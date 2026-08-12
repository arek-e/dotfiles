-- File explorer.
--
-- mini.files rather than neo-tree or nvim-tree: it is a column browser you
-- navigate with the same keys you already use to move around a buffer, and the
-- directory listing is itself editable, so renaming, creating and deleting are
-- ordinary text edits confirmed in one go.
--
-- Installed as the standalone module, not the whole mini.nvim suite.
-- It pairs with telescope: telescope answers "where is X", mini.files answers
-- "what is around here, and let me restructure it".

return {
  {
    "echasnovski/mini.files",
    version = false,
    dependencies = { "echasnovski/mini.icons" },
    keys = {
      {
        "<leader>fe",
        function()
          local files = require("mini.files")
          -- Reveal the current file rather than opening at the cwd, unless the
          -- buffer has no file on disk yet.
          local path = vim.api.nvim_buf_get_name(0)
          if path ~= "" and vim.uv.fs_stat(path) then
            files.open(path, true)
          else
            files.open(vim.uv.cwd(), true)
          end
        end,
        desc = "Explorer (current file)",
      },
      {
        "<leader>fE",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "Explorer (cwd)",
      },
    },
    opts = {
      -- Miller columns: going into a directory adds a column on the right and
      -- keeps the parents visible, so the whole branch stays on screen.
      --
      -- mini.files always keeps the full branch in memory; how much of it you
      -- can see is purely a function of these widths against your terminal
      -- width. These are deliberately narrow so five or six levels fit at once
      -- rather than two fat ones. `<` and `>` trim the branch left and right if
      -- it ever does outgrow the screen.
      windows = {
        preview = true,
        width_focus = 28, -- the column your cursor is in
        width_nofocus = 16, -- parent columns, just wide enough to read names
        width_preview = 34, -- rightmost lookahead pane
      },
      options = {
        -- Deletions go to a trash dir instead of being unrecoverable
        permanent_delete = false,
        use_as_default_explorer = true,
      },
      mappings = {
        go_in = "l",
        go_in_plus = "L", -- open the file and close the explorer
        go_out = "h",
        go_out_plus = "H",
        synchronize = "=", -- apply the edits you made to the listing
        reset = "<BS>",
        show_help = "g?",
      },
    },
    config = function(_, opts)
      require("mini.icons").setup()
      require("mini.files").setup(opts)

      local group = vim.api.nvim_create_augroup("user_mini_files", { clear = true })

      -- Show dotfiles, and let g. toggle them. Your old neo-tree config had
      -- them visible, since .env files matter in this stack.
      local show_dotfiles = true
      local function filter_show()
        return true
      end
      local function filter_hide(entry)
        return not vim.startswith(entry.name, ".")
      end

      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.keymap.set("n", "g.", function()
            show_dotfiles = not show_dotfiles
            require("mini.files").refresh({
              content = { filter = show_dotfiles and filter_show or filter_hide },
            })
          end, { buffer = args.data.buf_id, desc = "Toggle dotfiles" })

          -- q closes, matching every other transient window in this config
          vim.keymap.set("n", "q", function()
            require("mini.files").close()
          end, { buffer = args.data.buf_id, desc = "Close explorer" })

          -- Arrow navigation alongside h/l. mini.files' own `mappings` table
          -- takes one key per action, so the second binding is set here.
          -- Up and Down need no mapping: they are ordinary cursor movement.
          vim.keymap.set("n", "<Right>", function()
            require("mini.files").go_in({ close_on_file = true })
          end, { buffer = args.data.buf_id, desc = "Go in (open file and close)" })

          vim.keymap.set("n", "<Left>", function()
            require("mini.files").go_out()
          end, { buffer = args.data.buf_id, desc = "Go out" })

          -- Enter opens, which is what most people try first
          vim.keymap.set("n", "<CR>", function()
            require("mini.files").go_in({ close_on_file = true })
          end, { buffer = args.data.buf_id, desc = "Open" })
        end,
      })

      -- Render images in the preview pane.
      --
      -- mini.files previews a file by reading it as text, so anything binary
      -- shows as "-Non-text-file----". Where images can actually be drawn,
      -- replace that with the real image.
      --
      -- MiniFilesBufferUpdate is the documented hook for this ("can be used for
      -- integrations to set useful extmarks") and fires whenever a path buffer
      -- gets new content, which includes each preview change.
      --
      -- The gate is util.graphics, NOT Snacks.image.supports_terminal(). Inside
      -- herdr that check returns true while graphics do not actually arrive, so
      -- using it alone replaced the placeholder with a blank pane.
      local graphics = require("util.graphics")

      local function preview_image(buf_id, win_id)
        if not buf_id or not vim.api.nvim_buf_is_valid(buf_id) then
          return
        end
        if not graphics.supported() then
          return
        end

        -- mini.files names buffers minifiles://<buf_id>/<path>
        local path = vim.api.nvim_buf_get_name(buf_id):match("^minifiles://%d+/(.*)$")
        if not path or path == "" then
          return
        end
        if not Snacks.image.supports_file(path) then
          return
        end
        local stat = vim.uv.fs_stat(path)
        if not stat or stat.type ~= "file" then
          return
        end

        local height = win_id and vim.api.nvim_win_is_valid(win_id) and vim.api.nvim_win_get_height(win_id)
          or 20
        local width = win_id and vim.api.nvim_win_is_valid(win_id) and vim.api.nvim_win_get_width(win_id)
          or 40

        -- Clear the placeholder text and reserve blank rows to draw over
        local blank = {}
        for _ = 1, height do
          table.insert(blank, "")
        end
        local modifiable = vim.bo[buf_id].modifiable
        vim.bo[buf_id].modifiable = true
        pcall(vim.api.nvim_buf_set_lines, buf_id, 0, -1, false, blank)
        vim.bo[buf_id].modifiable = modifiable

        Snacks.image.placement.clean(buf_id)
        pcall(Snacks.image.placement.new, buf_id, path, {
          pos = { 1, 0 },
          width = width,
          auto_resize = true,
        })
      end

      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "MiniFilesBufferUpdate",
        callback = function(args)
          preview_image(args.data.buf_id, args.data.win_id)
        end,
      })

      -- Keep LSP informed when files are renamed through the explorer, so
      -- imports get updated instead of silently breaking.
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "MiniFilesActionRename",
        callback = function(args)
          local ok, snacks = pcall(require, "snacks")
          if ok then
            snacks.rename.on_rename_file(args.data.from, args.data.to)
            return
          end
          -- No snacks in this config, so notify the servers directly.
          local clients = vim.lsp.get_clients()
          for _, client in ipairs(clients) do
            if client:supports_method("workspace/willRenameFiles") then
              client:request("workspace/willRenameFiles", {
                files = {
                  {
                    oldUri = vim.uri_from_fname(args.data.from),
                    newUri = vim.uri_from_fname(args.data.to),
                  },
                },
              }, function(_, result)
                if result then
                  vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)
                end
              end)
            end
          end
        end,
      })
    end,
  },
}
