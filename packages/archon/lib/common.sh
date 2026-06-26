#!/usr/bin/env bash
# Archon shared helpers: paths, logging. Sourced by bin/ entrypoints.
# Archon is data and contracts; these helpers back the build-time metadata tasks
# (sync/validate) that generate and check the registry. They never install, read
# secrets, or edit dotfiles.

# Resolve a path, following symlinks, without requiring GNU readlink -f.
_archon_realpath() {
  local target="$1" dir link
  while [ -L "$target" ]; do
    link="$(readlink "$target")"
    case "$link" in
      /*) target="$link" ;;
      *) target="$(cd "$(dirname "$target")" && pwd)/$link" ;;
    esac
  done
  dir="$(cd "$(dirname "$target")" && pwd)"
  printf '%s/%s\n' "$dir" "$(basename "$target")"
}

# ARCHON_LIB = this file's dir; ARCHON_PKG = the archon package root.
ARCHON_LIB="$(cd "$(dirname "$(_archon_realpath "${BASH_SOURCE[0]}")")" && pwd)"
ARCHON_PKG="$(cd "$ARCHON_LIB/.." && pwd)"
ARCHON_DESCRIPTORS="$ARCHON_PKG/descriptors"
ARCHON_SCHEMAS="$ARCHON_PKG/schemas"
ARCHON_POLICIES="$ARCHON_PKG/policies"
ARCHON_GRAPHS="$ARCHON_PKG/graphs"
ARCHON_REGISTRY="$ARCHON_PKG/registry"
# wfos workspace root (…/workspaces/wfos), the workspaces dir, and Workstreams root.
# Layout: <WS_ROOT>/Build/src/workspaces/wfos — Workstreams is four levels above wfos.
WFOS_ROOT="$(cd "$ARCHON_PKG/../.." && pwd)"
WORKSPACES_DIR="$(cd "$WFOS_ROOT/.." && pwd)"
WS_ROOT="$(cd "$WFOS_ROOT/../../../.." && pwd)"
AGENTS_HOME="$WS_ROOT/.agents"

export ARCHON_LIB ARCHON_PKG ARCHON_DESCRIPTORS ARCHON_SCHEMAS ARCHON_POLICIES \
  ARCHON_GRAPHS ARCHON_REGISTRY WFOS_ROOT WORKSPACES_DIR WS_ROOT AGENTS_HOME

# ── logging ──────────────────────────────────────────────────────────────────
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  _C_RESET=$'\033[0m'; _C_DIM=$'\033[2m'; _C_BOLD=$'\033[1m'
  _C_GREEN=$'\033[32m'; _C_YELLOW=$'\033[33m'; _C_RED=$'\033[31m'; _C_BLUE=$'\033[34m'
else
  _C_RESET=''; _C_DIM=''; _C_BOLD=''; _C_GREEN=''; _C_YELLOW=''; _C_RED=''; _C_BLUE=''
fi

archon_info() { printf '%s\n' "${_C_BLUE}::${_C_RESET} $*"; }
archon_ok()   { printf '%s\n' "${_C_GREEN}ok${_C_RESET} $*"; }
archon_warn() { printf '%s\n' "${_C_YELLOW}!!${_C_RESET} $*" >&2; }
archon_err()  { printf '%s\n' "${_C_RED}xx${_C_RESET} $*" >&2; }
archon_die()  { archon_err "$*"; exit 1; }

# Require jq — the sanctioned, agent-safe query tool Archon builds on.
archon_require_jq() {
  command -v jq >/dev/null 2>&1 || archon_die "jq not found (Dust 'nav' module) — required for archon tasks"
}
