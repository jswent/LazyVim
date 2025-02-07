return {
  -- {
  --   "folke/which-key.nvim",
  --   event = "VeryLazy",
  --   opts = function(_, opts)
  --     opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
  --       ["<leader>f"] = { name = "+find" },
  --     })
  --   end,
  -- },

  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      require("lazyvim.util").lsp.on_attach(function(client, buffer)
        if client.supports_method("textDocument/documentSymbol") then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        icons = require("lazyvim.config").icons.kinds,
        lazy_update_context = true,
      }
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      -- local events = require("neo-tree.events")
      opts.filesystem = vim.tbl_deep_extend("force", opts.filesystem, {
        hijack_netrw_behavior = "open_current",
        filtered_items = {
          never_show = {
            ".DS_Store",
          },
        },
      })
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        {
          event = "neo_tree_window_after_close",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,
        },
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,
        },
        -- {
        --   event = events.FILE_OPENED,
        --   handler = function(file_path)
        --     require("neo-tree.command").execute({})
        --   end,
        -- },
      })
    end,
  },

  {
    "nacro90/numb.nvim",
    lazy = false,
    config = function()
      require("numb").setup()
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_browser = "/Applications/Min.app"
    end,
    ft = { "markdown" },
  },
}
