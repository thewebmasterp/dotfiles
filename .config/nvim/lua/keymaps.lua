-- Keymaps. Colemak-DH strategy: MINIMAL — Vim defaults untouched.
-- Navigation philosophy on your Ergodox:
--   * hold Space (layer 2) -> real arrow keys on N/E/I/O -> works natively in Vim
--   * prefer word motions (w, b, e), find (f<char>), and search (/) over
--     single-char movement anyway; that's idiomatic Vim on ANY layout.
local map = vim.keymap.set

-- Esc clears search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window navigation on Ctrl+arrows.
-- Your firmware layer 3 (right big thumb key) puts Ctrl+arrows on N/E/I/O,
-- so switching splits is a home-row roll. <C-w> + arrows also still works.
map("n", "<C-Left>",  "<C-w>h", { desc = "Focus window left" })
map("n", "<C-Down>",  "<C-w>j", { desc = "Focus window down" })
map("n", "<C-Up>",    "<C-w>k", { desc = "Focus window up" })
map("n", "<C-Right>", "<C-w>l", { desc = "Focus window right" })

-- Quality of life
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<CR>",  { desc = "Quit window" })

-- Move selected lines up/down and reindent (visual mode, arrows)
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-Up>",   ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered on half-page jumps and search hits
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic under cursor" })
