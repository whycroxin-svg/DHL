--[[
    DHL VIP - ULTRA PREMIUM EDITION
    Gercek VIP hissi
    Acilis animasyonu, particle, glow, ripple
    Hook YOK
]]

print("[DHL VIP] Yukleniyor...")

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

-- =============================================
-- GUI PARENT
-- =============================================
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
-- VIP THEMES (12 Premium)
-- =============================================
local Themes = {
    Gold     = {Name="Gold",     Primary=Color3.fromRGB(220,180,60),  Accent=Color3.fromRGB(255,220,120), Bg=Color3.fromRGB(20,18,10),  Panel=Color3.fromRGB(35,30,15),  Button=Color3.fromRGB(55,48,25),  Text=Color3.fromRGB(255,220,120), G1=Color3.fromRGB(255,200,60), G2=Color3.fromRGB(255,240,180)},
    Diamond  = {Name="Diamond",  Primary=Color3.fromRGB(120,220,255), Accent=Color3.fromRGB(200,240,255), Bg=Color3.fromRGB(10,20,30),  Panel=Color3.fromRGB(18,35,55),  Button=Color3.fromRGB(30,55,80),  Text=Color3.fromRGB(180,230,255), G1=Color3.fromRGB(120,220,255), G2=Color3.fromRGB(220,240,255)},
    Ruby     = {Name="Ruby",     Primary=Color3.fromRGB(220,40,80),   Accent=Color3.fromRGB(255,120,150), Bg=Color3.fromRGB(25,10,15),  Panel=Color3.fromRGB(45,15,25),  Button=Color3.fromRGB(70,25,40),  Text=Color3.fromRGB(255,150,180), G1=Color3.fromRGB(255,60,100), G2=Color3.fromRGB(150,20,80)},
    Sapphire = {Name="Sapphire", Primary=Color3.fromRGB(50,100,220),  Accent=Color3.fromRGB(120,170,255), Bg=Color3.fromRGB(10,15,30),  Panel=Color3.fromRGB(20,30,55),  Button=Color3.fromRGB(35,50,90),  Text=Color3.fromRGB(150,190,255), G1=Color3.fromRGB(50,100,255), G2=Color3.fromRGB(120,180,255)},
    Emerald  = {Name="Emerald",  Primary=Color3.fromRGB(50,200,120),  Accent=Color3.fromRGB(120,255,180), Bg=Color3.fromRGB(10,25,18),  Panel=Color3.fromRGB(20,45,32),  Button=Color3.fromRGB(35,70,50),  Text=Color3.fromRGB(150,255,200), G1=Color3.fromRGB(50,220,140), G2=Color3.fromRGB(120,255,200)},
    Obsidian = {Name="Obsidian", Primary=Color3.fromRGB(80,80,90),    Accent=Color3.fromRGB(200,200,220), Bg=Color3.fromRGB(8,8,12),    Panel=Color3.fromRGB(20,20,26),  Button=Color3.fromRGB(38,38,46),  Text=Color3.fromRGB(200,200,220), G1=Color3.fromRGB(120,120,140), G2=Color3.fromRGB(60,60,80)},
    Amethyst = {Name="Amethyst", Primary=Color3.fromRGB(160,80,220),  Accent=Color3.fromRGB(210,150,255), Bg=Color3.fromRGB(18,10,30),  Panel=Color3.fromRGB(35,20,55),  Button=Color3.fromRGB(55,32,80),  Text=Color3.fromRGB(210,160,255), G1=Color3.fromRGB(180,90,255), G2=Color3.fromRGB(220,160,255)},
    Neon     = {Name="Neon",     Primary=Color3.fromRGB(255,20,180),  Accent=Color3.fromRGB(0,255,220), Bg=Color3.fromRGB(15,5,20),   Panel=Color3.fromRGB(30,10,35),  Button=Color3.fromRGB(50,18,55),  Text=Color3.fromRGB(255,120,220), G1=Color3.fromRGB(255,20,180), G2=Color3.fromRGB(0,255,220)},
    Cyber    = {Name="Cyber",    Primary=Color3.fromRGB(0,240,255),   Accent=Color3.fromRGB(255,0,200), Bg=Color3.fromRGB(8,15,20),   Panel=Color3.fromRGB(15,28,38),  Button=Color3.fromRGB(25,45,60),  Text=Color3.fromRGB(100,240,255), G1=Color3.fromRGB(0,240,255), G2=Color3.fromRGB(255,0,200)},
    Fire     = {Name="Fire",     Primary=Color3.fromRGB(255,100,20),  Accent=Color3.fromRGB(255,200,80), Bg=Color3.fromRGB(25,10,5),   Panel=Color3.fromRGB(45,20,10),  Button=Color3.fromRGB(70,32,15),  Text=Color3.fromRGB(255,180,120), G1=Color3.fromRGB(255,120,30), G2=Color3.fromRGB(255,220,100)},
    Ice      = {Name="Ice",      Primary=Color3.fromRGB(100,180,255), Accent=Color3.fromRGB(220,240,255), Bg=Color3.fromRGB(10,18,25),  Panel=Color3.fromRGB(20,35,48),  Button=Color3.fromRGB(35,55,72),  Text=Color3.fromRGB(180,220,255), G1=Color3.fromRGB(100,180,255), G2=Color3.fromRGB(240,250,255)},
    Rose     = {Name="Rose",     Primary=Color3.fromRGB(255,120,160), Accent=Color3.fromRGB(255,200,220), Bg=Color3.fromRGB(25,12,18),  Panel=Color3.fromRGB(45,20,32),  Button=Color3.fromRGB(70,32,48),  Text=Color3.fromRGB(255,180,210), G1=Color3.fromRGB(255,120,160), G2=Color3.fromRGB(255,220,240)},
}
local CurrentTheme = Themes.Gold

-- =============================================
-- ORIGINAL LIGHTING
-- =============================================
local OriginalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    ClockTime = Lighting.ClockTime,
}

-- =============================================
-- SETTINGS
-- =============================================
local Settings = {
    CamlockEnabled = true, WallCheck = false, Smoothness = 0.450, Prediction = 0.100,
    TargetPart = "Head", Mode = "RightMouseClick", StickyAim = true, AutoSwitch = true,
    SkipDowned = true, AlwaysOn = false, TriggerBot = false, FOVVisible = true,
    FOVRadius = 150, FOVUseTheme = true,
    
    ESPEnabled = true, ESPNames = true, ESPHealth = true, ESPDistance = true,
    ESPTracers = true, ESPBoxes = false, ESPTracerOrigin = "Bottom",
    HighlightFillTransparency = 0.35, HighlightColor = Color3.fromRGB(220,180,60),
    
    SpeedEnabled = false, SpeedValue = 16, JumpPowerEnabled = false, JumpPowerValue = 50,
    InfiniteJump = false, Noclip = false, FlyEnabled = false, FlySpeed = 50, NoclipFly = false,
    
    AntiAFK = true, HitboxExpand = false, HitboxSize = 1.3,
    Watermark = true, FPSDisplay = true, PingDisplay = true, GuiTransparency = 0,
    
    FollowPlayer = false, FollowTarget = nil,
    DamageAura = false, DamageAuraRange = 10, DamageAuraAmount = 5,
    AntiFling = false, GodMode = false, CharacterSize = false, CharacterSizeValue = 1.0,
    
    Fullbright = false, NoFog = false, RemoveShadows = false,
    TimeChanger = false, TimeValue = 12,
    
    Kills = 0, SessionStart = tick(),
    SelectedPlayers = {}, CurrentTarget = nil,
    ParticlesEnabled = true,
}

-- =============================================
-- CLEANUP
-- =============================================
for _, loc in ipairs({game:GetService("CoreGui"), LocalPlayer:FindFirstChild("PlayerGui")}) do
    pcall(function() local o = loc:FindFirstChild("DHLV2_babaniz"); if o then o:Destroy() end end)
end
pcall(function() if gethui then local o = gethui():FindFirstChild("DHLV2_babaniz"); if o then o:Destroy() end end end)
for _, plr in ipairs(Players:GetPlayers()) do
    pcall(function() if plr.Character then local h = plr.Character:FindFirstChild("DHL_Highlight"); if h then h:Destroy() end end end)
end

-- =============================================
-- TWEEN HELPER
-- =============================================
local function tween(obj, time, props, style, dir)
    local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- =============================================
-- GUI PARENT
-- =============================================
local guiParent = getGuiParent()
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DHLV2_babaniz"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
if guiParent:IsA("ScreenGui") then
    ScreenGui = guiParent; ScreenGui.Name = "DHLV2_babaniz"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 999
else ScreenGui.Parent = guiParent end

-- =============================================
-- INTRO SPLASH SCREEN (ACILIS ANIMASYONU)
-- =============================================
local splashGui = Instance.new("ScreenGui")
splashGui.Name = "DHL_Splash"
splashGui.ResetOnSpawn = false
splashGui.DisplayOrder = 10000
splashGui.IgnoreGuiInset = true
splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
splashGui.Parent = guiParent

local splashFrame = Instance.new("Frame")
splashFrame.Size = UDim2.new(1, 0, 1, 0)
splashFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
splashFrame.BackgroundTransparency = 0
splashFrame.BorderSizePixel = 0
splashFrame.ZIndex = 1
splashFrame.Parent = splashGui

-- Splash gradient
local splashGrad = Instance.new("UIGradient", splashFrame)
splashGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15,10,5)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25,18,8)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10,8,4)),
})

-- Splash icerik container
local splashContent = Instance.new("Frame")
splashContent.Size = UDim2.new(0, 500, 0, 200)
splashContent.Position = UDim2.new(0.5, -250, 0.5, -100)
splashContent.BackgroundTransparency = 1
splashContent.ZIndex = 2
splashContent.Parent = splashFrame

-- VIP Crown ikonu
local crownLabel = Instance.new("TextLabel")
crownLabel.Size = UDim2.new(1, 0, 0, 80)
crownLabel.Position = UDim2.new(0, 0, 0, 0)
crownLabel.BackgroundTransparency = 1
crownLabel.Text = "👑"
crownLabel.TextColor3 = Color3.fromRGB(255,200,60)
crownLabel.TextSize = 72
crownLabel.Font = Enum.Font.GothamBold
crownLabel.ZIndex = 3
crownLabel.Parent = splashContent

-- DHL VIP yazisi
local splashTitle = Instance.new("TextLabel")
splashTitle.Size = UDim2.new(1, 0, 0, 60)
splashTitle.Position = UDim2.new(0, 0, 0, 70)
splashTitle.BackgroundTransparency = 1
splashTitle.Text = "DHL VIP"
splashTitle.TextColor3 = Color3.fromRGB(255,255,255)
splashTitle.TextSize = 56
splashTitle.Font = Enum.Font.GothamBlack
splashTitle.ZIndex = 3
splashTitle.Parent = splashContent

local splashTitleGrad = Instance.new("UIGradient", splashTitle)
splashTitleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,220,120)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220,180,60)),
})

-- Alt yazi
local splashSub = Instance.new("TextLabel")
splashSub.Size = UDim2.new(1, 0, 0, 24)
splashSub.Position = UDim2.new(0, 0, 0, 135)
splashSub.BackgroundTransparency = 1
splashSub.Text = "ULTRA PREMIUM EDITION"
splashSub.TextColor3 = Color3.fromRGB(220,180,60)
splashSub.TextSize = 16
splashSub.Font = Enum.Font.GothamBold
splashSub.ZIndex = 3
splashSub.Parent = splashContent

-- Loading bar
local loadBarBg = Instance.new("Frame")
loadBarBg.Size = UDim2.new(0, 300, 0, 4)
loadBarBg.Position = UDim2.new(0.5, -150, 0, 175)
loadBarBg.BackgroundColor3 = Color3.fromRGB(40,30,15)
loadBarBg.BorderSizePixel = 0
loadBarBg.ZIndex = 3
loadBarBg.Parent = splashContent
Instance.new("UICorner", loadBarBg).CornerRadius = UDim.new(1, 0)

local loadBarFill = Instance.new("Frame")
loadBarFill.Size = UDim2.new(0, 0, 1, 0)
loadBarFill.BackgroundColor3 = Color3.fromRGB(255,200,60)
loadBarFill.BorderSizePixel = 0
loadBarFill.ZIndex = 4
loadBarFill.Parent = loadBarBg
Instance.new("UICorner", loadBarFill).CornerRadius = UDim.new(1, 0)

local loadBarGrad = Instance.new("UIGradient", loadBarFill)
loadBarGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,200,60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,240,180)),
})

-- Acilis animasyonu
splashContent.Size = UDim2.new(0, 0, 0, 0)
splashContent.Position = UDim2.new(0.5, 0, 0.5, 0)
crownLabel.TextTransparency = 1
splashTitle.TextTransparency = 1
splashSub.TextTransparency = 1
loadBarBg.BackgroundTransparency = 1

task.spawn(function()
    task.wait(0.1)
    
    -- Content buyume
    tween(splashContent, 0.5, {Size = UDim2.new(0, 500, 0, 200), Position = UDim2.new(0.5, -250, 0.5, -100)}, Enum.EasingStyle.Back)
    task.wait(0.3)
    
    -- Crown pop
    tween(crownLabel, 0.3, {TextTransparency = 0}, Enum.EasingStyle.Back)
    task.wait(0.15)
    
    -- Title fade
    tween(splashTitle, 0.4, {TextTransparency = 0})
    task.wait(0.2)
    
    -- Subtitle
    tween(splashSub, 0.4, {TextTransparency = 0})
    task.wait(0.15)
    
    -- Loading bar
    tween(loadBarBg, 0.2, {BackgroundTransparency = 0})
    tween(loadBarFill, 1.2, {Size = UDim2.new(1, 0, 1, 0)}, Enum.EasingStyle.Quart)
    task.wait(1.3)
    
    -- Splash kaybolma
    tween(splashContent, 0.3, {Size = UDim2.new(0, 600, 0, 240), Position = UDim2.new(0.5, -300, 0.5, -120)}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    tween(crownLabel, 0.3, {TextTransparency = 1})
    tween(splashTitle, 0.3, {TextTransparency = 1})
    tween(splashSub, 0.3, {TextTransparency = 1})
    tween(loadBarBg, 0.2, {BackgroundTransparency = 1})
    tween(splashFrame, 0.5, {BackgroundTransparency = 1})
    task.wait(0.6)
    splashGui:Destroy()
end)

-- =============================================
-- TOAST BILDIRIM
-- =============================================
local toastContainer = Instance.new("Frame")
toastContainer.Name = "ToastContainer"
toastContainer.Size = UDim2.new(0, 320, 1, -20)
toastContainer.Position = UDim2.new(1, -340, 0, 10)
toastContainer.BackgroundTransparency = 1
toastContainer.ZIndex = 1000
toastContainer.Parent = ScreenGui

local toastLayout = Instance.new("UIListLayout", toastContainer)
toastLayout.SortOrder = Enum.SortOrder.LayoutOrder
toastLayout.Padding = UDim.new(0, 10)
toastLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local function showToast(title, message, toastType)
    toastType = toastType or "info"
    local colors = {
        info = CurrentTheme.Primary,
        success = Color3.fromRGB(50, 220, 120),
        warning = Color3.fromRGB(255, 180, 50),
        error = Color3.fromRGB(240, 60, 80),
        vip = Color3.fromRGB(255, 200, 60),
    }
    local icons = {info = "ℹ", success = "✓", warning = "⚠", error = "✕", vip = "👑"}
    
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 0, 0, 60)
    toast.Position = UDim2.new(1, 20, 0, 0)
    toast.BackgroundColor3 = CurrentTheme.Panel
    toast.BackgroundTransparency = 0.05
    toast.BorderSizePixel = 0
    toast.ZIndex = 1001
    toast.Parent = toastContainer
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", toast)
    stroke.Color = colors[toastType] or CurrentTheme.Primary
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    
    local toastGrad = Instance.new("UIGradient", toast)
    toastGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, CurrentTheme.Panel),
        ColorSequenceKeypoint.new(1, CurrentTheme.Bg),
    })
    toastGrad.Rotation = 45
    
    -- Sol renkli serit
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, -14)
    bar.Position = UDim2.new(0, 5, 0, 7)
    bar.BackgroundColor3 = colors[toastType] or CurrentTheme.Primary
    bar.BorderSizePixel = 0
    bar.ZIndex = 1002
    bar.Parent = toast
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 36, 0, 36)
    icon.Position = UDim2.new(0, 16, 0.5, -18)
    icon.BackgroundTransparency = 1
    icon.Text = icons[toastType] or "ℹ"
    icon.TextColor3 = colors[toastType] or CurrentTheme.Primary
    icon.TextSize = 22
    icon.Font = Enum.Font.GothamBold
    icon.ZIndex = 1002
    icon.Parent = toast
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -70, 0, 22)
    titleLbl.Position = UDim2.new(0, 60, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(255,255,255)
    titleLbl.TextSize = 14
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 1002
    titleLbl.Parent = toast
    
    local msgLbl = Instance.new("TextLabel")
    msgLbl.Size = UDim2.new(1, -70, 0, 18)
    msgLbl.Position = UDim2.new(0, 60, 0, 32)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text = message
    msgLbl.TextColor3 = Color3.fromRGB(190,190,200)
    msgLbl.TextSize = 11
    msgLbl.Font = Enum.Font.Gotham
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.ZIndex = 1002
    msgLbl.Parent = toast
    
    -- Giris animasyonu (pop)
    task.spawn(function()
        tween(toast, 0.4, {Size = UDim2.new(0, 320, 0, 60), Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back)
        task.wait(0.5)
        tween(toast, 0.3, {Position = UDim2.new(0, 0, 0, 0)})
    end)
    
    -- Cikis animasyonu
    task.delay(3.5, function()
        tween(toast, 0.35, {Position = UDim2.new(1, 20, 0, 0)}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        tween(toast, 0.35, {BackgroundTransparency = 1})
        tween(icon, 0.35, {TextTransparency = 1})
        tween(titleLbl, 0.35, {TextTransparency = 1})
        tween(msgLbl, 0.35, {TextTransparency = 1})
        tween(bar, 0.35, {BackgroundTransparency = 1})
        task.wait(0.4)
        toast:Destroy()
    end)
end

-- =============================================
-- DRAGGABLE
-- =============================================
local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or frame
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- =============================================
-- MAIN FRAME (Acilis Animasyonlu)
-- =============================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 720, 0, 500)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -250)
MainFrame.BackgroundColor3 = CurrentTheme.Bg
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Active = false
MainFrame.Visible = false -- Acilis animasyonundan sonra gorunecek
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

-- Glow pulse stroke
local glowStroke = Instance.new("UIStroke", MainFrame)
glowStroke.Color = CurrentTheme.Primary
glowStroke.Thickness = 2
glowStroke.Transparency = 0.3

task.spawn(function()
    while MainFrame.Parent do
        tween(glowStroke, 2.5, {Transparency = 0.7, Thickness = 1.5}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.5)
        tween(glowStroke, 2.5, {Transparency = 0.1, Thickness = 2.5}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.5)
    end
end)

-- Ana gradient
local mainGradient = Instance.new("UIGradient", MainFrame)
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 22, 15)),
    ColorSequenceKeypoint.new(0.5, CurrentTheme.Bg),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 13, 8)),
})
mainGradient.Rotation = 135

-- Arka plan partikulleri
local particleContainer = Instance.new("Frame")
particleContainer.Name = "Particles"
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.ClipsDescendants = true
particleContainer.ZIndex = 1
particleContainer.Parent = MainFrame

-- Partikul olusturucu
task.spawn(function()
    while particleContainer.Parent do
        if Settings.ParticlesEnabled then
            local p = Instance.new("Frame")
            p.Size = UDim2.new(0, math.random(2,5), 0, math.random(2,5))
            p.Position = UDim2.new(math.random(), 0, 1, 0)
            p.BackgroundColor3 = CurrentTheme.Accent
            p.BackgroundTransparency = 0.3
            p.BorderSizePixel = 0
            p.ZIndex = 2
            p.Parent = particleContainer
            Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
            
            local targetY = -0.05
            local duration = math.random(6, 12)
            local drift = math.random(-30, 30) / 100
            
            tween(p, duration, {
                Position = UDim2.new(p.Position.X.Scale + drift, 0, targetY, 0),
                BackgroundTransparency = 1
            }, Enum.EasingStyle.Linear)
            
            task.delay(duration, function() p:Destroy() end)
        end
        task.wait(math.random(30, 100) / 100)
    end
end)

-- Background image
local BgImage = Instance.new("ImageLabel")
BgImage.Name = "Background"; BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1; BgImage.ImageTransparency = 0.95
BgImage.ScaleType = Enum.ScaleType.Crop; BgImage.ZIndex = 0; BgImage.Parent = MainFrame
Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 16)
pcall(function()
    local fn = "dhl_bg.jpg"
    local url = "https://raw.githubusercontent.com/whycroxin-svg/ahh/main/hile%20gui%20arka%20plan.jpg"
    if writefile and isfile and getcustomasset then
        if not isfile(fn) then writefile(fn, game:HttpGet(url)) end
        BgImage.Image = getcustomasset(fn)
    else
        BgImage.Image = url
    end
end)

local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1, 0, 0, 55); DragHandle.BackgroundTransparency = 1
DragHandle.Text = ""; DragHandle.AutoButtonColor = false; DragHandle.ZIndex = 10; DragHandle.Parent = MainFrame
makeDraggable(MainFrame, DragHandle)

-- Baslik
local tl = Instance.new("TextLabel")
tl.Size = UDim2.new(1, 0, 0, 26); tl.Position = UDim2.new(0, 22, 0, 10)
tl.BackgroundTransparency = 1
tl.Text = "👑  DHL VIP"
tl.TextColor3 = Color3.fromRGB(255,255,255)
tl.TextSize = 22
tl.Font = Enum.Font.GothamBlack
tl.TextXAlignment = Enum.TextXAlignment.Left
tl.ZIndex = 5
tl.Parent = MainFrame
local titleGradient = Instance.new("UIGradient", tl)
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CurrentTheme.G1),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1, CurrentTheme.G2),
})

local cl = Instance.new("TextLabel")
cl.Size = UDim2.new(1, 0, 0, 14); cl.Position = UDim2.new(0, 22, 0, 34)
cl.BackgroundTransparency = 1
cl.Text = "ULTRA PREMIUM EDITION  •  v6"
cl.TextColor3 = Color3.fromRGB(170,170,180)
cl.TextSize = 10
cl.Font = Enum.Font.GothamBold
cl.TextXAlignment = Enum.TextXAlignment.Left
cl.ZIndex = 5
cl.Parent = MainFrame

-- Kapat butonu
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -44, 0, 14)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 25, 30); closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"; closeBtn.TextColor3 = Color3.fromRGB(255,120,120)
closeBtn.TextSize = 14; closeBtn.Font = Enum.Font.GothamBold; closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 11; closeBtn.Parent = MainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(220, 60, 60), BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255,255,255), Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(1, -46, 0, 12)})
end)
closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(60, 25, 30), BackgroundTransparency = 0.3, TextColor3 = Color3.fromRGB(255,120,120), Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -44, 0, 14)})
end)
closeBtn.MouseButton1Click:Connect(function()
    tween(MainFrame, 0.4, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.4)
    MainFrame.Visible = false
    MainFrame.Size = UDim2.new(0, 720, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -360, 0.5, -250)
    MainFrame.BackgroundTransparency = 0
end)

-- =============================================
-- SIDEBAR
-- =============================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 165, 1, -110)
Sidebar.Position = UDim2.new(0, 15, 0, 95)
Sidebar.BackgroundColor3 = CurrentTheme.Panel
Sidebar.BackgroundTransparency = 0.05
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 4
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

-- Animated gradient sidebar
local sideGradient = Instance.new("UIGradient", Sidebar)
sideGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CurrentTheme.Panel),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(CurrentTheme.Panel.R*255*0.6/255, CurrentTheme.Panel.G*255*0.6/255, CurrentTheme.Panel.B*255*0.6/255)),
    ColorSequenceKeypoint.new(1, CurrentTheme.Panel),
})
sideGradient.Rotation = 0

task.spawn(function()
    local rotation = 0
    while Sidebar.Parent do
        rotation = rotation + 1
        sideGradient.Rotation = rotation % 360
        task.wait(0.05)
    end
end)

local sideStroke = Instance.new("UIStroke", Sidebar)
sideStroke.Color = CurrentTheme.Primary
sideStroke.Thickness = 1.2
sideStroke.Transparency = 0.5

-- VIP Profile Frame
local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(1, -12, 0, 65)
profileFrame.Position = UDim2.new(0, 6, 0, 6)
profileFrame.BackgroundColor3 = CurrentTheme.Button
profileFrame.BackgroundTransparency = 0.4
profileFrame.BorderSizePixel = 0
profileFrame.ZIndex = 5
profileFrame.Parent = Sidebar
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(0, 10)

local profGrad = Instance.new("UIGradient", profileFrame)
profGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CurrentTheme.Button),
    ColorSequenceKeypoint.new(1, CurrentTheme.Panel),
})

-- Avatar
local avatarCircle = Instance.new("Frame")
avatarCircle.Size = UDim2.new(0, 42, 0, 42)
avatarCircle.Position = UDim2.new(0, 8, 0.5, -21)
avatarCircle.BackgroundColor3 = CurrentTheme.Primary
avatarCircle.BorderSizePixel = 0
avatarCircle.ZIndex = 6
avatarCircle.Parent = profileFrame
Instance.new("UICorner", avatarCircle).CornerRadius = UDim.new(1, 0)

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(1, -4, 1, -4)
avatarImg.Position = UDim2.new(0, 2, 0, 2)
avatarImg.BackgroundTransparency = 1
avatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
avatarImg.ZIndex = 7
avatarImg.Parent = avatarCircle
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

-- VIP Crown badge on avatar
local vipBadge = Instance.new("TextLabel")
vipBadge.Size = UDim2.new(0, 20, 0, 20)
vipBadge.Position = UDim2.new(1, -8, 1, -8)
vipBadge.BackgroundColor3 = Color3.fromRGB(255,200,60)
vipBadge.BorderSizePixel = 0
vipBadge.Text = "👑"
vipBadge.TextColor3 = Color3.fromRGB(80,60,10)
vipBadge.TextSize = 12
vipBadge.Font = Enum.Font.GothamBold
vipBadge.ZIndex = 8
vipBadge.Parent = avatarCircle
Instance.new("UICorner", vipBadge).CornerRadius = UDim.new(1, 0)

-- Name
local profileName = Instance.new("TextLabel")
profileName.Size = UDim2.new(1, -60, 0, 18)
profileName.Position = UDim2.new(0, 56, 0, 12)
profileName.BackgroundTransparency = 1
profileName.Text = LocalPlayer.DisplayName
profileName.TextColor3 = Color3.fromRGB(255,255,255)
profileName.TextSize = 13
profileName.Font = Enum.Font.GothamBold
profileName.TextXAlignment = Enum.TextXAlignment.Left
profileName.TextTruncate = Enum.TextTruncate.AtEnd
profileName.ZIndex = 6
profileName.Parent = profileFrame

-- Status
local profileStatus = Instance.new("TextLabel")
profileStatus.Size = UDim2.new(1, -60, 0, 14)
profileStatus.Position = UDim2.new(0, 56, 0, 30)
profileStatus.BackgroundTransparency = 1
profileStatus.Text = "● VIP AKTIF"
profileStatus.TextColor3 = Color3.fromRGB(255, 200, 60)
profileStatus.TextSize = 10
profileStatus.Font = Enum.Font.GothamBold
profileStatus.TextXAlignment = Enum.TextXAlignment.Left
profileStatus.ZIndex = 6
profileStatus.Parent = profileFrame

-- Sidebar scroll
local SideScroll = Instance.new("ScrollingFrame")
SideScroll.Size = UDim2.new(1, -12, 1, -90)
SideScroll.Position = UDim2.new(0, 6, 0, 78)
SideScroll.BackgroundTransparency = 1
SideScroll.BorderSizePixel = 0
SideScroll.ScrollBarThickness = 2
SideScroll.ScrollBarImageColor3 = CurrentTheme.Primary
SideScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
SideScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SideScroll.ZIndex = 5
SideScroll.Parent = Sidebar

local sideLayout = Instance.new("UIListLayout", SideScroll)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Padding = UDim.new(0, 5)

-- =============================================
-- CONTENT AREA
-- =============================================
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -200, 1, -110)
ContentArea.Position = UDim2.new(0, 185, 0, 95)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 3
ContentArea.Parent = MainFrame

-- =============================================
-- TAB SYSTEM (Animasyonlu)
-- =============================================
local tabConfig = {
    {Name = "Aimlock",   Icon = "🎯"},
    {Name = "ESP",       Icon = "👁"},
    {Name = "Movement",  Icon = "🚀"},
    {Name = "Players",   Icon = "👥"},
    {Name = "World",     Icon = "🌍"},
    {Name = "Character", Icon = "👤"},
    {Name = "Settings",  Icon = "⚙"},
}

local tabPages = {}
local tabButtons = {}
local activeTab = "Aimlock"
local uiElements = {}
local activeKeybindBtn = nil
local keybindCallbacks = {}

-- Sayfa gecis animasyonu (gelismis)
local function animatePageSwitch(oldPage, newPage, direction)
    direction = direction or 1
    
    -- Eski sayfa sola kayarak cik
    if oldPage then
        tween(oldPage, 0.25, {
            Position = UDim2.new(0, -50 * direction, 0, 0),
            BackgroundTransparency = 1,
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        
        task.delay(0.25, function()
            oldPage.Visible = false
            oldPage.Position = UDim2.new(0, 0, 0, 0)
        end)
    end
    
    -- Yeni sayfa sagdan kayarak gir
    task.delay(0.05, function()
        newPage.Visible = true
        newPage.Position = UDim2.new(0, 50 * direction, 0, 0)
        
        tween(newPage, 0.35, {
            Position = UDim2.new(0, 0, 0, 0),
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end)
end

for i, config in ipairs(tabConfig) do
    local name = config.Name
    local icon = config.Icon
    
    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. name
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = i==1 and CurrentTheme.Primary or CurrentTheme.Button
    btn.BackgroundTransparency = i==1 and 0 or 0.5
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.ZIndex = 5
    btn.Parent = SideScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
    
    -- Aktif indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 3, 0.55, 0)
    indicator.Position = UDim2.new(0, 3, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.BackgroundColor3 = CurrentTheme.Accent
    indicator.BorderSizePixel = 0
    indicator.Visible = (i == 1)
    indicator.ZIndex = 7
    indicator.Parent = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    
    -- Indicator glow
    local indGlow = Instance.new("UIStroke", indicator)
    indGlow.Color = CurrentTheme.Accent
    indGlow.Thickness = 3
    indGlow.Transparency = 0.5
    
    -- Ikon
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 30, 1, 0)
    iconLbl.Position = UDim2.new(0, 14, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextColor3 = Color3.fromRGB(255,255,255)
    iconLbl.TextSize = 17
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.ZIndex = 6
    iconLbl.Parent = btn
    
    -- Isim
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -50, 1, 0)
    nameLbl.Position = UDim2.new(0, 46, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = Color3.fromRGB(255,255,255)
    nameLbl.TextSize = 13
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 6
    nameLbl.Parent = btn
    
    tabButtons[name] = btn
    
    btn.MouseEnter:Connect(function()
        if activeTab ~= name then
            tween(btn, 0.2, {BackgroundTransparency = 0.2, BackgroundColor3 = CurrentTheme.Primary})
            tween(iconLbl, 0.2, {TextSize = 19})
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= name then
            tween(btn, 0.2, {BackgroundTransparency = 0.5, BackgroundColor3 = CurrentTheme.Button})
            tween(iconLbl, 0.2, {TextSize = 17})
        end
    end)
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = CurrentTheme.Primary
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = (i==1)
    page.ZIndex = 2
    page.Active = true
    page.Parent = ContentArea

    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,6)
    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft = UDim.new(0,4)
    pad.PaddingRight = UDim.new(0,4)
    pad.PaddingTop = UDim.new(0,4)

    tabPages[name] = page
    
    btn.MouseButton1Click:Connect(function()
        if activeTab == name then return end
        local oldTab = activeTab
        activeTab = name
        
        local direction = 1
        local oldIndex = 1
        local newIndex = 1
        for idx, cfg in ipairs(tabConfig) do
            if cfg.Name == oldTab then oldIndex = idx end
            if cfg.Name == name then newIndex = idx end
        end
        direction = newIndex > oldIndex and 1 or -1
        
        for n,b in pairs(tabButtons) do 
            local isActive = (n == name)
            tween(b, 0.3, {
                BackgroundColor3 = isActive and CurrentTheme.Primary or CurrentTheme.Button,
                BackgroundTransparency = isActive and 0 or 0.5
            })
            local ind = b:FindFirstChild("Indicator")
            if ind then 
                ind.Visible = isActive
                if isActive then
                    -- Indicator pulse animasyonu
                    tween(ind, 0.15, {Size = UDim2.new(0, 5, 0.7, 0)}, Enum.EasingStyle.Back)
                    task.wait(0.15)
                    tween(ind, 0.2, {Size = UDim2.new(0, 3, 0.55, 0)})
                end
            end
        end
        
        animatePageSwitch(tabPages[oldTab], page, direction)
    end)
end

-- =============================================
-- RIPPLE EFEKTI
-- =============================================
local function addRipple(btn, x, y)
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, x, 0, y)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255,255,255)
    ripple.BackgroundTransparency = 0.5
    ripple.BorderSizePixel = 0
    ripple.ZIndex = btn.ZIndex + 1
    ripple.Parent = btn
    Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
    
    local size = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2
    tween(ripple, 0.6, {
        Size = UDim2.new(0, size, 0, size),
        BackgroundTransparency = 1,
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    task.delay(0.7, function() ripple:Destroy() end)
end

-- =============================================
-- UI BUILDERS
-- =============================================
local function addToggle(page, name, default, callback, order, withKeybind)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 32)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order or 0
    row.ZIndex = 3
    row.Parent = page

    local toggleWidth = withKeybind and UDim2.new(1, -72, 1, 0) or UDim2.new(1, 0, 1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = toggleWidth
    btn.BackgroundColor3 = default and CurrentTheme.Primary or CurrentTheme.Button
    btn.BackgroundTransparency = default and 0 or 0.3
    btn.BorderSizePixel = 0
    btn.Text = name .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    btn.ZIndex = 3
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    table.insert(uiElements, {element=btn, type="toggle"})

    local state = default
    local function doToggle()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        tween(btn, 0.25, {
            BackgroundColor3 = state and CurrentTheme.Primary or CurrentTheme.Button,
            BackgroundTransparency = state and 0 or 0.3,
        })
        if callback then callback(state) end
    end
    
    btn.MouseButton1Click:Connect(function()
        addRipple(btn, btn.AbsoluteSize.X/2, btn.AbsoluteSize.Y/2)
        doToggle()
    end)
    
    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, {BackgroundTransparency = state and 0 or 0.15})
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, {BackgroundTransparency = state and 0 or 0.3})
    end)

    if withKeybind then
        local kbBtn = Instance.new("TextButton")
        kbBtn.Size = UDim2.new(0, 64, 1, 0)
        kbBtn.Position = UDim2.new(1, -64, 0, 0)
        kbBtn.BackgroundColor3 = CurrentTheme.Button
        kbBtn.BackgroundTransparency = 0.3
        kbBtn.BorderSizePixel = 0
        kbBtn.Text = "[ - ]"
        kbBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
        kbBtn.TextSize = 10
        kbBtn.Font = Enum.Font.GothamBold
        kbBtn.AutoButtonColor = false
        kbBtn.ZIndex = 4
        kbBtn.Parent = row
        Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 7)
        local kbStroke = Instance.new("UIStroke", kbBtn)
        kbStroke.Color = CurrentTheme.Primary
        kbStroke.Thickness = 1
        kbStroke.Transparency = 0.5
        table.insert(uiElements, {element=kbBtn, type="keybindBg"})
        table.insert(uiElements, {element=kbStroke, type="stroke"})

        kbBtn.MouseButton1Click:Connect(function()
            if activeKeybindBtn == kbBtn then
                activeKeybindBtn = nil; kbBtn.Text = "[ - ]"; kbBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
                tween(kbBtn, 0.2, {BackgroundColor3 = CurrentTheme.Button, TextColor3 = Color3.fromRGB(180,180,190)})
                return
            end
            if activeKeybindBtn then
                activeKeybindBtn.Text = "[ - ]"
                activeKeybindBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
                tween(activeKeybindBtn, 0.2, {BackgroundColor3 = CurrentTheme.Button})
            end
            activeKeybindBtn = kbBtn
            kbBtn.Text = "[...]"
            tween(kbBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(200, 180, 50), TextColor3 = Color3.fromRGB(0,0,0)})
        end)

        local function assignKeybind(keyCode)
            kbBtn.Text = "[" .. keyCode.Name .. "]"
            tween(kbBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(80, 240, 140), TextColor3 = Color3.fromRGB(0,0,0)}, Enum.EasingStyle.Back)
            task.wait(0.15)
            tween(kbBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(50, 180, 100), TextColor3 = Color3.fromRGB(255,255,255)})
            keybindCallbacks[keyCode] = doToggle
            activeKeybindBtn = nil
        end

        if not _G.DHL_KeybindAssigners then _G.DHL_KeybindAssigners = {} end
        _G.DHL_KeybindAssigners[kbBtn] = assignKeybind
    end

    return function() return state end, function(v)
        state = v
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        tween(btn, 0.25, {
            BackgroundColor3 = state and CurrentTheme.Primary or CurrentTheme.Button,
            BackgroundTransparency = state and 0 or 0.3,
        })
        if callback then callback(state) end
    end
end

local function addSlider(page, name, min, max, default, callback, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,-8,0,42)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order or 0
    container.ZIndex = 3
    container.Parent = page

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,16)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. string.format("%.3f", default)
    label.TextColor3 = Color3.fromRGB(220,220,230)
    label.TextSize = 11
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.ZIndex = 3
    label.Parent = container

    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(1,0,0,12)
    bg.Position = UDim2.new(0,0,0,22)
    bg.BackgroundColor3 = CurrentTheme.Button
    bg.BackgroundTransparency = 0.3
    bg.BorderSizePixel = 0
    bg.Text = ""
    bg.AutoButtonColor = false
    bg.ZIndex = 3
    bg.Parent = container
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = CurrentTheme.Primary
    fill.BorderSizePixel = 0
    fill.ZIndex = 3
    fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    table.insert(uiElements, {element=fill, type="fill"})
    table.insert(uiElements, {element=bg, type="bg"})

    local fillGrad = Instance.new("UIGradient", fill)
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, CurrentTheme.Primary),
        ColorSequenceKeypoint.new(1, CurrentTheme.Accent),
    })
    table.insert(uiElements, {element=fillGrad, type="gradient"})

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,16,0,16)
    knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new((default-min)/(max-min),0,0.5,0)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 4
    knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
    table.insert(uiElements, {element=knob, type="knob"})

    local knobStroke = Instance.new("UIStroke", knob)
    knobStroke.Color = CurrentTheme.Primary
    knobStroke.Thickness = 2.5
    table.insert(uiElements, {element=knobStroke, type="stroke"})

    -- Knob glow
    local knobGlow = Instance.new("UIStroke", knob)
    knobGlow.Color = CurrentTheme.Accent
    knobGlow.Thickness = 6
    knobGlow.Transparency = 0.85

    local value = default
    local sliding = false
    local function update(px)
        local ax,as = bg.AbsolutePosition.X, bg.AbsoluteSize.X
        if as == 0 then return end
        local p = math.clamp((px-ax)/as, 0, 1)
        value = min + (max-min)*p
        tween(fill, 0.06, {Size = UDim2.new(p,0,1,0)})
        tween(knob, 0.06, {Position = UDim2.new(p,0,0.5,0)})
        label.Text = name .. ": " .. string.format("%.3f", value)
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

local function addCycleButton(page, name, options, default, callback, order)
    local idx = 1
    for i,v in ipairs(options) do if v == default then idx = i; break end end
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-8,0,32)
    btn.BackgroundColor3 = CurrentTheme.Button
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = name .. ": " .. options[idx]
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    btn.LayoutOrder = order or 0
    btn.ZIndex = 3
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    local s = Instance.new("UIStroke", btn)
    s.Color = CurrentTheme.Primary
    s.Thickness = 1
    s.Transparency = 0.5
    table.insert(uiElements, {element=s, type="stroke"})
    
    btn.MouseEnter:Connect(function() tween(btn, 0.15, {BackgroundTransparency = 0.15}) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.15, {BackgroundTransparency = 0.3}) end)
    
    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        btn.Text = name .. ": " .. options[idx]
        addRipple(btn, btn.AbsoluteSize.X/2, btn.AbsoluteSize.Y/2)
        if callback then callback(options[idx]) end
    end)
    return function() return options[idx] end
end

local function addSeparator(page, order)
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1,-16,0,1)
    sep.BackgroundColor3 = CurrentTheme.Primary
    sep.BackgroundTransparency = 0.5
    sep.BorderSizePixel = 0
    sep.LayoutOrder = order or 0
    sep.ZIndex = 3
    sep.Parent = page
    table.insert(uiElements, {element=sep, type="separator"})
end

local function addLabel(page, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-8,0,22)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = CurrentTheme.Text
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0
    lbl.ZIndex = 3
    lbl.Parent = page
    table.insert(uiElements, {element=lbl, type="label"})
end

local function addButton(page, name, callback, order, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-8,0,34)
    btn.BackgroundColor3 = color or CurrentTheme.Primary
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    btn.LayoutOrder = order or 0
    btn.ZIndex = 3
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Thickness = 1
    stroke.Transparency = 0.8
    
    btn.MouseEnter:Connect(function() tween(btn, 0.15, {BackgroundTransparency = 0}) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.15, {BackgroundTransparency = 0.1}) end)
    
    btn.MouseButton1Click:Connect(function()
        addRipple(btn, btn.AbsoluteSize.X/2, btn.AbsoluteSize.Y/2)
        if callback then callback() end
    end)
    return btn
end

local function getFOVThemeColor()
    if Settings.FOVUseTheme then return CurrentTheme.Accent end
    return Color3.fromRGB(255,50,50)
end

-- =============================================
-- PAGES
-- =============================================

-- PAGE 1: AIMLOCK
local p1 = tabPages["Aimlock"]
addLabel(p1, "▸ CAMLOCK", 1)
local getCamlock = addToggle(p1, "Camlock System", true, nil, 2, true)
local getWallCheck = addToggle(p1, "Wall Check", false, nil, 3, true)
local getStickyAim = addToggle(p1, "Sticky Aim", true, nil, 4, true)
local getAutoSwitch = addToggle(p1, "Auto Switch", true, nil, 5, false)
local getSkipDowned = addToggle(p1, "Skip Downed", true, nil, 7, true)
local getAlwaysOn = addToggle(p1, "Always On", false, nil, 8, true)

addSeparator(p1, 9)
addLabel(p1, "▸ SETTINGS", 10)
local getMode = addCycleButton(p1, "Mode", {"Right Mouse Click", "Nearest Cursor", "Toggle Q"}, "Right Mouse Click", function(v) Settings.Mode = v:gsub(" ", "") end, 11)
local getTargetPart = addCycleButton(p1, "Target Part", {"Head", "HumanoidRootPart", "UpperTorso"}, "Head", function(v) Settings.TargetPart = v end, 12)
local getSmoothness = addSlider(p1, "Smoothness", 0.05, 1.0, 0.450, nil, 13)
local getPrediction = addSlider(p1, "Prediction", 0.0, 0.5, 0.100, nil, 14)
local getAimShake = addSlider(p1, "Aim Shake", 0, 5, 0, nil, 15)

addSeparator(p1, 16)
addLabel(p1, "▸ TRIGGER BOT", 17)
local getTriggerBot = addToggle(p1, "Trigger Bot", false, nil, 18, true)

addSeparator(p1, 20)
addLabel(p1, "▸ HITBOX", 21)
local getHitboxExpand = addToggle(p1, "Hitbox Expand", false, nil, 22, false)
local getHitboxSize = addSlider(p1, "Hitbox Size", 1.0, 3.0, 1.3, nil, 23)

addSeparator(p1, 24)
addLabel(p1, "▸ FOV", 25)
local getFOVVisible = addToggle(p1, "FOV Circle", true, nil, 26, true)
local getFOVRadius = addSlider(p1, "FOV Radius", 20, 500, 150, nil, 27)
local getFOVUseTheme = addToggle(p1, "FOV Follow Theme", true, function(v) Settings.FOVUseTheme = v end, 28, false)

-- PAGE 2: ESP
local p2 = tabPages["ESP"]
addLabel(p2, "▸ ESP HIGHLIGHT", 1)
local getESP = addToggle(p2, "ESP Enabled", true, nil, 2, true)
local getHighlightColor = addCycleButton(p2, "Color", {"Red","Cyan","Green","Yellow","Purple","White","Orange","Pink","Gold"}, "Gold", function(v)
    local colors = {Red=Color3.fromRGB(255,50,50), Cyan=Color3.fromRGB(0,200,255), Green=Color3.fromRGB(0,255,0),
        Yellow=Color3.fromRGB(255,255,0), Purple=Color3.fromRGB(180,0,255), White=Color3.fromRGB(255,255,255),
        Orange=Color3.fromRGB(255,150,0), Pink=Color3.fromRGB(255,100,200), Gold=Color3.fromRGB(255,200,60)}
    Settings.HighlightColor = colors[v] or Color3.fromRGB(255,200,60)
end, 3)
local getFillTransparency = addSlider(p2, "Fill Transparency", 0, 1, 0.35, nil, 4)

addSeparator(p2, 5)
addLabel(p2, "▸ INFO", 6)
local getESPNames = addToggle(p2, "Name Tags", true, nil, 7, true)
local getESPHealth = addToggle(p2, "Health Display", true, nil, 8, false)
local getESPDistance = addToggle(p2, "Distance Display", true, nil, 9, false)

addSeparator(p2, 10)
addLabel(p2, "▸ VISUALS", 11)
local getESPTracers = addToggle(p2, "Tracers", true, nil, 12, true)
local getTracerOrigin = addCycleButton(p2, "Tracer Origin", {"Bottom","Center","Mouse"}, "Bottom", nil, 13)
local getESPBoxes = addToggle(p2, "Box ESP", false, nil, 14, true)

-- PAGE 3: MOVEMENT
local p3 = tabPages["Movement"]
addLabel(p3, "▸ SPEED", 1)
local getSpeed = addToggle(p3, "Speed Hack", false, nil, 2, true)
local getSpeedValue = addSlider(p3, "Walk Speed", 16, 500, 16, nil, 3)

addSeparator(p3, 4)
addLabel(p3, "▸ JUMP", 5)
local getJumpPower = addToggle(p3, "Jump Power", false, nil, 6, true)
local getJumpValue = addSlider(p3, "Jump Value", 50, 500, 50, nil, 7)
local getInfJump = addToggle(p3, "Infinite Jump", false, nil, 8, true)

addSeparator(p3, 10)
addLabel(p3, "▸ FLY", 11)
local getFly = addToggle(p3, "Fly", false, nil, 12, true)
local getFlySpeed = addSlider(p3, "Fly Speed", 10, 500, 50, nil, 13)
local getNoclipFly = addToggle(p3, "Noclip Fly", false, nil, 14, true)

addSeparator(p3, 15)
addLabel(p3, "▸ NOCLIP", 16)
local getNoclip = addToggle(p3, "Noclip", false, nil, 17, true)

addSeparator(p3, 18)
addLabel(p3, "▸ TELEPORT", 19)
addButton(p3, "📍  Teleport to Mouse", function()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            showToast("Teleport", "Mouse konumuna isinlandin", "success")
        end
    end
end, 20, CurrentTheme.Primary)

addButton(p3, "🎯  Teleport to Target", function()
    local target = Settings.CurrentTarget
    if target and target.Character then
        local thrp = target.Character:FindFirstChild("HumanoidRootPart")
        local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if thrp and lhrp then
            lhrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 3)
            showToast("Teleport", target.DisplayName .. " yanina isinlandin", "success")
        end
    else
        showToast("Teleport", "Hedef yok!", "error")
    end
end, 21, CurrentTheme.Primary)

-- PAGE 4: PLAYERS
local p4 = tabPages["Players"]

local SelectCountLabel = Instance.new("TextLabel")
SelectCountLabel.Size = UDim2.new(1,-8,0,20)
SelectCountLabel.BackgroundTransparency = 1
SelectCountLabel.Text = "Selected: 0"
SelectCountLabel.TextColor3 = CurrentTheme.Text
SelectCountLabel.TextSize = 11
SelectCountLabel.Font = Enum.Font.GothamSemibold
SelectCountLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectCountLabel.LayoutOrder = 1
SelectCountLabel.ZIndex = 3
SelectCountLabel.Parent = p4
table.insert(uiElements, {element=SelectCountLabel, type="label"})

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1,-8,0,28)
btnRow.BackgroundTransparency = 1
btnRow.LayoutOrder = 2
btnRow.ZIndex = 3
btnRow.Parent = p4

local SelectAllBtn = Instance.new("TextButton")
SelectAllBtn.Size = UDim2.new(0.48,0,1,0)
SelectAllBtn.BackgroundColor3 = CurrentTheme.Primary
SelectAllBtn.BorderSizePixel = 0
SelectAllBtn.Text = "Select All"
SelectAllBtn.TextColor3 = Color3.fromRGB(255,255,255)
SelectAllBtn.TextSize = 11
SelectAllBtn.Font = Enum.Font.GothamBold
SelectAllBtn.AutoButtonColor = false
SelectAllBtn.ClipsDescendants = true
SelectAllBtn.ZIndex = 3
SelectAllBtn.Parent = btnRow
Instance.new("UICorner", SelectAllBtn).CornerRadius = UDim.new(0,7)
SelectAllBtn.MouseEnter:Connect(function() tween(SelectAllBtn, 0.15, {BackgroundColor3 = CurrentTheme.Accent}) end)
SelectAllBtn.MouseLeave:Connect(function() tween(SelectAllBtn, 0.15, {BackgroundColor3 = CurrentTheme.Primary}) end)
SelectAllBtn.MouseButton1Click:Connect(function()
    addRipple(SelectAllBtn, SelectAllBtn.AbsoluteSize.X/2, SelectAllBtn.AbsoluteSize.Y/2)
    for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then Settings.SelectedPlayers[p.Name] = p end end
    refreshPlayerList()
end)

local ClearAllBtn = Instance.new("TextButton")
ClearAllBtn.Size = UDim2.new(0.48,0,1,0)
ClearAllBtn.Position = UDim2.new(0.52,0,0,0)
ClearAllBtn.BackgroundColor3 = Color3.fromRGB(90, 30, 30)
ClearAllBtn.BorderSizePixel = 0
ClearAllBtn.Text = "Clear"
ClearAllBtn.TextColor3 = Color3.fromRGB(255,255,255)
ClearAllBtn.TextSize = 11
ClearAllBtn.Font = Enum.Font.GothamBold
ClearAllBtn.AutoButtonColor = false
ClearAllBtn.ClipsDescendants = true
ClearAllBtn.ZIndex = 3
ClearAllBtn.Parent = btnRow
Instance.new("UICorner", ClearAllBtn).CornerRadius = UDim.new(0,7)
ClearAllBtn.MouseEnter:Connect(function() tween(ClearAllBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(150, 40, 40)}) end)
ClearAllBtn.MouseLeave:Connect(function() tween(ClearAllBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(90, 30, 30)}) end)

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1,-8,0,30)
SearchBox.BackgroundColor3 = CurrentTheme.Button
SearchBox.BackgroundTransparency = 0.3
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "🔍  Search Players..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150,150,160)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(220,220,230)
SearchBox.TextSize = 12
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false
SearchBox.LayoutOrder = 3
SearchBox.ZIndex = 3
SearchBox.Parent = p4
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,7)
table.insert(uiElements, {element=SearchBox, type="bg"})

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1,-8,0,200)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.BorderSizePixel = 0
PlayerScroll.ScrollBarThickness = 3
PlayerScroll.ScrollBarImageColor3 = CurrentTheme.Primary
PlayerScroll.CanvasSize = UDim2.new(0,0,0,0)
PlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerScroll.LayoutOrder = 4
PlayerScroll.ZIndex = 3
PlayerScroll.Active = true
PlayerScroll.Parent = p4

local PlayerListLayout = Instance.new("UIListLayout", PlayerScroll)
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0,3)

addSeparator(p4, 5)
addLabel(p4, "▸ PLAYER ACTIONS", 6)

addButton(p4, "🎯  Goto First Selected", function()
    for _, plr in pairs(Settings.SelectedPlayers) do
        if plr and plr.Character then
            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if thrp and lhrp then
                lhrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 3)
                showToast("Goto", plr.DisplayName .. " yanina isinlandin", "success")
            end
            break
        end
    end
end, 7, CurrentTheme.Primary)

addButton(p4, "🤝  Bring First Selected", function()
    for _, plr in pairs(Settings.SelectedPlayers) do
        if plr and plr.Character then
            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if thrp and lhrp then
                thrp.CFrame = lhrp.CFrame * CFrame.new(0, 0, 5)
                showToast("Bring", plr.DisplayName .. " yanina cekildi", "success")
            end
            break
        end
    end
end, 8, CurrentTheme.Primary)

local getFollowPlayer = addToggle(p4, "👣  Follow First Selected", false, function(state)
    Settings.FollowPlayer = state
    if state then
        for _, plr in pairs(Settings.SelectedPlayers) do
            if plr and plr.Character then
                Settings.FollowTarget = plr
                break
            end
        end
    else
        Settings.FollowTarget = nil
    end
end, 9, true)

addButton(p4, "💀  Kill First Selected", function()
    for _, plr in pairs(Settings.SelectedPlayers) do
        if plr and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function() hum.Health = 0 end)
                Settings.Kills = Settings.Kills + 1
                showToast("👑 KILL", plr.DisplayName .. " olduruldu", "vip")
            end
            break
        end
    end
end, 10, Color3.fromRGB(220, 40, 60))

-- PAGE 5: WORLD
local p5 = tabPages["World"]
addLabel(p5, "▸ LIGHTING", 1)
local getFullbright = addToggle(p5, "Fullbright", false, nil, 2, true)
local getNoFog = addToggle(p5, "No Fog", false, nil, 3, true)
local getRemoveShadows = addToggle(p5, "Remove Shadows", false, nil, 4, true)
local getTimeChanger = addToggle(p5, "Time Changer", false, nil, 5, false)
local getTimeValue = addSlider(p5, "Time (0-24)", 0, 24, 12, nil, 6)

addSeparator(p5, 7)
addLabel(p5, "▸ SERVER", 8)
addButton(p5, "🔄  Server Rejoin", function()
    showToast("Server", "Yeniden baglaniliyor...", "info")
    task.wait(0.5)
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end, 9, CurrentTheme.Primary)

addButton(p5, "🌐  Server Hop", function()
    showToast("Server", "Yeni sunucu aranıyor...", "info")
    task.wait(0.5)
    pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if success and result and result.data then
            local servers = {}
            for _, server in ipairs(result.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
            if #servers > 0 then
                local randomServer = servers[math.random(1, #servers)]
                TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, LocalPlayer)
            else
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        else
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end)
end, 10, CurrentTheme.Primary)

addSeparator(p5, 11)
addLabel(p5, "▸ WORLD INFO", 12)
local worldInfoLabel = Instance.new("TextLabel")
worldInfoLabel.Size = UDim2.new(1,-8,0,75)
worldInfoLabel.BackgroundColor3 = CurrentTheme.Button
worldInfoLabel.BackgroundTransparency = 0.5
worldInfoLabel.BorderSizePixel = 0
worldInfoLabel.Text = "  🎮 Game: " .. game.PlaceId .. "\n  👥 Players: " .. #Players:GetPlayers() .. "\n  🌐 Server: " .. game.JobId:sub(1,8)
worldInfoLabel.TextColor3 = Color3.fromRGB(220,220,230)
worldInfoLabel.TextSize = 11
worldInfoLabel.Font = Enum.Font.Gotham
worldInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
worldInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
worldInfoLabel.LayoutOrder = 13
worldInfoLabel.ZIndex = 3
worldInfoLabel.Parent = p5
Instance.new("UICorner", worldInfoLabel).CornerRadius = UDim.new(0, 8)
table.insert(uiElements, {element=worldInfoLabel, type="bg"})
local wInfoPad = Instance.new("UIPadding", worldInfoLabel)
wInfoPad.PaddingLeft = UDim.new(0, 8)
wInfoPad.PaddingTop = UDim.new(0, 8)

-- PAGE 6: CHARACTER
local p6 = tabPages["Character"]
addLabel(p6, "▸ CHARACTER", 1)
local getGodMode = addToggle(p6, "God Mode", false, nil, 2, true)
local getAntiFling = addToggle(p6, "Anti Fling", false, nil, 3, true)
local getCharacterSize = addToggle(p6, "Character Size", false, nil, 4, false)
local getSizeValue = addSlider(p6, "Size Scale", 0.5, 5.0, 1.0, nil, 5)

addSeparator(p6, 6)
addLabel(p6, "▸ DAMAGE AURA", 7)
local getDamageAura = addToggle(p6, "Damage Aura", false, nil, 8, true)
local getDamageRange = addSlider(p6, "Aura Range", 3, 30, 10, nil, 9)
local getDamageAmount = addSlider(p6, "Damage Amount", 1, 50, 5, nil, 10)

addSeparator(p6, 11)
addLabel(p6, "▸ ACTIONS", 12)
addButton(p6, "🔄  Respawn", function()
    pcall(function() LocalPlayer.Character:BreakJoints() end)
    showToast("Character", "Yeniden doguluyor...", "info")
end, 13, Color3.fromRGB(200, 100, 30))

addButton(p6, "❤  Full Heal", function()
    pcall(function()
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end)
    showToast("Character", "Can dolduruldu", "success")
end, 14, Color3.fromRGB(40, 180, 90))

-- PAGE 7: SETTINGS
local p7 = tabPages["Settings"]
addLabel(p7, "▸ VIP THEMES", 1)
local getTheme = addCycleButton(p7, "Theme", {"Gold","Diamond","Ruby","Sapphire","Emerald","Obsidian","Amethyst","Neon","Cyber","Fire","Ice","Rose"}, "Gold", function(v)
    if Themes[v] then
        CurrentTheme = Themes[v]
        
        MainFrame.BackgroundColor3 = CurrentTheme.Bg
        glowStroke.Color = CurrentTheme.Primary
        Sidebar.BackgroundColor3 = CurrentTheme.Panel
        sideStroke.Color = CurrentTheme.Primary
        profileFrame.BackgroundColor3 = CurrentTheme.Button
        avatarCircle.BackgroundColor3 = CurrentTheme.Primary
        
        titleGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, CurrentTheme.G1),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1, CurrentTheme.G2),
        })
        mainGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 22, 15)),
            ColorSequenceKeypoint.new(0.5, CurrentTheme.Bg),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 13, 8)),
        })
        sideGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, CurrentTheme.Panel),
            ColorSequenceKeypoint.new(1, CurrentTheme.Bg),
        })
        profGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, CurrentTheme.Button),
            ColorSequenceKeypoint.new(1, CurrentTheme.Panel),
        })
        
        for _, data in ipairs(uiElements) do
            if data.element and data.element.Parent then
                if data.type == "toggle" then
                    if data.element.Text:find(": ON") then
                        data.element.BackgroundColor3 = CurrentTheme.Primary
                    elseif data.element.Text:find(": OFF") then
                        data.element.BackgroundColor3 = CurrentTheme.Button
                    end
                elseif data.type == "solid" then
                    data.element.BackgroundColor3 = CurrentTheme.Primary
                elseif data.type == "fill" then
                    data.element.BackgroundColor3 = CurrentTheme.Primary
                elseif data.type == "knob" then
                    data.element.BackgroundColor3 = Color3.fromRGB(255,255,255)
                elseif data.type == "bg" then
                    data.element.BackgroundColor3 = CurrentTheme.Button
                elseif data.type == "keybindBg" then
                    data.element.BackgroundColor3 = CurrentTheme.Button
                elseif data.type == "separator" then
                    data.element.BackgroundColor3 = CurrentTheme.Primary
                elseif data.type == "label" then
                    data.element.TextColor3 = CurrentTheme.Text
                elseif data.type == "stroke" then
                    data.element.Color = CurrentTheme.Primary
                elseif data.type == "gradient" then
                    data.element.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, CurrentTheme.Primary),
                        ColorSequenceKeypoint.new(1, CurrentTheme.Accent),
                    })
                end
            end
        end
        
        for n,b in pairs(tabButtons) do 
            b.BackgroundColor3 = (n==activeTab) and CurrentTheme.Primary or CurrentTheme.Button
            local ind = b:FindFirstChild("Indicator")
            if ind then 
                ind.BackgroundColor3 = CurrentTheme.Accent
                local glow = ind:FindFirstChildOfClass("UIStroke")
                if glow then glow.Color = CurrentTheme.Accent end
            end
        end
        
        for _, page in pairs(tabPages) do
            page.ScrollBarImageColor3 = CurrentTheme.Primary
        end
        PlayerScroll.ScrollBarImageColor3 = CurrentTheme.Primary
        SideScroll.ScrollBarImageColor3 = CurrentTheme.Primary
        
        if fovCircle and Settings.FOVUseTheme then
            fovCircle.Color = CurrentTheme.Accent
        end
        
        Watermark.BackgroundColor3 = CurrentTheme.Panel
        wmStroke.Color = CurrentTheme.Primary
        wmGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, CurrentTheme.G1),
            ColorSequenceKeypoint.new(1, CurrentTheme.G2),
        })
        
        showToast("👑 VIP Theme", CurrentTheme.Name .. " aktif edildi", "vip")
    end
end, 2)

addSeparator(p7, 3)
addLabel(p7, "▸ GUI", 4)
local getGuiTransparency = addSlider(p7, "Gui Transparency", 0, 0.9, 0, function(v)
    MainFrame.BackgroundTransparency = v
end, 5)

addSeparator(p7, 6)
addLabel(p7, "▸ APPEARANCE", 7)
local getWatermark = addToggle(p7, "Watermark", true, nil, 8, false)
local getFPSDisplay = addToggle(p7, "FPS Display", true, nil, 9, false)
local getPingDisplay = addToggle(p7, "Ping Display", true, nil, 10, false)
local getParticles = addToggle(p7, "Particle Effects", true, function(v)
    Settings.ParticlesEnabled = v
end, 11, false)

addSeparator(p7, 12)
addLabel(p7, "▸ CONFIG", 13)
addButton(p7, "💾  Save Config", function()
    if writefile then
        pcall(function()
            local data = {
                Theme = CurrentTheme.Name, SpeedValue = Settings.SpeedValue,
                JumpPowerValue = Settings.JumpPowerValue, FlySpeed = Settings.FlySpeed,
                FOVRadius = Settings.FOVRadius,
            }
            writefile("DHLVIP_config.json", HttpService:JSONEncode(data))
        end)
    end
    showToast("Config", "Ayarlar kaydedildi", "success")
end, 14, Color3.fromRGB(60, 100, 200))

addButton(p7, "📂  Load Config", function()
    if readfile and isfile then
        pcall(function()
            if isfile("DHLVIP_config.json") then
                local data = HttpService:JSONDecode(readfile("DHLVIP_config.json"))
                if data.SpeedValue then getSpeedValue(data.SpeedValue) end
                if data.JumpPowerValue then getJumpValue(data.JumpPowerValue) end
                if data.FlySpeed then getFlySpeed(data.FlySpeed) end
                if data.FOVRadius then getFOVRadius(data.FOVRadius) end
                if data.Theme and Themes[data.Theme] then CurrentTheme = Themes[data.Theme] end
            end
        end)
    end
    showToast("Config", "Ayarlar yuklendi", "success")
end, 15, Color3.fromRGB(60, 100, 200))

addSeparator(p7, 16)
addLabel(p7, "▸ STATISTICS", 17)
local statLabel = Instance.new("TextLabel")
statLabel.Size = UDim2.new(1,-8,0,80)
statLabel.BackgroundColor3 = CurrentTheme.Button
statLabel.BackgroundTransparency = 0.5
statLabel.BorderSizePixel = 0
statLabel.Text = "  👑 VIP STATUS: AKTIF\n  💀 Kills: 0\n  ⏱ Session: 0s\n  👤 User: " .. LocalPlayer.Name
statLabel.TextColor3 = Color3.fromRGB(220,220,230)
statLabel.TextSize = 11
statLabel.Font = Enum.Font.Gotham
statLabel.TextXAlignment = Enum.TextXAlignment.Left
statLabel.TextYAlignment = Enum.TextYAlignment.Top
statLabel.LayoutOrder = 18
statLabel.ZIndex = 3
statLabel.Parent = p7
Instance.new("UICorner", statLabel).CornerRadius = UDim.new(0, 8)
table.insert(uiElements, {element=statLabel, type="bg"})
local statPad = Instance.new("UIPadding", statLabel)
statPad.PaddingLeft = UDim.new(0, 8)
statPad.PaddingTop = UDim.new(0, 8)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local sessionTime = math.floor(tick() - Settings.SessionStart)
            statLabel.Text = "  👑 VIP STATUS: AKTIF\n  💀 Kills: " .. Settings.Kills .. "\n  ⏱ Session: " .. sessionTime .. "s\n  👤 User: " .. LocalPlayer.Name
        end)
    end
end)

-- =============================================
-- WATERMARK (VIP)
-- =============================================
local Watermark = Instance.new("Frame")
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0, 260, 0, 42)
Watermark.Position = UDim2.new(0, 15, 0, 15)
Watermark.BackgroundColor3 = CurrentTheme.Panel
Watermark.BackgroundTransparency = 0.1
Watermark.BorderSizePixel = 0
Watermark.Visible = true
Watermark.ZIndex = 500
Watermark.Parent = ScreenGui
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 10)
local wmStroke = Instance.new("UIStroke", Watermark)
wmStroke.Color = CurrentTheme.Primary
wmStroke.Thickness = 1.5
wmStroke.Transparency = 0.3
makeDraggable(Watermark, Watermark)

local wmGradient = Instance.new("UIGradient", Watermark)
wmGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CurrentTheme.G1),
    ColorSequenceKeypoint.new(1, CurrentTheme.G2),
})
wmGradient.Rotation = 45
wmGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.85),
    NumberSequenceKeypoint.new(1, 1),
})

local wmTitle = Instance.new("TextLabel")
wmTitle.Size = UDim2.new(1, 0, 0, 22)
wmTitle.Position = UDim2.new(0, 12, 0, 4)
wmTitle.BackgroundTransparency = 1
wmTitle.Text = "👑  DHL VIP  •  PREMIUM"
wmTitle.TextColor3 = Color3.fromRGB(255,255,255)
wmTitle.TextSize = 12
wmTitle.Font = Enum.Font.GothamBold
wmTitle.TextXAlignment = Enum.TextXAlignment.Left
wmTitle.ZIndex = 501
wmTitle.Parent = Watermark

local wmInfo = Instance.new("TextLabel")
wmInfo.Size = UDim2.new(1, 0, 0, 14)
wmInfo.Position = UDim2.new(0, 12, 0, 24)
wmInfo.BackgroundTransparency = 1
wmInfo.Text = "60 FPS  •  0 MS"
wmInfo.TextColor3 = Color3.fromRGB(180, 180, 190)
wmInfo.TextSize = 10
wmInfo.Font = Enum.Font.Gotham
wmInfo.TextXAlignment = Enum.TextXAlignment.Left
wmInfo.ZIndex = 501
wmInfo.Parent = Watermark

local fpsCount, fpsTime = 0, tick()
RunService.RenderStepped:Connect(function()
    fpsCount = fpsCount + 1
    if tick() - fpsTime >= 1 then
        local fps = fpsCount
        local ping = 0
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        if getFPSDisplay() or getPingDisplay() then
            local fpsStr = getFPSDisplay() and (fps .. " FPS") or ""
            local pingStr = getPingDisplay() and (ping .. " MS") or ""
            wmInfo.Text = fpsStr .. "  •  " .. pingStr
        end
        fpsCount = 0
        fpsTime = tick()
    end
end)
RunService.RenderStepped:Connect(function()
    Watermark.Visible = getWatermark()
end)

-- =============================================
-- PLAYER LIST LOGIC
-- =============================================
local playerButtons = {}
local originalSizes = {}

local function updateSelectCount()
    local c = 0
    for _ in pairs(Settings.SelectedPlayers) do c = c+1 end
    SelectCountLabel.Text = "Selected: " .. c
end

local function isSelected(player) return Settings.SelectedPlayers[player.Name] ~= nil end

local function toggleSelect(player, btn)
    if isSelected(player) then
        Settings.SelectedPlayers[player.Name] = nil
        tween(btn, 0.2, {BackgroundColor3 = CurrentTheme.Button, BackgroundTransparency = 0.3})
        btn.TextColor3 = Color3.fromRGB(200,200,210)
    else
        Settings.SelectedPlayers[player.Name] = player
        tween(btn, 0.2, {BackgroundColor3 = CurrentTheme.Primary, BackgroundTransparency = 0})
        btn.TextColor3 = Color3.fromRGB(255,255,255)
    end
    updateSelectCount()
end

local function createPlayerButton(player)
    if player == LocalPlayer then return end
    local sel = isSelected(player)
    local btn = Instance.new("TextButton")
    btn.Name = "PLR_"..player.Name
    btn.Size = UDim2.new(1,-4,0,30)
    btn.BackgroundColor3 = sel and CurrentTheme.Primary or CurrentTheme.Button
    btn.BackgroundTransparency = sel and 0 or 0.3
    btn.BorderSizePixel = 0
    btn.Text = "  "..player.DisplayName
    btn.TextColor3 = sel and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,210)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    btn.ZIndex = 3
    btn.Parent = PlayerScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
    btn.MouseButton1Click:Connect(function() 
        addRipple(btn, btn.AbsoluteSize.X/2, btn.AbsoluteSize.Y/2)
        toggleSelect(player, btn) 
    end)
    btn.MouseEnter:Connect(function()
        if not isSelected(player) then tween(btn, 0.15, {BackgroundTransparency = 0.15}) end
    end)
    btn.MouseLeave:Connect(function()
        if not isSelected(player) then tween(btn, 0.15, {BackgroundTransparency = 0.3}) end
    end)
    playerButtons[player.Name] = btn
end

function refreshPlayerList()
    for _,b in pairs(playerButtons) do if b and b.Parent then b:Destroy() end end
    playerButtons = {}
    local search = SearchBox.Text:lower()
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if search == "" or p.DisplayName:lower():find(search,1,true) or p.Name:lower():find(search,1,true) then
                createPlayerButton(p)
            end
        end
    end
    updateSelectCount()
end

ClearAllBtn.MouseButton1Click:Connect(function()
    addRipple(ClearAllBtn, ClearAllBtn.AbsoluteSize.X/2, ClearAllBtn.AbsoluteSize.Y/2)
    for name in pairs(highlightObjects) do removeHighlight(name) end
    Settings.SelectedPlayers = {}; Settings.CurrentTarget = nil; refreshPlayerList()
end)
refreshPlayerList()
Players.PlayerAdded:Connect(function() task.wait(0.5); refreshPlayerList() end)
Players.PlayerRemoving:Connect(function(player)
    Settings.SelectedPlayers[player.Name] = nil
    if Settings.CurrentTarget == player then Settings.CurrentTarget = nil end
    if Settings.FollowTarget == player then Settings.FollowTarget = nil end
    removeHighlight(player.Name); task.wait(0.1); refreshPlayerList()
end)
SearchBox:GetPropertyChangedSignal("Text"):Connect(refreshPlayerList)

-- =============================================
-- FOV CIRCLE
-- =============================================
local fovCircle, usingDrawing = nil, false
pcall(function()
    fovCircle = Drawing.new("Circle")
    fovCircle.Color = CurrentTheme.Accent
    fovCircle.Thickness = 1.5
    fovCircle.NumSides = 64
    fovCircle.Radius = 150
    fovCircle.Filled = false
    fovCircle.Visible = true
    fovCircle.Transparency = 0.8
    usingDrawing = true
end)

-- =============================================
-- ESP
-- =============================================
highlightObjects = {}
local espDrawings = {}

local function addHighlight(player)
    if not player or not player.Character then return end
    if highlightObjects[player.Name] then
        if highlightObjects[player.Name].Parent ~= player.Character then
            highlightObjects[player.Name]:Destroy(); highlightObjects[player.Name] = nil
        else return end
    end
    local hl = Instance.new("Highlight")
    hl.Name = "DHL_Highlight"
    hl.FillColor = Settings.HighlightColor
    hl.OutlineColor = Settings.HighlightColor
    hl.FillTransparency = Settings.HighlightFillTransparency
    hl.OutlineTransparency = 0
    hl.Adornee = player.Character
    hl.Parent = player.Character
    highlightObjects[player.Name] = hl

    if usingDrawing and not espDrawings[player.Name] then
        local esp = {}
        esp.name = Drawing.new("Text"); esp.name.Color = Settings.HighlightColor; esp.name.Size = 14
        esp.name.Center = true; esp.name.Outline = true; esp.name.OutlineColor = Color3.fromRGB(0,0,0)
        esp.name.Visible = false; esp.name.Font = 2
        esp.distance = Drawing.new("Text"); esp.distance.Color = Color3.fromRGB(200,200,200); esp.distance.Size = 12
        esp.distance.Center = true; esp.distance.Outline = true; esp.distance.OutlineColor = Color3.fromRGB(0,0,0)
        esp.distance.Visible = false; esp.distance.Font = 2
        esp.healthText = Drawing.new("Text"); esp.healthText.Color = Color3.fromRGB(0,255,0); esp.healthText.Size = 12
        esp.healthText.Center = true; esp.healthText.Outline = true; esp.healthText.OutlineColor = Color3.fromRGB(0,0,0)
        esp.healthText.Visible = false; esp.healthText.Font = 2
        esp.tracer = Drawing.new("Line"); esp.tracer.Color = Settings.HighlightColor
        esp.tracer.Thickness = 1; esp.tracer.Visible = false; esp.tracer.Transparency = 0.7
        esp.boxTop = Drawing.new("Line"); esp.boxTop.Thickness = 1; esp.boxTop.Visible = false
        esp.boxBottom = Drawing.new("Line"); esp.boxBottom.Thickness = 1; esp.boxBottom.Visible = false
        esp.boxLeft = Drawing.new("Line"); esp.boxLeft.Thickness = 1; esp.boxLeft.Visible = false
        esp.boxRight = Drawing.new("Line"); esp.boxRight.Thickness = 1; esp.boxRight.Visible = false
        espDrawings[player.Name] = esp
    end
end

function removeHighlight(playerName)
    if highlightObjects[playerName] then pcall(function() highlightObjects[playerName]:Destroy() end); highlightObjects[playerName] = nil end
    if espDrawings[playerName] then
        for _,obj in pairs(espDrawings[playerName]) do pcall(function() obj:Remove() end) end
        espDrawings[playerName] = nil
    end
end

local function hideDrawings(playerName)
    if espDrawings[playerName] then for _,obj in pairs(espDrawings[playerName]) do pcall(function() obj.Visible = false end) end end
end

local function updateESP()
    local espEnabled = getESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local selected = Settings.SelectedPlayers[player.Name] ~= nil
            local shouldShow = espEnabled and selected
            if shouldShow and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local head = player.Character:FindFirstChild("Head")
                if humanoid and humanoid.Health > 0 and rootPart then
                    addHighlight(player)
                    if highlightObjects[player.Name] then
                        highlightObjects[player.Name].FillColor = Settings.HighlightColor
                        highlightObjects[player.Name].OutlineColor = Settings.HighlightColor
                        highlightObjects[player.Name].FillTransparency = getFillTransparency()
                    end
                    if usingDrawing and espDrawings[player.Name] then
                        local esp = espDrawings[player.Name]
                        local headPos = head and head.Position or rootPart.Position + Vector3.new(0,2,0)
                        local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                        if onScreen then
                            local dist = math.floor((Camera.CFrame.Position - rootPart.Position).Magnitude)
                            local hp = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                            local yOff = -16
                            if getESPNames() then
                                esp.name.Text = player.DisplayName; esp.name.Position = Vector2.new(screenPos.X, screenPos.Y + yOff)
                                esp.name.Color = Settings.HighlightColor; esp.name.Visible = true; yOff = yOff - 16
                            else esp.name.Visible = false end
                            if getESPHealth() then
                                esp.healthText.Text = hp .. "% HP"; esp.healthText.Position = Vector2.new(screenPos.X, screenPos.Y + yOff)
                                esp.healthText.Color = Color3.fromRGB(255*(1-hp/100), 255*(hp/100), 0)
                                esp.healthText.Visible = true; yOff = yOff - 14
                            else esp.healthText.Visible = false end
                            if getESPDistance() then
                                esp.distance.Text = "["..dist.."m]"; esp.distance.Position = Vector2.new(screenPos.X, screenPos.Y + yOff)
                                esp.distance.Visible = true
                            else esp.distance.Visible = false end
                            if getESPTracers() then
                                local origin = getTracerOrigin()
                                local fromPos
                                if origin == "Bottom" then fromPos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                                elseif origin == "Center" then fromPos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                                else fromPos = Vector2.new(Mouse.X, Mouse.Y) end
                                esp.tracer.From = fromPos; esp.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                                esp.tracer.Color = Settings.HighlightColor; esp.tracer.Visible = true
                            else esp.tracer.Visible = false end
                            if getESPBoxes() and rootPart then
                                local topLeft = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0))
                                local bottomRight = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                                if topLeft and bottomRight then
                                    local tl2, br2 = Vector2.new(topLeft.X, topLeft.Y), Vector2.new(bottomRight.X, bottomRight.Y)
                                    local w = 40
                                    esp.boxTop.From = Vector2.new(tl2.X - w, tl2.Y); esp.boxTop.To = Vector2.new(tl2.X + w, tl2.Y)
                                    esp.boxBottom.From = Vector2.new(br2.X - w, br2.Y); esp.boxBottom.To = Vector2.new(br2.X + w, br2.Y)
                                    esp.boxLeft.From = Vector2.new(tl2.X - w, tl2.Y); esp.boxLeft.To = Vector2.new(br2.X - w, br2.Y)
                                    esp.boxRight.From = Vector2.new(tl2.X + w, tl2.Y); esp.boxRight.To = Vector2.new(br2.X + w, br2.Y)
                                    esp.boxTop.Color = Settings.HighlightColor
                                    esp.boxBottom.Color = Settings.HighlightColor
                                    esp.boxLeft.Color = Settings.HighlightColor
                                    esp.boxRight.Color = Settings.HighlightColor
                                    esp.boxTop.Visible = true; esp.boxBottom.Visible = true
                                    esp.boxLeft.Visible = true; esp.boxRight.Visible = true
                                end
                            else
                                esp.boxTop.Visible = false; esp.boxBottom.Visible = false
                                esp.boxLeft.Visible = false; esp.boxRight.Visible = false
                            end
                        else hideDrawings(player.Name) end
                    end
                else removeHighlight(player.Name) end
            else removeHighlight(player.Name) end
        end
    end
end

for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function() task.wait(0.5); if isSelected(plr) and getESP() then addHighlight(plr) end end)
    end
end
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() task.wait(0.5); if isSelected(plr) and getESP() then addHighlight(plr) end end)
end)

-- =============================================
-- WALL CHECK + DOWNED + PREDICTION
-- =============================================
local function isVisible(targetPart)
    if not getWallCheck() then return true end
    local origin = Camera.CFrame.Position
    local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude
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
    local predAmount = getPrediction()
    if predAmount <= 0 then return part.Position end
    local vel = Vector3.new(0,0,0)
    pcall(function() vel = part.AssemblyLinearVelocity end)
    local ping = 0
    pcall(function() ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000 end)
    local totalTime = (predAmount * 0.3) + (ping * 0.5)
    return part.Position + (vel * totalTime)
end

local function getClosestFromSelected()
    local closest, shortest = nil, math.huge
    local fov = getFOVRadius()
    local hasSelected = false
    for _ in pairs(Settings.SelectedPlayers) do hasSelected = true; break end
    if not hasSelected then return nil end
    for _, player in pairs(Settings.SelectedPlayers) do
        if player and player.Character and player.Character:FindFirstChild(Settings.TargetPart) then
            local part = player.Character[Settings.TargetPart]
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                if getSkipDowned() and isDowned(player.Character) then continue end
                local sp, onScreen = Camera:WorldToScreenPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if d < fov and d < shortest then
                        if getStickyAim() or isVisible(part) then shortest = d; closest = player end
                    end
                end
            end
        end
    end
    return closest
end

-- =============================================
-- INPUT
-- =============================================
local locked = false
local menuOpen = false

local function resetInput()
    pcall(function()
        if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
        if not UserInputService.MouseIconEnabled then
            UserInputService.MouseIconEnabled = true
        end
        locked = false
        Settings.CurrentTarget = nil
    end)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if activeKeybindBtn and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
            local assignFunc = _G.DHL_KeybindAssigners and _G.DHL_KeybindAssigners[activeKeybindBtn]
            if assignFunc then assignFunc(input.KeyCode) end
            return
        else
            activeKeybindBtn.Text = "[ - ]"
            activeKeybindBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
            activeKeybindBtn = nil
            return
        end
    end

    if input.UserInputType == Enum.UserInputType.Keyboard and keybindCallbacks[input.KeyCode] then
        keybindCallbacks[input.KeyCode]()
    end

    if gpe and not UserInputService:GetFocusedTextBox() then return end

    if Settings.Mode == "RightMouseClick" and input.UserInputType == Enum.UserInputType.MouseButton2 then
        if getCamlock() then
            Settings.CurrentTarget = getClosestFromSelected()
            locked = Settings.CurrentTarget ~= nil
        end
    end
    if Settings.Mode == "ToggleQ" and input.KeyCode == Enum.KeyCode.Q then
        if getCamlock() then
            if locked then locked = false; Settings.CurrentTarget = nil
            else Settings.CurrentTarget = getClosestFromSelected(); locked = Settings.CurrentTarget ~= nil end
        end
    end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            tween(MainFrame, 0.4, {Size = UDim2.new(0, 720, 0, 500), Position = UDim2.new(0.5, -360, 0.5, -250)}, Enum.EasingStyle.Back)
        end
    end

    if input.KeyCode == Enum.KeyCode.Space and getInfJump() then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end

    if input.KeyCode == Enum.KeyCode.Escape then
        if SearchBox:IsFocused() then SearchBox:ReleaseFocus() end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if Settings.Mode == "RightMouseClick" and input.UserInputType == Enum.UserInputType.MouseButton2 then
        locked = false; Settings.CurrentTarget = nil
    end
end)

-- =============================================
-- FEATURE LOOPS
-- =============================================
RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if getSpeed() then
        local spd = getSpeedValue()
        hum.WalkSpeed = spd
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and spd > 16 then
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                hrp.Velocity = Vector3.new(moveDir.X * spd, hrp.Velocity.Y, moveDir.Z * spd)
            end
        end
    end

    if getJumpPower() then
        local jp = getJumpValue()
        hum.JumpPower = jp
        hum.JumpHeight = jp * 0.12
        hum.UseJumpPower = true
    end
end)

RunService.Stepped:Connect(function()
    if getNoclip() and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    if getAntiFling() and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.Velocity
            if vel.Magnitude > 200 then
                hrp.Velocity = Vector3.new(0, vel.Y, 0)
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not Settings.FollowPlayer or not Settings.FollowTarget then return end
    if not Settings.FollowTarget.Character then return end
    local thrp = Settings.FollowTarget.Character:FindFirstChild("HumanoidRootPart")
    local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if thrp and lhrp then
        local dist = (thrp.Position - lhrp.Position).Magnitude
        if dist > 8 then
            lhrp.CFrame = lhrp.CFrame:Lerp(CFrame.new(thrp.Position) * (lhrp.CFrame - lhrp.Position), 0.1)
        end
    end
end)

local lastDamageTick = 0
RunService.Heartbeat:Connect(function()
    if not getDamageAura() then return end
    if tick() - lastDamageTick < 0.5 then return end
    lastDamageTick = tick()
    if not LocalPlayer.Character then return end
    local lhrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not lhrp then return end
    local range = getDamageRange()
    local dmg = getDamageAmount()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if thrp and (thrp.Position - lhrp.Position).Magnitude < range then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    pcall(function() hum.Health = hum.Health - dmg end)
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if getGodMode() and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    if getCharacterSize() then
        local scale = getSizeValue()
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                if not originalSizes[part] then originalSizes[part] = part.Size end
                part.Size = originalSizes[part] * scale
            end
        end
    else
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and originalSizes[part] then
                part.Size = originalSizes[part]
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not Settings.CurrentTarget or not Settings.CurrentTarget.Character then return end
    if not getHitboxExpand() then return end
    local sizeMult = getHitboxSize()
    for _, part in ipairs(Settings.CurrentTarget.Character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if not originalSizes[part] then originalSizes[part] = part.Size end
            pcall(function() part.Size = originalSizes[part] * sizeMult end)
        end
    end
end)

-- =============================================
-- FLY + AIMLOCK + WORLD
-- =============================================
local flyBV = nil
RunService.RenderStepped:Connect(function()
    if menuOpen then return end

    if usingDrawing and fovCircle then
        fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        fovCircle.Radius = getFOVRadius()
        fovCircle.Visible = getFOVVisible()
        fovCircle.Color = getFOVThemeColor()
    end

    updateESP()

    if getFly() then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            if getNoclipFly() then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
            if not flyBV or flyBV.Parent ~= root then
                if flyBV then pcall(function() flyBV:Destroy() end) end
                flyBV = Instance.new("BodyVelocity")
                flyBV.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                flyBV.Velocity = Vector3.new(0,0,0)
                flyBV.Parent = root
                local bg = Instance.new("BodyGyro")
                bg.Name = "DHL_AntiGrav"
                bg.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
                bg.Parent = root
            end
            local speed = getFlySpeed()
            local dir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
            if dir.Magnitude > 0 then dir = dir.Unit end
            flyBV.Velocity = dir * speed
            local bg = root:FindFirstChild("DHL_AntiGrav"); if bg then bg.CFrame = Camera.CFrame end
        end
    else
        if flyBV then pcall(function() flyBV:Destroy() end); flyBV = nil end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local bg = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("DHL_AntiGrav"); if bg then bg:Destroy() end
        end
    end

    if not getCamlock() then locked = false; Settings.CurrentTarget = nil; return end

    if getAlwaysOn() then
        if not Settings.CurrentTarget or not Settings.CurrentTarget.Character then
            Settings.CurrentTarget = getClosestFromSelected()
            locked = Settings.CurrentTarget ~= nil
        end
    end

    if Settings.Mode == "NearestCursor" then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            Settings.CurrentTarget = getClosestFromSelected(); locked = Settings.CurrentTarget ~= nil
        else locked = false; Settings.CurrentTarget = nil end
    end

    if getTriggerBot() and locked and Settings.CurrentTarget and Settings.CurrentTarget.Character then
        local part = Settings.CurrentTarget.Character:FindFirstChild(Settings.TargetPart)
        if part then
            local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < 15 then
                    pcall(function()
                        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end)
                end
            end
        end
    end

    if locked and Settings.CurrentTarget and Settings.CurrentTarget.Character then
        local part = Settings.CurrentTarget.Character:FindFirstChild(Settings.TargetPart)
        if not part then part = Settings.CurrentTarget.Character:FindFirstChild("HumanoidRootPart") end
        if part then
            local hum = Settings.CurrentTarget.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                if getSkipDowned() and isDowned(Settings.CurrentTarget.Character) then
                    if getAutoSwitch() then
                        Settings.CurrentTarget = getClosestFromSelected(); locked = Settings.CurrentTarget ~= nil
                    else locked = false; Settings.CurrentTarget = nil end
                    return
                end
                local canSee = isVisible(part)
                if canSee or getStickyAim() then
                    local smoothness = getSmoothness()
                    local shake = getAimShake()
                    local predictedPos = getPredictedPosition(part)
                    if shake > 0 then
                        predictedPos = predictedPos + Vector3.new(
                            math.random(-shake*10, shake*10)/10,
                            math.random(-shake*10, shake*10)/10,
                            math.random(-shake*10, shake*10)/10)
                    end
                    local targetCFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, smoothness)
                else
                    if getWallCheck() and not getStickyAim() then
                        if getAutoSwitch() then
                            Settings.CurrentTarget = getClosestFromSelected(); locked = Settings.CurrentTarget ~= nil
                        else locked = false; Settings.CurrentTarget = nil end
                    end
                end
            else
                if getAutoSwitch() then
                    Settings.CurrentTarget = getClosestFromSelected(); locked = Settings.CurrentTarget ~= nil
                else locked = false; Settings.CurrentTarget = nil end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if getFullbright() then
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.Brightness = OriginalLighting.Brightness
    end
    if getNoFog() then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = OriginalLighting.FogEnd
    end
    if getRemoveShadows() then
        Lighting.GlobalShadows = false
    else
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    end
    if getTimeChanger() then
        Lighting.ClockTime = getTimeValue()
    else
        Lighting.ClockTime = OriginalLighting.ClockTime
    end
end)

pcall(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function() vu:CaptureController(); vu:ClickButton2(Vector2.new()) end)
end)

-- =============================================
-- ESC MENU
-- =============================================
local guiWasVisible = true
local savedHighlightData = {}

pcall(function()
    GuiService.MenuOpened:Connect(function()
        menuOpen = true
        guiWasVisible = MainFrame.Visible
        MainFrame.Visible = false
        Watermark.Visible = false
        savedHighlightData = {}
        for name, hl in pairs(highlightObjects) do
            pcall(function() savedHighlightData[name] = hl.Parent; hl.Parent = nil end)
        end
        for _, esp in pairs(espDrawings) do 
            for _, obj in pairs(esp) do pcall(function() obj.Visible = false end) end 
        end
        if fovCircle then pcall(function() fovCircle.Visible = false end) end
        locked = false
        Settings.CurrentTarget = nil
    end)

    GuiService.MenuClosed:Connect(function()
        menuOpen = false
        MainFrame.Visible = guiWasVisible
        Watermark.Visible = getWatermark()
        for name, parent in pairs(savedHighlightData) do
            if highlightObjects[name] and parent then pcall(function() highlightObjects[name].Parent = parent end) end
        end
        savedHighlightData = {}
        if fovCircle and getFOVVisible() then pcall(function() fovCircle.Visible = true end) end
        resetInput(); task.wait(0.1); resetInput(); task.wait(0.15); resetInput()
    end)
end)

LocalPlayer.CharacterRemoving:Connect(function()
    for name in pairs(highlightObjects) do removeHighlight(name) end
    if flyBV then pcall(function() flyBV:Destroy() end); flyBV = nil end
end)

UserInputService.WindowFocused:Connect(function() task.wait(0.2); resetInput() end)
UserInputService.WindowFocusReleased:Connect(function() resetInput() end)

print("[DHL VIP] Yuklendi!")

-- Splash sonrasi GUI ac
task.spawn(function()
    task.wait(2.5) -- Splash suresi
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    tween(MainFrame, 0.6, {
        Size = UDim2.new(0, 720, 0, 500),
        Position = UDim2.new(0.5, -360, 0.5, -250),
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    task.wait(0.7)
    showToast("👑 DHL VIP", "Ultra Premium Edition aktif!", "vip")
    task.wait(0.8)
    showToast("Hosgeldiniz", "Right Shift ile GUI'yi ac/kapa", "info")
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "👑 DHL VIP",
        Text = "Ultra Premium Edition yuklendi!",
        Duration = 5
    })
end)
