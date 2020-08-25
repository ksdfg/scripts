# Some functions for easier life

# update everything
update() {
	# update icon pack
	echo "----- updating icon theme -----"
	cd /home/ksdfg/.icons/candy-icons
	git merge origin master
	cd - > /dev/null

	# update heroku cli
	echo "\n--- updating heroku cli ---"
	heroku update

	# update libraries
	echo "\n----- updating libraries -----"
	if [[ "$1" == "-m" ]]; then
		sudo echo "Updating mirror list may take a while ..."    # sudo here just so that it asks for pwd before showing this string
		sudo reflector --latest 200 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
	fi
	yay

	# update scripts upstream
	echo "\n----- updating scripts upstream -----"
	cp /home/ksdfg/.zshrc /home/ksdfg/scripts/.zshrc
	cp /home/ksdfg/.gitconfig /home/ksdfg/scripts/.gitconfig
	yay -Q > packages.txt
	cd /home/ksdfg/scripts
	git c -am "automated update"
	git p
	cd - > /dev/null
}

# update stuff and get lost
bbye() {
	update $* && poweroff
}

# update stuff and reboot
rebye() {
	update $* && reboot
}

# use yay to update packages and then back them up to packages.txt
aur() {
	yay $* && yay -Q > /home/ksdfg/scripts/packages.txt
}