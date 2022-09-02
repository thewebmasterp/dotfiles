#
# ~/.bashrc
#

function reload_gtk_theme() {
	  theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
	    gsettings set org.gnome.desktop.interface gtk-theme ''
	      sleep 1
	        gsettings set org.gnome.desktop.interface gtk-theme $theme
	}


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias music='tmux new-session -s $$ "tmux source-file ~/.config/ncmpcpp/tsession"'
_trap_exit() { tmux kill-session -t $$; }
alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias configupd='config add $(config diff --name-only HEAD)'
