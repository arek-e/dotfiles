-- Autocommands. Plugin-specific autocmds belong in that plugin's spec.

local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Briefly highlight the yanked text.
-- vim.hl replaced the deprecated vim.highlight in 0.11.
autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Keep splits proportional when the terminal is resized
autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current)
  end,
})

-- Reopen a file where you left it
autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit", "gitrebase" }
    if vim.tbl_contains(exclude, vim.bo[event.buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- q closes throwaway windows, and they stay out of the buffer list
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "checkhealth",
    "help",
    "lspinfo",
    "man",
    "qf",
    "query",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close window" })
  end,
})

-- Create missing parent directories on save
autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    -- Skip URL-style buffer names such as oil:// or fugitive://
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Treat dotenv files as shell so they get highlighting
autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("dotenv_filetype"),
  pattern = { ".env", ".env.*", "*.env" },
  callback = function()
    vim.bo.filetype = "sh"
  end,
})

-- Terminal buffers: no line numbers, unlisted, q to close
autocmd("TermOpen", {
  group = augroup("terminal_settings"),
  callback = function(event)
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close terminal" })
  end,
})

-- Transparency, so the terminal background shows through.
-- Set vim.g.transparent = false before startup to keep the theme's own
-- background. The colours below are gruvbox-dark values.
if vim.g.transparent == nil then
  vim.g.transparent = true
end

autocmd("ColorScheme", {
  group = augroup("transparent_overrides"),
  callback = function()
    if not vim.g.transparent then
      return
    end
    for _, group in ipairs({
      "Normal",
      "NormalNC",
      "NormalFloat",
      "FloatBorder",
      "SignColumn",
      "EndOfBuffer",
      "StatusLine",
      "StatusLineNC",
      "TabLine",
      "TabLineFill",
      "TabLineSel",
    }) do
      vim.api.nvim_set_hl(0, group, { bg = "NONE" })
    end
    -- Keep the cursorline faintly visible against a transparent background
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3c3836" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fabd2f", bold = true, bg = "NONE" })
  end,
})
