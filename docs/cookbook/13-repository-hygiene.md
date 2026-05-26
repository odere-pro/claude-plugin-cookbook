# 13 · Repository hygiene

> **Intent:** Set up the repository _around_ the plugin so its history, configuration, and
> presentation are as well-formed as its manifest — and so a new plugin inherits all of it by copying
> `skeleton/`.
> **Reads-with:** `10-validation-and-gates`, `11-distribution-and-versioning`, `09-claude-md-and-author-config`.

The plugin contract (chapters `00`–`12`) governs what loads into a session. This chapter governs the
repository that holds it: how you initialize it, commit to it, configure it, and present it. None of
this ships to end users (`09-claude-md-and-author-config`), but it is what makes the repo reviewable,
reproducible, and trustworthy — and it is all pre-wired in `skeleton/`.

## Initialize the repository

A plugin repo starts empty. Lay down the foundation before the plugin:

```bash
git init
# add LICENSE, .gitignore, .editorconfig, .gitattributes
git add -A && git commit -m "chore: scaffold repository"
```

Then add the plugin itself (copy `skeleton/`, edit the manifest per `02-manifest`) as its own commit.
The guiding rule: **the first handful of commits should read like a table of contents for the repo**,
each one a single coherent layer.

## Conventional Commits

Every commit message MUST follow [Conventional Commits](https://www.conventionalcommits.org/):

```text
<type>: <subject>

<optional body>
```

`type` is one of:

| Type       | Use for                                            |
| ---------- | -------------------------------------------------- |
| `feat`     | a new component or user-visible capability         |
| `fix`      | a bug fix in a component or hook                   |
| `docs`     | README, CHANGELOG, or cookbook-style docs          |
| `refactor` | restructuring with no behavior change              |
| `test`     | gates and test scripts (`10-validation-and-gates`) |
| `ci`       | workflow / automation changes                      |
| `build`    | tooling, dependencies, lint/format config          |
| `chore`    | scaffolding and housekeeping                       |
| `perf`     | performance work                                   |

Conventional types are not decoration: they are the **semver signal** (`feat` → minor, `fix` →
patch, a `!` suffix or `BREAKING CHANGE:` → major) and the raw material for a generated `CHANGELOG.md`
(`11-distribution-and-versioning`). The subject SHOULD be imperative and lowercase (`add skill`, not
`Added skill.`).

## Keep the history clean

A clean history is one a reviewer can read top to bottom and understand the build order:

- **One concern per commit.** Don't mix a new skill with a lint-config change.
- **Each commit builds green.** Every commit SHOULD pass `claude plugin validate . --strict` and the
  gates (`10-validation-and-gates`) on its own — bisect stays meaningful.
- **Order so each commit stands alone.** Land tooling before the gate that runs it; land gates before
  the CI that invokes them.
- **No noise.** Squash `wip`/`fixup`/`oops` commits before they reach a shared branch; prefer a linear
  history (rebase) over merge bubbles for a small plugin repo.

## Repository configuration files

Three files keep contributors and CI consistent regardless of editor or platform:

- **`.editorconfig`** — charset, indentation, final newline, trailing-whitespace policy. Markdown
  SHOULD opt out of trailing-whitespace trimming (two trailing spaces are a hard line break).
- **`.gitattributes`** — normalize line endings (`* text=auto eol=lf`) so hook scripts and JSON are
  byte-stable across macOS/Linux/Windows; pin `*.sh` to `eol=lf`; mark `bun.lock` as
  `linguist-generated`.
- **`.gitignore`** — ignore `node_modules/`, OS cruft (`.DS_Store`), and any scratch directory.

## Lint and format the docs with Bun

Plugins are mostly Markdown and JSON. Lint and format them with the same discipline as code, using
**Bun** as the runtime so there is no global-tool drift:

```jsonc
// package.json (author-only; never shipped)
{
  "packageManager": "bun@1.x",
  "scripts": {
    "lint:md": "markdownlint-cli2 \"**/*.md\"",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
  },
  "devDependencies": {
    "markdownlint-cli2": "^0.x",
    "prettier": "^3.x",
  },
}
```

```bash
bun install            # writes bun.lock; commit it
bun run lint:md        # markdownlint over every Markdown file
bun run format:check   # prettier in check mode (CI); `bun run format` to fix
```

- **`.markdownlint.jsonc`** — start from `"default": true`, then disable the rules that fight prose
  (`MD013` line length, `MD033` inline HTML for badges, `MD041` first-line heading). Configure, don't
  rewrite content, to land green.
- **`.prettierrc`** — set `"proseWrap": "preserve"` so Prettier normalizes formatting (table padding,
  list markers) **without** reflowing authored line breaks.

Wire both into a gate (`06-markdown-lint` in `10-validation-and-gates`) and into CI so a malformed doc
fails the build like a malformed manifest does.

## Badges

A `README.md` SHOULD open with a small, honest set of badges — each one a live signal, not a sticker:

```markdown
[![CI](https://github.com/<owner>/<repo>/actions/workflows/ci.yml/badge.svg)](https://github.com/<owner>/<repo>/actions/workflows/ci.yml)
[![plugin validate --strict](https://img.shields.io/badge/claude%20plugin%20validate-strict-brightgreen)](https://docs.claude.com/en/docs/claude-code/plugins)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code plugin](https://img.shields.io/badge/Claude%20Code-plugin-8A2BE2)](https://docs.claude.com/en/docs/claude-code/plugins)
```

The CI badge is dynamic (it tracks the workflow); the others are static [shields.io](https://shields.io)
badges. A version badge MAY track a release tag once you publish. Keep them truthful: a green
`validate --strict` badge MUST correspond to a real gate (`10-validation-and-gates`).

## CHANGELOG

Keep a `CHANGELOG.md` in [Keep a Changelog](https://keepachangelog.com/) format. Its top released
version MUST match `version` in `plugin.json` (the version of record, `02-manifest`); gate that
equality so the two never drift (`10-validation-and-gates`). On the explicit-version strategy, every
release bumps `plugin.json` **and** adds a `CHANGELOG.md` entry in the same commit
(`11-distribution-and-versioning`).

## Reuse this for a new plugin

`skeleton/` already ships every file in this chapter — `.editorconfig`, `.gitattributes`,
`.gitignore`, `.markdownlint.jsonc`, `.prettierrc`, a badged `README.md`, a `CHANGELOG.md` stub, and a
`CONTRIBUTING.md` stating the commit conventions. Two ways to inherit it:

- **Copy `skeleton/`** into a fresh repo and run the `BOOTSTRAP.md` playbook — you start with hygiene
  already wired.
- **Use the GitHub template.** If the cookbook repo is marked a _template repository_, "Use this
  template" gives a new repo with the same baseline; delete the cookbook `docs/` and keep `skeleton/`'s
  contents at the root.

Either way, a new plugin's first commit already satisfies this chapter — the work is replacing the
`REPLACE ME` placeholders, not assembling the scaffolding.
