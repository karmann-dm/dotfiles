# Go & YAML / GitOps

## Go in Neovim
| Keys | Action |
|------|--------|
| `space tt` / `space tr` | Run tests in file / nearest test |
| `space td` | Debug nearest test (delve) |
| `space ca` | Code action (fill struct, add tags…) |
| `space cf` | Format (gofumpt + goimports) |
| `gd` / `gI` | Definition / implementation |

## Go shell aliases
| Command | Action |
|---------|--------|
| `gob` | go build ./... |
| `got` | gotestsum — readable test output |
| `gol` | golangci-lint run |
| `gomt` | go mod tidy |

## YAML in Neovim
| Keys | Action |
|------|--------|
| `space cK` | Detect apiVersion/kind → add k8s/CRD schema (completion + validation) |
| `K` | Docs for the field under cursor (once a schema is set) |
| `ctrl-n` / `ctrl-p` then `enter` | Pick a completion (it pops up by itself) |
| `space cf` | Format YAML |
| `]d` / `[d` | Next / prev yamllint / schema error |

## GitOps shell
| Command | Action |
|---------|--------|
| `kval dir/` | kustomize build + kubeconform validation (incl. CRDs) |
| `kval file.yaml` | Validate a single manifest |
| `fr <name>` | flux reconcile kustomization --with-source |
| `fga` | flux get all -A |
| `yq '.spec' f.yaml` | Query YAML |
| `yamllint .` | Lint YAML |
| `sops -e -i secret.yaml` | Encrypt a secret in place (age key) |
