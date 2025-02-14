return {

  { "akinsho/bufferline.nvim", enabled = false },

  {
    "saghen/blink.cmp",
    lazy = true,
    ---@module "blink.cmp"
    ---@param opts blink.cmp.Config
    opts = function(_, opts)
      opts.sources.cmdline = function()
        local type = vim.fn.getcmdtype()
        -- Commands
        if type == ":" or type == "@" then
          return { "cmdline" }
        end
        return {}
      end
      opts.sources.min_keyword_length = function(ctx)
        -- only applies when typing a command, doesn't apply to arguments
        if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
          return 3
        end
        return 0
      end
      opts.completion.menu.draw.columns = function(ctx)
        if ctx.mode == "cmdline" then
          return { { "label", "label_description", gap = 1 } }
        else
          return { { "kind_icon" }, { "label", "label_description", gap = 1 } }
        end
      end
      opts.keymap = vim.tbl_deep_extend("force", opts.keymap, {
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      })
      return opts
    end,
  },

  {
    "ghillb/cybu.nvim",
    lazy = false,
    config = function(_, opts)
      local cybu = require("cybu")

      opts.position = {
        relative_to = "win",
        anchor = "topright",
      }
      opts.display_time = 1750
      opts.style = {
        path = "relative",
        border = "rounded",
        separator = " ",
        prefix = "…",
        padding = 1,
        hide_buffer_id = true,
        devicons = {
          enabled = true,
          colored = true,
        },
      }

      cybu.setup(opts)
    end,
  },

  {
    "folke/noice.nvim",
    lazy = true,
    opts = function(_, opts)
      local transparent = require("jswent.transparent")
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = {
          skip = true,
        },
      })
      if transparent.get_state() == true then
        opts.views = opts.views or {}
        opts.views = vim.tbl_deep_extend("force", opts.views, {
          mini = {
            win_options = {
              winblend = 0,
            },
          },
        })
      end
    end,
  },

  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = function(_, opts)
      local transparent = require("jswent.transparent")
      if transparent.get_state() == true then
        opts.background_colour = "#000000"
      end
    end,
  },

  {
    "folke/snacks.nvim",
    ---@param opts snacks.Config
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      opts.picker = vim.tbl_deep_extend("force", opts.picker, {
        frecency = true,
      })

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
              height = random_colorscript.height,
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
          return sections
        end)(),
      })

      return opts
    end,
  },
}
