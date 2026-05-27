#!/usr/bin/env bash
# Governance vocabulary is defined in the glossary. (CRITICAL)
# 12-glossary is authoritative for terms (cookbook authoring rule); each governance term the cookbook
# introduces in 14-supply-chain-and-governance MUST have a bold **term** entry there, so the prose and
# the glossary cannot drift. This is the simplified cookbook variant of calibration's glossary gate —
# a term presence check, not a full power-words/forbidden-terms scan.
set -euo pipefail
# shellcheck source=tests/gates/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "${REPO_ROOT}"

glossary="docs/cookbook/12-glossary.md"
if [ ! -f "${glossary}" ]; then
  echo "FAIL: missing ${glossary}"
  exit 1
fi

terms=(
  "OpenSSF Scorecard"
  "OpenSSF Best Practices"
  "SLSA provenance"
  "CodeQL"
  "Dependabot"
  "CODEOWNERS"
  "Changelog fragment"
  "Pinned action SHA"
)

fail=0
for t in "${terms[@]}"; do
  grep -qiF -- "**${t}**" "${glossary}" \
    || { echo "FAIL: '${t}' is not defined (**${t}**) in ${glossary}"; fail=1; }
done

[ "${fail}" -eq 0 ] && echo "glossary-consistency: ok" || exit 1
