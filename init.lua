require "utils"
require "window"
require "caffeine"
-----------------------------------------------
-- Reload config on write
-----------------------------------------------
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon config reloaded")

local alt = {"alt"}
hs.hotkey.bind(alt,    "1",     function() hs.application.open("iTerm") end)
hs.hotkey.bind(alt,    "2",     function() hs.application.open("Emacs") end)
hs.hotkey.bind(alt,    "3",     function() hs.application.open("Google Chrome") end)