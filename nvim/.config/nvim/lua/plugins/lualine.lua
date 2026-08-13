-- Statusline.
--
-- 0.12 ships a competent default statusline (it shows vim.diagnostic.status()
-- and vim.ui.progress_status()), so this is preference. What lualine buys is a
-- consistent layout and room for state that is otherwise invisible: an active
-- macro recording, a pending plugin update, the search hit count, the size of a
-- visual selection.
--
-- Icons come from mini.icons through its nvim-web-devicons shim, set up eagerly
-- in plugins/icons.lua. Without that loaded first there are no filetype icons.
--
-- Colours are gruvbox values, matching the palettes already hardcoded in
-- plugins/telescope.lua and plugins/snacks.lua.

local colors = {
  red = "#fb4934",
  green = "#b8bb26",
  yellow = "#fabd2f",
  blue = "#83a598",
  grey = "#928374",
}

-- Visible only while a macro is recording. Nothing else in the UI says this, and
-- noticing a stray `q` ten keystrokes later is its own punishment.
local macro = {
  function()
    return "  @" .. vim.fn.reg_recording()
  end,
  cond = function()
    return vim.fn.reg_recording() ~= ""
  end,
  color = { fg = colors.red, gui = "bold" },
}

-- Pending plugin updates, straight from lazy.
local lazy_updates = {
  function()
    return require("lazy.status").updates()
  end,
  cond = function()
    return package.loaded.lazy ~= nil and require("lazy.status").has_updates()
  end,
  color = { fg = colors.yellow },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          -- Explicit gruvbox_dark, NOT "auto".
          --
          -- gruvbox runs with transparent_mode = true, so "auto" derived a theme
          -- in which every section was fg=NONE bg=NONE: no coloured mode
          -- indicator, and powerline separators invisible because they are drawn
          -- from the contrast between two section backgrounds. The bar is now
          -- opaque while the buffer background stays transparent, which is the
          -- usual arrangement.
          theme = "gruvbox_dark",
          -- One bar for the whole window, matching laststatus = 3 in options.lua
          globalstatus = true,
          -- Powerline separators, written as explicit UTF-8 byte escapes.
          --
          -- Not as literal glyphs: pasted Nerd Font characters get silently
          -- stripped by some editors and tooling, which leaves the strings empty
          -- and the separators simply absent — exactly what happened here first
          -- time. The escapes are immune to that and say which codepoint they are.
          --
          -- U+E0B0  right-pointing solid    U+E0B2  left-pointing solid
          -- U+E0B1  right-pointing thin     U+E0B3  left-pointing thin
          section_separators = { left = "\238\130\176", right = "\238\130\178" },
          component_separators = { left = "\238\130\177", right = "\238\130\179" },
          disabled_filetypes = {
            statusline = { "snacks_dashboard", "minifiles" },
          },
        },
        sections = {
          -- First letter only: the colour already says which mode it is, so the
          -- whole word is redundant width.
          lualine_a = {
            {
              "mode",
              fmt = function(m)
                return m:sub(1, 1)
              end,
            },
          },

          lualine_b = {
            { "branch", icon = "" },
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
              diff_color = {
                added = { fg = colors.green },
                modified = { fg = colors.yellow },
                removed = { fg = colors.red },
              },
            },
          },

          lualine_c = {
            -- path = 1 is relative to the cwd, the only variant that tells you
            -- anything in a monorepo.
            {
              "filename",
              path = 1,
              shorting_target = 40,
              symbols = { modified = "  ", readonly = "  ", unnamed = "[No Name]" },
            },
            macro,
            -- Both of these appear only when relevant, so they cost no width at
            -- rest: the search hit count while searching, and how much is
            -- selected in visual mode.
            { "searchcount", maxcount = 999, timeout = 250 },
            { "selectioncount" },
          },

          lualine_x = {
            lazy_updates,
            -- LSP progress with a spinner. 0.12's default statusline shows
            -- vim.ui.progress_status(), which lualine replaced, so this puts the
            -- feedback back. It is what appears during the slow part of a large
            -- TypeScript project: "Analyzing ... and its dependencies".
            --
            -- No separate "attached clients" component: this already names the
            -- servers, and running both printed "vtsls | vtsls".
            {
              "lsp_status",
              icon = "",
              symbols = {
                spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                done = "",
                separator = " ",
              },
              color = { fg = colors.blue },
            },
            {
              "diagnostics",
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
            },
            -- Icon only: the extension is already in the filename.
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 1 } },
          },

          lualine_y = { { "progress", padding = { left = 1, right = 1 } } },
          lualine_z = { { "location", padding = { left = 1, right = 1 } } },
        },
        extensions = { "lazy", "mason", "quickfix", "man" },
      }
    end,
    config = function(_, opts)
      require("lualine").setup(opts)

      -- Without this the macro component does not appear until something else
      -- forces a redraw, which is usually after you have stopped recording.
      vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
        group = vim.api.nvim_create_augroup("user_lualine_macro", { clear = true }),
        callback = function()
          -- RecordingLeave fires before reg_recording() clears, hence the defer.
          vim.defer_fn(function()
            require("lualine").refresh({ place = { "statusline" } })
          end, 10)
        end,
      })
    end,
  },
}
