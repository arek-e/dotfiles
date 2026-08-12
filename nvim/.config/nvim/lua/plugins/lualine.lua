-- Statusline.
--
-- 0.12 ships a decent default statusline (it shows vim.diagnostic.status() and
-- UI progress), so this is a preference rather than a gap. lualine buys a
-- consistent layout, git branch and diff counts, and one global bar.
--
-- Icons come from mini.icons via its nvim-web-devicons shim, set up in
-- explorer.lua, so there is no second icon plugin here.

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          theme = "auto", -- follows gruvbox
          -- One bar for the whole window, matching laststatus = 3 in options.lua
          globalstatus = true,
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "snacks_dashboard", "minifiles" },
          },
        },
        sections = {
          lualine_a = { { "mode", fmt = function(m) return m:sub(1, 1) end } },
          lualine_b = {
            { "branch", icon = "" },
            { "diff", symbols = { added = " ", modified = " ", removed = " " } },
          },
          lualine_c = {
            -- path = 1 is the path relative to the cwd, which is the only
            -- version that tells you anything in a monorepo
            { "filename", path = 1, shorting_target = 40 },
          },
          lualine_x = {
            {
              "diagnostics",
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
            },
            -- Which LSP servers are actually attached to this buffer
            {
              function()
                local names = {}
                for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                  table.insert(names, client.name)
                end
                return table.concat(names, " ")
              end,
              icon = " ",
              cond = function()
                return #vim.lsp.get_clients({ bufnr = 0 }) > 0
              end,
            },
            { "filetype", icon_only = false },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "lazy", "mason", "quickfix" },
      }
    end,
  },
}
