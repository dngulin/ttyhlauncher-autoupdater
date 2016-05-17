#!/bin/bash

do_install() {
	echo "Self copy to local bin"
	mkdir -p "${HOME}/.local/bin/"
	cp "$0" "${HOME}/.local/bin/ttyhlauncher.sh"
	
	echo "Prepare local repositoy clone"
	mkdir -p "${HOME}/.local/src/"
	cd "${HOME}/.local/src/"

	echo "Clone repository..."
	git clone "https://github.com/dngulin/ttyhlauncher.git"
	cd "${HOME}/.local/src/ttyhlauncher"

	echo "Building sources..."
	qmake CONFIG+="unix_desktop" PREFIX="${HOME}/.local/"
	make
	make install
	
	post_install
}

post_install() {
	echo "Execute post-intsall changes"
	sed -i "s|Exec=ttyhlauncher|Exec=${HOME}/.local/bin/ttyhlauncher.sh start|" "${HOME}/.local/share/applications/ttyhlauncher.desktop"
	update-desktop-database
	echo "Done!"
}

do_start() {
	echo "Check for updates..."
	cd ${HOME}/.local/src/ttyhlauncher
	git pull
	qmake CONFIG+="unix_desktop" PREFIX="${HOME}/.local/"
	make
	make install
	
	post_install
	
	"${HOME}/.local/bin/ttyhlauncher"
}

do_uninstall() {

	echo "Removing local installed files..."
	
	echo "Removing local executables"
	rm "${HOME}/.local/bin/ttyhlauncher.sh";
	rm "${HOME}/.local/bin/ttyhlauncher";
	
	echo "Removing local data"
	rm "${HOME}/.local/share/applications/ttyhlauncher.desktop";
	rm "${HOME}/.local/share/icons/hicolor/scalable/apps/ttyhlauncher.svg";
	
	echo "Removing local repository clone"
	rm -rf "${HOME}/.local/src/ttyhlauncher";
	
	echo "Done!"
}

case $1 in

	"install")		do_install;;
	"start")		do_start;;
	"uninstall")	do_uninstall;;
	* )				echo "Use install, start or uninstall argument";;

esac

