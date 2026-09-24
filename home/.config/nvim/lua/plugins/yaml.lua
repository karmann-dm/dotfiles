-- YAML / GitOps.
--
-- LazyVim's lang.yaml already maps well-known files to schemas via SchemaStore
-- (kustomization.yaml, Chart.yaml, GitHub workflows, docker-compose, …).
-- Kubernetes manifests can't be detected by filename, so:
--
--   <space>cK  → reads apiVersion/kind of the current file and inserts a
--                `# yaml-language-server: $schema=…` modeline. Works for core
--                resources (Deployment, Service…) and CRDs (Flux HelmRelease,
--                Argo Application, cert-manager, …) via the datreeio CRD catalog.
--
-- After that you get completion, hover docs (K) and validation for every field.

local K8S_VERSION = "master-standalone-strict"
local CORE_GROUPS = {
  [""] = true, apps = true, batch = true, autoscaling = true, policy = true,
  ["networking.k8s.io"] = true, ["rbac.authorization.k8s.io"] = true,
  ["storage.k8s.io"] = true, ["apiextensions.k8s.io"] = true,
  ["admissionregistration.k8s.io"] = true, ["scheduling.k8s.io"] = true,
  ["coordination.k8s.io"] = true, ["node.k8s.io"] = true, ["discovery.k8s.io"] = true,
  ["certificates.k8s.io"] = true, ["events.k8s.io"] = true,
  ["flowcontrol.apiserver.k8s.io"] = true,
}

local function schema_url(api_version, kind)
  local group, version = api_version:match("^(.+)/(.+)$")
  if not group then
    group, version = "", api_version
  end
  kind = kind:lower()
  if CORE_GROUPS[group] then
    -- yannh/kubernetes-json-schema: <kind>-<first group label>-<version>.json
    local suffix = group == "" and version or (group:match("^[^.]+") .. "-" .. version)
    return ("https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/%s/%s-%s.json"):format(
      K8S_VERSION,
      kind,
      suffix
    )
  end
  -- datreeio/CRDs-catalog: <group>/<kind>_<version>.json
  return ("https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/%s/%s_%s.json"):format(group, kind, version)
end

local function insert_k8s_schema()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local api_version, kind
  for _, line in ipairs(lines) do
    api_version = api_version or line:match("^apiVersion:%s*([%w%./%-]+)")
    kind = kind or line:match("^kind:%s*(%w+)")
    if api_version and kind then
      break
    end
  end
  if not (api_version and kind) then
    vim.notify("No top-level apiVersion/kind found", vim.log.levels.WARN, { title = "k8s schema" })
    return
  end
  local modeline = "# yaml-language-server: $schema=" .. schema_url(api_version, kind)
  if lines[1] and lines[1]:match("^# yaml%-language%-server:") then
    vim.api.nvim_buf_set_lines(0, 0, 1, false, { modeline })
  else
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { modeline })
  end
  vim.notify(kind .. " (" .. api_version .. ")", vim.log.levels.INFO, { title = "k8s schema set" })
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              customTags = { "!reference sequence", "!Ref", "!Sub", "!GetAtt", "!If sequence" },
            },
          },
          keys = {
            { "<leader>cK", insert_k8s_schema, desc = "Kubernetes schema for this file" },
          },
        },
      },
    },
  },

  -- Lint YAML with yamllint (installed by the Brewfile)
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        yaml = { "yamllint" },
      },
    },
  },
}
