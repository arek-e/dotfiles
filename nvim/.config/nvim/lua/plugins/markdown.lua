-- Markdown rendering in the buffer: real headings, tables, code blocks,
-- checkboxes and callouts instead of raw syntax.
--
-- Needs the markdown and markdown_inline treesitter parsers, which
-- treesitter.lua already installs, and `conceallevel` above 0, which is set in
-- after/ftplugin/markdown.lua rather than globally.

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "md", "gitcommit" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.icons",
    },
    opts = {
      -- Render everything except the line the cursor is on, so editing shows
      -- you the raw syntax where you are working and the rendered form
      -- everywhere else.
      render_modes = { "n", "c", "t" },
      anti_conceal = { enabled = true },
      heading = {
        sign = false, -- the signcolumn is for diagnostics and git
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "block",
        left_pad = 0,
        right_pad = 2,
      },
      code = {
        sign = false,
        width = "block",
        left_pad = 1,
        right_pad = 1,
        border = "thin",
        language_pad = 1,
      },
      bullet = { icons = { "●", "○", "◆", "◇" } },
      checkbox = {
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰱒 " },
      },
      pipe_table = { style = "full", alignment_indicator = "─" },
      -- Callouts and links keep their defaults, which are already good
    },
  },
}
