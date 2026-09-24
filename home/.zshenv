# ~/.zshenv — read by every zsh (scripts too). Keep it tiny: env vars only.
# The rest lives in ~/.config/zsh (ZDOTDIR).

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# This file is a symlink into the repo: <repo>/home/.zshenv → <repo>
export DOTFILES="${${(%):-%x}:A:h:h}"

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-R --mouse -i"
export MANPAGER="nvim +Man!"
export LANG="en_US.UTF-8"

export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export GOPATH="$HOME/go"
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_BUNDLE_NO_LOCK=1
