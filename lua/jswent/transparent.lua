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

function M.check_startup()
  -- TODO: change to using $TRANSPARENT environment variable set by terminal emulator
  local wezterm_executable = os.getenv("WEZTERM_EXECUTABLE")
  local kitty_listen_on = os.getenv("KITTY_LISTEN_ON")

  local is_wezterm = wezterm_executable ~= nil and wezterm_executable ~= ""
  local is_kitty = kitty_listen_on ~= nil and kitty_listen_on ~= ""

  if is_wezterm or is_kitty then
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

M.check_startup()
M.create_commands()

return M
