-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set
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

require("jswent.transparent").create_toggle():map("<leader>ut")
