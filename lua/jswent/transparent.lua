local M = {}

local plugins = { "noice.nvim", "nvim-notify", "tokyonight.nvim" }

local function reload_plugins(plugin_array)
  local loader = require("lazy.core.loader")
  local colors_name = vim.g.colors_name

  for _, plugin in ipairs(plugin_array) do
    loader.reload(plugin)
  end

  vim.cmd("colorscheme " .. colors_name)
end

local state = false

function M.get_state()
  return state
end

function M.set_state(new_state)
  if type(new_state) == "boolean" then
    state = new_state
    reload_plugins(plugins)
  else
    error("new_state must be a boolean")
  end
end

return M
