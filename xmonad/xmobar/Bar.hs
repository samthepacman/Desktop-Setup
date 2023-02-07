Config { font    = "xft:Iosevka Nerd Font:weight=Light:pixelsize=14:antialias=true:hinting=true"
       , additionalFonts = [ "xft:Droid Sans:pixelsize=11:antialias=true:hinting=true"
                           , "xft:Iosevka Nerd Font:pixelsize=16:antialias=true:hinting=true"
                           , "xft:FontAwesome:pixelsize=13"
                           ]
       , textOffset = 13
       , bgColor = "#191a1c"
       , fgColor = "#abb2bf"
       , position = Static { xpos = 0, ypos = 0, width = 1366, height = 30 }
       , lowerOnStart = False
       , hideOnStart = False
       , allDesktops = True
       , alpha = 0
       , persistent = True
       , iconRoot = "/home/shiva/.config/nixpkgs/role/x11/xpms/"  -- default: "."
       , commands = [ 
                      -- Time and date
                      Run Date "DATE: %b %d %Y" "date" 50
                    , Run Date "TIME: %H:%M" "time" 50
                    , Run Network "wlp2s0" ["-t", "<fn=0>U :</fn> <rx>kb <fn=0> :</fn> <tx>kb"] 20
                    , Run Cpu ["-t", "<fn=1></fn>CPU: <total>%","-H","70","--high","red"] 20
                    , Run Memory ["-t", "MEM: <used>M (<usedratio>%)"] 20
                    , Run DiskU [("/nix/persist", " H: <free> free")] [] 60
                    , Run MPD ["-t", "<state>: <artist> - <track>"] 10
                    , Run Com "uname" ["-r"] "" 3600 
                    , Run StdinReader
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "} %memory% | %cpu% | %date% | %time% {"
       }
