# Shell (zsh)

## Finding things
| Keys | Action |
|------|--------|
| `ctrl-r` | Search history (atuin) — ctrl-r again changes scope |
| `ctrl-t` | Fuzzy-pick a file, insert its path |
| `alt-c` | Fuzzy cd into a subdirectory |
| `tab` | Completion menu — type to filter, `<` `>` switch groups |
| `ctrl-g` | Open the keys cheatsheet |
| `z proj` | Jump to the most-used dir matching "proj" |
| `zi` | Pick a dir interactively |
| `fif text` | Find in files → enter opens nvim at the line |

## Line editing
| Keys | Action |
|------|--------|
| `→` or `ctrl-e` | Accept the grey autosuggestion |
| `ctrl-a` / `ctrl-e` | Start / end of line |
| `alt-←` / `alt-→` | Word left / right |
| `ctrl-w` / `alt-backspace` | Delete word / path segment |
| `ctrl-u` | Delete the whole line |
| `ctrl-x ctrl-e` | Edit the command in nvim |
| `esc .` or `alt-.` | Insert last argument of previous command |

## Handy commands
| Command | Action |
|---------|--------|
| `keys` | Searchable cheatsheet of everything |
| `t` | Pick / start a tmux session |
| `y` | File manager (cd's where you quit) |
| `v` | nvim |
| `lg` | lazygit |
| `ll` / `lt` | Detailed list / tree |
| `help tar` | Examples for any command (tldr) |
| `mkcd dir` | mkdir + cd |
| `dot update` | Update everything (brew, plugins, rust…) |
| `dot doctor` | Check the setup is healthy |
| `dot edit` | Open the dotfiles in nvim |
| `reload` | Restart the shell after config changes |
