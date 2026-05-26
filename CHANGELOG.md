# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Packaged the cookbook as the installable `plugin-cookbook` plugin, with a
  `/plugin-cookbook:new-plugin` skill that scaffolds a validated starter from `skeleton/`.
- Author-only `.claude/` config: path-scoped house rules (cookbook authoring + plugin dev) and a
  format-on-edit hook.
- `SOFTWARE-3-0` now documents the three usage modes (copy · git/template · ship-with-Claude).

## [0.1.0] - 2026-05-27

### Added

- The 14-chapter plugin cookbook under `docs/cookbook/` (overview through repository hygiene, plus the
  thesis and the bootstrap playbook).
- A `skeleton/` starter plugin that passes `claude plugin validate --strict`, shipping its own
  badged README, changelog, contributing guide, and lint/format/editor config.
- A `tests/gates/` suite with a `run-all.sh` runner and GitHub Actions CI.
- Bun-managed markdownlint-cli2 and prettier for documentation linting and formatting.
