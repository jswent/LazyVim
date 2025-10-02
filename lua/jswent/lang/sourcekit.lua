local lsp_installed = vim.fn.executable("sourcekit-lsp")

if lsp_installed == 0 or vim.g.jswent_sourcekit_enabled == false then
  return {}
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- These options are (now) included in default lspconfig
      local sourcekit_opts = {
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
      }

      -- If using Neovim >= 0.11, use new native API
      if vim.fn.has("nvim-0.11") == 1 then
        vim.lsp.enable("sourcekit")
        vim.lsp.config("sourcekit", {
          settings = {
            ["sourcekit"] = sourcekit_opts,
          },
        })
      -- Otherwise, fallback to previous setup
      else
        require("lspconfig").sourcekit.setup(sourcekit_opts)
      end
    end,
  },
}
