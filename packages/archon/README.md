# Archon — metadata plane

Archon stores the machine-readable meaning of the system: **descriptors, registry, schemas,
policies, graphs, models, and package contracts**. It exposes no end-user runtime CLI — it is
data and contracts the other products read and write, plus two build-time metadata tasks that
generate and validate the registry from those contracts.

Deep dive: [`../../docs/metadata-plane.md`](../../docs/metadata-plane.md).

## Tasks

| Task | Purpose |
|------|---------|
| `moon run archon:validate` | gate — validate descriptors, policies, and the generated graph against their JSON schemas |
| `moon run archon:sync` | generate the registry (`units/skills/profiles/policies.json` + graph) |

Both are dependency-free (bash + `awk` + `jq`), read-only over sources, and write only
generated output under `registry/` — agent-safe.

## What lives here now

| Path | Kind | Purpose |
|------|------|---------|
| `descriptors/*.descriptor.toml` | descriptor | central unit descriptors (`dust`, planned `ds`); colocated descriptors live beside their units (e.g. `wfos.descriptor.toml` at the workspace root) |
| `schemas/unit.schema.json` | schema | contract for unit descriptors (canon §10.1) |
| `schemas/policy.schema.json` | schema | contract for policies (agent-rails + command styles) |
| `schemas/dust.tools.schema.json` | schema | contract for the generated tools registry |
| `policies/dust.agent.policy.toml` | policy | Dust agent rails (allow/block, gates) |
| `policies/no-agent-git-push.policy.toml` | policy | agents never push or publish (human-only) |
| `graphs/edges.schema.json` | schema | contract for the project graph (nodes + directed edges, canon §10.5) |
| `lib/`, `bin/archon{,-sync,-validate}` | code | the registry generator + validator (bash/awk/jq) |
| `registry/QUERIES.md`, `registry/queries/*.jq` | query | the jq cookbook over the registry |
| `registry/{units,skills,profiles,policies,tools}.json` | registry | generated indexes (gitignored — host-specific) |
| `registry/graph.{json,dot}` | registry | generated project graph (gitignored — host-specific) |
| `registry/sessions/*.json` | record | build-session records (tracked for provenance) |
| `registry/.gitkeep` | — | keeps the registry directory tracked |

## Concepts

```txt
Descriptors  describe how things connect.
Registries   index what exists (tools, workspaces, apps, patterns, and their kinds).
Schemas      define contracts.
Policies     define rules — including agent rails and gates.
Graphs       define relationships — project deps + capability + policy edges.
Models       define machine-readable domain meaning (planned).
Packages     define Hypercube-managed deliverable interfaces (planned).
```

## Relationships

- **[Dust](../dust/README.md)** produces the registry (`dust doctor`) and is governed by the
  agent policy here. Today Archon + Dust are the implemented pair.
- **Kraken** (`krk`) and **Hypercube** (`hqb`) will read and operate on Archon metadata when
  implemented.
- **Native manifests stay authoritative** — Archon describes meaning, routing, policy, and
  relationships; it does not replace `Cargo.toml`, `package.json`, `mise.toml`, or lockfiles.

## Interface-layer exposure

```txt
Toolchain layer (low)     paths, native manifests, adapter contracts, registry scans
Agent layer   (mid)       descriptors, policies, scoped graphs, session context
Application layer (high)  workflow intent, domain/system labels — minimal path surface
```

## Related

- [`AGENTS.md`](AGENTS.md) — agent rules for editing metadata
- [`../dust/README.md`](../dust/README.md) — the producer/consumer of this metadata
- [`../../docs/metadata-plane.md`](../../docs/metadata-plane.md) · [`../../docs/agent-rails.md`](../../docs/agent-rails.md)
