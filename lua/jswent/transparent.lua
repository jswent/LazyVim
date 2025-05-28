---@class jswent.transparent
local M = {}

local plugins = { "noice.nvim", "rose-pine", "tokyonight.nvim" }

local function reload_plugins(plugin_array)
  local loader = require("lazy.core.loader")
  local colors_name = vim.g.colors_name

  for _, plugin in ipairs(plugin_array) do
    loader.reload(plugin)
  end

  vim.cmd("colorscheme " .. colors_name)
end

---@type boolean
local state = false

function M.get_state()
  return state
end

---@param new_state boolean
function M.set_state(new_state)
  if type(new_state) == "boolean" then
    state = new_state
    reload_plugins(plugins)
  else
    error("new_state must be a boolean")
  end
end

function M.check_startup()
  local cfg_transparent = vim.g.jswent_transparent
  if cfg_transparent ~= nil and type(cfg_transparent) == "boolean" then
    state = cfg_transparent
    return
  end

  local env_transparent = os.getenv("TRANSPARENT")
  if env_transparent == "true" then
    state = true
  end
end

function M.create_commands()
  -- Command to enable transparency
  vim.api.nvim_create_user_command("EnableTransparent", function()
    M.set_state(true)
  end, { nargs = 0 })
  -- Command to disable transparency
  vim.api.nvim_create_user_command("DisableTransparent", function()
    M.set_state(false)
  end, { nargs = 0 })
  -- Command to toggle transparency
  vim.api.nvim_create_user_command("ToggleTransparent", function()
    M.set_state(not state)
  end, { nargs = 0 })
end

---@param opts? snacks.toggle.Config
function M.create_toggle(opts)
  return Snacks.toggle.new({
    id = "transparent",
    name = "Transparent Background",
    get = function()
      return M.get_state()
    end,
    set = function(new_state)
      M.set_state(new_state)
    end,
  }, opts)
end

M.check_startup()
M.create_commands()

return M
