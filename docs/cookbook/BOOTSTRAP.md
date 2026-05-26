# Bootstrap playbook: create a Claude Code plugin

> **Intent:** An imperative, agent-followable procedure for turning a plain repository into a
> plugin-development repo. Drop this package into a repo and tell Claude "follow the cookbook
> `BOOTSTRAP.md` to scaffold a plugin," or run it by hand.
> **Reads-with:** [`README.md`](README.md), [`09-claude-md-and-author-config`](09-claude-md-and-author-config.md), the chapter cited in each step.

> **The playbook vs. `skeleton/CLAUDE.md`, don't confuse them.** _This_ file (`BOOTSTRAP.md`) is the
> **playbook**. It is part of the cookbook, not part of your plugin. `skeleton/CLAUDE.md` is the
> **template** this playbook installs as your new repo's project memory. Step 3 makes the swap.

> **Shortcut:** if you have installed the cookbook as a plugin, `/plugin-cookbook:new-plugin <name>`
> runs this whole playbook for you (see [`SOFTWARE-3-0`](SOFTWARE-3-0.md)).

Work top to bottom. Each phase names the concrete file it touches and the chapter that explains it.

## Phase 0 — Decide the shape

Answer three questions before touching files:

- **Name** (kebab-case): becomes the namespace `<name>:<component>`.
- **Components you actually need**: which of skills / commands / agents / hooks / MCP? Keep those,
  delete the rest. Don't ship empty dirs.
- **Distribution**: a single-plugin repo (marketplace `source: "./"`) or one plugin in a larger
  catalog? ([`11-distribution-and-versioning`](11-distribution-and-versioning.md))

## Phase 1 — Scaffold

1. Copy [`skeleton/`](../../skeleton/) into the target repo root (it already passes
   `claude plugin validate --strict`).
2. Edit `.claude-plugin/plugin.json`: set `name`, `description` (lead with triggers), `author`,
   `license`, `keywords`. Keep `version` here as the version of record. ([`02-manifest`](02-manifest.md))
3. Edit `.claude-plugin/marketplace.json`: set marketplace `name`, `owner`, `description`, and the
   one plugin entry's `name`/`description`. **Do not** add `version` here. ([`02-manifest`](02-manifest.md))
4. For each component you keep, rename the `example-*` placeholder and rewrite its `description` and
   body:
   - skills → [`04-skills`](04-skills.md) · commands → [`03-commands`](03-commands.md) ·
     agents → [`05-subagents`](05-subagents.md) · hooks → [`06-hooks`](06-hooks.md) ·
     MCP → [`08-mcp`](08-mcp.md)
5. Delete the component directories (and `.mcp.json`) you don't need.

## Phase 2 — Override `.claude/` (author config)

This is where the repo becomes a _plugin-development_ repo, not just a plugin. ([`09-claude-md-and-author-config`](09-claude-md-and-author-config.md), [`07-rules`](07-rules.md))

1. Keep `skeleton/.claude/rules/plugin-dev.md`; tighten its `paths:` and house rules to the
   components you kept. These are author-only and never ship.
2. Add any maintenance skills/agents you want _while developing_ under `.claude/` — they are not
   plugin components and won't load for users.
3. Add `tests/` gates and a `.github/` workflow if you want CI enforcement. ([`10-validation-and-gates`](10-validation-and-gates.md))

## Phase 3 — Override `CLAUDE.md` (project memory)

1. Install `skeleton/CLAUDE.md` as the repo's **root** `CLAUDE.md` (replacing this playbook in the
   target repo — the playbook stays in the cookbook package, not in your plugin).
2. Edit it down to your plugin: the "what ships / what doesn't" inventory, the source-layout table,
   the gate map, and a "where to read before editing" pointer.
3. Remember: this file is **dev memory**, never loaded for end users. Anything users must see goes in
   a skill. ([`09-claude-md-and-author-config`](09-claude-md-and-author-config.md))

## Phase 4 — Validate and load

```bash
claude plugin validate . --strict     # manifest + frontmatter + hooks.json; fix every finding
claude --plugin-dir .                  # load against this repo
#   in-session:
/reload-plugins                        # pick up edits
/<your-plugin>:<your-skill>            # invoke a component to smoke-test
claude plugin details <your-plugin>    # check the always-on token cost
```

Green `validate --strict` + a component that fires = a well-formed plugin. Iterate from there, and
re-run `validate` before every release. ([`10-validation-and-gates`](10-validation-and-gates.md), [`11-distribution-and-versioning`](11-distribution-and-versioning.md))

## Done-when

- [ ] `claude plugin validate . --strict` exits 0.
- [ ] Each kept component has a trigger-first `description`; side-effecting skills set `disable-model-invocation: true`.
- [ ] No absolute machine paths and no secrets in any shipped file; hook scripts are `chmod +x` and use `${CLAUDE_PLUGIN_ROOT}`.
- [ ] Root `CLAUDE.md` describes the repo for developers; nothing user-facing depends on it.
- [ ] `plugin.json` owns `version`; `marketplace.json` does not repeat it.
