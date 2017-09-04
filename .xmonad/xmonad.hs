import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.DecorationMadness
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.Run

myLayout = tall ||| wide ||| full
  where
    tall = smartBorders $ Tall 1 0.03 0.5
    wide = Mirror tall
    full = noBorders Full

main = do
  safeSpawnProg "~/.config/polybar/launch.sh"
  xmonad $ desktopConfig
    { terminal = "urxvtc"
    , modMask = mod4Mask
    , workspaces = ["web", "term", "music", "misc", "aux"]
    , focusedBorderColor = "#268bd2"
    , normalBorderColor = "#073642"
    , borderWidth = 5
    , layoutHook = desktopLayoutModifiers myLayout
    , handleEventHook = handleEventHook desktopConfig <+> fullscreenEventHook
    } `additionalKeysP`
    [ ("M-<Tab>", nextWS)
    , ("M-S-<Tab>", prevWS)
    ]

