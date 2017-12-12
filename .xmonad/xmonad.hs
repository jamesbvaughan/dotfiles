import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Kde
import XMonad.Layout.Fullscreen
import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W

-- import XMonad.Config.Desktop
-- import XMonad.Hooks.DynamicLog
-- import XMonad.Hooks.EwmhDesktops
-- import XMonad.Hooks.ManageDocks
-- import XMonad.Layout.DecorationMadness
-- import XMonad.Layout.NoBorders
-- import XMonad.Layout.Spacing
-- import XMonad.Util.Run


myManageHook = composeAll . concat $
  [[className =? c --> doFloat | c <- myFloats]
  ,[title =? t --> doFloat | t <- myOtherFloats]
  ,[className =? c --> doF (W.shift "2") | c <- webApps]
  ,[className =? c --> doF (W.shift "3") | c <- ircApps]
  ]
  where
    myFloats = ["MPlayer", "Gimp", "plasmashell", "Plasma", "krunner", "Kmix", "Klipper", "Plasmoidviewer"]
    myOtherFloats = ["alsamixer", "plasma-desktop", "win7", "Desktop — Plasma"]
    webApps = ["Firefox-bin", "Opera"]
    ircApps = ["Ksirc"]


main = do

  xmonad $ fullscreenSupport kde4Config
    { terminal = "urxvt"

    , modMask = mod4Mask

    , borderWidth = 0

    , manageHook = manageHook kde4Config <+> myManageHook

    -- , manageHook = composeAll
    --   [ className =? "Cadence.py" --> doFloat
    --   , className =? "Catia.py" --> doFloat
    --   , className =? "Pavucontrol" --> doFloat
    --   , className =? "Jack-rack" --> doFloat
    --   , className =? "ardour_plugin_editor" --> doFloat
    --   ]
    --   <+> manageHook desktopConfig

    } `additionalKeysP`
    [ ("M-<Tab>", nextWS)
    , ("M-S-<Tab>", prevWS)
    ]

