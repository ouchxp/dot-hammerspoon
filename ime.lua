local pinyin = "com.sogou.inputmethod.sogou.pinyin"
local abc = "com.apple.keylayout.ABC"

-- app to expected ime config
local app2Ime = {}
app2Ime['iTerm2'] = abc
app2Ime['IntelliJ IDEA'] = abc
app2Ime['Google Chrome'] = abc
app2Ime['Code'] = abc
app2Ime['Finder'] = abc
app2Ime['Preview'] = abc
app2Ime['Mail'] = abc
app2Ime['Postman'] = abc
app2Ime['Alfred'] = abc
app2Ime['Calendar'] = abc


function updateFocusAppInputMethod()
    local focusAppName = hs.window.frontmostWindow():application():name()
    if app2Ime[focusAppName] ~= nil then
        hs.keycodes.currentSourceID(app2Ime[focusAppName])
    end
end

-- helper hotkey to figure out the app path and name of current focused window
hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    hs.alert.show("App name:      "
    ..hs.window.focusedWindow():application():name()
    .."\n"
    .."IM source id:  "
    ..hs.keycodes.currentSourceID())
end)

-- toogle input method
hs.hotkey.bind({'ctrl'}, "space", function()
    if (hs.keycodes.currentSourceID() == abc) then
        hs.keycodes.currentSourceID(pinyin)
    else
        hs.keycodes.currentSourceID(abc)
    end
end)

-- Handle cursor focus and application's screen manage.
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        updateFocusAppInputMethod()
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()