-- Rust extras on top of LazyVim's lang.rust (rustaceanvim + crates.nvim).
--   <space>cR  code actions (rust-analyzer's own menu)
--   <space>dr  debuggables      <space>tt  run test under cursor (neotest)
--   K          hover docs       gd         go to definition
return {
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy", extraArgs = { "--no-deps" } },
            inlayHints = { lifetimeElisionHints = { enable = "skip_trivial" } },
          },
        },
      },
    },
  },
}
