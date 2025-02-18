# Add custom directory to PATH
export PATH="${PATH}:${HOME}/.local/bin:${HOME}/node_modules/.bin"

# Set default terminal
export TERMINAL="/usr/bin/foot"

# Set wttrbar flags
# WTTRBAR_FLAGS="--location Sofia"

# Set btrfs fs uuid for use in btrfs-status waybar module
# BTRFS_ROOT_FS_UUID="c91f3789-2009-44af-91e0-a74d3d1c68dd"

# Execute and source the environment exported from all scripts in $RUN_ALL_IN_DIR
RUN_ALL_IN_DIR=".zprofile.d"
if [ -d ".zprofile.d" ];
then
	set -e  # exit on error
	for script in "$RUN_ALL_IN_DIR"/*.sh; do
		if [[ -f "$script" && -x "$script" ]]; then
    		source "$script"
		fi
	done
fi
