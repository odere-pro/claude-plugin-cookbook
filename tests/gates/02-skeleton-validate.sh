#!/usr/bin/env bash
# The shipped skeleton passes the built-in validator in strict mode.
# Skipped where the claude CLI is unavailable (e.g. CI without it installed).
set -euo pipefail
# shellcheck source=tests/gates/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "${REPO_ROOT}"

if ! have claude; then
  echo "skeleton-validate: SKIP (claude CLI not found)"
  exit 0
fi

if out="$(claude plugin validate skeleton --strict 2>&1)"; then
  echo "skeleton-validate: ok"
else
  echo "${out}"
  echo "FAIL: claude plugin validate skeleton --strict"
  exit 1
fi
