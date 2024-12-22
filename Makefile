ALL: INSTALL

INSTALL: THEMES FONTS DOTFILES
	sudo pkg install gtk-murrine-engine neofetch i3status neovim jq rsync

THEMES:
	sudo cp -R themes/* /usr/local/share/themes/
	sudo cp -R icons/* /usr/local/share/icons/
	sudo cp -R wallpaper/ ~/wallpaper/
	
FONTS:
	sudo cp -R fonts/* /usr/local/share/fonts/
	sudo fc-cache -vf

DOTFILES:
	rsync -a dotfiles/ ~/.

