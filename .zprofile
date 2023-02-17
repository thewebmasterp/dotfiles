# Add custom directory to path
export PATH="${PATH}:${HOME}/.local/bin:${HOME}/node_modules/.bin"

# Set default terminal
export TERMINAL="/usr/bin/alacritty"

# Set default user cahce dir
export XDG_CACHE_HOME="${HOME}/.cache"

# Set default user config dir
export XDG_CONFIG_HOME="${HOME}/.config"

# Set default user data dir
export XDG_DATA_HOME="${HOME}/.local/share"

# Set default node REPL history file
export NODE_REPL_HISTORY="${XDG_CACHE_HOME}/node_repl_history"

# Override qt theme with the one set by Kvantum
QT_STYLE_OVERRIDE=kvantum
