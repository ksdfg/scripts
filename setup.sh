#!/usr/bin/env bash

echo "Installing zsh if it wasn't present"
[[ "$(command -v zsh)" ]] || sudo pacman -S zsh

echo "Changing shell to zsh"
chsh -s /usr/bin/zsh

echo "Copying oh my zsh files"
cp -rv .oh-my-zsh $HOME/.oh-my-zsh

echo "Replacing .p10k.zsh"
cp -v .p10k.zsh $HOME/.p10k.zsh

echo "Replacing .zshrc"
cp -v .zshrc $HOME/.zshrc

echo "Replacing .gitconfig"
cp -v .gitconfig $HOME/.gitconfig
