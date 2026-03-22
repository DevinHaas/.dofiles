return {
  "supermaven-inc/supermaven-nvim",
  opts = {
    keymaps = {
      accept_suggestion = "<Tab>",
      clear_suggestion = "<C-]>",
      accept_word = "<C-j>",
    },
    ignore_filetypes = { cpp = true },
    colors = {
      suggestion_color = "#858585",
      cterm = 244,
    },
    log_level = "info",
    disable_inline_completion = false,
    disable_keymaps = false,
    condition = function()
      return false
    end,
  }, -- or omit entirely if no options needed
}
