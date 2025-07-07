-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- saving
map("n", "<c-s>", ":wq<CR>", {})
map("i", "<c-s>", "<Esc>:w<CR>a", {})

-- remove buffer
map("n", "Q", "<cmd>Bdelete<CR>", opts)

-- cybu
map("n", "<m-j>", "<Plug>(CybuNext)", opts)
map("n", "<m-k>", "<Plug>(CybuPrev)", opts)

-- terminal
if os.getenv("THEME") == "starship" then
  map("n", "<c-/>", function()
    Snacks.terminal(nil, { cwd = LazyVim.root(), env = { THEME_OVERRIDE = "starship" } })
  end, { desc = "Terminal (Root Dir)" })
end

-- claude
-- note: this overrides the CodeLens keymaps
if vim.fn.executable("claude") == 1 then
  local claude = require("jswent.claude")
  map("n", "<leader>cc", function() claude({ cwd = LazyVim.root.git() }) end, { desc = "Claude Code (Root Dir)" })
  map("n", "<leader>cC", function() claude() end, { desc = "Claude Code (cwd)" })
end


require("jswent.transparent").create_toggle():map("<leader>ut")
