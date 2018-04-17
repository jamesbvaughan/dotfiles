import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig
import XMonad.Util.Run


myLayout = tall ||| wide ||| full
  where
    tall = smartBorders $ Tall 1 0.03 0.5
    wide = Mirror tall
    full = noBorders Full


main = do
  spawn "launch-polybar"
  xmonad $ fullscreenSupport $ desktopConfig
    { terminal = "urxvtc"

    , workspaces = ["1", "2", "3", "4", "5"]

    , modMask = mod4Mask

    , borderWidth = 4

    , normalBorderColor = "#002b36"

    , focusedBorderColor = "#839496"

    , layoutHook = desktopLayoutModifiers $ fullscreenFull $ myLayout

    }
    `additionalKeysP`
    [ ("M-<Tab>", nextWS)
    , ("M-S-<Tab>", prevWS)
    ]
    `removeKeysP`
    [ "M-p"
    , "M-S-p"
    ]

