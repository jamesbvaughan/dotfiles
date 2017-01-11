import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Layout.DecorationMadness
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.Run


myBorderWidth = 3
myTerminal = "urxvtc"
myFocusedBorderColor = "#6272a4"
myAdditionalKeys =
  [ ("M-<Tab>", nextWS)
  , ("M-S-<Tab>", prevWS)
  ]
myLayout = tall ||| wide ||| full
  where
    tall = renamed [Replace "tall"] $ smartBorders $ smartSpacing 5 $ Tall 1 0.03 0.5
    wide = renamed [Replace "wide"] $ Mirror tall
    full = renamed [Replace "full"] $ noBorders Full


main = xmonad =<< xmobar (desktopConfig
  { terminal = myTerminal
  , modMask = mod4Mask
  , focusedBorderColor = myFocusedBorderColor
  , borderWidth = myBorderWidth
  , layoutHook = desktopLayoutModifiers myLayout
  }
  `additionalKeysP`
  myAdditionalKeys)
