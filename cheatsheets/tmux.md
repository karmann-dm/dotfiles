# tmux — sessions, windows, panes

**Prefix = `ctrl-space`.** Press it, let go, then the key. The status bar turns purple while it's armed.
Lost? **prefix + space** opens a clickable menu that also shows each key.

## Help
| Keys | Action |
|------|--------|
| `prefix space` | Menu of all common actions |
| `prefix ?` | This cheatsheet |
| `prefix /` | All cheatsheets |
| `prefix alt-?` | Raw list of every tmux binding |

## Panes (splits)
| Keys | Action |
|------|--------|
| `prefix \|` or `prefix \` | Split right |
| `prefix -` | Split down |
| `ctrl-h/j/k/l` | Move between panes AND nvim splits (no prefix!) |
| `prefix z` | Zoom pane (toggle fullscreen) |
| `prefix x` | Close pane |
| `prefix H/J/K/L` | Resize (repeatable — keep pressing) |
| `prefix =` | Even out pane sizes |
| `prefix b` | Break pane into its own window |
| `prefix ctrl-l` | Clear the screen (ctrl-l alone moves right) |

## Windows (tabs)
| Keys | Action |
|------|--------|
| `prefix c` | New window |
| `prefix 1` … `prefix 9` | Go to window N |
| `prefix n` / `prefix p` | Next / previous window |
| `prefix tab` | Toggle last two windows |
| `prefix ,` | Rename window |
| `prefix <` / `prefix >` | Move window left / right |

## Sessions (one per project)
| Keys | Action |
|------|--------|
| `prefix o` | Fuzzy pick session / project dir (sesh) |
| `t` (in shell) | Same picker from the shell |
| `prefix s` | Tree of sessions & windows |
| `prefix O` | Previous session |
| `prefix S` | New named session |
| `prefix d` | Detach (session keeps running) |
| `prefix ctrl-s` / `prefix ctrl-r` | Save / restore sessions (auto every 15 min) |

## Popups
| Keys | Action |
|------|--------|
| `prefix g` | lazygit |
| `prefix y` | yazi file manager |
| `prefix ctrl-k` | k9s (kubernetes) |
| `prefix t` | Scratch shell |
| `prefix u` | Pick a URL on screen and open it |

## Copy mode (scroll & search)
| Keys | Action |
|------|--------|
| `prefix [` | Enter copy mode (or just scroll with the mouse) |
| `/` / `?` | Search down / up, `n` / `N` next / prev |
| `v` / `ctrl-v` | Start selection / rectangle selection |
| `y` | Copy selection to the macOS clipboard |
| `q` or `esc` | Leave copy mode |

## Maintenance
| Keys | Action |
|------|--------|
| `prefix r` | Reload tmux.conf |
| `prefix I` | Install plugins |
| `prefix U` | Update plugins |
