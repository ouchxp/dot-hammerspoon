local caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
    caffeine:setIcon(state and "caffeine-on.pdf" or "caffeine-off.pdf")
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end