-- Can this environment actually display images?
--
-- `Snacks.image.supports_terminal()` is necessary but NOT sufficient, and
-- trusting it alone is what produced blank image areas here. herdr relays the
-- terminal version query out to Ghostty, so snacks asks "what terminal are
-- you?", gets "ghostty", and concludes graphics are available — regardless of
-- whether herdr will actually carry the image data.
--
-- herdr does carry it, but only with an experimental opt-in that is off by
-- default. Its own words, from the binary:
--
--     pane graphics require experimental.kitty_graphics
--
-- So in ~/.config/herdr/config.toml:
--
--     [experimental]
--     kitty_graphics = true
--
-- and then restart herdr. A `herdr server reload-config` is not enough, because
-- the painting is client-side (src/kitty_graphics.rs, paint_local_pane_graphics)
-- and the attached client keeps the value it started with.
--
-- Rather than assume either way, this reads that flag and mirrors herdr's own
-- gate. tmux and zellij are treated as incapable: tmux can be made to work with
-- allow-passthrough, but nothing here depends on images, so the conservative
-- answer costs nothing while a wrong guess looks broken.

local M = {}

---@param prefix string
---@return boolean
local function has_env_prefix(prefix)
  for name in pairs(vim.fn.environ()) do
    if name:find(prefix, 1, true) == 1 then
      return true
    end
  end
  return false
end

---Is `experimental.kitty_graphics` turned on in the herdr config?
---
---Deliberately a plain line scan rather than a TOML parse: the only key that
---matters is a single boolean, and pulling in a TOML library for it would be
---absurd. Comment lines are skipped, which matters because the config comments
---mention the key by name.
---@return boolean
function M.herdr_kitty_graphics()
  local path = vim.env.HERDR_CONFIG_PATH
  if not path or path == "" then
    path = vim.fn.expand("~/.config/herdr/config.toml")
  end
  local fd = io.open(path, "r")
  if not fd then
    return false
  end
  local enabled = false
  for line in fd:lines() do
    local trimmed = line:gsub("^%s+", "")
    if not trimmed:match("^#") then
      local value = trimmed:match("^kitty_graphics%s*=%s*(%a+)")
      if value then
        enabled = value == "true"
      end
    end
  end
  fd:close()
  return enabled
end

---Are we inside something that will swallow graphics escapes?
---@return boolean
function M.blocks_graphics()
  if vim.env.TMUX or vim.env.ZELLIJ or vim.env.STY or vim.env.TERM_PROGRAM == "tmux" then
    return true
  end
  if has_env_prefix("CMUX_") then
    return true
  end
  -- herdr carries graphics only with the experimental flag on.
  if has_env_prefix("HERDR_") then
    return not M.herdr_kitty_graphics()
  end
  return false
end

---Is the outer terminal one that speaks the Kitty graphics protocol?
---Env-only, so safe to call before there is a tty to query.
---@return boolean
function M.terminal_looks_capable()
  local prog = (vim.env.TERM_PROGRAM or ""):lower()
  local term = (vim.env.TERM or ""):lower()
  return prog:find("ghostty", 1, true) ~= nil
    or prog:find("kitty", 1, true) ~= nil
    or term:find("ghostty", 1, true) ~= nil
    or term:find("kitty", 1, true) ~= nil
    or vim.env.KITTY_WINDOW_ID ~= nil
end

---Best guess available without a tty. Decides layout, and whether to enable
---snacks.image at all.
---@return boolean
function M.likely()
  if vim.g.images_enabled == false then
    return false
  end
  return not M.blocks_graphics() and M.terminal_looks_capable()
end

---Authoritative: everything in `likely()`, plus snacks' own terminal query,
---which needs a real tty and so only answers correctly once the UI is up.
---@return boolean
function M.supported()
  if not M.likely() then
    return false
  end
  if not _G.Snacks or not Snacks.image then
    return false
  end
  return Snacks.image.supports_terminal()
end

return M
