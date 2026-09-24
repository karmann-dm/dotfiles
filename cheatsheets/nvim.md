# Neovim (LazyVim)

**Leader = `space`.** Press it and *wait* — which-key shows every option. Same for `g`, `z`, `[`, `]`.
Grey hints above the line show where `w`/`b`/`e`/`$`… jump (toggle `space uP`).

## Help
| Keys | Action |
|------|--------|
| `space` (wait) | Menu of everything |
| `space sk` | Search all keymaps |
| `space k` | Cheatsheet for the whole setup |
| `space ?` | Keymaps for the current buffer |
| `space uP` / `space uH` | Toggle motion hints / habit hints |
| `:Tutor` | 30-min interactive vim tutorial — do it once! |

## Files & search
| Keys | Action |
|------|--------|
| `space space` | Find file (fuzzy) |
| `space /` | Grep in project |
| `space ,` | Switch buffer |
| `space e` | File explorer (sidebar) |
| `space fr` | Recent files |
| `space sw` | Search word under cursor |
| `space sr` | Search & replace across files (grug-far) |
| `s` + 2 chars | Flash-jump anywhere on screen |

## Moving
| Keys | Action |
|------|--------|
| `h j k l` | ← ↓ ↑ → |
| `w` / `b` / `e` | Next word / back word / end of word |
| `0` / `^` / `$` | Line start / first char / line end |
| `gg` / `G` | File top / bottom |
| `ctrl-d` / `ctrl-u` | Half page down / up |
| `{` / `}` | Previous / next paragraph |
| `%` | Jump to matching bracket |
| `ctrl-o` / `ctrl-i` | Jump back / forward |
| `ctrl-h/j/k/l` | Move between splits (and tmux panes) |

## Editing
| Keys | Action |
|------|--------|
| `i` / `a` / `o` | Insert before / after / new line below |
| `esc` or `jk` or caps lock | Back to normal mode |
| `ciw` / `ci"` / `ci(` | Change inner word / "…" / (…) |
| `dd` / `yy` / `p` | Delete line / copy line / paste |
| `u` / `ctrl-r` | Undo / redo |
| `.` | Repeat last change |
| `gcc` / `gc` (visual) | Toggle comment |
| `alt-j` / `alt-k` | Move line down / up |
| `gsa` / `gsd` / `gsr` | Surround add / delete / replace |
| `space p` | Yank history |

## Code (LSP)
| Keys | Action |
|------|--------|
| `gd` / `gr` | Go to definition / references |
| `gI` / `gy` | Go to implementation / type definition |
| `K` | Hover docs |
| `space ca` | Code action (quick fix) |
| `space cr` | Rename symbol |
| `space cf` | Format |
| `]d` / `[d` | Next / prev diagnostic |
| `space xx` | All diagnostics (Trouble) |
| `space ss` | Symbols in file |

## Git
| Keys | Action |
|------|--------|
| `space gg` | lazygit |
| `]h` / `[h` | Next / prev changed hunk |
| `space ghp` | Preview hunk |
| `space ghs` / `space ghr` | Stage / reset hunk |
| `space gb` | Blame line |

## Windows, buffers, tabs
| Keys | Action |
|------|--------|
| `space -` / `space \|` | Split below / right |
| `space wd` | Close split |
| `shift-h` / `shift-l` | Previous / next buffer |
| `space bd` | Close buffer |
| `space qq` | Quit all |

## Debug & test
| Keys | Action |
|------|--------|
| `space db` | Toggle breakpoint |
| `space dc` | Continue / start debugging |
| `space du` | Debug UI |
| `space tt` / `space tr` | Run test file / nearest test |
| `space ts` | Test summary |
