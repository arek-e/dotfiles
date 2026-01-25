return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local logo = [[
      ██████╗ ███████╗██╗   ██╗███████╗███████╗████████╗ ██████╗██╗  ██╗
      ██╔══██╗██╔════╝██║   ██║██╔════╝██╔════╝╚══██╔══╝██╔════╝██║  ██║
      ██║  ██║█████╗  ██║   ██║█████╗  █████╗     ██║   ██║     ███████║
      ██║  ██║██╔══╝  ╚██╗ ██╔╝██╔══╝  ██╔══╝     ██║   ██║     ██╔══██║
      ██████╔╝███████╗ ╚████╔╝ ██║     ███████╗   ██║   ╚██████╗██║  ██║
      ╚═════╝ ╚══════╝  ╚═══╝  ╚═╝     ╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝
      ]]

      logo = string.rep("\n", 2) .. logo .. "\n\n"

      -- Read devfetch cache
      local cache_dir = vim.fn.expand("~/.cache/devfetch")

      local function read_cache(name)
        local file = io.open(cache_dir .. "/" .. name, "r")
        if file then
          local content = file:read("*all")
          file:close()
          return content
        end
        return nil
      end

      local function get_github_stats()
        local prs_data = read_cache("prs_data")
        local merged_data = read_cache("merged_data")

        local open_count = 0
        local merged_count = 0

        if prs_data then
          local ok, decoded = pcall(vim.json.decode, prs_data)
          if ok and decoded then
            open_count = #decoded
          end
        end

        if merged_data then
          local ok, decoded = pcall(vim.json.decode, merged_data)
          if ok and decoded then
            merged_count = #decoded
          end
        end

        return open_count, merged_count
      end

      local function get_open_prs()
        local prs_data = read_cache("prs_data")
        local prs = {}

        if prs_data then
          local ok, decoded = pcall(vim.json.decode, prs_data)
          if ok and decoded then
            for i = 1, math.min(3, #decoded) do
              local pr = decoded[i]
              if pr and pr.repository and pr.title then
                local repo = pr.repository.name or pr.repository.nameWithOwner or "unknown"
                local title = pr.title
                if #title > 40 then
                  title = title:sub(1, 37) .. "..."
                end
                table.insert(prs, repo .. ": " .. title)
              end
            end
          end
        end

        return prs
      end

      local function get_linear_issues()
        local linear_data = read_cache("linear")
        local issues = {}

        if linear_data then
          local ok, decoded = pcall(vim.json.decode, linear_data)
          if ok and decoded and decoded.data and decoded.data.viewer then
            local nodes = decoded.data.viewer.assignedIssues and decoded.data.viewer.assignedIssues.nodes
            if nodes then
              for i = 1, math.min(5, #nodes) do
                local issue = nodes[i]
                if issue then
                  local state = issue.state and issue.state.name or "?"
                  local id = issue.identifier or "?"
                  local title = issue.title or ""
                  if #title > 35 then
                    title = title:sub(1, 32) .. "..."
                  end
                  -- State abbreviations
                  local state_abbr = {
                    ["In Progress"] = "PROG",
                    ["In Review"] = "REVW",
                    ["Todo"] = "TODO",
                    ["Backlog"] = "BKLG",
                  }
                  local short_state = state_abbr[state] or state:sub(1, 4):upper()
                  table.insert(issues, string.format("[%s] %s: %s", short_state, id, title))
                end
              end
            end
          end
        end

        return issues
      end

      local function get_review_requests()
        local reviews = read_cache("reviews")
        local items = {}

        if reviews and reviews ~= "" then
          for line in reviews:gmatch("[^\n]+") do
            if #line > 45 then
              line = line:sub(1, 42) .. "..."
            end
            table.insert(items, line)
          end
        end

        return items
      end

      -- Build center content
      local open_prs, merged_prs = get_github_stats()
      local prs = get_open_prs()
      local linear = get_linear_issues()
      local reviews = get_review_requests()

      local opts = {
        theme = "doom",
        hide = {
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          center = {
            { action = "Telescope find_files", desc = " Find File", icon = " ", key = "f" },
            { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
            { action = "Telescope oldfiles", desc = " Recent Files", icon = " ", key = "r" },
            { action = "Telescope live_grep", desc = " Find Text", icon = " ", key = "g" },
            { action = "e $MYVIMRC", desc = " Config", icon = " ", key = "c" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            { action = "qa", desc = " Quit", icon = " ", key = "q" },
          },
          footer = function()
            local lines = {}

            -- Divider
            table.insert(lines, "")
            table.insert(lines, "─────────────────────────────────────────────")
            table.insert(lines, "")

            -- GitHub Stats
            table.insert(lines, string.format("  GitHub: %d open PRs • %d merged", open_prs, merged_prs))
            table.insert(lines, "")

            -- Open PRs
            if #prs > 0 then
              table.insert(lines, "   My PRs:")
              for _, pr in ipairs(prs) do
                table.insert(lines, "    › " .. pr)
              end
              table.insert(lines, "")
            end

            -- Review Requests
            if #reviews > 0 then
              table.insert(lines, "   Review Requests:")
              for _, review in ipairs(reviews) do
                table.insert(lines, "    › " .. review)
              end
              table.insert(lines, "")
            end

            -- Linear Issues
            if #linear > 0 then
              table.insert(lines, "   Linear:")
              for _, issue in ipairs(linear) do
                table.insert(lines, "    " .. issue)
              end
              table.insert(lines, "")
            end

            table.insert(lines, "─────────────────────────────────────────────")
            table.insert(lines, "")

            -- Stats
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            table.insert(lines, "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms")

            return lines
          end,
        },
      }

      -- Close lazy and re-open when dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
  },

  -- Disable LazyVim's default dashboard (snacks)
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
    },
  },
}
