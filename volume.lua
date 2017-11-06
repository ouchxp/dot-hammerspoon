-----------------------------------------------
-- Mute Built-in Output Device
-----------------------------------------------
function onAudioEvent(state)
    if state == "dev#" then
        local output = hs.audiodevice.findOutputByName("Built-in Output")
        output:setOutputVolume(0)
        output:setOutputMuted(true)
        hs.alert.show("Built-in Output Muted")
    end
end
if not hs.audiodevice.watcher.isRunning() then
    hs.audiodevice.watcher.setCallback(onAudioEvent)
    hs.audiodevice.watcher.start()
end
