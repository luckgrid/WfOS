# Dust — native substrate

Dust is the WfOS Level 0 **native-substrate** product: the layer of small native Unix/Rust
tools that make the machine usable for both developers and AI agents. See foundation doc §8.

Dust is shell-first and installs tools **globally**. Only the source of truth lives here:

```txt
manifest/dust.tools.toml   single source of truth — modules + tools
bin/                       dust dispatcher, doctor, bootstrap, env
lib/                       manifest parser, shared helpers, per-module logic
config/                    Brewfile + shell fragment + tool config templates
```

Codex metadata (descriptor, schema, agent policy, generated registry) lives in the sibling
[`../codex/`](../codex/README.md) package.

## Commands

| Command | Mutating | Agent-safe | Purpose |
|---------|----------|------------|---------|
| `dust doctor` | no | yes | detect tools, print readiness, write `codex/registry/tools.json` |
| `dust list` | no | yes | list modules and tools from the manifest |
| `dust env` | no | yes | print the shell activation snippet |
| `dust bootstrap` | yes | no | install missing tools (brew + mise), symlink configs, wire `~/.zshrc` |

## Modules

`shell, git, nav, session, secrets, tools, js, rust, ether, logs` — each replaceable
(e.g. fzf↔skim, tmux↔zellij, mise↔proto) per foundation doc §8.2.

## Agent rails

`dust` reads `DUST_AGENT=1`. In agent mode, read-only commands run; mutating commands
(`bootstrap`, installs, secret reads) are blocked per `../codex/policies/dust.agent.policy.toml`.

## mise / proto coexistence

This machine already uses **proto** (shims + aliases in `~/.zshrc`). Dust standardizes on
**mise** as its runtime manager and activates it in the Dust shell fragment. proto is left
intact. Activation order in `config/shell/dust.zsh` lets mise manage Dust-scoped runtimes;
to retire proto later, remove its block from `~/.zshrc` and the `PROTO_HOME` PATH entry.

## Layout note

Tools install globally (Homebrew binaries, `~/.config` symlinks, one sourced line in
`~/.zshrc`). This repo holds only the manifest, scripts, config templates, and metadata —
consistent with "low-level tools and dotfiles live outside `Workstreams/`".
