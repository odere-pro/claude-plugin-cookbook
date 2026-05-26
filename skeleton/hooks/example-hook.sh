#!/usr/bin/env bash
# example-hook.sh — a PostToolUse hook wired on Write|Edit (see hooks.json).
#
# Claude Code passes the hook event as JSON on stdin. This example reads it, notes which file was
# touched, and exits 0 (non-blocking). Swap in your own logic, or delete the hooks/ directory.
#
# Exit codes:
#   0 — allow / no-op. PostToolUse output is advisory.
#   2 — in a *PreToolUse* hook, exit 2 BLOCKS the tool call and feeds stderr back to Claude. This
#       example is PostToolUse and never blocks; see ../../06-hooks.md for the write-guard pattern.
#
# No network on the hot path: a hook runs on every matching tool call, so keep it fast and local.
set -u

input="$(cat 2>/dev/null || true)"
[ -z "$input" ] && exit 0

path=""
if command -v jq >/dev/null 2>&1; then
  path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"
fi

printf '[example-plugin] PostToolUse on %s\n' "${path:-<unknown>}" >&2
exit 0
