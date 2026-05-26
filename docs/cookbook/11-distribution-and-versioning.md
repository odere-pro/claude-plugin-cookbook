# 11 · Distribution and versioning

> **Intent:** Take the plugin from "loads on my machine" to "installed by others," and version it so
> updates reach users predictably.
> **Reads-with:** `02-manifest`, `10-validation-and-gates`.

## Local development loop

```bash
claude --plugin-dir /path/to/plugin     # load the plugin for this session
# then, in-session:
/reload-plugins                          # pick up edits without restarting
```

`--plugin-dir` loads the plugin in place (no cache copy), so it's the fast inner loop. After editing
a component, `/reload-plugins`. After editing a **hook** or **MCP server**, `/reload-plugins` swaps to
the new code; monitors need a session restart.

## Distribute through a marketplace

1. Host the repo (with `.claude-plugin/marketplace.json`) on GitHub/GitLab or any git host.
2. Users add the marketplace and install:

```text
/plugin marketplace add your-handle/your-repo
/plugin install your-plugin@your-marketplace
```

3. Push changes; users refresh with `/plugin marketplace update` and `/plugin update`.

For a single-plugin repo, `marketplace.json` lists one entry with `source: "./"`. For a catalog of
several, point each entry's `source` at a subdir (`"./plugins/foo"`) or a separate repo
(`{ "source": "github", "repo": "org/foo" }`).

## Installation scopes

`/plugin install … --scope <scope>` chooses where the plugin is enabled:

| Scope | Settings file | Use |
| ----- | ------------- | --- |
| `user` (default) | `~/.claude/settings.json` | personal, all projects |
| `project` | `.claude/settings.json` | team-shared via version control |
| `local` | `.claude/settings.local.json` | project-specific, gitignored |
| `managed` | managed settings | org-deployed, read-only |

## Versioning

The effective version is the first set of: `plugin.json` `version` → marketplace-entry `version` →
git commit SHA → `unknown` (`02-manifest`). Two coherent strategies:

| Strategy | How | Update behavior | For |
| -------- | --- | --------------- | --- |
| **Explicit** | set `version` in `plugin.json`; **bump every release** | users update only when you bump | published, stable releases |
| **Commit-SHA** | omit `version` everywhere | users update on every new commit | internal, fast-iterating plugins |

> **MUST:** if you set an explicit `version`, bump it on every release — pushing commits alone does
> nothing, because Claude Code sees the same version string and keeps the cached copy.

Follow semver (`MAJOR.MINOR.PATCH`), keep a `CHANGELOG.md`, and gate the changelog against the
manifest version (`10-validation-and-gates`). `claude plugin tag` creates a release git tag from
inside the plugin directory.

## Update mechanics

Marketplace plugins are copied into `~/.claude/plugins/cache`, one directory per version; an old
version is removed ~7 days after an update so concurrent sessions keep working. Because
`${CLAUDE_PLUGIN_ROOT}` changes on update, never write durable state there — use
`${CLAUDE_PLUGIN_DATA}` (`08-mcp`, `01-anatomy-and-layout`).
