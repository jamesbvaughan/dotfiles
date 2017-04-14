import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.DecorationMadness
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.Run

import XMonad.Layout.Cross

myBorderWidth = 0

myTerminal = "urxvtc"

myFocusedBorderColor = "#268bd2"

myAdditionalKeys =
  [ ("M-<Tab>", nextWS)
  , ("M-S-<Tab>", prevWS)
  ]

myLayout = tall ||| wide ||| full ||| simpleCross
  where
    tall = renamed [Replace "tall"] $ smartBorders $ spacingWithEdge 5 $ Tall 1 0.03 0.5
    wide = renamed [Replace "wide"] $ Mirror tall
    full = renamed [Replace "full"] $ noBorders Full

myConfig = desktopConfig
  { terminal = myTerminal
  , modMask = mod4Mask
  , focusedBorderColor = myFocusedBorderColor
  , borderWidth = myBorderWidth
  , layoutHook = desktopLayoutModifiers myLayout
  }

main = xmonad $ additionalKeysP myConfig myAdditionalKeys
