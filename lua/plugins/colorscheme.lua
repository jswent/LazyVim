return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
    opts = function(_, opts)
      local transparent = require("jswent.transparent")
      if transparent.get_state() == true then
        opts.transparent = true
      end
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = function(_, opts)
      local transparent = require("jswent.transparent")
      if transparent.get_state() == true then
        opts.transparent = true
        opts.styles = opts.styles or {}
        opts.styles = vim.tbl_deep_extend("force", opts.styles, {
          sidebars = "transparent",
          floats = "transparent",
        })
        opts.on_highlights = function(hl, c)
          if vim.o.background == "light" then
            hl.NeoTreeFileStats = { link = "NeoTreeGitModified" }
          end
        end
      end
    end,
  },
}
