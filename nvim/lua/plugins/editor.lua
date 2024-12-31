return {
  -- Highlight colors
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    priority = 1000,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions

      telescope.setup({
        defaults = {
          -- Default configuration
          mappings = {
            i = {
              ["<C-h>"] = "which_key", -- Map <C-h> to show picker key hints
            },
          },
          wrap_results = true,
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
          },
          sorting_strategy = "ascending",
          winblend = 0,
        },
        pickers = {
          -- Custom configuration for built-in pickers
          diagnostics = {
            theme = "ivy",
            initial_mode = "normal",
            layout_config = {
              preview_cutoff = 9999,
            },
          },
        },
        extensions = {
          -- Configuration for extensions
          file_browser = {
            theme = "dropdown",
            hijack_netrw = true,
            mappings = {
              ["n"] = {
                ["N"] = fb_actions.create,
                ["h"] = fb_actions.goto_parent_dir,
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
              },
            },
          },
        },
      })

      -- Load Telescope extensions
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")

      -- Add custom keybindings
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Telescope recent files" })
      vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Telescope live grep" })

      vim.keymap.set("n", "sf", function()
        local function telescope_buffer_dir()
          return vim.fn.expand("%:p:h")
        end

        telescope.extensions.file_browser.file_browser({
          path = "%:p:h",
          cwd = telescope_buffer_dir(),
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          previewer = false,
          initial_mode = "normal",
          layout_config = { height = 40 },
        })
      end, { desc = "Open File Browser with the path of the current buffer" })
    end,
  },
}
