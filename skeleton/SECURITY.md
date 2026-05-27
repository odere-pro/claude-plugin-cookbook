# Security policy

> REPLACE the trust-model bullets with your plugin's actual surface; keep the reporting section.

`example-plugin` ships no network code and no compiled binaries — its moving parts are Markdown
instructions, JSON manifests, and a few Bash scripts.

## Trust model

- REPLACE ME: name the one privileged thing the plugin does (e.g. a hook that writes files, a skill
  that runs a command) and the guard that fences it.
- No network on the hot path: no shipped hook or script calls `curl` / `wget` or fetches a remote
  package. (A gate can enforce this — see the cookbook's `14-supply-chain-and-governance`.)
- No secrets in shipped files; paths are relative and use `${CLAUDE_PLUGIN_ROOT}`.

## Supported versions

| Version | Supported |
| ------- | --------- |
| 0.1.x   | ✅        |
| < 0.1   | ❌        |

## Reporting a vulnerability

Please report privately via **GitHub Security Advisories** —
`https://github.com/REPLACE-ME-owner/example-plugin/security/advisories/new` — rather than opening a
public issue. We aim to acknowledge within a few days and to fix or mitigate confirmed issues before
any public disclosure.
