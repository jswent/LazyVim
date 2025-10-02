return {
  {
    "SmiteshP/nvim-navic",
    event = { "LspAttach", "BufReadPost" },
    init = function()
      vim.g.navic_silence = true
    end,
    opts = {
      lsp = { auto_attach = true },
      highlight = true,
      depth_limit = 5,
      icons = LazyVim.config.icons.kinds,
      lazy_update_context = false, -- Keep false for fast cursor updates
    },
    config = function(_, opts)
      local navic = require("nvim-navic")
      navic.setup(opts)

      -- Setup winbar after navic is configured
      require("jswent.winbar").setup()
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
