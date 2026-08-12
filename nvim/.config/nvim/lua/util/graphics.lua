-- Can this environment actually display images?
--
-- `Snacks.image.supports_terminal()` is necessary but NOT sufficient, and
-- trusting it alone is what produced blank image areas here.
--
-- herdr relays the terminal version query out to Ghostty, so snacks asks "what
-- terminal are you?", gets "ghostty", and concludes graphics are available. But
-- herdr does not forward the graphics data written into the pty by a child
-- process. Verified from a herdr pane with no nvim in the path:
--
--     chafa --format kitty --size 30x15 some.png    -> blank
--
-- The same command in a plain Ghostty tab draws the image. So relaying a query
-- is not the same as relaying image data, and a multiplexer check has to come
-- first. herdr's `pane.graphics.set` API is presumably the supported route for
-- images, which is not something a terminal program can use.
--
-- tmux can be made to work with allow-passthrough, but is treated as incapable
-- here for the same reason: nothing in this config depends on images, so the
-- conservative answer costs nothing and a wrong guess looks broken.

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

---Inside a terminal multiplexer that will not carry graphics through?
---
---Multiplexers announce themselves with prefixed variables (HERDR_PANE_ID,
---CMUX_TAB_ID, ...) rather than a bare name, so checking the bare name finds
---nothing.
---@return boolean
function M.in_multiplexer()
  if vim.env.TMUX or vim.env.ZELLIJ or vim.env.STY or vim.env.TERM_PROGRAM == "tmux" then
    return true
  end
  return has_env_prefix("HERDR_") or has_env_prefix("CMUX_")
end

---Is the outer terminal one that speaks the Kitty graphics protocol?
---Env-only, so it is safe to call before there is a tty to query.
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

---Best guess available without a tty. Used to decide layout and whether to
---enable snacks.image at all.
---@return boolean
function M.likely()
  if vim.g.images_enabled == false then
    return false
  end
  return not M.in_multiplexer() and M.terminal_looks_capable()
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
