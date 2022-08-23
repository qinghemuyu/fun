local rain_alpha = 0
local visualsRef = gui.Reference("VISUALS")
local visualTab = gui.Tab(visualsRef, "visualTab", "Rain Stuff")
local mainGroup = gui.Groupbox(visualTab, "Main Settings", 16,16,296,100)
local rainSpeed = gui.Slider(mainGroup, "rainSpeed", "Rain Speed", 700, 500, 2500)
local colorPickerBar = gui.ColorPicker(mainGroup, "mainCol", "Rain Colour",  255, 255, 255, rain_alpha - 75)

--var
local background_alpha = 0
local rain = {}
local time = 0
local stored_time = 0
local screen = {draw.GetScreenSize()}

--function
local function clamp(min, max, val)
    if val > max then return max end
    if val < min then return min end
    return val
end

local function draw_rain(x, y, size)
    local base = 4 + size
    draw.Color(gui.GetValue("esp.visualTab.mainCol"))
    draw.Line(x, y - base, x, y + base + 1)
end

local function OnRender()

    local frametime = globals.FrameTime()
    time = time + frametime

    if background_alpha ~= 255 then
        background_alpha = clamp(0, 255, background_alpha + 10)
        rain_alpha = clamp(0, 255, rain_alpha + 10)
    end

    if not background_alpha ~= 0 then
        background_alpha = clamp(0, 255, background_alpha - 10)
        rain_alpha = clamp(0, 255, rain_alpha - 10)
    end

    if #rain < 128 then
        if time > stored_time then
            stored_time = time

            table.insert(rain, {
                math.random(10, screen[1] - 10),
                1,
                math.random(1, 3),
                math.random(-60, 60) / 100,
                math.random(-3, 0)
            })
        end
    end

    local fps = 1 / frametime

    for i = 1, #rain do
        local rain = rain[i]
        local x, y, vspeed, hspeed, size = rain[1], rain[2], rain[3], rain[4], rain[5]

        if screen[2] <= y then
            rain[1] = math.random(10, screen[1] - 10)
            rain[2] = 1
            rain[3] = math.random(1, 3)
            rain[4] = math.random(-60, 60) / 100
            rain[5] = math.random(-3, 0)
        end

        draw_rain(x, y, size)

        rain[2] = rain[2] + vspeed / fps * gui.GetValue("esp.visualTab.rainSpeed")
        rain[1] = rain[1] + hspeed / fps * gui.GetValue("esp.visualTab.rainSpeed")
    end
    
end
callbacks.Register("Draw", OnRender)