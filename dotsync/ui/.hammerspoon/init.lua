-- Variables
wifiWatcher = nil
homeSSID = "huement"
lastSSID = hs.wifi.currentNetwork()
mouseCircle = nil
mouseCircleTimer = nil

-- Functions 
function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We just joined our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(25)
    elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        -- We just departed our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(0)
    end

    lastSSID = newSSID
end

--
-- Auto reload configuration
--
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

function mouseHighlight()
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition()
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Set a timer to delete the circle after 3 seconds
    mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)
end

function itunesArtist()
  ok,result = hs.applescript('tell Application "iTunes" to artist of the current track as string')
  hs.alert.show(result)
end

function windowGroup(wVar)
  local laptopScreen = "Color LCD"
  local windowLayout = {
    {"Chrome",  nil,          laptopScreen, hs.layout.left50,    nil, nil},
    {"Finder",    nil,          laptopScreen, hs.layout.right50,   nil, nil},
    {"iTunes",  "iTunes",     laptopScreen, hs.layout.maximized, nil, nil},
    {"iTunes",  "MiniPlayer", laptopScreen, nil, nil, hs.geometry.rect(0, -48, 400, 48)},
  }
  hs.layout.apply(windowLayout[wVar])
end

-- Kick it off
hs.hotkey.bind({"cmd","alt","shift"}, "D", mouseHighlight)

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()
