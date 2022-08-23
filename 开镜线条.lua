
local function rect(x, y, w, h, col)
    draw.Color(col[1], col[2], col[3], col[4]);
    draw.FilledRect(x, y, x + w, y + h);
end

local function gradientH(x1, y1, x2, y2,col1, left)
    local w = x2 - x1
    local h = y2 - y1
 
    for i = 0, w do
        local a = (i / w) * col1[4]
        local r, g, b = col1[1], col1[2], col1[3], col1[4];
        draw.Color(r, g, b, a)
        if left then
            draw.FilledRect(x1 + i, y1, x1 + i + 1, y1 + h)
        else
            draw.FilledRect(x1 + w - i, y1, x1 + w - i + 1, y1 + h)
        end
    end
end

local function gradientV( x, y, w, h, col1,down )

    local r, g, b ,a= col1[1], col1[2], col1[3], col1[4];
    for i = 1, h do
        local a = i / h * col1[4];
        if down then
            rect(x, y + i,w, 1, { r, g, b, a });
        else
            rect(x, y - i,w, 1, { r, g, b, a });
        end
    end
end

local function draw_GradientRect(x, y, w, h, dir, col1, col2)

    local r, g, b, a= col1[1], col1[2], col1[3], col1[4]; 
    local r2, g2, b2, a2= col2[1], col2[2], col2[3], col2[4]; 
    if dir == 0  then   
    gradientV(x, y, w, h, {r2, g2, b2, a2} , true)
    gradientV(x, y + h, w, h, {r, g, b, a} , false)
    elseif dir == 1  then
    gradientH(x, y, w + x, h + y, {r, g, b ,a} , true)
    gradientH(x, y, w + x, h + y, {r2, g2, b2 ,a2} , false)
    elseif dir ~= 1 or 0 then
        print("GradientRect:Unexpected characters '"..dir.."' (Please use it 0 or 1)")
    end

end

function drawshit()
    local localplayer = entities.GetLocalPlayer()
    local wpn = localplayer:GetPropEntity("m_hActiveWeapon")
    local is_scoped = wpn:GetPropBool("m_zoomLevel")

    local width, height = draw.GetScreenSize();
	
	    local offset, initial_position =
        overlay_offset:GetValue() * height / 1080, 
        overlay_position:GetValue() * height / 1080
	
	local r,g,b,a = cpicker:GetValue()
	
    if not cscope:GetValue() then return end
    if is_scoped == true then
	

		draw_GradientRect(width / 2 - initial_position, height / 2, initial_position - offset, 1, 1,{r, g, b, a}, { 0,0,0,0})-- left
		draw_GradientRect(width/2 + offset, height / 2, initial_position - offset, 1, 1,{0,0,0,0}, { r,g,b,a}) -- right


		draw_GradientRect(width / 2, height/2 - initial_position, 1, initial_position - offset, 0, {0, 0, 0, 0}, {r, g, b, a})-- up
		draw_GradientRect(width / 2, height/2 + offset, 1, initial_position - offset, 0,{r, g, b, a}, { 0,0,0,0})-- bottom
	
    end
end

function scopeoverlay(lol)
    local localplayer = entities.GetLocalPlayer()
    local is_scoped = localplayer:GetPropBool("m_bIsScoped")

    if is_scoped == false then return end
    if not cscope:GetValue() then return end
    if is_scoped == true then
        local scoped = localplayer:SetPropBool(false, "m_bIsScoped")
    end
end

function UI()
    cscope = gui.Checkbox(gui.Reference("Visuals","Overlay", "Weapon"), "cscope", "Custom Scope Overlay", true)
    cpicker = gui.ColorPicker(gui.Reference("Visuals","Overlay", "Weapon"), "cpicker", "Overlay Color", 255, 255, 255, 255)
	overlay_position = gui.Slider( gui.Reference("Visuals","Overlay", "Weapon"), "overlay_position", "Position", 180, 0, 500 )
	overlay_offset = gui.Slider( gui.Reference("Visuals","Overlay", "Weapon"), "overlay_offset", "Offset", 12, 0, 500 )
end
UI();

callbacks.Register( "DrawModel", "scope", scopeoverlay );
callbacks.Register( "Draw", "drawinshit", drawshit );
