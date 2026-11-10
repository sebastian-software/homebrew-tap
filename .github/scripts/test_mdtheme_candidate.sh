#!/usr/bin/env bash
set -euo pipefail
scripts="$(cd "$(dirname "$0")" && pwd)"
fixture_root="$(mktemp -d)"
trap 'rm -rf "$fixture_root"' EXIT

new_fixture() {
  case_root="$fixture_root/$1"
  mkdir -p "$case_root/source/Formula" "$case_root/source/.github/scripts" "$case_root/bin" "$case_root/prefix/bin"
  cp "$scripts/prepare_mdtheme_candidate.sh" "$scripts/verify_mdtheme_candidate.sh" "$scripts/trust_ci_formula.sh" "$case_root/source/.github/scripts/"
  printf 'old committed formula\n' > "$case_root/source/Formula/mdtheme.rb"
  git -C "$case_root/source" init -q
  git -C "$case_root/source" config commit.gpgsign false
  git -C "$case_root/source" config core.hooksPath /dev/null
  git -C "$case_root/source" add -- Formula/mdtheme.rb .github/scripts
  git -C "$case_root/source" -c user.name=Fixture -c user.email=fixture@example.invalid -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -qm old
  export GITHUB_REPOSITORY=sebastian-software/homebrew-tap GITHUB_WORKSPACE="$case_root/source"
  export GITHUB_SHA="$(git -C "$GITHUB_WORKSPACE" rev-parse HEAD)" GITHUB_OUTPUT="$case_root/output"
  export TEST_TAP_ROOT="$case_root/tap" TEST_BREW_LOG="$case_root/brew.log" TEST_PREFIX="$case_root/prefix"
  printf 'new release candidate\n' > "$case_root/candidate"
  cp "$case_root/candidate" "$GITHUB_WORKSPACE/Formula/mdtheme.rb"
  cat > "$case_root/bin/brew" <<'BREW'
#!/usr/bin/env bash
set -eu
case "$1" in
  --repo) printf '%s\n' "$TEST_TAP_ROOT" ;;
  --prefix) printf '%s\n' "$TEST_PREFIX" ;;
  trust|style|audit|install|test)
    cmp "$GITHUB_WORKSPACE/Formula/mdtheme.rb" "$TEST_TAP_ROOT/Formula/mdtheme.rb"
    printf '%s\n' "$*" >> "$TEST_BREW_LOG" ;;
  *) exit 2 ;;
esac
BREW
  printf '#!/bin/sh\nprintf "%%s\\n" "${TEST_VERSION:-0.5.0}"\n' > "$TEST_PREFIX/bin/mdtheme"
  chmod +x "$case_root/bin/brew" "$TEST_PREFIX/bin/mdtheme"
}
prepare() {
  bash "$scripts/prepare_mdtheme_candidate.sh" mdtheme-v0.5.0
  source "$GITHUB_OUTPUT"
  git clone -q "file://$GITHUB_WORKSPACE" "$TEST_TAP_ROOT"
}
verify() { PATH="$case_root/bin:$PATH" bash "$scripts/verify_mdtheme_candidate.sh" mdtheme-v0.5.0 "$formula_sha" "$candidate_head"; }

new_fixture candidate
prepare
verify
cmp "$case_root/candidate" "$TEST_TAP_ROOT/Formula/mdtheme.rb"
cmp "$case_root/candidate" "$GITHUB_WORKSPACE/verified/mdtheme.rb"
test "$(git -C "$TEST_TAP_ROOT" rev-parse HEAD)" = "$candidate_head"
test "$(head -1 "$TEST_BREW_LOG")" = 'trust --formula sebastian-software/tap/mdtheme'
grep -Fx 'audit --strict --online sebastian-software/tap/mdtheme' "$TEST_BREW_LOG"
grep -Fx 'install sebastian-software/tap/mdtheme' "$TEST_BREW_LOG"
grep -Fx 'test sebastian-software/tap/mdtheme' "$TEST_BREW_LOG"
# A repeated download of the candidate remains a no-op under the workflow gate.
git -C "$GITHUB_WORKSPACE" diff --quiet -- Formula/mdtheme.rb

new_fixture old-clone
# Reproduce the original defect: clone the old commit before preparing the candidate.
git clone -q "file://$GITHUB_WORKSPACE" "$TEST_TAP_ROOT"
bash "$scripts/prepare_mdtheme_candidate.sh" mdtheme-v0.5.0
source "$GITHUB_OUTPUT"
if verify; then echo 'Old clone unexpectedly passed' >&2; exit 1; fi
test ! -e "$TEST_BREW_LOG"
test ! -e "$GITHUB_WORKSPACE/verified/mdtheme.rb"

new_fixture changed-bytes
prepare
printf 'changed after commit\n' >> "$TEST_TAP_ROOT/Formula/mdtheme.rb"
if verify; then echo 'Modified tap unexpectedly passed' >&2; exit 1; fi
test ! -e "$TEST_BREW_LOG"

new_fixture old-installed-version
prepare
if TEST_VERSION=0.4.0 verify; then echo 'Old installed version unexpectedly passed' >&2; exit 1; fi
test ! -e "$GITHUB_WORKSPACE/verified/mdtheme.rb"

new_fixture foreign-stage
printf 'foreign\n' > "$GITHUB_WORKSPACE/Formula/other.rb"
git -C "$GITHUB_WORKSPACE" add -- Formula/other.rb
if bash "$scripts/prepare_mdtheme_candidate.sh" mdtheme-v0.5.0; then echo 'Foreign staged file unexpectedly committed' >&2; exit 1; fi
test "$(git -C "$GITHUB_WORKSPACE" rev-parse HEAD)" = "$GITHUB_SHA"
printf 'mdtheme candidate identity, validation, upload bytes, no-op, and rejection checks passed.\n'
