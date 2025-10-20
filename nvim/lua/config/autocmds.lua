-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.c",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  callback = function()
    vim.cmd("checktime")
  end,
  desc = "Check for external file changes on CursorHold",
})
