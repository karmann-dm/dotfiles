# Kubernetes

Your current context is shown on the right of the prompt (red if it contains "prod").

## k9s (`kk`, or `prefix ctrl-k`)
| Keys | Action |
|------|--------|
| `?` | Help for the current view |
| `:pods` `:deploy` `:svc` `:hr` `:ks` | Jump to a resource type |
| `/` | Filter the list |
| `0` | All namespaces |
| `enter` / `esc` | Drill in / back |
| `l` | Logs |
| `s` | Shell into container |
| `d` / `y` | Describe / YAML |
| `e` | Edit resource |
| `ctrl-d` | Delete |
| `shift-f` | Port-forward |

## Aliases
| Command | Action |
|---------|--------|
| `k` | kubectl |
| `kx` / `kn` | Switch context / namespace (fuzzy) |
| `kgp` / `kgd` / `kgs` | get pods / deployments / services |
| `kaf file.yaml` | apply -f |
| `kdp pod` | describe pod |
| `klf pod` | follow logs |
| `stern app` | Tail logs of all pods matching "app" |
| `kval dir/` | Validate manifests locally |
