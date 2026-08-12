-- Git signs and inline blame.
--
-- gitsigns rather than mini.diff, despite the rest of the config leaning on
-- mini: mini.diff has no blame at all, and inline blame is the point here. This
-- way one plugin covers signs, hunk navigation and blame, where the mini route
-- would have needed a second plugin for blame anyway.
--
-- Staging is deliberately not mapped. lazygit is bound to prefix+alt+g in herdr
-- and that is where staging happens; gitsigns.stage_hunk exists if that ever
-- changes.

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },

      -- The IntelliJ-style bit: author, when, and the commit subject as virtual
      -- text at end of the cursor's line.
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        -- The default is 1000ms, which feels broken rather than deliberate.
        delay = 300,
        -- Only blame in the focused window, so a split does not flicker.
        use_focus = true,
      },
      -- <author_time:%R> is a relative time ("3 days ago").
      current_line_blame_formatter = "  <author>, <author_time:%R> · <summary>",
      current_line_blame_formatter_nc = "  uncommitted",

      preview_config = { border = "rounded" },

      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "Git: " .. desc })
        end

        -- Navigation. Wrapped so they still work when a diff is open.
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next hunk")

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Previous hunk")

        -- Inspect
        map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame line (full)")
        map("n", "<leader>ghB", gs.blame, "Blame file")
        map("n", "<leader>ght", gs.toggle_current_line_blame, "Toggle inline blame")

        -- Undo
        map("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>ghr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")

        -- Diff
        map("n", "<leader>ghd", gs.diffthis, "Diff against index")
        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, "Diff against last commit")

        -- ih works as a text object: dih, vih
        map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
      end,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
      -- Blame text should recede, not compete with the code.
      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#7c6f64", italic = true })
    end,
  },
}
