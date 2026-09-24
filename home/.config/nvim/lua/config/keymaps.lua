-- Extra keymaps on top of LazyVim's defaults:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Every mapping gets a `desc` so it shows up in which-key and <space>sk.
local map = vim.keymap.set

-- jk in insert mode = escape (for when caps lock isn't handy)
map("i", "jk", "<esc>", { desc = "Escape" })

-- Keep the cursor centered when jumping around
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

-- Paste over a selection without losing what you yanked
map("x", "<leader>P", [["_dP]], { desc = "Paste without yanking" })

-- The cheatsheet for the whole setup (tmux, aerospace, shell, nvim …)
map("n", "<leader>k", function()
  Snacks.terminal(vim.fn.expand("~/.local/bin/keys"), {
    win = { position = "float", width = 0.9, height = 0.9, border = "rounded" },
  })
end, { desc = "Keys cheatsheet (whole setup)" })
