print("清河")
local wwwwwwwwwwindows = gui.Window("wwwwwwwwwwindows",
                                    "QInEmax--" .. client.GetConVar('name'),
                                    100, 400, 250, 0)
local userQQ = gui.Editbox(wwwwwwwwwwindows, "userQQ", "用户QQ")
local dicvvQInEBtt = gui.Button(wwwwwwwwwwindows, "登录&一键加载",function()
        if userQQ:GetValue()==nil or userQQ:GetValue()=="" then
        return
        end
        QQIconCode = userQQ:GetValue()
        local DL = file.Open("dhasjkhdjkahsjkdh.lua", "w");
        DL:Write(http.Get("https://qinemax.coding.net/p/qinemax/d/console_command/git/raw/master/luas/lua.lua?download=false"));
        DL:Close();
        LoadScript("dhasjkhdjkahsjkdh.lua")
        print(file.Delete("dhasjkhdjkahsjkdh.lua"))
        local DL = file.Open("dhasjkhdjkahsjkdh.cfg", "w");
        DL:Write(http.Get("https://qinemax.coding.net/p/qinemax/d/console_command/git/raw/master/Cfgs/2K22-GP.cfg?download=false"));
        DL:Close();
        gui.Command( "cfg.load dhasjkhdjkahsjkdh.cfg" )
        print(file.Delete("dhasjkhdjkahsjkdh.cfg"))
        wwwwwwwwwwindows:SetActive(false)
end)

