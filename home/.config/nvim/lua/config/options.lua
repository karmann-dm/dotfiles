-- Options on top of LazyVim's defaults:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
local opt = vim.opt

opt.relativenumber = true -- line jumps like 12j become obvious
opt.scrolloff = 8
opt.wrap = false
opt.colorcolumn = "100"
opt.spelllang = { "en" }
opt.swapfile = false
opt.undofile = true
opt.timeoutlen = 400 -- how long which-key waits before popping up (ms)
