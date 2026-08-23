require "utils"
-- require "window" -- use rectangle instead
require "caffeine"
require "ime"
-- install cli
require("hs.ipc")
hs.ipc.cliInstall("/opt/homebrew")
require "screenpipe"
require "shortcut"
-- require "volume"
-----------------------------------------------
-- Reload config on write
-----------------------------------------------
configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
show("Hammerspoon config reloaded")
