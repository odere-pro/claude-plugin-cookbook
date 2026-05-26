# 01 · Anatomy and layout

> **Intent:** Name every recognized component, where it lives, and the path/variable rules that make
> a plugin loadable on any machine.
> **Reads-with:** `00-overview`, `02-manifest`, every component chapter (`03`–`08`).

## The standard layout

Components live at the **plugin root**. The `.claude-plugin/` directory holds _only_ the manifest.

```text
example-plugin/
├── .claude-plugin/
│   ├── plugin.json          # manifest (optional; only file in this dir)
│   └── marketplace.json     # single-plugin marketplace (when the repo IS the plugin)
├── skills/<name>/SKILL.md   # skills (+ supporting files)
├── commands/<name>.md       # flat-file skills (classic form)
├── agents/<name>.md         # subagents
├── hooks/hooks.json         # event hooks (+ scripts)
├── .mcp.json                # MCP servers
├── .claude/                 # AUTHOR-ONLY dev config — not a plugin component
└── CLAUDE.md                # AUTHOR-ONLY dev memory — not shipped context
```

> **MUST:** keep `commands/`, `agents/`, `skills/`, `hooks/` and the other component dirs at the
> root, never inside `.claude-plugin/`. The most common "plugin loads but components are missing"
> bug is components nested under `.claude-plugin/`.

## Every recognized component

The commonly-authored components have their own chapters. The rest are listed here so the inventory
is complete — reach for them only when you need them.

| Component     | Default location             | Purpose                                                 | Chapter         |
| ------------- | ---------------------------- | ------------------------------------------------------- | --------------- |
| Manifest      | `.claude-plugin/plugin.json` | Metadata + optional path overrides                      | `02`            |
| Skills        | `skills/<name>/SKILL.md`     | `/name` capabilities, you or Claude invoke              | `04`            |
| Commands      | `commands/<name>.md`         | Flat-file skills (classic form)                         | `03`            |
| Subagents     | `agents/<name>.md`           | Specialized workers Claude delegates to                 | `05`            |
| Hooks         | `hooks/hooks.json`           | Shell/HTTP/etc. handlers on lifecycle events            | `06`            |
| MCP servers   | `.mcp.json`                  | External tools/services over MCP                        | `08`            |
| Output styles | `output-styles/`             | Alternate response formats                              | (official docs) |
| Themes        | `themes/*.json`              | Color themes (experimental)                             | (official docs) |
| Monitors      | `monitors/monitors.json`     | Background watches (experimental)                       | (official docs) |
| LSP servers   | `.lsp.json`                  | Language-server code intelligence                       | (official docs) |
| Executables   | `bin/`                       | Binaries added to the Bash tool's `PATH`                | (official docs) |
| Settings      | `settings.json`              | Plugin default settings (`agent`, `subagentStatusLine`) | (official docs) |

Path-scoped **rules** (`.claude/rules/*.md` with `paths:`) are a _project/user_ memory feature, not
a plugin component — see `07-rules` for how a plugin ships scoped guidance instead.

## Path variables

Reference bundled files through these — never hardcode an absolute path. All three are substituted
inside skill/agent content, hook/monitor commands, and MCP/LSP configs, and exported to subprocesses.

| Variable                | Resolves to                                       | Use for                                  |
| ----------------------- | ------------------------------------------------- | ---------------------------------------- |
| `${CLAUDE_PLUGIN_ROOT}` | the plugin's install dir                          | scripts, configs bundled with the plugin |
| `${CLAUDE_PLUGIN_DATA}` | a persistent per-plugin dir that survives updates | caches, installed deps, generated state  |
| `${CLAUDE_PROJECT_DIR}` | the user's project root                           | project-local scripts/config             |

> `${CLAUDE_PLUGIN_ROOT}` **changes on every update** and the old dir is cleaned up after ~7 days —
> treat it as ephemeral, never write state there. Put durable state in `${CLAUDE_PLUGIN_DATA}`.

## Path rules and caching

- **MUST** make every path in any config relative and start with `./`.
- Marketplace plugins are **copied into a cache** (`~/.claude/plugins/cache`) at install. A plugin
  therefore **cannot** reference files outside its own directory (`../shared` will not resolve).
  Share files within a marketplace via symlinks; everything else is skipped for security.

## Namespacing

Plugin components are namespaced by the plugin `name`: a skill `review` in plugin `example-plugin`
is invoked as `/example-plugin:review`, and the subagent `example-agent` appears as
`example-plugin:example-agent`. Namespacing means your components never collide with the user's own
skills/agents or those of other plugins.
