import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.Run


myLayoutHook = tall ||| wide ||| full
  where
    tall = smartBorders $ smartSpacingWithEdge 0 $ Tall 1 0.03 0.5
    wide = Mirror tall
    full = noBorders Full


main = do
  spawn "~/.config/polybar/launch.sh"
  xmonad $ fullscreenSupport $ desktopConfig
    { terminal = "urxvtc"

    , workspaces = ["web", "term", "music", "3", "4"]

    , layoutHook = lessBorders OnlyFloat $ avoidStruts $ myLayoutHook

    , modMask = mod4Mask

    , borderWidth = 3

    , normalBorderColor = "#586e75"

    , focusedBorderColor = "#eee8d5"

    }
    `additionalKeysP`
    [ ("M-<Tab>", nextWS)
    , ("M-S-<Tab>", prevWS)
    ]
    `removeKeysP`
    [ "M-p"
    ]

