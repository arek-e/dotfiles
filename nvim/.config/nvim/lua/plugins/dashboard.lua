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
                local repo = pr.repository.name or "repo"
                local title = pr.title
                if #title > 35 then
                  title = title:sub(1, 32) .. "..."
                end
                table.insert(prs, { repo = repo, title = title })
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
                  if #title > 30 then
                    title = title:sub(1, 27) .. "..."
                  end
                  table.insert(issues, { state = state, id = id, title = title })
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
            if line ~= "" then
              local repo, title = line:match("([^:]+): (.+)")
              if repo and title then
                if #title > 35 then
                  title = title:sub(1, 32) .. "..."
                end
                table.insert(items, { repo = repo, title = title })
              end
            end
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
            { action = function() require("telescope.builtin").find_files() end, desc = " Find File    ", icon = "  ", key = "f", key_hl = "DashboardKey" },
            { action = "ene | startinsert", desc = " New File     ", icon = "  ", key = "n", key_hl = "DashboardKey" },
            { action = function() require("telescope.builtin").oldfiles() end, desc = " Recent Files ", icon = "  ", key = "r", key_hl = "DashboardKey" },
            { action = function() require("persistence").load() end, desc = " Restore Session", icon = "  ", key = "s", key_hl = "DashboardKey" },
            { action = function() require("telescope.builtin").live_grep() end, desc = " Find Text    ", icon = "  ", key = "g", key_hl = "DashboardKey" },
            { action = function() vim.cmd("e " .. vim.fn.stdpath("config") .. "/init.lua") end, desc = " Config       ", icon = "  ", key = "c", key_hl = "DashboardKey" },
            { action = "Lazy", desc = " Plugins      ", icon = " 󰒲 ", key = "l", key_hl = "DashboardKey" },
            { action = "qa", desc = " Quit         ", icon = "  ", key = "q", key_hl = "DashboardKey" },
          },
          footer = function()
            local lines = {}

            -- Spacer
            table.insert(lines, "")
            table.insert(lines, "")

            -- GitHub Section Header
            local gh_header = string.format("   GitHub    %d open  •  %d merged", open_prs, merged_prs)
            table.insert(lines, gh_header)
            table.insert(lines, "  ─────────────────────────────────────────")

            -- Open PRs
            if #prs > 0 then
              for _, pr in ipairs(prs) do
                table.insert(lines, string.format("    ● %s: %s", pr.repo, pr.title))
              end
            else
              table.insert(lines, "    No open PRs")
            end

            table.insert(lines, "")

            -- Review Requests
            if #reviews > 0 then
              table.insert(lines, "   Review Requests")
              table.insert(lines, "  ─────────────────────────────────────────")
              for _, review in ipairs(reviews) do
                table.insert(lines, string.format("    ◐ %s: %s", review.repo, review.title))
              end
              table.insert(lines, "")
            end

            -- Linear Section Header
            if #linear > 0 then
              table.insert(lines, "   Linear Issues")
              table.insert(lines, "  ─────────────────────────────────────────")
              for _, issue in ipairs(linear) do
                -- Status indicator with visual differentiation
                local indicator = "○"
                local state_display = issue.state:sub(1, 4):upper()
                if issue.state == "In Progress" then
                  indicator = "●"
                  state_display = "PROG"
                elseif issue.state == "In Review" then
                  indicator = "◐"
                  state_display = "REVW"
                elseif issue.state == "Todo" then
                  indicator = "○"
                  state_display = "TODO"
                elseif issue.state == "Backlog" then
                  indicator = "◌"
                  state_display = "BKLG"
                end
                table.insert(lines, string.format("    %s %s %s  %s", indicator, state_display, issue.id, issue.title))
              end
              table.insert(lines, "")
            end

            -- Footer divider
            table.insert(lines, "  ═════════════════════════════════════════")
            table.insert(lines, "")

            -- Stats
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            table.insert(lines, string.format("  ⚡ %d/%d plugins in %sms", stats.loaded, stats.count, ms))

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
