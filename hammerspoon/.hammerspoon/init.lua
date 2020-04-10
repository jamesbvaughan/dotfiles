hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end)

local hyper = {"ctrl", "alt", "cmd"}

hs.loadSpoon("MiroWindowsManager")

hs.window.animationDuration = 0
spoon.MiroWindowsManager:bindHotkeys({
  up = {hyper, "k"},
  right = {hyper, "l"},
  down = {hyper, "j"},
  left = {hyper, "h"},
  fullscreen = {hyper, "f"}
})

local moveHyper = {"ctrl", "cmd"}

hs.hotkey.bind(moveHyper, "h", function()
  hs.window.focusWindowWest()
end)

hs.hotkey.bind(moveHyper, "j", function()
  hs.window.focusWindowSouth()
end)

hs.hotkey.bind(moveHyper, "k", function()
  hs.window.focusWindowNorth()
end)

hs.hotkey.bind(moveHyper, "l", function()
  hs.window.focusWindowEast()
end)
