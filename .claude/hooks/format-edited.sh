#!/usr/bin/env bash
# PostToolUse hook: auto-format an edited Markdown/JSON file with the repo's prettier.
# Non-blocking — always exits 0 and skips quietly when anything it needs is missing.
set -euo pipefail

input="$(cat)"

command -v jq >/dev/null 2>&1 || exit 0
file="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')"
[ -n "$file" ] || exit 0
[ -f "$file" ] || exit 0

case "$file" in
  *.md | *.json | *.jsonc) ;;
  *) exit 0 ;;
esac

command -v bun >/dev/null 2>&1 || exit 0
bunx prettier --write "$file" >/dev/null 2>&1 || true
exit 0
