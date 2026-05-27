#!/usr/bin/env bash
# Changelog fragment numbers are unique. (CRITICAL)
# Every changelog/<NN>-<slug>.md must carry a distinct <NN> prefix — the README convention is "one
# greater than the highest already used". A collision means two in-flight PRs picked the same number.
# Fix: renumber the later fragment to the next free NN (see changelog/README.md).
set -euo pipefail
# shellcheck source=tests/gates/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "${REPO_ROOT}"

dupes="$(
  for f in changelog/[0-9][0-9]-*.md; do
    [ -e "$f" ] || continue
    b="$(basename -- "$f")"
    printf '%s\n' "${b%%-*}"
  done | sort | uniq -d
)"

if [ -n "${dupes}" ]; then
  while IFS= read -r n; do
    [ -n "$n" ] || continue
    echo "FAIL: duplicate fragment number '${n}' — $(printf '%s ' changelog/"${n}"-*.md)"
  done <<EOF
${dupes}
EOF
  echo "  fix: renumber the later fragment to the next free NN (see changelog/README.md)"
  exit 1
fi

echo "changelog-fragment-unique: ok"
