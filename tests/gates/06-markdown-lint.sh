#!/usr/bin/env bash
# Markdown lints clean (markdownlint-cli2) and is prettier-formatted (--check).
# Skipped where bun is unavailable.
set -euo pipefail
# shellcheck source=tests/gates/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "${REPO_ROOT}"

if ! have bun; then
  echo "markdown-lint: SKIP (bun not found)"
  exit 0
fi

log="$(mktemp)"
trap 'rm -f "${log}"' EXIT

if bun run lint:md >"${log}" 2>&1 && bun run format:check >>"${log}" 2>&1; then
  echo "markdown-lint: ok"
else
  cat "${log}"
  echo "FAIL: markdown lint or prettier check"
  exit 1
fi
