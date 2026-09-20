-- Multiple simultaneous opencode agents.
--
-- Each agent is its own `opencode` process on a fixed port, run in a
-- toggleable floating terminal (via snacks.terminal). Fixed ports (rather
-- than opencode's default random port) mean:
--   1. Each snacks terminal gets a stable, distinct id (id = cmd+cwd+env+count,
--      see snacks terminal docs) so <leader>a1 always reopens the SAME
--      running agent 1, not a new process.
--   2. Agents are recognizable in `require("opencode").select()` -> Servers
--      if you want opencode.nvim's context-injection (<leader>oa, go, etc.)
--      aimed at a specific one instead of whichever it auto-connects to.
--
-- To move text between agents: <C-\><C-n> in the source terminal to reach
-- Normal mode, yank (e.g. "ay for register a), switch window (<C-Left/Right/
-- Up/Down> - works mid-Terminal-mode too, see keymaps.lua), then in the
-- target terminal <C-r>a to type that register's content in as input.

local M = {}

M.ports = { 4097, 4098, 4099, 4100 }

-- Toggle agent N's floating terminal. Reuses the same process/window if
-- already running (that's what gives it "multiple simultaneous agents").
function M.toggle(n)
  local port = M.ports[n]
  if not port then
    vim.notify("agents: no agent " .. tostring(n) .. " configured", vim.log.levels.WARN)
    return
  end
  require("snacks.terminal").toggle("opencode --port " .. port, {
    win = {
      position = "float",
      width = 0.9,
      height = 0.9,
      title = " opencode agent " .. n .. " (:" .. port .. ") ",
      border = "rounded",
    },
  })
end

for i = 1, #M.ports do
  vim.keymap.set("n", "<leader>a" .. i, function() M.toggle(i) end,
    { desc = "Toggle opencode agent " .. i })
end

return M
