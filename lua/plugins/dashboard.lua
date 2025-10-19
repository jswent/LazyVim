---@return snacks.dashboard.Section?
local function config_git_info_section()
  local config_path = vim.fn.stdpath("config")
  local is_git_repo = vim.fn.systemlist("git -C " .. config_path .. " rev-parse --is-inside-work-tree")[1]

  if is_git_repo == "false" then
    return nil
  end

  local branch = vim.fn.systemlist("git -C " .. config_path .. " rev-parse --abbrev-ref HEAD")[1]
  local commit = vim.fn.systemlist("git -C " .. config_path .. " rev-parse --short HEAD")[1]

  -- Check if behind origin
  local text = {
    { branch, hl = "special" },
    { "-", hl = "special" },
    { commit, hl = "special" },
  }

  -- Check if there's an upstream branch
  local upstream = vim.fn.system("git -C " .. config_path .. " rev-parse --abbrev-ref @{u} 2>/dev/null")
  if vim.v.shell_error == 0 and upstream ~= "" then
    -- Count commits behind
    local behind = vim.fn.systemlist("git -C " .. config_path .. " rev-list --count HEAD..@{u}")[1]
    if behind and tonumber(behind) and tonumber(behind) > 0 then
      table.insert(text, { " (", hl = "special" })
      table.insert(text, { behind .. "", hl = "DiagnosticWarn" })
      table.insert(text, { ")", hl = "special" })
    end
  end

  return {
    align = "center",
    text = text,
  }
end

return {
  {
    "folke/snacks.nvim",
    ---@param opts snacks.Config
    opts = function(_, opts)
      local Snacks = _G.Snacks or require("snacks")
      Snacks.dashboard.sections.config_git_info = config_git_info_section

      local is_large_window = vim.o.columns >= 120
      opts.dashboard = vim.tbl_deep_extend("force", opts.dashboard, {
        preset = vim.tbl_deep_extend("force", opts.dashboard.preset or {}, {
          header = [[
███████╗██╗   ██╗██╗███╗   ███╗ 
██╔════╝██║   ██║██║████╗ ████║ 
███████╗██║   ██║██║██╔████╔██║ 
╚════██║╚██╗ ██╔╝██║██║╚██╔╝██║ 
███████║ ╚████╔╝ ██║██║ ╚═╝ ██║ 
╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        }),
        sections = (function()
          local sections = { { section = "header" } }
          local colorscripts = require("jswent.colorscripts")
          local random_colorscript = colorscripts.random()

          if is_large_window then
            table.insert(sections, {
              pane = 2,
              section = "terminal",
              cmd = random_colorscript.cmd,
              -- height = random_colorscript.height,
              height = 7,
              padding = random_colorscript.padding,
            })
          end

          table.insert(sections, { section = "keys", gap = 1, padding = 1 })

          if is_large_window then
            table.insert(sections, {
              pane = 2,
              icon = " ",
              title = "Recent Files",
              section = "recent_files",
              indent = 2,
              padding = 1,
            })
            table.insert(sections, {
              pane = 2,
              icon = " ",
              title = "Projects",
              section = "projects",
              indent = 2,
              padding = 1,
            })
            table.insert(sections, {
              pane = 2,
              icon = " ",
              title = "Git Status",
              section = "terminal",
              enabled = function()
                return Snacks.git.get_root() ~= nil
              end,
              cmd = "git status --short --branch --renames",
              height = 5,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            })
          end

          table.insert(sections, { section = "startup" })
          table.insert(sections, { section = "config_git_info" })

          return sections
        end)(),
      })

      return opts
    end,
  },
}
