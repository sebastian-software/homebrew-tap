#!/usr/bin/env bash
# Validate and save the exact formula cloned from the local candidate commit.
set -euo pipefail
[[ ${1:-} =~ ^mdtheme-v[0-9]+\.[0-9]+\.[0-9]+$ ]]
expected_sha="${2:?}"
expected_head="${3:?}"
workspace="${GITHUB_WORKSPACE:?}"
test "$(git -C "$workspace" rev-parse HEAD)" = "$expected_head"
test "$(shasum -a 256 "$workspace/Formula/mdtheme.rb" | cut -d ' ' -f 1)" = "$expected_sha"
bash "$workspace/.github/scripts/trust_ci_formula.sh" mdtheme
tap_root="$(brew --repo sebastian-software/tap)"
brew style "$tap_root/Formula/mdtheme.rb"
brew audit --strict --online sebastian-software/tap/mdtheme
brew install sebastian-software/tap/mdtheme
brew test sebastian-software/tap/mdtheme
test "$("$(brew --prefix sebastian-software/tap/mdtheme)/bin/mdtheme" --version)" = "${1#mdtheme-v}"
# Detect changes made during validation before choosing the uploaded bytes.
test "$(git -C "$workspace" rev-parse HEAD)" = "$expected_head"
git -C "$workspace" diff --quiet HEAD -- Formula/mdtheme.rb
cmp "$workspace/Formula/mdtheme.rb" "$tap_root/Formula/mdtheme.rb"
test "$(shasum -a 256 "$tap_root/Formula/mdtheme.rb" | cut -d ' ' -f 1)" = "$expected_sha"
mkdir -p "$workspace/verified"
cp "$tap_root/Formula/mdtheme.rb" "$workspace/verified/mdtheme.rb"
