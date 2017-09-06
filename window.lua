-----------------------------------------------
-- Set hyper to cmd + alt
-----------------------------------------------
local hyper = {"cmd", "alt"}
local hyperCtrl = {"cmd", "alt", "ctrl"}

-----------------------------------------------
-- flexible resize function
-----------------------------------------------
function tolerance(a, b) return math.abs(a - b) < 32 end
function resize(x, y, w, h)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()
    local ww = max.w / w
    local hh = max.h / h
    local xx = max.x + (x * ww)
    local yy = max.y + (y * hh)

    if ischatmode and x == 0 then
        xx = xx + CHAT_MODE_WIDTH
        ww = ww - CHAT_MODE_WIDTH
    end

    if tolerance(f.x, xx) and tolerance(f.y, yy) and tolerance(f.w, ww) and tolerance(f.h, hh) then
        if w > h then
            x = (x + 1) % w
        elseif h > w then
            y = (y + 1) % h
        else
            x = (x == 0) and 0.9999 or 0
            y = (y == 0) and 0.9999 or 0
        end
        return resize(x, y, w, h)
    end
    f.x = xx
    f.y = yy
    f.w = ww
    f.h = hh
    return win:setFrame(f)
end

-----------------------------------------------
-- hyper 1, 2 for diagonal quarter window
-----------------------------------------------
hs.hotkey.bind(hyper, "1", function() resize(0, 0, 2, 2) end)
hs.hotkey.bind(hyper, "2", function() resize(1, 0, 2, 2) end)

-----------------------------------------------
-- hyper left, right for half window
-----------------------------------------------
hs.hotkey.bind(hyper, "left", function() hs.window.focusedWindow():moveToUnit(hs.layout.left50) end)
hs.hotkey.bind(hyper, "right", function() hs.window.focusedWindow():moveToUnit(hs.layout.right50) end)

-----------------------------------------------
-- move between monitors
-----------------------------------------------
hs.hotkey.bind(hyperCtrl, "left", function() hs.window.focusedWindow():moveOneScreenWest(0) end)
hs.hotkey.bind(hyperCtrl, "right", function() hs.window.focusedWindow():moveOneScreenEast(0) end)


-----------------------------------------------
-- Hyper n to show window hints
-----------------------------------------------
hs.hotkey.bind(hyper, "n", function() hs.hints.windowHints() end)

-----------------------------------------------
-- hyper f for fullscreen, c for center
-----------------------------------------------
hs.hotkey.bind(hyper, "c", function() hs.window.focusedWindow():centerOnScreen() end)
hs.hotkey.bind(hyper, "f", function() hs.window.focusedWindow():maximize() end)