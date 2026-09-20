-- Plugin manager (lazy.nvim) bootstrap + plugin specs.
-- Manage plugins with :Lazy  (update: :Lazy update)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Colorscheme: Catppuccin, following darkman (see lua/theme.lua).
  -- flavour = "auto" reads vim.o.background at load time only (no live
  -- autocmd inside the plugin), so theme.lua sets it explicitly before every
  -- (re)load - both at startup and when darkman calls back in remotely.
  -- auto_integrations (on by default) detects installed plugins itself, so
  -- there's no hand-maintained integrations list to keep in sync here.
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "auto",
        background = {
          light = "frappe", -- Frappe, not Latte, matches the rest of this setup
          dark = "mocha",
        },
      })
      require("theme").sync()
    end,
  },

  -- Swiss-army: fuzzy picker, nicer input, file explorer, terminal
  {
    "folke/snacks.nvim",
    priority = 900,
    lazy = false,
    ---@type snacks.Config
    opts = {
      input = { enabled = true },     -- nicer prompt UI (used by opencode ask)
      picker = { enabled = true },    -- fuzzy finder
      explorer = { enabled = true },  -- file tree
      terminal = { enabled = true },  -- embedded terminal (hosts opencode)
    },
    keys = {
      { "<leader>ff", function() Snacks.picker.files() end,      desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end,       desc = "Grep project" },
      { "<leader>fb", function() Snacks.picker.buffers() end,    desc = "Find open buffers" },
      { "<leader>fh", function() Snacks.picker.help() end,       desc = "Search help" },
      { "<leader>fr", function() Snacks.picker.recent() end,     desc = "Recent files" },
      { "<leader>e",  function() Snacks.explorer() end,          desc = "File explorer" },
    },
  },

  -- Shows pending keybindings as you type (press <Space> and wait)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>o", group = "opencode" },
        { "<leader>a", group = "agents" },
      },
    },
  },

  -- Better syntax highlighting / code understanding
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "bash", "python",
          "javascript", "typescript", "json", "yaml", "markdown", "c" },
        auto_install = true, -- install parser when opening a new filetype
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP: install servers with :Mason (they auto-enable once installed)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      { "mason-org/mason-lspconfig.nvim", opts = {} },
    },
    config = function()
      -- LSP keymaps, active only in buffers with a language server
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          local map = vim.keymap.set
          map("n", "gd", vim.lsp.buf.definition,
            vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          map("n", "grr", vim.lsp.buf.references,
            vim.tbl_extend("force", opts, { desc = "References" }))
          map("n", "grn", vim.lsp.buf.rename,
            vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
          map("n", "gra", vim.lsp.buf.code_action,
            vim.tbl_extend("force", opts, { desc = "Code action" }))
          map("n", "K", vim.lsp.buf.hover,
            vim.tbl_extend("force", opts, { desc = "Hover docs" }))
        end,
      })
    end,
  },

  -- Autocompletion
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "enter" }, -- <CR> accepts, <Tab>/<S-Tab> cycle
      completion = { documentation = { auto_show = true } },
    },
  },

  -- opencode integration
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Starts `opencode --port` in a snacks terminal on the right when
        -- no running opencode server is found.
        server = {
          start = function()
            require("snacks.terminal").open("opencode --port", {
              win = { position = "right", enter = false },
            })
          end,
        },
      }

      local map = vim.keymap.set
      map({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ") end,
        { desc = "Ask opencode about this" })
      map({ "n", "x" }, "<leader>os", function() require("opencode").select() end,
        { desc = "Select opencode prompt/command" })
      map({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
        { desc = "Send range to opencode", expr = true })
      map("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
        { desc = "Send line to opencode", expr = true })
      map({ "n", "t" }, "<leader>ot", function()
        require("snacks.terminal").toggle("opencode --port",
          { win = { position = "right", enter = false } })
      end, { desc = "Toggle opencode terminal" })
      map("n", "<leader>ou", function() require("opencode").command("session.half.page.up") end,
        { desc = "opencode scroll up" })
      map("n", "<leader>od", function() require("opencode").command("session.half.page.down") end,
        { desc = "opencode scroll down" })
      map("n", "<leader>on", function() require("opencode").command("session.new") end,
        { desc = "opencode new session" })
      map("n", "<leader>oi", function() require("opencode").command("session.interrupt") end,
        { desc = "opencode interrupt" })
    end,
  },
})
