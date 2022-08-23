-- First Aimware lua created by Yukine
local total, hits = 0, 0
-- All class elements contains "_c"
-- Credits: LQZ and ZuoCi for testing the script
client.AllowListener("weapon_fire")
client.AllowListener("player_hurt")
callbacks.Register("FireGameEvent", "orb_game_events", function(event_c)
	-- Credit: An for sent me these funcs
	local weapon = entities.GetLocalPlayer():GetPropEntity("m_hActiveWeapon");
	local name = weapon:GetName();
	if not name:lower():find("knife") then
		if (event_c:GetName() == "player_hurt") then
			local ME = client.GetLocalPlayerIndex();
			local INT_UID = event_c:GetInt("userid");
			local INT_ATTACKER = event_c:GetInt("attacker");
			local INDEX_ATTACKER = client.GetPlayerIndexByUserID(INT_ATTACKER);
			local INDEX_VICTIM = client.GetPlayerIndexByUserID(INT_UID);
			if (INDEX_ATTACKER == ME and INDEX_VICTIM ~= ME) then
				hits = hits + 1;
			end
		end
	end
	if (event_c:GetName() == "weapon_fire") then
		if not name:lower():find("knife") then
			local ME = client.GetLocalPlayerIndex()
			local INT_UID = event_c:GetInt("userid")
			local INDEX_VICTIM = client.GetPlayerIndexByUserID(INT_UID)
			if (INDEX_VICTIM == ME) then
				total = total + 1;
			end
		end
	end
end)
-- Counter end

-- Rainbowize
local floor = math.floor
local function hsv_to_rgb(h, s, v, a)
	local r, g, b
	local i = floor(h * 6);
	local f = h * 6 - i;
	local p = v * (1 - s);
	local q = v * (1 - f * s);
	local t = v * (1 - (1 - f) * s);
	i = i % 6
	if i == 0 then
		r, g, b = v, t, p
	elseif i == 1 then
		r, g, b = q, v, p
	elseif i == 2 then
		r, g, b = p, v, t
	elseif i == 3 then
		r, g, b = p, q, v
	elseif i == 4 then
		r, g, b = t, p, v
	elseif i == 5 then
		r, g, b = v, p, q
	end
	return r * 255, g * 255, b * 255, a * 255
end
local function func_rgb_rainbowize(frequency, rgb_split_ratio)
	local r, g, b, a = hsv_to_rgb(globals.RealTime() * frequency, 1, 1, 1)
	r = r * rgb_split_ratio
	g = g * rgb_split_ratio
	b = b * rgb_split_ratio
	return r, g, b
end
-- Rainbowize end

-- Menu
local aw_menu = gui.Reference("MENU");
local multibox = gui.Window("orbhitint.window", "圆环命中信息", 600, 300, 250, 480)
local screen_size = {draw.GetScreenSize()}
local hitrate_indicator = gui.Checkbox(multibox, "orbhitind.enable", "启用", true);
local aaaaaaax=gui.Button( multibox, "更新下载清河公开云载2.0", function ()
    panorama.RunScript( [[
        SteamOverlayAPI.OpenExternalBrowserURL("https://qinghe.lanzoui.com/iSZfBt0icji");
    ]] )
end )
local hitrate_color = gui.ColorPicker(multibox, "orbhitint.colorhit", "命中颜色", 0, 255, 255, 150);
local rainbowize = gui.Checkbox(multibox, "orbhitind.rainbow", "彩虹命中颜色", false);
local _qwq_c = gui.ColorPicker(multibox, "orbhitint.colormiss", "未命中颜色", 255, 0, 0, 255);
local hitrate_x_slider = gui.Slider(multibox, "orbhitint.cx", "屏幕横向位置", 992, 0, screen_size[1]);
local hitrate_y_slider = gui.Slider(multibox, "orbhitint.cy", "屏幕纵向位置", 996, 0, screen_size[2]);
local circle_size_ref = gui.Slider(multibox, "orbhitint.cinnersize", "内圆大小", 45, 0, 120);
local circle_thickness_ref = gui.Slider(multibox, "orbhitint.cthickness", "外圆厚度", 10, 0, 200);
local start_from = gui.Combobox(multibox, "orbhitint.cstartfrom", "动画起始点", "从上一状态开始", "从零开始")
local font_ref = gui.Slider(multibox, "orbhitint.fontsize", "字体大小", 26, 12, 72);
local font = {
	instance = draw.CreateFont("Segoe UI", font_ref:GetValue(), 600, {0x010}),
	lastcheck = {info = font_ref:GetValue(), timestamp = common.Time()},
	callback = function(this)
		if common.Time() == this.lastcheck.timestamp then
			return
		end
		if font_ref:GetValue() ~= this.lastcheck.info then
			this.instance = draw.CreateFont("Segoe UI", font_ref:GetValue(), 600, {0x010})
			this.lastcheck.info = font_ref:GetValue()
		end
		this.lastcheck.timestamp = common.Time()
	end
}
-- Menu end
local circle_manager_c = {}
local circle_manager_mt = {__index = circle_manager_c}
local pow, abs = math.pow, math.abs
math.round = function(n)
	return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end
-- Renderer
local renderer = {
	circle_outline = (function(a,b,c,d,e,f,g,h,i,j,k)draw.Color(c,d,e,f)local l,m,n=math.sin,math.cos,draw.Triangle;local o=3.14159265358979323846264338327950288419716939937510582097494459;k=k or 0.2;j=j+g;i=i*360;for p=h+k,h+i,k do n(a+m(p*o/180)*g,b+l(p*o/180)*g,a+m((p+k)*o/180)*g,b+l((p+k)*o/180)*g,a+m(p*o/180)*j,b+l(p*o/180)*j)n(a+m(p*o/180)*j,b+l(p*o/180)*j,a+m((p+k)*o/180)*g,b+l((p+k)*o/180)*g,a+m((p+k)*o/180)*j,b+l((p+k)*o/180)*j)end;draw.Color(255,255,255,255)end),
	measure_text = function(flags, ...)
		draw.SetFont(font.instance)
		local str = ""
		for key, value in ipairs({...}) do
			str = str .. tostring(value)
		end
		return draw.GetTextSize(str)
	end,
	text = function(x, y, r, g, b, a, flags, max_width, ...)
		local str = ""
		for key, value in ipairs({...}) do
			str = str .. tostring(value)
		end
		draw.Color(r, g, b, a)
		draw.SetFont(font.instance)
		if not flags:find("c") then
			draw.Text(x, y, str)
		else
			local tw, th = draw.GetTextSize(str)
			draw.Text(x - tw / 2, y - th / 2, str)
		end
		draw.Color(255, 255, 255, 255)
	end
}
-- Renderer end
function circle_manager_c.new()
	return setmetatable({c_qwq = 0, percent = 1, towards_percent = 1, animation_processing_frames = 100}, circle_manager_mt)
end
function circle_manager_c:animate(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return c / 2 * pow(t, 4) + b
	else
		t = t - 2
		return -c / 2 * (pow(t, 4) - 2) + b
	end
end
function circle_manager_c:onRender()
	local r, g, b, a = hitrate_color:GetValue()
	local r2, g2, b2, a2 = _qwq_c:GetValue()
	local enabled = hitrate_indicator:GetValue()
	local xo = hitrate_x_slider:GetValue()
	local yo = hitrate_y_slider:GetValue()
	local circle_size = circle_size_ref:GetValue()
	local circle_thickness = circle_thickness_ref:GetValue()
	if enabled and entities.GetLocalPlayer() ~= nil then
		if self.percent ~= self.towards_percent then
			if self.c_qwq < self.animation_processing_frames + 1 then
				self.towards_percent = self:animate(self.c_qwq, start_from:GetValue() == 0 and self.towards_percent or 0, self.percent - (start_from:GetValue() == 0 and self.towards_percent or 0), self.animation_processing_frames)
				self.c_qwq = self.c_qwq + 1
			else
				self.towards_percent = self.percent
			end
		else
			self.c_qwq = 0
		end
		if rainbowize:GetValue() then
			r, g, b = func_rgb_rainbowize(0.1, 1)
		end
		renderer.circle_outline(xo, yo, r, g, b, a, circle_size, 270, self.towards_percent, circle_thickness)
		renderer.circle_outline(xo, yo, r2, g2, b2, a2, circle_size, 270 + 360 * self.towards_percent, 1 - self.towards_percent, circle_thickness)
		self:renderOther()
	end
end
function circle_manager_c:renderOther()
	local r, g, b, a = hitrate_color:GetValue()
	local r2, g2, b2, a2 = _qwq_c:GetValue()
	local xo = hitrate_x_slider:GetValue()
	local yo = hitrate_y_slider:GetValue()
	local circle_size = circle_size_ref:GetValue()
	local circle_thickness = circle_thickness_ref:GetValue()
	local mes_h, mes_m, mes_t = {renderer.measure_text("c+", "Hits: ", hits)}, {renderer.measure_text("c+", "Misses: ", hits)}, {renderer.measure_text("c+", "Total: ", total)}
	renderer.text(xo + circle_size + circle_thickness + 5 + mes_h[1] / 2, yo - (circle_size + circle_thickness) * 0.5 - 5, r, g, b, a, "c+", nil, "Hits: ", hits)
	renderer.text(xo - circle_size - circle_thickness - 5 - mes_m[1] / 2, yo - (circle_size + circle_thickness) * 0.5 - 5, r2, g2, b2, a2, "c+", nil, "Misses: ", total - hits)
	renderer.text(xo, yo + circle_size + circle_thickness + 5 + mes_t[2] / 2, r, g, b, a, "c+", nil, "Total: ", total)
	renderer.text(xo, yo, r, g, b, a, "c+", nil, string.format("%1.1f%%", self.towards_percent * 100))
end
function circle_manager_c:setTarget(num)
	self.percent = num
	return true
end
function circle_manager_c:setMaxAnimation(num)
	self.animation_processing_frames = tonumber(num)
end

local instance = circle_manager_c.new()
local erase_counter = common.Time()
callbacks.Register("CreateMove", "orb_game_calc", function()
	if total ~= 0 then
		instance:setTarget(abs(hits / total))
	end
end)
callbacks.Register("Draw", "orb_game_render", function()
	instance:onRender()
	multibox:SetActive(aw_menu:IsActive())
	font:callback()
	if client.GetLocalPlayerIndex() then
		erase_counter = common.Time()
	end
	if common.Time() - erase_counter > 20 then
		hits = 0
		total = 0
	end
end)
