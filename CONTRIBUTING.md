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

## Pull requests

1. Branch from `main`.
2. Make the change; keep commits focused and conventionally named.
3. Ensure the commands above pass.
4. Open a PR; the template's checklist must be green before review.
