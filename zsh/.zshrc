# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# Powerlevel10k instant prompt. Keep near top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Platform / package-manager setup.
case "$(uname -s)" in
  Darwin)
    export IS_MACOS=1
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
    ;;
  Linux)
    export IS_LINUX=1
    ;;
esac

# oh-my-zsh location varies by installer/package manager.
if [[ -z "${ZSH:-}" ]]; then
  for candidate in \
    "$HOME/.oh-my-zsh" \
    "${HOMEBREW_PREFIX:-}/share/oh-my-zsh" \
    "/usr/share/oh-my-zsh"; do
    if [[ -s "$candidate/oh-my-zsh.sh" ]]; then
      export ZSH="$candidate"
      break
    fi
  done
fi

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_CUSTOM="${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}"

plugins=(git)
if [[ -n "${ZSH:-}" ]]; then
  [[ -d "$ZSH/plugins/fzf" ]] && plugins+=(fzf)
  for plugin in zsh-vi-mode zsh-autosuggestions; do
    if [[ -d "$ZSH_CUSTOM/plugins/$plugin" || -d "$ZSH/plugins/$plugin" ]]; then
      plugins+=("$plugin")
    fi
  done
fi

if [[ -s "${ZSH:-}/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# Prompt config. Cursor Agent gets a simpler shell.
if [[ -z "$CURSOR_AGENT" && -r "$HOME/.p10k.zsh" ]]; then
  source "$HOME/.p10k.zsh"
fi

# Tool homes.
export GOPATH="${GOPATH:-$HOME/go}"
export GOBIN="${GOBIN:-$GOPATH/bin}"
export PYTHONBIN="${PYTHONBIN:-$HOME/.local/bin}"
export CARGOBIN="${CARGOBIN:-$HOME/.cargo/bin}"
export LOCALBIN="${LOCALBIN:-$HOME/bin}"
export FLYBIN="${FLYBIN:-$HOME/.fly}"

if [[ -n "${IS_MACOS:-}" ]]; then
  export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
  if [[ -z "${JAVA_HOME:-}" && -x /usr/libexec/java_home ]]; then
    JAVA_HOME="$(/usr/libexec/java_home -v 17 2>/dev/null || /usr/libexec/java_home 2>/dev/null || true)"
    [[ -n "$JAVA_HOME" ]] && export JAVA_HOME
  fi
  export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"
elif [[ -n "${IS_LINUX:-}" ]]; then
  export ANDROID_HOME="${ANDROID_HOME:-$HOME/Android/Sdk}"
  [[ -z "${JAVA_HOME:-}" && -d /usr/lib/jvm/java-17-openjdk ]] && export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
  export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
fi

# Deduplicated PATH. zsh's path array keeps this readable and portable.
typeset -U path
path=(
  "$LOCALBIN"
  "$PYTHONBIN"
  "$CARGOBIN"
  "$GOBIN"
  "$FLYBIN"
  "$PNPM_HOME"
  "${HOMEBREW_PREFIX:-}/opt/openjdk/bin"
  "${HOMEBREW_PREFIX:-}/opt/avr-gcc@8/bin" # keg-only; QMK pins avr-gcc 8
  "$ANDROID_HOME/platform-tools"
  "$ANDROID_HOME/cmdline-tools/latest/bin"
  "$ANDROID_HOME/emulator"
  $path
)
export PATH

# Runtime initializers.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

if command -v wt >/dev/null 2>&1; then
  # Wrap `wt switch` inside tmux so worktrees become windows in the current repo session.
  if (( $+functions[wt] )); then
    functions[_wt_original]="$functions[wt]"

    _tg_worktree_window_name() {
      emulate -L zsh
      local target="$1"
      local base="${target:t}"
      local slug name rest

      slug="$(printf '%s' "$base" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g')"
      [[ -z "$slug" ]] && slug="worktree"

      if [[ "$slug" =~ '([a-z]+-[0-9]+)-?(.*)' ]]; then
        name="$match[1]"
        rest="$match[2]"
        [[ -n "$rest" ]] && name="$name-$rest"
      else
        name="$slug"
      fi

      if (( ${#name} > 42 )); then
        name="${name[1,42]}"
        name="${name%-}"
      fi

      printf '%s' "$name"
    }

    _tg_select_or_create_worktree_window() {
      emulate -L zsh
      local target="$1"
      shift

      local found window_name new_id shell_cmd

      if [[ "$PWD" == "$target" ]]; then
        tmux set-window-option @worktree_path "$target" >/dev/null 2>&1 || true
        return
      fi

      found="$(tmux list-windows -F '#{window_id}\t#{@worktree_path}' 2>/dev/null | awk -F '\t' -v target="$target" '$2 == target { print $1; exit }')"

      if [[ -z "$found" ]]; then
        found="$(tmux list-windows -F '#{window_id}\t#{pane_current_path}' 2>/dev/null | awk -F '\t' -v target="$target" '$2 == target { print $1; exit }')"
      fi

      if [[ -n "$found" ]]; then
        tmux set-window-option -t "$found" @worktree_path "$target" >/dev/null 2>&1 || true
        tmux select-window -t "$found"
        return
      fi

      window_name="$(_tg_worktree_window_name "$target")"
      if (( $# > 0 )); then
        local -a quoted
        quoted=("${(@q)@}")
        shell_cmd="${(j: :)quoted}"
        new_id="$(tmux new-window -P -F '#{window_id}' -c "$target" -n "$window_name" "$shell_cmd")"
      else
        new_id="$(tmux new-window -P -F '#{window_id}' -c "$target" -n "$window_name")"
      fi
      tmux set-window-option -t "$new_id" @worktree_path "$target" >/dev/null 2>&1 || true
    }

    wt() {
      if [[ -n "$TMUX" && "${1:-}" == "switch" && -n "${commands[tmux]:-}" ]]; then
        local cd_file exec_file exit_code=0 target arg passthrough_mode=0
        local -a wt_args passthrough
        wt_args=()
        passthrough=()

        for arg in "$@"; do
          if (( passthrough_mode )); then
            passthrough+=("$arg")
          elif [[ "$arg" == "--" ]]; then
            passthrough_mode=1
          else
            wt_args+=("$arg")
          fi
        done

        cd_file="$(mktemp)"
        exec_file="$(mktemp)"
        WORKTRUNK_DIRECTIVE_CD_FILE="$cd_file" WORKTRUNK_DIRECTIVE_EXEC_FILE="$exec_file" command "${WORKTRUNK_BIN:-wt}" "${wt_args[@]}" || exit_code=$?
        if [[ $exit_code -eq 0 && -s "$cd_file" ]]; then
          target="$(<"$cd_file")"
          if [[ -n "$target" && -d "$target" ]]; then
            _tg_select_or_create_worktree_window "$target" "${passthrough[@]}"
          fi
        fi
        if [[ -s "$exec_file" ]]; then
          source "$exec_file"
        fi
        rm -f "$cd_file" "$exec_file"
        return "$exit_code"
      fi
      _wt_original "$@"
    }
  fi

  alias ws='wt switch'
  alias wsc='wt switch --create'
fi

if command -v tmux-glance >/dev/null 2>&1; then
  alias tg='tmux-glance'
fi

# Node / nvm. Prefer a user install, then Homebrew, then Arch package init.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
elif [[ -n "${HOMEBREW_PREFIX:-}" && -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]]; then
  source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]] && source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
elif [[ -s /usr/share/nvm/init-nvm.sh ]]; then
  source /usr/share/nvm/init-nvm.sh
fi

# Google Cloud SDK, if manually unpacked.
if [[ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]]; then
  source "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
fi
if [[ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]]; then
  source "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"
fi

# Private aliases/secrets live outside dotfiles.
[[ -r "$HOME/.private_commands.sh" ]] && source "$HOME/.private_commands.sh"

# Aliases.
command -v bat >/dev/null 2>&1 && alias cat="bat"
command -v eza >/dev/null 2>&1 && alias ls="eza"
alias vim="nvim"
alias oldvim="\vim"
alias lg="lazygit"
alias nx="npx --no-install nx"
alias k="kubectl"
alias kns="kubens"
alias kx="kubectx"
alias gcrb='git for-each-ref --sort=-committerdate --count=30 --format='\''%(refname:short)'\'' refs/heads/ | fzf --height=20% --reverse --info=inline | xargs git checkout'

# Docker cleanup helpers.
removecontainers() {
  docker stop $(docker ps -aq)
  docker rm $(docker ps -aq)
}

armageddon() {
  removecontainers
  docker network prune -f
  docker rmi -f $(docker images --filter dangling=true -qa)
  docker volume rm $(docker volume ls --filter dangling=true -q)
  docker rmi -f $(docker images -qa)
}

# Clean stale Firefox lock before launching on Linux.
if [[ -n "${IS_LINUX:-}" ]]; then
  firefox() {
    rm -f ~/.mozilla/firefox/*.default-release/.parentlock 2>/dev/null
    command firefox "$@"
  }
fi

# Warm QMD embedding model on shell startup (detached, silent).
for memento_bin in \
  "$HOME/Projects/memento-vault/bin/memento-vault" \
  "$HOME/Personal/memento-vault/bin/memento-vault"; do
  if [[ -x "$memento_bin" ]]; then
    "$memento_bin" warmup >/dev/null 2>&1 &!
    break
  fi
done

# --- Claude Code account split (work = default ~/.claude, personal = ~/Personal/.claude-config)
# An `alias claude='claude <flags>'` may exist from earlier config; absorb its flags
# into the routing function (aliases and functions can't share the name in zsh).
if [[ -n ${aliases[claude]:-} ]]; then
  _claude_default_flags=(${(z)${aliases[claude]#claude}})
  unalias claude
else
  _claude_default_flags=()
fi
# auto-switch: any repo under ~/Personal uses the personal subscription
'claude'() {
  case "$PWD/" in
    "$HOME/Personal/"*) CLAUDE_CONFIG_DIR="$HOME/Personal/.claude-config" command claude "${_claude_default_flags[@]}" "$@" ;;
    *) command claude "${_claude_default_flags[@]}" "$@" ;;
  esac
}
alias claude-personal='CLAUDE_CONFIG_DIR="$HOME/Personal/.claude-config" command claude'


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

if [[ "$TERM_PROGRAM" == "kiro" ]] && command -v kiro >/dev/null 2>&1; then
  source "$(kiro --locate-shell-integration-path zsh)"
fi
