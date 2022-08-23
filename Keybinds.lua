local ra1 = math.floor(math.sin(globals.RealTime() * 1) * 120 + 128);
local ga1 = math.floor(math.sin(globals.RealTime() * 1 + 2) * 120 + 128);
local ba1 = math.floor(math.sin(globals.RealTime() * 1 + 4) * 100 + 128);


--var
local renderer = {}
local MENU = gui.Reference("MENU")
local font = draw.CreateFont("Verdana", 12)

local X, Y = draw.GetScreenSize()
local tX, tY, offsetX, offsetY, _drag
local DT_Wp = gui.Reference("Ragebot", "Accuracy", "Weapon")
local alpha = 0
local alpha2 = 0
local hsalpha = 0
local dtalpha = 0
local swalpha = 0
local fdalpha = 0
local lbyalpha = 0
local trgalpha = 0
local sbalpha = 0

local tick = client.GetConVar("sv_maxcmdrate") .. " tick"
local time, bTime, sTime = {0, 0, 0}, 0, 0
local divider = " | "
local cheatName = "aimware v7 [bate]"

--gui

-- --menu_assert
-- local function get_value(varname)
--     gui.GetValue(varname)
-- end
-- local function menu_assert(varname)
--     local Element = pcall(get_value, varname)
--     return Element
-- end

-- local reference = gui.Reference("Misc", "General", "Extra")
-- if menu_assert("adv.open.semenu.key") then
--     reference = gui_custom_Visuals_Reference
--     MENU = gui_custom_SenseUI_Reference
-- end

local Ref =  gui.Reference("Misc", "General", "Extra")
local keybinds = gui.Checkbox(Ref, "keyingsind", "Show Keyings", 1)
local watermark = gui.Checkbox(Ref, "watermark", "Show Watermark", 1)
local keybinds_rgb = gui.Checkbox(keybinds, "rgb", "rgb", 0)
local watermark_rgb = gui.Checkbox(watermark, "rgb", "rgb", 0)
--clr
local keybinds_clr = gui.ColorPicker(keybinds, "clr2", "clr2", ra1, ga1, ba1, 255)
local keybinds_clr2 = gui.ColorPicker(keybinds, "clr", "clr", 0, 0, 0, 100)
local watermark_clr = gui.ColorPicker(watermark, "clr", "clr", 131, 109, 221, 255)
local watermark_clr2 = gui.ColorPicker(watermark, "clr2", "clr", 0, 0, 0, 100)
--x,y
local keybinds_x = gui.Slider(keybinds, "x", "x", 400, 0, X)
local keybinds_y = gui.Slider(keybinds, "y", "y", 400, 0, Y)
local watermark_x = gui.Slider(watermark, "x", "x", 1900, 0, X)
local watermark_y = gui.Slider(watermark, "y", "y", 10, 0, Y)
--set
keybinds:SetDescription("Displays the active binding key.")
watermark:SetDescription("Shows watermark AIMWARE.net.")
keybinds_rgb:SetInvisible(true)
watermark_rgb:SetInvisible(true)
keybinds_x:SetInvisible(true)
keybinds_y:SetInvisible(true)
watermark_x:SetInvisible(true)
watermark_y:SetInvisible(true)

--function

--menu_assert
local function get_value(varname)
    gui.GetValue(varname)
end
local function menu_assert(varname)
    local Element = pcall(get_value, varname)
    return Element
end

--Mouse drag
local function is_inside(a, b, x, y, w, h)
    return a >= x and a <= w and b >= y and b <= h
end

local function drag_menu(x, y, w, h)
    if not MENU:IsActive() then
        return tX, tY
    end
    local mouse_down = input.IsButtonDown(1)
    if mouse_down then
        local X, Y = input.GetMousePos()
        if not _drag then
            local w, h = x + w, y + h
            if is_inside(X, Y, x, y, w, h) then
                offsetX, offsetY = X - x, Y - y
                _drag = true
            end
        else
            tX, tY = X - offsetX, Y - offsetY
            keybinds_x:SetValue(tX)
            keybinds_y:SetValue(tY)
        end
    else
        _drag = false
    end
    return tX, tY
end

--renderer text
renderer.text = function(x, y, clr, shadow, string, font, flags)
    local alpha = 255
    if font then
        draw.SetFont(font)
    end
    local textW, textH = draw.GetTextSize(string)
    if clr[4] then
        alpha = clr[4]
    end
    if flags == "l" then
        x = x - textW
    elseif flags == "r" then
        x = x + textW
    elseif flags == "lc" then
        x = x - (textW / 2)
    elseif flags == "rc" then
        x = x + (textW / 2)
    end
    if shadow then
        draw.Color(0, 0, 0, alpha)
        draw.Text(x + 1, y + 1, string)
    end
    draw.Color(clr[1], clr[2], clr[3], alpha)
    draw.Text(x, y, string)
end

--renderer rectangle
renderer.rectangle = function(x, y, w, h, clr, fill, radius)
    local alpha = 255
    if clr[4] then
        alpha = clr[4]
    end
    draw.Color(clr[1], clr[2], clr[3], alpha)
    if fill then
        draw.FilledRect(x, y, x + w, y + h)
    else
        draw.OutlinedRect(x, y, x + w, y + h)
    end
    if fill == "s" then
        draw.ShadowRect(x, y, x + w, y + h, radius)
    end
end

--renderer gradient
renderer.gradient = function(x, y, w, h, clr, clr1, vertical)
    local r, g, b, a = clr1[1], clr1[2], clr1[3], clr1[4]
    local r1, g1, b1, a1 = clr[1], clr[2], clr[3], clr[4]

    if a and a1 == nil then
        a, a1 = 255, 255
    end

    if vertical then
        if clr[4] ~= 0 then
            if a1 and a ~= 255 then
                for i = 0, w do
                    renderer.rectangle(x, y + w - i, w, 1, {r1, g1, b1, i / w * a1}, true)
                end
            else
                renderer.rectangle(x, y, w, h, {r1, g1, b1, a1}, true)
            end
        end
        if a2 ~= 0 then
            for i = 0, h do
                renderer.rectangle(x, y + i, w, 1, {r, g, b, i / h * a}, true)
            end
        end
    else
        if clr[4] ~= 0 then
            if a1 and a ~= 255 then
                for i = 0, w do
                    renderer.rectangle(x + w - i, y, 1, h, {r1, g1, b1, i / w * a1}, true)
                end
            else
                renderer.rectangle(x, y, w, h, {r1, g1, b1, a1}, true)
            end
        end
        if a2 ~= 0 then
            for i = 0, w do
                renderer.rectangle(x + i, y, 1, h, {r, g, b, i / w * a}, true)
            end
        end
    end
end

--alpha
local function alpha_stop(val, min, max)
    if val < min then
        return min
    end
    if val > max then
        return max
    end
    return val
end

--rgb http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c
local function hue2rgb(p, q, t)
    if (t < 0) then
        t = t + 1
    end
    if (t > 1) then
        t = t - 1
    end
    if (t < 1 / 6) then
        return p + (q - p) * 6 * t
    end
    if (t < 1 / 2) then
        return q
    end
    if (t < 2 / 3) then
        return p + (q - p) * (2 / 3 - t) * 6
    end
    return p
end
local function hslToRgb(h, s, l)
    local r, g, b

    if (s == 0) then
        r = l
        g = l
        b = l
    else
        local q = 0
        if (l < 0.5) then
            q = l * (1 + s)
        else
            q = l + s - l * s
        end

        local p = 2 * l - q

        r = hue2rgb(p, q, h + 1 / 3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1 / 3)
    end
    return {r * 255, g * 255, b * 255}
end

local function clamp(val, min, max)
    if (val > max) then
        return max
    elseif (val < min) then
        return min
    else
        return val
    end
end

--Get the correct name of the weapon
local function menu_weapon(var)
    local ws = string.match(var, [["(.+)"]])
    if ws == "Heavy Pistol" then
        ws = "hpistol"
    elseif ws == "Auto Sniper" then
        ws = "asniper"
    elseif ws == "Submachine Gun" then
        ws = "smg"
    elseif ws == "Light Machine Gun" then
        ws = "lmg"
    end
    local wp = string.lower(ws)
    return wp
end

--split string
local function split_string(inputstr, sep)
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

--Let drag position save
local function position_save()
    local x = keybinds_x:GetValue()
    local y = keybinds_y:GetValue()
    if tX ~= x or tY ~= y then
        tX = x
        tY = y
    end
end

--On draw Keybinds
local function OnKeybinds()
    local wid = entities.GetLocalPlayer():GetWeaponID()

    local x, y = drag_menu(tX, tY, 120, 30)
    local r, g, b, a = 255, 255, 255, 255
    local rgb = hslToRgb((globals.CurTime() / clamp(100 - 90, 1, 100)) % 1, 1, 0.5)
    local r2, g2, b2, a2 = keybinds_clr:GetValue()
    local r3, g3, b3, a3 = keybinds_clr2:GetValue()
    local fade_factor = ((1.0 / 0.15) * globals.FrameTime()) * 250
    local i = 0
    local xi = 0

    local DT_Wp = menu_weapon(DT_Wp:GetValue())
    local rbot_m = gui.GetValue("rbot.master")
    local onshot = gui.GetValue("rbot.antiaim.condition.shiftonshot")
    local lby = gui.GetValue("rbot.antiaim.base.lby")
    local sw_key = gui.GetValue("rbot.accuracy.movement.slowkey")
    local fd_key = gui.GetValue("rbot.antiaim.extra.fakecrouchkey")

    local lbot_m = gui.GetValue("lbot.master")
    local trg = gui.GetValue("lbot.trg.enable")
    local trg_key = gui.GetValue("lbot.trg.key")
    local trg_auto = gui.GetValue("lbot.trg.autofire")

    local misc_m = gui.GetValue("misc.master")
    local sb = gui.GetValue("misc.speedburst.enable")
    local sb_key = gui.GetValue("misc.speedburst.key")

    if rbot_m and onshot then
        hsalpha = alpha_stop(hsalpha + fade_factor, 0, a)
    else
        hsalpha = alpha_stop(hsalpha - fade_factor, 0, a)
    end

    if
        rbot_m and
            (wid == 1 or wid == 2 or wid == 3 or wid == 4 or wid == 30 or wid == 32 or wid == 36 or wid == 61 or wid == 63 or wid == 7 or wid == 8 or
                wid == 10 or
                wid == 13 or
                wid == 16 or
                wid == 39 or
                wid == 60 or
                wid == 11 or
                wid == 38 or
                wid == 17 or
                wid == 19 or
                wid == 23 or
                wid == 24 or
                wid == 26 or
                wid == 33 or
                wid == 34 or
                wid == 14 or
                wid == 28 or
                wid == 25 or
                wid == 27 or
                wid == 29 or
                wid == 35) and
            gui.GetValue("rbot.accuracy.weapon." .. DT_Wp .. ".doublefire") > 0
     then
        dtalpha = alpha_stop(dtalpha + fade_factor, 0, a)
    else
        dtalpha = alpha_stop(dtalpha - fade_factor, 0, a)
    end

    if rbot_m and sw_key ~= 0 and input.IsButtonDown(sw_key) then
        swalpha = alpha_stop(swalpha + fade_factor, 0, a)
    else
        swalpha = alpha_stop(swalpha - fade_factor, 0, a)
    end

    if rbot_m and fd_key ~= 0 and input.IsButtonDown(fd_key) then
        fdalpha = alpha_stop(fdalpha + fade_factor, 0, a)
    else
        fdalpha = alpha_stop(fdalpha - fade_factor, 0, a)
    end

    if rbot_m and lby < 0 then
        lbyalpha = alpha_stop(lbyalpha + fade_factor, 0, a)
    else
        lbyalpha = alpha_stop(lbyalpha - fade_factor, 0, a)
    end

    if lbot_m and trg and trg_key ~= 0 and input.IsButtonDown(trg_key) then
        trgalpha = alpha_stop(trgalpha + fade_factor, 0, a)
    elseif lbot_m and trg and trg_auto then
        trgalpha = alpha_stop(trgalpha + fade_factor, 0, a)
    else
        trgalpha = alpha_stop(trgalpha - fade_factor, 0, a)
    end

    if misc_m and sb and sb_key ~= 0 and input.IsButtonDown(sb_key) then
        sbalpha = alpha_stop(sbalpha + fade_factor, 0, a)
    else
        sbalpha = alpha_stop(sbalpha - fade_factor, 0, a)
    end

    if lbyalpha ~= 0 then
        xi = 20
        renderer.text(x + 5, y + 25 + i, {r, g, b, lbyalpha}, true, "Anti-aim inverter", font)
        renderer.text(x + 80 + xi, y + 25 + i, {r, g, b, lbyalpha}, true, "[toggled]", font)
        i = i + 15
    end

    if hsalpha ~= 0 then
        renderer.text(x + 5, y + 25 + i, {r, g, b, hsalpha}, true, "Hide shots", font)
        renderer.text(x + 80 + xi, y + 25 + i, {r, g, b, hsalpha}, true, "[toggled]", font)
        i = i + 15
    end

    if dtalpha ~= 0 then
        renderer.text(x + 5, y + 25 + i, {r, g, b, dtalpha}, true, "Double fire", font)
        renderer.text(x + 80 + xi, y + 25 + i, {r, g, b, dtalpha}, true, "[toggled]", font)
        i = i + 15
    end

    if swalpha ~= 0 then
        renderer.text(x + 5, y + 25 + i, {r, g, b, swalpha}, true, "Slow walk", font)
        renderer.text(x + 80 + xi, y + 25 + i, {r, g, b, swalpha}, true, "[holding]", font)
        i = i + 15
    end

    if fdalpha ~= 0 then
        renderer.text(x + 5, y + 25 + i, {r, g, b, fdalpha}, true, "Fake duck", font)
        renderer.text(x + 80 + xi, y + 25 + i, {r, g, b, fdalpha}, true, "[holding]", font)
        i = i + 15
    end

    if trgalpha ~= 0 then
        renderer.text(x + 5, y + 25 + i, {r, g, b, trgalpha}, true, "Trigger", font)
        renderer.text(x + 80 + xi, y + 25 + i, {r, g, b, trgalpha}, true, "[holding]", font)
        i = i + 15
    end

    if sbalpha ~= 0 then
        renderer.text(x + 5, y + 25 + i, {r, g, b, sbalpha}, true, "Speed burst", font)
        renderer.text(x + 80 + xi, y + 25 + i, {r, g, b, sbalpha}, true, "[holding]", font)
        i = i + 15
    end

    if i > 0 or MENU:IsActive() then
        alpha = alpha_stop(alpha + fade_factor, 0, 255)
    else
        alpha = alpha_stop(alpha - fade_factor, 0, 255)
    end

    if xi ~= 0 then
        alpha2 = alpha_stop(alpha2 + fade_factor, 0, 60)
    else
        alpha2 = alpha_stop(alpha2 - fade_factor, 0, 60)
    end

    renderer.rectangle(x, y + 2, 130 + alpha2 * 0.3, 18, {r3, g3, b3, alpha * a3 / 255}, true)
    renderer.rectangle(x, y, 130 + alpha2 * 0.3, 2, {ra1, ga1, ba1, alpha * a2 / 255}, true)
    renderer.text(x + 45 + (alpha2 * 0.3 * 0.5), y + 5, {255, 255, 255, alpha}, true, "keybinds", font)

    if keybinds_rgb:GetValue() then
        renderer.gradient(x, y, 129 + alpha2 * 0.3, 2, {rgb[1], rgb[2], rgb[3], alpha}, {rgb[2], rgb[3], rgb[1], alpha}, false)
    end
end

--time
-- callbacks.Register(
--     "Draw",
--     "getTime",
--     function()
--         if sTime == 0 or ((sTime + 1200 < common.Time()) and (entities.GetLocalPlayer() == nil or not entities.GetLocalPlayer():IsAlive())) then
--             local data = http.Get("http://time.tianqi.com/")
--             local data = string.match(data, [[<p id="local">(.-)</p>]])

--             if data ~= nil then
--                 for i, str in pairs(split_string(string.match(data, [[ (........)]]), ":")) do
--                     time[i] = tonumber(str)
--                 end
--                 sTime = common.Time()
--             end
--             bTime = common.Time()
--         end
--         time[3] = time[3] + common.Time() - bTime
--         bTime = common.Time()
--         if time[3] >= 60 then
--             time[2], time[3], bTime = time[2] + 1, 0, common.Time()
--         end
--         if time[2] >= 60 then
--             time[1], time[2] = time[1] + 1, 0
--         end
--         if time[1] >= 24 then
--             time[1] = 0
--         end
--     end
-- )

--On draw Watermark
local function OnWatermark()
    local lp = entities.GetLocalPlayer()
    local pr = entities.GetPlayerResources()

    local server
    local delay
    local indexlp = client.GetLocalPlayerIndex()
    local userName = client.GetPlayerNameByIndex(indexlp)
    local time =
        string.format(
        " %s:%s:%s",
        time[1] < 10 and "0" .. math.floor(time[1]) or math.floor(time[1]),
        time[2] < 10 and "0" .. math.floor(time[2]) or math.floor(time[2]),
        time[3] < 10 and "0" .. math.floor(time[3]) or math.floor(time[3])
    )

    if lp then
        delay = "delay: " .. pr:GetPropInt("m_iPing", lp:GetIndex()) .. "ms"
        server = engine.GetServerIP()
    else
        userName = client.GetConVar("name")
    end

    local watermarkText = cheatName .. divider .. userName .. divider

    if server ~= nil then
        if (server == "loopback") then
            server = "localhost"
        elseif string.find(server, "A") then
            server = "valve"
        end
        watermarkText = watermarkText .. server .. divider
    end

    if delay ~= nil then
        watermarkText = watermarkText .. delay .. divider
    end

    if lp then
        watermarkText = watermarkText .. tick .. divider
    end

    local watermarkText = watermarkText .. os.date('%X')

    draw.SetFont(font)
    local w, h = draw.GetTextSize(watermarkText)
    local x, y = watermark_x:GetValue(), watermark_y:GetValue()
    local x = x - w
    local r, g, b, a = 255, 255, 255, 255
    local r2, g2, b2, a2 = watermark_clr:GetValue()
    local r3, g3, b3, a3 = watermark_clr2:GetValue()
    local rgb = hslToRgb((globals.CurTime() / clamp(100 - 95, 1, 100)) % 1, 1, 0.5)

    renderer.rectangle(x, y + 2, w + 10, 18, {r3, g3, b3, a3}, true)

    if watermark_rgb:GetValue() then
        renderer.gradient(x, y, w + 9, 2, {rgb[1], rgb[2], rgb[3], 255}, {rgb[2], rgb[3], rgb[1], 255}, nil)
    else
        renderer.rectangle(x, y, w + 10, 2, {r2, g2, b2, a2}, true)
    end

    renderer.text(x + 5, y + 6, {r, g, b, a}, nil, watermarkText, font)
    renderer.text(x + 5, y + 6, {r, g, b, a}, nil, watermarkText, font)
end

--Callbacks
callbacks.Register(
    "Draw",
    function()
        if entities.GetLocalPlayer() and keybinds:GetValue() then
            position_save()
            OnKeybinds()
        end

        if watermark:GetValue() then
            OnWatermark()
        end
    end
)

--end
