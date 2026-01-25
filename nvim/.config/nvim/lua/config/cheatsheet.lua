-- Cheatsheet - NvChad-style floating keybinding reference
-- Open with <leader>? or :Cheatsheet

local M = {}

local cheatsheet_data = {
  {
    name = "Navigation",
    color = "#7aa2f7",
    mappings = {
      { "<C-h/j/k/l>", "Navigate splits/tmux panes" },
      { "<leader>wf", "Toggle focus mode" },
      { "<S-h> / <S-l>", "Prev/next buffer" },
      { "<leader>,", "Switch buffer" },
      { "<leader>e", "Neo-tree explorer" },
    },
  },
  {
    name = "Harpoon",
    color = "#9ece6a",
    mappings = {
      { "<leader>a", "Add file to harpoon" },
      { "<leader>h", "Open harpoon menu" },
      { "<leader>1-5", "Jump to file 1-5" },
      { "[H / ]H", "Prev/next harpoon file" },
    },
  },
  {
    name = "File Explorer",
    color = "#e0af68",
    mappings = {
      { "-", "Open parent dir (Oil)" },
      { "<leader>o", "Oil explorer" },
      { "<CR>", "Open file (in Oil)" },
      { "<C-v> / <C-x>", "Open vsplit/split" },
      { "g.", "Toggle hidden files" },
    },
  },
  {
    name = "Search (Telescope)",
    color = "#bb9af7",
    mappings = {
      { "<leader>ff", "Find files" },
      { "<leader>fg", "Find git files" },
      { "<leader>fr", "Recent files" },
      { "<leader>sg", "Live grep" },
      { "<leader>sw", "Search word" },
      { "<leader>st", "Search TODOs" },
      { "<leader>/", "Grep in project" },
    },
  },
  {
    name = "Search & Replace",
    color = "#f7768e",
    mappings = {
      { "<leader>sr", "Search & replace (Grug)" },
      { "<leader>sR", "S&R current file" },
      { "<leader>sw", "Search word under cursor" },
    },
  },
  {
    name = "Code Editing",
    color = "#7dcfff",
    mappings = {
      { "<leader>j", "Toggle split/join" },
      { "<C-a> / <C-x>", "Increment/decrement" },
      { "w / e / b", "Word motion (camelCase)" },
      { "zR / zM", "Open/close all folds" },
      { "K", "Peek fold or LSP hover" },
    },
  },
  {
    name = "Git",
    color = "#9ece6a",
    mappings = {
      { "<leader>gg", "LazyGit" },
      { "]h / [h", "Next/prev hunk" },
      { "<leader>ghs", "Stage hunk" },
      { "<leader>ghr", "Reset hunk" },
      { "<leader>ghp", "Preview hunk" },
      { "<leader>ghb", "Blame line" },
      { "<leader>gd", "Diff view" },
      { "<leader>gm", "Diff vs main" },
      { "<leader>gf", "File history" },
    },
  },
  {
    name = "Diagnostics",
    color = "#f7768e",
    mappings = {
      { "<leader>xx", "Diagnostics (Trouble)" },
      { "<leader>xX", "Buffer diagnostics" },
      { "<leader>xt", "TODOs (Trouble)" },
      { "]t / [t", "Next/prev TODO" },
      { "]d / [d", "Next/prev diagnostic" },
    },
  },
  {
    name = "LSP",
    color = "#7aa2f7",
    mappings = {
      { "gd", "Go to definition" },
      { "gr", "Go to references" },
      { "gI", "Go to implementation" },
      { "<leader>ca", "Code action" },
      { "<leader>cr", "Rename symbol" },
      { "<leader>cf", "Format" },
    },
  },
  {
    name = "AI (Claude)",
    color = "#bb9af7",
    mappings = {
      { "<C-,>", "Toggle Claude Code" },
      { "<leader>ac", "Open Claude Code" },
      { "<leader>aC", "Claude continue" },
      { "<leader>aR", "Claude resume" },
    },
  },
  {
    name = "Tasks (Overseer)",
    color = "#e0af68",
    mappings = {
      { "<leader>ot", "Toggle Overseer" },
      { "<leader>or", "Run task" },
      { "<leader>oq", "Quick action" },
      { "<leader>ob", "Build" },
    },
  },
  {
    name = "Sessions",
    color = "#7dcfff",
    mappings = {
      { "<leader>qs", "Restore session" },
      { "<leader>qS", "Select session" },
      { "<leader>ql", "Restore last session" },
    },
  },
  {
    name = "UI Toggles",
    color = "#9ece6a",
    mappings = {
      { "<leader>uC", "Change colorscheme" },
      { "<leader>z", "Zen mode" },
      { "<leader>Z", "Zen zoom" },
      { "<leader>un", "Notification history" },
    },
  },
  {
    name = "Tmux",
    color = "#7aa2f7",
    mappings = {
      { "<leader>tp", "Tmux pane (file dir)" },
      { "<leader>tP", "Tmux pane (project)" },
      { "<leader>tw", "Tmux window (file dir)" },
    },
  },
  {
    name = "General",
    color = "#c0caf5",
    mappings = {
      { "jk", "Exit insert mode" },
      { "<C-s>", "Save file" },
      { "<A-j> / <A-k>", "Move line down/up" },
      { "q", "Close help/qf windows" },
      { "<leader>?", "This cheatsheet" },
    },
  },
}

-- Create the cheatsheet content
local function create_content()
  local lines = {}
  local highlights = {}
  local line_num = 0

  -- Header
  table.insert(lines, "")
  line_num = line_num + 1
  local header = "  ╭─────────────────────────────────────────────────────────────────────────────────╮"
  table.insert(lines, header)
  line_num = line_num + 1
  table.insert(highlights, { line = line_num, col = 0, end_col = #header, hl = "CheatsheetBorder" })

  local title = "  │                            NEOVIM KEYBINDINGS                                   │"
  table.insert(lines, title)
  line_num = line_num + 1
  table.insert(highlights, { line = line_num, col = 0, end_col = #title, hl = "CheatsheetTitle" })

  local subheader = "  │                              <leader> = Space                                   │"
  table.insert(lines, subheader)
  line_num = line_num + 1
  table.insert(highlights, { line = line_num, col = 0, end_col = #subheader, hl = "CheatsheetSubtitle" })

  local border_bottom = "  ╰─────────────────────────────────────────────────────────────────────────────────╯"
  table.insert(lines, border_bottom)
  line_num = line_num + 1
  table.insert(highlights, { line = line_num, col = 0, end_col = #border_bottom, hl = "CheatsheetBorder" })

  table.insert(lines, "")
  line_num = line_num + 1

  -- Render sections in two columns
  local col_width = 42
  local sections_per_col = math.ceil(#cheatsheet_data / 2)

  for i = 1, sections_per_col do
    local left_section = cheatsheet_data[i]
    local right_section = cheatsheet_data[i + sections_per_col]

    if left_section then
      -- Section headers
      local left_header = string.format("  ┌─ %s ", left_section.name)
      left_header = left_header .. string.rep("─", col_width - #left_header + 2)
      local right_header = ""
      if right_section then
        right_header = string.format("  ┌─ %s ", right_section.name)
        right_header = right_header .. string.rep("─", col_width - #right_header + 2)
      end

      table.insert(lines, left_header .. right_header)
      line_num = line_num + 1
      table.insert(highlights, { line = line_num, col = 0, end_col = #left_header, hl = "Cheatsheet" .. i })
      if right_section then
        table.insert(highlights, { line = line_num, col = #left_header, end_col = #left_header + #right_header, hl = "Cheatsheet" .. (i + sections_per_col) })
      end

      -- Find max mappings in either section
      local max_mappings = #left_section.mappings
      if right_section then
        max_mappings = math.max(max_mappings, #right_section.mappings)
      end

      for j = 1, max_mappings do
        local left_mapping = left_section.mappings[j]
        local right_mapping = right_section and right_section.mappings[j]

        local left_line = ""
        if left_mapping then
          local key_part = string.format("  │ %-18s", left_mapping[1])
          local desc_part = string.format("%-22s", left_mapping[2])
          left_line = key_part .. desc_part
        else
          left_line = string.rep(" ", col_width)
        end

        local right_line = ""
        if right_mapping then
          local key_part = string.format("  │ %-18s", right_mapping[1])
          local desc_part = string.format("%-22s", right_mapping[2])
          right_line = key_part .. desc_part
        end

        table.insert(lines, left_line .. right_line)
        line_num = line_num + 1

        -- Highlight keys
        if left_mapping then
          table.insert(highlights, { line = line_num, col = 4, end_col = 22, hl = "CheatsheetKey" })
          table.insert(highlights, { line = line_num, col = 22, end_col = col_width, hl = "CheatsheetDesc" })
        end
        if right_mapping then
          table.insert(highlights, { line = line_num, col = col_width + 4, end_col = col_width + 22, hl = "CheatsheetKey" })
          table.insert(highlights, { line = line_num, col = col_width + 22, end_col = col_width * 2, hl = "CheatsheetDesc" })
        end
      end

      table.insert(lines, "")
      line_num = line_num + 1
    end
  end

  -- Footer
  table.insert(lines, "  Press q or <Esc> to close")
  line_num = line_num + 1
  table.insert(highlights, { line = line_num, col = 0, end_col = 30, hl = "CheatsheetFooter" })
  table.insert(lines, "")

  return lines, highlights
end

-- Set up highlight groups
local function setup_highlights()
  vim.api.nvim_set_hl(0, "CheatsheetBorder", { fg = "#3b4261" })
  vim.api.nvim_set_hl(0, "CheatsheetTitle", { fg = "#7aa2f7", bold = true })
  vim.api.nvim_set_hl(0, "CheatsheetSubtitle", { fg = "#565f89", italic = true })
  vim.api.nvim_set_hl(0, "CheatsheetKey", { fg = "#9ece6a", bold = true })
  vim.api.nvim_set_hl(0, "CheatsheetDesc", { fg = "#c0caf5" })
  vim.api.nvim_set_hl(0, "CheatsheetFooter", { fg = "#565f89", italic = true })

  -- Section colors
  for i, section in ipairs(cheatsheet_data) do
    vim.api.nvim_set_hl(0, "Cheatsheet" .. i, { fg = section.color, bold = true })
  end
end

-- Open the cheatsheet in a floating window
function M.open()
  setup_highlights()

  local lines, highlights = create_content()

  -- Calculate window size
  local width = 88
  local height = #lines
  local max_height = math.floor(vim.o.lines * 0.85)
  if height > max_height then
    height = max_height
  end

  -- Center the window
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "cheatsheet"

  -- Apply highlights
  local ns = vim.api.nvim_create_namespace("cheatsheet")
  for _, hl in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(buf, ns, hl.hl, hl.line - 1, hl.col, hl.end_col)
  end

  -- Create window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Cheatsheet ",
    title_pos = "center",
  })

  -- Window options
  vim.wo[win].winblend = 0
  vim.wo[win].cursorline = false

  -- Close on q or Escape
  local close = function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<leader>?", close, { buffer = buf, nowait = true })

  -- Close on buffer leave
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    once = true,
    callback = close,
  })
end

-- Create user command
vim.api.nvim_create_user_command("Cheatsheet", M.open, { desc = "Open keybindings cheatsheet" })

return M
