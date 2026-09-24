# Login shells. PATH is set here (not in .zshenv) because macOS runs
# /usr/libexec/path_helper from /etc/zprofile, which would reorder it.

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

typeset -U path   # no duplicates
path=(
  $HOME/.local/bin
  $CARGO_HOME/bin
  $GOPATH/bin
  $path
)
export PATH
