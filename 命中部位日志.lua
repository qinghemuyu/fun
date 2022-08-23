

local activeHitLogs = {};
local function HitGroup(INT_HITGROUP)
    if INT_HITGROUP == nil then
        return;
    elseif INT_HITGROUP == 0 then
        return "身体";
    elseif INT_HITGROUP == 1 then
        return "鬼头";
    elseif INT_HITGROUP == 2 then
        return "大咪咪";
    elseif INT_HITGROUP == 3 then
        return "腹部";
    elseif INT_HITGROUP == 4 then
        return "左臂";
    elseif INT_HITGROUP == 5 then
        return "右臂";
    elseif INT_HITGROUP == 6 then
        return "左腿";
    elseif INT_HITGROUP == 7 then
        return "右腿";
    elseif INT_HITGROUP == 10 then
        return "身体";
    end
end

local function add(time, ...)
    local speed = 1.5
    local r = math.floor(math.sin(globals.RealTime() * speed) * 120 + 130)
    local g = math.floor(math.sin(globals.RealTime() * speed + 2)* 120 + 130)
    local b = math.floor(math.sin(globals.RealTime() * speed + 4) * 120 + 130)
    table.insert(activeHitLogs, {
        ["text"] = { ... },
        ["time"] = time,
        ["delay"] = globals.RealTime() + time,
        ["color"] = {{r, g, b}, {16, 0, 0}},
        ["x_pad"] = -11,
        ["x_pad_b"] = -11,
    })
end

local function getMultiColorTextSize(lines)
    local fw = 0
    local fh = 0;
    for i = 1, #lines do
        local w, h = draw.GetTextSize(lines[i][4])
        fw = fw + w
        fh = h;
    end
    return fw, fh
end

local function drawMultiColorText(x, y, lines)
    local x_pad = 0
    for i = 1, #lines do
        local line = lines[i];
        local r, g, b, msg = line[1], line[2], line[3], line[4]
        draw.Color(r, g, b, 255);
        draw.Text(x + x_pad, y, msg);
        local w, _ = draw.GetTextSize(msg)
        x_pad = x_pad + w
    end
end

local function showLog(count, color, text, layer)
    local y = 15 + (42 * (count - 1));
    local w, h = getMultiColorTextSize(text)
    local mw = w < 150 and 150 or w
    if globals.RealTime() < layer.delay then
        if layer.x_pad < mw then layer.x_pad = layer.x_pad + (mw - layer.x_pad) * 0.05 end
        if layer.x_pad > mw then layer.x_pad = mw end
        if layer.x_pad > mw / 1.09 then
            if layer.x_pad_b < mw - 6 then
                layer.x_pad_b = layer.x_pad_b + ((mw - 6) - layer.x_pad_b) * 0.05
            end
        end
        if layer.x_pad_b > mw - 6 then
            layer.x_pad_b = mw - 6
        end
    else
        if layer.x_pad_b > -11 then
            layer.x_pad_b = layer.x_pad_b - (((mw - 5) - layer.x_pad_b) * 0.05) + 0.01
        end
        if layer.x_pad_b < (mw - 11) and layer.x_pad >= 0 then
            layer.x_pad = layer.x_pad - (((mw + 1) - layer.x_pad) * 0.05) + 0.01
        end
        if layer.x_pad < 0 then
            table.remove(activeHitLogs, count)
        end
    end
    local c1 = color[1]
    local c2 = color[2]
    local a = 255;
    draw.Color(c1[1], c1[2], c1[3], a);
    draw.FilledRect(layer.x_pad - layer.x_pad, y, layer.x_pad + 28, (h + y) + 20);
    draw.Color(c2[1], c2[2], c2[3], a);
    draw.FilledRect(layer.x_pad_b - layer.x_pad, y, layer.x_pad_b + 22, (h + y) + 20);
    drawMultiColorText(layer.x_pad_b - mw + 18, y + 9, text)
end

callbacks.Register('FireGameEvent', function(e)
    local en = e:GetName();
    local isHurt = en == 'player_hurt';
    local weaponFired = en == 'weapon_fire';
    if isHurt == false and weaponFired == false then
        return
    end
    local localPlayer = entities.GetLocalPlayer();
    local user = entities.GetByUserID(e:GetInt('userid'));
    if (localPlayer == nil or user == nil) then
        return;
    end
    if isHurt then
        local attacker = entities.GetByUserID(e:GetInt('attacker'));
        local remainingHealth = e:GetInt('health');
        local damageDone = e:GetInt('dmg_health');
        if (attacker == nil) then
            return;
        end
        if (localPlayer:GetIndex() == attacker:GetIndex()) then
            local r = math.floor(math.sin(globals.RealTime() * 1) * 100 + 127);
            local g = math.floor(math.sin(globals.RealTime() * 1 + 2) * 100 + 127);
            local b = math.floor(math.sin(globals.RealTime() * 1 + 4) * 100 + 127); 
            add(5,
                { r, g, b, "[𝑸𝒊𝒏𝒈𝒉𝒆'V5] " },
                {255,255,255," 击中了 "},
                { 150, 185, 1,string.sub(user:GetName(), 0, 28) },
                { 255, 255, 255, " 的 " },
                { 150, 185, 1, HitGroup(e:GetInt('hitgroup')) },
                { 255, 255, 255, " 造成 " },
                { 150, 185, 1, damageDone },
                { 255, 255, 255, " 的伤害 (剩余 " },
                { 150, 185, 1, remainingHealth },
                { 255, 255, 255, " 的血量 )" })
                
	print("[清河V5红演] 击中了 " .. user:GetName() .. " 的 " .. HitGroup(e:GetInt('hitgroup')).. " 造成 " .. damageDone .. " 的伤害 ( 剩余 "  ..remainingHealth .. " 的血量 ) " )
        end
    elseif weaponFired then
        if (localPlayer:GetIndex() == user:GetIndex() and target ~= nil) then
            -- todo implement miss shots
        end
    end
end);

callbacks.Register('Draw', function()
    for index, hitlog in pairs(activeHitLogs) do
        showLog(index, hitlog.color, hitlog.text, hitlog)
    end
end);