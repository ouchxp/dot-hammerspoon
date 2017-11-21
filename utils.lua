function reloadConfig(files)
    doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

-- show on primary screen by default
function show(msg)
    hs.alert.show("Built-in Output Muted", hs.alert.defaultStyle, hs.screen.primaryScreen())
end