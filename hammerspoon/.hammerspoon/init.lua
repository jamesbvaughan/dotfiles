hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- Hotkeys to quickly change spaces
spaces = require("hs._asm.undocumented.spaces")

function moveToNextSpace(direction)
  local activeSpaceId = spaces.activeSpace()
  local activeScreenId = spaces.spaceScreenUUID(activeSpaceId)
  local screenSpaces = spaces.layout()[activeScreenId]
  
  local index = {}
  local numberOfSpaces = 0
  for k, v in pairs(screenSpaces) do
    index[v] = k
    numberOfSpaces = numberOfSpaces + 1
  end

  local activeSpaceIndex = index[activeSpaceId]

  if (direction == "left") then
    if (activeSpaceIndex > 1) then
      targetSpaceIndex = activeSpaceIndex - 1
    else
      targetSpaceIndex = numberOfSpaces
    end
  elseif (direction == "right") then
    if (activeSpaceIndex < numberOfSpaces) then
      targetSpaceIndex = activeSpaceIndex + 1
    else
      targetSpaceIndex = 1
    end
  end

  targetSpaceId = screenSpaces[targetSpaceIndex]
  spaces.changeToSpace(targetSpaceId)
end

-- Next Space
hs.hotkey.bind({"option"}, "tab", function()
  moveToNextSpace("right")
end)

-- Previous Space
hs.hotkey.bind({"option", "shift"}, "tab", function()
  moveToNextSpace("left")
end)


hs.eventtap.new({hs.eventtap.event.types.otherMouseDown},
  function(evt)
    return handleButtonPressed(evt)
  end
):start()

immediateKeyStroke = function(modifiers, character)
    local event = require("hs.eventtap").event
    event.newKeyEvent(modifiers, string.lower(character), true):post()
    event.newKeyEvent(modifiers, string.lower(character), false):post()
    return true
end

function handleButtonPressed(evt)
  button_prop = hs.eventtap.event.properties["mouseEventButtonNumber"]
  button_pressed = evt:getProperty(button_prop)

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

hs.console.darkMode(true)
if hs.console.darkMode() then
    hs.console.outputBackgroundColor{ white = 0 }
    hs.console.consoleCommandColor{ white = 1 }
    hs.console.alpha(.9)
end

hs.alert("Hammerspoon config reloaded")
