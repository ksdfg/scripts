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

    echo "\n----- updating scripts upstream -----"

    # update zsh config
    sudo cp "$HOME"/.zshrc "$HOME"/.scripts/.zshrc

    # update gitconfig
    sudo cp "$HOME"/.gitconfig "$HOME"/.scripts/.gitconfig

    # update p10k config
    sudo cp "$HOME"/.p10k.zsh "$HOME"/.scripts/.p10k.zsh

    # update ssh config
    sudo cp "$HOME"/.ssh/id_rsa "$HOME"/.scripts/.ssh/id_rsa
    sudo cp "$HOME"/.ssh/id_rsa.pub "$HOME"/.scripts/.ssh/id_rsa.pub
    sudo cp "$HOME"/.ssh/id_navana "$HOME"/.scripts/.ssh/id_navana
    sudo cp "$HOME"/.ssh/id_navana.pub "$HOME"/.scripts/.ssh/id_navana.pub
    sudo cp "$HOME"/.ssh/config "$HOME"/.scripts/.ssh/config

    # update installed packages
    yay -Qeq >"$HOME"/.scripts/packages.txt

    # update scripts upstream
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
    echo "cleaning yay cache"
    echo "------------------"
    yay -Scc
    
    echo
    echo "cleaning local cache folder"
    echo "---------------------------"
    rm -rf ~/.cache/*
    
    echo
    echo "cleaning golang cache"
    echo "---------------------"
    go clean -testcache -modcache
    
    echo
    echo "cleaning docker cache"
    echo "---------------------"
    docker system prune --all --volumes --force
    
    echo
    echo "cleaning poetry cache"
    echo "---------------------"
    for cache in $(poetry cache list)                                                                                                                       
    do
        poetry cache clear $cache --all
    done

    echo
    echo "space after cleanup"
    echo "-------------------"
    df / -h
}
