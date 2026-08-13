-- Session restore: reopen the buffers, window layout and cursor positions you
-- had in a directory.
--
-- This does NOT overlap herdr's session restore. herdr brings back workspaces,
-- tabs and panes; it knows nothing about what was open *inside* nvim in a pane.
-- This restores that.
--
-- persistence over auto-session (1.9k stars) on purpose: restoring is explicit.
-- Auto-restoring on startup means `nvim` in a project silently reopens whatever
-- you last had, which is surprising when you wanted one file. Saving is
-- automatic; only loading is a keypress.
--
-- `branch = true` keys the session to the git branch, which matters with the
-- worktree workflow: each branch keeps its own set of open files.

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      -- Save only once at least one real file buffer is open, so starting nvim
      -- and quitting does not overwrite a good session with an empty one.
      need = 1,
      branch = true,
    },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore session (this dir + branch)",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore last session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Select a session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
          vim.notify("session will not be saved on exit", vim.log.levels.WARN)
        end,
        desc = "Stop saving this session",
      },
    },
    config = function(_, opts)
      require("persistence").setup(opts)

      -- Sessions store window layout, so transient windows have to go first or
      -- they come back empty and misplaced on restore. persistence only saves on
      -- VimLeavePre, so closing things here is safe.
      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistenceSavePre",
        group = vim.api.nvim_create_augroup("user_session_cleanup", { clear = true }),
        callback = function()
          pcall(function()
            require("edgy").close()
          end)
          pcall(function()
            require("mini.files").close()
          end)
          -- Scratch, terminal and dashboard buffers should not be restored
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) then
              local bt, ft = vim.bo[buf].buftype, vim.bo[buf].filetype
              if bt == "terminal" or bt == "nofile" or ft == "snacks_dashboard" then
                pcall(vim.api.nvim_buf_delete, buf, { force = true })
              end
            end
          end
        end,
      })
    end,
  },
}
