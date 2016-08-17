import XMonad
import XMonad.Util.Run
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog

myModMask = mod4Mask
myBorderWidth = 3
myTerminal = "urxvtc"
myLayoutHook = desktopLayoutModifiers myLayout
myLayout = spaced ||| full
  where 
    spaced = smartBorders $ smartSpacing 5 $ Tall 1 0.03 0.5
    full = smartBorders Full

main = xmonad =<< xmobar desktopConfig
    { terminal =    myTerminal
    , modMask =     myModMask
    , borderWidth = myBorderWidth
    , layoutHook =  myLayoutHook
    }
