#!/usr/bin/env bash
# No concrete secret-shaped tokens in shipped or author files. (CRITICAL)
# Targets real credential formats (OpenAI, GitHub PAT classic + fine-grained, AWS, Slack, PEM keys),
# not the pattern *descriptions* a doc might carry. `examples/` is excluded so demonstration fixtures
# can show a fake token without tripping the gate.
set -euo pipefail
# shellcheck source=tests/gates/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "${REPO_ROOT}"

targets=(skeleton skills docs .claude-plugin .github scripts changelog README.md CHANGELOG.md CONTRIBUTING.md SECURITY.md SUPPORT.md CODE_OF_CONDUCT.md)

# The pattern lives in a variable so this gate (under tests/gates/, not a target) never matches itself.
secret_re='(sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{50,}|AKIA[0-9A-Z]{16}|xox[baprs]-[A-Za-z0-9-]{12,}|-----BEGIN [A-Z ]*PRIVATE KEY-----)'

hits="$(grep -rnE "${secret_re}" "${targets[@]}" 2>/dev/null | grep -v '/examples/' || true)"
if [ -n "${hits}" ]; then
  echo "FAIL: possible secret(s) found:"
  printf '%s\n' "${hits}" | sed 's/^/  /'
  exit 1
fi
echo "secret-scan: ok"
