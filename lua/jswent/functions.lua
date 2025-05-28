---@class jswent.functions
local M = {}

-- get length of current word
function M.get_word_length()
  local word = vim.fn.expand("<cword>")
  return #word
end

--- Toggle a boolean Vim option (e.g., 'relativenumber', 'spell').
--- @param option string The name of the option to toggle.k
function M.toggle_option(option)
  local value = not vim.api.nvim_get_option_value(option, {})
  vim.opt[option] = value
  vim.notify(option .. " set to " .. tostring(value))
end

--- Toggle the 'showtabline' option between always visible (2) and hidden (0).
function M.toggle_tabline()
  local value = vim.api.nvim_get_option_value("showtabline", {})

  if value == 2 then
    value = 0
  else
    value = 2
  end

  vim.opt.showtabline = value

  vim.notify("showtabline" .. " set to " .. tostring(value))
end

local diagnostics_active = true

--- Toggle diagnostics visibility (using Neovim's built-in LSP).
function M.toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end

local virtualtext_active = true

--- Toggle the display of virtual text in diagnostics.
function M.toggle_virtualtext()
  virtualtext_active = not virtualtext_active
  if virtualtext_active then
    vim.diagnostic.config({ virtual_text = true })
  else
    vim.diagnostic.config({ virtual_text = false })
  end
end

--- Check if a string is empty or nil.
--- @param s string? The string to check.
--- @return boolean True if the string is nil or empty, false otherwise.
function M.isempty(s)
  return s == nil or s == ""
end

--- Safely get a buffer-local option from the current buffer.
--- @param opt string The name of the buffer option.
--- @return any|nil The option value, or nil if an error occurs.
function M.get_buf_option(opt)
  local status_ok, buf_option = pcall(vim.api.nvim_get_option_value, opt, { buf = 0 })
  if not status_ok then
    return nil
  else
    return buf_option
  end
end

--- Smart quit: if the buffer is modified, prompt the user to confirm quitting.
function M.smart_quit()
  local bufnr = vim.api.nvim_get_current_buf()
  local _, modified = pcall(vim.api.nvim_get_option_value, "modified", { buf = bufnr })
  if modified then
    vim.ui.input({
      prompt = "You have unsaved changes. Quit anyway? (y/n) ",
    }, function(input)
      if input == "y" then
        vim.cmd("q!")
      end
    end)
  else
    vim.cmd("q!")
  end
end

--- Check if a plugin is loaded (via Lazy.nvim).
--- @param plugin_name string The name of the plugin to check.
--- @return boolean True if the plugin is loaded, false otherwise.
function M.is_plugin_loaded(plugin_name)
  local plugin = vim.tbl_get(require("lazy.core.config"), "plugins", plugin_name)
  return plugin and plugin._.loaded and plugin._.loaded.start == "start" or false
end

return M
