# Claude Code Plugin Cookbook

> **Intent:** Give a competent engineer everything needed to create a complete, well-formed Claude
> Code plugin — every attribute, from manifest to MCP — without reading another plugin's source.
> **Reads-with:** the whole package (`00`–`14`), the `skeleton/`, and the `BOOTSTRAP.md` playbook.

This is a **template for the initial creation of a Claude Code plugin**. It pairs a numbered
reference (each chapter covers one attribute) with a copyable `skeleton/` that already passes
`claude plugin validate --strict`, and a `BOOTSTRAP.md` playbook that walks an agent through turning a
plain repo into a plugin-development repo.

## What this is / is not

- **Is:** a complete, plugin-agnostic guide + a working starter scaffold. The worked examples are the
  in-package `skeleton/` and, where a production pattern helps, the `claude-calibration` plugin.
- **Is not:** a tutorial on what to build, or a guide to any one language/runtime. It documents the
  _plugin contract_, not your plugin's logic.

## Who it's for

An engineer comfortable with JSON, YAML frontmatter, and shell — who wants to ship a plugin correctly
the first time and understand _why_ each rule exists.

## How to read it

| Mode                     | Path                                                                                                                                                                                                      |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Bootstrap a repo now** | the [`BOOTSTRAP.md`](BOOTSTRAP.md) playbook → copy [`skeleton/`](../../skeleton/)                                                                                                                         |
| **Impatient**            | [`00`](00-overview.md) → `skeleton/` → [`02`](02-manifest.md) → [`10`](10-validation-and-gates.md)                                                                                                        |
| **Thorough**             | sequential [`00`](00-overview.md) → [`14`](14-supply-chain-and-governance.md)                                                                                                                             |
| **By component**         | [`03`](03-commands.md)–[`08`](08-mcp.md) as needed                                                                                                                                                        |
| **Quality / shipping**   | [`10`](10-validation-and-gates.md) → [`09`](09-claude-md-and-author-config.md) → [`11`](11-distribution-and-versioning.md) → [`13`](13-repository-hygiene.md) → [`14`](14-supply-chain-and-governance.md) |

## Conventions

- Every chapter opens with **Intent** and **Reads-with** lines.
- Normative words follow RFC 2119: **MUST**, **SHOULD**, **MAY**.
- Chapter numbers are **stable** — cite `04-skills`, never "the skills chapter."
- Cross-references use the chapter stem in backticks (`07-rules`); the glossary ([`12`](12-glossary.md)) is authoritative for terms.
- A `CLAUDE.md` at a plugin root is dev memory, not shipped context — a fact load-bearing enough that it appears in three chapters.

## Chapters

| #   | Chapter                                                          | Covers                                                                      |
| --- | ---------------------------------------------------------------- | --------------------------------------------------------------------------- |
| 00  | [Overview](00-overview.md)                                       | the one mental model: descriptions are always-on, bodies load on invoke     |
| 01  | [Anatomy and layout](01-anatomy-and-layout.md)                   | every recognized component, default locations, path variables               |
| 02  | [The manifest](02-manifest.md)                                   | `plugin.json` + `marketplace.json` + the version-of-record rule             |
| 03  | [Commands](03-commands.md)                                       | flat-file skills, arguments, dynamic context injection                      |
| 04  | [Skills](04-skills.md)                                           | `SKILL.md` frontmatter, bundles, the routing budget, invocation control     |
| 05  | [Subagents](05-subagents.md)                                     | `agents/*.md`, least-privilege `tools`, when to delegate                    |
| 06  | [Hooks](06-hooks.md)                                             | `hooks.json`, events, exit codes, the write-guard pattern                   |
| 07  | [Rules and path-scoped guidance](07-rules.md)                    | `paths:` rules vs plugin-shipped guidance                                   |
| 08  | [MCP servers](08-mcp.md)                                         | `.mcp.json`, path variables, secrets, pairing with a skill                  |
| 09  | [CLAUDE.md and author config](09-claude-md-and-author-config.md) | shipped vs author-only; transforming the repo                               |
| 10  | [Validation and gates](10-validation-and-gates.md)               | the built-in validator + your own CI gates                                  |
| 11  | [Distribution and versioning](11-distribution-and-versioning.md) | marketplace, scopes, semver, updates                                        |
| 12  | [Glossary](12-glossary.md)                                       | the canonical vocabulary                                                    |
| 13  | [Repository hygiene](13-repository-hygiene.md)                   | init, conventional commits, clean history, repo config, lint/format, badges |
| 14  | [Supply-chain and governance](14-supply-chain-and-governance.md) | OpenSSF, provenance, governance docs, Dependabot, fragment changelog        |

## Also in this package

- [`skeleton/`](../../skeleton/) — a minimal, valid, loadable plugin. Copy it; don't start from scratch.
- [`BOOTSTRAP.md`](BOOTSTRAP.md) — the bootstrap playbook (scaffold → override `.claude/` → override `CLAUDE.md` → validate).
- [`SOFTWARE-3-0.md`](SOFTWARE-3-0.md) — why a plugin should be agent-operable, not just agent-built.
