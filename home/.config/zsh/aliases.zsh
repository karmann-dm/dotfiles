# Aliases. zsh-you-should-use will remind you when you forget one of these.

# Files
alias ls='eza --icons --group-directories-first'
alias l='eza -lh --icons --git --group-directories-first'
alias ll='eza -lah --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons --git-ignore'
alias cat='bat --paging=never --style=plain'
alias tree='eza --tree --icons'
alias ..='cd ..'
alias ...='cd ../..'

# Editor & tools
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias lg='lazygit'
alias help='tldr'
alias reload='exec zsh'
alias dots='dot edit'

# Rust
alias cb='cargo build'
alias cr='cargo run'
alias ct='cargo nextest run'
alias cw='bacon'                 # watch: check/clippy/test on save
alias ccl='cargo clippy --all-targets --all-features -- -D warnings'
alias cf='cargo fmt'

# Go
alias gob='go build ./...'
alias got='gotestsum --format pkgname -- ./...'
alias gol='golangci-lint run'
alias gomt='go mod tidy'

# Kubernetes / GitOps  (kubectl plugin also gives: kgp, kgs, kaf, kdel, klf …)
alias k='kubectl'
alias kx='kubectx'
alias kn='kubens'
alias kk='k9s'
alias fr='flux reconcile kustomization --with-source'
alias fga='flux get all -A'
