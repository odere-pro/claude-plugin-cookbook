#!/usr/bin/env bash
# Documentation integrity:
#   1. every relative Markdown link target (file or dir) resolves;
#   2. every `NN-stem` chapter cross-reference has a docs/cookbook/NN-stem.md.
set -euo pipefail
# shellcheck source=tests/gates/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "${REPO_ROOT}"

broken="$(mktemp)"
trap 'rm -f "${broken}"' EXIT

while IFS= read -r md; do
  dir="$(dirname "$md")"
  # Strip fenced code blocks: example links/stems inside them are illustrative.
  prose="$(awk '/^```/{f=!f; next} !f' "$md")"

  # 1. relative link targets
  while IFS= read -r target; do
    case "$target" in
      http://* | https://* | mailto:* | '#'*) continue ;;
    esac
    path="${target%%#*}"   # drop any #anchor
    [ -z "$path" ] && continue
    [ -e "${dir}/${path}" ] || echo "${md}: broken link -> ${target}" >>"${broken}"
  done < <(printf '%s\n' "$prose" | grep -oE '\]\([^)]+\)' | sed -E 's/^\]\(//; s/\)$//')

  # 2. `NN-stem` chapter references (e.g. `04-skills`)
  while IFS= read -r stem; do
    [ -e "docs/cookbook/${stem}.md" ] \
      || echo "${md}: references \`${stem}\` but docs/cookbook/${stem}.md is missing" >>"${broken}"
  done < <(printf '%s\n' "$prose" | grep -oE '`[0-9]{2}-[a-z0-9-]+`' | tr -d '`' | sort -u)
done < <(git ls-files '*.md')

if [ -s "${broken}" ]; then
  echo "FAIL: documentation links:"
  cat "${broken}"
  exit 1
fi
echo "doc-links: ok"
