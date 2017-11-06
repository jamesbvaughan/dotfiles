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

main = do

  safeSpawnProg "sleep 1 && ~/.config/polybar/launch.sh"

  xmonad $ desktopConfig
    { terminal = "urxvtc"

    , modMask = mod4Mask

    , workspaces =
      [ "web"
      , "term"
      , "music"
      , "misc"
      , "aux"
      ]

    , focusedBorderColor = "#268bd2"

    , normalBorderColor = "#073642"

    , borderWidth = 5

    , layoutHook = desktopLayoutModifiers $
        let
          tall = smartBorders $ Tall 1 0.03 0.5
          wide = Mirror tall
          full = noBorders Full
        in
          tall ||| wide ||| full

    , handleEventHook = handleEventHook desktopConfig <+> fullscreenEventHook

    , manageHook = composeAll
      [ className =? "Cadence.py" --> doFloat
      , className =? "Catia.py" --> doFloat
      , className =? "Pavucontrol" --> doFloat
      , className =? "Jack-rack" --> doFloat
      , className =? "ardour_plugin_editor" --> doFloat
      ]
      <+> manageHook desktopConfig

    } `additionalKeysP`
    [ ("M-<Tab>", nextWS)
    , ("M-S-<Tab>", prevWS)
    ]

