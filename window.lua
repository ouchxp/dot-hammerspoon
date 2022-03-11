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
top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 }
bottom50      = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 }
hs.hotkey.bind(hyper, "left", function() hs.window.focusedWindow():moveToUnit(hs.layout.left50) end)
hs.hotkey.bind(hyper, "right", function() hs.window.focusedWindow():moveToUnit(hs.layout.right50) end)
hs.hotkey.bind(hyperCtrl, "up", function() hs.window.focusedWindow():moveToUnit(top50) end)
hs.hotkey.bind(hyperCtrl, "down", function() hs.window.focusedWindow():moveToUnit(bottom50) end)

-----------------------------------------------
-- move between monitors
-----------------------------------------------
hs.hotkey.bind(hyperCtrl, "right", function()
    local win = hs.window.focusedWindow()
    local screen = win:screen()
    win:move(win:frame():toUnitRect(screen:frame()), screen:previous(), true, 0)
  end)

hs.hotkey.bind(hyperCtrl, "left", function()
    local win = hs.window.focusedWindow()
    local screen = win:screen()
    win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
  end)

-----------------------------------------------
-- Hyper n to show window hints
-----------------------------------------------
hs.hotkey.bind(hyper, "n", function() hs.hints.windowHints() end)

-----------------------------------------------
-- hyper f for fullscreen, c for center
-----------------------------------------------
hs.hotkey.bind(hyper, "c", function() hs.window.focusedWindow():centerOnScreen() end)
hs.hotkey.bind(hyper, "f", function()
    local w = hs.window.focusedWindow()
    if w:application():name() == "Emacs" then
        hs.eventtap.keyStroke({"alt"}, "F10")
    else
        w:maximize(0)
    end
end)
