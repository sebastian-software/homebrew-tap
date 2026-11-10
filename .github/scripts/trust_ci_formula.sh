#!/usr/bin/env bash
# Grant only the reviewed formula's trust after checking the local CI tap source.
set -euo pipefail

if [[ $# != 1 ]]; then
  echo 'Usage: trust_ci_formula.sh dalo|mdtheme' >&2
  exit 1
fi
case "$1" in
  dalo|mdtheme) formula="$1" ;;
  *) echo 'Only the explicitly reviewed CI formulae may be trusted.' >&2; exit 1 ;;
esac

test "${GITHUB_REPOSITORY:?}" = 'sebastian-software/homebrew-tap'
workspace="${GITHUB_WORKSPACE:?}"
source_head="$(git -C "$workspace" rev-parse HEAD)"
# The release updater adds a local formula commit; it must descend from this run.
git -C "$workspace" merge-base --is-ancestor "${GITHUB_SHA:?}" "$source_head"
test "$(git -C "$workspace" rev-parse --show-toplevel)" = "$(cd "$workspace" && pwd -P)"
git -C "$workspace" diff --quiet HEAD -- "Formula/${formula}.rb"

tap_root="$(brew --repo sebastian-software/tap)"
test "$(git -C "$tap_root" remote get-url origin)" = "file://${workspace}"
test "$(git -C "$tap_root" rev-parse HEAD)" = "$source_head"
cmp "${workspace}/Formula/${formula}.rb" "${tap_root}/Formula/${formula}.rb"

# A tap contains executable Ruby. Never trust the whole tap or disable its gate.
brew trust --formula "sebastian-software/tap/${formula}"
