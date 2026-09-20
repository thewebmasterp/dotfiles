-- Catppuccin <-> darkman integration.
--
-- darkman writes the current mode to an untracked state file; this module
-- only reads it. Nothing here ever writes into this (tracked) config - all
-- mutable state lives under ~/.local/state/theme/, same as every other app
-- in this setup.
--
-- Live reload works over Neovim's own RPC, not file-watching: each running
-- instance starts a socket under ~/.local/state/theme/nvim-sockets/, and the
-- darkman hook calls back into every socket it finds with:
--   nvim --server <socket> --remote-expr 'v:lua.CatppuccinSync()'

local M = {}

local STATE_FILE = vim.fn.expand("~/.local/state/theme/nvim-background")
local SOCKET_DIR = vim.fn.expand("~/.local/state/theme/nvim-sockets")

-- Returns "dark" or "light", defaulting to "dark" if the state file is
-- missing, unreadable, or contains anything unexpected.
function M.read_background()
	local f = io.open(STATE_FILE, "r")
	if not f then
		return "dark"
	end
	local content = f:read("*l")
	f:close()
	if content == "light" then
		return "light"
	end
	return "dark"
end

-- Applies the current darkman state to this running instance. Safe to call
-- before or after catppuccin has loaded (used both at startup and remotely).
function M.sync()
	vim.o.background = M.read_background()
	local ok, catppuccin = pcall(require, "catppuccin")
	if ok then
		catppuccin.load()
	end
end

-- Starts an RPC server so darkman's hook can reach this instance. One socket
-- per running instance, named by pid, removed on exit.
function M.start_server()
	vim.fn.mkdir(SOCKET_DIR, "p")
	local sock = SOCKET_DIR .. "/" .. vim.fn.getpid() .. ".sock"
	local ok = pcall(vim.fn.serverstart, sock)
	if ok then
		vim.api.nvim_create_autocmd("VimLeavePre", {
			once = true,
			callback = function()
				pcall(os.remove, sock)
			end,
		})
	end
end

return M
