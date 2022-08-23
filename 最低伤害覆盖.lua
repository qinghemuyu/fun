--最低伤害覆盖(hold/bind)

local guiSet = gui.SetValue

local guiGet = gui.GetValue

local togglekey = input.IsButtonDown

local ref = gui.Reference("RAGEBOT");

local tab = gui.Tab(ref,"Extra","最低伤害覆盖")

local dmgsettings = gui.Groupbox(tab,"最低伤害覆盖",16,16,296,300)

local togglekey = gui.Keybox(dmgsettings, "ChangeDmgKey", "最低伤害按键绑定", 	20)

local setDmg = gui.Combobox(dmgsettings, "mindmgmode", "按键模式", "关闭", "切换", "长按",1348984838)

local awpDamage = gui.Slider(dmgsettings, "awpDamage", "AWP lowered Min Damage", 15, 0, 150)

local awpori = gui.Slider(dmgsettings, "awpori", "AWP Original Min Damage", 101, 0, 150)

local awpCheck = gui.Checkbox(dmgsettings, "awpCheck", "启用AWP最低伤害", 1)

local scoutDamage = gui.Slider(dmgsettings, "scoutDamage", "Scout lowered Min Damage", 12, 0, 150)

local scoutori = gui.Slider(dmgsettings, "scoutori", "Scout Original Min Damage", 91, 0, 150)

local scoutCheck = gui.Checkbox(dmgsettings, "scoutCheck", "启用SSG08最低伤害", 1)

local autoDamage = gui.Slider(dmgsettings, "autoDamage", "Auto lowered Min Damage", 6, 0, 150)

local autoori = gui.Slider(dmgsettings, "autoori", "Auto Original Min Damage", 32, 0, 150)

local autoCheck = gui.Checkbox(dmgsettings, "autoCheck", "启用自动最低伤害", 1)

local Toggle =-1

local pressed = false

local awp1 = 0

local scout1 = 0

local auto1 = 0

local awpmindmg = guiGet("rbot.accuracy.weapon.sniper.mindmg")

local scoutmindmg = guiGet("rbot.accuracy.weapon.scout.mindmg")

local automindmg = guiGet("rbot.accuracy.weapon.asniper.mindmg")





function changeMinDamage()

if awpCheck:GetValue() then

    awp1 = awpDamage:GetValue()

    else

    awp1 = awpori:GetValue()

    end

if scoutCheck:GetValue() then

    scout1 = scoutDamage:GetValue()

    else

    scout1 = scoutori:GetValue()

    end

if autoCheck:GetValue() then

    auto1 = autoDamage:GetValue()

    else

    auto1 = autoori:GetValue()

    end

if (setDmg:GetValue()==1) then

        if input.IsButtonPressed(togglekey:GetValue()) then

            pressed=true;

Toggle = Toggle *-1



        elseif (pressed and input.IsButtonReleased(togglekey:GetValue())) then

            pressed=false;



            if Toggle == 1 then

            guiSet("rbot.accuracy.weapon.sniper.mindmg", awp1)

            guiSet("rbot.accuracy.weapon.scout.mindmg", scout1)

            guiSet("rbot.accuracy.weapon.asniper.mindmg", auto1)

            else

        guiSet("rbot.accuracy.weapon.asniper.mindmg", autoori:GetValue())

        guiSet("rbot.accuracy.weapon.sniper.mindmg", awpori:GetValue())

        guiSet("rbot.accuracy.weapon.scout.mindmg", scoutori:GetValue())



            end

        end

    elseif (setDmg:GetValue()==2) then

        if input.IsButtonDown(togglekey:GetValue()) then

            guiSet("rbot.accuracy.weapon.sniper.mindmg", awp1)

            guiSet("rbot.accuracy.weapon.scout.mindmg", scout1)

            guiSet("rbot.accuracy.weapon.asniper.mindmg", auto1)

        else

        guiSet("rbot.accuracy.weapon.asniper.mindmg", autoori:GetValue())

        guiSet("rbot.accuracy.weapon.sniper.mindmg", awpori:GetValue())

        guiSet("rbot.accuracy.weapon.scout.mindmg", scoutori:GetValue())

        end

    elseif (setDmg:GetValue()==0) then

        Toggle = -1

        guiSet("rbot.accuracy.weapon.asniper.mindmg", autoori:GetValue())

        guiSet("rbot.accuracy.weapon.sniper.mindmg", awpori:GetValue())

        guiSet("rbot.accuracy.weapon.scout.mindmg", scoutori:GetValue())

    end

end



function Drawtext()

    w, h = draw.GetScreenSize()

if (setDmg:GetValue()==1) then

    if Toggle == 1 then

        draw.Color(0, 255, 0, 255);

    	draw.Text(5, h - 415, "Min Damage Mode On");

        if awpCheck:GetValue() then

        draw.Color(255, 255, 0, 255);

        draw.Text(5, h - 368, "Awp MinDmg On:")

        draw.TextShadow(142, h-368, guiGet("rbot.accuracy.weapon.sniper.mindmg")) 
        else

        end

        if scoutCheck:GetValue() then

        draw.Color(255, 255, 0, 255);

        draw.Text(5, h - 381, "Scout MinDmg On:") 

        draw.TextShadow(142, h - 381, guiGet("rbot.accuracy.weapon.scout.mindmg"))
        else

        end

        if autoCheck:GetValue() then

        draw.Color(255, 255, 0, 255);

        draw.Text(5, h - 394, "Auto MinDmg On: ")
        
        draw.TextShadow(142, h - 394, guiGet("rbot.accuracy.weapon.asniper.mindmg"))

        else

        end

   	 elseif Toggle == -1 then

        draw.Color(255, 0, 0, 255);

    	draw.Text(5, h - 415, "Min Damage Mode Off");

		draw.Text(5, h - 368, "Awp MinDmg Off");

		draw.TextShadow(142, h - 368, guiGet("rbot.accuracy.weapon.sniper.mindmg"))

		draw.Text(5, h - 381, "Scout MinDmg Off")

		draw.TextShadow(142, h - 381, guiGet("rbot.accuracy.weapon.scout.mindmg"))

        draw.Text(5, h - 394, "Auto MinDmg Off");		

		draw.TextShadow(142, h - 394, guiGet("rbot.accuracy.weapon.asniper.mindmg"))





    end

elseif (setDmg:GetValue()==2) then

    if input.IsButtonDown(togglekey:GetValue()) then

          draw.Color(0, 255, 0, 255);

    draw.Text(5, h - 415, "Min Damage Mode: Lowered");

        if awpCheck:GetValue() then

        draw.Color(255, 255, 0, 255);

        draw.Text(5, h - 368, "Awp MinDmg On");

		draw.Color(0, 0, 175, 255);

		draw.TextShadow(142, h-368, guiGet("rbot.accuracy.weapon.sniper.mindmg")) 

        else

        end

        if scoutCheck:GetValue() then

        draw.Color(255, 255, 0, 255);

        draw.Text(5, h - 381, "Scout MinDmg On");

		draw.Color(0, 0, 175, 255);

		draw.TextShadow(142, h-381, guiGet("rbot.accuracy.weapon.scout.mindmg"))

        else

        end

        if autoCheck:GetValue() then

        draw.Color(255, 255, 0, 255);

        draw.Text(5, h - 394, "Auto MinDmg On");

		draw.Color(0, 0, 175, 255);

		draw.TextShadow(142, h-394, guiGet("rbot.accuracy.weapon.asniper.mindmg"))

        else

        end

    else

        draw.Color(255, 0, 0, 255);

    	draw.Text(5, h - 415, "Min Damage Mode: Original");

        draw.Color(255, 0, 0, 255);

        draw.Text(5, h - 368, "Awp MinDmg Off");

		draw.Color(0, 0, 175, 255);

		draw.TextShadow(142, h - 368, guiGet("rbot.accuracy.weapon.sniper.mindmg"))

        draw.Color(255, 0, 0, 255);

		draw.Text(5, h - 381, "Scout MinDmg Off")

		draw.Color(0, 0, 175, 255);

		draw.TextShadow(142, h - 381, guiGet("rbot.accuracy.weapon.scout.mindmg"))

		draw.Color(255, 0, 0, 255);        

		draw.Text(5, h - 394, "Auto MinDmg Off");		

		draw.Color(0, 0, 175, 255);

		draw.TextShadow(142, h - 394, guiGet("rbot.accuracy.weapon.asniper.mindmg"))

    end

else

draw.Color(255, 0, 0, 255);

draw.Text(5, h - 415, "Min Damage Mode Off");

end

end

callbacks.Register("Draw", "Drawtext", Drawtext);

callbacks.Register("Draw", "changeMinDamage", changeMinDamage);