---@class jswent.claude
---@overload fun(opts?: jswent.claude.Config): snacks.win
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.open(...)
  end,
})

M.meta = {
  desc = "Open Claude Code in a float",
}

---@class jswent.claude.Config: snacks.terminal.Opts
---@field args? string[]
local defaults = {
  win = {
    style = "claude",
  },
}

Snacks.config.style("claude", {})

-- Opens Claude Code terminal UI in a float window
---@param opts? jswent.claude.Config
function M.open(opts)
  ---@type jswent.claude.Config
  opts = Snacks.config.get("claude", defaults, opts)

  local cmd = { "claude" }
  vim.list_extend(cmd, opts.args or {})

  return Snacks.terminal(cmd, opts)
end

local function is_installed()
  return vim.fn.executable("claude") == 1
end

---@private
function M.health()
  local ok = is_installed()
  Snacks.health[ok and "ok" or "error"](("{claude} %sinstalled"):format(ok and "" or "not "))
end

--- @return { mode: string, lhs: string, rhs: function, opts: table }[]
function M.get_keymaps()
  if not is_installed() then
    return {}
  end

  return {
    {
      mode = "n",
      lhs = "<leader>cc",
      rhs = function()
        M({ cwd = LazyVim.root.git() })
      end,
      opts = { desc = "Claude Code (Root Dir)" },
    },
    {
      mode = "n",
      lhs = "<leader>cC",
      rhs = function()
        M()
      end,
      opts = { desc = "Claude Code (cwd)" },
    },
  }
end

--- Set up autocommand to re-apply Claude keymaps after LSP attaches
function M.setup_autocmd()
  vim.api.nvim_create_augroup("ClaudeKeymaps", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = "ClaudeKeymaps",
    callback = function(args)
      -- delay execution to run after lazyvim.plugins.lsp.keymaps.on_attach
      vim.schedule(function()
        M.apply_keymaps({ bufnr = args.buf })
      end)
    end,
    desc = "Re-apply Claude keymaps after LSP attaches",
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

--- Apply Claude keymaps globally or buffer-local
--- @param opts? { bufnr?: integer, lsp_attach?: boolean }
function M.apply_keymaps(opts)
  opts = opts or {}

  if vim.g.jswent_claude_enabled == false then
    return
  end

  for _, m in ipairs(M.get_keymaps()) do
    local keymap_opts = vim.tbl_deep_extend("force", { silent = true }, m.opts or {})
    if opts.bufnr then
      keymap_opts.buffer = opts.bufnr
    end
    vim.keymap.set(m.mode, m.lhs, m.rhs, keymap_opts)
  end

  if opts.lsp_attach then
    M._setup_autocmd_once()
  end
end

return M
