-- Editor options. :help 'optionname' explains any of these.
local o = vim.opt

-- Line numbers: absolute on cursor line, relative elsewhere.
-- Relative numbers pair well with counted motions: 5<Down>, 5j, etc.
o.number = true
o.relativenumber = true

o.mouse = "a"                  -- mouse works everywhere (fine while learning)
o.clipboard = "unnamedplus"    -- yank/paste uses the system clipboard
o.undofile = true              -- persistent undo across sessions
o.ignorecase = true            -- case-insensitive search...
o.smartcase = true             -- ...unless the query has capitals
o.signcolumn = "yes"           -- stable gutter (no text shifting)
o.scrolloff = 8                -- keep context above/below cursor
o.splitright = true            -- new vsplits open right
o.splitbelow = true            -- new splits open below
o.wrap = false                 -- no soft-wrapping of long lines
o.cursorline = true            -- highlight the current line
o.confirm = true               -- ask instead of failing on unsaved quit
o.updatetime = 300             -- faster CursorHold/diagnostics
o.timeoutlen = 500             -- mapped-key sequence wait (ms)

-- Default indentation: 4 spaces (plugins/ftplugins override per language)
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
