---
description: >-
  Authoring conventions for the cookbook chapters. Author-only — lives under .claude/ and is never
  shipped. Path-scoped so it loads only when you edit the reference docs.
paths:
  - "docs/cookbook/**"
---

# Cookbook authoring rules

- Chapter numbers are **stable**. Cite a chapter by stem in backticks (`04-skills`), never "the skills
  chapter". A new chapter goes at the end; never renumber existing ones.
- Every chapter opens with **Intent** and **Reads-with** blockquote lines.
- Use RFC 2119 normative words (MUST / SHOULD / MAY) deliberately, not for emphasis.
- Prose is hand-wrapped and Prettier runs with `proseWrap: preserve` — keep line breaks tidy (~100
  columns); do not rely on the formatter to reflow.
- Every relative link and every `NN-stem` reference MUST resolve. Refer to a gate by its path
  (`tests/gates/05-doc-links.sh`), not as a bare stem, so it is not mistaken for a chapter.
- The glossary (`12-glossary`) is authoritative for terms; add an entry when you introduce one.
- After editing docs, run `bash tests/gates/run-all.sh` — the doc-links and markdown gates must pass.
