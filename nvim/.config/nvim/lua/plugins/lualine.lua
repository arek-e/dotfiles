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
  -- gruvbox, bright variants: these are the saturated ones, and the muted
  -- neutrals are what made the shipped theme look flat.
  red = "#fb4934",
  green = "#b8bb26",
  yellow = "#fabd2f",
  blue = "#83a598",
  purple = "#d3869b",
  orange = "#fe8019",
  -- neutrals
  bg0 = "#1d2021", -- hard background, used as fg on the coloured mode block
  bg2 = "#3c3836",
  fg1 = "#ebdbb2",
  grey = "#928374",
}

-- A hand-written theme rather than a shipped one.
--
-- lualine's `gruvbox_dark` puts *grey* on normal mode and green on command,
-- which reads as flat and gets the convention backwards. This uses the
-- saturated gruvbox brights, with the mode block carrying the colour:
--
--   normal green, insert blue, visual orange, replace red, command yellow
--
-- Section c is transparent on purpose, so the coloured blocks read as floating
-- on the terminal background rather than sitting in a solid grey bar. That is
-- also consistent with the rest of the config, which runs gruvbox in
-- transparent_mode.
local function mode_block(color)
  return { fg = colors.bg0, bg = color, gui = "bold" }
end

local theme = {
  normal = {
    a = mode_block(colors.green),
    b = { fg = colors.fg1, bg = colors.bg2 },
    c = { fg = colors.grey, bg = "NONE" },
  },
  insert = { a = mode_block(colors.blue) },
  visual = { a = mode_block(colors.orange) },
  replace = { a = mode_block(colors.red) },
  command = { a = mode_block(colors.yellow) },
  terminal = { a = mode_block(colors.purple) },
  inactive = {
    a = { fg = colors.grey, bg = "NONE", gui = "bold" },
    b = { fg = colors.grey, bg = "NONE" },
    c = { fg = colors.grey, bg = "NONE" },
  },
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

-- Attached language servers, as icons.
--
-- Glyphs come from mini.icons rather than hardcoded codepoints, so they are
-- guaranteed to exist in the icon set actually installed. Servers map to the
-- closest thing mini.icons knows:
--
--   eslint / oxlint -> their config files, which icons.lua gives a linter glyph
--   tailwindcss     -> scss, purely because it is a distinct colour from css and
--                      so does not collapse into cssls when both are attached
--
-- Icons are deduplicated: eslint and oxlint can never both attach (each requires
-- its own config file), so a collision there is not possible.
local server_icon = {
  vtsls = { "filetype", "typescript" },
  eslint = { "file", ".eslintrc.js" },
  oxlint = { "file", ".oxlintrc.json" },
  tailwindcss = { "filetype", "scss" },
  cssls = { "filetype", "css" },
  html = { "filetype", "html" },
  jsonls = { "filetype", "json" },
  lua_ls = { "filetype", "lua" },
}

-- Progress is tracked from LspProgress rather than vim.lsp.status(), which
-- accumulates and was observed still returning a stale "Analyzing ..." string
-- long after the work had finished. Counting begin/end is exact.
local lsp_pending = 0

local lsp = {
  function()
    local icons, seen = {}, {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local spec = server_icon[client.name]
      local glyph
      if spec and _G.MiniIcons then
        local ok, g = pcall(MiniIcons.get, spec[1], spec[2])
        glyph = ok and g or nil
      end
      glyph = glyph or client.name
      if not seen[glyph] then
        seen[glyph] = true
        icons[#icons + 1] = glyph
      end
    end
    local prefix = ""
    if lsp_pending > 0 then
      local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      prefix = frames[math.floor(vim.uv.hrtime() / 8e7) % #frames + 1] .. " "
    end
    return prefix .. table.concat(icons, " ")
  end,
  cond = function()
    return #vim.lsp.get_clients({ bufnr = 0 }) > 0
  end,
}

-- Position that says something.
--
-- The defaults were `progress` and `location`: "94%" and "382:31". The
-- percentage duplicates what the line number already implies, and neither says
-- how long the file is. Line of total, plus column, answers "where am I and how
-- much is left" in one read.
local position = {
  function()
    return ("Ln %d/%d  Col %d"):format(vim.fn.line("."), vim.fn.line("$"), vim.fn.virtcol("."))
  end,
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
          -- The hand-written theme above, not "auto" and not a shipped one.
          -- "auto" derives from gruvbox's transparent_mode and yields sections
          -- that are entirely bg=NONE, which leaves the mode indicator
          -- uncoloured and powerline separators invisible, since a separator is
          -- drawn from the contrast between two section backgrounds.
          theme = theme,
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
            lsp,
            {
              "diagnostics",
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
            },
            -- No separate filetype icon. The LSP component above already shows a
            -- language glyph for anything with a server attached, and having both
            -- printed the TypeScript icon twice in a row. For a file with no
            -- server the extension in the filename is the indicator.
          },

          -- No `progress` percentage: `position` below carries the same
          -- information in a form that also says how long the file is.
          lualine_y = {},
          lualine_z = { position },
        },
        extensions = { "lazy", "mason", "quickfix", "man" },
      }
    end,
    config = function(_, opts)
      require("lualine").setup(opts)

      -- Count in-flight LSP progress tokens so the spinner is exact, and refresh
      -- so it animates rather than waiting for an unrelated redraw.
      vim.api.nvim_create_autocmd("LspProgress", {
        group = vim.api.nvim_create_augroup("user_lualine_lsp", { clear = true }),
        callback = function(ev)
          local kind = ev.data and ev.data.params and ev.data.params.value and ev.data.params.value.kind
          if kind == "begin" then
            lsp_pending = lsp_pending + 1
          elseif kind == "end" then
            lsp_pending = math.max(0, lsp_pending - 1)
          end
          require("lualine").refresh({ place = { "statusline" } })
        end,
      })

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
