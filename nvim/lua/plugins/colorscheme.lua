return {
  {
    "rebelot/kanagawa.nvim", -- The plugin name
    lazy = false, -- Load immediately on startup
    priority = 1000, -- High priority to ensure it loads before other plugins
    opts = {
      compile = false, -- Enable compiling the colorscheme
      undercurl = true, -- Enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = true, -- Do not set background color (change to true for transparency)
      dimInactive = false, -- Dim inactive windows
      terminalColors = true, -- Define terminal colors
      colors = { -- Add or modify colors
        palette = {},
        theme = {
          wave = {},
          lotus = {},
          dragon = {},
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
      overrides = function(colors) -- Add or modify highlights
        local theme = colors.theme
        return {
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },

          -- Save an hlgroup with dark background and dimmed foreground
          -- so that you can use it where your still want darker windows.
          -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

          -- Popular plugins that open floats will link to NormalFloat by default;
          -- set their background accordingly if you wish to keep them dark and borderless
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        }
      end,
      theme = "wave", -- Load the "wave" theme
      background = { -- Map background to theme
        dark = "wave", -- Use "wave" for dark mode
        light = "lotus", -- Use "lotus" for light mode
      },
    },
    config = function(_, opts) -- Config function to apply the colorscheme
      require("kanagawa").setup(opts) -- Setup with the provided options (Lazy.nvim handles this automatically via opts)
      vim.cmd("colorscheme kanagawa") -- Apply the colorscheme
    end,
  },
}
