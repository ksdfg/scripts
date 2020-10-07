#!/usr/bin/env bash

echo "Installing zsh if it wasn't present"
[[ "$(command -v zsh)" ]] || sudo pacman -S zsh

echo "Changing shell to zsh"
chsh -s /usr/bin/zsh

echo "Replacing .zshrc"
cp -v .zshrc ~/.zshrc

echo "Replacing .gitconfig"
cp -v .gitconfig ~/.gitconfig
