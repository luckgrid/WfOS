# Archon agent guide

Archon is data and contracts. [`README.md`](README.md) and
[`../../docs/metadata-plane.md`](../../docs/metadata-plane.md) are the source of truth.

## Rules

- **Reading is safe.** Descriptors, schemas, and policies are meant to be read by agents to
  understand routing, contracts, and rails.
- **The registry is generated, never hand-edited.** `registry/tools.json` comes from `dust
  doctor`; `registry/{units,skills,profiles,policies}.json` and the graph come from
  `moon run archon:sync`. All are host-specific and gitignored — regenerate, don't edit.
- **`moon run archon:validate` is the gate.** It validates every descriptor, policy, and the
  generated graph against its JSON schema (`schemas/*.schema.json`, `graphs/edges.schema.json`).
  `validate` and `sync` are agent-safe: they read contracts and write only generated output.
- **Policies define the rails you operate under.** `policies/dust.agent.policy.toml` is enforced
  by Dust when `DUST_AGENT=1` (mutating substrate commands exit non-zero). `policies/no-agent-git-push.policy.toml`
  is Archon policy metadata for publish actions (push, release, merge) — authoritative intent and
  graph edges today; runtime command blocking deferred to Kraken, same boundary as direct `pass`/`git`
  invocation on `PATH`.
- **Keep contracts honest.** When adding metadata, follow the Dust example: a descriptor for
  how a product connects, a schema for any generated artifact, a policy for its agent rails.
  Generated output goes under `registry/` (gitignored); contracts and policies stay tracked.
- **Native manifests stay authoritative** — do not duplicate or override `Cargo.toml`,
  `package.json`, or lockfile data in Archon.
