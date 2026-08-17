# macOS bootstrap for Vic's portable development/agent stack.
# Run with: brew bundle --file ~/dotfiles/Brewfile

# homebrew/bundle and homebrew/services were deprecated and emptied upstream;
# `brew bundle` and `brew services` are built into Homebrew now. Tapping them fails.
tap "hashicorp/tap"
tap "jesseduffield/lazygit"
tap "joshmedeski/sesh"
tap "qmk/qmk"

# Shell / dotfile basics
brew "git"
brew "git-lfs"
brew "gh"
brew "stow"
brew "neovim" # config/.config/nvim is stowed by install.sh; .zshrc aliases vim=nvim
brew "zsh"
brew "tmux"
brew "sesh"
brew "fzf"
brew "ripgrep"
brew "fd"
brew "jq"
brew "yq"
brew "bat"
brew "eza"
brew "zoxide"
brew "lazygit"
brew "btop"
brew "duf"
brew "tldr"
brew "wget"
brew "coreutils"
brew "gnu-sed"
brew "gnupg"
brew "pinentry-mac"
brew "mas"

# Language/toolchains
brew "nvm"
brew "pnpm"
brew "bun"
brew "python"
brew "uv"
brew "go"
brew "golangci-lint"
brew "gopls"
brew "rust"
brew "rust-analyzer"
brew "openjdk@17"
brew "node" # fallback/system node; pi stack should normally use nvm-managed Node 24+

# Dev infrastructure
brew "awscli"
brew "docker-compose"
brew "kubernetes-cli"
brew "kubectx"
brew "helm"
brew "hashicorp/tap/terraform"
brew "postgresql@16"
brew "libpq"
brew "protobuf"
brew "graphviz"
brew "libimobiledevice"
brew "pillow"
brew "rover"
brew "sbt"
brew "nmap"
brew "hurl"
brew "tailscale"

# Editors / terminals / local apps
cask "1password"
cask "1password-cli" # ships as a cask, not a formula
cask "amethyst"
cask "basictex"
cask "ghostty"
cask "cursor"
cask "visual-studio-code"
cask "docker"
cask "google-chrome"
cask "firefox"
cask "obsidian"
cask "slack"
cask "zoom"
cask "postman"
cask "android-studio"

# Fonts
cask "font-meslo-lg-nerd-font"
cask "font-fira-code"
cask "font-fira-code-nerd-font"

# Optional keyboard / embedded tooling kept from the old Mac setup
brew "qmk/qmk/qmk"
