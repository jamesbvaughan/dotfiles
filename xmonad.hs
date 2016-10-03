import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Layout.DecorationMadness
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.Run

myModMask = mod4Mask
myBorderWidth = 3
myTerminal = "urxvtc"
myLayoutHook = desktopLayoutModifiers myLayout
myConfig = desktopConfig
myFocusedBorderColor = "#6272a4"
myAdditionalKeys =
  [ ("M-<Tab>", nextWS)
  , ("M-S-<Tab>", prevWS)
  ]
myLayout = spaced ||| full
  where
    spaced = smartBorders $ smartSpacing 5 $ Tall 1 0.03 0.5
    full =   noBorders Full

main = xmonad =<< xmobar (myConfig
  { terminal = myTerminal
  , modMask = myModMask
  , focusedBorderColor = myFocusedBorderColor
  , borderWidth = myBorderWidth
  , layoutHook = myLayoutHook
  }
  `additionalKeysP`
  myAdditionalKeys)
