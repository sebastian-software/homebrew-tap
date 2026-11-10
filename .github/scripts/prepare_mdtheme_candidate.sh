#!/usr/bin/env bash
# Make the generated formula the exact source cloned by Homebrew.
set -euo pipefail
[[ ${1:-} =~ ^mdtheme-v[0-9]+\.[0-9]+\.[0-9]+$ ]]
test "${GITHUB_REPOSITORY:?}" = sebastian-software/homebrew-tap
workspace="${GITHUB_WORKSPACE:?}"
test "$(git -C "$workspace" rev-parse HEAD)" = "${GITHUB_SHA:?}"
test -z "$(git -C "$workspace" diff --cached --name-only)"
test "$(git -C "$workspace" diff --name-only)" = Formula/mdtheme.rb
# Explicit paths keep other formulae outside this candidate commit.
git -C "$workspace" add -- Formula/mdtheme.rb
test "$(git -C "$workspace" diff --cached --name-only)" = Formula/mdtheme.rb
git -C "$workspace" -c user.name='github-actions[bot]' \
  -c user.email='41898282+github-actions[bot]@users.noreply.github.com' \
  commit -m "Update verified mdtheme to ${1#mdtheme-v}" -- Formula/mdtheme.rb
printf 'candidate_head=%s\n' "$(git -C "$workspace" rev-parse HEAD)" >> "${GITHUB_OUTPUT:?}"
printf 'formula_sha=%s\n' "$(shasum -a 256 "$workspace/Formula/mdtheme.rb" | cut -d ' ' -f 1)" >> "$GITHUB_OUTPUT"
