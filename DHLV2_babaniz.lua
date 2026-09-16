--[[
    DHL VIP - CLEAN PRO EDITION
    Profesyonel, minimal, kurumsal tasarim
    Yapay zeka destekli hile gorunumu
]]

print("[DHL VIP] Clean Pro Edition yukleniyor...")

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
-- PRO THEMES (Sade ve Profesyonel)
-- =============================================
local Themes = {
    Obsidian = {Name="Obsidian", Primary=Color3.fromRGB(100,110,130), Accent=Color3.fromRGB(160,180,210), Bg=Color3.fromRGB(12,13,16),  Panel=Color3.fromRGB(18,19,23),  Button=Color3.fromRGB(26,28,34),  Text=Color3.fromRGB(200,210,220), SubText=Color3.fromRGB(120,130,140), G1=Color3.fromRGB(140,150,170), G2=Color3.fromRGB(80,90,110)},
    Cobalt   = {Name="Cobalt",   Primary=Color3.fromRGB(50,100,180),  Accent=Color3.fromRGB(100,160,240), Bg=Color3.fromRGB(10,12,18),  Panel=Color3.fromRGB(16,20,28),  Button=Color3.fromRGB(24,30,42),  Text=Color3.fromRGB(200,215,235), SubText=Color3.fromRGB(110,130,160), G1=Color3.fromRGB(80,140,220), G2=Color3.fromRGB(40,80,160)},
    Noir     = {Name="Noir",     Primary=Color3.fromRGB(80,80,80),    Accent=Color3.fromRGB(200,200,200), Bg=Color3.fromRGB(8,8,8),     Panel=Color3.fromRGB(14,14,14),  Button=Color3.fromRGB(22,22,22),  Text=Color3.fromRGB(230,230,230), SubText=Color3.fromRGB(120,120,120), G1=Color3.fromRGB(180,180,180), G2=Color3.fromRGB(80,80,80)},
    Crimson  = {Name="Crimson",  Primary=Color3.fromRGB(140,30,50),   Accent=Color3.fromRGB(230,90,110),  Bg=Color3.fromRGB(14,8,12),   Panel=Color3.fromRGB(22,14,18),  Button=Color3.fromRGB(34,20,26),  Text=Color3.fromRGB(230,200,205), SubText=Color3.fromRGB(150,110,120), G1=Color3.fromRGB(200,60,90), G2=Color3.fromRGB(100,20,40)},
    Emerald  = {Name="Emerald",  Primary=Color3.fromRGB(40,140,100),  Accent=Color3.fromRGB(90,220,170),  Bg=Color3.fromRGB(8,14,12),   Panel=Color3.fromRGB(14,22,18),  Button=Color3.fromRGB(22,34,28),  Text=Color3.fromRGB(200,230,215), SubText=Color3.fromRGB(110,150,130), G1=Color3.fromRGB(70,190,140), G2=Color3.fromRGB(30,90,70)},
    Violet   = {Name="Violet",   Primary=Color3.fromRGB(110,60,180),  Accent=Color3.fromRGB(180,120,255), Bg=Color3.fromRGB(12,10,20),  Panel=Color3.fromRGB(20,16,32),  Button=Color3.fromRGB(30,24,48),  Text=Color3.fromRGB(220,210,240), SubText=Color3.fromRGB(140,120,170), G1=Color3.fromRGB(150,100,240), G2=Color3.fromRGB(80,40,140)},
    Slate    = {Name="Slate",    Primary=Color3.fromRGB(70,90,110),   Accent=Color3.fromRGB(130,170,200), Bg=Color3.fromRGB(10,13,18),  Panel=Color3.fromRGB(16,20,28),  Button=Color3.fromRGB(24,30,40),  Text=Color3.fromRGB(200,215,230), SubText=Color3.fromRGB(110,130,150), G1=Color3.fromRGB(120,150,180), G2=Color3.fromRGB(60,80,100)},
}
local CurrentTheme = Themes.Obsidian

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
    HighlightFillTransparency = 0.35, HighlightColor = Color3.fromRGB(140,150,170),
    
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
-- GUI
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
-- CLEAN SPLASH SCREEN
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

-- Ince cizgi efekti
local lineTop = Instance.new("Frame")
lineTop.Size = UDim2.new(0, 0, 0, 1)
lineTop.Position = UDim2.new(0.5, 0, 0.5, -60)
lineTop.AnchorPoint = Vector2.new(0.5, 0.5)
lineTop.BackgroundColor3 = CurrentTheme.Primary
lineTop.BorderSizePixel = 0
lineTop.ZIndex = 2
lineTop.Parent = splashFrame

local lineBottom = Instance.new("Frame")
lineBottom.Size = UDim2.new(0, 0, 0, 1)
lineBottom.Position = UDim2.new(0.5, 0, 0.5, 60)
lineBottom.AnchorPoint = Vector2.new(0.5, 0.5)
lineBottom.BackgroundColor3 = CurrentTheme.Primary
lineBottom.BorderSizePixel = 0
lineBottom.ZIndex = 2
lineBottom.Parent = splashFrame

-- Title (Clean, minimal)
local splashTitle = Instance.new("TextLabel")
splashTitle.Size = UDim2.new(1, 0, 0, 40)
splashTitle.Position = UDim2.new(0, 0, 0.5, -20)
splashTitle.BackgroundTransparency = 1
splashTitle.Text = "D H L"
splashTitle.TextColor3 = Color3.fromRGB(255,255,255)
splashTitle.TextSize = 36
splashTitle.Font = Enum.Font.GothamBlack
splashTitle.TextTransparency = 1
splashTitle.ZIndex = 3
splashTitle.Parent = splashFrame

local splashSub = Instance.new("TextLabel")
splashSub.Size = UDim2.new(1, 0, 0, 16)
splashSub.Position = UDim2.new(0, 0, 0.5, 22)
splashSub.BackgroundTransparency = 1
splashSub.Text = "P R O F E S S I O N A L   E D I T I O N"
splashSub.TextColor3 = CurrentTheme.SubText
splashSub.TextSize = 9
splashSub.Font = Enum.Font.GothamSemibold
splashSub.TextTransparency = 1
splashSub.ZIndex = 3
splashSub.Parent = splashFrame

-- Progress bar (ince, minimal)
local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(0, 240, 0, 2)
progressBg.Position = UDim2.new(0.5, -120, 0.5, 90)
progressBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
progressBg.BorderSizePixel = 0
progressBg.BackgroundTransparency = 1
progressBg.ZIndex = 3
progressBg.Parent = splashFrame

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = CurrentTheme.Primary
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 4
progressFill.Parent = progressBg

local progressText = Instance.new("TextLabel")
progressText.Size = UDim2.new(0, 240, 0, 14)
progressText.Position = UDim2.new(0.5, -120, 0.5, 100)
progressText.BackgroundTransparency = 1
progressText.Text = "Initializing..."
progressText.TextColor3 = CurrentTheme.SubText
progressText.TextSize = 10
progressText.Font = Enum.Font.Gotham
progressText.TextTransparency = 1
progressText.ZIndex = 4
progressText.Parent = splashFrame

-- Splash animasyonu
task.spawn(function()
    task.wait(0.15)
    
    -- Cizgiler acilir
    tween(lineTop, 0.5, {Size = UDim2.new(0, 300, 0, 1)}, Enum.EasingStyle.Quart)
    tween(lineBottom, 0.5, {Size = UDim2.new(0, 300, 0, 1)}, Enum.EasingStyle.Quart)
    
    task.wait(0.3)
    
    -- Title fade
    tween(splashTitle, 0.4, {TextTransparency = 0})
    task.wait(0.2)
    
    -- Subtitle
    tween(splashSub, 0.4, {TextTransparency = 0})
    task.wait(0.25)
    
    -- Progress
    tween(progressBg, 0.2, {BackgroundTransparency = 0})
    tween(progressText, 0.3, {TextTransparency = 0})
    
    -- Progress mesajlari
    local messages = {"Initializing...", "Loading modules...", "Injecting...", "Ready"}
    for i, msg in ipairs(messages) do
        progressText.Text = msg
        tween(progressFill, 0.25, {Size = UDim2.new(i / #messages, 0, 1, 0)}, Enum.EasingStyle.Quad)
        task.wait(0.28)
    end
    
    task.wait(0.2)
    
    -- Cikis
    tween(splashFrame, 0.5, {BackgroundTransparency = 1})
    tween(splashTitle, 0.4, {TextTransparency = 1})
    tween(splashSub, 0.4, {TextTransparency = 1})
    tween(progressText, 0.3, {TextTransparency = 1})
    tween(progressBg, 0.3, {BackgroundTransparency = 1})
    tween(lineTop, 0.4, {Size = UDim2.new(0, 0, 0, 1)})
    tween(lineBottom, 0.4, {Size = UDim2.new(0, 0, 0, 1)})
    task.wait(0.55)
    splashGui:Destroy()
end)

-- =============================================
-- CLEAN TOAST SISTEMI
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
toastLayout.Padding = UDim.new(0, 8)
toastLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local function showToast(title, message, toastType)
    toastType = toastType or "info"
    local colors = {
        info = CurrentTheme.Accent,
        success = Color3.fromRGB(80, 200, 130),
        warning = Color3.fromRGB(230, 180, 60),
        error = Color3.fromRGB(220, 70, 80),
    }
    
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 0, 0, 52)
    toast.Position = UDim2.new(1, 20, 0, 0)
    toast.BackgroundColor3 = CurrentTheme.Panel
    toast.BackgroundTransparency = 0.05
    toast.BorderSizePixel = 0
    toast.ZIndex = 1001
    toast.Parent = toastContainer
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", toast)
    stroke.Color = CurrentTheme.Button
    stroke.Thickness = 1
    stroke.Transparency = 0
    
    -- Sol ince renkli serit
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 2, 1, 0)
    bar.Position = UDim2.new(0, 0, 0, 0)
    bar.BackgroundColor3 = colors[toastType]
    bar.BorderSizePixel = 0
    bar.ZIndex = 1002
    bar.Parent = toast
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -24, 0, 18)
    titleLbl.Position = UDim2.new(0, 14, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = CurrentTheme.Text
    titleLbl.TextSize = 12
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 1002
    titleLbl.Parent = toast
    
    local msgLbl = Instance.new("TextLabel")
    msgLbl.Size = UDim2.new(1, -24, 0, 16)
    msgLbl.Position = UDim2.new(0, 14, 0, 28)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text = message
    msgLbl.TextColor3 = CurrentTheme.SubText
    msgLbl.TextSize = 10
    msgLbl.Font = Enum.Font.Gotham
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.ZIndex = 1002
    msgLbl.Parent = toast
    
    -- Giris
    tween(toast, 0.4, {Size = UDim2.new(0, 320, 0, 52), Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quint)
    
    task.delay(3, function()
        tween(toast, 0.3, {Position = UDim2.new(1, 20, 0, 0)}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        tween(toast, 0.3, {BackgroundTransparency = 1})
        tween(titleLbl, 0.25, {TextTransparency = 1})
        tween(msgLbl, 0.25, {TextTransparency = 1})
        tween(stroke, 0.25, {Transparency = 1})
        task.wait(0.35)
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
-- MAIN FRAME (Clean, minimal)
-- =============================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 700, 0, 480)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
MainFrame.BackgroundColor3 = CurrentTheme.Bg
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Active = false
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Clean border (ince, keskin)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = CurrentTheme.Button
mainStroke.Thickness = 1
mainStroke.Transparency = 0

-- Ust kenar vurgu cizgisi
local topAccent = Instance.new("Frame")
topAccent.Size = UDim2.new(0, 120, 0, 1)
topAccent.Position = UDim2.new(0, 24, 0, 1)
topAccent.BackgroundColor3 = CurrentTheme.Primary
topAccent.BorderSizePixel = 0
topAccent.ZIndex = 5
topAccent.Parent = MainFrame

local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1, 0, 0, 55); DragHandle.BackgroundTransparency = 1
DragHandle.Text = ""; DragHandle.AutoButtonColor = false; DragHandle.ZIndex = 10; DragHandle.Parent = MainFrame
makeDraggable(MainFrame, DragHandle)

-- Basit arka plan (cok hafif gradient)
local mainGradient = Instance.new("UIGradient", MainFrame)
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(CurrentTheme.Bg.R*255 + 4, CurrentTheme.Bg.G*255 + 4, CurrentTheme.Bg.B*255 + 4)),
    ColorSequenceKeypoint.new(1, CurrentTheme.Bg),
})
mainGradient.Rotation = 135

-- Baslik (SOLDA KUCUK NOKTA + TEXT)
local dotIndicator = Instance.new("Frame")
dotIndicator.Size = UDim2.new(0, 6, 0, 6)
dotIndicator.Position = UDim2.new(0, 24, 0, 22)
dotIndicator.BackgroundColor3 = CurrentTheme.Primary
dotIndicator.BorderSizePixel = 0
dotIndicator.ZIndex = 5
dotIndicator.Parent = MainFrame
Instance.new("UICorner", dotIndicator).CornerRadius = UDim.new(1, 0)

-- Dot pulse
task.spawn(function()
    while dotIndicator.Parent do
        tween(dotIndicator, 1.5, {BackgroundTransparency = 0.5}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.5)
        tween(dotIndicator, 1.5, {BackgroundTransparency = 0}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.5)
    end
end)

local tl = Instance.new("TextLabel")
tl.Size = UDim2.new(1, 0, 0, 18); tl.Position = UDim2.new(0, 38, 0, 16)
tl.BackgroundTransparency = 1
tl.Text = "DHL VIP"
tl.TextColor3 = CurrentTheme.Text
tl.TextSize = 15
tl.Font = Enum.Font.GothamBold
tl.TextXAlignment = Enum.TextXAlignment.Left
tl.ZIndex = 5
tl.Parent = MainFrame

local cl = Instance.new("TextLabel")
cl.Size = UDim2.new(1, 0, 0, 14); cl.Position = UDim2.new(0, 38, 0, 32)
cl.BackgroundTransparency = 1
cl.Text = "PROFESSIONAL EDITION"
cl.TextColor3 = CurrentTheme.SubText
cl.TextSize = 9
cl.Font = Enum.Font.GothamSemibold
cl.TextXAlignment = Enum.TextXAlignment.Left
cl.ZIndex = 5
cl.Parent = MainFrame

-- Versiyon (sag ust)
local versionLbl = Instance.new("TextLabel")
versionLbl.Size = UDim2.new(0, 60, 0, 14)
versionLbl.Position = UDim2.new(1, -120, 0, 20)
versionLbl.BackgroundTransparency = 1
versionLbl.Text = "v6.0.1"
versionLbl.TextColor3 = CurrentTheme.SubText
versionLbl.TextSize = 10
versionLbl.Font = Enum.Font.Gotham
versionLbl.TextXAlignment = Enum.TextXAlignment.Right
versionLbl.ZIndex = 5
versionLbl.Parent = MainFrame

-- Kapat butonu (sade, minimal)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0, 14)
closeBtn.BackgroundColor3 = CurrentTheme.Button
closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"
closeBtn.TextColor3 = CurrentTheme.SubText
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.Gotham
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 11
closeBtn.Parent = MainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)
closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(180, 50, 50), BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255,255,255)})
end)
closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, 0.15, {BackgroundColor3 = CurrentTheme.Button, BackgroundTransparency = 0.3, TextColor3 = CurrentTheme.SubText})
end)
closeBtn.MouseButton1Click:Connect(function()
    tween(MainFrame, 0.35, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.4)
    MainFrame.Visible = false
    MainFrame.Size = UDim2.new(0, 700, 0, 480)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
    MainFrame.BackgroundTransparency = 0
end)

-- =============================================
-- SIDEBAR (Clean)
-- =============================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 155, 1, -110)
Sidebar.Position = UDim2.new(0, 15, 0, 95)
Sidebar.BackgroundColor3 = CurrentTheme.Panel
Sidebar.BackgroundTransparency = 0
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 4
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local sideStroke = Instance.new("UIStroke", Sidebar)
sideStroke.Color = CurrentTheme.Button
sideStroke.Thickness = 1
sideStroke.Transparency = 0

-- Profil
local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(1, -12, 0, 55)
profileFrame.Position = UDim2.new(0, 6, 0, 6)
profileFrame.BackgroundColor3 = CurrentTheme.Button
profileFrame.BackgroundTransparency = 0.5
profileFrame.BorderSizePixel = 0
profileFrame.ZIndex = 5
profileFrame.Parent = Sidebar
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(0, 4)

local avatarCircle = Instance.new("Frame")
avatarCircle.Size = UDim2.new(0, 36, 0, 36)
avatarCircle.Position = UDim2.new(0, 8, 0.5, -18)
avatarCircle.BackgroundColor3 = CurrentTheme.Button
avatarCircle.BorderSizePixel = 0
avatarCircle.ZIndex = 6
avatarCircle.Parent = profileFrame
Instance.new("UICorner", avatarCircle).CornerRadius = UDim.new(1, 0)

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(1, -2, 1, -2)
avatarImg.Position = UDim2.new(0, 1, 0, 1)
avatarImg.BackgroundTransparency = 1
avatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
avatarImg.ZIndex = 7
avatarImg.Parent = avatarCircle
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

-- Avatar etrafinda ince halka
local avatarRing = Instance.new("UIStroke", avatarCircle)
avatarRing.Color = CurrentTheme.Primary
avatarRing.Thickness = 1.5
avatarRing.Transparency = 0.3

local profileName = Instance.new("TextLabel")
profileName.Size = UDim2.new(1, -54, 0, 16)
profileName.Position = UDim2.new(0, 50, 0, 12)
profileName.BackgroundTransparency = 1
profileName.Text = LocalPlayer.DisplayName
profileName.TextColor3 = CurrentTheme.Text
profileName.TextSize = 12
profileName.Font = Enum.Font.GothamBold
profileName.TextXAlignment = Enum.TextXAlignment.Left
profileName.TextTruncate = Enum.TextTruncate.AtEnd
profileName.ZIndex = 6
profileName.Parent = profileFrame

local profileStatus = Instance.new("TextLabel")
profileStatus.Size = UDim2.new(1, -54, 0, 12)
profileStatus.Position = UDim2.new(0, 50, 0, 28)
profileStatus.BackgroundTransparency = 1
profileStatus.Text = "● CONNECTED"
profileStatus.TextColor3 = Color3.fromRGB(80, 200, 130)
profileStatus.TextSize = 9
profileStatus.Font = Enum.Font.GothamSemibold
profileStatus.TextXAlignment = Enum.TextXAlignment.Left
profileStatus.ZIndex = 6
profileStatus.Parent = profileFrame

-- Sidebar scroll
local SideScroll = Instance.new("ScrollingFrame")
SideScroll.Size = UDim2.new(1, -12, 1, -78)
SideScroll.Position = UDim2.new(0, 6, 0, 66)
SideScroll.BackgroundTransparency = 1
SideScroll.BorderSizePixel = 0
SideScroll.ScrollBarThickness = 2
SideScroll.ScrollBarImageColor3 = CurrentTheme.Button
SideScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
SideScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SideScroll.ZIndex = 5
SideScroll.Parent = Sidebar

local sideLayout = Instance.new("UIListLayout", SideScroll)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Padding = UDim.new(0, 2)

-- =============================================
-- CONTENT AREA
-- =============================================
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -190, 1, -110)
ContentArea.Position = UDim2.new(0, 175, 0, 95)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 3
ContentArea.Parent = MainFrame

-- =============================================
-- TAB SYSTEM (Clean, sade)
-- =============================================
local tabConfig = {
    {Name = "AIMLOCK",   Sub = "Targeting system"},
    {Name = "ESP",       Sub = "Visual overlay"},
    {Name = "MOVEMENT",  Sub = "Speed & flight"},
    {Name = "PLAYERS",   Sub = "Player actions"},
    {Name = "WORLD",     Sub = "Environment"},
    {Name = "CHARACTER", Sub = "Player state"},
    {Name = "SETTINGS",  Sub = "Configuration"},
}

local tabPages = {}
local tabButtons = {}
local activeTab = "AIMLOCK"
local uiElements = {}
local activeKeybindBtn = nil
local keybindCallbacks = {}

-- Sekme gecis animasyonu
local function animatePageSwitch(oldPage, newPage)
    if oldPage then
        tween(oldPage, 0.15, {Position = UDim2.new(0, -20, 0, 0)}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(0.15, function()
            oldPage.Visible = false
            oldPage.Position = UDim2.new(0, 0, 0, 0)
        end)
    end
    
    task.delay(0.05, function()
        newPage.Visible = true
        newPage.Position = UDim2.new(0, 20, 0, 0)
        tween(newPage, 0.25, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quint)
    end)
end

for i, config in ipairs(tabConfig) do
    local name = config.Name
    local sub = config.Sub
    
    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. name
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = i==1 and CurrentTheme.Button or Color3.fromRGB(0,0,0)
    btn.BackgroundTransparency = i==1 and 0 or 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.ZIndex = 5
    btn.Parent = SideScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    -- Aktif indicator (sol ince serit)
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 2, 0.6, 0)
    indicator.Position = UDim2.new(0, 0, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.BackgroundColor3 = CurrentTheme.Primary
    indicator.BorderSizePixel = 0
    indicator.Visible = (i == 1)
    indicator.ZIndex = 7
    indicator.Parent = btn
    
    -- Ana text (buyuk harf)
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -20, 0, 16)
    nameLbl.Position = UDim2.new(0, 14, 0, 6)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = i==1 and CurrentTheme.Text or CurrentTheme.SubText
    nameLbl.TextSize = 11
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 6
    nameLbl.Parent = btn
    
    -- Alt text (aciklama)
    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -20, 0, 12)
    subLbl.Position = UDim2.new(0, 14, 0, 22)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = sub
    subLbl.TextColor3 = CurrentTheme.SubText
    subLbl.TextSize = 8
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.ZIndex = 6
    subLbl.Parent = btn
    
    tabButtons[name] = btn
    
    btn.MouseEnter:Connect(function()
        if activeTab ~= name then
            tween(btn, 0.15, {BackgroundTransparency = 0.7, BackgroundColor3 = CurrentTheme.Button})
            tween(nameLbl, 0.15, {TextColor3 = CurrentTheme.Text})
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= name then
            tween(btn, 0.15, {BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(0,0,0)})
            tween(nameLbl, 0.15, {TextColor3 = CurrentTheme.SubText})
        end
    end)
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = CurrentTheme.Button
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
        
        for n,b in pairs(tabButtons) do 
            local isActive = (n == name)
            tween(b, 0.2, {
                BackgroundColor3 = isActive and CurrentTheme.Button or Color3.fromRGB(0,0,0),
                BackgroundTransparency = isActive and 0 or 1
            })
            local ind = b:FindFirstChild("Indicator")
            if ind then ind.Visible = isActive end
            local nameLbl = b:FindFirstChildOfClass("TextLabel")
            if nameLbl then
                tween(nameLbl, 0.15, {TextColor3 = isActive and CurrentTheme.Text or CurrentTheme.SubText})
            end
        end
        
        animatePageSwitch(tabPages[oldTab], page)
    end)
end

-- =============================================
-- UI BUILDERS (Clean, Professional)
-- =============================================
local function addToggle(page, name, default, callback, order, withKeybind)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 34)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order or 0
    row.ZIndex = 3
    row.Parent = page

    local toggleWidth = withKeybind and UDim2.new(1, -76, 1, 0) or UDim2.new(1, 0, 1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = toggleWidth
    btn.BackgroundColor3 = CurrentTheme.Button
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = CurrentTheme.Text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = false
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 3
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    -- Sol durum noktasi
    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 6, 0, 6)
    statusDot.Position = UDim2.new(0, 12, 0.5, -3)
    statusDot.BackgroundColor3 = default and Color3.fromRGB(80, 200, 130) or CurrentTheme.SubText
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 4
    statusDot.Parent = btn
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)
    
    -- Text padding sol
    local textPad = Instance.new("UIPadding", btn)
    textPad.PaddingLeft = UDim.new(0, 26)
    
    -- Durum text (sagda)
    local stateLbl = Instance.new("TextLabel")
    stateLbl.Size = UDim2.new(0, 40, 1, 0)
    stateLbl.Position = UDim2.new(1, -48, 0, 0)
    stateLbl.BackgroundTransparency = 1
    stateLbl.Text = default and "ON" or "OFF"
    stateLbl.TextColor3 = default and Color3.fromRGB(80, 200, 130) or CurrentTheme.SubText
    stateLbl.TextSize = 10
    stateLbl.Font = Enum.Font.GothamBold
    stateLbl.TextXAlignment = Enum.TextXAlignment.Right
    stateLbl.ZIndex = 4
    stateLbl.Parent = btn
    
    table.insert(uiElements, {element=btn, type="toggle"})

    local state = default
    local function doToggle()
        state = not state
        tween(btn, 0.2, {BackgroundTransparency = state and 0.15 or 0.3})
        tween(statusDot, 0.2, {BackgroundColor3 = state and Color3.fromRGB(80, 200, 130) or CurrentTheme.SubText})
        tween(stateLbl, 0.2, {TextColor3 = state and Color3.fromRGB(80, 200, 130) or CurrentTheme.SubText})
        stateLbl.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end
    btn.MouseButton1Click:Connect(doToggle)
    
    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, {BackgroundTransparency = state and 0.05 or 0.15})
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, {BackgroundTransparency = state and 0.15 or 0.3})
    end)

    if withKeybind then
        local kbBtn = Instance.new("TextButton")
        kbBtn.Size = UDim2.new(0, 68, 1, 0)
        kbBtn.Position = UDim2.new(1, -68, 0, 0)
        kbBtn.BackgroundColor3 = CurrentTheme.Button
        kbBtn.BackgroundTransparency = 0.5
        kbBtn.BorderSizePixel = 0
        kbBtn.Text = "—"
        kbBtn.TextColor3 = CurrentTheme.SubText
        kbBtn.TextSize = 10
        kbBtn.Font = Enum.Font.GothamBold
        kbBtn.AutoButtonColor = false
        kbBtn.ZIndex = 4
        kbBtn.Parent = row
        Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 4)
        local kbStroke = Instance.new("UIStroke", kbBtn)
        kbStroke.Color = CurrentTheme.Button
        kbStroke.Thickness = 1
        kbStroke.Transparency = 0
        table.insert(uiElements, {element=kbBtn, type="keybindBg"})
        table.insert(uiElements, {element=kbStroke, type="stroke"})

        kbBtn.MouseButton1Click:Connect(function()
            if activeKeybindBtn == kbBtn then
                activeKeybindBtn = nil
                kbBtn.Text = "—"
                kbBtn.TextColor3 = CurrentTheme.SubText
                tween(kbBtn, 0.2, {BackgroundTransparency = 0.5})
                return
            end
            if activeKeybindBtn then
                activeKeybindBtn.Text = "—"
                activeKeybindBtn.TextColor3 = CurrentTheme.SubText
                tween(activeKeybindBtn, 0.2, {BackgroundTransparency = 0.5})
            end
            activeKeybindBtn = kbBtn
            kbBtn.Text = "..."
            kbBtn.TextColor3 = Color3.fromRGB(230, 180, 60)
            tween(kbBtn, 0.2, {BackgroundTransparency = 0.2})
        end)

        local function assignKeybind(keyCode)
            kbBtn.Text = keyCode.Name
            kbBtn.TextColor3 = CurrentTheme.Text
            tween(kbBtn, 0.15, {BackgroundTransparency = 0.3})
            keybindCallbacks[keyCode] = doToggle
            activeKeybindBtn = nil
        end

        if not _G.DHL_KeybindAssigners then _G.DHL_KeybindAssigners = {} end
        _G.DHL_KeybindAssigners[kbBtn] = assignKeybind
    end

    return function() return state end, function(v)
        state = v
        tween(btn, 0.2, {BackgroundTransparency = state and 0.15 or 0.3})
        tween(statusDot, 0.2, {BackgroundColor3 = state and Color3.fromRGB(80, 200, 130) or CurrentTheme.SubText})
        tween(stateLbl, 0.2, {TextColor3 = state and Color3.fromRGB(80, 200, 130) or CurrentTheme.SubText})
        stateLbl.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end
end

local function addSlider(page, name, min, max, default, callback, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,-8,0,46)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order or 0
    container.ZIndex = 3
    container.Parent = page

    -- Ust satir: isim + deger
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 16)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = CurrentTheme.Text
    label.TextSize = 11
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    label.Parent = container

    local valueLbl = Instance.new("TextLabel")
    valueLbl.Size = UDim2.new(0.4, -4, 0, 16)
    valueLbl.Position = UDim2.new(0.6, 0, 0, 0)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text = string.format("%.3f", default)
    valueLbl.TextColor3 = CurrentTheme.Accent
    valueLbl.TextSize = 11
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right
    valueLbl.ZIndex = 3
    valueLbl.Parent = container

    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(1,0,0,6)
    bg.Position = UDim2.new(0,0,0,26)
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
    fill.BackgroundColor3 = CurrentTheme.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 3
    fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    table.insert(uiElements, {element=fill, type="fill"})
    table.insert(uiElements, {element=bg, type="bg"})

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,10,0,10)
    knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new((default-min)/(max-min),0,0.5,0)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 4
    knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
    table.insert(uiElements, {element=knob, type="knob"})

    local value = default
    local sliding = false
    local function update(px)
        local ax,as = bg.AbsolutePosition.X, bg.AbsoluteSize.X
        if as == 0 then return end
        local p = math.clamp((px-ax)/as, 0, 1)
        value = min + (max-min)*p
        tween(fill, 0.06, {Size = UDim2.new(p,0,1,0)})
        tween(knob, 0.06, {Position = UDim2.new(p,0,0.5,0)})
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

local function addCycleButton(page, name, options, default, callback, order)
    local idx = 1
    for i,v in ipairs(options) do if v == default then idx = i; break end end
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-8,0,34)
    btn.BackgroundColor3 = CurrentTheme.Button
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = order or 0
    btn.ZIndex = 3
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    local s = Instance.new("UIStroke", btn)
    s.Color = CurrentTheme.Button
    s.Thickness = 1
    s.Transparency = 0
    table.insert(uiElements, {element=s, type="stroke"})
    
    -- Isim
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.5, 0, 1, 0)
    nameLbl.Position = UDim2.new(0, 12, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = CurrentTheme.Text
    nameLbl.TextSize = 11
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 4
    nameLbl.Parent = btn
    
    -- Deger
    local valueLbl = Instance.new("TextLabel")
    valueLbl.Size = UDim2.new(0.5, -12, 1, 0)
    valueLbl.Position = UDim2.new(0.5, 0, 0, 0)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text = options[idx]
    valueLbl.TextColor3 = CurrentTheme.Accent
    valueLbl.TextSize = 11
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right
    valueLbl.ZIndex = 4
    valueLbl.Parent = btn
    
    btn.MouseEnter:Connect(function() tween(btn, 0.15, {BackgroundTransparency = 0.15}) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.15, {BackgroundTransparency = 0.3}) end)
    
    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        valueLbl.Text = options[idx]
        tween(valueLbl, 0.1, {TextColor3 = Color3.fromRGB(255,255,255)})
        task.wait(0.1)
        tween(valueLbl, 0.15, {TextColor3 = CurrentTheme.Accent})
        if callback then callback(options[idx]) end
    end)
    return function() return options[idx] end
end

local function addSeparator(page, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,-16,0,16)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order or 0
    container.ZIndex = 3
    container.Parent = page
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = CurrentTheme.Button
    line.BorderSizePixel = 0
    line.ZIndex = 3
    line.Parent = container
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 100, 1, 0)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundColor3 = CurrentTheme.Bg
    lbl.BorderSizePixel = 0
    lbl.Text = ""
    lbl.TextColor3 = CurrentTheme.SubText
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 4
    lbl.Parent = container
    
    table.insert(uiElements, {element=line, type="separatorLine"})
end

local function addLabel(page, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-8,0,20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = CurrentTheme.SubText
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0
    lbl.ZIndex = 3
    lbl.Parent = page
    table.insert(uiElements, {element=lbl, type="sectionLabel"})
end

local function addButton(page, name, callback, order, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-8,0,36)
    btn.BackgroundColor3 = color or CurrentTheme.Button
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = CurrentTheme.Text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = false
    btn.LayoutOrder = order or 0
    btn.ZIndex = 3
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = CurrentTheme.Button
    stroke.Thickness = 1
    stroke.Transparency = 0
    
    btn.MouseEnter:Connect(function() tween(btn, 0.15, {BackgroundTransparency = 0.05}) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.15, {BackgroundTransparency = 0.2}) end)
    
    btn.MouseButton1Click:Connect(function()
        tween(btn, 0.1, {BackgroundTransparency = 0})
        task.wait(0.1)
        tween(btn, 0.15, {BackgroundTransparency = 0.2})
        if callback then callback() end
    end)
    return btn
end

local function getFOVThemeColor()
    if Settings.FOVUseTheme then return CurrentTheme.Accent end
    return Color3.fromRGB(200,80,80)
end

-- =============================================
-- PAGES
-- =============================================

-- PAGE 1: AIMLOCK
local p1 = tabPages["AIMLOCK"]
addLabel(p1, "CAMLOCK", 1)
local getCamlock = addToggle(p1, "Camlock System", true, nil, 2, true)
local getWallCheck = addToggle(p1, "Wall Check", false, nil, 3, true)
local getStickyAim = addToggle(p1, "Sticky Aim", true, nil, 4, true)
local getAutoSwitch = addToggle(p1, "Auto Switch", true, nil, 5, false)
local getSkipDowned = addToggle(p1, "Skip Downed", true, nil, 6, true)
local getAlwaysOn = addToggle(p1, "Always On", false, nil, 7, true)

addSeparator(p1, 8)
addLabel(p1, "PARAMETERS", 9)
local getMode = addCycleButton(p1, "Mode", {"Right Mouse Click", "Nearest Cursor", "Toggle Q"}, "Right Mouse Click", function(v) Settings.Mode = v:gsub(" ", "") end, 10)
local getTargetPart = addCycleButton(p1, "Target Part", {"Head", "HumanoidRootPart", "UpperTorso"}, "Head", function(v) Settings.TargetPart = v end, 11)
local getSmoothness = addSlider(p1, "Smoothness", 0.05, 1.0, 0.450, nil, 12)
local getPrediction = addSlider(p1, "Prediction", 0.0, 0.5, 0.100, nil, 13)
local getAimShake = addSlider(p1, "Aim Shake", 0, 5, 0, nil, 14)

addSeparator(p1, 15)
addLabel(p1, "TRIGGER", 16)
local getTriggerBot = addToggle(p1, "Trigger Bot", false, nil, 17, true)

addSeparator(p1, 18)
addLabel(p1, "HITBOX", 19)
local getHitboxExpand = addToggle(p1, "Hitbox Expand", false, nil, 20, false)
local getHitboxSize = addSlider(p1, "Hitbox Size", 1.0, 3.0, 1.3, nil, 21)

addSeparator(p1, 22)
addLabel(p1, "FOV", 23)
local getFOVVisible = addToggle(p1, "FOV Circle", true, nil, 24, true)
local getFOVRadius = addSlider(p1, "FOV Radius", 20, 500, 150, nil, 25)
local getFOVUseTheme = addToggle(p1, "FOV Follow Theme", true, function(v) Settings.FOVUseTheme = v end, 26, false)

-- PAGE 2: ESP
local p2 = tabPages["ESP"]
addLabel(p2, "HIGHLIGHT", 1)
local getESP = addToggle(p2, "ESP Enabled", true, nil, 2, true)
local getHighlightColor = addCycleButton(p2, "Color", {"Red","Cyan","Green","Yellow","Purple","White","Orange","Pink","Gold"}, "Cyan", function(v)
    local colors = {Red=Color3.fromRGB(255,80,80), Cyan=Color3.fromRGB(100,180,220), Green=Color3.fromRGB(100,220,140),
        Yellow=Color3.fromRGB(240,220,100), Purple=Color3.fromRGB(180,120,240), White=Color3.fromRGB(255,255,255),
        Orange=Color3.fromRGB(240,160,80), Pink=Color3.fromRGB(240,140,180), Gold=Color3.fromRGB(230,200,100)}
    Settings.HighlightColor = colors[v] or Color3.fromRGB(100,180,220)
end, 3)
local getFillTransparency = addSlider(p2, "Fill Transparency", 0, 1, 0.35, nil, 4)

addSeparator(p2, 5)
addLabel(p2, "INFO OVERLAY", 6)
local getESPNames = addToggle(p2, "Name Tags", true, nil, 7, true)
local getESPHealth = addToggle(p2, "Health Display", true, nil, 8, false)
local getESPDistance = addToggle(p2, "Distance Display", true, nil, 9, false)

addSeparator(p2, 10)
addLabel(p2, "TRACERS", 11)
local getESPTracers = addToggle(p2, "Tracers", true, nil, 12, true)
local getTracerOrigin = addCycleButton(p2, "Tracer Origin", {"Bottom","Center","Mouse"}, "Bottom", nil, 13)
local getESPBoxes = addToggle(p2, "Box ESP", false, nil, 14, true)

-- PAGE 3: MOVEMENT
local p3 = tabPages["MOVEMENT"]
addLabel(p3, "SPEED", 1)
local getSpeed = addToggle(p3, "Speed Hack", false, nil, 2, true)
local getSpeedValue = addSlider(p3, "Walk Speed", 16, 500, 16, nil, 3)

addSeparator(p3, 4)
addLabel(p3, "JUMP", 5)
local getJumpPower = addToggle(p3, "Jump Power", false, nil, 6, true)
local getJumpValue = addSlider(p3, "Jump Value", 50, 500, 50, nil, 7)
local getInfJump = addToggle(p3, "Infinite Jump", false, nil, 8, true)

addSeparator(p3, 9)
addLabel(p3, "FLIGHT", 10)
local getFly = addToggle(p3, "Fly", false, nil, 11, true)
local getFlySpeed = addSlider(p3, "Fly Speed", 10, 500, 50, nil, 12)
local getNoclipFly = addToggle(p3, "Noclip Fly", false, nil, 13, true)

addSeparator(p3, 14)
addLabel(p3, "NOCLIP", 15)
local getNoclip = addToggle(p3, "Noclip", false, nil, 16, true)

addSeparator(p3, 17)
addLabel(p3, "TELEPORT", 18)
addButton(p3, "Teleport to Mouse", function()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            showToast("Teleport", "Moved to mouse position", "success")
        end
    end
end, 19, CurrentTheme.Button)

addButton(p3, "Teleport to Target", function()
    local target = Settings.CurrentTarget
    if target and target.Character then
        local thrp = target.Character:FindFirstChild("HumanoidRootPart")
        local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if thrp and lhrp then
            lhrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 3)
            showToast("Teleport", "Moved to " .. target.DisplayName, "success")
        end
    else
        showToast("Teleport", "No target selected", "error")
    end
end, 20, CurrentTheme.Button)

-- PAGE 4: PLAYERS
local p4 = tabPages["PLAYERS"]

local SelectCountLabel = Instance.new("TextLabel")
SelectCountLabel.Size = UDim2.new(1,-8,0,20)
SelectCountLabel.BackgroundTransparency = 1
SelectCountLabel.Text = "0 players selected"
SelectCountLabel.TextColor3 = CurrentTheme.SubText
SelectCountLabel.TextSize = 10
SelectCountLabel.Font = Enum.Font.Gotham
SelectCountLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectCountLabel.LayoutOrder = 1
SelectCountLabel.ZIndex = 3
SelectCountLabel.Parent = p4
table.insert(uiElements, {element=SelectCountLabel, type="subLabel"})

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1,-8,0,28)
btnRow.BackgroundTransparency = 1
btnRow.LayoutOrder = 2
btnRow.ZIndex = 3
btnRow.Parent = p4

local SelectAllBtn = Instance.new("TextButton")
SelectAllBtn.Size = UDim2.new(0.48,0,1,0)
SelectAllBtn.BackgroundColor3 = CurrentTheme.Button
SelectAllBtn.BackgroundTransparency = 0.3
SelectAllBtn.BorderSizePixel = 0
SelectAllBtn.Text = "Select All"
SelectAllBtn.TextColor3 = CurrentTheme.Text
SelectAllBtn.TextSize = 10
SelectAllBtn.Font = Enum.Font.GothamSemibold
SelectAllBtn.AutoButtonColor = false
SelectAllBtn.ZIndex = 3
SelectAllBtn.Parent = btnRow
Instance.new("UICorner", SelectAllBtn).CornerRadius = UDim.new(0,4)
SelectAllBtn.MouseEnter:Connect(function() tween(SelectAllBtn, 0.15, {BackgroundTransparency = 0.15}) end)
SelectAllBtn.MouseLeave:Connect(function() tween(SelectAllBtn, 0.15, {BackgroundTransparency = 0.3}) end)

local ClearAllBtn = Instance.new("TextButton")
ClearAllBtn.Size = UDim2.new(0.48,0,1,0)
ClearAllBtn.Position = UDim2.new(0.52,0,0,0)
ClearAllBtn.BackgroundColor3 = CurrentTheme.Button
ClearAllBtn.BackgroundTransparency = 0.3
ClearAllBtn.BorderSizePixel = 0
ClearAllBtn.Text = "Clear"
ClearAllBtn.TextColor3 = CurrentTheme.Text
ClearAllBtn.TextSize = 10
ClearAllBtn.Font = Enum.Font.GothamSemibold
ClearAllBtn.AutoButtonColor = false
ClearAllBtn.ZIndex = 3
ClearAllBtn.Parent = btnRow
Instance.new("UICorner", ClearAllBtn).CornerRadius = UDim.new(0,4)
ClearAllBtn.MouseEnter:Connect(function() tween(ClearAllBtn, 0.15, {BackgroundTransparency = 0.15}) end)
ClearAllBtn.MouseLeave:Connect(function() tween(ClearAllBtn, 0.15, {BackgroundTransparency = 0.3}) end)

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1,-8,0,32)
SearchBox.BackgroundColor3 = CurrentTheme.Button
SearchBox.BackgroundTransparency = 0.3
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "Search players..."
SearchBox.PlaceholderColor3 = CurrentTheme.SubText
SearchBox.Text = ""
SearchBox.TextColor3 = CurrentTheme.Text
SearchBox.TextSize = 11
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false
SearchBox.LayoutOrder = 3
SearchBox.ZIndex = 3
SearchBox.Parent = p4
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,4)
table.insert(uiElements, {element=SearchBox, type="bg"})

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1,-8,0,180)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.BorderSizePixel = 0
PlayerScroll.ScrollBarThickness = 3
PlayerScroll.ScrollBarImageColor3 = CurrentTheme.Button
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
addLabel(p4, "ACTIONS", 6)

addButton(p4, "Goto First Selected", function()
    for _, plr in pairs(Settings.SelectedPlayers) do
        if plr and plr.Character then
            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if thrp and lhrp then
                lhrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 3)
                showToast("Goto", "Moved to " .. plr.DisplayName, "success")
            end
            break
        end
    end
end, 7, CurrentTheme.Button)

addButton(p4, "Bring First Selected", function()
    for _, plr in pairs(Settings.SelectedPlayers) do
        if plr and plr.Character then
            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if thrp and lhrp then
                thrp.CFrame = lhrp.CFrame * CFrame.new(0, 0, 5)
                showToast("Bring", "Brought " .. plr.DisplayName, "success")
            end
            break
        end
    end
end, 8, CurrentTheme.Button)

local getFollowPlayer = addToggle(p4, "Follow First Selected", false, function(state)
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

addButton(p4, "Kill First Selected", function()
    for _, plr in pairs(Settings.SelectedPlayers) do
        if plr and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function() hum.Health = 0 end)
                Settings.Kills = Settings.Kills + 1
                showToast("Target Eliminated", plr.DisplayName, "success")
            end
            break
        end
    end
end, 10, Color3.fromRGB(100, 30, 35))

-- PAGE 5: WORLD
local p5 = tabPages["WORLD"]
addLabel(p5, "LIGHTING", 1)
local getFullbright = addToggle(p5, "Fullbright", false, nil, 2, true)
local getNoFog = addToggle(p5, "No Fog", false, nil, 3, true)
local getRemoveShadows = addToggle(p5, "Remove Shadows", false, nil, 4, true)
local getTimeChanger = addToggle(p5, "Time Changer", false, nil, 5, false)
local getTimeValue = addSlider(p5, "Time (0-24)", 0, 24, 12, nil, 6)

addSeparator(p5, 7)
addLabel(p5, "SERVER", 8)
addButton(p5, "Server Rejoin", function()
    showToast("Server", "Reconnecting...", "info")
    task.wait(0.5)
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end, 9, CurrentTheme.Button)

addButton(p5, "Server Hop", function()
    showToast("Server", "Searching for new server...", "info")
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
end, 10, CurrentTheme.Button)

addSeparator(p5, 11)
addLabel(p5, "SERVER INFO", 12)
local worldInfoLabel = Instance.new("TextLabel")
worldInfoLabel.Size = UDim2.new(1,-8,0,80)
worldInfoLabel.BackgroundColor3 = CurrentTheme.Button
worldInfoLabel.BackgroundTransparency = 0.4
worldInfoLabel.BorderSizePixel = 0
worldInfoLabel.Text = "  Game ID      : " .. game.PlaceId .. "\n  Player Count : " .. #Players:GetPlayers() .. "\n  Server ID    : " .. game.JobId:sub(1,8) .. "\n  Ping         : --"
worldInfoLabel.TextColor3 = CurrentTheme.SubText
worldInfoLabel.TextSize = 10
worldInfoLabel.Font = Enum.Font.Code
worldInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
worldInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
worldInfoLabel.LayoutOrder = 13
worldInfoLabel.ZIndex = 3
worldInfoLabel.Parent = p5
Instance.new("UICorner", worldInfoLabel).CornerRadius = UDim.new(0, 4)
table.insert(uiElements, {element=worldInfoLabel, type="bg"})
local wInfoPad = Instance.new("UIPadding", worldInfoLabel)
wInfoPad.PaddingLeft = UDim.new(0, 10)
wInfoPad.PaddingTop = UDim.new(0, 10)

-- PAGE 6: CHARACTER
local p6 = tabPages["CHARACTER"]
addLabel(p6, "STATE", 1)
local getGodMode = addToggle(p6, "God Mode", false, nil, 2, true)
local getAntiFling = addToggle(p6, "Anti Fling", false, nil, 3, true)
local getCharacterSize = addToggle(p6, "Character Size", false, nil, 4, false)
local getSizeValue = addSlider(p6, "Size Scale", 0.5, 5.0, 1.0, nil, 5)

addSeparator(p6, 6)
addLabel(p6, "DAMAGE AURA", 7)
local getDamageAura = addToggle(p6, "Damage Aura", false, nil, 8, true)
local getDamageRange = addSlider(p6, "Aura Range", 3, 30, 10, nil, 9)
local getDamageAmount = addSlider(p6, "Damage Amount", 1, 50, 5, nil, 10)

addSeparator(p6, 11)
addLabel(p6, "ACTIONS", 12)
addButton(p6, "Respawn", function()
    pcall(function() LocalPlayer.Character:BreakJoints() end)
    showToast("Character", "Respawning...", "info")
end, 13, CurrentTheme.Button)

addButton(p6, "Full Heal", function()
    pcall(function()
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end)
    showToast("Character", "Health restored", "success")
end, 14, CurrentTheme.Button)

-- PAGE 7: SETTINGS
local p7 = tabPages["SETTINGS"]
addLabel(p7, "THEME", 1)
local getTheme = addCycleButton(p7, "Theme", {"Obsidian","Cobalt","Noir","Crimson","Emerald","Violet","Slate"}, "Obsidian", function(v)
    if Themes[v] then
        CurrentTheme = Themes[v]
        
        MainFrame.BackgroundColor3 = CurrentTheme.Bg
        mainStroke.Color = CurrentTheme.Button
        topAccent.BackgroundColor3 = CurrentTheme.Primary
        dotIndicator.BackgroundColor3 = CurrentTheme.Primary
        tl.TextColor3 = CurrentTheme.Text
        cl.TextColor3 = CurrentTheme.SubText
        versionLbl.TextColor3 = CurrentTheme.SubText
        Sidebar.BackgroundColor3 = CurrentTheme.Panel
        sideStroke.Color = CurrentTheme.Button
        profileFrame.BackgroundColor3 = CurrentTheme.Button
        avatarCircle.BackgroundColor3 = CurrentTheme.Button
        avatarRing.Color = CurrentTheme.Primary
        profileName.TextColor3 = CurrentTheme.Text
        profileStatus.TextColor3 = Color3.fromRGB(80, 200, 130)
        
        mainGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(CurrentTheme.Bg.R*255 + 4, CurrentTheme.Bg.G*255 + 4, CurrentTheme.Bg.B*255 + 4)),
            ColorSequenceKeypoint.new(1, CurrentTheme.Bg),
        })
        
        for _, data in ipairs(uiElements) do
            if data.element and data.element.Parent then
                if data.type == "toggle" then
                    data.element.TextColor3 = CurrentTheme.Text
                elseif data.type == "fill" then
                    data.element.BackgroundColor3 = CurrentTheme.Accent
                elseif data.type == "knob" then
                    data.element.BackgroundColor3 = Color3.fromRGB(255,255,255)
                elseif data.type == "bg" then
                    data.element.BackgroundColor3 = CurrentTheme.Button
                elseif data.type == "keybindBg" then
                    data.element.BackgroundColor3 = CurrentTheme.Button
                elseif data.type == "separatorLine" then
                    data.element.BackgroundColor3 = CurrentTheme.Button
                elseif data.type == "sectionLabel" then
                    data.element.TextColor3 = CurrentTheme.SubText
                elseif data.type == "subLabel" then
                    data.element.TextColor3 = CurrentTheme.SubText
                elseif data.type == "stroke" then
                    data.element.Color = CurrentTheme.Button
                end
            end
        end
        
        for n,b in pairs(tabButtons) do 
            local isActive = (n == activeTab)
            b.BackgroundColor3 = isActive and CurrentTheme.Button or Color3.fromRGB(0,0,0)
            local ind = b:FindFirstChild("Indicator")
            if ind then ind.BackgroundColor3 = CurrentTheme.Primary end
            local nameLbl = b:FindFirstChildOfClass("TextLabel")
            if nameLbl then nameLbl.TextColor3 = isActive and CurrentTheme.Text or CurrentTheme.SubText end
        end
        
        for _, page in pairs(tabPages) do
            page.ScrollBarImageColor3 = CurrentTheme.Button
        end
        PlayerScroll.ScrollBarImageColor3 = CurrentTheme.Button
        SideScroll.ScrollBarImageColor3 = CurrentTheme.Button
        
        if fovCircle and Settings.FOVUseTheme then
            fovCircle.Color = CurrentTheme.Accent
        end
        
        Watermark.BackgroundColor3 = CurrentTheme.Panel
        wmStroke.Color = CurrentTheme.Button
        wmTitle.TextColor3 = CurrentTheme.Text
        wmInfo.TextColor3 = CurrentTheme.SubText
        
        showToast("Theme", CurrentTheme.Name .. " applied", "info")
    end
end, 2)

addSeparator(p7, 3)
addLabel(p7, "INTERFACE", 4)
local getGuiTransparency = addSlider(p7, "Gui Transparency", 0, 0.9, 0, function(v)
    MainFrame.BackgroundTransparency = v
end, 5)

addSeparator(p7, 6)
addLabel(p7, "OVERLAY", 7)
local getWatermark = addToggle(p7, "Watermark", true, nil, 8, false)
local getFPSDisplay = addToggle(p7, "FPS Display", true, nil, 9, false)
local getPingDisplay = addToggle(p7, "Ping Display", true, nil, 10, false)

addSeparator(p7, 11)
addLabel(p7, "CONFIGURATION", 12)
addButton(p7, "Save Config", function()
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
    showToast("Config", "Settings saved", "success")
end, 13, CurrentTheme.Button)

addButton(p7, "Load Config", function()
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
    showToast("Config", "Settings loaded", "success")
end, 14, CurrentTheme.Button)

addSeparator(p7, 15)
addLabel(p7, "SESSION", 16)
local statLabel = Instance.new("TextLabel")
statLabel.Size = UDim2.new(1,-8,0,80)
statLabel.BackgroundColor3 = CurrentTheme.Button
statLabel.BackgroundTransparency = 0.4
statLabel.BorderSizePixel = 0
statLabel.Text = "  Status     : ACTIVE\n  Kills      : 0\n  Session    : 0s\n  User       : " .. LocalPlayer.Name
statLabel.TextColor3 = CurrentTheme.SubText
statLabel.TextSize = 10
statLabel.Font = Enum.Font.Code
statLabel.TextXAlignment = Enum.TextXAlignment.Left
statLabel.TextYAlignment = Enum.TextYAlignment.Top
statLabel.LayoutOrder = 17
statLabel.ZIndex = 3
statLabel.Parent = p7
Instance.new("UICorner", statLabel).CornerRadius = UDim.new(0, 4)
table.insert(uiElements, {element=statLabel, type="bg"})
local statPad = Instance.new("UIPadding", statLabel)
statPad.PaddingLeft = UDim.new(0, 10)
statPad.PaddingTop = UDim.new(0, 10)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local sessionTime = math.floor(tick() - Settings.SessionStart)
            statLabel.Text = "  Status     : ACTIVE\n  Kills      : " .. Settings.Kills .. "\n  Session    : " .. sessionTime .. "s\n  User       : " .. LocalPlayer.Name
        end)
    end
end)

-- =============================================
-- WATERMARK (Clean)
-- =============================================
local Watermark = Instance.new("Frame")
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0, 220, 0, 38)
Watermark.Position = UDim2.new(0, 15, 0, 15)
Watermark.BackgroundColor3 = CurrentTheme.Panel
Watermark.BackgroundTransparency = 0.05
Watermark.BorderSizePixel = 0
Watermark.Visible = true
Watermark.ZIndex = 500
Watermark.Parent = ScreenGui
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 4)
local wmStroke = Instance.new("UIStroke", Watermark)
wmStroke.Color = CurrentTheme.Button
wmStroke.Thickness = 1
makeDraggable(Watermark, Watermark)

-- Ust accent cizgisi
local wmAccent = Instance.new("Frame")
wmAccent.Size = UDim2.new(0, 30, 0, 1)
wmAccent.Position = UDim2.new(0, 12, 0, 1)
wmAccent.BackgroundColor3 = CurrentTheme.Primary
wmAccent.BorderSizePixel = 0
wmAccent.ZIndex = 502
wmAccent.Parent = Watermark

local wmDot = Instance.new("Frame")
wmDot.Size = UDim2.new(0, 5, 0, 5)
wmDot.Position = UDim2.new(0, 12, 0.5, -2)
wmDot.BackgroundColor3 = CurrentTheme.Primary
wmDot.BorderSizePixel = 0
wmDot.ZIndex = 502
wmDot.Parent = Watermark
Instance.new("UICorner", wmDot).CornerRadius = UDim.new(1, 0)

local wmTitle = Instance.new("TextLabel")
wmTitle.Size = UDim2.new(1, 0, 0, 18)
wmTitle.Position = UDim2.new(0, 24, 0, 6)
wmTitle.BackgroundTransparency = 1
wmTitle.Text = "DHL VIP"
wmTitle.TextColor3 = CurrentTheme.Text
wmTitle.TextSize = 11
wmTitle.Font = Enum.Font.GothamBold
wmTitle.TextXAlignment = Enum.TextXAlignment.Left
wmTitle.ZIndex = 501
wmTitle.Parent = Watermark

local wmInfo = Instance.new("TextLabel")
wmInfo.Size = UDim2.new(1, 0, 0, 12)
wmInfo.Position = UDim2.new(0, 24, 0, 22)
wmInfo.BackgroundTransparency = 1
wmInfo.Text = "60 FPS  |  0 MS"
wmInfo.TextColor3 = CurrentTheme.SubText
wmInfo.TextSize = 9
wmInfo.Font = Enum.Font.Code
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
            wmInfo.Text = fpsStr .. "  |  " .. pingStr
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
    SelectCountLabel.Text = c .. " players selected"
end

local function isSelected(player) return Settings.SelectedPlayers[player.Name] ~= nil end

local function toggleSelect(player, btn, dot)
    if isSelected(player) then
        Settings.SelectedPlayers[player.Name] = nil
        tween(btn, 0.2, {BackgroundColor3 = CurrentTheme.Button, BackgroundTransparency = 0.3})
        btn.TextColor3 = CurrentTheme.SubText
        if dot then tween(dot, 0.2, {BackgroundColor3 = CurrentTheme.SubText}) end
    else
        Settings.SelectedPlayers[player.Name] = player
        tween(btn, 0.2, {BackgroundColor3 = CurrentTheme.Button, BackgroundTransparency = 0.15})
        btn.TextColor3 = CurrentTheme.Text
        if dot then tween(dot, 0.2, {BackgroundColor3 = Color3.fromRGB(80,200,130)}) end
    end
    updateSelectCount()
end

local function createPlayerButton(player)
    if player == LocalPlayer then return end
    local sel = isSelected(player)
    local btn = Instance.new("TextButton")
    btn.Name = "PLR_"..player.Name
    btn.Size = UDim2.new(1,-4,0,32)
    btn.BackgroundColor3 = CurrentTheme.Button
    btn.BackgroundTransparency = sel and 0.15 or 0.3
    btn.BorderSizePixel = 0
    btn.Text = player.DisplayName
    btn.TextColor3 = sel and CurrentTheme.Text or CurrentTheme.SubText
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    btn.Parent = PlayerScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    
    local textPad = Instance.new("UIPadding", btn)
    textPad.PaddingLeft = UDim.new(0, 24)
    
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.Position = UDim2.new(0, 10, 0.5, -3)
    dot.BackgroundColor3 = sel and Color3.fromRGB(80,200,130) or CurrentTheme.SubText
    dot.BorderSizePixel = 0
    dot.ZIndex = 4
    dot.Parent = btn
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    btn.MouseButton1Click:Connect(function() toggleSelect(player, btn, dot) end)
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

SelectAllBtn.MouseButton1Click:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then Settings.SelectedPlayers[p.Name] = p end end
    refreshPlayerList()
end)
ClearAllBtn.MouseButton1Click:Connect(function()
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
    fovCircle.Thickness = 1
    fovCircle.NumSides = 64
    fovCircle.Radius = 150
    fovCircle.Filled = false
    fovCircle.Visible = true
    fovCircle.Transparency = 0.7
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
    hl.OutlineTransparency = 0.3
    hl.Adornee = player.Character
    hl.Parent = player.Character
    highlightObjects[player.Name] = hl

    if usingDrawing and not espDrawings[player.Name] then
        local esp = {}
        esp.name = Drawing.new("Text"); esp.name.Color = Settings.HighlightColor; esp.name.Size = 13
        esp.name.Center = true; esp.name.Outline = true; esp.name.OutlineColor = Color3.fromRGB(0,0,0)
        esp.name.Visible = false; esp.name.Font = 2
        esp.distance = Drawing.new("Text"); esp.distance.Color = Color3.fromRGB(200,200,200); esp.distance.Size = 11
        esp.distance.Center = true; esp.distance.Outline = true; esp.distance.OutlineColor = Color3.fromRGB(0,0,0)
        esp.distance.Visible = false; esp.distance.Font = 2
        esp.healthText = Drawing.new("Text"); esp.healthText.Color = Color3.fromRGB(0,255,0); esp.healthText.Size = 11
        esp.healthText.Center = true; esp.healthText.Outline = true; esp.healthText.OutlineColor = Color3.fromRGB(0,0,0)
        esp.healthText.Visible = false; esp.healthText.Font = 2
        esp.tracer = Drawing.new("Line"); esp.tracer.Color = Settings.HighlightColor
        esp.tracer.Thickness = 1; esp.tracer.Visible = false; esp.tracer.Transparency = 0.6
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
                                esp.name.Color = Settings.HighlightColor; esp.name.Visible = true; yOff = yOff - 15
                            else esp.name.Visible = false end
                            if getESPHealth() then
                                esp.healthText.Text = hp .. "%"; esp.healthText.Position = Vector2.new(screenPos.X, screenPos.Y + yOff)
                                esp.healthText.Color = Color3.fromRGB(255*(1-hp/100), 255*(hp/100), 0)
                                esp.healthText.Visible = true; yOff = yOff - 13
                            else esp.healthText.Visible = false end
                            if getESPDistance() then
                                esp.distance.Text = dist .. "m"; esp.distance.Position = Vector2.new(screenPos.X, screenPos.Y + yOff)
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
                                    local w = 30
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
            activeKeybindBtn.Text = "—"
            activeKeybindBtn.TextColor3 = CurrentTheme.SubText
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
            tween(MainFrame, 0.4, {Size = UDim2.new(0, 700, 0, 480), Position = UDim2.new(0.5, -350, 0.5, -240)}, Enum.EasingStyle.Back)
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

print("[DHL VIP] Clean Pro Edition yuklendi!")

-- Splash sonrasi GUI ac
task.spawn(function()
    task.wait(2.8)
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    tween(MainFrame, 0.55, {
        Size = UDim2.new(0, 700, 0, 480),
        Position = UDim2.new(0.5, -350, 0.5, -240),
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    task.wait(0.7)
    showToast("DHL VIP", "Connection established", "success")
    task.wait(0.6)
    showToast("Interface", "Press Right Shift to toggle", "info")
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DHL VIP",
        Text = "Professional Edition loaded",
        Duration = 5
    })
end)
