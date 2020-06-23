-----------------------------------------------
-- Mute Built-in Output Device
-----------------------------------------------
function mute(speakerName)
    local output = hs.audiodevice.findOutputByName(speakerName)
    if output then
        output:setOutputVolume(0)
        output:setOutputMuted(true)
    end
end

function onAudioEvent(state)
    if state == "dev#" then
        mute("Built-in Output")
        mute("MacBook Pro Speakers")
    end
end

hs.audiodevice.watcher.setCallback(onAudioEvent)
hs.audiodevice.watcher.start()

function reloadIfNotRunning()
    if not hs.audiodevice.watcher.isRunning() then
        hs.reload()
    end
end
hs.timer.doEvery(60, reloadIfNotRunning)