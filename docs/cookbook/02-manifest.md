# 02 · The manifest

> **Intent:** Write a correct `plugin.json` and `marketplace.json`, and understand the
> version-of-record rule that ties them together.
> **Reads-with:** `01-anatomy-and-layout`, `11-distribution-and-versioning`.

## `plugin.json`

Lives at `.claude-plugin/plugin.json`. The manifest is **optional** — without it, Claude Code
auto-discovers components in their default locations and derives the name from the directory. Add one
the moment you want metadata, a pinned version, or custom component paths.

> **MUST:** if you include a manifest, `name` is the only required field. It is kebab-case, no
> spaces, and is what namespaces every component (`<name>:<component>`).

### Field reference

| Field                                                                               | Required | Purpose                                                   |
| ----------------------------------------------------------------------------------- | -------- | --------------------------------------------------------- |
| `name`                                                                              | **yes**  | Unique kebab-case identifier; namespaces components       |
| `$schema`                                                                           | no       | JSON-Schema URL for editor autocomplete (ignored at load) |
| `displayName`                                                                       | no       | Human-readable name for UI surfaces; may contain spaces   |
| `version`                                                                           | no       | Semver. Pins updates — see version-of-record below        |
| `description`                                                                       | no       | What the plugin does; routing/discovery text              |
| `author`                                                                            | no       | `{ name, email, url }`                                    |
| `homepage`, `repository`                                                            | no       | Docs / source URLs                                        |
| `license`                                                                           | no       | SPDX id (`MIT`, `Apache-2.0`, …)                          |
| `keywords`                                                                          | no       | Discovery tags (array)                                    |
| `skills`, `commands`, `agents`, `hooks`, `mcpServers`, `lspServers`, `outputStyles` | no       | Override default component paths (see below)              |
| `experimental.themes`, `experimental.monitors`                                      | no       | Experimental component paths                              |
| `userConfig`, `channels`, `dependencies`                                            | no       | User-prompted config, message channels, plugin deps       |

Unrecognized top-level fields are **warnings**, not errors — a manifest can double as an npm or
editor-extension manifest. Wrong _types_ (e.g. `keywords` as a string) are hard errors. Run
`claude plugin validate . --strict` in CI to treat warnings as errors and catch typos.

### Component-path overrides

You rarely need these — the defaults in `01-anatomy-and-layout` work. When you do override, the
behavior differs by field:

- **Replaces** the default dir: `commands`, `agents`, `outputStyles`, `experimental.*`. To keep the
  default _and_ add more, list it explicitly: `"commands": ["./commands/", "./extras/"]`.
- **Adds to** the default: `skills` (the default `skills/` is always scanned too).
- **Own merge rules**: `hooks`, `mcpServers`, `lspServers`.

All override paths are relative and start with `./`.

### Minimal manifest (from `skeleton/`)

```json
{
  "$schema": "https://json.schemastore.org/claude-code-plugin-manifest.json",
  "name": "example-plugin",
  "version": "0.1.0",
  "description": "What it does and when to use it.",
  "author": { "name": "Your Name", "email": "you@example.com" },
  "license": "MIT",
  "keywords": ["example", "starter"]
}
```

## `marketplace.json`

A marketplace is a catalog that distributes one or more plugins. When a repo _is_ a single plugin,
ship a one-entry marketplace whose plugin `source` is `"./"` (the repo root is the plugin).

| Field                                       | Required | Notes                                                                   |
| ------------------------------------------- | -------- | ----------------------------------------------------------------------- |
| `name`                                      | **yes**  | Marketplace id (kebab-case); public-facing in `install <plugin>@<name>` |
| `owner`                                     | **yes**  | `{ name (req), email? }`                                                |
| `plugins`                                   | **yes**  | Array of entries (below)                                                |
| `description`                               | no\*     | `--strict` validation requires it; always write one                     |
| `version`, `$schema`, `metadata.pluginRoot` | no       | Catalog metadata                                                        |

Each `plugins[]` entry requires `name` and `source`; it may also carry any manifest field plus the
marketplace-only `category`, `tags`, `strict`. `source` is `"./relative/path"` or an object:
`github` (`{repo, ref?, sha?}`), `url`, `git-subdir`, or `npm`.

```json
{
  "name": "your-marketplace",
  "owner": { "name": "Your Name", "email": "you@example.com" },
  "description": "What this marketplace offers.",
  "plugins": [{ "name": "example-plugin", "source": "./", "description": "…", "license": "MIT" }]
}
```

## The version-of-record rule

A plugin's effective version is resolved from the first of these that is set:

1. `version` in **`plugin.json`** ← the version of record
2. `version` in the marketplace entry
3. the git commit SHA of the source
4. `unknown`

> **SHOULD:** set `version` in `plugin.json` only, and **omit it from the marketplace entry** — one
> source of truth. **MUST** bump it on every release, or users keep the cached copy. If you iterate
> fast, omit `version` everywhere so each commit is treated as a new version.

The `skeleton/` follows this: `plugin.json` carries `"version"`, `marketplace.json` does not.
