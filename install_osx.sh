#!/bin/zsh

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Homebrew packages
brew bundle 

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install tmux plugins 
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack

# stow dotfiles
stow config
stow git
stow zsh
