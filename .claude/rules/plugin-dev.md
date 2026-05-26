---
description: >-
  House rules for developing this repo's own plugin (plugin-cookbook) and its gates. Author-only —
  lives under .claude/ and is never shipped. Path-scoped to the plugin components and tests.
paths:
  - ".claude-plugin/**"
  - "skills/**"
  - "hooks/**"
  - "tests/gates/**"
---

# Plugin-dev house rules

## Quality

- A skill's `description` leads with the trigger ("Use when…"); keep description + when_to_use within
  the 1,536-char routing budget.
- A side-effecting skill MUST set `disable-model-invocation: true` (the `new-plugin` skill scaffolds
  files, so it does).
- Keep both the root plugin and `skeleton/` `claude plugin validate --strict`-clean.

## Security

- No secrets or tokens in any tracked file; no `/Users/…` or `/home/…` machine paths.
- Hooks stay local and fast: no `curl` / `wget` / remote `npx` on the hot path.
- Any agent declares `tools` explicitly (least privilege) and never sets `hooks`, `mcpServers`, or
  `permissionMode` in a shipped agent.

## Accuracy

- Paths in any config are relative and start with `./`; reference plugin files via
  `${CLAUDE_PLUGIN_ROOT}` and persistent state via `${CLAUDE_PLUGIN_DATA}`.
- `plugin.json` is the version of record; `marketplace.json` does not repeat the version.
- Run `bash tests/gates/run-all.sh` before committing — every gate must pass.
