-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Line wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard - use system clipboard
opt.clipboard = "unnamedplus"

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Consider - as part of a word
opt.iskeyword:append("-")

-- Disable swap files (you're using git anyway)
opt.swapfile = false

-- Persistent undo
opt.undofile = true
opt.undolevels = 10000

-- Update time for faster completion
opt.updatetime = 200
opt.timeoutlen = 300

-- Better completion experience
opt.completeopt = "menu,menuone,noselect"

-- Scroll offset
opt.scrolloff = 8
opt.sidescrolloff = 8
