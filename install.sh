#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
DO_STOW=1
DO_AI=1
DO_MEMENTO=1
DO_PI_EXTENSIONS=1
DO_BEISLID=1
DO_CLONE_OPEN_SOURCE=1
DO_MCP_REMOTE=1
DO_WORKTRUNK=1
FORCE_LINKS_VALUE="${FORCE_LINKS:-0}"
STATUS=0

MEMENTO_REPO="${MEMENTO_REPO:-$HOME/Projects/memento-vault}"
PI_EXTENSIONS_REPO="${PI_EXTENSIONS_REPO:-$HOME/Personal/pi-extensions}"
BEISLID_REPO="${BEISLID_REPO:-$HOME/Personal/beislid/main}"
MEMENTO_REPO_URL="${MEMENTO_REPO_URL:-https://github.com/sandsower/memento-vault.git}"
PI_EXTENSIONS_REPO_URL="${PI_EXTENSIONS_REPO_URL:-https://github.com/sandsower/pi-extensions.git}"
BEISLID_REPO_URL="${BEISLID_REPO_URL:-https://github.com/sandsower/beislid.git}"
MCP_REMOTE_VERSION="${MCP_REMOTE_VERSION:-0.1.38}"
WORKTRUNK_VERSION="${WORKTRUNK_VERSION:-0.46.1}"
if [ -z "${MEMENTO_VAULT_PATH:-}" ] && [ -d "$HOME/Personal/memento" ]; then
  MEMENTO_VAULT_PATH="$HOME/Personal/memento"
else
  MEMENTO_VAULT_PATH="${MEMENTO_VAULT_PATH:-$HOME/memento}"
fi

usage() {
  cat <<'EOF'
Dotfiles installer

Usage: ./install.sh [flags]

Default run:
  - stows config/, git/, and zsh/
  - links safe AI agent config from ai/
  - clones public/open-source setup repos when missing
  - installs Memento Vault
  - installs personal pi extensions
  - installs Beislið skills
  - installs pinned mcp-remote when npm is available
  - installs pinned Worktrunk CLI when cargo is available

Flags:
  --status              Print detected install state and exit
  --dry-run             Print commands without running them
  --no-stow             Skip GNU Stow links
  --no-ai               Skip ai/link-agent-config.sh
  --no-memento          Skip Memento Vault install
  --no-pi-extensions    Skip pi install for personal pi extensions
  --no-beislid          Skip Beislið skill install
  --no-clone            Do not clone missing public setup repos
  --no-mcp-remote       Do not install mcp-remote with npm
  --no-worktrunk        Do not install Worktrunk CLI with cargo
  --force-links         Repoint existing symlinks managed by ai/link-agent-config.sh
  -h, --help            Show this help

Agent use:
  A clean Claude/Codex/pi session can read AGENTS.md, run --status,
  install safe missing prerequisites after approval, run --dry-run,
  then run this installer and verify the reported agent surfaces.

Environment overrides:
  MEMENTO_REPO          Checkout path for memento-vault (default: ~/Projects/memento-vault)
  MEMENTO_REPO_URL      Public clone URL for memento-vault
  MEMENTO_VAULT_PATH    Vault path passed to memento-vault installer (default: ~/Personal/memento when present, else ~/memento)
  PI_EXTENSIONS_REPO    Checkout path for personal pi extensions (default: ~/Personal/pi-extensions)
  PI_EXTENSIONS_REPO_URL Public clone URL for personal pi extensions
  BEISLID_REPO          Checkout path for Beislið skills (default: ~/Personal/beislid/main)
  BEISLID_REPO_URL      Public clone URL for Beislið skills
  MCP_REMOTE_VERSION    mcp-remote npm version (default: 0.1.38)
  WORKTRUNK_VERSION     Worktrunk cargo version (default: 0.46.1)
  FORCE_LINKS           Set to 1 to repoint existing AI config symlinks

Security boundary:
  This installer does not install secrets and does not clone private repos.
  It only clones the public/open-source repos named above. Restore API keys,
  auth files, trusted project roots, and work-specific overlays separately.
EOF
}

log() { printf '==> %s\n' "$*"; }
warn() { printf 'warn: %s\n' "$*" >&2; }
run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '+ %q' "$1"
    shift || true
    for arg in "$@"; do printf ' %q' "$arg"; done
    printf '\n'
  else
    "$@"
  fi
}

for arg in "$@"; do
  case "$arg" in
    --status) STATUS=1 ;;
    --dry-run) DRY_RUN=1 ;;
    --no-stow) DO_STOW=0 ;;
    --no-ai) DO_AI=0 ;;
    --no-memento) DO_MEMENTO=0 ;;
    --no-pi-extensions) DO_PI_EXTENSIONS=0 ;;
    --no-beislid) DO_BEISLID=0 ;;
    --no-clone) DO_CLONE_OPEN_SOURCE=0 ;;
    --no-mcp-remote) DO_MCP_REMOTE=0 ;;
    --no-worktrunk) DO_WORKTRUNK=0 ;;
    --force-links) FORCE_LINKS_VALUE=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown flag: $arg" >&2; usage >&2; exit 2 ;;
  esac
done

status() {
  echo "dotfiles root: $ROOT"
  command -v stow >/dev/null 2>&1 && echo "stow: $(command -v stow)" || echo "stow: missing"
  command -v pi >/dev/null 2>&1 && echo "pi: $(command -v pi)" || echo "pi: missing"
  command -v mcp-remote >/dev/null 2>&1 && echo "mcp-remote: $(command -v mcp-remote)" || echo "mcp-remote: missing"
  command -v wt >/dev/null 2>&1 && echo "worktrunk: $(command -v wt)" || echo "worktrunk: missing"
  [ -d "$MEMENTO_REPO" ] && echo "memento repo: $MEMENTO_REPO" || echo "memento repo: missing ($MEMENTO_REPO)"
  [ -d "$PI_EXTENSIONS_REPO" ] && echo "pi extensions repo: $PI_EXTENSIONS_REPO" || echo "pi extensions repo: missing ($PI_EXTENSIONS_REPO)"
  [ -d "$BEISLID_REPO" ] && echo "beislid repo: $BEISLID_REPO" || echo "beislid repo: missing ($BEISLID_REPO)"
  echo "clone public repos: $([ "$DO_CLONE_OPEN_SOURCE" -eq 1 ] && echo yes || echo no)"
  [ -d "$MEMENTO_VAULT_PATH" ] && echo "memento vault: $MEMENTO_VAULT_PATH" || echo "memento vault: missing ($MEMENTO_VAULT_PATH)"
}

if [ "$STATUS" -eq 1 ]; then
  status
  exit 0
fi

log "preflight"
status

normalize_git_url() {
  printf '%s' "$1" \
    | sed 's#^git@github.com:#https://github.com/#' \
    | sed 's#\.git$##'
}

repo_origin_matches() {
  local path="$1"
  local expected="$2"
  local origin
  origin="$(git -C "$path" remote get-url origin 2>/dev/null || true)"
  [ -n "$origin" ] && [ "$(normalize_git_url "$origin")" = "$(normalize_git_url "$expected")" ]
}

clone_repo_if_missing() {
  local name="$1"
  local path="$2"
  local url="$3"
  if git -C "$path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if repo_origin_matches "$path" "$url"; then
      log "$name repo already present"
      return 0
    fi
    warn "$name repo exists at $path but origin does not match expected public URL; leaving it untouched"
    return 1
  fi
  if [ -e "$path" ]; then
    warn "$name path exists but is not a git checkout: $path; leaving it untouched"
    return 1
  fi
  if [ "$DO_CLONE_OPEN_SOURCE" -ne 1 ]; then
    warn "$name repo missing at $path; rerun without --no-clone or clone it separately"
    return 1
  fi
  if ! command -v git >/dev/null 2>&1; then
    warn "git missing; cannot clone $name"
    return 1
  fi
  log "cloning $name"
  run mkdir -p "$(dirname "$path")"
  run git clone "$url" "$path"
}

ensure_memento_pi_package() {
  local settings="$HOME/.pi/agent/settings.json"
  if ! command -v pi >/dev/null 2>&1; then
    return 0
  fi
  if ! command -v python3 >/dev/null 2>&1; then
    warn "python3 missing; cannot safely register filtered Memento pi package"
    warn "install python3, then rerun this installer"
    return 0
  fi
  log "installing Memento pi package with generic-skill filter"
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '+ normalize %q packages entry for %q with skills filter %q\n' "$settings" "$MEMENTO_REPO" "skills/generic"
    return 0
  fi
  mkdir -p "$(dirname "$settings")"
  python3 - "$settings" "$MEMENTO_REPO" <<'PY'
import json
import os
import sys
from pathlib import Path

settings_path = Path(sys.argv[1]).expanduser()
repo_path = Path(sys.argv[2]).expanduser().resolve()
settings_dir = settings_path.parent
source = os.path.relpath(repo_path, settings_dir)
if not source.startswith("."):
    source = f"./{source}"

if settings_path.exists():
    try:
        data = json.loads(settings_path.read_text())
    except json.JSONDecodeError as exc:
        raise SystemExit(f"invalid pi settings JSON at {settings_path}: {exc}")
else:
    data = {}

packages = data.get("packages", [])
if not isinstance(packages, list):
    raise SystemExit(f"invalid pi settings packages value at {settings_path}: expected list")


def package_source(entry):
    if isinstance(entry, str):
        return entry
    if isinstance(entry, dict) and isinstance(entry.get("source"), str):
        return entry["source"]
    return None


def resolves_to_repo(src):
    if src is None:
        return False
    if src.startswith(("npm:", "git:", "http://", "https://", "ssh://", "git://")):
        return False
    return (settings_dir / src).expanduser().resolve() == repo_path

filtered = [entry for entry in packages if not resolves_to_repo(package_source(entry))]
filtered.append({"source": source, "skills": ["skills/generic"]})
data["packages"] = filtered
settings_path.write_text(json.dumps(data, indent=2) + "\n")
print(f"{settings_path}: Memento package filtered to skills/generic")
PY
}

if [ "$DO_MCP_REMOTE" -eq 1 ]; then
  if command -v mcp-remote >/dev/null 2>&1; then
    log "mcp-remote already installed; leaving existing executable untouched"
  elif command -v npm >/dev/null 2>&1; then
    log "installing mcp-remote@$MCP_REMOTE_VERSION"
    run npm install -g "mcp-remote@$MCP_REMOTE_VERSION"
  else
    warn "npm missing; cannot install mcp-remote@$MCP_REMOTE_VERSION"
  fi
fi

if [ "$DO_WORKTRUNK" -eq 1 ]; then
  if command -v wt >/dev/null 2>&1; then
    log "Worktrunk already installed; leaving existing executable untouched"
  elif command -v cargo >/dev/null 2>&1; then
    log "installing worktrunk@$WORKTRUNK_VERSION"
    run cargo install worktrunk --version "$WORKTRUNK_VERSION"
  else
    warn "cargo missing; cannot install worktrunk@$WORKTRUNK_VERSION"
  fi
fi

if [ "$DO_STOW" -eq 1 ]; then
  if command -v stow >/dev/null 2>&1; then
    log "stowing base dotfiles"
    run stow -d "$ROOT" -t "$HOME" config git zsh
  else
    warn "stow missing; install it or rerun with --no-stow"
  fi
fi

if [ "$DO_AI" -eq 1 ]; then
  log "linking safe AI config"
  run env FORCE_LINKS="$FORCE_LINKS_VALUE" "$ROOT/ai/link-agent-config.sh"
fi

if [ "$DO_MEMENTO" -eq 1 ]; then
  clone_repo_if_missing "Memento Vault" "$MEMENTO_REPO" "$MEMENTO_REPO_URL" || true
  if [ -x "$MEMENTO_REPO/install.sh" ]; then
    log "installing Memento Vault"
    run env MEMENTO_VAULT_PATH="$MEMENTO_VAULT_PATH" "$MEMENTO_REPO/install.sh" --experimental --mcp
    ensure_memento_pi_package
  else
    warn "Memento repo not found at $MEMENTO_REPO; clone/install it separately or set MEMENTO_REPO"
  fi
fi

if [ "$DO_PI_EXTENSIONS" -eq 1 ]; then
  clone_repo_if_missing "personal pi extensions" "$PI_EXTENSIONS_REPO" "$PI_EXTENSIONS_REPO_URL" || true
  if [ -d "$PI_EXTENSIONS_REPO" ]; then
    if command -v pi >/dev/null 2>&1; then
      log "installing personal pi extensions"
      run pi install "$PI_EXTENSIONS_REPO"
    else
      warn "pi missing; install pi before installing personal pi extensions"
    fi
  else
    warn "pi extensions repo not found at $PI_EXTENSIONS_REPO; clone it separately or set PI_EXTENSIONS_REPO"
  fi
fi

if [ "$DO_BEISLID" -eq 1 ]; then
  clone_repo_if_missing "Beislið" "$BEISLID_REPO" "$BEISLID_REPO_URL" || true
  if [ -x "$BEISLID_REPO/install.sh" ]; then
    log "installing Beislið skills"
    run "$BEISLID_REPO/install.sh" --with-security-hooks --with-pi-show-me
  else
    warn "Beislið repo not found at $BEISLID_REPO; clone/install it separately or set BEISLID_REPO"
  fi
fi

log "done"
cat <<'EOF'
Next manual steps:
- restore credentials from a password manager or ignored local env files
- add private/project-specific overlays outside this repo
- add Codex trusted project roots locally only
- run: ./install.sh --status
- restart pi/Claude/Codex sessions and run their status commands
EOF
