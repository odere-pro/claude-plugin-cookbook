# `changelog/` — fragment-per-PR changelog

This directory holds one Markdown fragment per merged PR. The aggregator
(`scripts/changelog-aggregate.sh`) promotes the fragments into the `[Unreleased]` block of
`CHANGELOG.md` at release time.

The point: every PR writes to its own file, so two PRs in flight cannot conflict on the changelog. No
rebase-driven `git stash` dances.

## File naming

`changelog/<NN>-<slug>.md` where:

- `<NN>` is the next zero-padded sequence number (one greater than the highest already used here).
- `<slug>` is kebab-case, ≤ 32 chars, descriptive of the change (often the branch slug).

## File content

Exactly one bullet, leading with intent, ending with a period. **Do not prefix with the commit SHA** —
the aggregator resolves the introducing commit per fragment via `git log` and prepends the short SHA on
aggregation. Multi-clause is fine; multi-paragraph is not.

```markdown
- <Intent / goal>: <what changed>.
```

## When to write a fragment

Every PR that ships a user-visible or behavioural change writes a fragment. Doc-only PRs (anything
touching only `docs/`, `changelog/`, `.github/`, or the root governance files — `README.md`,
`CHANGELOG.md`, `LICENSE`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md`,
`CLAUDE.md`) may skip it — `tests/gates/10-changelog-fragment-present.sh` encodes exactly that rule.

## Aggregation

```bash
bash scripts/changelog-aggregate.sh            # dry-run preview to stdout
bash scripts/changelog-aggregate.sh --apply    # inline fragments into CHANGELOG.md, then remove them
```

The release PR is the canonical place to run `--apply`; see [`docs/RELEASING.md`](../docs/RELEASING.md).
