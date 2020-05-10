require "utils"
require "window"
require "caffeine"
-- disable volume module
-- require "volume"
-----------------------------------------------
-- Reload config on write
-----------------------------------------------
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
show("Hammerspoon config reloaded")

local alt = {"alt"}
hs.hotkey.bind(alt,    "1",     function() hs.application.open("iTerm") end)
hs.hotkey.bind(alt,    "2",     function() hs.application.open("Emacs") end)
hs.hotkey.bind(alt,    "3",     function() hs.application.open("Google Chrome") end)