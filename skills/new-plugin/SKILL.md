---
name: new-plugin
description: >-
  Use when the user asks to create, scaffold, or start a new Claude Code plugin. Copies the cookbook's
  validated skeleton into a new directory, fills in the manifest, validates --strict, and initializes a
  clean git history, then points at the cookbook chapters for deeper work.
disable-model-invocation: true
argument-hint: "[plugin-name] [what it should do]"
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
- **The rest of the arguments** — a free-form description of what the plugin should do: its purpose
  and which components it needs ("a hook that lints markdown on save", "a skill plus a subagent for
  code review"). `$ARGUMENTS` holds the whole string; the intent is everything after the first token.
  Use it to write the manifest description (step 3) and to choose components (step 4) without asking.
  If it is empty, fall back to asking what the plugin should do.

## Steps

1. **Resolve the name and intent.** Take `NAME="$1"`; if it is empty, ask the user for one. You need
   not pre-check the format or for collisions — `init` (next step) enforces kebab-case and refuses to
   overwrite an existing `./$NAME` — but surface its error verbatim if it fails. Keep the rest of the
   arguments as the **intent**; if it is empty, ask the user what the plugin should do (purpose +
   components) before shaping anything.

2. **Scaffold the validated starter.** Run the bundled script. It copies the skeleton (dotfiles
   included) to `./$NAME` after enforcing the name and overwrite guards. The starter already passes
   `claude plugin validate --strict`:

   ```bash
   "${CLAUDE_SKILL_DIR}/scripts/scaffold.sh" init "$NAME"
   ```

3. **Set the manifest** (`./$NAME/.claude-plugin/plugin.json`, see `02-manifest`): set `name` to
   `$NAME`, write a trigger-first `description` (lead with "Use when…") **synthesized from the intent**,
   and fill in `author`, `license`, and `keywords`. Keep `version` as the version of record. In
   `./$NAME/.claude-plugin/marketplace.json`, set the marketplace `name`, `owner`, and `description`,
   and the one plugin entry's `name` (it MUST equal `$NAME`) and `description`; do **not** add a
   `version` there.

4. **Shape the components from the intent.** Map what the user described to components — "skill"/
   "command" → `skills/` or `commands/`, "agent"/"reviewer"/"worker" → `agents/`, "hook"/"on save"/
   "block" → `hooks/`, "MCP"/"server" → `.mcp.json` — then **keep and rename the `example-*`
   placeholders the intent implies and delete the rest**, without asking when the intent is clear.
   Rewrite each kept component's `description` and body — skills (`04-skills`), commands
   (`03-commands`), agents (`05-subagents`), hooks (`06-hooks`), MCP (`08-mcp`). **By default delete
   `.mcp.json`** — it ships a placeholder MCP server that shows as failed in `/doctor`; keep it only if
   the plugin has a real server, and point `command` at it (`08-mcp`). Any side-effecting skill MUST
   set `disable-model-invocation: true`. If the intent is ambiguous about a component, ask.

5. **Validate and commit.** Re-validate `--strict` and initialize a clean history
   (`13-repository-hygiene`) in one step. If validation fails the script stops before committing — fix
   every finding and re-run:

   ```bash
   "${CLAUDE_SKILL_DIR}/scripts/scaffold.sh" finalize "$NAME"
   ```

6. **Hand off.** Report that the plugin is at `./$NAME`, validated and committed. Flag the governance
   `REPLACE-ME` placeholders the user must fill — the owner in `.github/CODEOWNERS` and the README
   Scorecard badge, the advisory URL in `SECURITY.md`, the contact in `CODE_OF_CONDUCT.md`, and the
   Best-Practices id once registered (`14-supply-chain-and-governance`); note that the Scorecard and
   CodeQL workflows ship dormant until the repo is public. Then point the user at the cookbook for next
   steps: the component chapters, hardening and gates (`10-validation-and-gates`), distribution
   (`11-distribution-and-versioning`), and supply-chain/governance (`14-supply-chain-and-governance`).
   The chapters ship alongside this skill under `${CLAUDE_PLUGIN_ROOT}/docs/cookbook/`.
