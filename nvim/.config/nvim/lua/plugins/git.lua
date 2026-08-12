return {
  -- Telescope git branch - see all changed files on branch vs main
  {
    "mrloop/telescope-git-branch.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>gB", function() require("git_branch").files() end, desc = "Branch files vs main" },
    },
    config = function()
      require("telescope").load_extension("git_branch")
    end,
  },

  -- Git worktree management
  {
    "polarmutex/git-worktree.nvim",
    version = "^2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("git_worktree")
      local Hooks = require("git-worktree.hooks")
      local update_on_switch = Hooks.builtins.update_current_buffer_on_switch
      Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
        vim.notify("Worktree: " .. path)
        update_on_switch(path, prev_path)
      end)
    end,
    keys = {
      { "<leader>gw", function() require("telescope").extensions.git_worktree.git_worktree() end, desc = "Switch Worktree" },
      {
        "<leader>gW",
        function()
          local branch = vim.fn.input("Branch: ")
          if branch == "" then return end
          local path = vim.fn.input("Path (default: ../" .. branch .. "): ")
          if path == "" then path = "../" .. branch end
          require("git-worktree").create_worktree(path, branch, "origin")
        end,
        desc = "Create Worktree",
      },
    },
  },

  -- Gitsigns - inline git status (already included in LazyVim, just configuring)
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Navigation
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")

        -- Actions
        map("n", "<leader>ghs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>ghr", gs.reset_hunk, "Reset Hunk")
        map("v", "<leader>ghs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage Hunk")
        map("v", "<leader>ghr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>gB", function()
          gs.blame()
        end, "Blame File")
        map("n", "<leader>ght", function()
          gs.toggle_current_line_blame()
        end, "Toggle Inline Blame")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, "Diff This ~")

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- Diffview - full diff viewing
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View (working tree)" },
      { "<leader>gD", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Diff View (last commit)" },
      { "<leader>gm", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diff View (vs main)" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current)" },
      { "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "File History (repo)" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diff View" },
    },
    config = function()
      local actions = require("diffview.actions")
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = {
          default = {
            layout = "diff2_horizontal",
          },
          merge_tool = {
            layout = "diff3_mixed",
            disable_diagnostics = true,
          },
          file_history = {
            layout = "diff2_horizontal",
          },
        },
        file_panel = {
          win_config = {
            position = "left",
            width = 35,
          },
        },
        keymaps = {
          view = {
            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,
            ["gf"] = actions.goto_file_edit,
            ["<leader>e"] = actions.toggle_files,
          },
          file_panel = {
            ["j"] = actions.next_entry,
            ["k"] = actions.prev_entry,
            ["<cr>"] = actions.select_entry,
            ["o"] = actions.select_entry,
            ["s"] = actions.toggle_stage_entry,
            ["-"] = actions.toggle_stage_entry,
            ["R"] = actions.refresh_files,
            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,
          },
        },
      })
    end,
  },
}
