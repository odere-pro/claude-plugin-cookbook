#!/usr/bin/env bash
# Shipped scripts (hooks, skill scripts) and the gate scripts themselves stay
# clean under shellcheck at error level.
set -euo pipefail
# shellcheck source=tests/gates/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "${REPO_ROOT}"

if ! have shellcheck; then
  echo "shellcheck: SKIP (shellcheck not found)"
  exit 0
fi

scripts=()
while IFS= read -r s; do scripts+=("$s"); done \
  < <(find skeleton/hooks .claude/hooks skills tests/gates -name '*.sh' 2>/dev/null | sort)
if shellcheck -S error "${scripts[@]}"; then
  echo "shellcheck: ok"
else
  echo "FAIL: shellcheck reported errors"
  exit 1
fi
