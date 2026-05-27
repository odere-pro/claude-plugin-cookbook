#!/usr/bin/env bash
# Hook and skill scripts make no network calls (no curl/wget/remote npx). (CRITICAL)
# A hook fires on the hot path; fetching a remote payload there is the anti-pattern the cookbook
# warns against in 06-hooks. Scans the author hook, the skeleton's shipped hook, and skill scripts.
set -euo pipefail
# shellcheck source=tests/gates/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "${REPO_ROOT}"

remote_re='(\b(curl|wget)\b|npx[^[:space:]]*https?://)'
fail=0
while IFS= read -r f; do
  [ -n "$f" ] || continue
  if grep -nE "${remote_re}" "$f" >/dev/null 2>&1; then
    echo "FAIL: network call in ${f}:"
    grep -nE "${remote_re}" "$f" | sed 's/^/  /'
    fail=1
  fi
done < <(find skeleton/hooks .claude/hooks skills -type f -name '*.sh' 2>/dev/null | sort)

[ "${fail}" -eq 0 ] && echo "hooks-no-remote: ok" || exit 1
