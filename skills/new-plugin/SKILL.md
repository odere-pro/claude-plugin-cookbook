---
name: new-plugin
description: >-
  Use when the user asks to create, scaffold, or start a new Claude Code plugin. Copies the cookbook's
  validated skeleton into a new directory, fills in the manifest, validates --strict, and initializes a
  clean git history, then points at the cookbook chapters for deeper work.
disable-model-invocation: true
argument-hint: "[plugin-name]"
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(${CLAUDE_SKILL_DIR}/scripts/scaffold.sh:*), Bash(mv:*), Bash(rm:*)
---

# Scaffold a new plugin

Create a new, validated Claude Code plugin from the cookbook's `skeleton/`. The user invokes this with
`/plugin-cookbook:new-plugin <plugin-name>`; it never auto-fires.

## When to use

- The user runs `/plugin-cookbook:new-plugin <name>`, or asks to scaffold or start a new plugin.

## Input

- `$1` — the new plugin's name in kebab-case (for example `my-plugin`). If it is empty, ask for a name
  before touching the filesystem.

## Steps

1. **Resolve the name.** Take `NAME="$1"`; if it is empty, ask the user for one. You need not pre-check
   the format or for collisions — `init` (next step) enforces kebab-case and refuses to overwrite an
   existing `./$NAME` — but surface its error verbatim if it fails.

2. **Scaffold the validated starter.** Run the bundled script. It copies the skeleton (dotfiles
   included) to `./$NAME` after enforcing the name and overwrite guards. The starter already passes
   `claude plugin validate --strict`:

   ```bash
   "${CLAUDE_SKILL_DIR}/scripts/scaffold.sh" init "$NAME"
   ```

3. **Set the manifest** (`./$NAME/.claude-plugin/plugin.json`, see `02-manifest`): set `name` to
   `$NAME`, write a trigger-first `description` (lead with "Use when…"), and fill in `author`,
   `license`, and `keywords`. Keep `version` as the version of record. In
   `./$NAME/.claude-plugin/marketplace.json`, set the marketplace `name`, `owner`, and `description`,
   and the one plugin entry's `name` (it MUST equal `$NAME`) and `description`; do **not** add a
   `version` there.

4. **Shape the components.** For each component the user wants, rename the `example-*` placeholder and
   rewrite its `description` and body — skills (`04-skills`), commands (`03-commands`), agents
   (`05-subagents`), hooks (`06-hooks`), MCP (`08-mcp`). Delete the component directories they do not
   need. **By default delete `.mcp.json`** — it ships a placeholder MCP server that shows as failed in
   `/doctor`; keep it only if the plugin has a real server, and point `command` at it (`08-mcp`). Any
   side-effecting skill MUST set `disable-model-invocation: true`.

5. **Validate and commit.** Re-validate `--strict` and initialize a clean history
   (`13-repository-hygiene`) in one step. If validation fails the script stops before committing — fix
   every finding and re-run:

   ```bash
   "${CLAUDE_SKILL_DIR}/scripts/scaffold.sh" finalize "$NAME"
   ```

6. **Hand off.** Report that the plugin is at `./$NAME`, validated and committed. Point the user at the
   cookbook for next steps: the component chapters, hardening and gates (`10-validation-and-gates`), and
   distribution (`11-distribution-and-versioning`). The chapters ship alongside this skill under
   `${CLAUDE_PLUGIN_ROOT}/docs/cookbook/`.
