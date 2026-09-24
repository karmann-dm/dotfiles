# Rust

## In Neovim
| Keys | Action |
|------|--------|
| `space cR` | rust-analyzer code actions (grouped) |
| `space dr` | Debuggables (pick a target to debug) |
| `space tt` / `space tr` | Run tests in file / nearest test |
| `K` | Hover docs (press twice to enter the popup) |
| `space ca` | Quick fix (add import, fill match arms…) |
| `space cf` | cargo fmt |
| `K` / `space ca` (in Cargo.toml) | Crate info / upgrade a dependency (crates.nvim) |

## Shell aliases
| Command | Action |
|---------|--------|
| `cw` | bacon: re-runs check/clippy/test on every save (keys shown at bottom) |
| `cb` / `cr` | cargo build / cargo run |
| `ct` | cargo nextest run (fast parallel tests) |
| `ccl` | clippy with all targets, warnings = errors |
| `cf` | cargo fmt |
| `cargo add serde -F derive` | Add a dependency |
| `cargo expand` | Show macro-expanded code |
| `cargo audit` | Check dependencies for CVEs |
| `cargo machete` | Find unused dependencies |
| `cargo outdated` | List outdated dependencies |
| `cargo llvm-cov` | Test coverage |

## bacon (inside `cw`)
| Keys | Action |
|------|--------|
| `c` / `l` / `t` | clippy / check / test |
| `r` | Rerun |
| `f` | Show failing test only |
| `?` | Help |
