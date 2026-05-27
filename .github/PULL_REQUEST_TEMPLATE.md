<!-- Keep the history clean: one concern per PR, Conventional Commit titles. -->

## Summary

<!-- What changed and why. -->

## Test plan

- [ ] `bun install` succeeds
- [ ] `bun run lint:md` and `bun run format:check` pass
- [ ] `bash tests/gates/run-all.sh` is green
- [ ] `claude plugin validate skeleton --strict` exits 0
- [ ] A `changelog/` fragment was added (or the change is doc-only) — see [`changelog/README.md`](../changelog/README.md)
- [ ] Commits follow [Conventional Commits](https://www.conventionalcommits.org/)
