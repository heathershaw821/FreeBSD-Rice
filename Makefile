ALL: INSTALL

INSTALL: TOOLS THEMES FONTS DOTFILES

THEMES:
	sudo cp -R themes/* /usr/local/share/themes/
	sudo cp -R icons/* /usr/local/share/icons/
	sudo cp -R wallpaper/ ~/wallpaper/
	
FONTS:
	sudo cp -R fonts/* /usr/local/share/fonts/
	sudo fc-cache -vf

DOTFILES:
	rsync -a dotfiles/ ~/.

THINKPAD:
	sudo rsync -a root/ /

TOOLS:
	sudo pkg install gtk-murrine-engine neofetch i3status neovim jq rsync sysutils/rust-coreutils
	sudo cc src/firefox-hound.c -o /usr/local/bin/firefox-hound
	sudo mkdir -p /usr/local/lib/heather
	sudo cp src/jailer /usr/local/bin/jailer
	sudo cp src/colors /usr/local/lib/heather/colors
	sudo cp src/mozilla.tar /usr/local/lib/mozilla.tar
	sudo chmod u+s /usr/local/bin/firefox-hound
	sudo chown root:wheel /usr/local/bin/firefox-hound /usr/local/bin/jailer
	
