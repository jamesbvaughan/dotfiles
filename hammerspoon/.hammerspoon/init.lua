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


immediateKeyStroke = function(modifiers, character)
    local event = require("hs.eventtap").event
    event.newKeyEvent(modifiers, string.lower(character), true):post()
    event.newKeyEvent(modifiers, string.lower(character), false):post()
    return true
end


hs.eventtap.new({hs.eventtap.event.types.otherMouseDown},
  function(evt)
    return handleButtonPressed(evt)
  end
):start()

function handleButtonPressed(evt)
  button_prop = hs.eventtap.event.properties["mouseEventButtonNumber"]
  button_pressed = evt:getProperty(button_prop)

  print(hs.inspect(button_pressed))

  -- if cmd held, then use tab navigation with thumb buttons
  if evt:getFlags()["cmd"] then
    if button_pressed == 3 then
      return immediateKeyStroke({"cmd", "shift"}, "]")
    elseif button_pressed == 4 then
      return immediateKeyStroke({"cmd", "shift"}, "[")
    end
  -- trigger back and forward with thumb buttons
  else
    if button_pressed == 3 then
     return immediateKeyStroke({"cmd"}, "[")
   elseif button_pressed == 4 then
     return immediateKeyStroke({"cmd"}, "]")    end
  end
end

xTouch = hs.midi.new("X-Touch One")
xTouch:callback(function(object, deviceName, commandType, description, metadata)
  print("object: " .. tostring(object))
  print("deviceName: " .. deviceName)
  print("commandType: " .. commandType)
  print("description: " .. description)
  print("metadata: " .. hs.inspect(metadata))
  print("number: " .. hs.inspect(metadata.controllerNumber))
  print("value: " .. hs.inspect(metadata.controllerValue))
end)
