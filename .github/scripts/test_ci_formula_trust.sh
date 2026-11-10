#!/usr/bin/env bash
set -euo pipefail
script="$(cd "$(dirname "$0")" && pwd)/trust_ci_formula.sh"
fixture_root="$(mktemp -d)"
trap 'rm -rf "$fixture_root"' EXIT

new_fixture() {
  case_root="${fixture_root}/$1"
  mkdir -p "${case_root}/source/Formula" "${case_root}/bin"
  printf '# Dalo fixture\n' > "${case_root}/source/Formula/dalo.rb"
  printf '# mdtheme fixture\n' > "${case_root}/source/Formula/mdtheme.rb"
  git -C "${case_root}/source" init -q
  git -C "${case_root}/source" add Formula
  git -C "${case_root}/source" -c core.hooksPath=/dev/null -c commit.gpgsign=false \
    -c user.name=Fixture -c user.email=fixture@example.invalid commit -qm fixture
  git clone -q "file://${case_root}/source" "${case_root}/tap"
  cat > "${case_root}/bin/brew" <<'BREW'
#!/usr/bin/env bash
set -eu
case "$1" in
  --repo) printf '%s\n' "$TEST_TAP_ROOT" ;;
  trust) printf '%s\n' "$*" >> "$TEST_TRUST_LOG" ;;
  *) exit 2 ;;
esac
BREW
  chmod +x "${case_root}/bin/brew"
  export GITHUB_REPOSITORY=sebastian-software/homebrew-tap
  export GITHUB_WORKSPACE="${case_root}/source"
  export GITHUB_SHA="$(git -C "$GITHUB_WORKSPACE" rev-parse HEAD)"
  export TEST_TAP_ROOT="${case_root}/tap" TEST_TRUST_LOG="${case_root}/trust.log"
}

run_helper() { PATH="${case_root}/bin:$PATH" bash "$script" "$@"; }
reject() {
  if run_helper "$@" > "${case_root}/rejection.log" 2>&1; then
    echo "Unexpected trust in ${case_root}" >&2
    exit 1
  fi
  test ! -e "$TEST_TRUST_LOG"
}

new_fixture canonical
run_helper dalo
run_helper mdtheme
printf '%s\n' 'trust --formula sebastian-software/tap/dalo' \
  'trust --formula sebastian-software/tap/mdtheme' > "${case_root}/expected.log"
cmp "${case_root}/expected.log" "$TEST_TRUST_LOG"

new_fixture local-release-commit
printf '# updated release\n' >> "${GITHUB_WORKSPACE}/Formula/dalo.rb"
git -C "$GITHUB_WORKSPACE" add Formula/dalo.rb
git -C "$GITHUB_WORKSPACE" -c core.hooksPath=/dev/null -c commit.gpgsign=false \
  -c user.name=Fixture -c user.email=fixture@example.invalid commit -qm update
git -C "$TEST_TAP_ROOT" fetch -q origin
git -C "$TEST_TAP_ROOT" checkout -q --detach FETCH_HEAD
run_helper dalo
test "$(cat "$TEST_TRUST_LOG")" = 'trust --formula sebastian-software/tap/dalo'

new_fixture uncommitted-source
printf '# uncommitted\n' >> "${GITHUB_WORKSPACE}/Formula/dalo.rb"
reject dalo

new_fixture wrong-origin
git -C "$TEST_TAP_ROOT" remote set-url origin https://github.com/other/tap
reject dalo

new_fixture wrong-head
printf '# another commit\n' > "${TEST_TAP_ROOT}/other"
git -C "$TEST_TAP_ROOT" add other
git -C "$TEST_TAP_ROOT" -c core.hooksPath=/dev/null -c commit.gpgsign=false \
  -c user.name=Fixture -c user.email=fixture@example.invalid commit -qm other
reject dalo

new_fixture changed-formula
printf '# unreviewed\n' >> "${TEST_TAP_ROOT}/Formula/dalo.rb"
reject dalo

new_fixture unrelated-run
GITHUB_SHA=0000000000000000000000000000000000000000
reject dalo

new_fixture unknown-formula
reject other

new_fixture wrong-repository
GITHUB_REPOSITORY=other/tap
reject dalo

printf 'Formula trust boundaries passed: canonical formula/local-release grants and seven pre-trust rejections.\n'
