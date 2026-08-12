-- Keymaps that do not depend on any plugin.
-- Plugin keymaps belong in that plugin's own spec, under the `keys` field, so
-- lazy.nvim can use them as load triggers.

local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Save from any mode
map({ "n", "i", "v", "s" }, "<C-s>", "<cmd>write<cr><esc>", { desc = "Write buffer" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window splits and resize
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split below" })
map("n", "<leader>\\", "<cmd>vsplit<cr>", { desc = "Split right" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Taller window" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Shorter window" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Narrower window" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Wider window" })

-- Buffers
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Wrapped lines: j/k move by screen line unless a count is given
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Keep the cursor centred while moving through the file
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down, centred" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up, centred" })
map("n", "n", "nzzzv", { desc = "Next match, centred" })
map("n", "N", "Nzzzv", { desc = "Previous match, centred" })
map("n", "J", "mzJ`z", { desc = "Join lines, keep cursor" })

-- Move lines and selections, reindenting as they go
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Indent without dropping the selection
map("v", "<", "<gv", { desc = "Outdent" })
map("v", ">", ">gv", { desc = "Indent" })

-- Paste over a selection without clobbering the register
map("v", "p", '"_dP', { desc = "Paste, keep register" })

-- Terminal mode: get back to normal mode
map("t", "<C-\\><C-n>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-q>", "<C-\\><C-n><cmd>close<cr>", { desc = "Close terminal" })

-- Diagnostics. ]d and [d are built in on 0.11, so only the extras go here.
map("n", "<leader>xe", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>xq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Show the cwd
map("n", "<leader>pw", function()
  vim.notify(vim.fn.getcwd(), vim.log.levels.INFO)
end, { desc = "Show cwd" })
