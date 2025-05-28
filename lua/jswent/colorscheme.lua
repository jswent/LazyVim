---@class jswent.colorscheme
local M = {}

---@class jswent.colorscheme.Config
---@field colors string
---@field appearance "dark" | "light" | "system"
---@field theme_mappings table<string,string>
local defaults = {
  colors = vim.g.jswent_colorscheme or "tokyonight",
  appearance = "system",
  theme_mappings = {
    ["tokyonight"] = "tokyonight",
    ["gruvbox"] = "gruvbox",
    ["rose-pine"] = "rose-pine",
  },
}

-- TODO: Allow for modular opts
local colors = defaults.colors
local appearance = defaults.appearance
local theme_mappings = defaults.theme_mappings

---@param terminal string The terminal name
---@return string|nil theme The terminal theme or nil if not found
local function read_terminal_theme(terminal)
  if not terminal then
    vim.notify("No terminal specified", vim.log.levels.ERROR)
    return nil
  end

  local machfiles_dir = os.getenv("MACHFILES_DIR")
  local path

  if machfiles_dir then
    path = string.format("%s/.%s-theme", machfiles_dir, terminal)
  else
    path = string.format("%s/.machfiles/.%s-theme", vim.fn.expand("~"), terminal)
  end

  local ok, content = pcall(function()
    local file = io.open(path, "r")
    if not file then
      error(string.format("Could not open theme file: %s", path))
    end
    local content = file:read("*all")
    file:close()
    return content:gsub("%s*$", "") -- Trim whitespace
  end)

  if not ok then
    vim.notify(content, vim.log.levels.WARN)
    return nil
  end

  return content
end

---@return string colors The current colorscheme
function M.get_colors()
  return colors
end

---@return "dark"|"light"|"system" appearance The current appearance setting
function M.get_appearance()
  return appearance
end

---@param new_colors string The new colorscheme to set
function M.set_colors(new_colors)
  -- TODO: Handle validation and apply settings here
  colors = new_colors
end

---@param new_appearance "dark"|"light"|"system" The new appearance to set
function M.set_appearance(new_appearance)
  if new_appearance == "dark" then
    appearance = "dark"
  elseif new_appearance == "light" then
    appearance = "light"
  elseif new_appearance == "system" then
    appearance = "system"
  else
    vim.notify("Invalid appearance value. Must be 'dark', 'light', or 'system'", vim.log.levels.ERROR)
    return
  end

  M.apply_settings()
end

function M.apply_settings()
  if appearance == "system" then
    -- TODO: Add system detection logic
    -- For now, using existing background as the system choice
  else
    vim.o.background = appearance
  end

  local ok, err = pcall(vim.cmd, string.format("colorscheme %s", colors))
  if not ok then
    vim.notify(string.format("Failed to apply colorscheme: %s", err), vim.log.levels.ERROR)
  end
end

function M.toggle_appearance()
  if appearance == "dark" then
    appearance = "light"
  elseif appearance == "light" then
    appearance = "dark"
  elseif appearance == "system" then
    if vim.o.background == "light" then
      appearance = "dark"
    elseif vim.o.background == "dark" then
      appearance = "light"
    end
  end

  -- Apply the change immediately
  M.apply_settings()
end

function M.check_startup()
  local term = os.getenv("TERM")

  if term ~= "xterm-ghostty" then
    M.apply_settings()
    return
  end

  local theme_contents = read_terminal_theme("ghostty")
  if not theme_contents then
    return
  end

  local vim_theme = theme_mappings[theme_contents]
  if vim_theme then
    M.set_colors(vim_theme)
    M.apply_settings() -- Apply the settings
  end
end

M.check_startup()

return M
