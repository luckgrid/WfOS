# wfos workspace

WfOS Level 0 system workspace: tools, interface packages, and orchestration for the
runtime controller (Kraken), package translator (Hypercube), native substrate (Dust),
portable runtime (Ether), and the Codex metadata plane.

Canonical path: `Tech/Build/src/workspaces/wfos/` · Luckgrid disk: `Tech/Dev/src/workspaces/wfos/`.

## Git instance

This workspace is its **own standalone git repository** (`main`), independent of the
`Workstreams/` repo and the `Tech/Dev` workflow tree. The Workstreams repo ignores this
path (`/*/*/src/`), so `wfos` versions itself locally (local-first; no remote at Level 0).
It is **not** a git submodule — it is a separate repo that happens to live on disk under the
Build workflow's `src/`.

## Packages

| Package | Archetype | Status |
|---------|-----------|--------|
| [`dust/`](packages/dust/README.md) | native-substrate | implemented — Level 0 low-level tools |
| [`codex/`](packages/codex/README.md) | metadata-plane | implemented — descriptors, schemas, policies, registry |
| `kraken/` | runtime-controller | planned (`krk`) |
| `hypercube/` | package-translator | planned (`hqb`) |
| `ether/` | portable-runtime | planned (WASM/WASI) |

## Dust (this pass)

Dust is the global low-level Unix/Rust tool substrate that devs and agents work through.
It is shell-first and installs tools **globally** (Homebrew + mise); only the manifest,
scripts, config templates, and Codex metadata live in this repo.

Quick start:

```bash
Tech/Dev/src/workspaces/wfos/packages/dust/bin/dust doctor      # detect + report (read-only)
Tech/Dev/src/workspaces/wfos/packages/dust/bin/dust bootstrap   # auto-install missing tools + wire shell
```

After `bootstrap`, `dust` is on PATH (symlinked into `~/.local/bin`), so both humans and
agents can call `dust doctor` from anywhere.
