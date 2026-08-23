local node = "/opt/homebrew/bin/node"
local restartTimer
local resolveTask
local screenpipeTask

local colors = {
    green = { red = 0.16, green = 0.78, blue = 0.25, alpha = 1 },
    red = { red = 0.9, green = 0.15, blue = 0.15, alpha = 1 },
    gray = { red = 0.55, green = 0.55, blue = 0.55, alpha = 1 },
}

local modes = {
    off = {
        label = "Off",
        dot = "○",
        color = colors.gray,
        args = nil,
    },
    audio = {
        label = "Audio only",
        dot = "●",
        color = colors.green,
        args = {
            "record",
            "--disable-vision",
            "--use-system-default-audio",
        },
    },
    audio_video = {
        label = "Audio + video",
        dot = "●",
        color = colors.red,
        args = {
            "record",
            "--use-all-monitors",
            "--use-system-default-audio",
        },
    },
}

local modeOrder = { "off", "audio", "audio_video" }
local mode = hs.settings.get("screenpipe.mode") or "audio"
if not modes[mode] then
    mode = "audio"
end

local menuBar = hs.menubar.new(true, "screenpipe-mode")
local startScreenpipe

local function updateMenuBar()
    local current = modes[mode]
    menuBar:setIcon(nil)
    menuBar:setTitle(hs.styledtext.new(current.dot, { color = current.color }))
    menuBar:setTooltip("Screenpipe: " .. current.label .. " — click to cycle")
end

local function cancelRestart()
    if restartTimer then
        restartTimer:stop()
        restartTimer = nil
    end
end

local function scheduleRestart()
    cancelRestart()
    if mode == "off" then
        return
    end

    restartTimer = hs.timer.doAfter(5, function()
        restartTimer = nil
        startScreenpipe()
    end)
end

local function launchScreenpipe(path)
    if mode == "off" then
        return
    end

    local current = modes[mode]
    local task
    task = hs.task.new(
        path,
        function(exitCode)
            if screenpipeTask ~= task then
                return
            end
            screenpipeTask = nil
            if mode ~= "off" then
                print("screenpipe exited with code " .. tostring(exitCode))
                scheduleRestart()
            end
        end,
        function()
            return true
        end,
        current.args
    )

    if not task then
        scheduleRestart()
        return
    end

    screenpipeTask = task
    task:setEnvironment({
        HOME = os.getenv("HOME"),
        PATH = "/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin",
    })

    if not task:start() then
        if screenpipeTask == task then
            screenpipeTask = nil
        end
        scheduleRestart()
    end
end

startScreenpipe = function()
    if mode == "off" or (screenpipeTask and screenpipeTask:isRunning()) then
        return
    end
    if resolveTask and resolveTask:isRunning() then
        return
    end

    local output = {}
    local errors = {}
    local resolveScript = [[
cleanup() {
  if [ -n "${node_pid:-}" ]; then
    /usr/bin/pkill -TERM -P "$node_pid" 2>/dev/null || true
    kill "$node_pid" 2>/dev/null || true
    wait "$node_pid" 2>/dev/null || true
  fi
}
trap 'cleanup; exit 143' TERM INT
/opt/homebrew/bin/node /opt/homebrew/lib/node_modules/npm/bin/npx-cli.js --yes screenpipe@latest --version >/dev/null 2>&1 &
node_pid=$!
wait "$node_pid" || exit $?
node_pid=
path=$(find "$HOME/.npm/_npx" -type f -path '*/node_modules/@screenpipe/cli-*/bin/screenpipe' -perm -111 -print0 2>/dev/null | xargs -0 stat -f '%m %N' 2>/dev/null | sort -rn | head -n 1 | sed 's/^[0-9][0-9]* //')
[ -x "$path" ] || exit 1
printf '%s\n' "$path"
]]

    local task
    task = hs.task.new(
        "/bin/sh",
        function(exitCode, stdout, stderr)
            if resolveTask ~= task then
                return
            end
            resolveTask = nil

            if exitCode ~= 0 then
                print("screenpipe npm resolver exited with code " .. tostring(exitCode))
                scheduleRestart()
                return
            end

            local resolvedPath = table.concat(output) .. (stdout or "")
            resolvedPath = resolvedPath:match("([^%s][^\r\n]*)%s*$")
            if not resolvedPath or resolvedPath == "" then
                local resolverError = table.concat(errors) .. (stderr or "")
                print("screenpipe npm resolver returned no binary path: " .. resolverError)
                scheduleRestart()
                return
            end

            launchScreenpipe(resolvedPath)
        end,
        function(_, stdout, stderr)
            if stdout and stdout ~= "" then
                table.insert(output, stdout)
            end
            if stderr and stderr ~= "" then
                table.insert(errors, stderr)
            end
            return true
        end,
        { "-c", resolveScript }
    )

    if not task then
        scheduleRestart()
        return
    end

    resolveTask = task
    task:setEnvironment({
        HOME = os.getenv("HOME"),
        PATH = "/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin",
    })

    if not task:start() then
        if resolveTask == task then
            resolveTask = nil
        end
        scheduleRestart()
    end
end

local function setMode(nextMode)
    if not modes[nextMode] or nextMode == mode then
        return
    end

    mode = nextMode
    hs.settings.set("screenpipe.mode", mode)
    updateMenuBar()
    cancelRestart()

    if screenpipeTask and screenpipeTask:isRunning() then
        screenpipeTask:terminate()
    elseif resolveTask and resolveTask:isRunning() then
        resolveTask:terminate()
    elseif mode ~= "off" then
        startScreenpipe()
    end
end

local function cycleMode()
    for index, name in ipairs(modeOrder) do
        if name == mode then
            setMode(modeOrder[index % #modeOrder + 1])
            return
        end
    end
    setMode(modeOrder[1])
end

menuBar:setClickCallback(cycleMode)
updateMenuBar()
startScreenpipe()
