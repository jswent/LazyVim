---@class jswent.winbar
local M = {}

---@class WinbarConfig
---@field update_interval number Timer interval in ms (default: 16 for ~60fps)
---@field exclude_filetype string[] Filetypes to exclude from winbar

---@type WinbarConfig
local default_config = {
  update_interval = 16,
  exclude_filetype = {
    "help",
    "startify",
    "dashboard",
    "packer",
    "neogitstatus",
    "NvimTree",
    "Trouble",
    "alpha",
    "lir",
    "Outline",
    "spectre_panel",
    "toggleterm",
    "DressingSelect",
    "Jaq",
    "harpoon",
    "dapui_scopes",
    "dapui_breakpoints",
    "dapui_stacks",
    "dapui_watches",
    "dap-repl",
    "dap-terminal",
    "dapui_console",
    "lab",
    "Markdown",
    "neo-tree",
    "",
  },
}

---@type WinbarConfig
local config = vim.deepcopy(default_config)

-- State
local uv = vim.uv or vim.loop
local update_timer = uv.new_timer()
local icon_cache = {} ---@type table<number, {icon: string, hl_group: string}>

-- Cached module requires
local devicons = require("nvim-web-devicons")
local navic = require("nvim-navic")
local navic_lib = require("nvim-navic.lib")
local icons = require("jswent.icons")

-- Utility functions

---Check if buffer should be excluded from winbar
---@param bufnr number
---@return boolean
local function is_excluded(bufnr)
  local ft = vim.bo[bufnr].filetype
  return vim.tbl_contains(config.exclude_filetype, ft)
end

---Get filename from buffer
---@param bufnr number
---@return string filename, string extension
local function get_buf_filename(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  return vim.fn.fnamemodify(name, ":t"), vim.fn.fnamemodify(name, ":e")
end

-- Component builders

---Get or create cached icon data for buffer
---@param bufnr number
---@return string icon, string hl_group
local function get_file_icon(bufnr)
  if icon_cache[bufnr] then
    return icon_cache[bufnr].icon, icon_cache[bufnr].hl_group
  end

  local filename, extension = get_buf_filename(bufnr)
  if filename == "" then
    return "", ""
  end

  local icon, icon_color = devicons.get_icon_color(filename, extension, { default = true })
  icon = icon or ""
  local hl_group = "WinBarFileIcon" .. (extension ~= "" and extension or "default")

  if icon_color then
    vim.api.nvim_set_hl(0, hl_group, { fg = icon_color })
  end

  icon_cache[bufnr] = { icon = icon, hl_group = hl_group }
  return icon, hl_group
end

---Build filename component with icon
---@param bufnr number
---@return string
local function get_filename_component(bufnr)
  local filename = get_buf_filename(bufnr)
  if filename == "" then
    return ""
  end

  local icon, hl_group = get_file_icon(bufnr)

  if icon ~= "" then
    return string.format(" %%#%s#%s%%* %%#WinBarFilename#%s%%*", hl_group, icon, filename)
  else
    return string.format(" %%#WinBarFilename#%s%%*", filename)
  end
end

---Get navic location (breadcrumbs) for specific window's cursor position
---@param bufnr number
---@param winid number Window displaying the buffer
---@return string
local function get_navic_location(bufnr, winid)
  if not navic.is_available(bufnr) then
    return ""
  end

  local tree = navic_lib.get_tree(bufnr)
  if not tree then
    return ""
  end

  -- Get cursor position for THIS specific window
  local ok, cursor_pos = pcall(vim.api.nvim_win_get_cursor, winid)
  if not ok then
    return ""
  end

  -- Update context for this window's cursor position
  -- Note: This temporarily updates navic's global context for the buffer,
  -- but that's okay since we immediately format and return the result
  navic_lib.update_context(bufnr, cursor_pos)
  local location = navic.get_location({}, bufnr)

  if location == "" then
    return ""
  end

  return " " .. icons.ui.ChevronRight .. " " .. location
end

---Get modified indicator
---@param bufnr number
---@return string
local function get_modified_indicator(bufnr)
  if vim.bo[bufnr].modified then
    return " %#LspCodeLens#" .. icons.ui.Circle .. "%*"
  end
  return ""
end

---Get tabpage indicator if multiple tabs
---@return string
local function get_tabpage_indicator()
  local num_tabs = #vim.api.nvim_list_tabpages()

  if num_tabs > 1 then
    local tabpage_number = vim.api.nvim_tabpage_get_number(0)
    return "%=" .. tabpage_number .. "/" .. num_tabs
  end

  return ""
end

---Get the buffer location context string (filename + navic location)
---@param bufnr number
---@param winid number Window displaying the buffer
---@return string
local function get_buffer_location(bufnr, winid)
  if not vim.api.nvim_buf_is_valid(bufnr) or is_excluded(bufnr) then
    return ""
  end

  local filename = get_filename_component(bufnr)
  local navic_location = get_navic_location(bufnr, winid)

  if filename == "" then
    return navic_location
  elseif navic_location == "" then
    return filename
  else
    return filename .. navic_location
  end
end

---Build complete winbar string for a window displaying a buffer
---@param winid number
---@param bufnr number
---@return string
local function build_winbar_for_window(winid, bufnr)
  local location = get_buffer_location(bufnr, winid)
  local modified = get_modified_indicator(bufnr)
  local tabpage = get_tabpage_indicator()

  -- Optimize: concatenate directly without table
  if location == "" then
    return modified .. tabpage
  elseif modified == "" and tabpage == "" then
    return location
  else
    return location .. modified .. tabpage
  end
end

-- Winbar update logic

---Update winbar for a specific window
---@param winid number
local function update_winbar_for_window(winid)
  if not vim.api.nvim_win_is_valid(winid) then
    return
  end

  -- Skip floating windows
  local win_config = vim.api.nvim_win_get_config(winid)
  if win_config.relative ~= "" then
    return
  end

  -- Get the buffer displayed in this window
  local bufnr = vim.api.nvim_win_get_buf(winid)

  -- Build winbar string for this window-buffer pair
  local winbar_string = build_winbar_for_window(winid, bufnr)

  -- Set winbar for this specific window
  vim.api.nvim_set_option_value("winbar", winbar_string, { scope = "local", win = winid })
end

---Update winbar for current window (for use in autocmds)
local function update_winbar()
  update_winbar_for_window(vim.api.nvim_get_current_win())
end

-- Public API

---Setup winbar with optional config
---@param opts? WinbarConfig
function M.setup(opts)
  -- Merge user config with defaults
  if opts then
    config = vim.tbl_deep_extend("force", default_config, opts)
  end

  -- Set up highlight for filename that inherits from NavicText
  local navic_text = vim.api.nvim_get_hl(0, { name = "NavicText" })
  if navic_text.fg then
    vim.api.nvim_set_hl(0, "WinBarFilename", { fg = navic_text.fg })
  end

  -- Create augroup
  local group = vim.api.nvim_create_augroup("WinBar", { clear = true })

  -- Start timer for automatic updates (catches LSP load and navic updates)
  -- Update all visible windows like lualine does
  local timer_callback = vim.schedule_wrap(function()
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
      update_winbar_for_window(winid)
    end
  end)

  if update_timer then
    uv.timer_start(update_timer, 0, config.update_interval, timer_callback)
  end

  -- Update on these events for immediate refresh
  vim.api.nvim_create_autocmd({
    "BufWinEnter",
    "BufWritePost",
    "TextChanged",
    "TextChangedI",
  }, {
    group = group,
    callback = function()
      update_winbar()
    end,
  })

  -- Clear icon cache when buffer is deleted
  vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    callback = function(args)
      icon_cache[args.buf] = nil
    end,
  })

  -- Clear icon cache when file is renamed
  vim.api.nvim_create_autocmd("BufFilePost", {
    group = group,
    callback = function(args)
      icon_cache[args.buf] = nil
      update_winbar()
    end,
  })

  -- Initial update for current buffer
  vim.schedule(update_winbar)
end

return M
