# Neovim guide

A practical guide to the Neovim in this setup: LazyVim plus Rust, Go and YAML/Kubernetes support.
Read part 1 once, keep part 2 open for a week, and treat the rest as a reference.

> **The one rule:** when you don't know a key, press **`space`** and **wait**. A menu (which-key)
> shows everything you can press next. The same works for `g`, `z`, `[`, `]`, `"` and `ctrl-w`.

Contents:
1. [How Neovim thinks](#1-how-neovim-thinks)
2. [Survival kit (day 1)](#2-survival-kit-day-1)
3. [The hint system](#3-the-hint-system)
4. [Files, buffers and search](#4-files-buffers-and-search)
5. [Moving fast](#5-moving-fast)
6. [Editing: the grammar](#6-editing-the-grammar)
7. [Splits, tmux and the terminal](#7-splits-tmux-and-the-terminal)
8. [Code intelligence (LSP)](#8-code-intelligence-lsp)
9. [Git](#9-git)
10. [Rust workflow](#10-rust-workflow)
11. [Go workflow](#11-go-workflow)
12. [YAML, Kubernetes and Helm](#12-yaml-kubernetes-and-helm)
13. [Tests and debugging](#13-tests-and-debugging)
14. [Maintenance and customizing](#14-maintenance-and-customizing)
15. [Troubleshooting](#15-troubleshooting)
16. [Practice plan](#16-practice-plan)

---

## 1. How Neovim thinks

Neovim has **modes**. Most confusion comes from typing in the wrong one.

| Mode | How you get there | What keys do | Status line shows |
|---|---|---|---|
| **Normal** | `esc` (or caps lock, or `jk`) | Move around and run commands. `d` deletes, `w` jumps a word… | `NORMAL` |
| **Insert** | `i`, `a`, `o` | Type text like in any editor | `INSERT` |
| **Visual** | `v` (chars), `V` (lines), `ctrl-v` (block) | Select, then act on the selection | `VISUAL` |
| **Command** | `:` | Type a command such as `:w` and press enter | the `:` prompt |

You spend most of your time in **Normal mode**. You drop into Insert mode to type, then go
straight back out with `esc`. Caps lock is esc when tapped (Karabiner), so it's always under your
little finger.

**Leader key = `space`.** Almost every LazyVim command is `space` followed by a mnemonic:
`space f…` files, `space s…` search, `space c…` code, `space g…` git, `space t…` tests,
`space d…` debug, `space u…` UI toggles, `space x…` problem lists, `space q…` quit/session.

---

## 2. Survival kit (day 1)

| Want to… | Keys |
|---|---|
| Open a project | `cd ~/code/project && nvim` (or `t` to pick a tmux session first) |
| Find a file by name | `space space`, type part of the name, `enter` |
| Start typing | `i` (before the cursor) · `a` (after) · `o` (new line below) · `O` (above) |
| Stop typing | `esc` / caps lock / `jk` |
| Save | `ctrl-s` (works in any mode) or `:w` |
| Undo / redo | `u` / `ctrl-r` |
| Move | `h j k l` (← ↓ ↑ →), or the arrow keys (allowed; you'll get a gentle hint) |
| Delete a line / copy a line / paste | `dd` / `yy` / `p` |
| Search in the file | `/word`, `enter`, then `n` / `N` for next / previous |
| Close the file | `space bd` |
| Quit everything | `space qq` |
| "Help, I'm lost" | `esc esc`, then `space` and wait |

Do the built-in tutorial once: type `:Tutor` and press enter. It takes about 30 minutes and is
the best investment in this whole setup.

---

## 3. The hint system

This config is set up to teach you as you go:

| Helper | What it does | Toggle |
|---|---|---|
| **which-key** | Press `space`, `g`, `z`, `[`, `]` and wait: a menu shows what comes next | always on |
| **precognition** | Faint markers above the cursor line show where `w` `b` `e` `^` `$` `{` `}` would jump | `space uP` |
| **hardtime** | Spots slow habits (`jjjjj`, holding arrows) and suggests the faster motion. It only hints and never blocks. | `space uH` |
| **`space sk`** | Fuzzy-search every keymap by description ("rename", "format", …) | — |
| **`space ?`** | Keymaps that only exist in the current file type | — |
| **`space k`** | The whole-setup cheatsheet (tmux, AeroSpace, shell, git, …) | — |
| **`space sh`** | Search Neovim's help pages | — |

Tip: in any picker (files, grep, keymaps…), press **`?`** to see its own keys.

---

## 4. Files, buffers and search

**Finding things**

| Keys | What |
|---|---|
| `space space` | Find file in the project (fuzzy) |
| `space /` | Grep: find text in all project files |
| `space sw` | Grep for the word under the cursor (or the visual selection) |
| `space fr` | Recent files |
| `space ,` | Open files ("buffers") |
| `space fc` | Neovim config files |
| `space sR` | Reopen the last picker with the same query |
| `space sr` | **Search and replace across files** (grug-far): type search + replacement, review, apply |

Inside a picker: type to filter, `ctrl-j` / `ctrl-k` (or arrows) to move, `enter` to open,
`ctrl-v` / `ctrl-s` to open in a vertical / horizontal split, `esc` to close, `?` for help.

**The file explorer: `space e`**

| Key (in the explorer) | What |
|---|---|
| `enter` / `l` | Open file / expand folder |
| `h` / `backspace` | Collapse / go up a directory |
| `a` | Add a file (end the name with `/` to create a folder) |
| `r` / `d` | Rename / delete |
| `c` / `m` / `p` | Copy / move / paste |
| `?` | All explorer keys |

**Buffers** are open files. The tabs along the top are buffers, not "tabs".

| Keys | What |
|---|---|
| `shift-h` / `shift-l` | Previous / next buffer |
| `space bb` | Toggle between the last two buffers |
| `space bd` | Close buffer |
| `space bo` | Close all *other* buffers |

**Sessions.** Neovim remembers the open files per directory. After reopening a project, press
`space qs` to restore them (`space ql` restores the last session anywhere).

---

## 5. Moving fast

The goal is to stop pressing `j` twenty times. Use precognition's markers to learn these.

| Keys | Moves to… |
|---|---|
| `w` / `b` / `e` | Next word / back one word / end of word (`W` `B` `E` ignore punctuation) |
| `0` / `^` / `$` | Line start / first non-blank character / line end |
| `f x` / `t x` | Onto / just before the next `x` on this line (`;` repeats, `,` goes back) |
| `s` + 2 chars | **Flash**: jump anywhere on screen. Type 2 letters, then the highlighted label |
| `S` | Flash-select a whole syntax node (function, block, argument…) |
| `{` / `}` | Previous / next blank line (paragraph) |
| `%` | The matching bracket |
| `gg` / `G` / `42G` | Top / bottom / line 42 |
| `ctrl-d` / `ctrl-u` | Half page down / up (kept centered) |
| `zz` | Center the screen on the cursor |
| `ctrl-o` / `ctrl-i` | Jump back / forward (after `gd`, search, `G`…). Use this constantly. |
| `]f` / `[f` | Next / previous function start |
| `]]` / `[[` | Next / previous occurrence of the word under cursor |

**Counts:** most motions take a number. `5j` moves down 5 lines. The line numbers on the left are
relative to the cursor for exactly this reason: the line labelled `7` is `7j` away.

---

## 6. Editing: the grammar

Editing commands are sentences: **verb + (count) + noun**.

| Verbs | | Nouns (motions & text objects) | |
|---|---|---|---|
| `d` | delete | `w` | to next word |
| `c` | change (delete + insert mode) | `iw` / `aw` | inner word / a word (with space) |
| `y` | yank (copy) | `i"` / `a"` | inside / around quotes |
| `>` / `<` | indent / dedent | `i(` `i{` `i[` `it` | inside parens / braces / brackets / tag |
| `gc` | toggle comment | `if` / `af` | inside / around a **function** |
| `gU` / `gu` | uppercase / lowercase | `ic` / `ac` | inside / around a **class/struct** |
| | | `ia` / `aa` | an **argument** |
| | | `ip` | paragraph |
| | | `$` / `0` | to end / start of line |

Examples, read out loud:

- `ciw` — **c**hange **i**nner **w**ord
- `di"` — **d**elete **i**nside **"**quotes"
- `ya{` — **y**ank **a**round **{** braces
- `daf` — **d**elete **a** **f**unction
- `cia` — **c**hange **i**nner **a**rgument (great for function calls)
- `gcip` — comment a paragraph
- `>ip` — indent a paragraph

Doubling the verb acts on the whole line: `dd`, `cc`, `yy`, `>>`, `gcc`.

**The dot command.** `.` repeats your last change. Change one word with `ciw`, type the new text,
press `esc`, then jump to the next occurrence with `n` and press `.`.

**More editing**

| Keys | What |
|---|---|
| `x` / `r x` | Delete character / replace it with `x` |
| `J` | Join the line below onto this one |
| `p` / `P` | Paste after / before (`space p` = pick from yank history) |
| `space P` (visual) | Paste over a selection without losing what you copied |
| `gsa iw "` | **Surround** add: wrap word in quotes (`gsa` + motion + char) |
| `gsd "` / `gsr " '` | Surround delete / replace |
| `gco` / `gcO` | Add a comment line below / above |
| `ddp` / `ddkP` | Move line down / up. LazyVim's `alt-j/k` is taken by AeroSpace here. |
| `V` then `j`/`k`, then `>` or `d` or `y` | Select lines, then act on them |
| `ctrl-v`, `j`…, `I`, text, `esc` | Block select: type the same text on many lines |
| `:%s/old/new/g` | Replace in the whole file (add `c` at the end to confirm each one) |
| `*` | Search for the word under the cursor |

**Completion** pops up by itself while you type. Use `ctrl-n` / `ctrl-p` (or arrows) to move and
`enter` (or `ctrl-y`) to accept. Press `esc` or `ctrl-e` to close it. `tab` jumps to the next
placeholder in a snippet. (`ctrl-space` would open it manually, but that's the tmux prefix here,
so rely on it opening automatically.)

---

## 7. Splits, tmux and the terminal

| Keys | What |
|---|---|
| `space \|` / `space -` | Split right / below |
| `ctrl-h/j/k/l` | Move between splits **and tmux panes**. They behave as one grid. |
| `space wd` | Close this split |
| `space wm` | Maximize / restore this split |
| `ctrl-w =` | Make all splits equal size |
| `ctrl-/` | Toggle a floating terminal at the project root (`space ft` too) |

A good layout for Rust: Neovim on the left, and a tmux pane on the right (`ctrl-space |`) running
`bacon`. Move between them with `ctrl-h` / `ctrl-l`.

---

## 8. Code intelligence (LSP)

Language servers give Neovim IDE features. They start automatically when you open a Rust, Go or
YAML file inside a project. The first time, Mason downloads them in the background.

| Keys | What |
|---|---|
| `K` | Docs for the thing under the cursor (press `K` again to move into the popup) |
| `gd` | Go to definition (`ctrl-o` to come back) |
| `gr` | All references |
| `gI` / `gy` | Go to implementation / type definition |
| `gK` or `ctrl-k` (insert) | Function signature help |
| `space ca` | **Code action**: quick fixes, imports, "fill match arms", … |
| `space cr` | Rename a symbol everywhere (with live preview) |
| `space cf` | Format the file (also happens on save; toggle auto-format with `space uf`) |
| `space ss` / `space sS` | Symbols in this file / in the whole project |
| `]d` `[d` / `]e` `[e` | Next / previous diagnostic / error |
| `space cd` | Show the full diagnostic message for this line |
| `space xx` | All diagnostics in a list (Trouble) |
| `space sd` | Diagnostics in a picker |
| `space uh` | Toggle inlay hints (the grey type annotations) |
| `space cl` | Which language servers are attached |

---

## 9. Git

| Keys | What |
|---|---|
| `space gg` | **lazygit** (stage, commit, push, branches; press `?` inside for keys) |
| `]h` / `[h` | Next / previous changed hunk |
| `space ghp` | Preview the hunk inline |
| `space ghs` / `space ghr` | Stage / reset the hunk |
| `space ghb` | Blame the line (who changed it and why) |
| `space gb` | Git blame line (popup) |
| `space gs` | Git status picker |
| `space gl` | Git log |

Signs in the left gutter show added, changed and deleted lines.

---

## 10. Rust workflow

Everything comes from LazyVim's Rust extra: **rustaceanvim** (rust-analyzer), **crates.nvim**,
codelldb for debugging and neotest for tests. rust-analyzer itself comes from rustup
(`rustup component add rust-analyzer`, which the installer already ran).

**Open a project from its root** (the folder with `Cargo.toml`), otherwise rust-analyzer starts
in a reduced "standalone" mode.

```sh
t                       # pick/create a tmux session for the project
nvim                    # open Neovim at the project root
```

| Task | How |
|---|---|
| See type of anything | `K`, or turn on inlay hints: `space uh` |
| Fix a compiler error | `]e` to jump to it, `space ca` for suggested fixes |
| Clippy warnings | Shown inline as you save (rust-analyzer runs clippy on save) |
| Rust-specific actions | `space cR`: expand macro, open Cargo.toml, parent module, explain error, … |
| Run a test | Cursor inside `#[test] fn …`, then `space tr`. `space tt` runs the whole file. |
| Test output | `space to` (output of the last test), `space ts` (summary tree) |
| Debug a binary/test | `space dr` (Rust debuggables: pick a target), set breakpoints with `space db` |
| Dependencies | In `Cargo.toml`, versions show inline. `K` on a crate shows info, `space ca` upgrades it. |
| Rename a type or function | `space cr` |
| Continuous checking | In a tmux pane next to Neovim: `cw` (bacon). Press `c` clippy, `t` test, `?` help. |

Formatting (rustfmt) runs on save.

---

## 11. Go workflow

LazyVim's Go extra sets up **gopls**, **gofumpt + goimports** (format and fix imports on save),
**golangci-lint**, **delve** for debugging and **neotest-golang** for tests.

| Task | How |
|---|---|
| Run the test under cursor / file | `space tr` / `space tt` |
| Debug the test under cursor | `space td` |
| Fill a struct literal, add error checks, generate interface stubs… | `space ca` |
| Go to implementation of an interface | `gI` |
| Add JSON tags to a struct | `space ca` (gomodifytags is installed) |
| Imports | Just save: goimports adds and removes them |

Tabs are displayed 4 columns wide in Go files.

---

## 12. YAML, Kubernetes and Helm

**Schemas give you completion, validation and docs.** yamlls picks the schema automatically for
well-known files: `kustomization.yaml`, `Chart.yaml`, `values.schema.json`, GitHub Actions
workflows, docker-compose, `.gitlab-ci.yml` and more (via SchemaStore).

**Kubernetes manifests** can't be recognized from the file name, so:

1. Open a manifest (`deployment.yaml`, a Flux `HelmRelease`, an Argo `Application`, …).
2. Press **`space cK`**. It reads `apiVersion` / `kind` and adds a first line like
   `# yaml-language-server: $schema=https://…/deployment-apps-v1.json`.
   Core resources use the upstream Kubernetes schemas. CRDs (Flux, Argo, cert-manager,
   external-secrets, …) use the datreeio CRD catalog.
3. Now you get: completion of every field (it pops up by itself), `K` on a field for its docs,
   and red errors for typos and wrong types.

Commit that first line: everyone else using yamlls gets the same help.

| Task | How |
|---|---|
| Format YAML | `space cf` (also on save) |
| Lint | yamllint runs automatically; see problems with `]d` or `space xx` |
| Helm templates | Files under `templates/` are detected as Helm (helm-ls): completion for `.Values.…` |
| Fold big manifests | `za` toggle fold, `zM` fold all, `zR` unfold all |
| Validate before pushing | In the shell: `kval overlays/prod/` (kustomize build + kubeconform) |

---

## 13. Tests and debugging

**Tests (neotest)** — `space t…`

| Keys | What |
|---|---|
| `space tr` | Run nearest test |
| `space tt` | Run all tests in file |
| `space tT` | Run all tests in the project |
| `space tl` | Re-run last test |
| `space ts` | Summary tree (enter to run, `?` for keys) |
| `space to` / `space tO` | Output of a test / output panel |
| `space td` | Debug nearest test |

Pass/fail icons show next to each test in the gutter.

**Debugger (DAP)** — `space d…`

| Keys | What |
|---|---|
| `space db` | Toggle breakpoint on this line |
| `space dB` | Conditional breakpoint |
| `space dc` | Start / continue |
| `space dO` / `space di` / `space do` | Step over / into / out |
| `space dC` | Run to cursor |
| `space du` | Toggle the debug UI (variables, stack, watches) |
| `space de` | Evaluate expression under cursor |
| `space dt` | Terminate |

---

## 14. Maintenance and customizing

| Command | What |
|---|---|
| `:Lazy` (`space l`) | Plugins: `U` update, `S` sync, `X` clean, `?` help |
| `:Mason` (`space cm`) | Language servers, formatters and linters: `i` install, `U` update |
| `:LazyExtras` | Enable more languages and features. Move to one, press `x`, restart. |
| `:checkhealth` | Diagnose problems |
| `dot update` (shell) | Update everything, Neovim plugins included |

**Where the config lives** (`dot edit` opens it, or `space fc`):

```
home/.config/nvim/
├── init.lua
├── lazy-lock.json          # exact plugin versions (commit it after updating)
└── lua/
    ├── config/
    │   ├── lazy.lua        # which LazyVim extras are enabled
    │   ├── options.lua     # editor options
    │   ├── keymaps.lua     # your own keymaps
    │   └── autocmds.lua
    └── plugins/            # one file per topic; each returns a list of plugin specs
        ├── hints.lua       # which-key, precognition, hardtime
        ├── rust.lua
        ├── yaml.lua
        └── tmux.lua
```

**Add your own keymap** in `lua/config/keymaps.lua`. Always give it a `desc` so which-key shows it:

```lua
vim.keymap.set("n", "<leader>cb", "<cmd>!cargo build<cr>", { desc = "Cargo build" })
```

**Add a plugin:** create `lua/plugins/<name>.lua` returning `{ "author/repo", opts = {} }`, then
restart Neovim. LazyVim's docs at <https://lazyvim.org> list the options for every built-in plugin.

After updating plugins, commit `lazy-lock.json` so other machines get the same versions.

---

## 15. Troubleshooting

| Symptom | Fix |
|---|---|
| No completion, `gd` does nothing | `space cl`: is a server attached? If not, open `:Mason` and check for errors, or run `:checkhealth vim.lsp`. |
| Rust: "standalone mode" / missing features | Open Neovim from the folder with `Cargo.toml`. Check `rust-analyzer --version` works in the shell. |
| Formatting changed my file unexpectedly | `space uf` toggles format-on-save (`space uF` just for this buffer) |
| Too many hints / popups | `space uP` (motion hints), `space uH` (habit hints) |
| A key does nothing | It may be caught by AeroSpace (`alt-…`) or tmux (`ctrl-space`). Search it with `space sk`. |
| Weird colors or icons | Use kitty with the JetBrainsMono Nerd Font (already configured) |
| Everything is broken after an update | `:Lazy`, then `R` restores plugins to `lazy-lock.json`. Or `git checkout lazy-lock.json` and `:Lazy restore`. |
| Stuck in some mode | `esc` twice, then `:q!` to quit without saving, or `space qq` |

---

## 16. Practice plan

About 15 minutes a day. Always keep precognition and hardtime on while learning.

| Week | Focus | Daily drill |
|---|---|---|
| 1 | Modes, `hjkl`, `i a o`, `esc`, `:w`, `u`, `dd yy p` | Do `:Tutor` once, then edit real code without the mouse |
| 2 | `w b e`, `f/t`, `s` (flash), `ctrl-d/u`, `space space`, `space /` | Never press `j` more than 3 times in a row. Use counts or flash. |
| 3 | Verb + text object: `ciw`, `di"`, `cia`, `daf`, `.` | Refactor something using only text objects and `.` |
| 4 | LSP: `gd`, `K`, `space ca`, `space cr`, `]e`, tests `space tr` | Fix a whole compile error list with `]e` + `space ca` |
| 5 | Splits + tmux + git: `ctrl-hjkl`, `space gg`, hunks | Stage and commit only from Neovim |
| 6 | Debugger, `space sr`, macros (`qa` … `q`, then `@a`) | Debug one failing test with breakpoints |

Once a week, open `space sk`, scroll through the list and try one command you didn't know.
