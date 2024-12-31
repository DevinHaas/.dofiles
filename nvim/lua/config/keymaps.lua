local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')
keymap.set("i", "kj", "<Esc>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save file and quit
keymap.set("n", "<Leader>w", ":update<Return>", opts)
keymap.set("n", "<Leader>q", ":quit<Return>", opts)
keymap.set("n", "<Leader>Q", ":qa<Return>", opts)

-- File explorer with NvimTree
keymap.set("n", "<Leader>x", ":NvimTreeToggle<Return>", opts)

-- Split window
keymap.set("n", "<leader>wv", ":vsplit<Return>", opts) -- Vertical split
keymap.set("n", "<leader>ws", ":split<Return>", opts) -- Horizontal split

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-S-h>", "<C-w><")
keymap.set("n", "<C-S-l>", "<C-w>>")
keymap.set("n", "<C-S-k>", "<C-w>+")
keymap.set("n", "<C-S-j>", "<C-w>-")

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end)
keymap.set("n", "<C-e>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

keymap.set("n", "<leader>1", function()
  harpoon:list():select(1)
end)
keymap.set("n", "<leader>2", function()
  harpoon:list():select(2)
end)
keymap.set("n", "<leader>3", function()
  harpoon:list():select(3)
end)
keymap.set("n", "<leader>4", function()
  harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
keymap.set("n", "<C-S-P>", function()
  harpoon:list():prev()
end)
keymap.set("n", "<C-S-N>", function()
  harpoon:list():next()
end)

-- Diagnostics
keymap.set("n", "<C-p>", function()
  vim.diagnostic.goto_next()
end, opts)
