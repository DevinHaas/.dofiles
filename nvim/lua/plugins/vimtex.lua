return {
  {
    "micangl/cmp-vimtex",
    ft = "tex",
    dependencies = { "hrsh7th/nvim-cmp", "lervag/vimtex" }, -- Explicitly declare dependencies
    lazy = true, -- It's a cmp source, so let cmp load it
  },
  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    config = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
    },
  },
}
