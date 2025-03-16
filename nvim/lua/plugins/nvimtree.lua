return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup({
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set("n", "t", api.node.open.tab, opts("Tab"))
      end,
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      sort = {
        sorter = "case_sensitive",
      },

      view = {
        width = 30,
        relativenumber = true,
        side = "right",
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
        custom = {
          "node_modules/.*",
          "^.idea$", -- Hide `.idea`
          "^.next$", -- Hide `.next`
          "^.DS_Store$", -- Hide `.DS_Store`
        },
      },
      git = {
        ignore = false, -- Show files ignored by Git
      },

      log = {

        enable = true,
        truncate = true,
        types = {
          diagnostics = true,
          git = true,
          profile = true,
          watcher = true,
        },
      },
    })

    if vim.fn.argc(-1) == 0 then
      vim.cmd("NvimTreeFocus")
    end
  end,
}
