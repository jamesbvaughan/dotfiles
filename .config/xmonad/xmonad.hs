import System.Process
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
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

incSideGaps amount = do
  sendMessage $ IncGap amount R
  sendMessage $ IncGap amount L

decSideGaps amount = incSideGaps (-amount)

main = do
  -- myNormalBorderColor <- readProcess "get_color.sh" [] []
  spawn "launch-polybar"
  xmonad $ fullscreenSupport $ desktopConfig
    { terminal = "urxvtc"

    , workspaces = ["1", "2", "3", "4", "5"]

    , modMask = mod4Mask

    , borderWidth = 4

    -- , normalBorderColor = myNormalBorderColor

    , normalBorderColor = "#000000"

    , focusedBorderColor = "#839496"

    , layoutHook = desktopLayoutModifiers
                    $ fullscreenFull
                    $ myLayout

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

