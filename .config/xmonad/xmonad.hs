import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
import XMonad.Layout.Fullscreen
import XMonad.Util.EZConfig
import XMonad.Util.Run


main = do
  spawn "~/.config/polybar/launch.sh"
  xmonad $ fullscreenSupport $ desktopConfig
    { terminal = "urxvtc"

    , workspaces = ["1", "2", "3", "4", "5"]

    , modMask = mod4Mask

    , borderWidth = 0

    }
    `additionalKeysP`
    [ ("M-<Tab>", nextWS)
    , ("M-S-<Tab>", prevWS)
    ]
    `removeKeysP`
    [ "M-p"
    , "M-S-p"
    ]

