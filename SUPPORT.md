# Support

Need help with `plugin-cookbook`? Here's where to look.

## Self-service first

- **Learn the model** — read the [cookbook index](docs/cookbook/README.md); it links one chapter per
  attribute of the plugin contract (manifest, skills, commands, subagents, hooks, MCP, validation,
  distribution, hygiene, supply-chain).
- **Scaffold a plugin** — run `/plugin-cookbook:new-plugin <name> <what it should do>` in a session,
  or follow the [bootstrap playbook](docs/cookbook/BOOTSTRAP.md) against a copy of
  [`skeleton/`](skeleton/).
- **Validate / harden** — see [`10-validation-and-gates`](docs/cookbook/10-validation-and-gates.md)
  and run `bash tests/gates/run-all.sh`.
- **Vocabulary** — [`12-glossary`](docs/cookbook/12-glossary.md) is authoritative for terms.

## Questions and bugs

- **Bugs** — open a GitHub issue using the **Bug report** template. Include the command you ran, your
  Claude Code version, and the relevant `/plugin` or `/doctor` output.
- **Ideas / feature requests** — open an issue using the **Feature request** template.
- **Security issues** — do **not** open a public issue; see [`SECURITY.md`](SECURITY.md).

## Contributing

If you want to fix or extend something yourself, start with [`CONTRIBUTING.md`](CONTRIBUTING.md).
