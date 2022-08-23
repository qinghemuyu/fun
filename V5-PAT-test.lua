
--


local GROUPBOX_MAIN=gui.Groupbox(gui.Reference("Ragebot", "Anti-aim"), "合法AA", 100, 100)
local KEYBOX_INVERTER=gui.Keybox(GROUPBOX_MAIN, "inverter", "切换方向",70)
local KEYBOX_ONUSEKEY=gui.Keybox(GROUPBOX_MAIN,"onuse", "抬头切换合法AA",69)
local KEYBOX_LEFTKEY=gui.Keybox(GROUPBOX_MAIN,"left", "左",90)
local KEYBOX_RIGHTKEY=gui.Keybox(GROUPBOX_MAIN,"right", "右",67)
local KEYBOX_BackKEY=gui.Keybox(GROUPBOX_MAIN,"Back","背身",88)
KEYBOX_INVERTER:SetDescription("按键绑定")
local font = draw.CreateFont('Verdana', 35, 100)
local w, h = draw.GetScreenSize()--获取屏幕相对定位

--水印
local FONT = draw.CreateFont("Verdana", 30, 400)
callbacks.Register( "Draw", function()
local screenW, screenH = draw.GetScreenSize()
local r = math.floor(math.sin(globals.RealTime() * 1) * 100 + 127);
local g = math.floor(math.sin(globals.RealTime() * 1 + 2) * 100 + 127);
local b = math.floor(math.sin(globals.RealTime() * 1 + 4) * 100 + 127); 
draw.SetFont(FONT)
draw.Color(r, g, b, 255);

draw.TextShadow(0, screenH - 200, "Cfg by Qinghe" )
draw.TextShadow(0, screenH - 250, "QQ：1348984838" )
end)


callbacks.Register("Draw",function()

    --draw.SetFont(FONT)
    local r = math.floor(math.sin(globals.RealTime() * 1) * 100 + 127);
    local g = math.floor(math.sin(globals.RealTime() * 1 + 2) * 100 + 127);
    local b = math.floor(math.sin(globals.RealTime() * 1 + 4) * 100 + 127); 
    draw.Color(255,255,255,255)
    draw.Text(5,5,"Test -by ")
    draw.Color(r,g,b)
    draw.Text( 60, 5,"Qinghe" )
end)


---------------------AA指示器
local CHECKBOX_ALL = gui.Checkbox(GROUPBOX_MAIN, "IndicatorsALL", "指示器", 1)
function arrow()
    local r = math.floor(math.sin(globals.RealTime() * 1) * 120 + 128);
    local g = math.floor(math.sin(globals.RealTime() * 1 + 2) * 120 + 128);
    local b = math.floor(math.sin(globals.RealTime() * 1 + 4) * 100 + 128);
    if not entities.GetLocalPlayer() or not entities.GetLocalPlayer():IsAlive() then return end
    if not gui.GetValue( "rbot.master" ) then return end
    draw.SetFont( font )
        if CHECKBOX_ALL:GetValue() then
            if invrtr then
                draw.Color(r, g, b, 255)
                draw.Text(w/2-50-20, h/2.05-5, "<")
            else
                draw.Color(r, g, b, 255)
                draw.Text(w/2+30+20 , h/2.05-5, ">") 
            end
        end
    
    end
    callbacks.Register("Draw", "semiragehelper", arrow)

callbacks.Register("Draw", function()
        local x,y = draw.GetScreenSize();
        local r = math.floor(math.sin(globals.RealTime() * 1) * 120 + 128);
        local g = math.floor(math.sin(globals.RealTime() * 1 + 2) * 120 + 128);
        local b = math.floor(math.sin(globals.RealTime() * 1 + 4) * 100 + 128);
        draw.Color(r, g, b, 255);
        draw.FilledRect(0, 0, x, 2);
end)

---------------------------默认RageAA方向
function finverter()
    gui.SetValue( "rbot.antiaim.advanced.pitch", 2)

    if KEYBOX_INVERTER:GetValue() ~= 0 then
        if input.IsButtonPressed(KEYBOX_INVERTER:GetValue()) then
            invrtr = not invrtr
        end
        if invrtr then
            
            gui.SetValue("rbot.antiaim.base",172)
            gui.SetValue( "rbot.antiaim.base.rotation", 58 )
            gui.SetValue( "rbot.antiaim.base.lby", -126 )
        else
            gui.SetValue("rbot.antiaim.base", -172)
            gui.SetValue( "rbot.antiaim.base.rotation", -58 )
            gui.SetValue( "rbot.antiaim.base.lby", 126 )
        end
    end
end

callbacks.Register("Draw", "semiragehelper", finverter)


--合法AA切换以及合法AA左右切换
function leftAAbot()
    local r = math.floor(math.sin(globals.RealTime() * 1) * 120 + 128);
    local g = math.floor(math.sin(globals.RealTime() * 1 + 2) * 120 + 128);
    local b = math.floor(math.sin(globals.RealTime() * 1 + 4) * 100 + 128);
    draw.Color(0, 0, 0, 255);
    draw.Text(w/2+22, h/2.05+15, "Max")--自定义准星下水印
    draw.Color( r, g, b)
    draw.Text(w/2, h/2.05+15, "Qln")
    if KEYBOX_ONUSEKEY:GetValue() ~= 0 then
        if input.IsButtonPressed(KEYBOX_ONUSEKEY:GetValue()) then
            onuse = not onuse
        end
    
        if onuse then
            draw.Color( 0, 0, 0)
            draw.Text(w/2, h/2.05+30, "RageAA")--显示当前AA模式
        else 
            gui.SetValue( "rbot.antiaim.advanced.pitch", off)
            draw.Color( 0, 0, 0)
            draw.Text(w/2, h/2.05+30, "LegitAA")
                if invrtr then
                    gui.SetValue("rbot.antiaim.base", 0)
                    gui.SetValue( "rbot.antiaim.base.rotation", -58 )
                    gui.SetValue( "rbot.antiaim.base.lby", 52 )
                else
                    gui.SetValue("rbot.antiaim.base",0)
                    gui.SetValue( "rbot.antiaim.base.rotation", 58 )
                    gui.SetValue( "rbot.antiaim.base.lby", -52 )
                end
            end
        end
    end
callbacks.Register("Draw", "semiragehelper", leftAAbot)

--左藏头
function leftBot()

    if KEYBOX_LEFTKEY:GetValue() ~= 0 then
        if input.IsButtonPressed(KEYBOX_LEFTKEY:GetValue()) then
            left = not left
        end
        
        if left then

            gui.SetValue("rbot.antiaim.base", 118)
            draw.Color( 0, 0, 0)
            draw.Text(w/2, h/2.05+45, "<-左")
        else 
        
            end
        end
    end
callbacks.Register("Draw", "LfetBotAA", leftBot)
--右藏头
function rightBot()
    
    if KEYBOX_RIGHTKEY:GetValue() ~= 0 then
        if input.IsButtonPressed(KEYBOX_RIGHTKEY:GetValue()) then
            right = not right
        end
        
        if right then

            gui.SetValue("rbot.antiaim.base", -75)
            draw.Color( 0, 0, 0)
            draw.Text(w/2, h/2.05+45, "右->") 
        else 
           
            end
        end
    end

callbacks.Register("Draw", "RightborAA", rightBot)

--背身AA
function BackBot()
    
    if KEYBOX_BackKEY:GetValue() ~= 0 then
        if input.IsButtonPressed(KEYBOX_BackKEY:GetValue()) then
            Back = not Back
        end
        
        if Back then
            gui.SetValue("rbot.antiaim.base", 172)
            draw.Color( 0, 0, 0)
            draw.Text(w/2, h/2.05+45, "背身") 
        else 
           
            end
        end
    end

callbacks.Register("Draw", "semiragehelper", BackBot)

--draw Weapon
callbacks.Register("Draw",function()
    local Weapon=gui.GetValue('rbot.accuracy.weapon')
    if Weapon == '"Sniper"' then
        Weapon = "AWP"
    elseif Weapon=='"Scout"'then
        Weapon="Scout"
    elseif Weapon=='"Heavy Pistol"'then
        Weapon="Heavy Pistol"
    elseif Weapon=='"Pistol"'then
        Weapon="Pistol"
    elseif Weapon=='"Rifle"'then
        Weapon="Rifle"
    elseif Weapon=='"Zeus"'then
        Weapon="Zeus"
    elseif Weapon=='"Submachine Gun"'then
        Weapon="SMG"
    elseif Weapon=='"Shotgun"'then
        Weapon="SG"
    elseif Weapon=='"Light Machine Gun"'then
        Weapon="LMG"
    elseif Weapon=='"Auto Sniper"'then
        Weapon="Auto-SR"
    end
    draw.Color( 0, 255, 255)
    draw.Text(w/2-55, h/2-55,"Weapon: ")
    draw.Color( 225,255,255)
    draw.Text( w/2+5, h/2-55, Weapon )
    local weaponapi = gui.Reference("Ragebot", "Accuracy", "Weapon")
    local function ApiWeapon(var)
        local Weapon_selection = string.match(var, [["(.+)"]])
        if Weapon_selection == "Heavy Pistol" then
            Weapon_selection = "hpistol"
        elseif Weapon_selection == "Auto Sniper" then
            Weapon_selection = "asniper"
        elseif Weapon_selection == "Submachine Gun" then
            Weapon_selection = "Smg"
        elseif Weapon_selection == "Light Machine Gun" then
            Weapon_selection = "Lmg"
        end
        local Weapon = string.lower(Weapon_selection)
        return Weapon
    end
    local Weapon2 = ApiWeapon(weaponapi:GetValue())
    local mindmg = gui.GetValue("rbot.accuracy.weapon." .. Weapon2 .. ".mindmg")
    local hitchance = gui.GetValue("rbot.accuracy.weapon." .. Weapon2 .. ".hitchance")
    draw.Color( 255, 255, 255)
    draw.Text(w/2+5, h/2-30,"DMG: "..mindmg)
    draw.Color( 255, 255, 255)
    draw.Text(w/2-55, h/2-30,"HIT: "..hitchance)
end)


















































































































































































































































































































--Qinghe
--Q1348984838




















































































































































































































































































































































































































































































































































































































































--CFG BY QINGHE
--QQ1348984838