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

link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "  backup  ${dst/#"$HOME"/\~}"
    if [ "$DRY_RUN" != 1 ]; then
      mkdir -p "$(dirname "$BACKUP/${dst#"$HOME"/}")"
      mv "$dst" "$BACKUP/${dst#"$HOME"/}"
    fi
  fi
  echo "  link    ${dst/#"$HOME"/\~}"
  if [ "$DRY_RUN" != 1 ]; then
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
  fi
}

shopt -s dotglob nullglob

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

echo "  ✓ links up to date"
