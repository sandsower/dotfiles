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

if command -v wt >/dev/null 2>&1; then
  eval "$(wt config shell init zsh)"

  # Wrap wt so `wt switch` uses sesh inside tmux when available.
  if (( $+functions[wt] )); then
    functions[_wt_original]="$functions[wt]"
    wt() {
      if [[ -n "$TMUX" && "${1:-}" == "switch" && -n "${commands[sesh]:-}" ]]; then
        local directive_file exit_code=0
        directive_file="$(mktemp)"
        WORKTRUNK_DIRECTIVE_FILE="$directive_file" command "${WORKTRUNK_BIN:-wt}" "$@" || exit_code=$?
        if [[ $exit_code -eq 0 && -s "$directive_file" ]]; then
          local target
          target=$(sed "s/^cd '//;s/'$//" "$directive_file")
          sesh connect "$target"
        elif [[ -s "$directive_file" ]]; then
          source "$directive_file"
        fi
        rm -f "$directive_file"
        return "$exit_code"
      fi
      _wt_original "$@"
    }
  fi
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
if [[ -x "$HOME/Projects/memento-vault/bin/memento-vault" ]]; then
  "$HOME/Projects/memento-vault/bin/memento-vault" warmup >/dev/null 2>&1 &!
fi
