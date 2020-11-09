#!/usr/bin/env bash

# Some functions for easier life

# update everything
update() {
    # update icon pack
    echo "----- updating icon theme -----"
    cd "$HOME"/.icons/candy-icons || exit
    git fetch
    git rebase -Xtheirs origin master
    cd - >/dev/null || exit

    # update heroku cli
    echo "\n--- updating heroku cli ---"
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
    cp "$HOME"/.zshrc "$HOME"/scripts/.zshrc
    cp "$HOME"/.gitconfig "$HOME"/scripts/.gitconfig
    cp "$HOME"/.p10k.zsh "$HOME"/scripts/.p10k.zsh
    sudo cp -urT "$HOME"/.oh-my-zsh/ "$HOME"/scripts/
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
    echo -en "\033]0;Connecting to JBL T450BT\a"
    bluetoothctl power on
    if bluetoothctl connect ${JBL}; then
        bluetooth_battery ${JBL}.1
    fi
}

# reset gcloud account and config after qwiklabs
gcloud-reset() {
    # reset account and project config
    for email in $(gcloud auth list --filter "account!=ksdfg123@gmail.com" --format "value(account)"); do
        gcloud auth revoke $email
    done
    gcloud config set account ksdfg123@gmail.com
    gcloud config set project madness-sense

    # reset kubeconfig
    rm $HOME/.kube/config

    # lot of labs require region/zone to be set
    gcloud config unset compute/zone
    gcloud config unset compute/region
}
