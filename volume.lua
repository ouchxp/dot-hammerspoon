-----------------------------------------------
-- Mute Built-in Output Device
-----------------------------------------------
function onAudioEvent(state)
    if state == "dev#" then
        local output = hs.audiodevice.findOutputByName("Built-in Output")
        output:setOutputVolume(0)
        output:setOutputMuted(true)
        show("Built-in Output Muted")
    end
end

hs.audiodevice.watcher.setCallback(onAudioEvent)
hs.audiodevice.watcher.start()


function reloadIfNotRunning()
    if not hs.audiodevice.watcher.isRunning then
        hs.reload()
    end
end
hs.timer.doEvery(60, reloadIfNotRunning)