return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile", "LazyFile", "VeryLazy" },
  build = function()
    local TS = require("nvim-treesitter")
    if not TS.get_installed then
      LazyVim.error("Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.")
      return
    end
    LazyVim.treesitter.ensure_treesitter_cli(function()
      TS.update(nil, { summary = true })
    end)
  end,
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  lazy = vim.fn.argc(-1) == 0,
  opts = {
    -- enable syntax highlighting
    highlight = {
      enable = true,
    },
    modules = {},
    -- enable indentation
    indent = { enable = true },
    -- enable autotagging (w/ nvim-ts-autotag plugin)
    autotag = {
      enable = true,
    },
    -- ensure these language parsers are installed
    ensure_installed = {
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "prisma",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },
  config = function(_, opts)
    local TS = require("nvim-treesitter")

    setmetatable(require("nvim-treesitter.install"), {
      __newindex = function(_, k)
        if k == "compilers" then
          vim.schedule(function()
            LazyVim.error({
              "Setting custom compilers for `nvim-treesitter` is no longer supported.",
              "",
              "For more info, see:",
              "- [compilers](https://docs.rs/cc/latest/cc/#compile-time-requirements)",
            })
          end)
        end
      end,
    })

    -- some quick sanity checks
    if not TS.get_installed then
      return LazyVim.error("Please use `:Lazy` and update `nvim-treesitter`")
    elseif type(opts.ensure_installed) ~= "table" then
      return LazyVim.error("`nvim-treesitter` opts.ensure_installed must be a table")
    end

    -- setup treesitter
    TS.setup(opts)
    LazyVim.treesitter.get_installed(true) -- initialize the installed langs

    -- install missing parsers
    local install = vim.tbl_filter(function(lang)
      return not LazyVim.treesitter.have(lang)
    end, opts.ensure_installed or {})
    if #install > 0 then
      LazyVim.treesitter.ensure_treesitter_cli(function()
        TS.install(install, { summary = true }):await(function()
          LazyVim.treesitter.get_installed(true) -- refresh the installed langs
        end)
      end)
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
      callback = function(ev)
        if not LazyVim.treesitter.have(ev.match) then
          return
        end

        -- highlighting
        if vim.tbl_get(opts, "highlight", "enable") ~= false then
          pcall(vim.treesitter.start)
        end

        -- indents
        if vim.tbl_get(opts, "indent", "enable") ~= false and LazyVim.treesitter.have(ev.match, "indents") then
          LazyVim.set_default("indentexpr", "v:lua.LazyVim.treesitter.indentexpr()")
        end

        -- folds
        if vim.tbl_get(opts, "folds", "enable") ~= false and LazyVim.treesitter.have(ev.match, "folds") then
          if LazyVim.set_default("foldmethod", "expr") then
            LazyVim.set_default("foldexpr", "v:lua.LazyVim.treesitter.foldexpr()")
          end
        end
      end,
    })
  end,
}
