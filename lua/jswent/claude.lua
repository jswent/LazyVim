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

---@private
function M.health()
  local ok = vim.fn.executable("claude") == 1
  Snacks.health[ok and "ok" or "error"](("{claude} %sinstalled"):format(ok and "" or "not "))
end

return M
