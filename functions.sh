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
    #echo "--- updating heroku cli ---"
    #heroku update

    # update libraries
    echo "----- updating libraries -----"
    if [[ $1 == "-m" ]]; then
        sudo echo "Updating mirror list may take a while ..." # sudo here just so that it asks for pwd before showing this string
        sudo reflector --latest 200 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    fi
    yay

    # update scripts upstream
    echo "\n----- updating scripts upstream -----"
    sudo cp "$HOME"/.zshrc "$HOME"/.scripts/.zshrc
    sudo cp "$HOME"/.gitconfig "$HOME"/.scripts/.gitconfig
    sudo cp "$HOME"/.p10k.zsh "$HOME"/.scripts/.p10k.zsh
    yay -Qeq >"$HOME"/.scripts/packages.txt
    cd "$HOME"/.scripts || exit
    git c -am "automated update"
    git p
    cd - >/dev/null || exit
}

docker-prune() {
	# prune docker resources eating up space for no reason
    echo "\n----- pruning docker resources -----"
	docker system prune --volumes --force
}

# update stuff and get lost
bbye() {
    update "$*" && docker-prune && poweroff
}

# update stuff and reboot
rebye() {
    update "$*" && docker-prune && reboot
}

# clean cache
clear-cache() {
    echo "space before cleanup"
    echo "--------------------"
    df / -h

    echo
    echo "cleaning cache"
    echo "--------------"
    yay -Scc
    rm -rf ~/.cache/*
    go clean -testcache -modcache

    echo
    echo "space after cleanup"
    echo "--------------------"
    df / -h
}
