return {
  {
    "SmiteshP/nvim-navic",
    event = "VimEnter",
    commit = "8649f694d3e76ee10c19255dece6411c29206a54",
    init = function()
      vim.g.navic_silence = true
      require("lazyvim.util").lsp.on_attach(function(client, buffer)
        if client.supports_method("textDocument/documentSymbol") then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      require("jswent.winbar")
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        icons = LazyVim.config.icons.kinds,
        lazy_update_context = true,
      }
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
    "nvim-mini/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
}
