#!/bin/zsh

 packages=(
 	celt
 	golangci-lint
 	google-chrome
 	grub-tools
 	oh-my-zsh-git
 	oh-my-zsh-powerline-theme-git
 	powerline-fonts-git
 	spotify
 	vuze
 	lazygit
 	alacritty
 	kubectl
 	docker
 	tmux
 )
sudo pacman -S "${packages[@]}"


# stow dotfiles
#stow config
#stow git
#stow zsh
