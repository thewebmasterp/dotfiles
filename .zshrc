# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-.]=** r:|=**'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' menu select=5
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/thewebmasterp/.zshrc'

autoload -Uz compinit
# Full compinit rescans/audits all completion files; only do that if the dump
# is older than 24h, otherwise trust the cached ~/.zcompdump (-C).
if [[ -n ~/.zcompdump(#qN.mh-24) ]]; then
	compinit -C
else
	compinit
fi
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
# HISTSIZE (in-memory) is kept larger than SAVEHIST (on-disk) so
# HIST_EXPIRE_DUPS_FIRST has room to drop dupes before unique events.
HISTSIZE=120000
SAVEHIST=100000
setopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install

# Key bindings
# Print current keybindings: bindkey
bindkey "^[[H" beginning-of-line	# Home
bindkey "^[[F" end-of-line			# End
bindkey "^[[3~" delete-char			# Del
bindkey "^[[3;5~" delete-word		# Ctrl + Del
bindkey "^H" backward-delete-word	# Ctrl + Backspace
bindkey "^[[1;5C" forward-word		# Ctrl + ArrowRight
bindkey "^[[1;5D" backward-word		# Ctrl + ArrowLeft
bindkey "^Z" undo					# Ctrl + Z
bindkey "^Y" redo					# Ctrl + Y

# Aliases
alias md="mkdir -p"
alias rd="rmdir"
alias ls="lsd -Al --group-directories-first"
alias glog="git log --all --decorate --graph --abbrev-commit --format='%C(bold yellow)%h%d%C(reset) - %C(white)%s%C(reset)%n          %C(bold blue)%ar (%ai)%C(reset) %C(bold dim green)%an%C(reset)'"
alias adog="git log --all --decorate --oneline --graph"
# Browse history in fzf with surrounding context in the preview.
# The sed strips the ": <epoch>:<duration>;" prefix that EXTENDED_HISTORY writes.
histctx() {
	local clean='s/^: [0-9]+:[0-9]+;//'
	sed -E $clean ~/.histfile | grep -n '' | fzf --delimiter : \
		--preview "sed -E '$clean' ~/.histfile | bat --style=numbers --color=always --file-name histfile --highlight-line {1}" \
		--preview-window '+{1}-/2'
}
qr() { qrencode -m 2 -t utf8 <<< "$*" }
alias gitp="git-private"
alias gits="git-shared"
alias claude-w='CLAUDE_CONFIG_DIR=~/.claude-work claude'
alias claude-p='CLAUDE_CONFIG_DIR=~/.claude-personal claude'
alias oc='opencode --port' # always expose the API so Neovim (opencode.nvim) can find it

# Env Exports
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-match_002dwords_002dby_002dstyle
# Define how to match "words"; default mode is "normal" (alphanumerical + WORDCHARS)
# Default WORDCHARS are *?_-.[]~=/&;!#$%^(){}<>
export WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"
# VISUAL/EDITOR are exported from ~/.zprofile
# fzf default find command: fd is fast and respects .gitignore
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

# nmtui/whiptail/dialog etc. (anything using libnewt) -> Catppuccin.
# NEWT_COLORS only maps ROLE NAMES to a fixed 16-name S-Lang colour
# vocabulary (black/red/green/brown/blue/magenta/cyan/lightgray + bright
# variants); the actual RGB per name comes from the terminal's own ANSI
# palette (already Catppuccin in foot.ini), so this hot-reloads for free
# with foot's Mocha<->Frappe switching - nmtui launches fresh every run,
# same as swaylock. "blue" is used as the one active/selected accent,
# consistent with the accent colour used everywhere else in this setup.
export NEWT_COLORS='
root=gray,black
border=blue,black
window=lightgray,black
shadow=black,black
title=blue,black
button=black,lightgray
actbutton=black,blue
checkbox=lightgray,black
actcheckbox=black,blue
entry=lightgray,black
disentry=gray,black
label=lightgray,black
listbox=lightgray,black
actlistbox=black,blue
sellistbox=lightgray,black
actsellistbox=black,blue
textbox=lightgray,black
acttextbox=black,blue
helpline=lightgray,black
roottext=lightgray,black
emptyscale=black,black
fullscale=blue,blue
compactbutton=black,lightgray
'

# https://github.com/mgunyho/tere
tere() {
    local result=$(command tere "$@")
    [ -n "$result" ] && cd -- "$result"
}

# If the internal history needs to be trimmed to add the current command line, setting this
# option will cause the oldest history event that has a duplicate to be lost before losing a
# unique event from the list. You should be sure to set the value of HISTSIZE to a larger
# number than SAVEHIST in order to give you some room for the duplicated events, otherwise
# this option will behave just like HIST_IGNORE_ALL_DUPS once the history fills up with unique
# events.
setopt HIST_EXPIRE_DUPS_FIRST
# When searching for history entries in the line editor, do not display duplicates of a line
# previously found, even if the duplicates are not contiguous.
setopt HIST_FIND_NO_DUPS
# If a new command line being added to the history list duplicates an older one, the older
# command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS
# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt HIST_IGNORE_DUPS
# Remove command lines from the history list when the first character on the line is a space,
# or when one of the expanded aliases contains a leading space. Only normal aliases (not
# global or suffix aliases) have this behaviour. Note that the command lingers in the internal
# history until the next command is entered before it vanishes, allowing you to briefly reuse
# or edit the line. If you want to make it vanish right away without entering another command,
# type a space and press return.
setopt HIST_IGNORE_SPACE
# When writing out the history file, older commands that duplicate newer ones are omitted.
setopt HIST_SAVE_NO_DUPS
# Save each command's timestamp and duration in the history file (": <epoch>:<duration>;cmd").
# View with `history -if` (or -iD for durations).
setopt EXTENDED_HISTORY
# Like INC_APPEND_HISTORY (write each command to $HISTFILE as soon as it is entered), but also
# import commands typed in other running shells, so history is shared live between terminals.
setopt SHARE_HISTORY
# Allow comments ("cmd  # note to self") on the interactive command line.
setopt INTERACTIVE_COMMENTS

# zsh-you-should-use plugin
source /usr/share/zsh/plugins/zsh-you-should-use/zsh-you-should-use.plugin.zsh

# Git status in prompt with the $(gitprompt) expansion
source /usr/share/zsh/scripts/git-prompt.zsh
ZSH_THEME_GIT_PROMPT_PREFIX=" ("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_TAG="%{$fg_bold[white]%}"

# Customizing the prompt
# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
# Either show hostname in the prompt "[tom@v330:~]" or not [tom:~]:
# PROMPT='%B%F{magenta}[%n:%f%F{blue}%(4~|../|)%3~%f%b$(gitprompt)%B%F{magenta}]%f%b ' # without hostname
PROMPT='%B%F{magenta}[%n@%m:%f%F{blue}%(4~|../|)%3~%f%b$(gitprompt)%B%F{magenta}]%f%b ' # with hostname
RPROMPT='%B%F{red}%(0?||Exit code: %?)%f%b'

# CTRL+ARROW_RIGHT   - partially accept suggestion up to the point that the cursor moves to
# ARROW_RIGHT or END - accept suggestion and replace contents of the command line buffer with the suggestion
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# CTRL+T - paste the selected files and directories onto the command-line
# CTRL+R - paste the selected command from history onto the command-line
# ALT+C  - cd into the selected directory
# Type ** and hit tab (eg. with the cd command; works with directories, files, process IDs, hostnames, environment variables)
source <(fzf --zsh)

# mise (https://mise.jdx.dev) - runtime/tool version manager, replaces nvm.
# Reads .nvmrc/.node-version (idiomatic_version_file_enable_tools=["node"]) and
# mise.toml; auto-switches versions on cd. Global default: `mise use -g node@22`.
eval "$(mise activate zsh)"

# zoxide (https://github.com/ajeetdsouza/zoxide) - frecency-based cd.
# `z foo` jumps to the best-matching visited dir, `zi foo` picks interactively via fzf.
eval "$(zoxide init zsh)"

# Private/machine-specific shell additions (tracked in the private repo only,
# e.g. work project aliases) live in ~/.zshrc.d/*.zsh. Sourced late so they can
# also override plugin settings above.
if [ -d "$HOME/.zshrc.d" ]; then
	for script in "$HOME"/.zshrc.d/*.zsh; do
		[ -f "$script" ] && source "$script"
	done
fi

# Must go last (see https://github.com/zsh-users/zsh-syntax-highlighting#why-must-zsh-syntax-highlightingzsh-be-sourced-at-the-end-of-the-zshrc-file)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Sift through history for previous commands matching the typed substring (anywhere
# in the line, not just as prefix). Must be sourced after zsh-syntax-highlighting.
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1 # skip duplicate matches while cycling
bindkey "^[[A" history-substring-search-up # ARROW_UP
bindkey "^[[B" history-substring-search-down # ARROW_DOWN

