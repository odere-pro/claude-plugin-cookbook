#!/usr/bin/env bash
# Both plugins in this repo pass the built-in validator in strict mode:
# the root plugin (plugin-cookbook) and the skeleton starter.
# Skipped where the claude CLI is unavailable (e.g. CI without it installed).
set -euo pipefail
# shellcheck source=tests/gates/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "${REPO_ROOT}"

if ! have claude; then
  echo "plugin-validate: SKIP (claude CLI not found)"
  exit 0
fi

fail=0
for target in . skeleton; do
  if out="$(claude plugin validate "$target" --strict 2>&1)"; then
    echo "plugin-validate (${target}): ok"
  else
    echo "${out}"
    echo "FAIL: claude plugin validate ${target} --strict"
    fail=1
  fi
done

[ "${fail}" -eq 0 ] || exit 1
