# 08 · MCP servers

> **Intent:** Bundle a Model Context Protocol server so the plugin adds external tools, and pair it
> with a skill so it's discoverable and scoped.
> **Reads-with:** `01-anatomy-and-layout`, `04-skills`.

## The shape

MCP servers are declared in `.mcp.json` at the plugin root (or inline under `mcpServers` in
`plugin.json`). The config is a standard MCP server map; reference bundled binaries and data through
the path variables:

```json
{
  "mcpServers": {
    "example-server": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/example-server",
      "args": ["--stdio"],
      "env": { "EXAMPLE_DATA_DIR": "${CLAUDE_PLUGIN_DATA}" }
    }
  }
}
```

Each entry supports `command`, `args`, `env`, and `cwd`. A server's tools appear in Claude's toolkit
automatically when the plugin is enabled, alongside the user's own MCP tools.

> `skeleton/.mcp.json` ships this exact entry as a **placeholder**. Until you point `command` at a
> real server it will show as failed in `/doctor` — that's expected. Replace it, or delete `.mcp.json`
> if your plugin has no MCP server.

## Paths and persistence

- **MUST** use `${CLAUDE_PLUGIN_ROOT}` for the server binary and any bundled config — never an
  absolute path. The install dir changes on every update.
- Put anything the server must persist across updates (a database, installed dependencies) under
  `${CLAUDE_PLUGIN_DATA}`. A common `SessionStart` hook installs `node_modules` into
  `${CLAUDE_PLUGIN_DATA}` once, then the server runs against it.

## Secrets and user config

Never bake a token into `.mcp.json`. Declare it in the manifest's `userConfig` so Claude Code prompts
the user at enable time and stores it securely:

```json
{
  "userConfig": {
    "api_token": {
      "type": "string", "title": "API token",
      "description": "Token for the service", "sensitive": true
    }
  }
}
```

The value is then available as `${user_config.api_token}` inside the MCP `env`/`args`, and sensitive
values go to the system keychain rather than `settings.json`.

## Pair the server with a skill

MCP tools surface automatically, but their raw names and signatures are terse. A thin, `paths:`- or
description-scoped skill that explains *when* and *how* to use the server's tools makes them
discoverable and keeps Claude using them correctly — the skill is the human-readable front door to
the machine-readable server. (See `04-skills`; this "wrap the integration in a skill" pattern is one
the calibration rubric actively recommends.)

## What to verify

- `.mcp.json` parses (`jq . .mcp.json`).
- `claude --debug` shows the server initializing; the server starts when the plugin is enabled.
- No secrets are committed — they come from `userConfig`, not the JSON.
