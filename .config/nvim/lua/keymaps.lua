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

-- Terminal mode: no built-in way to paste a register AS INPUT into the
-- running program (a plain "p" would just edit the buffer text, not type
-- into the pty). This is Neovim's own documented fix — see :h terminal-input.
-- Usage: in a terminal (e.g. an opencode agent), <C-r> then a register name
-- (e.g. "a) types that register's contents into the process, same as if
-- you'd typed it. Pairs with normal yanking: v...y or "ay in Terminal-Normal
-- mode (<C-\><C-n> to get there).
map("t", "<C-r>", function()
  return [[<C-\><C-n>"]] .. vim.fn.nr2char(vim.fn.getchar()) .. "pi"
end, { expr = true, desc = "Terminal: paste register as input" })

-- Extend window navigation (Normal-mode mapping above) into Insert and
-- Terminal-mode too, so you can hop between windows - e.g. between several
-- opencode agent terminals - without first dropping to Normal mode.
-- <C-\><C-n> is a documented "hard escape" that works from both Insert and
-- Terminal-mode (:h i_CTRL-\_CTRL-N, :h CTRL-\_CTRL-N).
for _, mode in ipairs({ "i", "t" }) do
  map(mode, "<C-Left>",  "<C-\\><C-n><C-w>h", { desc = "Focus window left" })
  map(mode, "<C-Down>",  "<C-\\><C-n><C-w>j", { desc = "Focus window down" })
  map(mode, "<C-Up>",    "<C-\\><C-n><C-w>k", { desc = "Focus window up" })
  map(mode, "<C-Right>", "<C-\\><C-n><C-w>l", { desc = "Focus window right" })
end
