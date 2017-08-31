import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.DecorationMadness
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.Run

myLayout = tall ||| wide ||| full
  where
    tall = renamed [Replace "tall"] $ smartBorders $ spacingWithEdge 5 $ Tall 1 0.03 0.5
    wide = renamed [Replace "wide"] $ Mirror tall
    full = renamed [Replace "full"] $ noBorders Full

main = do
  spawnPipe "sleep 0.1; polybar -r jamesbar"
  xmonad $ desktopConfig
    { terminal = "urxvtc"
    , modMask = mod4Mask
    , workspaces = ["web", "term", "music", "misc", "aux"]
    , focusedBorderColor = "#268bd2"
    , borderWidth = 0
    , layoutHook = desktopLayoutModifiers myLayout
    , handleEventHook = handleEventHook desktopConfig <+> fullscreenEventHook
    } `additionalKeysP`
    [ ("M-<Tab>", nextWS)
    , ("M-S-<Tab>", prevWS)
    ]

