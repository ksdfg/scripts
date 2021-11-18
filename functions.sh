#!/usr/bin/env bash

# Some functions for easier life

# update everything
update() {
    # update icon pack
    # echo "----- updating icon theme -----"
    # cd "$HOME"/.icons/candy-icons || exit
    # git fetch
    # git pull origin master
    # cd - >/dev/null || exit
    # echo

    # update heroku cli
    echo "--- updating heroku cli ---"
    heroku update

    # update libraries
    echo "\n----- updating libraries -----"
    if [[ $1 == "-m" ]]; then
        sudo echo "Updating mirror list may take a while ..." # sudo here just so that it asks for pwd before showing this string
        sudo reflector --latest 200 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    fi
    yay

    # update scripts upstream
    echo "\n----- updating scripts upstream -----"
    sudo cp "$HOME"/.zshrc "$HOME"/scripts/.zshrc
    sudo cp "$HOME"/.gitconfig "$HOME"/scripts/.gitconfig
    sudo cp "$HOME"/.p10k.zsh "$HOME"/scripts/.p10k.zsh
    sudo cp -TR "$HOME"/.oh-my-zsh/. "$HOME"/scripts/.oh-my-zsh/
    yay -Qq >"$HOME"/scripts/packages.txt
    cd "$HOME"/scripts || exit
    git c -am "automated update"
    git p
    cd - >/dev/null || exit
}

# update stuff and get lost
bbye() {
    update "$*" && poweroff
}

# update stuff and reboot
rebye() {
    update "$*" && reboot
}

# connect to JBL headphones
jbl() {
    echo -en "\033]0;Connecting to JBL headphones\a"
    bluetoothctl power on
    if bluetoothctl connect ${JBL}; then
        bluetooth_battery ${JBL}.1
    fi
}

# create a git repo and set navana user configs
git-navana() {
    git config user.email "kshitish@navanatech.in"
    git config user.name "Kshitish Deshpande"
    git config user.signingkey 38AA49997E22451B5536A8F8543211343CAA6F66
}
