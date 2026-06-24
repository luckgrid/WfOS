# WfOS Dust — shell activation fragment (zsh).
# Sourced from ~/.zshrc by `dust bootstrap`. Every activation is guarded so this
# file is safe to source even when a tool is not installed.

# Dust home + CLI on PATH (also symlinked into ~/.local/bin during bootstrap).
# Default layout is a suggestion (Workstreams/Build/…); override by exporting
# DUST_HOME in ~/.zshenv or before sourcing — e.g. when wfos lives elsewhere.
export DUST_HOME="${DUST_HOME:-$HOME/Workstreams/Build/src/workspaces/wfos/packages/dust}"
case ":$PATH:" in
  *":$DUST_HOME/bin:"*) ;;
  *) export PATH="$DUST_HOME/bin:$PATH" ;;
esac

# Tool version manager (Dust default). Activated after proto so mise manages
# Dust-scoped runtimes; proto remains available for existing workflows.
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"

# Per-directory environments.
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# Prompt.
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Smarter cd.
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# Fuzzy finder key bindings + completion (fzf >= 0.48).
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh) 2>/dev/null || true
fi

# Modern coreutils-style aliases when available.
command -v eza >/dev/null 2>&1 && alias ls='eza' && alias ll='eza -l --git' && alias la='eza -la --git'
command -v bat >/dev/null 2>&1 && alias cat='bat --paging=never'

# RTK output-compression layer (recommended-default; swappable via DUST_RTK).
# Skipped when the chezmoi layer manages it (DUST_RTK_MANAGED=1) to avoid double-sourcing;
# the chezmoi fragment sets DUST_RTK from profile data, then sources this same file.
if [ -z "${DUST_RTK_MANAGED:-}" ]; then
  _dust_rtk_frag="${DUST_HOME:-$HOME/Workstreams/Build/src/workspaces/wfos/packages/dust}/config/shell/rtk.zsh"
  [ -f "$_dust_rtk_frag" ] && source "$_dust_rtk_frag"
  unset _dust_rtk_frag
fi

# Zsh plugins (Homebrew, sourced files — guarded so missing plugins are harmless).
# Order matters: autosuggestions/autocomplete first, syntax-highlighting LAST.
# Skipped when the chezmoi plugin layer manages plugins — it sets DUST_PLUGINS_MANAGED=1
# and sources its own profile-aware fragment, so this block stands down to avoid double-sourcing.
if [ -z "${DUST_PLUGINS_MANAGED:-}" ]; then
  _dust_brew_prefix="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null)}"
  if [ -n "$_dust_brew_prefix" ]; then
    [ -f "$_dust_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
      source "$_dust_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    # zsh-autocomplete is optional and can conflict with other completion setups.
    [ -f "$_dust_brew_prefix/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ] && \
      source "$_dust_brew_prefix/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
    # Must be sourced last to wrap the final widget set.
    [ -f "$_dust_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
      source "$_dust_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi
  unset _dust_brew_prefix
fi
