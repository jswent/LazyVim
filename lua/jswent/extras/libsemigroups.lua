local M = {}

---@type table<string, string>
M.ft_by_extension = {
  tpp = "cpp",
}

---@module "lazy"
---@type table<LazyPluginSpec>
M.specs = {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      ---@module "conform"
      ---@type conform.setupOpts
      local lsgOpts = {
        formatters_by_ft = {
          cpp = { "clang_format_lsg" },
          hpp = { "clang_format_lsg" },
          tpp = { "clang_format_lsg" },
        },
        formatters = {
          clang_format_lsg = {
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
      return vim.tbl_deep_extend("force", opts, lsgOpts)
    end,
  },
}

vim.filetype.add({
  extension = M.ft_by_extension,
})

return M.specs
