return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      ---@class PluginLspOpts
      local userOpts = {
        servers = {
          eslint = {},
        },
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
        },
      }
      return vim.tbl_deep_extend("force", opts, userOpts)
    end,
  },
}
