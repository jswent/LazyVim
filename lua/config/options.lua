-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

require("jswent.winbar")

-- vim.g.snacks_animate = true

vim.g.lazyvim_picker = "snacks"

vim.g.lazyvim_explorer = "neo-tree"

-- use this to override the default colorscheme, see jswent.colorscheme
-- vim.g.jswent_colorscheme = "gruvbox"

-- use this to override the transparency; ghostty, wezterm, kitty supported by default
-- vim.g.jswent_transparency = true

-- use this to enable/disable cybu.nvim
-- vim.g.jswent_cybu_enabled = true
