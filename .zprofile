# Add custom directory to PATH
# ~/.local/bin goes FIRST so user-local binaries (e.g. the cameractrls wrapper)
# shadow their /usr/bin counterparts, in the shell and in rofi's run mode.
export PATH="${HOME}/.local/bin:${PATH}:${HOME}/node_modules/.bin"

# Set default terminal
export TERMINAL="/usr/bin/foot"

# Set wttrbar flags
# WTTRBAR_FLAGS="--location Sofia"

# Set btrfs fs uuid for use in btrfs-status waybar module
# BTRFS_ROOT_FS_UUID="c91f3789-2009-44af-91e0-a74d3d1c68dd"

# Execute and source the environment exported from all scripts in $RUN_ALL_IN_DIR.
# Each script is guarded individually: a failing script must never abort the
# login shell (set -e here would do exactly that), it just stops sourcing.
RUN_ALL_IN_DIR="$HOME/.zprofile.d"
if [ -d "$RUN_ALL_IN_DIR" ]; then
	for script in "$RUN_ALL_IN_DIR"/*.sh; do
		if [[ -f "$script" && -x "$script" ]]; then
			source "$script" || echo ".zprofile: failed sourcing $script" >&2
		fi
	done
fi
