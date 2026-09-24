-- Autocmds on top of LazyVim's defaults.
local group = vim.api.nvim_create_augroup("dotfiles", { clear = true })

-- GitOps-y files that YAML tooling doesn't recognize by extension
vim.filetype.add({
  filename = {
    [".yamllint"] = "yaml",
    ["kustomization.yml"] = "yaml",
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
  },
})

-- Go uses tabs; show them as 4 wide
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
