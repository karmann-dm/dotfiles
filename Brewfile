# Everything this setup installs. Apply changes with:  dot update   (or: brew bundle)
# Add something new? Put it here so a fresh machine gets it too.

tap "nikitabobko/tap"      # AeroSpace
tap "FelixKratz/formulae"  # borders (highlight focused window)
tap "fluxcd/tap"

# ── Window management & terminal ──────────────────────────────────────────────
cask "nikitabobko/tap/aerospace"   # tiling window manager (alt + …)
brew "FelixKratz/formulae/borders" # colored border around the focused window
cask "kitty"                       # GPU terminal
cask "raycast"                     # keyboard launcher (replaces Spotlight)
cask "karabiner-elements"          # caps lock = esc (tap) / ctrl (hold)
cask "font-jetbrains-mono-nerd-font"
cask "font-symbols-only-nerd-font"

# ── Shell ─────────────────────────────────────────────────────────────────────
brew "zsh"
brew "antidote"     # zsh plugin manager
brew "starship"     # prompt
brew "atuin"        # ctrl-r: searchable shell history
brew "fzf"          # fuzzy finder behind everything
brew "zoxide"       # `z proj` jumps to ~/code/project
brew "direnv"       # per-directory env vars (.envrc)
brew "eza"          # ls with icons + git status
brew "bat"          # cat with syntax highlighting
brew "ripgrep"      # rg: fast grep
brew "fd"           # fast find
brew "yazi"         # terminal file manager (vim keys)
brew "btop"         # system monitor
brew "tlrc"         # `tldr tar` — examples instead of man pages
brew "glow"         # render markdown in the terminal (used by `keys`)
brew "jq"
brew "yq"
brew "wget"
brew "coreutils"
brew "gnu-sed"
brew "watch"
brew "tree"

# ── Editor & multiplexer ──────────────────────────────────────────────────────
brew "neovim"
brew "tmux"
brew "sesh"             # smart tmux session picker
brew "tree-sitter-cli"  # needed by nvim-treesitter to build parsers
brew "node"             # some language servers are npm packages
brew "python"
brew "lua"
brew "luarocks"

# ── Git ───────────────────────────────────────────────────────────────────────
brew "git"
brew "gh"
brew "lazygit"      # git TUI (also inside nvim: space g g)
brew "git-delta"    # beautiful diffs
brew "difftastic"   # syntax-aware diffs: `git dft`
brew "pre-commit"

# ── Rust (toolchain itself comes from rustup, see install.sh) ─────────────────
brew "cargo-binstall"  # install cargo tools as prebuilt binaries
brew "bacon"           # background `cargo check`/clippy/test runner
brew "hyperfine"       # benchmarking CLI
brew "tokei"           # count lines of code

# ── Go ────────────────────────────────────────────────────────────────────────
brew "go"
brew "golangci-lint"
brew "delve"
brew "gofumpt"

# ── GitOps / Kubernetes / YAML ────────────────────────────────────────────────
brew "kubernetes-cli"   # kubectl
brew "kubectx"          # kubectx / kubens
brew "k9s"              # cluster TUI
brew "helm"
brew "kustomize"
brew "fluxcd/tap/flux"
brew "argocd"
brew "stern"            # multi-pod log tailing
brew "kubeconform"      # validate manifests against schemas
brew "yamllint"
brew "sops"
brew "age"
brew "kind"             # local clusters
brew "hadolint"         # Dockerfile linter
cask "orbstack"         # fast Docker + k8s for macOS
