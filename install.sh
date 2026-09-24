#!/usr/bin/env bash
# ------------------------------------------------------------------------------
#  dotfiles installer — takes a fresh macOS to a full keyboard-driven dev setup.
#
#  Fresh machine (nothing installed yet):
#    curl -fsSL https://raw.githubusercontent.com/karmann-dm/dotfiles/main/install.sh | bash
#
#  From a clone:
#    ./install.sh              # everything
#    ./install.sh --no-macos   # skip `defaults write` system tweaks
#    ./install.sh --only link  # run a single step (see STEPS below)
#
#  Safe to re-run: every step is idempotent. Existing files that would be
#  replaced by a symlink are moved to ~/.dotfiles-backup/<timestamp>/.
#
#  NOTE: macOS ships bash 3.2 — keep this script free of bash 4+ features.
# ------------------------------------------------------------------------------
set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/karmann-dm/dotfiles.git}"
DOTFILES="${DOTFILES:-$HOME/dotfiles}"

STEPS="xcode brew clone packages link git shell rust go tmux nvim themes macos"
SKIP_MACOS=0
ONLY=""

while [ $# -gt 0 ]; do
  case "$1" in
    --no-macos) SKIP_MACOS=1 ;;
    --only) shift; ONLY="$1" ;;
    -h|--help) sed -n '2,18p' "$0"; exit 0 ;;
    *) echo "unknown flag: $1" >&2; exit 1 ;;
  esac
  shift
done

# ---------- pretty output -----------------------------------------------------
bold=$'\033[1m'; blue=$'\033[34m'; green=$'\033[32m'; yellow=$'\033[33m'; red=$'\033[31m'; reset=$'\033[0m'
step() { printf '\n%s==> %s%s\n' "$blue$bold" "$*" "$reset"; }
ok()   { printf '%s  ✓ %s%s\n' "$green" "$*" "$reset"; }
warn() { printf '%s  ! %s%s\n' "$yellow" "$*" "$reset"; }
die()  { printf '%s  ✗ %s%s\n' "$red" "$*" "$reset" >&2; exit 1; }
has()  { command -v "$1" >/dev/null 2>&1; }

[ "$(uname -s)" = "Darwin" ] || die "This installer is for macOS."

# Homebrew lives in different places on Apple Silicon vs Intel.
if [ "$(uname -m)" = "arm64" ]; then BREW_PREFIX=/opt/homebrew; else BREW_PREFIX=/usr/local; fi
load_brew() { [ -x "$BREW_PREFIX/bin/brew" ] && eval "$("$BREW_PREFIX/bin/brew" shellenv)"; return 0; }
load_brew
export PATH="$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin:$PATH"

# ---------- steps -------------------------------------------------------------
step_xcode() {
  step "Xcode Command Line Tools"
  if xcode-select -p >/dev/null 2>&1; then ok "already installed"; return; fi
  xcode-select --install || true
  warn "A system dialog opened — click Install. Waiting for it to finish…"
  until xcode-select -p >/dev/null 2>&1; do sleep 5; done
  ok "installed"
}

step_brew() {
  step "Homebrew"
  if has brew; then ok "already installed"; return; fi
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew
  ok "installed"
}

step_clone() {
  step "dotfiles repository"
  # When run from a clone, use that clone wherever it lives.
  local here=""
  if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
    here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  fi
  if [ -n "$here" ] && [ -f "$here/Brewfile" ]; then
    DOTFILES="$here"; ok "using $DOTFILES"; return
  fi
  if [ -d "$DOTFILES/.git" ]; then
    git -C "$DOTFILES" pull --ff-only || warn "could not fast-forward $DOTFILES"
  else
    git clone "$DOTFILES_REPO" "$DOTFILES"
  fi
  ok "$DOTFILES"
}

step_packages() {
  step "Packages (Brewfile) — this takes a while the first time"
  brew update
  # Don't abort the whole install when a single cask fails (e.g. needs a password).
  brew bundle --file="$DOTFILES/Brewfile" || warn "some Brewfile entries failed — re-run later with: dot update"
}

step_link() {
  step "Symlinking configs into \$HOME"
  "$DOTFILES/scripts/link.sh"
}

step_git() {
  step "Git identity (~/.gitconfig.local, not committed)"
  local f="$HOME/.gitconfig.local"
  if [ -f "$f" ]; then ok "exists"; return; fi
  local name email
  if [ -t 0 ] || [ -e /dev/tty ]; then
    printf '  Git name:  '; read -r name </dev/tty || true
    printf '  Git email: '; read -r email </dev/tty || true
  fi
  cat >"$f" <<EOF
[user]
	name = ${name:-Your Name}
	email = ${email:-you@example.com}
EOF
  ok "wrote $f (edit anytime)"
}

step_shell() {
  step "Shell"
  local zsh_path; zsh_path="$(command -v zsh)"
  if [ "${SHELL:-}" != "$zsh_path" ] && [ "${SHELL:-}" != "/bin/zsh" ]; then
    chsh -s /bin/zsh || warn "could not change login shell"
  fi
  mkdir -p "$HOME/.local/state/zsh" "$HOME/.cache/zsh"
  ok "zsh ready (plugins are fetched by antidote on first launch)"
}

step_rust() {
  step "Rust toolchain (rustup)"
  if ! has rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --default-toolchain stable
  fi
  rustup update stable
  rustup component add rust-analyzer clippy rustfmt rust-src
  ok "rustc $(rustc --version | cut -d' ' -f2)"
  if has cargo-binstall; then
    # Prebuilt binaries — seconds instead of minutes of compiling.
    cargo binstall --no-confirm --locked \
      cargo-nextest cargo-watch cargo-edit cargo-expand cargo-audit \
      cargo-outdated cargo-machete cargo-llvm-cov || warn "some cargo tools failed"
  fi
}

step_go() {
  step "Go tools"
  has go || { warn "go not installed, skipping"; return; }
  go install golang.org/x/tools/gopls@latest
  go install golang.org/x/tools/cmd/goimports@latest
  go install gotest.tools/gotestsum@latest
  go install github.com/fatih/gomodifytags@latest
  ok "$(go version | cut -d' ' -f3)"
}

step_tmux() {
  step "tmux plugins (tpm)"
  local tpm="$HOME/.local/share/tmux/plugins/tpm"
  [ -d "$tpm" ] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm"
  TMUX_PLUGIN_MANAGER_PATH="$HOME/.local/share/tmux/plugins/" "$tpm/bin/install_plugins" >/dev/null || warn "tpm install failed"
  ok "installed"
}

step_nvim() {
  step "Neovim plugins (lazy.nvim) + language servers (mason)"
  nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1 || warn "lazy sync reported errors — open nvim and run :Lazy"
  ok "done (language servers install in the background on first launch — see :Mason)"
}

step_themes() {
  step "Themes (bat / delta)"
  local d="$HOME/.config/bat/themes"
  mkdir -p "$d"
  if [ ! -f "$d/Catppuccin Mocha.tmTheme" ]; then
    curl -fsSL -o "$d/Catppuccin Mocha.tmTheme" \
      "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme" || warn "theme download failed"
  fi
  bat cache --build >/dev/null
  ok "done"
}

step_macos() {
  step "macOS defaults"
  if [ "$SKIP_MACOS" = 1 ]; then warn "skipped (--no-macos)"; return; fi
  "$DOTFILES/scripts/macos.sh"
}

run() {
  local s
  for s in $STEPS; do
    if [ -z "$ONLY" ] || [ "$ONLY" = "$s" ]; then
      "step_$s"
    fi
  done
}

# `--only X` still needs to know where the repo is.
[ -n "$ONLY" ] && [ "$ONLY" != "clone" ] && step_clone >/dev/null
run

if [ -z "$ONLY" ]; then
  cat <<EOF

${green}${bold}All done!${reset}

  Next steps (one-time, can't be automated):
   1. Open ${bold}AeroSpace${reset}, ${bold}Karabiner-Elements${reset} and ${bold}Raycast${reset} once and grant the
      Accessibility / Input Monitoring permissions they ask for.
   2. Set Raycast as your launcher (it offers to replace Spotlight's ⌘Space).
   3. Log out and back in so keyboard + Dock settings take effect.
   4. Open ${bold}kitty${reset} and type ${bold}keys${reset} — every shortcut in this setup, searchable.

  Stuck? Press ${bold}alt-?${reset} anywhere (window manager), ${bold}ctrl-space ?${reset} in tmux,
  or ${bold}space${reset} in Neovim and wait — a menu pops up.
EOF
fi
