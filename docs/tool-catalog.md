# Tool catalog

The open-source tools, libraries, skills, and crates that WfOS builds on or plans to include,
grouped by role. Each entry notes its status and where it fits.

Status legend: **core** (installed by Dust today) · **optional** (detected/swappable) ·
**planned** (intended, not yet wired) · **inspiration** (reference, not a dependency).

---

## Core dependencies — Unix substrate (Dust)

The low-level CLI layer. Defaults are installed by `dust bootstrap`; alternatives are
detected if present. See [dust.md](dust.md).

| Tool | Status | Role |
|------|--------|------|
| [git](https://git-scm.com/) | core | version control |
| [gh](https://cli.github.com/) | core | GitHub CLI |
| [OpenSSH](https://www.openssh.com/) | core | secure remote access and keys |
| [fzf](https://github.com/junegunn/fzf) | core | fuzzy finder and selection |
| [tmux](https://github.com/tmux/tmux) | core | persistent terminal sessions |
| [starship](https://github.com/starship/starship) | core | cross-shell prompt context |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | core | smarter directory jumping |
| [eza](https://github.com/eza-community/eza) | core | modern `ls` |
| [bat](https://github.com/sharkdp/bat) | core | `cat` with syntax highlighting |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | core | fast recursive search |
| [fd](https://github.com/sharkdp/fd) | core | fast file find |
| [jq](https://github.com/jqlang/jq) | core | JSON processor |
| [direnv](https://direnv.net/) | core | per-directory environment activation |
| [shellcheck](https://www.shellcheck.net/) | core | shell script linting |
| [pass](https://www.passwordstore.org/) | core | Unix password store (agent-blocked) |
| [age](https://github.com/FiloSottile/age) / [sops](https://github.com/getsops/sops) | optional | file/secret encryption |
| [jj](https://github.com/jj-vcs/jj) | optional | Git-compatible VCS alternative |
| [skim](https://github.com/skim-rs/skim) | optional | Rust fuzzy finder (fzf alternative) |
| [zellij](https://github.com/zellij-org/zellij) | optional | terminal workspace (tmux alternative) |
| [Fabric](https://github.com/danielmiessler/fabric) | planned | AI-augmentation patterns runnable from the shell |

Dotfiles practice and bootstrap inspiration: [dotfiles.github.io](https://dotfiles.github.io/)
(utilities, frameworks, bootstrap, tips). WfOS integrates low-level tooling in this spirit —
small, composable, dotfile-friendly.

## Monorepo & toolchains

| Tool | Status | Role |
|------|--------|------|
| [proto](https://moonrepo.dev/proto) | core | pins and installs workspace toolchains (`.prototools`) |
| [moon](https://moonrepo.dev/moon) | core | project graph, task running, caching |
| [starbase](https://github.com/moonrepo/starbase) | planned | Rust framework for the Kraken CLI |
| [mise](https://mise.jdx.dev/) | core | runtime/version manager (Dust default) |

See [monorepo.md](monorepo.md).

## Runtime engine — Rust crates

The engine under [Kraken](kraken.md); see [runtime-architecture.md](runtime-architecture.md).

| Crate / spec | Status | Role |
|--------------|--------|------|
| [Tokio](https://crates.io/crates/tokio) | planned | async runtime + subprocess proxying |
| [clap](https://crates.io/crates/clap) | planned | CLI argument/command parsing |
| [Ratatui](https://crates.io/crates/ratatui) | planned | terminal UI (TUI phase) |
| [Serde](https://crates.io/crates/serde) | planned | config/profile parsing (TOML-first) |
| [Orka](https://crates.io/crates/orka) | planned | pluggable async DAG workflow engine (candidate) |
| [Zenoh](https://crates.io/crates/zenoh) | planned | pub/sub data fabric (federation/multi-process) |
| [rmcp](https://crates.io/crates/rmcp) / [MCP](https://modelcontextprotocol.io) | planned | expose native commands as LLM tools |

## Web & docs publishing

| Tool | Status | Role |
|------|--------|------|
| [Zola](https://www.getzola.org/) | planned | static-site generator for `apps/docs` and `apps/web` |
| [Typst](https://typst.app/) | planned | production/publish-grade docs and whitepapers |

See [apps.md](apps.md).

## AI enhancements (selectable in the setup flow)

These are **opt-in**: the planned setup flow ([setup.md](setup.md)) presents them as choices,
each with a description, so a developer or agent installs only what they want. None are
required for WfOS to be useful.

| Tool | Status | What it does |
|------|--------|--------------|
| [RTK (Rust Token Killer)](https://github.com/rtk-ai/rtk) | optional | CLI proxy that compresses command output to cut LLM token use 60–90%; single Rust binary |
| [ponytail](https://github.com/DietrichGebert/ponytail) | optional | forces the simplest, most minimal solution that works (anti-over-engineering) |
| [drawio-skill](https://github.com/Agents365-ai/drawio-skill) | optional | generate diagrams/flowcharts as draw.io files and export images |
| [SkillSpector](https://github.com/nvidia/skillspector) | optional | security scanner for AI agent skills — detect vulnerabilities and malicious patterns |
| [Handy](https://github.com/cjpais/Handy) | optional | free, offline, extensible speech-to-text |
| [improve](https://github.com/shadcn/improve) | optional | survey a codebase and produce prioritized, self-contained improvement plans |
| [OpenRouter](https://openrouter.ai/) | optional | low-level model-adapter / AI-routing layer for building tools (not a high-level agent UI) |
| [Fabric](https://github.com/danielmiessler/fabric) | optional | crowdsourced AI prompt "patterns" usable anywhere |

OpenRouter is the intended substrate for model adapters and routing inside WfOS-built tools —
a primitive to build on, not a replacement for an agent CLI.

## Native / local apps

| App | Status | Role |
|-----|--------|------|
| [Obsidian](https://obsidian.md/) | planned | local notes for shared context without vendor lock-in (first phase) |
| [open-notebook](https://github.com/lfnovo/open-notebook) | planned | AI-assisted notes; proof-of-concept for the Mindflow idea |

## WASM / WASI runtimes

The portable execution target; see [ether.md](ether.md).

| Project | Status | Role |
|---------|--------|------|
| [WASI](https://github.com/WebAssembly/WASI) | planned | system interface spec for portable components |
| [Wasmtime](https://wasmtime.dev/) | core | WASM/WASI runtime (Dust `ether` module) |
| [Spin](https://github.com/spinframework/spin) | inspiration | event-driven WASM apps without a container layer |
| [wasmCloud](https://github.com/wasmcloud/wasmcloud) | inspiration | distributed platform for WASM components |
| [Hyperlight Wasm](https://opensource.microsoft.com/blog/2025/03/26/hyperlight-wasm-fast-secure-and-os-free/) | inspiration | micro-VM isolation for WASM |

## Network & security

Local-first today; relevant when work spans machines (federation).

| Tool | Status | Role |
|------|--------|------|
| [WireGuard](https://www.wireguard.com/) | planned | fast, modern VPN tunnel |
| [Tailscale](https://tailscale.com/) | planned | managed WireGuard mesh |
| [Headscale](https://github.com/juanfont/headscale) | planned | self-hosted Tailscale control server |
| [SoftEther](https://www.softether.org/) | inspiration | multi-protocol VPN |

## Workflow inspirations

Local-first workflow apps that prove ideas WfOS borrows from (window/session/space layouts,
scattered-knowledge capture). Reference, not dependencies.

| App | Idea |
|-----|------|
| Decks | bringing scattered knowledge back together |
| [Freeter](https://freeter.io/) | organizing tools and resources per workflow |
| [FlashSpace](https://github.com/wojciech-kulik/FlashSpace) | fast virtual workspace/space switching |
| [Spaces](https://spacesformac.xyz/) | per-context window and app layouts |
