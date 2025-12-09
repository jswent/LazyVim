---@class jswent.open
---@overload fun(filepath?: string): boolean
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.open(...)
  end,
})

M.meta = {
  desc = "Open files with macOS default applications",
}

---@class jswent.open.Config
---@field notify_success? boolean Enable success notifications
---@field notify_errors? boolean Enable error notifications
local defaults = {
  notify_success = true,
  notify_errors = true,
}

-- Current configuration (initialized from defaults)
M.config = vim.deepcopy(defaults)

---@private
---@param opts jswent.open.Config
function M._update_config(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

---Setup the open module with configuration
---@param opts? jswent.open.Config
function M.setup(opts)
  if opts then
    M._update_config(opts)
  end
end

---Load the open module (setup autocmds and user commands)
function M.load()
  M._setup_autocmd_once()
  M._setup_user_commands_once()
end

---@param filepath? string
---@param opts? jswent.open.Config
---@return boolean success
function M.open(filepath, opts)
  opts = vim.tbl_deep_extend("force", M.config, opts or {})

  -- If no filepath provided, try current buffer
  if not filepath or filepath == "" then
    local current_file, err = M._get_current_buffer_file()
    if not current_file then
      if opts.notify_errors then
        vim.notify(err or "No file to open", vim.log.levels.ERROR)
      end
      return false
    end
    filepath = current_file
  else
    -- Handle relative paths from current working directory
    if not vim.startswith(filepath, "/") and not vim.startswith(filepath, "~") then
      filepath = vim.fn.getcwd() .. "/" .. filepath
    end
  end

  return M._open_with_macos(filepath, opts)
end

---@private
---@return string|nil, string|nil
function M._get_current_buffer_file()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  if bufname == "" then
    return nil, "Current buffer has no associated file"
  end

  -- Check if buffer is modified and might not be saved
  if vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
    vim.notify("Buffer has unsaved changes", vim.log.levels.WARN)
  end

  return bufname, nil
end

---@private
---@param filepath string
---@param opts jswent.open.Config
---@return boolean success
function M._open_with_macos(filepath, opts)
  if not filepath or filepath == "" then
    if opts.notify_errors then
      vim.notify("No file path provided", vim.log.levels.ERROR)
    end
    return false
  end

  -- Normalize and expand the path
  local expanded_path = vim.fn.expand(filepath)
  local normalized_path = vim.fs.normalize(expanded_path)

  -- Check if file/directory exists using modern API
  local stat = vim.uv.fs_stat(normalized_path)
  if not stat then
    if opts.notify_errors then
      vim.notify(string.format("File or directory does not exist: %s", normalized_path), vim.log.levels.ERROR)
    end
    return false
  end

  -- Execute the macOS open command
  local cmd = { "open", normalized_path }

  -- Use vim.system for better async handling (Neovim 0.10+)
  if vim.system then
    vim.system(cmd, {}, function(result)
      if result.code == 0 then
        if opts.notify_success then
          vim.schedule(function()
            vim.notify(string.format("Opened: %s", normalized_path), vim.log.levels.INFO)
          end)
        end
      else
        if opts.notify_errors then
          vim.schedule(function()
            vim.notify(
              string.format("Failed to open: %s\nError: %s", normalized_path, result.stderr),
              vim.log.levels.ERROR
            )
          end)
        end
      end
    end)
  else
    -- Fallback for older Neovim versions
    local result = vim.fn.system(cmd)
    local exit_code = vim.v.shell_error

    if exit_code == 0 then
      if opts.notify_success then
        vim.notify(string.format("Opened: %s", normalized_path), vim.log.levels.INFO)
      end
    else
      if opts.notify_errors then
        vim.notify(string.format("Failed to open: %s\nError: %s", normalized_path, result), vim.log.levels.ERROR)
      end
    end
  end

  return true
end

---@private
---@return boolean
function M._is_macos()
  return vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1
end

---@private
---@return boolean
function M._is_open_available()
  return M._is_macos() and vim.fn.executable("open") == 1
end

---@private
---@param bufnr integer
---@return boolean
function M._buffer_has_file(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == "" then
    return false
  end

  -- Check if the file actually exists using modern API
  local stat = vim.uv.fs_stat(bufname)
  return stat ~= nil
end

---@private
function M.health()
  local macos_ok = M._is_macos()

  if macos_ok then
    vim.health.ok("Running on macOS")
  else
    vim.health.error("Not running on macOS - this module requires macOS")
    return
  end

  local open_ok = vim.fn.executable("open") == 1
  if open_ok then
    vim.health.ok("`open` command available")
  else
    vim.health.error("`open` command not found")
  end
end

---@return { mode: string, lhs: string, rhs: function, opts: table }[]
function M.get_keymaps()
  if not M._is_open_available() then
    return {}
  end

  return {
    {
      mode = "n",
      lhs = "<leader>o",
      rhs = function()
        M()
      end,
      opts = { desc = "Open current file with default app" },
    },
  }
end

---@param bufnr integer
---@return { mode: string, lhs: string, rhs: function, opts: table }[]
function M.get_buffer_keymaps(bufnr)
  if not M._is_open_available() or not M._buffer_has_file(bufnr) then
    return {}
  end

  return {
    {
      mode = "n",
      lhs = "bO",
      rhs = function()
        M()
      end,
      opts = { desc = "Open buffer file with default app", buffer = bufnr },
    },
  }
end

---Set up autocommands to apply buffer-local keymaps when files are detected
function M.setup_autocmd()
  vim.api.nvim_create_augroup("OpenKeymaps", { clear = true })

  -- Apply keymaps when a buffer gets a file
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
    group = "OpenKeymaps",
    callback = function(args)
      vim.schedule(function()
        M.apply_buffer_keymaps({ bufnr = args.buf })
      end)
    end,
    desc = "Apply Open buffer keymaps when file is detected",
  })

  -- Clean up keymaps when buffer loses its file association
  vim.api.nvim_create_autocmd({ "BufUnload", "BufDelete" }, {
    group = "OpenKeymaps",
    callback = function(args)
      -- Buffer-local keymaps are automatically cleaned up when buffer is deleted
    end,
    desc = "Cleanup Open buffer keymaps",
  })
end

-- Guarded version of setup_autocmd to call from apply_keymaps
function M._setup_autocmd_once()
  if M._autocmd_initialized then
    return
  end
  M._autocmd_initialized = true

  M.setup_autocmd()
end

---Set up user commands for opening files
function M.setup_user_commands()
  if not M._is_open_available() then
    return
  end

  vim.api.nvim_create_user_command("Open", function(cmd_opts)
    M.open(cmd_opts.args ~= "" and cmd_opts.args or nil)
  end, {
    nargs = "?",
    complete = "file",
    desc = "Open file with macOS default application",
  })

  vim.api.nvim_create_user_command("O", function(cmd_opts)
    M.open(cmd_opts.args ~= "" and cmd_opts.args or nil)
  end, {
    nargs = "?",
    complete = "file",
    desc = "Alias for :Open command",
  })
end

-- Guarded version of setup_user_commands to call from apply_keymaps
function M._setup_user_commands_once()
  if M._user_commands_initialized then
    return
  end
  M._user_commands_initialized = true

  M.setup_user_commands()
end

---Apply Open keymaps globally or buffer-local
---@param opts? { bufnr?: integer, global?: boolean }
function M.apply_keymaps(opts)
  opts = opts or {}

  if vim.g.jswent_open_enabled == false then
    return
  end

  -- Apply global keymaps
  if not opts.bufnr or opts.global then
    for _, m in ipairs(M.get_keymaps()) do
      local keymap_opts = vim.tbl_deep_extend("force", { silent = true }, m.opts or {})
      if opts.bufnr and not opts.global then
        keymap_opts.buffer = opts.bufnr
      end
      vim.keymap.set(m.mode, m.lhs, m.rhs, keymap_opts)
    end
  end

  -- Apply buffer-local keymaps
  if opts.bufnr then
    M.apply_buffer_keymaps({ bufnr = opts.bufnr })
  end

  M._setup_autocmd_once()
  M._setup_user_commands_once()
end

---Apply buffer-local keymaps for a specific buffer
---@param opts { bufnr: integer }
function M.apply_buffer_keymaps(opts)
  if not opts.bufnr then
    return
  end

  if vim.g.jswent_open_enabled == false then
    return
  end

  for _, m in ipairs(M.get_buffer_keymaps(opts.bufnr)) do
    local keymap_opts = vim.tbl_deep_extend("force", { silent = true }, m.opts or {})
    vim.keymap.set(m.mode, m.lhs, m.rhs, keymap_opts)
  end
end

return M
