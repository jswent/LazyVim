return {
  {
    "nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-cmdline",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
      cmp.setup.filetype("markdown.mdx", {
        enabled = false,
      })
      opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<C-e>"] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
      })
    end,
  },

  { "akinsho/bufferline.nvim", enabled = false },

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
        opts.views = {
          mini = {
            win_options = {
              winblend = 0,
            },
          },
        }
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
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[
      ███████╗██╗   ██╗██╗███╗   ███╗ 
      ██╔════╝██║   ██║██║████╗ ████║ 
      ███████╗██║   ██║██║██╔████╔██║ 
      ╚════██║╚██╗ ██╔╝██║██║╚██╔╝██║ 
      ███████║ ╚████╔╝ ██║██║ ╚═╝ ██║ 
      ╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ 
      ]]
      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
}
