# Claude Plugin Cookbook

[![CI](https://github.com/odere-pro/claude-plugin-cookbook/actions/workflows/ci.yml/badge.svg)](https://github.com/odere-pro/claude-plugin-cookbook/actions/workflows/ci.yml)
[![plugin validate --strict](https://img.shields.io/badge/claude%20plugin%20validate-strict-brightgreen)](docs/cookbook/10-validation-and-gates.md)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/odere-pro/claude-plugin-cookbook/badge)](https://scorecard.dev/viewer/?uri=github.com/odere-pro/claude-plugin-cookbook)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code plugin](https://img.shields.io/badge/Claude%20Code-plugin-8A2BE2)](https://docs.claude.com/en/docs/claude-code/plugins)

<!-- Add once the project is registered at https://www.bestpractices.dev (see docs/cookbook/14-supply-chain-and-governance.md):
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/REPLACE-ME/badge)](https://www.bestpractices.dev/projects/REPLACE-ME)
-->

A reference cookbook **and** a working starter for building [Claude Code](https://docs.claude.com/en/docs/claude-code/overview)
plugins. The cookbook documents the whole plugin contract — manifest, skills, commands, subagents,
hooks, MCP, validation, distribution, and repository hygiene — and the `skeleton/` is a minimal plugin
that already passes `claude plugin validate --strict`. Copy it, fill in the blanks, ship.

## Quickstart

```bash
# 1. Read the one mental model, then skim the index
open docs/cookbook/README.md          # or just read it on GitHub

# 2. Copy the starter into your new plugin repo
cp -R skeleton/ ../my-plugin && cd ../my-plugin

# 3. Follow the bootstrap playbook, then validate
claude plugin validate . --strict
```

New to plugins? Start with the [cookbook index](docs/cookbook/README.md). Want to scaffold right now?
Follow the [bootstrap playbook](docs/cookbook/BOOTSTRAP.md) against a copy of [`skeleton/`](skeleton/).

## Or install it with Claude

The cookbook is itself an installable plugin. Install it and let Claude scaffold for you:

```text
/plugin marketplace add odere/claude-plugin-cookbook
/plugin install plugin-cookbook@plugin-cookbook
/plugin-cookbook:new-plugin my-plugin
```

`/plugin-cookbook:new-plugin` copies the validated skeleton into `./my-plugin`, fills in the manifest,
runs `claude plugin validate --strict`, and initializes a clean git history. See the three usage modes
(copy · template · ship-with-Claude) in [`SOFTWARE-3-0`](docs/cookbook/SOFTWARE-3-0.md).

## What's inside

| Path                                                       | What it is                                                                      |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------- |
| [`docs/cookbook/`](docs/cookbook/README.md)                | the 14-chapter reference (one attribute per chapter) + thesis + playbook        |
| [`docs/cookbook/BOOTSTRAP.md`](docs/cookbook/BOOTSTRAP.md) | an agent-followable playbook that turns a repo into a plugin                    |
| [`skeleton/`](skeleton/)                                   | a minimal, valid, loadable plugin — copy it, don't start from scratch           |
| [`skills/new-plugin/`](skills/new-plugin/SKILL.md)         | the `/plugin-cookbook:new-plugin` skill that scaffolds a new plugin             |
| [`tests/gates/`](tests/gates/)                             | standalone CI checks (`run-all.sh`) enforcing the well-formed-plugin invariants |

## Use this as a template

This repository is a GitHub **template**. Click **Use this template** to get a new repo with the same
baseline, then keep the contents of `skeleton/` at the root and delete `docs/`. The skeleton already
ships a badged README, a `CHANGELOG.md`, a `CONTRIBUTING.md`, and the lint/format/editor config — see
[`13-repository-hygiene`](docs/cookbook/13-repository-hygiene.md).

## Developing this repo

```bash
bun install
bun run lint:md && bun run format:check   # markdown lint + prettier
bash tests/gates/run-all.sh               # the full gate suite
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for commit conventions and the PR checklist.

## License

[MIT](LICENSE)
