--[[
    Sou Hub - Winter Edition v3
    Kar temali MatrixHub tarzi UI
    TUM eski ozellikler eklendi
]]

print("[Sou Hub] Winter Edition v3 yukleniyor...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function getGuiParent()
    if gethui then return gethui() end
    if syn and syn.protect_gui then
        local sg = Instance.new("ScreenGui")
        syn.protect_gui(sg)
        sg.Parent = game:GetService("CoreGui")
        return sg
    end
    local ok = pcall(function()
        local t = Instance.new("ScreenGui"); t.Parent = game:GetService("CoreGui"); t:Destroy()
    end)
    if ok then return game:GetService("CoreGui") end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- =============================================
-- WINTER THEME
-- =============================================
local Theme = {
    Bg = Color3.fromRGB(15, 20, 32),
    Panel = Color3.fromRGB(22, 28, 42),
    Header = Color3.fromRGB(18, 24, 38),
    Button = Color3.fromRGB(32, 40, 58),
    ButtonHover = Color3.fromRGB(42, 52, 72),
    Slider = Color3.fromRGB(30, 38, 55),
    SliderFill = Color3.fromRGB(120, 180, 255),
    Text = Color3.fromRGB(230, 240, 255),
    SubText = Color3.fromRGB(140, 160, 190),
    Accent = Color3.fromRGB(120, 180, 255),
    Accent2 = Color3.fromRGB(180, 220, 255),
    ToggleOn = Color3.fromRGB(120, 180, 255),
    ToggleOff = Color3.fromRGB(60, 70, 90),
    Snow = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(45, 55, 75),
    Kill = Color3.fromRGB(255, 90, 100),
}

-- =============================================
-- THEMES (15 tema)
-- =============================================
local Themes = {
    Winter   = {Name="Winter",   Primary=Color3.fromRGB(140,168,200), Accent=Color3.fromRGB(232,244,255), Bg=Color3.fromRGB(10,18,32),  Panel=Color3.fromRGB(16,28,46),  Button=Color3.fromRGB(26,42,66),  Text=Color3.fromRGB(220,235,250)},
    Obsidian = {Name="Obsidian", Primary=Color3.fromRGB(100,110,130), Accent=Color3.fromRGB(160,180,210), Bg=Color3.fromRGB(12,13,16),  Panel=Color3.fromRGB(18,19,23),  Button=Color3.fromRGB(26,28,34),  Text=Color3.fromRGB(200,210,220)},
    Cobalt   = {Name="Cobalt",   Primary=Color3.fromRGB(50,100,180),  Accent=Color3.fromRGB(100,160,240), Bg=Color3.fromRGB(10,12,18),  Panel=Color3.fromRGB(16,20,28),  Button=Color3.fromRGB(24,30,42),  Text=Color3.fromRGB(200,215,235)},
    Noir     = {Name="Noir",     Primary=Color3.fromRGB(80,80,80),    Accent=Color3.fromRGB(200,200,200), Bg=Color3.fromRGB(8,8,8),     Panel=Color3.fromRGB(14,14,14),  Button=Color3.fromRGB(22,22,22),  Text=Color3.fromRGB(230,230,230)},
    Crimson  = {Name="Crimson",  Primary=Color3.fromRGB(140,30,50),   Accent=Color3.fromRGB(230,90,110),  Bg=Color3.fromRGB(14,8,12),   Panel=Color3.fromRGB(22,14,18),  Button=Color3.fromRGB(34,20,26),  Text=Color3.fromRGB(230,200,205)},
    Emerald  = {Name="Emerald",  Primary=Color3.fromRGB(40,140,100),  Accent=Color3.fromRGB(90,220,170),  Bg=Color3.fromRGB(8,14,12),   Panel=Color3.fromRGB(14,22,18),  Button=Color3.fromRGB(22,34,28),  Text=Color3.fromRGB(200,230,215)},
    Violet   = {Name="Violet",   Primary=Color3.fromRGB(110,60,180),  Accent=Color3.fromRGB(180,120,255), Bg=Color3.fromRGB(12,10,20),  Panel=Color3.fromRGB(20,16,32),  Button=Color3.fromRGB(30,24,48),  Text=Color3.fromRGB(220,210,240)},
    Slate    = {Name="Slate",    Primary=Color3.fromRGB(70,90,110),   Accent=Color3.fromRGB(130,170,200), Bg=Color3.fromRGB(10,13,18),  Panel=Color3.fromRGB(16,20,28),  Button=Color3.fromRGB(24,30,40),  Text=Color3.fromRGB(200,215,230)},
    Halloween= {Name="Halloween",Primary=Color3.fromRGB(255,107,26),  Accent=Color3.fromRGB(255,165,0),   Bg=Color3.fromRGB(13,6,5),    Panel=Color3.fromRGB(26,14,8),   Button=Color3.fromRGB(42,24,16),  Text=Color3.fromRGB(255,220,190)},
    Desert   = {Name="Desert",   Primary=Color3.fromRGB(200,148,74),  Accent=Color3.fromRGB(244,217,160), Bg=Color3.fromRGB(26,15,10),  Panel=Color3.fromRGB(42,26,15),  Button=Color3.fromRGB(58,40,24),  Text=Color3.fromRGB(240,220,190)},
    Ocean    = {Name="Ocean",    Primary=Color3.fromRGB(30,144,255),  Accent=Color3.fromRGB(126,200,227), Bg=Color3.fromRGB(4,18,32),   Panel=Color3.fromRGB(8,32,52),   Button=Color3.fromRGB(14,46,72),  Text=Color3.fromRGB(200,225,245)},
    Sakura   = {Name="Sakura",   Primary=Color3.fromRGB(245,165,184), Accent=Color3.fromRGB(255,209,220), Bg=Color3.fromRGB(26,13,18),  Panel=Color3.fromRGB(42,21,32),  Button=Color3.fromRGB(58,31,46),  Text=Color3.fromRGB(255,225,235)},
    Cyberpunk= {Name="Cyberpunk",Primary=Color3.fromRGB(255,0,170),   Accent=Color3.fromRGB(0,255,255),   Bg=Color3.fromRGB(10,0,20),   Panel=Color3.fromRGB(21,0,37),   Button=Color3.fromRGB(31,0,53),   Text=Color3.fromRGB(240,220,255)},
    Christmas= {Name="Christmas",Primary=Color3.fromRGB(212,36,38),   Accent=Color3.fromRGB(15,139,60),   Bg=Color3.fromRGB(10,26,14),  Panel=Color3.fromRGB(20,42,26),  Button=Color3.fromRGB(30,58,36),  Text=Color3.fromRGB(230,240,230)},
    Sunset   = {Name="Sunset",   Primary=Color3.fromRGB(255,123,84),  Accent=Color3.fromRGB(255,178,107), Bg=Color3.fromRGB(26,15,26),  Panel=Color3.fromRGB(42,22,32),  Button=Color3.fromRGB(58,32,48),  Text=Color3.fromRGB(255,230,220)},
}
local CurrentTheme = Themes.Winter

local OriginalLighting = {
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness, FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows, ClockTime = Lighting.ClockTime,
}

-- =============================================
-- SETTINGS
-- =============================================
local Settings = {
    -- Visual
    SpeedHack = false, SpeedHackValue = 16,
    Noclip = false, NoclipSpeed = 0,
    Flight = false, FlightSpeed = 50,
    Mode = "Camera",
    Fullbright = false, NoFog = false,
    
    -- AimBot
    Camlock = true, Smoothness = 0.450, Prediction = 0.100,
    TargetPart = "Head", FOVVisible = true, FOVRadius = 150,
    WallCheck = false, StickyAim = true, AutoSwitch = true,
    SkipDowned = true, AlwaysOn = false, TriggerBot = false,
    HitboxExpand = false, HitboxSize = 1.3,
    
    -- AutoKill
    AutoKill = false, AutoLock = false, AutoFire = false,
    InstantKill = false, RapidKill = false, RapidKillDelay = 0.05,
    KillRange = 100, AutoKillTarget = nil,
    
    -- ESP
    ESPEnabled = true, ESPNames = true, ESPHealth = true, ESPDistance = true,
    ESPTracers = true, ESPBoxes = false, ESPTracerOrigin = "Bottom",
    HighlightFillTransparency = 0.35, HighlightColor = Color3.fromRGB(120,180,255),
    
    -- Movement
    InfJump = false, GodMode = false,
    AntiFling = false, DamageAura = false,
    DamageAuraRange = 10, DamageAuraAmount = 5,
    CharacterSize = false, CharacterSizeValue = 1.0,
    
    -- Misc
    AntiAFK = true, Watermark = true, FPSDisplay = true, PingDisplay = true,
    GuiTransparency = 250,
    
    -- World
    TimeChanger = false, TimeValue = 12,
    
    -- Spectate
    SpectateTarget = nil, Spectating = false,
    SpectateKey = Enum.KeyCode.V,
    
    -- Follow
    FollowPlayer = false, FollowTarget = nil,
    
    -- Stats
    Kills = 0, SessionStart = tick(),
    SelectedPlayers = {}, CurrentTarget = nil,
}

-- CLEANUP
for _, loc in ipairs({game:GetService("CoreGui"), LocalPlayer:FindFirstChild("PlayerGui")}) do
    pcall(function() 
        local o = loc:FindFirstChild("SouHub_Winter"); if o then o:Destroy() end
        local o2 = loc:FindFirstChild("SouHub_Snow"); if o2 then o2:Destroy() end
    end)
end
pcall(function() 
    if gethui then 
        local o = gethui():FindFirstChild("SouHub_Winter"); if o then o:Destroy() end
        local o2 = gethui():FindFirstChild("SouHub_Snow"); if o2 then o2:Destroy() end
    end 
end)

local function tween(obj, time, props, style, dir)
    local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- =============================================
-- GUI
-- =============================================
local guiParent = getGuiParent()
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SouHub_Winter"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
if guiParent:IsA("ScreenGui") then
    ScreenGui = guiParent; ScreenGui.Name = "SouHub_Winter"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 999
else ScreenGui.Parent = guiParent end

-- KAR YAGISI (arkada)
local snowGui = Instance.new("ScreenGui")
snowGui.Name = "SouHub_Snow"
snowGui.ResetOnSpawn = false
snowGui.DisplayOrder = 1
snowGui.IgnoreGuiInset = true
snowGui.Parent = guiParent

local snowContainer = Instance.new("Frame")
snowContainer.Size = UDim2.new(1, 0, 1, 0)
snowContainer.BackgroundTransparency = 1
snowContainer.Parent = snowGui

local function createSnowflake()
    local sf = Instance.new("TextLabel")
    sf.Size = UDim2.new(0, math.random(8, 18), 0, math.random(8, 18))
    sf.Position = UDim2.new(math.random(), 0, -0.05, 0)
    sf.BackgroundTransparency = 1
    sf.Text = "❄"
    sf.TextColor3 = Color3.fromRGB(255, 255, 255)
    sf.TextSize = math.random(8, 18)
    sf.TextTransparency = math.random(3, 7) / 10
    sf.Font = Enum.Font.GothamBold
    sf.Rotation = math.random(0, 360)
    sf.Parent = snowContainer
    local dur = math.random(6, 14)
    local drift = math.random(-20, 20) / 100
    tween(sf, dur, {Position = UDim2.new(sf.Position.X.Scale + drift, 0, 1.1, 0), Rotation = sf.Rotation + math.random(-180, 180)}, Enum.EasingStyle.Linear)
    task.delay(dur, function() if sf and sf.Parent then sf:Destroy() end end)
end

task.spawn(function()
    while snowContainer.Parent do
        createSnowflake()
        task.wait(math.random(5, 15) / 100)
    end
end)

-- TOAST
local toastContainer = Instance.new("Frame")
toastContainer.Size = UDim2.new(0, 320, 1, -20)
toastContainer.Position = UDim2.new(1, -340, 0, 10)
toastContainer.BackgroundTransparency = 1
toastContainer.ZIndex = 1000
toastContainer.Parent = ScreenGui
local toastLayout = Instance.new("UIListLayout", toastContainer)
toastLayout.SortOrder = Enum.SortOrder.LayoutOrder
toastLayout.Padding = UDim.new(0, 8)

local function showToast(title, message, toastType)
    toastType = toastType or "info"
    local colors = {info = Theme.Accent, success = Color3.fromRGB(80, 200, 130), warning = Color3.fromRGB(230, 180, 60), error = Color3.fromRGB(220, 70, 80), kill = Theme.Kill}
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 0, 0, 52)
    toast.Position = UDim2.new(1, 20, 0, 0)
    toast.BackgroundColor3 = Theme.Panel
    toast.BackgroundTransparency = 0.05
    toast.BorderSizePixel = 0
    toast.ZIndex = 1001
    toast.Parent = toastContainer
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", toast)
    stroke.Color = colors[toastType]; stroke.Thickness = 1.5; stroke.Transparency = 0.3
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 1, 0); bar.BackgroundColor3 = colors[toastType]
    bar.BorderSizePixel = 0; bar.ZIndex = 1002; bar.Parent = toast
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -24, 0, 18); titleLbl.Position = UDim2.new(0, 16, 0, 10)
    titleLbl.BackgroundTransparency = 1; titleLbl.Text = title
    titleLbl.TextColor3 = Theme.Text; titleLbl.TextSize = 12
    titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 1002; titleLbl.Parent = toast
    local msgLbl = Instance.new("TextLabel")
    msgLbl.Size = UDim2.new(1, -24, 0, 16); msgLbl.Position = UDim2.new(0, 16, 0, 28)
    msgLbl.BackgroundTransparency = 1; msgLbl.Text = message
    msgLbl.TextColor3 = Theme.SubText; msgLbl.TextSize = 10
    msgLbl.Font = Enum.Font.Gotham; msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.ZIndex = 1002; msgLbl.Parent = toast
    tween(toast, 0.4, {Size = UDim2.new(0, 320, 0, 52), Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quint)
    task.delay(3, function()
        tween(toast, 0.3, {Position = UDim2.new(1, 20, 0, 0)})
        tween(toast, 0.3, {BackgroundTransparency = 1})
        toast:Destroy()
    end)
end

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 780, 0, 480)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -240)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Theme.Border
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Theme.Header
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.ZIndex = 5
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local logoLbl = Instance.new("TextLabel")
logoLbl.Size = UDim2.new(0, 200, 1, 0)
logoLbl.Position = UDim2.new(0, 20, 0, 0)
logoLbl.BackgroundTransparency = 1
logoLbl.Text = "❄ Sou Hub"
logoLbl.TextColor3 = Theme.Text
logoLbl.TextSize = 20
logoLbl.Font = Enum.Font.GothamBold
logoLbl.TextXAlignment = Enum.TextXAlignment.Left
logoLbl.ZIndex = 7
logoLbl.Parent = Header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 32, 0, 32)
minBtn.Position = UDim2.new(1, -40, 0.5, -16)
minBtn.BackgroundColor3 = Theme.Button
minBtn.BackgroundTransparency = 0.5
minBtn.BorderSizePixel = 0
minBtn.Text = "−"
minBtn.TextColor3 = Theme.Text
minBtn.TextSize = 20
minBtn.Font = Enum.Font.GothamBold
minBtn.AutoButtonColor = false
minBtn.ZIndex = 7
minBtn.Parent = Header
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        tween(MainFrame, 0.3, {Size = UDim2.new(0, 780, 0, 50)})
    else
        tween(MainFrame, 0.3, {Size = UDim2.new(0, 780, 0, 480)})
    end
end)

-- DRAGGABLE
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local d = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- TAB BAR (11 sekme - kaydirmali)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 45)
TabBar.Position = UDim2.new(0, 0, 0, 50)
TabBar.BackgroundColor3 = Theme.Bg
TabBar.BackgroundTransparency = 0.5
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 5
TabBar.Parent = MainFrame

local TabBarScroll = Instance.new("ScrollingFrame")
TabBarScroll.Size = UDim2.new(1, 0, 1, 0)
TabBarScroll.BackgroundTransparency = 1
TabBarScroll.BorderSizePixel = 0
TabBarScroll.ScrollBarThickness = 0
TabBarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBarScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
TabBarScroll.ScrollingDirection = Enum.ScrollingDirection.X
TabBarScroll.ZIndex = 6
TabBarScroll.Parent = TabBar

local tabLayout = Instance.new("UIListLayout", TabBarScroll)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 4)
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
local tabPad = Instance.new("UIPadding", TabBarScroll)
tabPad.PaddingLeft = UDim.new(0, 20)
tabPad.PaddingTop = UDim.new(0, 6)

-- 11 SEKMEE (eski + yeni)
local tabNames = {"Visual", "AimBot", "AutoKill", "ESP", "Movement", "Players", "World", "Character", "Spectate", "Themes", "Misc"}
local tabButtons = {}
local tabPages = {}
local activeTab = "Visual"

-- UI BUILDERS
local function addToggle(parent, name, default, callback, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order or 0
    row.ZIndex = 4
    row.Parent = parent
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.7, 0, 1, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = Theme.Text
    nameLbl.TextSize = 13
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 5
    nameLbl.Parent = row
    
    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 50, 0, 26)
    switchBg.Position = UDim2.new(1, -50, 0.5, -13)
    switchBg.BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff
    switchBg.BackgroundTransparency = default and 0 or 0.2
    switchBg.BorderSizePixel = 0
    switchBg.Text = ""
    switchBg.AutoButtonColor = false
    switchBg.ZIndex = 5
    switchBg.Parent = row
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    local switchStroke = Instance.new("UIStroke", switchBg)
    switchStroke.Color = default and Theme.Accent2 or Theme.Border
    switchStroke.Thickness = 1.5
    switchStroke.Transparency = default and 0 or 0.5
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 6
    knob.Parent = switchBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local state = default
    local function doToggle()
        state = not state
        if state then
            tween(switchBg, 0.25, {BackgroundColor3 = Theme.ToggleOn, BackgroundTransparency = 0})
            tween(switchStroke, 0.25, {Color = Theme.Accent2, Transparency = 0})
            tween(knob, 0.25, {Position = UDim2.new(1, -22, 0.5, -10)}, Enum.EasingStyle.Back)
        else
            tween(switchBg, 0.25, {BackgroundColor3 = Theme.ToggleOff, BackgroundTransparency = 0.2})
            tween(switchStroke, 0.25, {Color = Theme.Border, Transparency = 0.5})
            tween(knob, 0.25, {Position = UDim2.new(0, 2, 0.5, -10)}, Enum.EasingStyle.Back)
        end
        if callback then callback(state) end
    end
    switchBg.MouseButton1Click:Connect(doToggle)
    nameLbl.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then doToggle() end
    end)
    return function() return state end, function(v)
        state = v
        if state then
            tween(switchBg, 0.25, {BackgroundColor3 = Theme.ToggleOn, BackgroundTransparency = 0})
            tween(knob, 0.25, {Position = UDim2.new(1, -22, 0.5, -10)})
        else
            tween(switchBg, 0.25, {BackgroundColor3 = Theme.ToggleOff, BackgroundTransparency = 0.2})
            tween(knob, 0.25, {Position = UDim2.new(0, 2, 0.5, -10)})
        end
        if callback then callback(state) end
    end
end

local function addRedToggle(parent, name, default, callback, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order or 0
    row.ZIndex = 4
    row.Parent = parent
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.7, 0, 1, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = Color3.fromRGB(255, 200, 200)
    nameLbl.TextSize = 13
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 5
    nameLbl.Parent = row
    
    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 50, 0, 26)
    switchBg.Position = UDim2.new(1, -50, 0.5, -13)
    switchBg.BackgroundColor3 = default and Color3.fromRGB(220, 60, 70) or Theme.ToggleOff
    switchBg.BackgroundTransparency = default and 0 or 0.2
    switchBg.BorderSizePixel = 0
    switchBg.Text = ""
    switchBg.AutoButtonColor = false
    switchBg.ZIndex = 5
    switchBg.Parent = row
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    local switchStroke = Instance.new("UIStroke", switchBg)
    switchStroke.Color = default and Color3.fromRGB(255, 100, 110) or Theme.Border
    switchStroke.Thickness = 1.5
    switchStroke.Transparency = default and 0 or 0.5
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 6
    knob.Parent = switchBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local state = default
    local function doToggle()
        state = not state
        if state then
            tween(switchBg, 0.25, {BackgroundColor3 = Color3.fromRGB(220, 60, 70), BackgroundTransparency = 0})
            tween(switchStroke, 0.25, {Color = Color3.fromRGB(255, 100, 110), Transparency = 0})
            tween(knob, 0.25, {Position = UDim2.new(1, -22, 0.5, -10)}, Enum.EasingStyle.Back)
        else
            tween(switchBg, 0.25, {BackgroundColor3 = Theme.ToggleOff, BackgroundTransparency = 0.2})
            tween(switchStroke, 0.25, {Color = Theme.Border, Transparency = 0.5})
            tween(knob, 0.25, {Position = UDim2.new(0, 2, 0.5, -10)}, Enum.EasingStyle.Back)
        end
        if callback then callback(state) end
    end
    switchBg.MouseButton1Click:Connect(doToggle)
    nameLbl.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then doToggle() end
    end)
    return function() return state end
end

local function addSlider(parent, name, min, max, default, callback, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 52)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order or 0
    container.ZIndex = 4
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 5
    label.Parent = container
    
    local valueLbl = Instance.new("TextLabel")
    valueLbl.Size = UDim2.new(0.5, 0, 0, 18)
    valueLbl.Position = UDim2.new(0.5, 0, 0, 0)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text = string.format("%.3f", default)
    valueLbl.TextColor3 = Theme.Text
    valueLbl.TextSize = 12
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right
    valueLbl.ZIndex = 5
    valueLbl.Parent = container
    
    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(1, 0, 0, 10)
    bg.Position = UDim2.new(0, 0, 0, 30)
    bg.BackgroundColor3 = Theme.Slider
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 0
    bg.Text = ""
    bg.AutoButtonColor = false
    bg.ZIndex = 5
    bg.Parent = container
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.SliderFill
    fill.BorderSizePixel = 0
    fill.ZIndex = 5
    fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default-min)/(max-min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 6
    knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local knobStroke = Instance.new("UIStroke", knob)
    knobStroke.Color = Theme.Accent
    knobStroke.Thickness = 2.5
    
    local value = default
    local sliding = false
    local function update(px)
        local ax, as = bg.AbsolutePosition.X, bg.AbsoluteSize.X
        if as == 0 then return end
        local p = math.clamp((px - ax) / as, 0, 1)
        value = min + (max - min) * p
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, 0, 0.5, 0)
        valueLbl.Text = string.format("%.3f", value)
        if callback then callback(value) end
    end
    bg.MouseButton1Down:Connect(function(x) sliding = true; update(x) end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
    return function() return value end
end

local function addButton(parent, name, callback, order, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = color or Theme.Button
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Theme.Text
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = false
    btn.LayoutOrder = order or 0
    btn.ZIndex = 5
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Theme.Border
    stroke.Thickness = 1
    btn.MouseEnter:Connect(function() tween(btn, 0.15, {BackgroundColor3 = Theme.ButtonHover, BackgroundTransparency = 0.1}) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.15, {BackgroundColor3 = color or Theme.Button, BackgroundTransparency = 0.2}) end)
    btn.MouseButton1Click:Connect(function()
        tween(btn, 0.1, {BackgroundTransparency = 0})
        task.wait(0.1)
        tween(btn, 0.15, {BackgroundTransparency = 0.2})
        if callback then callback() end
    end)
    return btn
end

local function addSection(parent, text, order, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Theme.Text
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0
    lbl.ZIndex = 5
    lbl.Parent = parent
    return lbl
end

-- SAYFA OLUSTURUCU
local function createPage(name, visible)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Theme.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = visible or false
    page.ZIndex = 4
    page.Parent = ContentArea
    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    return page
end

-- CONTENT AREA
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -40, 1, -130)
ContentArea.Position = UDim2.new(0, 20, 0, 105)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 3
ContentArea.Parent = MainFrame

-- TAB BUTONLARI
for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 95, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tabBtn.BackgroundTransparency = 1
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = name
    tabBtn.TextColor3 = i==1 and Theme.Text or Theme.SubText
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.AutoButtonColor = false
    tabBtn.ZIndex = 6
    tabBtn.Parent = TabBarScroll
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    tabButtons[name] = tabBtn
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, i==1 and 0.6 or 0, 0, 2)
    indicator.Position = UDim2.new(0.5, 0, 1, -2)
    indicator.AnchorPoint = Vector2.new(0.5, 0)
    indicator.BackgroundColor3 = (name == "AutoKill") and Theme.Kill or Theme.Accent
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 7
    indicator.Parent = tabBtn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 1)
end

-- =============================================
-- SAYFALAR
-- =============================================
local visualPage = createPage("Visual", true)
local aimbotPage = createPage("AimBot")
local autokillPage = createPage("AutoKill")
local espPage = createPage("ESP")
local movementPage = createPage("Movement")
local playersPage = createPage("Players")
local worldPage = createPage("World")
local characterPage = createPage("Character")
local spectatePage = createPage("Spectate")
local themesPage = createPage("Themes")
local miscPage = createPage("Misc")

tabPages = {Visual=visualPage, AimBot=aimbotPage, AutoKill=autokillPage, ESP=espPage, Movement=movementPage, Players=playersPage, World=worldPage, Character=characterPage, Spectate=spectatePage, Themes=themesPage, Misc=miscPage}

-- =============================================
-- PAGE 1: VISUAL
-- =============================================
addSection(visualPage, "❄ Visual", 1)
local getSpeedHack = addToggle(visualPage, "Speed Hack", false, function(v) Settings.SpeedHack = v end, 2)
local getSpeedHackValue = addSlider(visualPage, "Speed Hack Value", 0, 1000, 16, function(v) Settings.SpeedHackValue = v end, 3)
local getNoclip = addToggle(visualPage, "Noclip", false, function(v) Settings.Noclip = v end, 4)
local getNoclipSpeed = addSlider(visualPage, "NoClip Speed", 0, 1000, 0, function(v) Settings.NoclipSpeed = v end, 5)
local getFlight = addToggle(visualPage, "Flight", false, function(v) Settings.Flight = v end, 6)
local getFlightSpeed = addSlider(visualPage, "Flight Speed", 0, 1000, 50, function(v) Settings.FlightSpeed = v end, 7)
local getFullbright = addToggle(visualPage, "Fullbright", false, function(v) Settings.Fullbright = v end, 8)
local getNoFog = addToggle(visualPage, "No Fog", false, function(v) Settings.NoFog = v end, 9)

addSection(visualPage, "Mode", 10)
local modeOptions = {"Camera", "Movement", "Velocity"}
local modeIdx = 1
local modeBtn = addButton(visualPage, "Mode: Camera", function()
    modeIdx = modeIdx % #modeOptions + 1
    modeBtn.Text = "Mode: " .. modeOptions[modeIdx]
    Settings.Mode = modeOptions[modeIdx]
end, 11)

-- =============================================
-- PAGE 2: AIMBOT
-- =============================================
addSection(aimbotPage, "❄ Camlock", 1)
local getCamlock = addToggle(aimbotPage, "Camlock System", true, function(v) Settings.Camlock = v end, 2)
local getWallCheck = addToggle(aimbotPage, "Wall Check", false, function(v) Settings.WallCheck = v end, 3)
local getStickyAim = addToggle(aimbotPage, "Sticky Aim", true, function(v) Settings.StickyAim = v end, 4)
local getAutoSwitch = addToggle(aimbotPage, "Auto Switch", true, function(v) Settings.AutoSwitch = v end, 5)
local getSkipDowned = addToggle(aimbotPage, "Skip Downed", true, function(v) Settings.SkipDowned = v end, 6)
local getAlwaysOn = addToggle(aimbotPage, "Always On", false, function(v) Settings.AlwaysOn = v end, 7)
local getTriggerBot = addToggle(aimbotPage, "Trigger Bot", false, function(v) Settings.TriggerBot = v end, 8)

addSection(aimbotPage, "Parameters", 9)
local getSmoothness = addSlider(aimbotPage, "Smoothness", 0.05, 1.0, 0.450, function(v) Settings.Smoothness = v end, 10)
local getPrediction = addSlider(aimbotPage, "Prediction", 0.0, 0.5, 0.100, function(v) Settings.Prediction = v end, 11)

addSection(aimbotPage, "FOV", 12)
local getFOVVisible = addToggle(aimbotPage, "FOV Circle", true, function(v) Settings.FOVVisible = v end, 13)
local getFOVRadius = addSlider(aimbotPage, "FOV Radius", 20, 500, 150, function(v) Settings.FOVRadius = v end, 14)

addSection(aimbotPage, "Hitbox", 15)
local getHitboxExpand = addToggle(aimbotPage, "Hitbox Expand", false, function(v) Settings.HitboxExpand = v end, 16)
local getHitboxSize = addSlider(aimbotPage, "Hitbox Size", 1.0, 3.0, 1.3, function(v) Settings.HitboxSize = v end, 17)

-- =============================================
-- PAGE 3: AUTOKILL
-- =============================================
addSection(autokillPage, "⚔ AUTO ELIMINATION", 1, Theme.Kill)
local getAutoKill = addRedToggle(autokillPage, "AUTOKILL", false, function(state)
    Settings.AutoKill = state
    if state then
        showToast("AUTOKILL", "Hedefe kilitleniyor...", "kill")
        for _, plr in pairs(Settings.SelectedPlayers) do
            if plr and plr.Character then Settings.AutoKillTarget = plr; break end
        end
        if not Settings.AutoKillTarget then
            showToast("AUTOKILL", "Once oyuncu sec!", "error")
            Settings.AutoKill = false
        end
    end
end, 2)
local getAutoLock = addRedToggle(autokillPage, "Auto Lock", true, function(v) Settings.AutoLock = v end, 3)
local getAutoFire = addRedToggle(autokillPage, "Auto Fire", true, function(v) Settings.AutoFire = v end, 4)
local getInstantKill = addRedToggle(autokillPage, "Instant Kill", true, function(v) Settings.InstantKill = v end, 5)
local getRapidKill = addRedToggle(autokillPage, "Rapid Kill", false, function(v) Settings.RapidKill = v end, 6)
local getRapidDelay = addSlider(autokillPage, "Rapid Delay", 0.01, 0.5, 0.05, function(v) Settings.RapidKillDelay = v end, 7)
local getKillRange = addSlider(autokillPage, "Kill Range", 5, 500, 100, function(v) Settings.KillRange = v end, 8)

-- =============================================
-- PAGE 4: ESP
-- =============================================
addSection(espPage, "❄ ESP Highlight", 1)
local getESP = addToggle(espPage, "ESP Enabled", true, function(v) Settings.ESPEnabled = v end, 2)
local getESPNames = addToggle(espPage, "Name Tags", true, function(v) Settings.ESPNames = v end, 3)
local getESPHealth = addToggle(espPage, "Health Display", true, function(v) Settings.ESPHealth = v end, 4)
local getESPDistance = addToggle(espPage, "Distance Display", true, function(v) Settings.ESPDistance = v end, 5)
local getESPTracers = addToggle(espPage, "Tracers", true, function(v) Settings.ESPTracers = v end, 6)
local getESPBoxes = addToggle(espPage, "Box ESP", false, function(v) Settings.ESPBoxes = v end, 7)
local getFillTransparency = addSlider(espPage, "Fill Transparency", 0, 1, 0.35, function(v) Settings.HighlightFillTransparency = v end, 8)

-- =============================================
-- PAGE 5: MOVEMENT
-- =============================================
addSection(movementPage, "❄ Movement", 1)
local getInfJump = addToggle(movementPage, "Infinite Jump", false, function(v) Settings.InfJump = v end, 2)

addSection(movementPage, "Teleport", 3)
addButton(movementPage, "Teleport to Mouse", function()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)) end
    end
end, 4)
addButton(movementPage, "Teleport to Target", function()
    local target = Settings.AutoKillTarget or Settings.CurrentTarget
    if target and target.Character then
        local thrp = target.Character:FindFirstChild("HumanoidRootPart")
        local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if thrp and lhrp then lhrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 3) end
    end
end, 5)

-- =============================================
-- PAGE 6: PLAYERS
-- =============================================
addSection(playersPage, "❄ Players", 1)

local SelectCountLabel = Instance.new("TextLabel")
SelectCountLabel.Size = UDim2.new(1, 0, 0, 20)
SelectCountLabel.BackgroundTransparency = 1
SelectCountLabel.Text = "0 players selected"
SelectCountLabel.TextColor3 = Theme.SubText
SelectCountLabel.TextSize = 10
SelectCountLabel.Font = Enum.Font.Gotham
SelectCountLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectCountLabel.LayoutOrder = 2
SelectCountLabel.ZIndex = 5
SelectCountLabel.Parent = playersPage

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, 0, 0, 28)
btnRow.BackgroundTransparency = 1
btnRow.LayoutOrder = 3
btnRow.ZIndex = 4
btnRow.Parent = playersPage

local SelectAllBtn = Instance.new("TextButton")
SelectAllBtn.Size = UDim2.new(0.48, 0, 1, 0)
SelectAllBtn.BackgroundColor3 = Theme.Button
SelectAllBtn.BackgroundTransparency = 0.3
SelectAllBtn.BorderSizePixel = 0
SelectAllBtn.Text = "Select All"
SelectAllBtn.TextColor3 = Theme.Text
SelectAllBtn.TextSize = 10
SelectAllBtn.Font = Enum.Font.GothamSemibold
SelectAllBtn.AutoButtonColor = false
SelectAllBtn.ZIndex = 5
SelectAllBtn.Parent = btnRow
Instance.new("UICorner", SelectAllBtn).CornerRadius = UDim.new(0, 4)

local ClearAllBtn = Instance.new("TextButton")
ClearAllBtn.Size = UDim2.new(0.48, 0, 1, 0)
ClearAllBtn.Position = UDim2.new(0.52, 0, 0, 0)
ClearAllBtn.BackgroundColor3 = Theme.Button
ClearAllBtn.BackgroundTransparency = 0.3
ClearAllBtn.BorderSizePixel = 0
ClearAllBtn.Text = "Clear"
ClearAllBtn.TextColor3 = Theme.Text
ClearAllBtn.TextSize = 10
ClearAllBtn.Font = Enum.Font.GothamSemibold
ClearAllBtn.AutoButtonColor = false
ClearAllBtn.ZIndex = 5
ClearAllBtn.Parent = btnRow
Instance.new("UICorner", ClearAllBtn).CornerRadius = UDim.new(0, 4)

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, 0, 0, 32)
SearchBox.BackgroundColor3 = Theme.Button
SearchBox.BackgroundTransparency = 0.3
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "Search players..."
SearchBox.PlaceholderColor3 = Theme.SubText
SearchBox.Text = ""
SearchBox.TextColor3 = Theme.Text
SearchBox.TextSize = 11
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false
SearchBox.LayoutOrder = 4
SearchBox.ZIndex = 5
SearchBox.Parent = playersPage
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, 0, 0, 200)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.BorderSizePixel = 0
PlayerScroll.ScrollBarThickness = 3
PlayerScroll.ScrollBarImageColor3 = Theme.Accent
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerScroll.LayoutOrder = 5
PlayerScroll.ZIndex = 4
PlayerScroll.Active = true
PlayerScroll.Parent = playersPage

local PlayerListLayout = Instance.new("UIListLayout", PlayerScroll)
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 3)

addSection(playersPage, "Actions", 6)
addButton(playersPage, "Goto First Selected", function()
    for _, plr in pairs(Settings.SelectedPlayers) do
        if plr and plr.Character then
            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if thrp and lhrp then lhrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 3) end
            break
        end
    end
end, 7)

addButton(playersPage, "Bring First Selected", function()
    for _, plr in pairs(Settings.SelectedPlayers) do
        if plr and plr.Character then
            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if thrp and lhrp then thrp.CFrame = lhrp.CFrame * CFrame.new(0, 0, 5) end
            break
        end
    end
end, 8)

local getFollowPlayer = addToggle(playersPage, "Follow First Selected", false, function(state)
    Settings.FollowPlayer = state
    if state then
        for _, plr in pairs(Settings.SelectedPlayers) do
            if plr and plr.Character then Settings.FollowTarget = plr; break end
        end
    else
        Settings.FollowTarget = nil
    end
end, 9)

addButton(playersPage, "Kill First Selected", function()
    for _, plr in pairs(Settings.SelectedPlayers) do
        if plr and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function() hum.Health = 0 end)
                Settings.Kills = Settings.Kills + 1
                showToast("KILL", plr.DisplayName, "kill")
            end
            break
        end
    end
end, 10, Color3.fromRGB(120, 30, 40))

-- =============================================
-- PAGE 7: WORLD
-- =============================================
addSection(worldPage, "❄ World", 1)
addButton(worldPage, "Server Rejoin", function()
    task.wait(0.5)
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
end, 2)

addButton(worldPage, "Server Hop", function()
    task.wait(0.5)
    pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if success and result and result.data then
            local servers = {}
            for _, server in ipairs(result.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then table.insert(servers, server.id) end
            end
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
            else TeleportService:Teleport(game.PlaceId, LocalPlayer) end
        else TeleportService:Teleport(game.PlaceId, LocalPlayer) end
    end)
end, 3)

addSection(worldPage, "Time", 4)
local getTimeChanger = addToggle(worldPage, "Time Changer", false, function(v) Settings.TimeChanger = v end, 5)
local getTimeValue = addSlider(worldPage, "Time (0-24)", 0, 24, 12, function(v) Settings.TimeValue = v end, 6)

-- =============================================
-- PAGE 8: CHARACTER
-- =============================================
addSection(characterPage, "❄ Character", 1)
local getGodMode = addToggle(characterPage, "God Mode", false, function(v) Settings.GodMode = v end, 2)
local getAntiFling = addToggle(characterPage, "Anti Fling", false, function(v) Settings.AntiFling = v end, 3)
local getCharacterSize = addToggle(characterPage, "Character Size", false, function(v) Settings.CharacterSize = v end, 4)
local getSizeValue = addSlider(characterPage, "Size Scale", 0.5, 5.0, 1.0, function(v) Settings.CharacterSizeValue = v end, 5)

addSection(characterPage, "Damage Aura", 6)
local getDamageAura = addToggle(characterPage, "Damage Aura", false, function(v) Settings.DamageAura = v end, 7)
local getDamageRange = addSlider(characterPage, "Aura Range", 3, 30, 10, function(v) Settings.DamageAuraRange = v end, 8)
local getDamageAmount = addSlider(characterPage, "Damage Amount", 1, 50, 5, function(v) Settings.DamageAuraAmount = v end, 9)

addSection(characterPage, "Actions", 10)
addButton(characterPage, "Respawn", function()
    pcall(function() LocalPlayer.Character:BreakJoints() end)
end, 11)

addButton(characterPage, "Full Heal", function()
    pcall(function()
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end)
end, 12)

-- =============================================
-- PAGE 9: SPECTATE (YENI)
-- =============================================
addSection(spectatePage, "❄ Spectate Mode", 1)

local specStatusLabel = Instance.new("TextLabel")
specStatusLabel.Size = UDim2.new(1, 0, 0, 24)
specStatusLabel.BackgroundTransparency = 1
specStatusLabel.Text = "Not Spectating"
specStatusLabel.TextColor3 = Theme.SubText
specStatusLabel.TextSize = 12
specStatusLabel.Font = Enum.Font.GothamBold
specStatusLabel.TextXAlignment = Enum.TextXAlignment.Center
specStatusLabel.LayoutOrder = 2
specStatusLabel.ZIndex = 5
specStatusLabel.Parent = spectatePage

local specSearch = Instance.new("TextBox")
specSearch.Size = UDim2.new(1, 0, 0, 32)
specSearch.BackgroundColor3 = Theme.Button
specSearch.BackgroundTransparency = 0.3
specSearch.BorderSizePixel = 0
specSearch.PlaceholderText = "Search player to spectate..."
specSearch.PlaceholderColor3 = Theme.SubText
specSearch.Text = ""
specSearch.TextColor3 = Theme.Text
specSearch.TextSize = 11
specSearch.Font = Enum.Font.Gotham
specSearch.ClearTextOnFocus = false
specSearch.LayoutOrder = 3
specSearch.ZIndex = 5
specSearch.Parent = spectatePage
Instance.new("UICorner", specSearch).CornerRadius = UDim.new(0, 4)

local specScroll = Instance.new("ScrollingFrame")
specScroll.Size = UDim2.new(1, 0, 0, 200)
specScroll.BackgroundTransparency = 1
specScroll.BorderSizePixel = 0
specScroll.ScrollBarThickness = 3
specScroll.ScrollBarImageColor3 = Theme.Accent
specScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
specScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
specScroll.LayoutOrder = 4
specScroll.ZIndex = 4
specScroll.Active = true
specScroll.Parent = spectatePage
local specLayout = Instance.new("UIListLayout", specScroll)
specLayout.SortOrder = Enum.SortOrder.LayoutOrder
specLayout.Padding = UDim.new(0, 3)

addButton(spectatePage, "Stop Spectating", function()
    Settings.Spectating = false
    Settings.SpectateTarget = nil
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end)
    specStatusLabel.Text = "Not Spectating"
    specStatusLabel.TextColor3 = Theme.SubText
end, 5)

local function startSpectate(player)
    if not player or not player.Character then return end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    Settings.SpectateTarget = player
    Settings.Spectating = true
    Camera.CameraSubject = hum
    specStatusLabel.Text = "Spectating: " .. player.DisplayName
    specStatusLabel.TextColor3 = Theme.Accent2
end

local specButtons = {}
local function refreshSpecList()
    for _, b in pairs(specButtons) do if b and b.Parent then b:Destroy() end end
    specButtons = {}
    local search = specSearch.Text:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if search == "" or player.DisplayName:lower():find(search, 1, true) or player.Name:lower():find(search, 1, true) then
                local isSpec = Settings.SpectateTarget == player
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -4, 0, 32)
                btn.BackgroundColor3 = isSpec and Theme.Accent or Theme.Button
                btn.BackgroundTransparency = isSpec and 0 or 0.3
                btn.BorderSizePixel = 0
                btn.Text = player.DisplayName
                btn.TextColor3 = Theme.Text
                btn.TextSize = 11
                btn.Font = Enum.Font.Gotham
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.AutoButtonColor = false
                btn.ZIndex = 5
                btn.Parent = specScroll
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
                local tp = Instance.new("UIPadding", btn)
                tp.PaddingLeft = UDim.new(0, 14)
                btn.MouseButton1Click:Connect(function()
                    if Settings.SpectateTarget == player and Settings.Spectating then
                        Settings.Spectating = false
                        Settings.SpectateTarget = nil
                        pcall(function()
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                                Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                            end
                        end)
                        specStatusLabel.Text = "Not Spectating"
                        specStatusLabel.TextColor3 = Theme.SubText
                    else
                        startSpectate(player)
                    end
                    refreshSpecList()
                end)
                specButtons[player.Name] = btn
            end
        end
    end
end
refreshSpecList()
specSearch:GetPropertyChangedSignal("Text"):Connect(refreshSpecList)
Players.PlayerAdded:Connect(function() task.wait(0.5); refreshSpecList() end)
Players.PlayerRemoving:Connect(function(player)
    if Settings.SpectateTarget == player then
        Settings.Spectating = false
        Settings.SpectateTarget = nil
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            end
        end)
    end
    task.wait(0.1)
    refreshSpecList()
end)

RunService.Heartbeat:Connect(function()
    if Settings.Spectating and Settings.SpectateTarget then
        if Settings.SpectateTarget.Character and Settings.SpectateTarget.Character:FindFirstChildOfClass("Humanoid") then
            local hum = Settings.SpectateTarget.Character:FindFirstChildOfClass("Humanoid")
            if Camera.CameraSubject ~= hum then Camera.CameraSubject = hum end
        end
    end
end)

-- =============================================
-- PAGE 10: THEMES
-- =============================================
addSection(themesPage, "❄ Theme Selection", 1)

local themeGrid = Instance.new("Frame")
themeGrid.Size = UDim2.new(1, 0, 0, 500)
themeGrid.BackgroundTransparency = 1
themeGrid.LayoutOrder = 2
themeGrid.ZIndex = 4
themeGrid.Parent = themesPage
local themeGridLayout = Instance.new("UIGridLayout", themeGrid)
themeGridLayout.CellSize = UDim2.new(0.25, -6, 0, 70)
themeGridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
themeGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

_G.SouHub_ThemeButtons = {}

local function applyTheme(themeName)
    if not Themes[themeName] then return end
    CurrentTheme = Themes[themeName]
    Theme.Bg = CurrentTheme.Bg
    Theme.Panel = CurrentTheme.Panel
    Theme.Header = Color3.fromRGB(CurrentTheme.Bg.R*255*0.9/255, CurrentTheme.Bg.G*255*0.9/255, CurrentTheme.Bg.B*255*0.9/255)
    Theme.Button = CurrentTheme.Button
    Theme.Accent = CurrentTheme.Primary
    Theme.Accent2 = CurrentTheme.Accent
    Theme.Text = CurrentTheme.Text
    Theme.SliderFill = CurrentTheme.Accent
    Theme.ToggleOn = CurrentTheme.Primary
    
    MainFrame.BackgroundColor3 = Theme.Bg
    mainStroke.Color = Theme.Border
    Header.BackgroundColor3 = Theme.Header
    logoLbl.TextColor3 = Theme.Text
    TabBar.BackgroundColor3 = Theme.Bg
    for _, b in pairs(tabButtons) do
        local isActive = b.Text == activeTab
        b.TextColor3 = isActive and Theme.Text or Theme.SubText
    end
    for _, btn in pairs(_G.SouHub_ThemeButtons) do
        if btn.Parent then
            local isActive = btn:GetAttribute("ThemeName") == themeName
            btn.BackgroundColor3 = isActive and Theme.Accent or Theme.Bg
            local stroke = btn:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Color = isActive and Theme.Accent2 or Theme.Border
                stroke.Transparency = isActive and 0 or 0.7
            end
        end
    end
    showToast("Theme Applied", CurrentTheme.Name, "success")
end

for name, theme in pairs(Themes) do
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Theme.Bg
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    btn.Parent = themeGrid
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Theme.Border
    stroke.Thickness = 1.5
    stroke.Transparency = 0.7
    
    local colorRow = Instance.new("Frame")
    colorRow.Size = UDim2.new(1, -12, 0, 24)
    colorRow.Position = UDim2.new(0, 6, 0, 6)
    colorRow.BackgroundTransparency = 1
    colorRow.ZIndex = 6
    colorRow.Parent = btn
    local cl = Instance.new("UIListLayout", colorRow)
    cl.FillDirection = Enum.FillDirection.Horizontal
    cl.Padding = UDim.new(0, 3)
    for i, c in ipairs({theme.Primary, theme.Accent, theme.Panel}) do
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 16, 0, 16)
        dot.BackgroundColor3 = c
        dot.BorderSizePixel = 0
        dot.ZIndex = 7
        dot.Parent = colorRow
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    end
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -8, 0, 18)
    nameLbl.Position = UDim2.new(0, 4, 1, -26)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = theme.Name
    nameLbl.TextColor3 = Theme.Text
    nameLbl.TextSize = 11
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.ZIndex = 6
    nameLbl.Parent = btn
    
    btn:SetAttribute("ThemeName", name)
    _G.SouHub_ThemeButtons[name] = btn
    
    if name == CurrentTheme.Name then
        stroke.Transparency = 0
        stroke.Color = Theme.Accent2
        btn.BackgroundColor3 = Theme.Accent
    end
    
    btn.MouseEnter:Connect(function()
        if btn:GetAttribute("ThemeName") ~= CurrentTheme.Name then
            tween(btn, 0.15, {BackgroundColor3 = Theme.Button})
            tween(stroke, 0.15, {Transparency = 0.3})
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn:GetAttribute("ThemeName") ~= CurrentTheme.Name then
            tween(btn, 0.15, {BackgroundColor3 = Theme.Bg})
            tween(stroke, 0.15, {Transparency = 0.7})
        end
    end)
    btn.MouseButton1Click:Connect(function() applyTheme(name) end)
end

-- =============================================
-- PAGE 11: MISC
-- =============================================
addSection(miscPage, "❄ Miscellaneous", 1)
local getAntiAFK = addToggle(miscPage, "Anti-AFK", true, function(v) Settings.AntiAFK = v end, 2)
local getWatermark = addToggle(miscPage, "Watermark", true, function(v) Settings.Watermark = v end, 3)
local getFPSDisplay = addToggle(miscPage, "FPS Display", true, function(v) Settings.FPSDisplay = v end, 4)
local getPingDisplay = addToggle(miscPage, "Ping Display", true, function(v) Settings.PingDisplay = v end, 5)
local getGuiTransparency = addSlider(miscPage, "GUI Transparency", 0, 500, 250, function(v)
    Settings.GuiTransparency = v
    MainFrame.BackgroundTransparency = 1 - (v / 500)
end, 6)

addSection(miscPage, "Config", 7)
addButton(miscPage, "Save Config", function()
    if writefile then
        pcall(function()
            local data = {Theme = CurrentTheme.Name, SpeedValue = Settings.SpeedHackValue, KillRange = Settings.KillRange}
            writefile("SouHub_config.json", HttpService:JSONEncode(data))
        end)
        showToast("Config", "Kaydedildi", "success")
    end
end, 8)

addButton(miscPage, "Load Config", function()
    if readfile and isfile then
        pcall(function()
            if isfile("SouHub_config.json") then
                local data = HttpService:JSONDecode(readfile("SouHub_config.json"))
                if data.Theme and Themes[data.Theme] then applyTheme(data.Theme) end
                if data.SpeedValue then getSpeedHackValue(data.SpeedValue) end
                if data.KillRange then getKillRange(data.KillRange) end
                showToast("Config", "Yuklendi", "success")
            end
        end)
    end
end, 9)

-- =============================================
-- SAYFA GECIS
-- =============================================
local function switchTab(tabName)
    if activeTab == tabName then return end
    for name, page in pairs(tabPages) do page.Visible = false end
    for name, btn in pairs(tabButtons) do
        local isActive = (name == tabName)
        tween(btn, 0.2, {TextColor3 = isActive and Theme.Text or Theme.SubText})
        local ind = btn:FindFirstChild("Indicator")
        if ind then
            tween(ind, 0.25, {Size = isActive and UDim2.new(0.6, 0, 0, 2) or UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Quart)
        end
    end
    local targetPage = tabPages[tabName]
    if targetPage then
        targetPage.Visible = true
        targetPage.Position = UDim2.new(0, 15, 0, 0)
        tween(targetPage, 0.25, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quint)
    end
    activeTab = tabName
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

-- =============================================
-- FEATURE LOOPS
-- =============================================
local flyBV = nil
local originalSizes = {}

-- Speed
RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if Settings.SpeedHack then
        local spd = Settings.SpeedHackValue
        hum.WalkSpeed = spd
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and spd > 16 then
            local md = hum.MoveDirection
            if md.Magnitude > 0 then
                hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
            end
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if Settings.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    if Settings.AntiFling and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Velocity.Magnitude > 200 then hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0) end
    end
end)

-- Flight
RunService.RenderStepped:Connect(function()
    if Settings.Flight and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        if not flyBV or flyBV.Parent ~= root then
            if flyBV then pcall(function() flyBV:Destroy() end) end
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyBV.Velocity = Vector3.new(0, 0, 0)
            flyBV.Parent = root
            local bg = Instance.new("BodyGyro")
            bg.Name = "SouHub_AntiGrav"
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.Parent = root
        end
        local spd = Settings.FlightSpeed
        if spd < 1 then spd = 1 end
        local dir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
        if dir.Magnitude > 0 then dir = dir.Unit end
        flyBV.Velocity = dir * spd
        local bg = root:FindFirstChild("SouHub_AntiGrav")
        if bg then bg.CFrame = Camera.CFrame end
    else
        if flyBV then pcall(function() flyBV:Destroy() end); flyBV = nil end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local bg = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("SouHub_AntiGrav")
            if bg then bg:Destroy() end
        end
    end
end)

-- Fullbright/NoFog/Time
RunService.Heartbeat:Connect(function()
    if Settings.Fullbright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.Brightness = OriginalLighting.Brightness
    end
    if Settings.NoFog then Lighting.FogEnd = 100000 else Lighting.FogEnd = OriginalLighting.FogEnd end
    if Settings.TimeChanger then Lighting.ClockTime = Settings.TimeValue else Lighting.ClockTime = OriginalLighting.ClockTime end
end)

-- Anti-Fling, God, Aura
RunService.Heartbeat:Connect(function()
    if Settings.GodMode and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end
end)

local lastDamageTick = 0
RunService.Heartbeat:Connect(function()
    if not Settings.DamageAura then return end
    if tick() - lastDamageTick < 0.5 then return end
    lastDamageTick = tick()
    if not LocalPlayer.Character then return end
    local lhrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not lhrp then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if thrp and (thrp.Position - lhrp.Position).Magnitude < Settings.DamageAuraRange then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then pcall(function() hum.Health = hum.Health - Settings.DamageAuraAmount end) end
            end
        end
    end
end)

-- Infinite Jump
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space and Settings.InfJump then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
    if input.KeyCode == Enum.KeyCode.RightShift then MainFrame.Visible = not MainFrame.Visible end
end)

-- Follow
RunService.Heartbeat:Connect(function()
    if not Settings.FollowPlayer or not Settings.FollowTarget then return end
    if not Settings.FollowTarget.Character then return end
    local thrp = Settings.FollowTarget.Character:FindFirstChild("HumanoidRootPart")
    local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if thrp and lhrp and (thrp.Position - lhrp.Position).Magnitude > 8 then
        lhrp.CFrame = lhrp.CFrame:Lerp(CFrame.new(thrp.Position) * (lhrp.CFrame - lhrp.Position), 0.1)
    end
end)

-- AUTO KILL
local lastKillTick = 0
RunService.RenderStepped:Connect(function()
    if not Settings.AutoKill then return end
    local target = Settings.AutoKillTarget
    if not target or not target.Character then
        for _, plr in pairs(Settings.SelectedPlayers) do
            if plr and plr.Character then
                local h = plr.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 then
                    Settings.AutoKillTarget = plr
                    target = plr
                    break
                end
            end
        end
        if not target then return end
    end
    local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local thrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not lhrp or not thrp then return end
    if (thrp.Position - lhrp.Position).Magnitude > Settings.KillRange then return end
    if Settings.AutoLock then
        local tp = target.Character:FindFirstChild("Head") or thrp
        pcall(function() Camera.CFrame = CFrame.new(Camera.CFrame.Position, tp.Position) end)
    end
    if Settings.AutoFire then
        pcall(function()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end)
    end
    if Settings.InstantKill and tick() - lastKillTick >= 0.1 then
        lastKillTick = tick()
        pcall(function()
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0; Settings.Kills = Settings.Kills + 1 end
        end)
    end
    if Settings.RapidKill and tick() - lastKillTick >= Settings.RapidKillDelay then
        lastKillTick = tick()
        pcall(function()
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then hum.Health = hum.Health - 25 end
        end)
    end
end)

-- Anti-AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function() vu:CaptureController(); vu:ClickButton2(Vector2.new()) end)
end)

-- =============================================
-- PLAYER LIST LOGIC
-- =============================================
local playerButtons = {}

local function updateSelectCount()
    local c = 0
    for _ in pairs(Settings.SelectedPlayers) do c = c + 1 end
    SelectCountLabel.Text = c .. " players selected"
end

local function isSelected(player) return Settings.SelectedPlayers[player.Name] ~= nil end

local function toggleSelect(player, btn)
    if isSelected(player) then
        Settings.SelectedPlayers[player.Name] = nil
        tween(btn, 0.2, {BackgroundColor3 = Theme.Button, BackgroundTransparency = 0.3})
        btn.TextColor3 = Theme.SubText
    else
        Settings.SelectedPlayers[player.Name] = player
        tween(btn, 0.2, {BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0})
        btn.TextColor3 = Theme.Text
    end
    updateSelectCount()
end

local function createPlayerButton(player)
    if player == LocalPlayer then return end
    local sel = isSelected(player)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 32)
    btn.BackgroundColor3 = sel and Theme.Accent or Theme.Button
    btn.BackgroundTransparency = sel and 0 or 0.3
    btn.BorderSizePixel = 0
    btn.Text = player.DisplayName
    btn.TextColor3 = Theme.Text
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    btn.Parent = PlayerScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    local tp = Instance.new("UIPadding", btn)
    tp.PaddingLeft = UDim.new(0, 14)
    btn.MouseButton1Click:Connect(function() toggleSelect(player, btn) end)
    playerButtons[player.Name] = btn
end

local function refreshPlayerList()
    for _, b in pairs(playerButtons) do if b and b.Parent then b:Destroy() end end
    playerButtons = {}
    local search = SearchBox.Text:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if search == "" or p.DisplayName:lower():find(search, 1, true) or p.Name:lower():find(search, 1, true) then
                createPlayerButton(p)
            end
        end
    end
    updateSelectCount()
end

SelectAllBtn.MouseButton1Click:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then Settings.SelectedPlayers[p.Name] = p end end
    refreshPlayerList()
end)
ClearAllBtn.MouseButton1Click:Connect(function()
    Settings.SelectedPlayers = {}
    Settings.CurrentTarget = nil
    Settings.AutoKillTarget = nil
    refreshPlayerList()
end)
refreshPlayerList()
Players.PlayerAdded:Connect(function() task.wait(0.5); refreshPlayerList() end)
Players.PlayerRemoving:Connect(function(player)
    Settings.SelectedPlayers[player.Name] = nil
    if Settings.CurrentTarget == player then Settings.CurrentTarget = nil end
    if Settings.AutoKillTarget == player then Settings.AutoKillTarget = nil end
    task.wait(0.1)
    refreshPlayerList()
end)
SearchBox:GetPropertyChangedSignal("Text"):Connect(refreshPlayerList)

-- =============================================
-- FOV Circle + ESP
-- =============================================
local fovCircle, usingDrawing = nil, false
pcall(function()
    fovCircle = Drawing.new("Circle")
    fovCircle.Color = Theme.Accent
    fovCircle.Thickness = 1
    fovCircle.NumSides = 64
    fovCircle.Radius = 150
    fovCircle.Filled = false
    fovCircle.Visible = true
    fovCircle.Transparency = 0.7
    usingDrawing = true
end)

highlightObjects = {}

local function addHighlight(player)
    if not player or not player.Character then return end
    if highlightObjects[player.Name] then
        if highlightObjects[player.Name].Parent ~= player.Character then
            highlightObjects[player.Name]:Destroy()
            highlightObjects[player.Name] = nil
        else return end
    end
    local hl = Instance.new("Highlight")
    hl.Name = "SouHub_Highlight"
    hl.FillColor = Settings.HighlightColor
    hl.OutlineColor = Settings.HighlightColor
    hl.FillTransparency = Settings.HighlightFillTransparency
    hl.OutlineTransparency = 0.3
    hl.Adornee = player.Character
    hl.Parent = player.Character
    highlightObjects[player.Name] = hl
end

function removeHighlight(playerName)
    if highlightObjects[playerName] then
        pcall(function() highlightObjects[playerName]:Destroy() end)
        highlightObjects[playerName] = nil
    end
end

local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local selected = Settings.SelectedPlayers[player.Name] ~= nil
            if Settings.ESPEnabled and selected and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    addHighlight(player)
                else removeHighlight(player.Name) end
            else removeHighlight(player.Name) end
        end
    end
end

-- =============================================
-- AIMBOT (Camlock)
-- =============================================
local locked = false
local function resetInput()
    pcall(function()
        if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
        if not UserInputService.MouseIconEnabled then UserInputService.MouseIconEnabled = true end
        locked = false
        Settings.CurrentTarget = nil
    end)
end

local function isVisible(targetPart)
    if not Settings.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {LocalPlayer.Character}
    local result = workspace:Raycast(origin, targetPart.Position - origin, rp)
    if result then
        local tc = targetPart:FindFirstAncestorWhichIsA("Model")
        if tc and result.Instance:IsDescendantOf(tc) then return true end
        return false
    end
    return true
end

local function isDowned(character)
    if not character then return false end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return (hum.Health / hum.MaxHealth) < 0.20
end

local function getPredictedPosition(part)
    if not part or not part.Parent then return part and part.Position or Vector3.new() end
    if Settings.Prediction <= 0 then return part.Position end
    local vel = Vector3.new(0, 0, 0)
    pcall(function() vel = part.AssemblyLinearVelocity end)
    local ping = 0
    pcall(function() ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000 end)
    return part.Position + (vel * ((Settings.Prediction * 0.3) + (ping * 0.5)))
end

local function getClosestFromSelected()
    local closest, shortest = nil, math.huge
    local fov = Settings.FOVRadius
    for _, player in pairs(Settings.SelectedPlayers) do
        if player and player.Character and player.Character:FindFirstChild(Settings.TargetPart) then
            local part = player.Character[Settings.TargetPart]
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                if Settings.SkipDowned and isDowned(player.Character) then continue end
                local sp, onScreen = Camera:WorldToScreenPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if d < fov and d < shortest then
                        if Settings.StickyAim or isVisible(part) then
                            shortest = d
                            closest = player
                        end
                    end
                end
            end
        end
    end
    return closest
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe and not UserInputService:GetFocusedTextBox() then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if Settings.Camlock then
            Settings.CurrentTarget = getClosestFromSelected()
            locked = Settings.CurrentTarget ~= nil
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        locked = false
        Settings.CurrentTarget = nil
    end
end)

RunService.RenderStepped:Connect(function()
    if usingDrawing and fovCircle then
        fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        fovCircle.Radius = Settings.FOVRadius
        fovCircle.Visible = Settings.FOVVisible
        fovCircle.Color = Theme.Accent
    end
    updateESP()
    if Settings.AlwaysOn and Settings.Camlock then
        if not Settings.CurrentTarget or not Settings.CurrentTarget.Character then
            Settings.CurrentTarget = getClosestFromSelected()
            locked = Settings.CurrentTarget ~= nil
        end
    end
    if locked and Settings.CurrentTarget and Settings.CurrentTarget.Character then
        local part = Settings.CurrentTarget.Character:FindFirstChild(Settings.TargetPart)
        if not part then part = Settings.CurrentTarget.Character:FindFirstChild("HumanoidRootPart") end
        if part then
            local hum = Settings.CurrentTarget.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local canSee = isVisible(part)
                if canSee or Settings.StickyAim then
                    local predictedPos = getPredictedPosition(part)
                    local targetCFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.Smoothness)
                else
                    if Settings.AutoSwitch then
                        Settings.CurrentTarget = getClosestFromSelected()
                        locked = Settings.CurrentTarget ~= nil
                    else locked = false; Settings.CurrentTarget = nil end
                end
            else
                if Settings.AutoSwitch then
                    Settings.CurrentTarget = getClosestFromSelected()
                    locked = Settings.CurrentTarget ~= nil
                else locked = false; Settings.CurrentTarget = nil end
            end
        end
    end
end)

-- =============================================
-- WATERMARK
-- =============================================
local Watermark = Instance.new("Frame")
Watermark.Size = UDim2.new(0, 220, 0, 38)
Watermark.Position = UDim2.new(0, 15, 0, 15)
Watermark.BackgroundColor3 = Theme.Panel
Watermark.BackgroundTransparency = 0.1
Watermark.BorderSizePixel = 0
Watermark.Visible = true
Watermark.ZIndex = 500
Watermark.Parent = ScreenGui
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 6)
local wmStroke = Instance.new("UIStroke", Watermark)
wmStroke.Color = Theme.Accent
wmStroke.Thickness = 1
wmStroke.Transparency = 0.3

local wmTitle = Instance.new("TextLabel")
wmTitle.Size = UDim2.new(1, 0, 0, 18)
wmTitle.Position = UDim2.new(0, 12, 0, 8)
wmTitle.BackgroundTransparency = 1
wmTitle.Text = "❄ Sou Hub"
wmTitle.TextColor3 = Theme.Text
wmTitle.TextSize = 11
wmTitle.Font = Enum.Font.GothamBold
wmTitle.TextXAlignment = Enum.TextXAlignment.Left
wmTitle.ZIndex = 501
wmTitle.Parent = Watermark

local wmInfo = Instance.new("TextLabel")
wmInfo.Size = UDim2.new(1, 0, 0, 12)
wmInfo.Position = UDim2.new(0, 12, 0, 24)
wmInfo.BackgroundTransparency = 1
wmInfo.Text = "60 FPS  |  0 MS"
wmInfo.TextColor3 = Theme.SubText
wmInfo.TextSize = 9
wmInfo.Font = Enum.Font.Code
wmInfo.TextXAlignment = Enum.TextXAlignment.Left
wmInfo.ZIndex = 501
wmInfo.Parent = Watermark

-- Watermark drag
local wmDrag, wmDragInput, wmStart, wmStartPos
Watermark.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        wmDrag = true
        wmStart = input.Position
        wmStartPos = Watermark.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then wmDrag = false end
        end)
    end
end)
Watermark.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then wmDragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == wmDragInput and wmDrag then
        local d = input.Position - wmStart
        Watermark.Position = UDim2.new(wmStartPos.X.Scale, wmStartPos.X.Offset + d.X, wmStartPos.Y.Scale, wmStartPos.Y.Offset + d.Y)
    end
end)

local fpsCount, fpsTime = 0, tick()
RunService.RenderStepped:Connect(function()
    fpsCount = fpsCount + 1
    if tick() - fpsTime >= 1 then
        local fps = fpsCount
        local ping = 0
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        if Settings.FPSDisplay or Settings.PingDisplay then
            local fpsStr = Settings.FPSDisplay and (fps .. " FPS") or ""
            local pingStr = Settings.PingDisplay and (ping .. " MS") or ""
            wmInfo.Text = fpsStr .. "  |  " .. pingStr
        end
        fpsCount = 0
        fpsTime = tick()
    end
end)
RunService.RenderStepped:Connect(function() Watermark.Visible = Settings.Watermark end)

-- =============================================
-- BILDIRIM
-- =============================================
print("[Sou Hub] Winter Edition v3 yuklendi!")
print("[Sou Hub] 11 sekme aktif - Tum ozellikler eklendi")

task.wait(0.5)
showToast("❄ Sou Hub", "Winter Edition v3 hazir!", "success")
task.wait(0.5)
showToast("Sekmeler", "11 sekme - Sag/Sol ok ile kaydir", "info")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❄ Sou Hub",
        Text = "Winter Edition v3 loaded!",
        Duration = 5
    })
end)
