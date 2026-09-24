local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = "catppuccin" } },

    -- Languages ------------------------------------------------------------
    { import = "lazyvim.plugins.extras.lang.rust" }, -- rustaceanvim, crates.nvim, codelldb
    { import = "lazyvim.plugins.extras.lang.go" }, -- gopls, gofumpt, goimports, delve, neotest-golang
    { import = "lazyvim.plugins.extras.lang.yaml" }, -- yamlls + SchemaStore
    { import = "lazyvim.plugins.extras.lang.helm" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.git" },

    -- Debugging & tests (<space>d… and <space>t…) ---------------------------
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.test.core" },

    -- Editing ---------------------------------------------------------------
    { import = "lazyvim.plugins.extras.editor.inc-rename" }, -- live preview while renaming
    { import = "lazyvim.plugins.extras.coding.yanky" }, -- yank history: <space>p
    { import = "lazyvim.plugins.extras.coding.mini-surround" }, -- gsa / gsd / gsr
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
    { import = "lazyvim.plugins.extras.ui.treesitter-context" }, -- sticky function header

    -- Our own additions: lua/plugins/*.lua
    { import = "plugins" },
  },
  defaults = { lazy = false, version = false },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = true, notify = false }, -- check for plugin updates quietly
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
