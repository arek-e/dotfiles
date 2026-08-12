-- Vanilla editor options. No plugin may be referenced from this file.

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes" -- reserve the column so text does not jump
opt.cursorline = true

-- Indentation: 2 spaces, treesitter and the LSP override per-language
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true
opt.breakindent = true

-- Wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true -- an uppercase letter in the pattern re-enables case
opt.hlsearch = true
opt.incsearch = true

-- Splits open where the eye already is
opt.splitright = true
opt.splitbelow = true

-- Scrolling context
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Persistent undo instead of swap files
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undolevels = 10000

-- Responsiveness. timeoutlen also gates how fast which-key appears.
opt.updatetime = 200
opt.timeoutlen = 300

-- Completion: never auto-select, always show the menu
opt.completeopt = { "menu", "menuone", "noselect" }

-- System clipboard
opt.clipboard = "unnamedplus"

-- Treat foo-bar as one word
opt.iskeyword:append("-")

-- Misc
opt.termguicolors = true
opt.mouse = "a"
opt.confirm = true -- prompt instead of failing on :q with unsaved changes
opt.laststatus = 3 -- one global statusline, not one per split
opt.showmode = false
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Folds: provided by treesitter, opened by default so nothing is hidden
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
