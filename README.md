# dotfiles

A keyboard-driven macOS developer setup, installable on a fresh Mac with one command.
It's tuned for **Rust**, **Go** and **YAML/GitOps**, and it is built to **teach you its own
shortcuts**, so you don't need to memorize anything up front.

```
┌──────────────────────── AeroSpace (alt + …) ── windows & workspaces ────────────────────────┐
│ ┌──────────────────── kitty ── the terminal ─────────────────────┐  ┌───── browser ─────┐   │
│ │ ┌──────────── tmux (ctrl-space + …) ── sessions/panes ───────┐ │  │                   │   │
│ │ │  ┌── Neovim (space + …) ──┐  ┌── zsh ─────────────────────┐ │ │  │                   │   │
│ │ │  │ LazyVim · rust · go ·  │  │ fzf · atuin · zoxide ·     │ │ │  │                   │   │
│ │ │  │ yaml/k8s · git · debug │  │ starship · lazygit · k9s   │ │ │  │                   │   │
│ │ │  └────────────────────────┘  └────────────────────────────┘ │ │  │                   │   │
│ │ └─────────────────────────────────────────────────────────────┘ │  └───────────────────┘   │
│ └─────────────────────────────────────────────────────────────────┘                          │
└──────────────────────────────────────────────────────────────────────────────────────────────┘
```

Each layer has **one modifier**, so you always know which layer a key belongs to:

| Layer | Modifier | Stuck? press… |
|---|---|---|
| Windows (AeroSpace) | `alt` | `alt-?` opens a floating cheatsheet |
| Terminal multiplexer (tmux) | `ctrl-space`, then a key | `ctrl-space` `space` opens a menu |
| Editor (Neovim) | `space` | `space`, then wait: a menu pops up |
| Moving between panes/splits | `ctrl-h/j/k/l` | works the same in tmux and Neovim |
| Shell | — | `keys` or `ctrl-g` |

---

## Install

On a brand-new Mac, open Terminal.app and run:

```sh
curl -fsSL https://raw.githubusercontent.com/karmann-dm/dotfiles/main/install.sh | bash
```

Or clone the repo first:

```sh
git clone https://github.com/karmann-dm/dotfiles ~/dotfiles
cd ~/dotfiles && ./install.sh
```

It works the same on a **fresh Mac** and on one that's **already half set up**:

| You already have… | What happens |
|---|---|
| Homebrew, Xcode tools, rustup, Go | Kept. Only what's missing gets installed. |
| Brew packages at older versions | Upgraded (`--no-upgrade` leaves them alone) |
| kitty / AeroSpace / fonts you installed by hand (not via brew) | Left untouched. The installer says how to hand them over to brew (`brew install --cask --adopt …`). |
| Your own `~/.config/nvim`, `~/.gitconfig`, `~/.aerospace.toml`, `~/.tmux.conf`, … | Moved to `~/.dotfiles-backup/<date>/`, never deleted. For Neovim, the old plugin data goes there too so it can't clash with LazyVim. |
| A name/email in your old `~/.gitconfig` | Reused for `~/.gitconfig.local` without asking |
| AeroSpace / tmux / kitty already running | Configs are reloaded at the end, no restart needed |
| One step failing (network, a cask needing a password, …) | The other steps still run. The summary ends with the exact command to retry only the failed ones, e.g. `./install.sh --only packages,nvim` |

Re-running the installer is always safe: a second run changes nothing unless something is missing or outdated.

```sh
./install.sh                 # install what's missing + upgrade what's there
./install.sh --no-upgrade    # install what's missing, keep existing versions
./install.sh --no-macos      # skip the macOS `defaults` tweaks
./install.sh --only rust,go  # just some steps
```

Steps: `xcode brew clone packages link git shell rust go tmux nvim themes macos reload`.

What it sets up:

1. Xcode Command Line Tools and Homebrew
2. Everything in the [`Brewfile`](Brewfile) (apps, CLI tools, fonts)
3. Symlinks from `home/` into `~`
4. `~/.gitconfig.local` with your git name/email (not committed)
5. Rust via rustup (stable + rust-analyzer, clippy, rustfmt) and cargo tools
   (nextest, watch, expand, audit, machete, llvm-cov, …)
6. Go tools (gopls, goimports, gotestsum, …)
7. tmux and Neovim plugins
8. macOS defaults (fast key repeat, Dock autohide, AeroSpace-friendly Spaces, …)

### After installing (one-time manual steps)

- [ ] Open **AeroSpace**, **Karabiner-Elements** and **Raycast** once and grant the permissions
      they ask for in System Settings → Privacy & Security.
- [ ] In Raycast, set the hotkey to `⌘ Space` (it offers to disable Spotlight's shortcut).
- [ ] `gh auth login`: git over HTTPS then uses the GitHub CLI for credentials.
- [ ] Log out and back in so the key-repeat and Dock settings take effect.
- [ ] Optional: install the [Vimium](https://vimium.github.io/) browser extension. The browser
      then works with the same `hjkl` / `f` (click links) keys.
- [ ] Run `dot doctor` to check that everything is wired up.

---

## How the setup teaches you

You said you're not used to keyboard shortcuts yet, so several layers of hints are built in:

| Where | What helps |
|---|---|
| Everywhere | **`keys`** is a fuzzy-searchable cheatsheet of the whole setup (`keys tmux`, `keys rust`, …). Open it from the shell (`ctrl-g`), tmux (`prefix ?`), Neovim (`space k`) or AeroSpace (`alt-?`). |
| New shell | Every new shell prints **one random tip**. Turn it off with `export DOTFILES_TIPS=0` in `~/.config/zsh/local.zsh`. |
| Shell | **zsh-you-should-use** tells you when an alias exists for the command you just typed. **Autosuggestions** show grey completions from history. |
| tmux | The status bar **always shows** `^space + space menu · ? keys`. It turns purple and says **PREFIX** once you've pressed the prefix. `prefix space` opens a menu that shows every action *with its key*. |
| Neovim | **which-key**: press `space`, `g`, `z`, `[` or `]` and wait, and a menu lists what comes next. **precognition** shows where `w b e $ ^ { }` would jump, right in the text. **hardtime** (hint mode only) points out repetitive habits like `jjjjj`. |
| AeroSpace | A colored border (JankyBorders) marks the focused window. `alt-?` opens the cheatsheet. |
| lazygit, k9s, yazi, bacon | Press `?` inside any of them. |

Once you know the keys, turn the training wheels off with `space uP` (motion hints) and
`space uH` (habit hints) in Neovim.

### A learning path that works

The goal is one new habit per week, not everything at once.

1. **Week 1 (windows):** `alt-1..4` to switch workspaces, `alt-h/l` to move focus, `alt-enter`
   for a new terminal. Run `:Tutor` in Neovim once (30 min).
2. **Week 2 (tmux):** `t` to start a session per project, `prefix |` and `prefix -` to split,
   `ctrl-h/j/k/l` to move between panes, `prefix z` to zoom.
3. **Week 3 (Neovim):** `space space` to find files, `space /` to grep, `gd` and `K` for code,
   `space ca` for fixes, `s` to jump anywhere.
4. **Week 4 (flow):** `ctrl-r` for history, `z` to jump between directories, `prefix g` for lazygit,
   `prefix o` to switch projects, `cw` (bacon) in a side pane while writing Rust.

---

## Neovim guide

New to Neovim? **[docs/neovim.md](docs/neovim.md)** walks through modes, a day-1 survival kit,
the hint system, moving and editing, and the Rust, Go and YAML/Kubernetes workflows. It ends
with a 6-week practice plan. Read it in the terminal with `dot guide`.

## What's inside

```
.
├── install.sh            # bootstrap a fresh Mac
├── Brewfile              # every app/CLI installed
├── cheatsheets/*.md      # what `keys` searches — edit these as you learn!
├── docs/neovim.md        # the Neovim guide (`dot guide`)
├── scripts/
│   ├── link.sh           # symlink home/ → ~ (with backups)
│   └── macos.sh          # system defaults
└── home/                 # mirrors ~
    ├── .zshenv  .gitconfig
    ├── .local/bin/       # keys · dot · sesh-pick
    └── .config/
        ├── aerospace/    # tiling WM (alt)
        ├── kitty/        # terminal + Catppuccin theme
        ├── tmux/         # ctrl-space prefix, menus, popups, session restore
        ├── nvim/         # LazyVim + Rust/Go/YAML/Helm/Docker/debug/test
        ├── zsh/          # antidote plugins, aliases, functions
        ├── karabiner/    # caps lock = esc (tap) / ctrl (hold)
        ├── starship.toml # prompt with k8s context (red on prod)
        └── lazygit/ atuin/ bat/ k9s/ sesh/ yazi/ git/
```

### Rust
- **Neovim:** rustaceanvim (rust-analyzer with clippy on save), crates.nvim for `Cargo.toml`,
  codelldb debugging (`space d…`), neotest (`space t…`).
- **CLI:** `bacon` (`cw`), `cargo nextest` (`ct`), `cargo-expand`, `cargo-audit`, `cargo-machete`,
  `cargo-outdated`, `cargo-llvm-cov`, `hyperfine`.

### Go
- **Neovim:** gopls, gofumpt + goimports on save, golangci-lint, delve debugging, neotest-golang.
- **CLI:** `gotestsum` (`got`), `golangci-lint` (`gol`).

### Java / Kotlin
- **Toolchain:** SDKMAN installs the latest Temurin LTS JDK, Gradle, Maven and Kotlin. Switch JDKs
  with `sdk use java …`. A `.sdkmanrc` in a project switches versions automatically on `cd`.
- **Neovim:** nvim-jdtls (with JUnit test runner and debugger, Lombok support), kotlin-language-server,
  ktlint formatting and the Kotlin debugger. See `keys jvm` or the [Neovim guide](docs/neovim.md#11b-java-and-kotlin).
- **Shell:** `gw` (./gradlew), `gwb` / `gwt` / `gwr`, `mvnt`.

### YAML / GitOps
- **Neovim:** yamlls with SchemaStore, which covers kustomization, Chart.yaml, GitHub Actions,
  compose and more automatically. **`space cK`** detects `apiVersion`/`kind` and adds the matching
  Kubernetes or CRD schema (Flux, Argo, cert-manager, … via the datreeio catalog), which gives you
  completion, hover docs and validation for every field. Also Helm templates (helm-ls), yamllint
  and Dockerfile linting.
- **CLI:** kubectl (+ oh-my-zsh aliases), kubectx/kubens, k9s, helm, kustomize, flux, argocd,
  stern, kubeconform (`kval dir/` validates a kustomize build, CRDs included), sops + age, kind,
  OrbStack. The prompt shows the current k8s context and turns **red** for prod contexts.

---

## Day-to-day

| Command | What it does |
|---|---|
| `dot update` | Pull the repo, `brew bundle`, relink, and update rust, nvim, tmux and zsh plugins |
| `dot doctor` | Check that tools, symlinks, fonts and permissions are in place |
| `dot edit` | Open this repo in Neovim (in its own tmux session) |
| `keys [topic]` | Search shortcuts |

**Adding things:** add apps to the `Brewfile`, configs under `home/`, and new shortcuts to a
`cheatsheets/*.md` table so `keys` can find them. Machine-specific shell settings go in
`~/.config/zsh/local.zsh` (git-ignored).

**Theme:** Catppuccin Mocha everywhere (kitty, tmux, Neovim, fzf, bat, delta, starship,
lazygit, borders).

## Troubleshooting

- **A window floats instead of tiling:** press `alt-shift-space` to toggle it. If an app always
  does it, add a rule for it in `aerospace.toml` (see the kitty one) — find its app id with
  `aerospace list-apps`.

- **"Refusing to load formula … from untrusted tap":** newer Homebrew requires trusting
  third-party taps. The installer trusts the three taps in the `Brewfile` (`nikitabobko/tap`,
  `FelixKratz/formulae`, `fluxcd/tap`) and nothing else. To do it by hand: `brew trust <tap>`.
- **"circular dependency: libtiff, webp":** a harmless Homebrew warning caused by stale
  metadata of already-installed packages. It goes away with
  `brew reinstall libtiff webp`.

- **`alt` shortcuts type characters like `˙` instead:** AeroSpace isn't running or doesn't have
  Accessibility permission yet.
- **Caps lock doesn't act as esc/ctrl:** open Karabiner-Elements and allow its driver and
  Input Monitoring.
- **Icons show up as boxes:** set kitty's font (already configured) and make sure
  `font-jetbrains-mono-nerd-font` installed (`dot doctor`).
- **A Neovim language server is missing:** run `:Mason` and check `:checkhealth`. For Rust,
  rust-analyzer comes from rustup (`rustup component add rust-analyzer`).
- **tmux plugins are missing:** press `prefix I`.
- **Your old config files:** they were moved to `~/.dotfiles-backup/`.
