-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Quick escape from insert mode
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Better up/down (handles wrapped lines)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window navigation is handled by vim-tmux-navigator
-- Ctrl+h/j/k/l will seamlessly navigate nvim splits AND tmux panes

-- Open tmux pane at current file's directory
map("n", "<leader>tp", function()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then
    dir = vim.fn.getcwd()
  end
  -- Open a new tmux pane (horizontal split) at the file's directory
  vim.fn.system(string.format("tmux split-window -h -c %s", vim.fn.shellescape(dir)))
end, { desc = "Tmux pane at file dir" })

map("n", "<leader>tP", function()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then
    dir = vim.fn.getcwd()
  end
  -- Open a new tmux pane (vertical split) at the file's directory
  vim.fn.system(string.format("tmux split-window -v -c %s", vim.fn.shellescape(dir)))
end, { desc = "Tmux pane (vertical) at file dir" })

map("n", "<leader>tw", function()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then
    dir = vim.fn.getcwd()
  end
  -- Open a new tmux window at the file's directory
  vim.fn.system(string.format("tmux new-window -c %s", vim.fn.shellescape(dir)))
end, { desc = "Tmux window at file dir" })

-- Quick save
map({ "n", "i", "v", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Clear search highlighting
map("n", "<Esc>", "<cmd>noh<cr><Esc>", { desc = "Clear search highlight" })

-- Better indenting (stay in visual mode)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines up/down
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Centered scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Oil file explorer
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory (Oil)" })

-- Harpoon quick access (also configured in harpoon plugin)
-- <leader>a to add, <leader>h to toggle menu, <leader>1-4 for quick access

-- Theme switcher
local themes = {
  { name = "catppuccin", variants = { "mocha", "macchiato", "frappe", "latte" } },
  { name = "tokyonight", variants = { "night", "storm", "moon", "day" } },
  { name = "kanagawa", variants = { "wave", "dragon", "lotus" } },
  { name = "rose-pine", variants = { "main", "moon", "dawn" } },
  { name = "nightfox", variants = { "nightfox", "dayfox", "dawnfox", "duskfox", "nordfox", "terafox", "carbonfox" } },
}

map("n", "<leader>uC", function()
  local items = {}
  for _, theme in ipairs(themes) do
    for _, variant in ipairs(theme.variants) do
      local colorscheme = theme.name == "nightfox" and variant or theme.name
      table.insert(items, {
        name = theme.name .. " (" .. variant .. ")",
        colorscheme = colorscheme,
        theme = theme.name,
        variant = variant,
      })
    end
  end

  vim.ui.select(items, {
    prompt = "Select Theme:",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      -- Set variant before colorscheme for themes that need it
      if choice.theme == "catppuccin" then
        require("catppuccin").setup({ flavour = choice.variant })
      elseif choice.theme == "tokyonight" then
        require("tokyonight").setup({ style = choice.variant })
      elseif choice.theme == "kanagawa" then
        require("kanagawa").setup({ theme = choice.variant })
      elseif choice.theme == "rose-pine" then
        require("rose-pine").setup({ variant = choice.variant })
      end
      vim.cmd.colorscheme(choice.colorscheme)
      vim.notify("Theme: " .. choice.name, vim.log.levels.INFO)
    end
  end)
end, { desc = "Change Colorscheme" })
