# Shell functions.

# ctrl-g widget: open the `keys` picker without losing what you typed.
_keys_widget() { zle -I; keys </dev/tty; zle reset-prompt }
zle -N _keys_widget

# y: file manager that cd's to wherever you quit it.
y() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(<"$tmp")" && [[ -n $cwd && $cwd != $PWD ]]; then builtin cd -- "$cwd"; fi
  rm -f -- "$tmp"
}

# mkcd dir: make a directory and enter it.
mkcd() { mkdir -p -- "$1" && cd -- "$1" }

# t: pick/attach a tmux session (works inside and outside tmux).
t() {
  if [[ -n $1 ]]; then sesh connect "$1"; return; fi
  if [[ -z $TMUX ]] && ! tmux has-session 2>/dev/null; then
    sesh connect "$PWD"          # nothing running yet → start a session here
  else
    sesh-pick
  fi
}

# fif: find-in-files — ripgrep + fzf, enter opens the match in nvim at that line.
fif() {
  local sel
  sel=$(rg --color=always --line-number --no-heading --smart-case "${*:-}" |
    fzf --ansi --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'right,60%,border-left,+{2}+3/3,~3' \
        --border-label ' find in files · enter opens nvim ') || return
  nvim "${sel%%:*}" +"$(cut -d: -f2 <<<"$sel")"
}

# kctx: show which cluster you're pointing at (starship shows it too).
kctx() { kubectl config current-context }

# kval: validate k8s manifests/kustomize output with kubeconform.
#   kval file.yaml   ·   kval ./overlays/prod   (runs kustomize build)
kval() {
  local target=${1:-.}
  if [[ -d $target && -f $target/kustomization.yaml ]]; then
    kustomize build "$target" | kubeconform -strict -summary -ignore-missing-schemas \
      -schema-location default \
      -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' -
  else
    kubeconform -strict -summary -ignore-missing-schemas \
      -schema-location default \
      -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' "$target"
  fi
}
