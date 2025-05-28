return {

  { "akinsho/bufferline.nvim", enabled = false },

  {
    "saghen/blink.cmp",
    lazy = true,
    ---@module "blink.cmp"
    ---@param opts blink.cmp.Config
    opts = function(_, opts)
      opts.enabled = function()
        if vim.tbl_contains({ "markdown" }, vim.bo.filetype) then
          return false
        end
        return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
      end
      --- @type blink.cmp.CmdlineConfig
      opts.cmdline = {
        enabled = true,
        keymap = {
          -- ["<Tab>"] = { "show", "accept" },
          ["<C-Space>"] = { "accept" },
        },
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Commands
          if type == ":" or type == "@" then
            return { "cmdline" }
          end
          return {}
        end,
        completion = { ghost_text = { enabled = true } },
      }
      opts.sources.min_keyword_length = function(ctx)
        -- only applies when typing a command, doesn't apply to arguments
        if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
          return 4
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
    enabled = function()
      return vim.g.jswent_cybu_enabled
    end,
    lazy = false,
    config = function()
      local opts = {}

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

      require("cybu").setup(opts)
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
      -- Snacks.picker configuration
      opts.picker = opts.picker or {}

      opts.picker.matcher = opts.picker.matcher or {}
      opts.picker.matcher.frecency = true

      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.files = opts.picker.sources.files or {}
      opts.picker.sources.files.hidden = true

      return opts
    end,
  },
}
