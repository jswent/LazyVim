-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- saving
keymap("n", "<c-s>", ":wq<CR>", {})
keymap("i", "<c-s>", "<Esc>:w<CR>a", {})

-- remove buffer
keymap("n", "Q", "<cmd>Bdelete<CR>", opts)

-- cybu
keymap("n", "<m-j>", "<Plug>(CybuNext)", opts)
keymap("n", "<m-k>", "<Plug>(CybuPrev)", opts)
