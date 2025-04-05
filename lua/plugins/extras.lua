local M = {}

-- Telescope configuration
M.telescope = {
  enabled = function()
    return vim.g.lazyvim_picker == "telescope"
  end,
  config = {
    {
      "telescope.nvim",
      dependencies = {
        "nvim-telescope/telescope-file-browser.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
      },
      keys = {
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Project grep" },
        { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      },
      config = function(_, opts)
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local fb_actions = require("telescope").extensions.file_browser.actions
        local icons = require("jswent.icons")

        opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
          prompt_prefix = icons.ui.Telescope .. " ",
          selection_caret = " ",
          path_display = { "smart" },
          winblend = 0,
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,

              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              ["<C-b>"] = actions.results_scrolling_up,
              ["<C-f>"] = actions.results_scrolling_down,

              ["<C-c>"] = actions.close,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,

              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,

              ["<c-d>"] = require("telescope.actions").delete_buffer,

              -- ["<C-u>"] = actions.preview_scrolling_up,
              -- ["<C-d>"] = actions.preview_scrolling_down,

              -- ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<Tab>"] = actions.close,
              ["<S-Tab>"] = actions.close,
              -- ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-h>"] = actions.which_key, -- keys from pressing <C-h>
              ["<esc>"] = actions.close,
            },

            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-b>"] = actions.results_scrolling_up,
              ["<C-f>"] = actions.results_scrolling_down,

              ["<Tab>"] = actions.close,
              ["<S-Tab>"] = actions.close,
              -- ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              -- ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["q"] = actions.close,
              ["dd"] = require("telescope.actions").delete_buffer,
              ["s"] = actions.select_horizontal,
              ["v"] = actions.select_vertical,
              ["t"] = actions.select_tab,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,

              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,

              ["?"] = actions.which_key,
            },
          },
        })
        opts.extensions = {
          file_browser = {
            theme = "dropdown",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
              -- your custom insert mode mappings
              ["n"] = {
                -- your custom normal mode mappings
                ["N"] = fb_actions.create,
                ["h"] = fb_actions.goto_parent_dir,
                ["/"] = function()
                  vim.cmd("startinsert")
                end,
                ["<C-u>"] = function(prompt_bufnr)
                  for i = 1, 10 do
                    actions.move_selection_previous(prompt_bufnr)
                  end
                end,
                ["<C-d>"] = function(prompt_bufnr)
                  for i = 1, 10 do
                    actions.move_selection_next(prompt_bufnr)
                  end
                end,
                ["<PageUp>"] = actions.preview_scrolling_up,
                ["<PageDown>"] = actions.preview_scrolling_down,
              },
            },
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),
          },
        }
        opts.pickers = {
          live_grep = {
            theme = "dropdown",
          },
          grep_string = {
            theme = "dropdown",
          },
          find_files = {
            theme = "dropdown",
            previewer = false,
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
          },
          planets = {
            show_pluto = true,
            show_moon = true,
          },
          colorscheme = {},
          lsp_references = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_definitions = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_declarations = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_implementations = {
            theme = "dropdown",
            initial_mode = "normal",
          },
        }
        telescope.setup(opts)
        telescope.load_extension("file_browser")
        telescope.load_extension("ui-select")
        telescope.load_extension("notify")
      end,
    },
  },
}

M.dashboard = {
  enabled = function()
    -- return require("lazy.core.config").spec.plugins["dashboard-nvim"] ~= nil
    return false
  end,
  config = {
    {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
      opts = function(_, opts)
        local logo = [[
      ███████╗██╗   ██╗██╗███╗   ███╗ 
      ██╔════╝██║   ██║██║████╗ ████║ 
      ███████╗██║   ██║██║██╔████╔██║ 
      ╚════██║╚██╗ ██╔╝██║██║╚██╔╝██║ 
      ███████║ ╚████╔╝ ██║██║ ╚═╝ ██║ 
      ╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ 
      ]]
        logo = string.rep("\n", 8) .. logo .. "\n\n"
        opts.config.header = vim.split(logo, "\n")
      end,
    },
  },
}

M.nvim_cmp = {
  enabled = function()
    return vim.g.lazyvim_cmp == "nvim-cmp"
  end,
  config = {
    {
      "nvim-cmp",
      event = "VeryLazy",
      dependencies = {
        "hrsh7th/cmp-cmdline",
      },
      ---@param opts cmp.ConfigSchema
      opts = function(_, opts)
        local cmp = require("cmp")
        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "path" },
          }, {
            {
              name = "cmdline",
              option = {
                ignore_cmds = { "Man", "!" },
              },
            },
          }),
        })
        cmp.setup.filetype("markdown.mdx", {
          enabled = false,
        })
        opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          -- ["<Tab>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_next_item()
          --   else
          --     fallback()
          --   end
          -- end, { "i", "s" }),
          -- ["<S-Tab>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_prev_item()
          --   else
          --     fallback()
          --   end
          -- end, { "i", "s" }),
        })
      end,
    },
  },
}

-- Add more extras here following the same pattern
-- Example:
-- M.some_feature = {
--   enabled = function()
--     return some_condition
--   end,
--   config = {
--     -- feature configuration
--   }
-- }

-- Return only enabled configurations
local enabled_configs = {}
for _, extra in pairs(M) do
  if extra.enabled and extra.enabled() then
    vim.list_extend(enabled_configs, extra.config)
  end
end
return enabled_configs
