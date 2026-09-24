-- Plugins that TEACH you the keyboard instead of expecting you to know it.
return {
  -- which-key: the popup after pressing <space>, g, z, [, ], " …
  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
      delay = function(ctx)
        return ctx.plugin and 0 or 250
      end,
      spec = {
        { "<leader>k", icon = "⌨ " },
      },
    },
  },

  -- precognition: shows where w / b / e / $ / ^ / { / } would jump, right in the
  -- buffer. Turn it off once you've got it: <space>uP
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = {
      startVisible = true,
      showBlankVirtLine = false,
    },
    keys = {
      {
        "<leader>uP",
        function()
          if require("precognition").toggle() then
            vim.notify("Motion hints on", vim.log.levels.INFO, { title = "precognition" })
          else
            vim.notify("Motion hints off", vim.log.levels.INFO, { title = "precognition" })
          end
        end,
        desc = "Toggle motion hints (precognition)",
      },
    },
  },

  -- hardtime: notices inefficient habits (jjjjj, holding arrows) and suggests
  -- the better motion. Hint mode only — it never blocks you. Toggle: <space>uH
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      restriction_mode = "hint",
      disable_mouse = false,
      max_count = 4,
      -- arrows still work; you just get a gentle hint
      disabled_keys = {
        ["<Up>"] = false,
        ["<Down>"] = false,
        ["<Left>"] = false,
        ["<Right>"] = false,
      },
      disabled_filetypes = { "lazy", "mason", "snacks_dashboard", "snacks_picker_input", "neo-tree", "qf", "help" },
    },
    keys = {
      { "<leader>uH", "<cmd>Hardtime toggle<cr>", desc = "Toggle habit hints (hardtime)" },
    },
  },
}
