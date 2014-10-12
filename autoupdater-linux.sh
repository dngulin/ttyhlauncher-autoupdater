#!/bin/bash

do_install() {
	echo "Self copy to local bin"
	mkdir -p "${HOME}/.local/bin/"
	cp "$0" "${HOME}/.local/bin/ttyhlauncher.sh"
	
	echo "Prepare local repositoy clone"
	mkdir -p "${HOME}/.local/src/"
	cd "${HOME}/.local/src/"

	echo "Clone repository..."
	git clone "https://github.com/figec/ttyhlauncher.git"
	cd "${HOME}/.local/src/ttyhlauncher"

	echo "Building sources..."
	qmake CONFIG+="unix_desktop" PREFIX="${HOME}/.local/"
	make
	make install
	
	echo "Execute post-intsall changes"
	sed -i "s|Exec=ttyhlauncher|Exec=${HOME}/.local/bin/ttyhlauncher.sh start|" "${HOME}/.local/share/applications/ttyhlauncher.desktop"
	echo "Done!"
}

do_start() {
	x-terminal-emulator -e cd "${HOME}/.local/src/ttyhlauncher" & git pull & qmake CONFIG+="unix_desktop" PREFIX="${HOME}/.local/" & make & make install
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

