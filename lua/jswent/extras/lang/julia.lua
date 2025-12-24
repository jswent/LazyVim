-- Julia LSP configuration with custom sysimage support
--
-- Depot Detection:
--   1. Checks JULIA_DEPOT_PATH environment variable
--   2. Falls back to ~/.julia (default depot location)
--   Requires julia binary at {depot}/bin/julia
--
-- Environment: {depot}/environments/nvim-lspconfig/
--
-- To set up the environment (using default depot ~/.julia):
--   julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add(["LanguageServer", "SymbolServer", "StaticLint", "PackageCompiler"])'
--
-- Then create the sysimage for faster startup (optional but recommended):
--   cd ~/.julia/environments/nvim-lspconfig
--   julia --project=. -e 'using PackageCompiler; create_sysimage([:LanguageServer, :SymbolServer, :StaticLint]; sysimage_path="julials.so")'

---@return string|nil depot_path The Julia depot path if found
---@return string|nil error_message Error message if depot not found
local function get_depot_path()
  -- 1. Check JULIA_DEPOT_PATH environment variable
  local depot = vim.env.JULIA_DEPOT_PATH
  if depot and depot ~= "" then
    return depot, nil
  end

  -- TODO
  -- 2. Find julia in PATH and resolve to depot

  -- 3. Check default ~/.julia location
  local default_depot = vim.fn.expand("~/.julia")
  local default_julia_bin = default_depot .. "/bin/julia"
  if vim.fn.executable(default_julia_bin) == 1 then
    return default_depot, nil
  end

  -- No depot found, return err
  return nil, "Julia depot not found. Skipping julia extra."
end

local julia_depot, err = get_depot_path()
if not julia_depot then
  vim.notify(err, vim.log.levels.WARN)
  return {}
end

local julia_bin = julia_depot .. "/bin/julia"
local env_path = julia_depot .. "/environments/nvim-lspconfig/"
local sysimage_path = env_path .. "julials.so"

-- Build the julia command with sysimage if it exists
local function get_julia_cmd()
  local cmd = {
    julia_bin,
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
