import XMonad
import XMonad.Util.Run
import XMonad.Layout.Spacing
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog

myConfig = desktopConfig
myModMask = mod4Mask
myBorderWidth = 3
myTerminal = "urxvtc"
myLayoutHook = desktopLayoutModifiers $ spacing 5 $ Tall 1 0.03 0.5
myLogHook h = dynamicLogWithPP $ xmobarPP { ppOutput = hPutStrLn h }

main = do
  h <- spawnPipe "killall xmobar; xmobar"
  xmonad myConfig
    { terminal =    myTerminal
    , modMask =     myModMask
    , borderWidth = myBorderWidth
    , layoutHook =  myLayoutHook
    , logHook =     myLogHook h
    }
