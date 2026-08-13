-- Two different answers to "where am I", both at the top of the window.
--
-- incline puts the filename in a small floating label in each window's top right
-- corner. That is strictly better than a filename in the statusline here, because
-- `laststatus = 3` means there is ONE statusline for the whole editor: with a
-- split, it can only ever name one of the buffers. incline is per window, so the
-- filename in lualine was removed in favour of it.
--
-- treesitter-context pins the enclosing scope to the top of the window, so deep
-- inside a function body you can still see its signature. This is the "where is
-- the cursor" question in the other sense: not which file, but which function.
--
-- Deliberately NOT dropbar or nvim-navic. Those put interactive breadcrumbs in
-- the winbar, and edgy already sets `winbar = true` for its own window titles, so
-- they would compete for the same line. incline floats instead, and
-- treesitter-context uses its own window.

return {
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
      local colors = {
        fg = "#ebdbb2",
        grey = "#928374",
        yellow = "#fabd2f",
        red = "#fb4934",
        bg = "#3c3836",
      }

      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 1, vertical = 0 },
          placement = { horizontal = "right", vertical = "top" },
          -- Below floats, so telescope, glance and code action previews are never
          -- covered by a filename label.
          zindex = 30,
          options = { signcolumn = "no", wrap = false },
        },
        render = function(props)
          local bufname = vim.api.nvim_buf_get_name(props.buf)
          local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"

          -- Icon from mini.icons, which also returns its highlight group, so the
          -- glyph keeps its language colour.
          local icon, icon_hl = " ", nil
          if _G.MiniIcons then
            local ok, glyph, hl = pcall(MiniIcons.get, "file", filename)
            if ok then
              icon, icon_hl = glyph, hl
            end
          end

          local parts = {
            { " " },
            { icon .. " ", group = icon_hl },
            { filename, gui = props.focused and "bold" or "None", guifg = props.focused and colors.fg or colors.grey },
          }

          if vim.bo[props.buf].modified then
            parts[#parts + 1] = { " ●", guifg = colors.yellow }
          end

          -- Per-window diagnostic counts, which the single global statusline
          -- cannot give you when a split has two different buffers open.
          for severity, sign in pairs({ ERROR = " ", WARN = " " }) do
            local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[severity] })
            if n > 0 then
              parts[#parts + 1] = {
                " " .. sign .. n,
                guifg = severity == "ERROR" and colors.red or colors.yellow,
              }
            end
          end

          parts[#parts + 1] = { " " }
          return parts
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    -- Needs only Neovim 0.9+ and talks to vim.treesitter directly, so it does
    -- not care that nvim-treesitter is on the `main` branch here.
    opts = {
      -- Three lines is enough for "which function, in which class" without
      -- eating the viewport.
      max_lines = 3,
      min_window_height = 20,
      -- Collapse a multi-line function signature to its first line
      multiline_threshold = 1,
      -- Drop the outermost scope first when it does not all fit
      trim_scope = "outer",
      -- Context for where the cursor is, not for the top visible line
      mode = "cursor",
      separator = "─",
      zindex = 20,
    },
    keys = {
      {
        "<leader>uc",
        function()
          require("treesitter-context").toggle()
        end,
        desc = "Toggle sticky context",
      },
      {
        "[c",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Jump to context start",
      },
    },
  },
}
