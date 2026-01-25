-- Cheatsheet - Clean floating keybinding reference
-- Open with <leader>? or :Cheatsheet

local M = {}

local sections = {
  {
    title = "Navigation",
    icon = "󰆧",
    color = "#7aa2f7",
    keys = {
      { "C-h/j/k/l", "Navigate splits/tmux" },
      { "S-h / S-l", "Prev/next buffer" },
      { "<leader>,", "Switch buffer" },
      { "<leader>e", "File explorer" },
      { "<leader>wf", "Toggle focus" },
    },
  },
  {
    title = "Harpoon",
    icon = "󱡀",
    color = "#9ece6a",
    keys = {
      { "<leader>A", "Add file" },
      { "<leader>h", "Open menu" },
      { "<leader>1-5", "Jump to file" },
      { "[H / ]H", "Prev/next file" },
    },
  },
  {
    title = "Files",
    icon = "",
    color = "#e0af68",
    keys = {
      { "-", "Parent dir (Oil)" },
      { "<leader>o", "Oil explorer" },
      { "<leader>ff", "Find files" },
      { "<leader>fr", "Recent files" },
    },
  },
  {
    title = "Search",
    icon = "",
    color = "#bb9af7",
    keys = {
      { "<leader>sg", "Live grep" },
      { "<leader>sw", "Search word" },
      { "<leader>st", "Search TODOs" },
      { "<leader>/", "Grep project" },
    },
  },
  {
    title = "Replace",
    icon = "󰛔",
    color = "#f7768e",
    keys = {
      { "<leader>sr", "Search & replace" },
      { "<leader>sR", "Replace in file" },
    },
  },
  {
    title = "Code",
    icon = "",
    color = "#7dcfff",
    keys = {
      { "<leader>j", "Split/join" },
      { "C-a / C-x", "Inc/decrement" },
      { "zR / zM", "Open/close folds" },
      { "K", "Hover/peek fold" },
    },
  },
  {
    title = "Git",
    icon = "",
    color = "#9ece6a",
    keys = {
      { "<leader>gg", "LazyGit" },
      { "]h / [h", "Next/prev hunk" },
      { "<leader>ghs", "Stage hunk" },
      { "<leader>ghp", "Preview hunk" },
      { "<leader>gd", "Diff view" },
      { "<leader>gm", "Diff vs main" },
    },
  },
  {
    title = "LSP",
    icon = "",
    color = "#7aa2f7",
    keys = {
      { "gd", "Definition" },
      { "gr", "References" },
      { "gI", "Implementation" },
      { "<leader>ca", "Code action" },
      { "<leader>cr", "Rename" },
    },
  },
  {
    title = "Diagnostics",
    icon = "",
    color = "#f7768e",
    keys = {
      { "<leader>xx", "Diagnostics" },
      { "<leader>xt", "TODOs" },
      { "]d / [d", "Next/prev diag" },
      { "]t / [t", "Next/prev TODO" },
    },
  },
  {
    title = "AI",
    icon = "󰚩",
    color = "#bb9af7",
    keys = {
      { "C-,", "Toggle Claude" },
      { "<leader>ac", "Claude Code" },
      { "<leader>aC", "Continue" },
    },
  },
  {
    title = "Tasks",
    icon = "",
    color = "#e0af68",
    keys = {
      { "<leader>ot", "Toggle tasks" },
      { "<leader>or", "Run task" },
      { "<leader>ob", "Build" },
    },
  },
  {
    title = "Sessions",
    icon = "󰆓",
    color = "#7dcfff",
    keys = {
      { "<leader>qs", "Restore" },
      { "<leader>qS", "Select" },
      { "<leader>ql", "Last session" },
    },
  },
  {
    title = "UI",
    icon = "󰔎",
    color = "#9ece6a",
    keys = {
      { "<leader>uC", "Colorscheme" },
      { "<leader>z", "Zen mode" },
      { "<leader>un", "Notifications" },
    },
  },
  {
    title = "General",
    icon = "󰌌",
    color = "#c0caf5",
    keys = {
      { "jk", "Exit insert" },
      { "C-s", "Save" },
      { "A-j / A-k", "Move line" },
      { "<leader>?", "This help" },
    },
  },
}

local function setup_highlights()
  vim.api.nvim_set_hl(0, "CheatHeader", { fg = "#7aa2f7", bold = true })
  vim.api.nvim_set_hl(0, "CheatSubheader", { fg = "#565f89", italic = true })
  vim.api.nvim_set_hl(0, "CheatKey", { fg = "#9ece6a", bold = true })
  vim.api.nvim_set_hl(0, "CheatDesc", { fg = "#a9b1d6" })
  vim.api.nvim_set_hl(0, "CheatSep", { fg = "#3b4261" })
  vim.api.nvim_set_hl(0, "CheatFooter", { fg = "#565f89", italic = true })

  for i, section in ipairs(sections) do
    vim.api.nvim_set_hl(0, "CheatSection" .. i, { fg = section.color, bold = true })
  end
end

local function create_content()
  local lines = {}
  local highlights = {}
  local line_num = 0

  -- Header
  table.insert(lines, "")
  line_num = line_num + 1

  local title = "    NEOVIM KEYBINDINGS"
  table.insert(lines, title)
  line_num = line_num + 1
  table.insert(highlights, { line = line_num, col = 0, end_col = #title, hl = "CheatHeader" })

  local subtitle = "    <leader> = Space"
  table.insert(lines, subtitle)
  line_num = line_num + 1
  table.insert(highlights, { line = line_num, col = 0, end_col = #subtitle, hl = "CheatSubheader" })

  table.insert(lines, "")
  line_num = line_num + 1

  -- Calculate columns
  local col_width = 38
  local num_cols = 2
  local sections_per_col = math.ceil(#sections / num_cols)

  -- Build rows
  for row = 1, sections_per_col do
    local left_idx = row
    local right_idx = row + sections_per_col

    local left_section = sections[left_idx]
    local right_section = sections[right_idx]

    -- Section headers
    if left_section then
      local left_header = string.format("  %s %s", left_section.icon, left_section.title)
      local right_header = ""
      if right_section then
        right_header = string.format("  %s %s", right_section.icon, right_section.title)
      end

      local padding = col_width - vim.fn.strdisplaywidth(left_header)
      local line = left_header .. string.rep(" ", padding) .. right_header
      table.insert(lines, line)
      line_num = line_num + 1
      table.insert(highlights, { line = line_num, col = 0, end_col = vim.fn.strdisplaywidth(left_header), hl = "CheatSection" .. left_idx })
      if right_section then
        table.insert(highlights, { line = line_num, col = col_width, end_col = col_width + vim.fn.strdisplaywidth(right_header), hl = "CheatSection" .. right_idx })
      end

      -- Find max keys
      local max_keys = #left_section.keys
      if right_section then
        max_keys = math.max(max_keys, #right_section.keys)
      end

      for k = 1, max_keys do
        local left_key = left_section.keys[k]
        local right_key = right_section and right_section.keys[k]

        local left_str = ""
        local left_key_end = 0
        if left_key then
          left_str = string.format("    %-14s %s", left_key[1], left_key[2])
          left_key_end = 4 + 14 -- "    " + key width
        end

        local right_str = ""
        if right_key then
          right_str = string.format("    %-14s %s", right_key[1], right_key[2])
        end

        local left_pad = col_width - vim.fn.strdisplaywidth(left_str)
        if left_pad < 0 then left_pad = 0 end
        local full_line = left_str .. string.rep(" ", left_pad) .. right_str

        table.insert(lines, full_line)
        line_num = line_num + 1

        if left_key then
          table.insert(highlights, { line = line_num, col = 4, end_col = left_key_end, hl = "CheatKey" })
          table.insert(highlights, { line = line_num, col = left_key_end, end_col = col_width, hl = "CheatDesc" })
        end
        if right_key then
          table.insert(highlights, { line = line_num, col = col_width + 4, end_col = col_width + 4 + 14, hl = "CheatKey" })
          table.insert(highlights, { line = line_num, col = col_width + 4 + 14, end_col = #full_line, hl = "CheatDesc" })
        end
      end

      table.insert(lines, "")
      line_num = line_num + 1
    end
  end

  -- Footer
  local footer = "  Press q or <Esc> to close"
  table.insert(lines, footer)
  line_num = line_num + 1
  table.insert(highlights, { line = line_num, col = 0, end_col = #footer, hl = "CheatFooter" })

  table.insert(lines, "")

  return lines, highlights
end

function M.open()
  setup_highlights()

  local lines, highlights = create_content()

  -- Calculate window size
  local width = 78
  local height = #lines
  local max_height = math.floor(vim.o.lines * 0.9)
  if height > max_height then
    height = max_height
  end

  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "cheatsheet"

  local ns = vim.api.nvim_create_namespace("cheatsheet")
  for _, hl in ipairs(highlights) do
    pcall(vim.api.nvim_buf_add_highlight, buf, ns, hl.hl, hl.line - 1, hl.col, hl.end_col)
  end

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " 󰌌 Cheatsheet ",
    title_pos = "center",
  })

  vim.wo[win].winblend = 0
  vim.wo[win].cursorline = false
  vim.wo[win].wrap = false

  local close = function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<leader>?", close, { buffer = buf, nowait = true })

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    once = true,
    callback = close,
  })
end

vim.api.nvim_create_user_command("Cheatsheet", M.open, { desc = "Open keybindings cheatsheet" })

return M
