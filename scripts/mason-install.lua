-- Install every Mason package this Neovim config uses (language servers,
-- formatters, linters, debug adapters) and WAIT until they're done.
--
-- Normally LazyVim installs them in the background the first time you open a
-- file. Some things can't cope with that race: jdtls, for example, only enables
-- debugging (`space dc`) if java-debug-adapter is already installed when it
-- starts. Running this once up front avoids all of that.
--
--   nvim --headless "+luafile scripts/mason-install.lua"     (install.sh does this)

local function log(msg)
  io.stdout:write(msg .. "\n")
end

local function finish(code)
  vim.schedule(function()
    vim.cmd((code == 0 and "qall!" or "cquit " .. code))
  end)
end

-- Loading these runs LazyVim's own setup, which may already start some installs.
require("lazy").load({ plugins = { "mason.nvim", "mason-lspconfig.nvim", "nvim-lspconfig" } })
local registry = require("mason-registry")

local refreshed, refresh_ok = false, false
registry.refresh(function(success)
  refreshed, refresh_ok = true, success
end)
vim.wait(180000, function() return refreshed end, 200)
if not refresh_ok or #registry.get_all_package_names() == 0 then
  log("mason: could not download the package registry (offline or blocked?) — open nvim later and run :Mason")
  return finish(1)
end

-- 1. Tools listed for mason.nvim (formatters, linters, debug adapters…)
local wanted = {}
for _, name in ipairs(LazyVim.opts("mason.nvim").ensure_installed or {}) do
  wanted[name] = true
end

-- 2. Language servers configured for nvim-lspconfig, mapped to Mason package names
local ok_map, map = pcall(function()
  return require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package
end)
for server, sopts in pairs(LazyVim.opts("nvim-lspconfig").servers or {}) do
  local enabled = sopts == true or (type(sopts) == "table" and sopts.enabled ~= false and sopts.mason ~= false)
  if enabled and ok_map and map[server] then
    wanted[map[server]] = true
  end
end
-- jdtls is set up by nvim-jdtls, not through the servers table
if LazyVim.has_extra and LazyVim.has_extra("lang.java") then
  wanted["jdtls"] = true
end

local failed, started = {}, 0
for name in pairs(wanted) do
  local ok, pkg = pcall(registry.get_package, name)
  if not ok then
    failed[#failed + 1] = name .. " (unknown package)"
  elseif not pkg:is_installed() and not pkg:is_installing() then
    started = started + 1
    log("mason: installing " .. name)
    pkg:install({}, function(success)
      if not success then
        failed[#failed + 1] = name
      end
    end)
  end
end

-- Wait for ours and any LazyVim started itself (15 min cap for slow networks).
vim.wait(900000, function()
  for name in pairs(wanted) do
    local ok, pkg = pcall(registry.get_package, name)
    if ok and pkg:is_installing() then
      return false
    end
  end
  return true
end, 500)

local total = vim.tbl_count(wanted)
if #failed > 0 then
  log(("mason: %d/%d ready, failed: %s — retry inside nvim with :Mason"):format(total - #failed, total, table.concat(failed, ", ")))
  return finish(1)
end
log(("mason: all %d packages ready (%d newly installed)"):format(total, started))
finish(0)
