# Software 3.0: the agent-operable plugin

> **Intent:** Name the thesis this cookbook is shaped around — a plugin is "Software 3.0" not because
> an agent helped write it, but because an agent can _operate_ it end to end.
> **Reads-with:** [`README.md`](README.md), [`00-overview`](00-overview.md), [`10-validation-and-gates`](10-validation-and-gates.md).

## The framing

In Andrej Karpathy's vocabulary: Software 1.0 is code you write, 2.0 is weights you train, and 3.0 is
**LLMs as the runtime, natural language as the program**. The interesting design surface moves
outward — to the interfaces an LLM can drive: stable contracts, scriptable verbs, machine-readable
descriptions, and docs the model can consult mid-task.

Software 3.0 is not "did an LLM help write this?" It is: **is the thing reachable by an agent without
a human in the loop?**

## The thesis

> A Claude Code plugin is Software 3.0 when an agent can **install, invoke, configure, and extend** it
> using only natural language and what the repo ships.

A plugin sits _inside_ the agent's runtime, so this is not aspirational — it is the default success
condition, and every component either advances it or quietly breaks it.

## The contracts that make it true

Each plugin attribute is, underneath, a contract an agent reads:

1. **Descriptions are routing.** A skill/agent/command `description` is the machine-readable cue
   Claude uses to decide whether to load the body. Vague descriptions are broken routing, not a
   style nit ([`04-skills`](04-skills.md)).
2. **Invocation is declared, not guessed.** `disable-model-invocation` and `user-invocable` state
   _who_ may fire a capability, so an agent never deploys because the code "looked ready"
   ([`04-skills`](04-skills.md)).
3. **Authority is least-privilege.** Scoped `allowed-tools` and explicit agent `tools` make the
   blast radius of any component legible and small ([`05-subagents`](05-subagents.md)).
4. **Determinism on the hot path.** Hooks are shell with exit codes, no network — an agent can reason
   about cause and effect, and a guard's verdict is reproducible ([`06-hooks`](06-hooks.md)).
5. **One version of record.** `plugin.json` owns the version, so "is there an update?" has a single
   answer ([`02-manifest`](02-manifest.md)).
6. **Context ships as skills, not prose.** A plugin contributes context through skills/agents/hooks;
   a root `CLAUDE.md` is dev memory. Instructions an agent needs live where the agent will load them
   ([`09-claude-md-and-author-config`](09-claude-md-and-author-config.md)).

## The gates that hold the contract

A contract no one checks decays. The built-in `claude plugin validate --strict`, plus a thin suite of
CI gates (JSON parses, frontmatter present, paths relative, no secrets, no network in hooks), keep the
agent-operable surface intact across every change ([`10-validation-and-gates`](10-validation-and-gates.md)).
The `skeleton/` is the floor: it starts green.

## Operating this cookbook (three modes)

This cookbook is itself agent-operable — you can use it three ways, in increasing order of "3.0-ness":

1. **Copy (by hand).** Copy the starter and edit it. The most direct, no tooling required:

   ```bash
   cp -R skeleton/ ../my-plugin
   ```

   Then follow [`BOOTSTRAP.md`](BOOTSTRAP.md) and the component chapters.

2. **Git / template (versioned).** Clone the repo, or use the GitHub **"Use this template"** button to
   get a fresh repo with the skeleton's contents and hygiene baked in. This gives you version control,
   shareable history, and the commit/versioning discipline from
   [`13-repository-hygiene`](13-repository-hygiene.md) and
   [`11-distribution-and-versioning`](11-distribution-and-versioning.md) from commit one.

3. **Ship with Claude (Software 3.0).** Install the cookbook as a plugin and let an agent operate it:

   ```text
   /plugin marketplace add odere/claude-plugin-cookbook
   /plugin install plugin-cookbook@plugin-cookbook
   /plugin-cookbook:new-plugin my-plugin
   ```

   The `new-plugin` skill copies the validated skeleton, fills in the manifest, runs
   `claude plugin validate --strict`, and initializes a clean history — the entire bootstrap driven by
   natural language. That is this chapter's thesis applied to the cookbook itself: not just written by
   an agent, but **operated** by one.

## The standard to hold

> If the docs are silent on something an agent needs, treat that as a bug. The plugin is the
> components **plus** the docs that describe their contracts; one without the other is not Software
> 3.0.

This cookbook is written to that standard. So should be the plugin you build from it.
