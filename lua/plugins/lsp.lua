return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      ---@class PluginLspOpts
      local userOpts = {
        servers = { eslint = {} },
        setup = {
          eslint = function()
            require("lazyvim.util").lsp.on_attach(function(client)
              if client.name == "eslint" then
                client.server_capabilities.documentFormattingProvider = true
              elseif client.name == "tsserver" then
                client.server_capabilities.documentFormattingProvider = false
              end
            end)
          end,
        },
      }
      return vim.tbl_deep_extend("force", opts, userOpts)
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      ---@module "conform"
      ---@type conform.setupOpts
      local userOpts = {
        formatters_by_ft = {
          java = { "google-java-format" },
          rust = { "rustfmt" },
          cpp = { "clang_format" },
          hpp = { "clang_format" },
          tpp = { "clang_format" },
        },
        formatters = {
          -- special handling for `clang-format-15` for libsemigroups
          clang_format = {
            command = "clang-format-15",
            condition = function(self, ctx)
              local util = require("conform.util")
              local has_root_file = util.root_file({ ".use-clang-format-15" })(self, ctx) or false
              local in_path = vim.fn.executable("clang-format-15") == 1
              return has_root_file and in_path
            end,
          },
        },
      }
      return vim.tbl_deep_extend("force", opts, userOpts)
    end,
  },
}
