# ~/.config/zsh/.zshrc — interactive shell.
# Aliases → aliases.zsh · Functions → functions.zsh · Plugins → .zsh_plugins.txt
# Forgot a shortcut? Run `keys` (or `keys shell`).

# Non-login shells (e.g. some IDE terminals) still need PATH.
[[ -z $HOMEBREW_PREFIX || ":$PATH:" != *":$HOME/.local/bin:"* ]] && source $ZDOTDIR/.zprofile

# ── Options ───────────────────────────────────────────────────────────────────
HISTFILE=$XDG_STATE_HOME/zsh/history
HISTSIZE=100000
SAVEHIST=100000
setopt share_history hist_ignore_all_dups hist_ignore_space hist_reduce_blanks
setopt auto_cd auto_pushd pushd_ignore_dups pushd_silent   # `..` / `-` / dir names just work
setopt interactive_comments no_beep extended_glob
WORDCHARS=${WORDCHARS//[\/.-]}   # alt-backspace deletes one path segment
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}

# ── Plugins (antidote) ────────────────────────────────────────────────────────
zstyle ':antidote:bundle' use-friendly-names 'yes'
ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh; [[ -d $ZSH_CACHE_DIR/completions ]] || mkdir -p $ZSH_CACHE_DIR/completions
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $ZSH_CACHE_DIR/completions $fpath)
YSU_MESSAGE_POSITION="after"
YSU_MESSAGE_FORMAT="$(tput setaf 3)💡 alias exists:$(tput sgr0) %alias → %command"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

autoload -Uz compinit is-at-least add-zsh-hook
if [[ -r $HOMEBREW_PREFIX/opt/antidote/share/antidote/antidote.zsh ]]; then
  source $HOMEBREW_PREFIX/opt/antidote/share/antidote/antidote.zsh
  antidote load $ZDOTDIR/.zsh_plugins.pre.txt $ZSH_CACHE_DIR/plugins.pre.zsh
  compinit -d $ZSH_CACHE_DIR/zcompdump
  antidote load $ZDOTDIR/.zsh_plugins.txt $ZSH_CACHE_DIR/plugins.zsh
else
  compinit -d $ZSH_CACHE_DIR/zcompdump
fi

# ── Completion look ───────────────────────────────────────────────────────────
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'           # case-insensitive
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-flags '--height=50%' '--color=hl:#f38ba8,hl+:#f38ba8,pointer:#f5c2e7'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:(z|zoxide):*' fzf-preview 'eza -1 --color=always --icons $realpath'

# ── Tools ─────────────────────────────────────────────────────────────────────
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--layout=reverse --border=rounded --info=inline-right --height=60% \
  --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7 \
  --color=pointer:#f5c2e7,marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,border:#6c7086 \
  --bind 'ctrl-/:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up'"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:300 {}' --border-label=' files · ctrl-/ preview '"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons {}' --border-label=' cd into… '"
export BAT_THEME="Catppuccin Mocha"
export _ZO_EXCLUDE_DIRS="$HOME:/tmp/*"

# Each tool is optional — a half-finished install never breaks the shell.
(( $+commands[fzf] ))      && source <(fzf --zsh)                         # ctrl-t files · alt-c cd
(( $+commands[zoxide] ))   && eval "$(zoxide init zsh)"                   # z foo · zi (interactive)
(( $+commands[atuin] ))    && eval "$(atuin init zsh --disable-up-arrow)" # ctrl-r history search
(( $+commands[direnv] ))   && eval "$(direnv hook zsh)"
(( $+commands[starship] )) && eval "$(starship init zsh)"

# SDKMAN: JDKs / Gradle / Maven / Kotlin (`sdk help`). With sdkman_auto_env on,
# entering a directory with a .sdkmanrc switches to that project's versions.
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s $SDKMAN_DIR/bin/sdkman-init.sh ]] && source $SDKMAN_DIR/bin/sdkman-init.sh

# ── Keys ──────────────────────────────────────────────────────────────────────
bindkey -e                                  # emacs-style line editing (ctrl-a/e/w/u…)
bindkey '^E' autosuggest-accept             # ctrl-e / → accept the grey suggestion
bindkey '^[[1;3D' backward-word              # alt-←
bindkey '^[[1;3C' forward-word               # alt-→
autoload -z edit-command-line; zle -N edit-command-line
bindkey '^X^E' edit-command-line            # ctrl-x ctrl-e: edit the command in nvim

source $ZDOTDIR/functions.zsh
source $ZDOTDIR/aliases.zsh
bindkey '^G' _keys_widget                   # ctrl-g: open the cheatsheet picker
[[ -f $ZDOTDIR/local.zsh ]] && source $ZDOTDIR/local.zsh   # machine-specific, not in git

# ── A daily nudge ─────────────────────────────────────────────────────────────
# One random shortcut per new shell. Silence with: export DOTFILES_TIPS=0 (in local.zsh)
if [[ ${DOTFILES_TIPS:-1} == 1 && -z $NVIM ]] && (( $+commands[keys] )); then
  keys --tip 2>/dev/null
fi
