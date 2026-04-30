#!/usr/bin/env bash
set -euo pipefail

link_file() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "refusing to replace non-symlink: $dst" >&2
    return 1
  fi
  if [ -L "$dst" ]; then
    local current
    current="$(readlink "$dst")"
    if [ "$current" = "$src" ]; then
      echo "already linked: $dst -> $src"
      return 0
    fi
    if [ "${FORCE_LINKS:-0}" != "1" ]; then
      echo "refusing to repoint existing symlink: $dst -> $current" >&2
      echo "set FORCE_LINKS=1 to repoint it to: $src" >&2
      return 1
    fi
  fi
  ln -sfn "$src" "$dst"
  echo "$dst -> $src"
}

ROOT="${DOTFILES_DIR:-$HOME/dotfiles}"

link_file "$ROOT/ai/pi/settings.json" "$HOME/.pi/agent/settings.json"
link_file "$ROOT/ai/pi/mcp.json" "$HOME/.pi/agent/mcp.json"
link_file "$ROOT/ai/pi/keybindings.json" "$HOME/.pi/agent/keybindings.json"

link_file "$ROOT/ai/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link_file "$ROOT/ai/claude/portable-claude.md" "$HOME/.claude/portable-claude.md"
link_file "$ROOT/ai/claude/hooks/notify.sh" "$HOME/.claude/hooks/notify.sh"
link_file "$ROOT/ai/claude/agents/concierge.md" "$HOME/.claude/agents/concierge.md"

link_file "$ROOT/ai/codex/config.toml" "$HOME/.codex/config.toml"
link_file "$ROOT/ai/memento-vault/memento.yml" "$HOME/.config/memento-vault/memento.yml"
