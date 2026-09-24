# Git & lazygit

## lazygit (`lg`, `prefix g`, or `space gg` in nvim)
| Keys | Action |
|------|--------|
| `?` | All keys for the current panel |
| `1`–`5` / `tab` | Jump between panels |
| `space` | Stage / unstage file (or hunk/line inside a file) |
| `a` | Stage all |
| `c` | Commit |
| `P` / `p` | Push / pull |
| `enter` | Open file diff — stage single lines with `space` |
| `n` | New branch |
| `r` (on commits) | Reword commit |
| `s` (on commits) | Squash into commit below |
| `e` | Edit file in nvim |
| `z` / `Z` | Undo / redo |
| `q` | Quit |

## Aliases (oh-my-zsh git plugin)
| Command | Action |
|---------|--------|
| `gst` | git status |
| `ga .` / `gaa` | add / add all |
| `gcmsg "msg"` | commit -m |
| `gp` / `gl` | push / pull |
| `gco` / `gcb name` | checkout / new branch |
| `gsw main` | switch branch |
| `glog` | pretty log graph |
| `gd` | diff |
| `grbi HEAD~3` | interactive rebase |

## git aliases (~/.gitconfig)
| Command | Action |
|---------|--------|
| `git undo` | Undo last commit, keep changes |
| `git amend` | Add staged changes to last commit |
| `git recent` | Branches by last commit date |
| `git dft` | Syntax-aware diff (difftastic) |
| `git lg` | Compact graph log |

## GitHub CLI
| Command | Action |
|---------|--------|
| `gh pr create` | Open a PR |
| `gh pr checkout 123` | Check out a PR |
| `gh pr view --web` | Open PR in browser |
| `gh run watch` | Watch CI |
