---
name: new-plugin
description: >-
  Use when the user asks to create, scaffold, or start a new Claude Code plugin. Copies the cookbook's
  validated skeleton into a new directory, fills in the manifest, validates --strict, and initializes a
  clean git history, then points at the cookbook chapters for deeper work.
disable-model-invocation: true
argument-hint: "[plugin-name]"
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
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

1. **Resolve the target.** Take `NAME="$1"` and require kebab-case (`^[a-z][a-z0-9-]*$`); if it is empty
   or invalid, ask the user for a valid name. The target is `./$NAME` — if that path already exists,
   stop and report it instead of overwriting.

2. **Copy the validated starter** — it already passes `claude plugin validate --strict`:

   ```bash
   cp -R "${CLAUDE_PLUGIN_ROOT}/skeleton" "./$NAME"
   ```

3. **Set the manifest** (`./$NAME/.claude-plugin/plugin.json`, see `02-manifest`): set `name` to
   `$NAME`, write a trigger-first `description` (lead with "Use when…"), and fill in `author`,
   `license`, and `keywords`. Keep `version` as the version of record. In
   `./$NAME/.claude-plugin/marketplace.json`, set the marketplace `name`, `owner`, and `description`,
   and the one plugin entry's `name` (it MUST equal `$NAME`) and `description`; do **not** add a
   `version` there.

4. **Shape the components.** For each component the user wants, rename the `example-*` placeholder and
   rewrite its `description` and body — skills (`04-skills`), commands (`03-commands`), agents
   (`05-subagents`), hooks (`06-hooks`), MCP (`08-mcp`). Delete the component directories (and
   `.mcp.json`) they do not need. Any side-effecting skill MUST set `disable-model-invocation: true`.

5. **Validate** and fix every finding before continuing:

   ```bash
   claude plugin validate "./$NAME" --strict
   ```

6. **Initialize a clean history** (`13-repository-hygiene`):

   ```bash
   (cd "./$NAME" && git init -q && git add -A && git commit -q -m "chore: scaffold repository")
   ```

7. **Hand off.** Report that the plugin is at `./$NAME`, validated and committed. Point the user at the
   cookbook for next steps: the component chapters, hardening and gates (`10-validation-and-gates`), and
   distribution (`11-distribution-and-versioning`). The chapters ship alongside this skill under
   `${CLAUDE_PLUGIN_ROOT}/docs/cookbook/`.
