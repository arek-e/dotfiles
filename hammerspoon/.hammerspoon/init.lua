-- Option+Shift+1..9 switches to the second display's workspace s1..s9.
-- Control+Shift+1..9 moves the focused window there.
-- OmniWM's "switch-workspace anywhere" works regardless of which display has
-- focus. Raw workspace names 10..18 map to s1..s9 on the second display.
local omniwmctl = "/opt/homebrew/bin/omniwmctl"

for slot = 1, 9 do
  hs.hotkey.bind({ "alt", "shift" }, tostring(slot), function()
    hs.task.new(omniwmctl, nil, { "command", "switch-workspace", "anywhere", tostring(9 + slot) }):start()
  end)
end

-- Control+Shift+1..9 moves the focused window to the second display's s1..s9.
-- Absolute workspace numbers work from either display, unlike the slot commands.
for slot = 1, 9 do
  hs.hotkey.bind({ "ctrl", "shift" }, tostring(slot), function()
    hs.task.new(omniwmctl, nil, { "command", "move-to-workspace", tostring(9 + slot) }):start()
  end)
end

hs.alert.show("Hammerspoon: OmniWM second-display keys loaded")
