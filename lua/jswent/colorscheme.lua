local DEFAULT_COLORS = "tokyonight"
local DEFAULT_APPEARANCE = "system"
local THEME_MAPPINGS = {
  ["rose-pine"] = "rose-pine",
}

local M = {}

local colors = DEFAULT_COLORS
local appearance = DEFAULT_APPEARANCE

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

function M.get_colors()
  return colors
end

function M.get_appearance()
  return appearance
end

function M.check_startup()
  local term = os.getenv("TERM")

  if term ~= "xterm-ghostty" then
    return
  end

  local theme_contents = read_terminal_theme("ghostty")
  if not theme_contents then
    return
  end

  -- Look up theme in mappings
  local vim_theme = THEME_MAPPINGS[theme_contents]
  if vim_theme then
    local ok, err = pcall(vim.cmd, string.format("colorscheme %s", vim_theme))
    if not ok then
      vim.notify(string.format("Failed to set colorscheme: %s", err), vim.log.levels.ERROR)
    end
  end
end

M.check_startup()

return M
