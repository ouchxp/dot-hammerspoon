require "utils"
require "window"
require "caffeine"
require "ime"
require "shortcut"
-- require "volume"
-----------------------------------------------
-- Reload config on write
-----------------------------------------------
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
show("Hammerspoon config reloaded")
