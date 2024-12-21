ALL: INSTALL

INSTALL:
	sudo pkg install gtk-murrine-engine neofetch i3status neovim jq
	sudo cp -r fonts/* /usr/local/share/fonts/
	sudo cp -r themes/* /usr/local/share/themes/
	sudo cp -r icons/* /usr/local/share/icons/
	sudo cp -r wallpaper/ ~/wallpaper/
	sudo fc-cache -vf
	cp -rf dotfiles/.* ~/

