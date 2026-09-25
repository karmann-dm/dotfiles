#!/usr/bin/env bash
# shellcheck disable=SC2088  # "~/…" in messages is meant literally
# ------------------------------------------------------------------------------
#  dotfiles installer — takes a macOS machine (fresh OR half set up) to a full
#  keyboard-driven dev setup.
#
#  Fresh machine:
#    curl -fsSL https://raw.githubusercontent.com/karmann-dm/dotfiles/main/install.sh | bash
#
#  From a clone:
#    ./install.sh                  # everything; installs what's missing, upgrades what's there
#    ./install.sh --no-upgrade     # only install what's missing, leave existing versions alone
#    ./install.sh --no-macos       # skip `defaults write` system tweaks
#    ./install.sh --only rust,go   # run just these steps (see STEPS below)
#
#  Safe to re-run at any time:
#   - things already installed are skipped (or upgraded, unless --no-upgrade)
#   - apps you installed by hand (e.g. kitty.app, AeroSpace.app) are left alone
#   - existing config files are moved to ~/.dotfiles-backup/<timestamp>/, never deleted
#   - a failing step doesn't stop the others; you get a summary at the end
#
#  NOTE: macOS ships bash 3.2 — keep this script free of bash 4+ features.
# ------------------------------------------------------------------------------
set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/karmann-dm/dotfiles.git}"
DOTFILES="${DOTFILES:-$HOME/dotfiles}"

# Steps before `clone` are prerequisites: if they fail, nothing else can work.
STEPS="xcode brew clone packages link git shell rust go tmux nvim themes macos reload"
SKIP_MACOS=0
UPGRADE=1
ONLY=""

while [ $# -gt 0 ]; do
  case "$1" in
    --no-macos) SKIP_MACOS=1 ;;
    --no-upgrade) UPGRADE=0 ;;
    --only) shift; ONLY="${1:-}" ;;
    -h|--help) sed -n '2,22p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown flag: $1 (try --help)" >&2; exit 1 ;;
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
# Tools may already exist from earlier installs (rustup, official Go pkg, …).
export PATH="$HOME/.cargo/bin:$HOME/go/bin:/usr/local/go/bin:$HOME/.local/bin:$PATH"

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
  if has brew; then
    ok "already installed ($(brew --version | head -1))"
    return
  fi
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew
  has brew || die "Homebrew installed but not found in $BREW_PREFIX"
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
    git -C "$DOTFILES" pull --ff-only || warn "could not fast-forward $DOTFILES (local changes?) — using it as is"
  elif [ -e "$DOTFILES" ]; then
    die "$DOTFILES exists but isn't a git clone — move it away or set DOTFILES=/other/path"
  else
    git clone "$DOTFILES_REPO" "$DOTFILES"
  fi
  ok "$DOTFILES"
}

# Casks whose app/font is already on disk but NOT managed by Homebrew (you
# downloaded kitty or AeroSpace yourself) make `brew install --cask` fail with
# "It seems there is already an App at …". We leave those alone.
unmanaged_casks() {
  local casks
  casks=$(sed -n 's/^cask "\([^"]*\)".*/\1/p' "$DOTFILES/Brewfile")
  [ -n "$casks" ] || return 0
  # shellcheck disable=SC2086
  brew info --cask --json=v2 $casks 2>/dev/null | /usr/bin/python3 -c '
import json, os, subprocess, sys
home = os.path.expanduser("~")
managed = set(subprocess.run(["brew", "list", "--cask", "-1"], capture_output=True, text=True).stdout.split())
for c in json.load(sys.stdin).get("casks", []):
    if c["token"] in managed:
        continue
    for art in c.get("artifacts", []):
        for kind, dirs in (("app", ["/Applications", home + "/Applications"]), ("font", [home + "/Library/Fonts", "/Library/Fonts"])):
            for item in art.get(kind, []):
                name = item if isinstance(item, str) else item.get("target", "")
                name = os.path.basename(str(name))
                if name and any(os.path.exists(os.path.join(d, name)) for d in dirs):
                    print(c.get("full_token", c["token"]), name, sep="\t")
                    break
' || true
}

# Newer Homebrew refuses to load formulae/casks from third-party taps until
# they're trusted ("Refusing to load formula … from untrusted tap"). The taps
# listed in our Brewfile are the ones this setup deliberately depends on, so
# tap + trust exactly those — nothing else.
trust_taps() {
  brew trust --help >/dev/null 2>&1 || return 0   # older Homebrew: no tap trust yet
  local t failed=0
  # shellcheck disable=SC2013  # tap names never contain spaces
  for t in $(sed -n 's/^tap "\([^"]*\)".*/\1/p' "$DOTFILES/Brewfile"); do
    brew tap "$t" >/dev/null 2>&1 || true
    if brew trust "$t" >/dev/null 2>&1; then
      ok "trusted tap $t"
    else
      warn "could not trust tap $t — run: brew trust $t"; failed=1
    fi
  done
  return $failed
}

step_packages() {
  step "Packages (Brewfile) — the first run takes a while"
  brew update || warn "brew update failed (offline?) — continuing with the local index"
  trust_taps || true

  local brewfile="$DOTFILES/Brewfile" tmp skip cask app
  skip="$(unmanaged_casks)"
  if [ -n "$skip" ]; then
    tmp="$(mktemp "${TMPDIR:-/tmp}/Brewfile.XXXXXX")"
    cp "$brewfile" "$tmp"
    while IFS="$(printf '\t')" read -r cask app; do
      [ -n "$cask" ] || continue
      warn "$app already installed outside Homebrew — keeping yours (to let brew manage it: brew install --cask --adopt $cask)"
      grep -v "^cask \"$cask\"" "$tmp" >"$tmp.new" || true
      grep -v "^cask \"${cask##*/}\"" "$tmp.new" >"$tmp" || true
    done <<EOF
$skip
EOF
    brewfile="$tmp"
  fi

  local args="--file=$brewfile"
  [ "$UPGRADE" = 1 ] || args="$args --no-upgrade"
  local rc=0
  # shellcheck disable=SC2086
  brew bundle $args || rc=$?
  [ "$brewfile" = "$DOTFILES/Brewfile" ] || rm -f "$brewfile" "$brewfile.new"
  if [ $rc -eq 0 ]; then
    ok "all Brewfile entries installed"
  else
    warn "some entries failed — the rest are installed. See which with: brew bundle check --verbose --file=$DOTFILES/Brewfile"
    return 1
  fi
}

step_link() {
  step "Symlinking configs into \$HOME"
  "$DOTFILES/scripts/link.sh"
}

step_git() {
  step "Git identity (~/.gitconfig.local, not committed)"
  local f="$HOME/.gitconfig.local"
  if [ -f "$f" ]; then ok "exists"; return; fi

  # Reuse the identity from a gitconfig we just moved to the backup folder.
  local name="" email="" old
  for old in "$HOME"/.dotfiles-backup/*/.gitconfig; do :; done   # glob sorts by date → last = newest
  [ -f "$old" ] || old=""
  if [ -n "$old" ]; then
    name="$(git config --file "$old" user.name || true)"
    email="$(git config --file "$old" user.email || true)"
  fi
  local n="" e=""
  if { [ -z "$name" ] || [ -z "$email" ]; } && (: </dev/tty) 2>/dev/null; then
    printf '  Git name  [%s]: ' "$name"; read -r n </dev/tty || true
    printf '  Git email [%s]: ' "$email"; read -r e </dev/tty || true
    name="${n:-$name}"; email="${e:-$email}"
  fi
  cat >"$f" <<EOF
[user]
	name = ${name:-Your Name}
	email = ${email:-you@example.com}
EOF
  ok "wrote $f${old:+ (identity taken from your previous ~/.gitconfig)}"
}

step_shell() {
  step "Shell"
  case "${SHELL:-}" in
    */zsh) ok "zsh is already the login shell" ;;
    *) if chsh -s /bin/zsh; then ok "login shell → zsh"; else warn "could not change login shell"; return 1; fi ;;
  esac
  mkdir -p "$HOME/.local/state/zsh" "$HOME/.cache/zsh"
  # Old files zsh no longer reads now that ZDOTDIR=~/.config/zsh
  local f
  for f in .zshrc .zprofile .zlogin; do
    [ -f "$HOME/$f" ] && [ ! -L "$HOME/$f" ] &&
      warn "~/$f is no longer read — move anything you still need into ~/.config/zsh/local.zsh"
  done
  if [ "$UPGRADE" = 1 ] && has zsh && [ -r "$BREW_PREFIX/opt/antidote/share/antidote/antidote.zsh" ]; then
    ZDOTDIR="$HOME/.config/zsh" zsh -c "source $BREW_PREFIX/opt/antidote/share/antidote/antidote.zsh && antidote update" >/dev/null 2>&1 || true
  fi
  ok "zsh ready (plugins are fetched by antidote on first launch)"
}

step_rust() {
  step "Rust toolchain (rustup)"
  if ! has rustup; then
    # A Homebrew `rust` or other rustc on PATH would make rustup-init refuse.
    has rustc && warn "found an existing rustc ($(command -v rustc)) — rustup's will take precedence via ~/.cargo/bin"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
      RUSTUP_INIT_SKIP_PATH_CHECK=yes sh -s -- -y --no-modify-path --default-toolchain stable
  elif [ "$UPGRADE" = 1 ]; then
    rustup self update 2>/dev/null || true   # no-op/fails harmlessly when rustup came from brew
    rustup update stable
  else
    rustup toolchain list | grep -q '^stable' || rustup toolchain install stable
  fi
  rustup component add rust-analyzer clippy rustfmt rust-src
  ok "rustc $(rustc --version | cut -d' ' -f2)"

  if has cargo-binstall; then
    # Prebuilt binaries — seconds instead of minutes of compiling. binstall
    # skips tools that are already current and upgrades the rest.
    local tools="cargo-nextest cargo-watch cargo-edit cargo-expand cargo-audit cargo-outdated cargo-machete cargo-llvm-cov"
    if [ "$UPGRADE" = 0 ]; then
      local t missing=""
      for t in $tools; do has "$t" || missing="$missing $t"; done
      tools="$missing"
    fi
    if [ -n "${tools// /}" ]; then
      # shellcheck disable=SC2086
      cargo binstall --no-confirm $tools || { warn "some cargo tools failed"; return 1; }
    fi
    ok "cargo tools ready"
  else
    warn "cargo-binstall missing (Brewfile step failed?) — skipping cargo tools"
  fi
}

step_go() {
  step "Go tools"
  has go || { warn "go not installed — run the packages step first"; return 1; }
  local pkg bin
  for pkg in golang.org/x/tools/gopls golang.org/x/tools/cmd/goimports \
             gotest.tools/gotestsum github.com/fatih/gomodifytags; do
    bin="${pkg##*/}"
    if [ "$UPGRADE" = 0 ] && has "$bin"; then continue; fi
    go install "$pkg@latest"
  done
  ok "$(go version | cut -d' ' -f3)"
}

step_tmux() {
  step "tmux plugins (tpm)"
  local plugins="$HOME/.local/share/tmux/plugins"
  [ -d "$plugins/tpm" ] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$plugins/tpm"
  export TMUX_PLUGIN_MANAGER_PATH="$plugins/"
  # tpm asks the tmux server for the plugin list — make a running server see the new config.
  tmux info >/dev/null 2>&1 && tmux source-file "$HOME/.config/tmux/tmux.conf" >/dev/null 2>&1
  "$plugins/tpm/bin/install_plugins" >/dev/null
  if [ "$UPGRADE" = 1 ]; then "$plugins/tpm/bin/update_plugins" all >/dev/null; fi
  [ -d "$HOME/.tmux/plugins" ] && warn "~/.tmux/plugins (old location) is unused now — safe to delete"
  ok "plugins installed"
}

step_nvim() {
  step "Neovim plugins (lazy.nvim) + language servers (mason)"
  has nvim || { warn "nvim not installed — run the packages step first"; return 1; }
  # sync = install missing + update + clean; restore = exactly the versions in lazy-lock.json
  local cmd="Lazy! restore"
  [ "$UPGRADE" = 1 ] && cmd="Lazy! sync"
  nvim --headless "+$cmd" +qa >/dev/null 2>&1 || { warn "lazy.nvim reported errors — open nvim and run :Lazy"; return 1; }
  ok "done (language servers install in the background on first launch — see :Mason)"
}

step_themes() {
  step "Themes (bat / delta)"
  local d="$HOME/.config/bat/themes"
  mkdir -p "$d"
  if [ ! -f "$d/Catppuccin Mocha.tmTheme" ]; then
    curl -fsSL -o "$d/Catppuccin Mocha.tmTheme" \
      "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"
  fi
  has bat && bat cache --build >/dev/null
  ok "done"
}

step_macos() {
  step "macOS defaults"
  if [ "$SKIP_MACOS" = 1 ]; then warn "skipped (--no-macos)"; return; fi
  "$DOTFILES/scripts/macos.sh"
}

# Apps that are already running pick up the new configs without a restart.
step_reload() {
  step "Reloading running apps"
  if pgrep -xq AeroSpace; then
    if aerospace reload-config; then ok "AeroSpace config reloaded"
    else warn "AeroSpace reload failed — check ~/.config/aerospace/aerospace.toml"; fi
  fi
  if has tmux && tmux info >/dev/null 2>&1; then
    tmux source-file "$HOME/.config/tmux/tmux.conf" && ok "tmux config reloaded"
  fi
  if pgrep -xq kitty; then
    pkill -USR1 -x kitty && ok "kitty config reloaded"
  fi
  if has borders && pgrep -xq AeroSpace && ! pgrep -xq borders; then
    (borders active_color=0xffcba6f7 inactive_color=0x00000000 width=6.0 hidpi=on >/dev/null 2>&1 &)
    ok "borders started"
  fi
  return 0
}

# ---------- runner ------------------------------------------------------------
FAILED=""
wanted() { [ -z "$ONLY" ] || case ",$ONLY," in *",$1,"*) return 0 ;; *) return 1 ;; esac; }

for s in $STEPS; do
  case "$s" in
    xcode|brew|clone)
      # Prerequisites run in this shell: they set PATH/DOTFILES and must succeed.
      if wanted "$s" || [ "$s" = clone ]; then "step_$s"; fi
      ;;
    *)
      wanted "$s" || continue
      # Each step runs in its own subshell with `set -e`, so a failure stops that
      # step only. (Not inside `if`/`||`, which would silently disable set -e.)
      set +e
      ( set -e; "step_$s" )
      rc=$?
      set -e
      if [ $rc -ne 0 ]; then
        printf '%s  ✗ step "%s" failed (exit %s) — continuing%s\n' "$red" "$s" "$rc" "$reset"
        FAILED="$FAILED $s"
      fi
      ;;
  esac
done

if [ -n "$FAILED" ]; then
  failed_list="$(echo "$FAILED" | sed 's/^ //; s/ /,/g')"
  cat <<EOF

${yellow}${bold}Finished with problems in:${reset}${FAILED}
  Everything else is set up. Fix the cause (scroll up for the error) and re-run only those:
    ${bold}$DOTFILES/install.sh --only $failed_list${reset}
EOF
  exit 1
fi

if [ -z "$ONLY" ]; then
  cat <<EOF

${green}${bold}All done!${reset}

  Next steps (one-time, can't be automated):
   1. Open ${bold}AeroSpace${reset}, ${bold}Karabiner-Elements${reset} and ${bold}Raycast${reset} once and grant the
      Accessibility / Input Monitoring permissions they ask for.
   2. Set Raycast as your launcher (it offers to replace Spotlight's ⌘Space).
   3. Log out and back in so keyboard + Dock settings take effect.
   4. Open ${bold}kitty${reset} and type ${bold}keys${reset} — every shortcut in this setup, searchable.
   5. Run ${bold}dot doctor${reset} to double-check everything.

  Stuck? Press ${bold}alt-?${reset} anywhere (window manager), ${bold}ctrl-space ?${reset} in tmux,
  or ${bold}space${reset} in Neovim and wait — a menu pops up.
EOF
else
  printf '\n%sDone: %s%s\n' "$green$bold" "$ONLY" "$reset"
fi
