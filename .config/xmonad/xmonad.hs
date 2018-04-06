import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
import XMonad.Layout.Fullscreen
import XMonad.Util.EZConfig
import XMonad.Util.Run


main = do
  spawn "launch-polybar"
  xmonad $ fullscreenSupport $ desktopConfig
    { terminal = "urxvtc"

    , workspaces = ["1", "2", "3", "4", "5"]

    , modMask = mod4Mask

    , borderWidth = 4

    , normalBorderColor = "#002b36"

    , focusedBorderColor = "#839496"

    }
    `additionalKeysP`
    [ ("M-<Tab>", nextWS)
    , ("M-S-<Tab>", prevWS)
    ]
    `removeKeysP`
    [ "M-p"
    , "M-S-p"
    ]

