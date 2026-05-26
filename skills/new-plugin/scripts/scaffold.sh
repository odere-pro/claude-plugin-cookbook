#!/usr/bin/env bash
# scaffold.sh — deterministic file mechanics for the new-plugin skill.
#
# The judgment steps (manifest text, which components to keep, whether to keep
# .mcp.json) stay in the SKILL.md prose. This script owns only the reproducible
# file operations, so they behave identically on every machine the plugin is
# installed on. Two subcommands bracket the prose steps:
#
#   scaffold.sh init <name>
#     Require a kebab-case <name>, refuse to overwrite an existing ./<name>, and
#     copy the validated skeleton (dotfiles included) to ./<name>.
#
#   scaffold.sh finalize <name>
#     Re-validate ./<name> --strict, then initialize a clean git history. If
#     validation fails it stops before committing.
#
# The shipped skeleton is found via ${CLAUDE_PLUGIN_ROOT}; if that is not exported
# the plugin root is derived from this script's own location (three levels up from
# skills/new-plugin/scripts/), so the script is self-locating either way.
set -euo pipefail

plugin_root="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/../../.." && pwd)}"

die() {
  printf 'scaffold: %s\n' "$1" >&2
  exit 1
}

init() {
  name="${1:-}"
  [ -n "$name" ] || die "missing plugin name — usage: scaffold.sh init <name>"
  printf '%s' "$name" | grep -Eq '^[a-z][a-z0-9-]*$' \
    || die "invalid name '$name' — use kebab-case, for example my-plugin"
  [ ! -e "./$name" ] || die "./$name already exists — refusing to overwrite"

  skeleton="$plugin_root/skeleton"
  [ -d "$skeleton" ] || die "skeleton not found at $skeleton"

  cp -R "$skeleton" "./$name"
  printf 'scaffold: created ./%s from the validated skeleton\n' "$name"
}

finalize() {
  name="${1:-}"
  [ -n "$name" ] || die "missing plugin name — usage: scaffold.sh finalize <name>"
  [ -d "./$name" ] || die "./$name not found — run 'scaffold.sh init $name' first"

  claude plugin validate "./$name" --strict
  (
    cd "./$name" || die "cannot enter ./$name"
    git init -q
    git add -A
    git commit -q -m "chore: scaffold repository"
  )
  printf 'scaffold: validated ./%s --strict and committed a clean history\n' "$name"
}

case "${1:-}" in
init) init "${2:-}" ;;
finalize) finalize "${2:-}" ;;
*) die "usage: scaffold.sh {init <name>|finalize <name>}" ;;
esac
