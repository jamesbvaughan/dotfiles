import System.Process
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Kde
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig
import XMonad.Util.Run


myLayout = tall ||| wide ||| full ||| reading
  where
    tall = smartBorders $ Tall 1 0.03 0.5
    wide = Mirror tall
    full = noBorders $ Full
    reading = gaps [(L,500), (R,500), (U,30), (D,30)] full

myManageHook = composeAll . concat $
    [ [ className =? c --> doIgnore | c <- classesToIgnore ]
    ]
  where
    classesToIgnore = ["plasmashell", "krunner"]

incSideGaps amount = do
  sendMessage $ IncGap amount R
  sendMessage $ IncGap amount L

decSideGaps amount = incSideGaps (-amount)

main = do
  -- myNormalBorderColor <- readProcess "get_color.sh" [] []
  -- spawn "launch-polybar"
  xmonad $ fullscreenSupport $ kde4Config
    { terminal = "urxvt"

    , workspaces = ["1", "2", "3", "4", "5"]

    , modMask = mod4Mask

    , borderWidth = 4

    , normalBorderColor = "#002b36"

    , focusedBorderColor = "#839496"

    , layoutHook = desktopLayoutModifiers
                    $ fullscreenFull
                    $ myLayout

    , manageHook = manageHook kde4Config <+> myManageHook

    }
    `additionalKeysP`
    [ ("M-<Tab>", nextWS)
    , ("M-S-<Tab>", prevWS)
    , ("M-S-=", incSideGaps 80)
    , ("M--", decSideGaps 80)
    ]
    `removeKeysP`
    [ "M-p"
    , "M-S-p"
    ]

