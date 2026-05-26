# example-plugin — plugin development

> Author/dev project memory for this repository. **Not shipped context**: a plugin's root `CLAUDE.md`
> is never loaded into an end user's session. It serves the people (and agents) developing the
> plugin. To ship instructions into a user's context, put them in a **skill**.

This repo is the source for the `example-plugin` Claude Code plugin. Every recognized component
directory under here ships to users when the plugin is installed.

## What ships

- `.claude-plugin/plugin.json` — the manifest (version of record)
- `.claude-plugin/marketplace.json` — single-plugin marketplace (`source: "./"`); omits `version`
- `skills/` — `<name>/SKILL.md` skills (and supporting files)
- `commands/` — flat `.md` skills (classic form)
- `agents/` — worker subagents
- `hooks/` — `hooks.json` + scripts
- `.mcp.json` — MCP server definitions (delete if none)

## What doesn't ship (author-only — copied to the cache but never loaded)

- `.claude/` — this repo's own project config (house rules, dev skills/agents)
- `CLAUDE.md` (this file) — dev-repo memory, not user context
- `README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, `LICENSE`, `tests/`, `.github/` — docs and CI
- `.editorconfig`, `.gitattributes`, `.gitignore`, `.markdownlint*.jsonc`, `.prettierrc` — repo config

## Source layout

| Path                   | Role                         | Ships? |
| ---------------------- | ---------------------------- | ------ |
| `.claude-plugin/`      | manifest + marketplace       | yes    |
| `skills/`, `commands/` | user/Claude-invokable skills | yes    |
| `agents/`              | worker subagents             | yes    |
| `hooks/`               | event hooks + scripts        | yes    |
| `.mcp.json`            | MCP servers                  | yes    |
| `.claude/`             | dev-repo project config      | no     |
| `tests/`               | validation gates             | no     |

## House rules

See [`.claude/rules/plugin-dev.md`](.claude/rules/plugin-dev.md) (path-scoped; loads when you edit
components).

## Verify before release

```bash
claude plugin validate . --strict      # manifest + component frontmatter + hooks.json
claude --plugin-dir .                   # load against this repo, then /reload-plugins
```
