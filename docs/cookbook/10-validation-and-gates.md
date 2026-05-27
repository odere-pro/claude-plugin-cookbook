# 10 · Validation and gates

> **Intent:** Prove a plugin is well-formed before you ship it — with the built-in validator first,
> then your own CI gates for the invariants the validator doesn't cover.
> **Reads-with:** `02-manifest`, `09-claude-md-and-author-config`.

## Start with the built-in validator

Claude Code ships a validator. Use it before every release:

```bash
claude plugin validate .            # manifest + component frontmatter + hooks.json
claude plugin validate . --strict   # treat warnings (e.g. missing description) as errors — for CI
```

Companion tools:

- `/plugin validate` — the same check, in-session.
- `claude --debug` — shows what loaded, with per-component registration and any errors.
- `claude plugin details <name>` — the always-on vs on-invoke **token cost** of each component.
- `/doctor` — flags ignored folders, failed MCP servers, and skill-budget overflow.

The `skeleton/` passes `claude plugin validate . --strict` with exit 0 — start from a green baseline.

## The well-formed-plugin invariants

These are the universal checks every plugin should satisfy. The validator catches most; the rest are
worth a CI gate:

| Invariant                                                   | Why                                                             |
| ----------------------------------------------------------- | --------------------------------------------------------------- |
| Every shipped `*.json` parses                               | a typo in `plugin.json`/`hooks.json`/`.mcp.json` breaks loading |
| `marketplace.json` entry `name` matches `plugin.json`       | install resolves the wrong thing otherwise                      |
| Every `SKILL.md`/agent/command has a `description`          | no `description`, no routing                                    |
| All config paths are relative and start with `./`           | absolute paths break after the cache copy                       |
| Hook scripts are executable and use `${CLAUDE_PLUGIN_ROOT}` | otherwise the hook silently no-ops                              |
| No `/Users/…`, `/home/…` in shipped files                   | a leaked machine path                                           |
| No token-shaped secrets in shipped files                    | a leaked credential                                             |

## The hardening invariants (house rules)

Beyond "loads correctly," a disciplined plugin enforces conventions the platform leaves optional.
These mirror the calibration plugin's gate suite — adopt the ones that fit:

| Gate                                                                    | Protects                                        |
| ----------------------------------------------------------------------- | ----------------------------------------------- |
| Skills are `disable-model-invocation: true` (unless meant to auto-fire) | no skill auto-fires a side effect               |
| Agents declare `tools` explicitly                                       | least privilege; no accidental tool inheritance |
| Rules carry `paths:`                                                    | a scoped rule, not an always-on one             |
| Hooks contain no `curl`/`wget`/remote `npx`                             | no network on the hot path                      |
| No token-shaped secrets in tracked files                                | a leaked credential                             |
| `CHANGELOG.md` has the current `plugin.json` version                    | version/changelog drift                         |
| A changelog fragment present per non-doc PR, uniquely numbered          | concurrent PRs never collide on the changelog   |

The last three are realized in this repo as `tests/gates/07-secret-scan.sh`,
`tests/gates/09-changelog-version.sh`, and `tests/gates/10-changelog-fragment-present.sh` /
`tests/gates/11-changelog-fragment-unique.sh`. The fragment gates and the supply-chain checks they pair
with (Scorecard, CodeQL, release provenance) are covered in `14-supply-chain-and-governance`.

## A CI gate pattern

Keep gates as small, standalone scripts under `tests/` with a `run-all.sh` runner, each printing
`ok` or `FAIL` and exiting non-zero on failure. This repo's own `tests/gates/` is the worked example:
numbered scripts (`tests/gates/01-json-parses.sh`, `tests/gates/05-doc-links.sh`,
`tests/gates/07-secret-scan.sh`, `tests/gates/10-changelog-fragment-present.sh`, …) sharing a `lib.sh`
that locates the repo root; `run-all.sh` discovers them by filename, so a new gate is just a new
`NN-*.sh`. A representative gate:

```bash
#!/usr/bin/env bash
# every SKILL.md has name + description
set -euo pipefail
fail=0
while IFS= read -r f; do
  grep -qE '^description:[[:space:]]*\S' "$f" || { echo "FAIL: no description in $f"; fail=1; }
done < <(find skills -name SKILL.md | sort)
[ "$fail" -eq 0 ] && echo "skill-frontmatter: ok" || exit 1
```

Wire `tests/` to run in `.github/workflows/`. These scripts live in the **author-only** zone
(`09-claude-md-and-author-config`) — they validate the plugin but never ship as part of it.
