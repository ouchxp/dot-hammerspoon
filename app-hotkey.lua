function appHotkeyGen(appName, hotkey)
    return function (name, event, app)
        if event == hs.application.watcher.activated then
            if name == appName then
                hotkey:enable()
            end
        elseif event == hs.application.watcher.deactivated then
            if name == appName then
                hotkey:disable()
            end
        end
    end
end

local executeSQL = hs.hotkey.bind({"cmd"}, "return", function() hs.eventtap.keyStroke({"cmd"}, "r") end):disable()
local fAppWatch = appHotkeyGen("Sequel Pro", executeSQL)
hs.application.watcher.new(fAppWatch):start()