# Contributing

Thanks for improving the Claude Plugin Cookbook. This repo holds documentation (`docs/cookbook/`), a
starter plugin (`skeleton/`), and the CI gates that keep both well-formed.

## Setup

```bash
bun install
```

## Before you push

```bash
bun run lint:md          # markdownlint-cli2 over every Markdown file
bun run format:check     # prettier in check mode (use `bun run format` to fix)
bash tests/gates/run-all.sh
```

The gate suite mirrors the checks in [`10-validation-and-gates`](docs/cookbook/10-validation-and-gates.md):
JSON parses, the skeleton validates `--strict`, shell scripts are clean, no machine paths leak,
documentation links resolve, and Markdown is linted and formatted. The `skeleton/` MUST stay
`claude plugin validate --strict`-clean.

## Commits

Use [Conventional Commits](https://www.conventionalcommits.org/): `<type>: <subject>`, with `type` one
of `feat fix docs refactor test chore perf ci build`. Keep each commit to one logical change so the
history reads as a clean, reviewable sequence — see [`13-repository-hygiene`](docs/cookbook/13-repository-hygiene.md).

## Changelog fragments

Every PR with a user-visible or behavioural change adds one fragment under `changelog/` (one bullet per
file, no SHA prefix) so two PRs in flight never conflict on the changelog — see
[`changelog/README.md`](changelog/README.md). Doc-only PRs may skip it;
`tests/gates/10-changelog-fragment-present.sh` encodes the rule. Fragments are aggregated into
`CHANGELOG.md` at release time ([`docs/RELEASING.md`](docs/RELEASING.md)).

## Pull requests

1. Branch from `main`.
2. Make the change; keep commits focused and conventionally named.
3. Add a `changelog/` fragment unless the change is doc-only.
4. Ensure the commands above pass.
5. Open a PR; the template's checklist must be green before review.

## Reporting issues

Security vulnerabilities go through [`SECURITY.md`](SECURITY.md), not public issues. By participating
you agree to the [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md).
