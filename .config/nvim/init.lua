-- Neovim config: lean, Colemak-DH-aware (minimal remap strategy).
-- Layout notes: Ergodox EZ does Colemak-DH in firmware. Hold-Space = layer 2
-- (arrows on N/E/I/O home row), layer 3 adds Ctrl+arrows. We keep Vim's
-- default keys and lean on those firmware arrows instead of remapping letters.

-- Leader = Space (tap Space; holding it is your firmware nav layer, which is fine).
-- Must be set before plugins load.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")
require("plugins")

-- darkman -> Catppuccin hot reload (see lua/theme.lua).
require("theme").start_server()
_G.CatppuccinSync = require("theme").sync
