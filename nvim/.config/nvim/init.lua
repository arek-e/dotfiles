-- Entry point.
--
-- Kept deliberately thin: leader keys must be set before lazy.nvim loads any
-- spec that defines a `<leader>` mapping, so they go here rather than in
-- options.lua.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
