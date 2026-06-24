# Dust — native substrate

Dust is the layer of small native Unix/Rust tools that make the machine usable for developers
and AI agents. It is shell-first and installs tools **globally** (Homebrew + mise); only the
manifest, scripts, config templates, and metadata live here.

Deep dive: [`../../docs/native-substrate.md`](../../docs/native-substrate.md).

## Layout

```txt
manifest/dust.tools.toml   single source of truth — modules + tools
bin/                       dust, dust-doctor, dust-bootstrap, dust-env, dust-gen, validate-substrate.sh
lib/                       manifest parser, generate.sh, shared helpers, per-module logic
config/                    Brewfile (generated) + shell fragment + tool config templates
moon.yml                   doctor/list/env/gen-check/validate-substrate tasks
```

The generated tool registry is written to the [Archon](../archon/README.md) package
(`packages/archon/registry/tools.json`) — host-specific and gitignored.

## Quick start

```bash
moon run dust:doctor          # detect + report (read-only); writes the Archon registry
moon run dust:list            # list modules and tools
bin/dust bootstrap            # install missing tools + wire shell (human-only; --dry-run to preview)
```

After `bootstrap`, `dust` is on `PATH` (symlinked into `~/.local/bin`).

## DUST_HOME

The shell fragment sets a suggested default (`~/Workstreams/Build/src/workspaces/wfos/packages/dust`)
when `DUST_HOME` is unset. Override in `~/.zshenv` if your layout differs; `bootstrap` exports
the resolved package path into `~/.zshrc` automatically. See [`../../docs/setup.md`](../../docs/setup.md#dust_home-and-workstreams-layout).

## Commands

| Command | Mutating | Agent-safe | Purpose |
|---------|----------|------------|---------|
| `dust doctor [--json] [--no-write]` | no | yes | detect tools, print readiness (`--json` = parseable), write the registry |
| `dust list [module]` | no | yes | list modules and tools from the manifest |
| `dust gen <brewfile\|mise>` | no | yes | derive install artifacts from the manifest (dry-run, stdout) |
| `dust env [--shell\|--json]` | no | yes | print the resolved environment (paths, module map, `DUST_AGENT`); `--shell` = activation snippet |
| `dust bootstrap` | yes | no | install (brew + mise), symlink configs, wire `~/.zshrc` |

The manifest is the single source of truth: `dust gen brewfile` reproduces `config/Brewfile`
exactly (enforced by `dust gen brewfile --check` / `moon run dust:gen-check`).

## Modules

`shell, git, nav, system, session, secrets, tools, dotfiles, js, rust, ether, logs, agent` —
each replaceable (fzf ↔ skim, tmux ↔ zellij, mise ↔ proto, git ↔ jj). The manifest holds
per-tool `brew`, `detect`, `agent_safe`, and `alternatives`. Descriptions and links:
[`../../docs/tool-catalog.md`](../../docs/tool-catalog.md).

The `agent` module wires **RTK** as the recommended-default output compressor (60-90% token
savings), swappable via `DUST_RTK` / profile data — see
[`../../docs/native-substrate.md`](../../docs/native-substrate.md#output-compression-rtk).

## mise / proto coexistence

Dust standardizes on **mise** for day-to-day runtimes and activates it in
`config/shell/dust.zsh`; an existing **proto** setup is left intact. (proto also pins the
workspace build toolchains — see [`../../docs/monorepo.md`](../../docs/monorepo.md).)

## Agent rails

`dust` reads `DUST_AGENT`. In agent mode, read-only commands run; mutating ones are blocked
per `../archon/policies/dust.agent.policy.toml`. See [`AGENTS.md`](AGENTS.md) and
[`../../docs/agent-rails.md`](../../docs/agent-rails.md).

## Related

- [`dotfiles/README.md`](dotfiles/README.md) — chezmoi source (profiles, validation, promotion)
- [`dotfiles/SECRETS.md`](dotfiles/SECRETS.md) — tiered vault model + agent secret-read hard block
- [`secrets/README.md`](secrets/README.md) — sops + age fixtures (files vault)
- [`../archon/README.md`](../archon/README.md) — metadata this package produces and is governed by
- [`../../docs/native-substrate.md`](../../docs/native-substrate.md) · [`../../docs/setup.md`](../../docs/setup.md)
