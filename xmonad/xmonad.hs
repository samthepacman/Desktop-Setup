----------------------------------- IMPORT MODULES -----------------------------------

    -- Base
import XMonad
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies)
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Actions.DynamicProjects
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.FloatKeys
import XMonad.Actions.TreeSelect as T
import XMonad.Actions.SinkAll
import XMonad.Actions.SpawnOn
import XMonad.Actions.MessageFeedback
import XMonad.Actions.Navigation2D
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ResizableTile
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.BinarySpacePartition


    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation

import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import qualified XMonad.StackSet as W

    -- Prompt
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.XMonad
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Ssh
import XMonad.Prompt.Unicode
import Control.Arrow (first)

   -- Utilities
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.NamedWindows       (getName)
import XMonad.Util.Run                (runInTerm, safeSpawn)

-------------------------------------- THEMING ---------------------------------------

-- Tomorrow Night
colorD = "#191a1c" -- dark
color0 = "#1d1f21" -- black
color1 = "#cc6666" -- red
color2 = "#b5bd68" -- green
color3 = "#f0c674" -- yellow
color4 = "#81a2be" -- blue
color5 = "#b294bb" -- magenta
color6 = "#8abeb7" -- cyan
color7 = "#c5c8c6" -- white
--

-- OneDark
-- colorD = "#1d2026"
-- color0 = "#282c34"
-- color1 = "#ff6c6b"
-- color2 = "#98be65"
-- color3 = "#ecbe7b"
-- color4 = "#51afef"
-- color5 = "#c678dd"
-- color6 = "#46d9ff"
-- color7 = "#bbc2cf"
--

-- Solarized
-- colorD = "#002b36"
-- color0 = "#073642"
-- color1 = "#dc322f"
-- color2 = "#859900"
-- color3 = "#b58900"
-- color4 = "#268bd2"
-- color5 = "#d33682"
-- color6 = "#2aa198"
-- color7 = "#eee8d5"
--

-- Tokyo Night
-- colorD = "#1a1b26"
-- color0 = "#32344a"
-- color1 = "#f7768e"
-- color2 = "#9ece6a"
-- color3 = "#e0af68"
-- color4 = "#7aa2f7"
-- color5 = "#ad8ee6"
-- color6 = "#449dab"
-- color7 = "#787c99"
--

-- TheLoveLace
-- colorD = "#1D1F28"
-- color0 = "#282A36"
-- color1 = "#F37F97"
-- color2 = "#5ADECD"
-- color3 = "#F2A272"
-- color4 = "#8897F4"
-- color5 = "#C574DD"
-- color6 = "#79E6F3"
-- color7 = "#FDFDFD"
--

-- Dracula
-- colorD = "#282a36"
-- color0 = "#000000"
-- color1 = "#ff5555"
-- color2 = "#50fa7b"
-- color3 = "#f1fa8c"
-- color4 = "#bd93f9"
-- color5 = "#ff79c6"
-- color6 = "#8be9fd"
-- color7 = "#bbbbbb"
--

-- Argonaut
-- colorD = "#292C3E"
-- color0 = "#0d0d0d"
-- color1 = "#FF301B"
-- color2 = "#A0E521"
-- color3 = "#FFC620"
-- color4 = "#1BA6FA"
-- color5 = "#8763B8"
-- color6 = "#21DEEF"
-- color7 = "#EBEBEB"
--

-- Ayu
-- colorD = "#0A0E14"
-- color0 = "#01060E"
-- color1 = "#EA6C73"
-- color2 = "#91B362"
-- color3 = "#F9AF4F"
-- color4 = "#53BDFA"
-- color5 = "#FAE994"
-- color6 = "#90E1C6"
-- color7 = "#C7C7C7"
--

-- Dark Pastels
-- colorD = "#2C2C2C"
-- color0 = "#3F3F3F"
-- color1 = "#705050"
-- color2 = "#60B48A"
-- color3 = "#DFAF8F"
-- color4 = "#9AB8D7"
-- color5 = "#DC8CC3"
-- color6 = "#8CD0D3"
-- color7 = "#DCDCCC"
--

-- MAIN COLORS
dark     = colorD
black    = color0
red      = color1
green    = color2
yellow   = color3
blue     = color4
magenta  = color5
cyan     = color6
white    = color7

-------------------------------------- DEFAULTS --------------------------------------
-- wm settings

myBorderWidth :: Dimension
myBorderWidth = 0

myNormColor :: String
myNormColor = dark

myFocusColor :: String
myFocusColor = yellow

myModMask :: KeyMask
myModMask = mod1Mask

altMask :: KeyMask
altMask = mod1Mask

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- cli cmds
myEditor :: String
myEditor = "emacs"

myTerminal :: String
myTerminal = "alacritty"

myBrowser :: String
myBrowser = "qutebrowser"

myEmacs :: String
myEmacs = "emacsclient -c -a 'emacs' "

myRestart :: String
myRestart = "xmonad --restart && notify-send 'Xmonad Restarted'"

myFont :: String
myFont = "xft:Iosevka Nerd Font:size=11:antialias=true:hinting=true"

myRecompile :: String
myRecompile = "xmonad --recompile && xmonad --restart && notify-send 'Recompiled'"

-------------------------------- AUTOSTART / STARTUP ---------------------------------

myStartupHook :: X ()
myStartupHook = do
          spawnOnce "feh --no-fehbg --bg-scale ~/Files/Wallpaper/street.jpg"
          spawnOnce "picom &"
--	  spawnOnce "~/.xmonad/bin/init-tilingwm &"
--	  spawnOnce "~/.xmonad/bin/init-keyboard &"
          spawnOnce "mpd"
          spawnOnce "emacs --daemon &"
          spawnOnce "xsetroot -cursor_name left_ptr &"
          setWMName "LG3D"

------------------------------------ GRID SELECT -------------------------------------
myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x1d,0x1f,0x21) -- lowest inactive bg
                  (0x1d,0x1f,0x21) -- highest inactive bg
                  (0x81,0xa2,0xbe) -- active bg
                  (0xc5,0xc8,0xc6) -- inactive fg
                  (0x1d,0x1f,0x21) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 80
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myAppGrid = [ ("Discord", "discord")
                 , ("Ncmpcpp", "alacritty -e ncmpcpp")
                 , ("Emacs", "emacsclient -c -a emacs")
                 , ("Firefox", "firefox")
                 , ("Brave", "brave")
                 , ("Gimp", "gimp")
                 , ("CherryTree", "cherrytree")
                 , ("EasyTag", "easytag")
                 , ("HakuNeko", "hakuneko")
                 , ("KdeConnect", "kdeconnect-app")
                 , ("Bluetooth", "blueman-manager")
                 , ("Ranger", "alacritty -e ranger")
                 , ("NNN", "alacritty -e nnn")
                 , ("Lxappearance", "lxappearance")
                 , ("Connman", "cmst")
                 , ("Manual", "nixos-help")
                 , ("Htop", "alacritty -e htop")
                 , ("Terminal", "Htop")
                 , ("Neovim", "alacritty -e nvim")
                 , ("Spotify", "spotify")
                 , ("Inkscape", "inkscape")
                 , ("Qutebrowser", "qutebrowser")
                 , ("Youtube", "alacritty -e ytfzf")
                 , ("PCManFM", "pcmanfm")
                 ]
----------------------------------- XMONAD PROMPT ------------------------------------

dtXPConfig :: XPConfig
dtXPConfig = def
      { font                = myFont
      , bgColor             = dark
      , fgColor             = white
      , bgHLight            = blue
      , fgHLight            = dark
      , borderColor         = black
      , promptBorderWidth   = 0
      , position            = Top
      , height              = 28
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 100000  -- set Just 100000 for .1 sec
      , showCompletionOnTab = False
      , searchPredicate     = fuzzyMatch
      , alwaysHighlight     = True
      , maxComplRows        = Just 15      -- set to Just 5 for 5 rows
      }

------------------------------------ TREE SELECT -------------------------------------
--- TS THEMING
myTSConfig = T.tsDefaultConfig 
    { T.ts_navigate = myNavigationKeys
    , T.ts_node         = (0xffc5c8c6, 0xff1d1f21)
    , T.ts_nodealt      = (0xffc5c8c6, 0xff242629)
    , T.ts_highlight    = (0xff1d1f21, 0xff81a2be)
    , T.ts_background   = 0xcc1d1f21
    , T.ts_font         = "xft:VictorMono Nerd Font:size=11:style=italic"
    , T.ts_node_width   = 200
    , T.ts_node_height  = 30
    , T.ts_originX      = 30
    , T.ts_originY      = 0
    , T.ts_indent       = 80
    , T.ts_extra        = 0xffabb2bf
}

--- TS NAVIGATION
myNavigationKeys = M.fromList
    [ ((0, xK_Escape), T.cancel)
    , ((0, xK_Return), T.select)
    , ((0, xK_space),  T.select)
    , ((0, xK_b),      T.moveHistBack)
    , ((0, xK_f),      T.moveHistForward)
    , ((0, xK_h),      T.moveParent)
    , ((0, xK_j),      T.moveNext)
    , ((0, xK_k),      T.movePrev)
    , ((0, xK_l),      T.moveChild)
    , ((0, xK_Left),   T.moveParent)
    , ((0, xK_Down),   T.moveNext)
    , ((0, xK_Up),     T.movePrev)
    , ((0, xK_Right),  T.moveChild)
    ]

--- TS APPMENU
treeselectMenu :: T.TSConfig (X ()) -> X ()
treeselectMenu a = T.treeselectAction a
   [ Node (T.TSNode "+ Media" "" (return ()))
       [ Node (T.TSNode "Gimp" "" (spawn "file-roller")) []
       , Node (T.TSNode "Inkscape" "" (spawn "qalculate-gtk")) []
       , Node (T.TSNode "Virt-Manager" "" (spawn "virt-manager")) []
       , Node (T.TSNode "Virtualbox" ""(spawn "virtualbox")) []
       ]
   , Node (T.TSNode "+ Internet" "" (return ()))
       [ Node (T.TSNode "Brave" "" (spawn "brave")) []
       , Node (T.TSNode "Discord" "" (spawn "discord")) []
       , Node (T.TSNode "Elfeed" "" (spawn "emacsclient -c -a '' --eval '(elfeed)'")) []
       , Node (T.TSNode "Firefox" "" (spawn "firefox")) []
       ]
   , Node (T.TSNode "+ Multimedia" "" (return ()))
       [ Node (T.TSNode "Alsa Mixer" "" (spawn (myTerminal ++ " -e alsamixer"))) []
       , Node (T.TSNode "Audacity" "" (spawn "audacity")) []
       , Node (T.TSNode "Deadbeef" "" (spawn "deadbeef")) []
       , Node (T.TSNode "EMMS" "" (spawn "xxx")) []
       ]
   ]
------------------------------------ WINDOW DECO -------------------------------------

topbar      = 10
topBarTheme = def
    { fontName              = myFont
    , inactiveBorderColor   = dark
    , inactiveColor         = dark
    , inactiveTextColor     = dark
    , activeBorderColor     = yellow
    , activeColor           = yellow
    , activeTextColor       = yellow
    , urgentBorderColor     = magenta
    , urgentTextColor       = magenta
    , decoHeight            = topbar
    }

addTopBar = noFrillsDeco shrinkText topBarTheme
-- addTabBar = tabbed shrinkText myTabTheme
-------------------------------- PER-LAYOUT SETTINGS ---------------------------------

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True
--- LAYOUT

tall     = renamed [Replace "TALL"]
           $ addTopBar
           $ limitWindows 12
           $ mySpacing 3
           $ ResizableTall 1 (3/100) (5/10) []
monocle  = renamed [Replace "MONOCLE"]
           $ addTopBar
           $ limitWindows 20 Full
floats   = renamed [Replace "FLOAT"]
           $ addTopBar
           $ limitWindows 20 simplestFloat
threeCol = renamed [Replace "ThreeCol"]
           $ addTopBar
           $ mySpacing 3
           $ ThreeColMid 1 (1/10) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ addTopBar
           $ limitWindows 7
           $ mySpacing 3
           $ ThreeCol 1 (3/100) (1/2)
magnify  = renamed [Replace "magnify"]
           $ subLayout [] (smartBorders Simplest)
           $ magnifier
           $ addTopBar
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
tabs       = renamed [Replace "tabs"]
spirals  = renamed [Replace "spirals"]
           $ addTopBar
           $ mySpacing 3
           $ subLayout [] (smartBorders Simplest)
           $ spiral (6/7)
myTabTheme = def { fontName            = myFont
                 , activeColor         = yellow 
                 , inactiveColor       = dark
                 , activeBorderColor   = yellow
                 , inactiveBorderColor = dark
                 , activeTextColor     = dark
                 , inactiveTextColor   = dark
                 }

-- LAYOUT HOOK ------------
myLayoutHook = mouseResize $ windowArrange $ T.toggleLayouts floats $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout = threeCol
	                         ||| threeRow
                                 ||| tall
                                 ||| floats
                                 ||| monocle
				 ||| spirals

------------------------------------ WORKSPACE -------------------------------------
-- SHOW WORKSPACE NAME
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:VictorMono Nerd Font:Italic:size=28"
    , swn_fade              = 0.5
    , swn_bgcolor           = dark
    , swn_color             = white
    }

-- NODE - TREESELECT BASED WORKSPACES
myWorkspaces :: Forest String
myWorkspaces = [ Node "Alpha"
                   [ Node "1" []
                   , Node "2" []
                   , Node "3" []
                   ]
               , Node "Beta"
                   [ Node "1" []
                   , Node "2" []
                   , Node "3" []
                   ]
               , Node "Gamma"
                   [ Node "1" []
                   , Node "2" []
                   , Node "3" []
                   ]
               , Node "Delta"
                   [ Node "1" []
                   , Node "2" []
                   , Node "3" []
                   ]
               , Node "Epsilon"
                   [ Node "1" []
                   , Node "2" []
                   , Node "3" []
                   ]
               , Node "Zeta"
                   [ Node "1" []
                   , Node "2" []
                   , Node "3" []
                   ]
               , Node "Eta"
                   [ Node "1" []
                   , Node "2" []
                   , Node "3" []
                   ]
               , Node "Theta"
                   [ Node "1" []
                   , Node "2" []
                   , Node "3" []
                   ]
               , Node "Iota"
                   [ Node "1" []
                   , Node "2" []
                   , Node "3" []
                   ]
               , Node "Kappa"
                   [ Node "1" []
                   , Node "2" []
                   , Node "3" []
                   ]
               , Node "Projects"
                   [ Node "DevEnv" []
                   , Node "JavaScript" []
                   , Node "Xmonad" []
                   , Node "Python" []
                   , Node "Space" []
                   , Node "Misc" []
                   ]
               ]

------------------------------------- PROJECT --------------------------------------
projects :: [Project]
projects =

    [ Project   { projectName       = "Projects"
                , projectDirectory  = "~/"
                , projectStartHook  = Nothing
                }

    , Project   { projectName       = "Projects.DevEnv"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do spawn myTerminal
                                                spawn myTerminal
                                                spawn myTerminal
                }

    , Project   { projectName       = "Projects.JavaScript"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do spawn "/usr/lib/xscreensaver/spheremonics"
                                                runInTerm "-name top" "top"
                                                runInTerm "-name top" "htop"
                                                runInTerm "-name glances" "glances"
                                                spawn "/usr/lib/xscreensaver/cubicgrid"
                                                spawn "/usr/lib/xscreensaver/surfaces"
                }

    , Project   { projectName       = "Projects.Xmonad"
                , projectDirectory  = "~/.xmonad"
                , projectStartHook  = Just $ do runInTerm "-name vix" "vim ~/.xmonad/xmonad.hs"
                                                spawn myTerminal
                                                spawn myTerminal
                }

    , Project   { projectName       = "Projects.Python"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do runInTerm "-name glances" "glances"
                }

    , Project   { projectName       = "Projects.Haskell"
                , projectDirectory  = "~/wrk"
                , projectStartHook  = Just $ do spawn myTerminal
                                                spawn myBrowser
                }

    , Project   { projectName       = "Projects.Space"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do spawn myBrowser
                }

    , Project   { projectName       = "Projects.Misc"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do return ()
                }
    ]

-----------------------  WINDOW MANAGE HOOKS [ MOVING APPS ] -----------------------

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     [ className =? "confirm"         --> doFloat
     , className =? "file_progress"   --> doFloat
     , className =? "dialog"          --> doFloat
     , className =? "download"        --> doFloat
     , className =? "error"           --> doFloat
     , className =? "Gimp"            --> doFloat
     , className =? "notification"    --> doFloat
     , className =? "pinentry-gtk-2"  --> doFloat
     , className =? "splash"          --> doFloat
     , className =? "toolbar"         --> doFloat
     , title =? "Oracle VM VirtualBox Manager"  --> doFloat
     , title =? "scratchpad"          --> hasBorder False
     , title =? "music"               --> hasBorder False
     , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat
     , isFullscreen -->  doFullFloat
     ] <+> namedScratchpadManageHook myScratchPads

---------------------------- DISABLE SCRATCHPAD BORDERS ----------------------------

removeBorderQuery :: Query Bool
removeBorderQuery = title =? "scratchpad" <||> title =? "music"

removeBorder :: Window -> X ()
removeBorder ws = withDisplay $ \d -> mapM_ (\w -> io $ setWindowBorderWidth d w 0) [ws]

myBorderEventHook :: Event -> X All
myBorderEventHook (MapNotifyEvent {ev_window = window}) = do
    whenX (runQuery removeBorderQuery window) (removeBorder window)
    return $ All True

myBorderEventHook _ = return $ All True

----------------------------------- WIDGET FADE ------------------------------------

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 1.0

--------------------------------- NAMED SCRATCHPAD ---------------------------------

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "ncmpcpp" spawnMus findMus manageMus
                ]
  where
  -- role = stringProperty "WM_WINDOW_ROLE"
  -- wm_name = stringProperty "WM_NAME"

    spawnTerm  = myTerminal ++ " -t scratchpad -e ranger"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.6
                 w = 0.6
                 t = 0.2
                 l = 0.2
    spawnMus  = myTerminal ++ " -t scratchpad -e ncmpcpp"
    findMus   = title =? "music"
    manageMus = customFloating $ W.RationalRect l t w h
               where
                 h = 0.6
                 w = 0.6
                 t = 0.2
                 l = 0.2
------------------------------- XMONAD SEARCH PROMPT -------------------------------
dtXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
dtXPKeymap = M.fromList $
     map (first $ (,) controlMask)      -- control + <key>
     [ (xK_z, killBefore)               -- kill line backwards
     , (xK_k, killAfter)                -- kill line forwards
     , (xK_a, startOfLine)              -- move to the beginning of the line
     , (xK_e, endOfLine)                -- move to the end of the line
     , (xK_m, deleteString Next)        -- delete a character foward
     , (xK_b, moveCursor Prev)          -- move cursor forward
     , (xK_f, moveCursor Next)          -- move cursor backward
     , (xK_BackSpace, killWord Prev)    -- kill the previous word
     , (xK_y, pasteString)              -- paste a string
     , (xK_g, quit)                     -- quit out of prompt
     , (xK_bracketleft, quit)
     ]
     ++
     map (first $ (,) altMask)          -- meta key + <key>
     [ (xK_BackSpace, killWord Prev)    -- kill the prev word
     , (xK_f, moveWord Next)            -- move a word forward
     , (xK_b, moveWord Prev)            -- move a word backward
     , (xK_d, killWord Next)            -- kill the next word
     , (xK_n, moveHistory W.focusUp')   -- move up thru history
     , (xK_p, moveHistory W.focusDown') -- move down thru history
     ]
     ++
     map (first $ (,) 0) -- <key>
     [ (xK_Return, setSuccess True >> setDone True)
     , (xK_KP_Enter, setSuccess True >> setDone True)
     , (xK_BackSpace, deleteString Prev)
     , (xK_Delete, deleteString Next)
     , (xK_Left, moveCursor Prev)
     , (xK_Right, moveCursor Next)
     , (xK_Home, startOfLine)
     , (xK_End, endOfLine)
     , (xK_Down, moveHistory W.focusUp')
     , (xK_Up, moveHistory W.focusDown')
     , (xK_Escape, quit)
     ]
----------------------------
---  XMONAD SEARCH
archwiki, ebay, news, reddit, urban, yacy :: S.SearchEngine

archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="
ebay     = S.searchEngine "ebay" "https://www.ebay.com/sch/i.html?_nkw="
news     = S.searchEngine "news" "https://news.google.com/search?q="
reddit   = S.searchEngine "reddit" "https://www.reddit.com/search/?q="
urban    = S.searchEngine "urban" "https://www.urbandictionary.com/define.php?term="
yacy     = S.searchEngine "yacy" "http://localhost:8090/yacysearch.html?query="

searchList :: [(String, S.SearchEngine)]
searchList = [ ("a", archwiki)
             , ("d", S.duckduckgo)
             , ("e", ebay)
             , ("g", S.google)
             , ("h", S.hoogle)
             , ("i", S.images)
             , ("n", news)
             , ("r", reddit)
             , ("s", S.stackage)
             , ("t", S.thesaurus)
             , ("v", S.vocabulary)
             , ("b", S.wayback)
             , ("u", urban)
             , ("w", S.wikipedia)
             , ("y", S.youtube)
             , ("S-y", yacy)
             , ("z", S.amazon)
             ]

-------------------------------- XMONAD KEYBINDING ---------------------------------

myKeys :: [(String, X ())]
myKeys =
         [ ("M-S-r", spawn (myRecompile))                             -- Restart xmonad
         
	 -----------------------------------------------------------------------------
         -- PROMPT
         , ("M-<Return>", shellPrompt dtXPConfig)   -- Shell prompt
         , ("M-d", shellPrompt dtXPConfig)          -- Shell prompt
         
	 -- PROJECT PROMPT
         , ("C-t w", switchProjectPrompt dtXPConfig)   -- Project shift prompt
         , ("C-t s", shiftToProjectPrompt dtXPConfig)  -- Project switch prompt
	 -----------------------------------------------------------------------------
         -- TERMINAL
         , ("M-S-<Return>", spawn (myTerminal))               -- Alacritty tertminal
         , ("M-C-n", spawn (myTerminal ++ " -e ncmpcpp"))     -- Ncmpcpp
         , ("M-e", spawn (myTerminal ++ " -e nvim"))          -- Neovim

	 -- NAMED SCRATCHPADS
	 , ("M-f", namedScratchpadAction myScratchPads  "terminal" )      -- Terminal scratchpad
         , ("M-g", namedScratchpadAction myScratchPads  "ncmpcpp" )       -- Ncmpcpp scratchpad
         -----------------------------------------------------------------------------
         -- EMACS
	 , ("M-a", spawn (myEmacs ++ ("--eval '(eshell)'")))                -- Emacs eshell
	 , ("M-e t", spawn (myEmacs ++ ("--eval '(term)'")))                -- Emacs terminal
	 , ("M-e n", spawn (myEmacs ++ ("--eval '(nix-shell)'")))           -- Emacs nix-shell ( shell.nix )
         -----------------------------------------------------------------------------
         --- XMONAD WIDGETS

         -- TREE SELECT
         , ("M-p", T.treeselectWorkspace myTSConfig myWorkspaces W.greedyView)  -- Treeselect workspace
         , ("M-z", T.treeselectWorkspace myTSConfig myWorkspaces W.greedyView)  -- Treeselect workspace
         , ("C-S-t", treeselectMenu myTSConfig)                                 -- Treeselect appmenu
         , ("M-S-p", T.treeselectWorkspace myTSConfig myWorkspaces W.shift)     -- Treeselect workspace shift

         -- GRID SELECT
         , ("C-g g", spawnSelected' myAppGrid)                 -- grid select favorite apps
         , ("C-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
         , ("C-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window
         -----------------------------------------------------------------------------
         -- WINDOW
         , ("M-q", kill)          -- Kill the currently focused client
         , ("M-S-a", killAll)     -- Kill all windows on current workspace
         -------------------------------------------------------------------------------
         -- FLOAT LAYOUT
         , ("M-w", withFocused $ windows . W.sink)                            -- Push floating window back to tile
         , ("M-S-<Delete>", sinkAll)                                          -- Push all floating windows to tile
         -- , ("M-S-d", withFocused (keysAbsResizeWindow (-10,-10) (1024,752)))  -- Window resize shrink
         -- , ("M-S-s", withFocused (keysAbsResizeWindow (10,10) (1024,752)))    -- Window resize expand
         -----------------------------------------------------------------------------
         -- WINDOW NAVIGATION
         , ("M-m", windows W.focusMaster)   -- Move focus to the master window
         , ("M-j", windows W.focusDown)     -- Move focus to the next window
         , ("M-k", windows W.focusUp)       -- Move focus to the prev window
         , ("M-S-j", windows W.swapDown)    -- Swap focused window with next window
         , ("M-S-k", windows W.swapUp)      -- Swap focused window with prev window
         , ("M-<Backspace>", promote)       -- Moves focused window to master, others maintain order
         , ("M1-S-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
         , ("M1-C-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack
         , ("M-C-s", killAllOtherCopies)
         -----------------------------------------------------------------------------
         -- LAYOUT KEY
         , ("M-,", sendMessage NextLayout)                -- Switch to next layout
         , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)   -- Toggles noborder
         , ("M-C-p", sendMessage (IncMasterN 1))          -- Increase number of clients in master pane
         , ("M-C-o", sendMessage (IncMasterN (-1)))       -- Decrease number of clients in master pane
         , ("M-S-<KP_Multiply>", increaseLimit)           -- Increase number of windows
         , ("M-S-<KP_Divide>", decreaseLimit)             -- Decrease number of windows

         -----------------------------------------------------------------------------
         -- RESIZING
         , ("M-h", sendMessage Shrink)            -- Shrink horiz window width
         , ("M-l", sendMessage Expand)            -- Expand horiz window width
         , ("M-C-j", sendMessage MirrorShrink)    -- Shrink vert window width
         , ("M-C-k", sendMessage MirrorExpand)    -- Exoand vert window width

         , ("M-r h", sendMessage Shrink)            -- Shrink horiz window width
         , ("M-r l", sendMessage Expand)            -- Expand horiz window width
         , ("M-r j", sendMessage MirrorShrink)    -- Shrink vert window width
         , ("M-r k", sendMessage MirrorExpand)    -- Exoand vert window width
         -----------------------------------------------------------------------------
         -- APPS
         , ("M-u", spawn "~/.xmonad/bin/init-xmobars")
         -- , ("M-u s", spawn "bash ~/.config/nixpkgs/user/scripts/system/screen.sh")
         , ("M-n", spawn "cmst -d")
      ]
        ++ [("M-s " ++ k, S.promptSearch dtXPConfig f) | (k,f) <- searchList ]
        ++ [("M-S-s " ++ k, S.selectSearch f) | (k,f) <- searchList ]

------------------------------------------------------------------------------------
------------------------------ FINALIZING THE CONFIG -------------------------------
------------------------------------------------------------------------------------
main :: IO ()
main = do

    -- XMONAD HOOKS
    xmonad $ dynamicProjects projects $ ewmh def
        { manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook
        , handleEventHook    = serverModeEventHookCmd
                               <+> serverModeEventHook
                               <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                               <+> myBorderEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
        , workspaces         = toWorkspaces myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = workspaceHistoryHook <+> myLogHook
        } `additionalKeysP` myKeys
