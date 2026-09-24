#!/usr/bin/env bash
# Symlink everything under home/ into $HOME.
#
#   home/.config/<app>      -> ~/.config/<app>       (whole directory)
#   home/.local/bin/<tool>  -> ~/.local/bin/<tool>   (per file)
#   home/.<file>            -> ~/.<file>
#
# Anything already in the way (that isn't our symlink) is moved to
# ~/.dotfiles-backup/<timestamp>/ — nothing is ever deleted.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$DOTFILES/home"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN="${DRY_RUN:-0}"

# Move a file/dir out of the way into the backup folder.
stash() {
  local path="$1"
  [ -e "$path" ] || [ -L "$path" ] || return 0
  echo "  backup  ${path/#"$HOME"/\~}"
  if [ "$DRY_RUN" != 1 ]; then
    mkdir -p "$(dirname "$BACKUP/${path#"$HOME"/}")"
    mv "$path" "$BACKUP/${path#"$HOME"/}"
  fi
}

link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    local was_real=1; [ -L "$dst" ] && was_real=0
    stash "$dst"
    # Replacing a hand-made nvim config: its plugins/state would clash with
    # LazyVim's, so park them next to the config.
    if [ "$dst" = "$HOME/.config/nvim" ] && [ "$was_real" = 1 ]; then
      stash "$HOME/.local/share/nvim"
      stash "$HOME/.local/state/nvim"
      stash "$HOME/.cache/nvim"
    fi
  fi
  echo "  link    ${dst/#"$HOME"/\~}"
  if [ "$DRY_RUN" != 1 ]; then
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
  fi
}

shopt -s dotglob nullglob

# Legacy locations that would shadow or conflict with the new configs:
#   ~/.aerospace.toml — AeroSpace refuses to start when it AND ~/.config/aerospace exist
#   ~/.tmux.conf      — tmux and tpm read it instead of ~/.config/tmux/tmux.conf
for legacy in "$HOME/.aerospace.toml" "$HOME/.tmux.conf"; do
  stash "$legacy"
done

for item in "$SRC"/*; do
  name="$(basename "$item")"
  case "$name" in
    .config|.local) continue ;;
  esac
  link "$item" "$HOME/$name"
done

for item in "$SRC"/.config/*; do
  link "$item" "$HOME/.config/$(basename "$item")"
done

for item in "$SRC"/.local/bin/*; do
  chmod +x "$item"
  link "$item" "$HOME/.local/bin/$(basename "$item")"
done

if [ -d "$BACKUP" ]; then
  echo "  ✓ links up to date — your previous files are in ${BACKUP/#"$HOME"/\~}"
else
  echo "  ✓ links up to date"
fi
