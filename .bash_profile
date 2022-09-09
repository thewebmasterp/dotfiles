#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Adding custom directory to path
export PATH="${PATH}:${HOME}/.bin:${HOME}/node_modules/.bin"

# Set default terminal
export TERMINAL="/usr/bin/alacritty"
