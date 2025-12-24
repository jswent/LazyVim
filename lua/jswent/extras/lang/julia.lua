-- Julia LSP configuration with custom sysimage support
-- Environment: ~/.local/julia/environments/nvim-lspconfig/
--
-- To set up the environment, run:
--   julia --project=~/.local/julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add(["LanguageServer", "SymbolServer", "StaticLint", "PackageCompiler"])'
--
-- Then create the sysimage for faster startup (run from the environment directory):
--   cd ~/.local/julia/environments/nvim-lspconfig
--   julia --project=. -e 'using PackageCompiler; create_sysimage([:LanguageServer, :SymbolServer, :StaticLint]; sysimage_path="julials.so")'

local env_path = vim.fn.expand("~/.local/julia/environments/nvim-lspconfig/")
local sysimage_path = env_path .. "julials.so"

-- Build the julia command with sysimage if it exists
local function get_julia_cmd()
  local cmd = {
    "julia",
    "--project=" .. env_path,
    "--startup-file=no",
    "--history-file=no",
  }

  -- Use sysimage if it exists for faster startup
  if vim.fn.filereadable(sysimage_path) == 1 then
    table.insert(cmd, "--sysimage=" .. sysimage_path)
    table.insert(cmd, "--sysimage-native-code=yes")
  end

  table.insert(cmd, "-e")
  table.insert(
    cmd,
    [[
    using LanguageServer, SymbolServer, StaticLint
    depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
    project_path = let
        p = Base.current_project(pwd())
        p !== nothing ? dirname(p) : pwd()
    end
    @info "Starting Julia language server" pwd() project_path depot_path
    server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
    server.runlinter = true
    run(server)
  ]]
  )

  return cmd
end

return {
  recommended = function()
    return LazyVim.extras.wants({
      ft = { "julia" },
      root = { "Project.toml" },
    })
  end,

  {
    "folke/lazy.nvim",
    event = "FileType julia",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "julia",
        callback = function()
          vim.opt_local.shiftwidth = 4
          vim.opt_local.tabstop = 4
          vim.opt_local.softtabstop = 4
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        disable = { "julia" }, -- use vim syntax instead (faster on large files)
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        julials = {
          mason = false, -- use custom cmd, don't let mason manage this
          settings = {
            julia = {
              completionmode = "qualify",
              lint = { missingrefs = "none" },
              format = {
                indent = 4,
              },
            },
          },
        },
      },
      setup = {
        julials = function(_, opts)
          opts.cmd = get_julia_cmd()
          return false -- continue with default lspconfig setup
        end,
      },
    },
  },

  -- cmp integration
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = { "kdheepak/cmp-latex-symbols" },
    opts = function(_, opts)
      table.insert(opts.sources, {
        name = "latex_symbols",
        option = {
          strategy = 0, -- mixed
        },
      })
    end,
  },

  -- blink.cmp integration
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "kdheepak/cmp-latex-symbols", "saghen/blink.compat" },
    opts = {
      sources = {
        compat = { "latex_symbols" },
        providers = {
          latex_symbols = {
            kind = "LatexSymbols",
            async = true,
            opts = {
              strategy = 0, -- mixed
            },
          },
        },
      },
    },
  },
}
