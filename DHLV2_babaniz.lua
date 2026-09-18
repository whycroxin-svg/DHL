--[[
    SOU HUB - TOUCHLINE WINTER EDITION
    Winter GUI + Touchline ozellikleri
    Kar yagisi + Splash + 8 sekmeli GUI
]]

print("[SOU HUB] Touchline Winter Edition yukleniyor...")

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
-- THEMES
-- =============================================
local Themes = {
    Winter   = {Name="Winter",   Category="Special", Primary=Color3.fromRGB(140,168,200), Accent=Color3.fromRGB(232,244,255), Bg=Color3.fromRGB(10,18,32),  Panel=Color3.fromRGB(16,28,46),  Button=Color3.fromRGB(26,42,66),  Text=Color3.fromRGB(220,235,250), SubText=Color3.fromRGB(140,165,195)},
    Obsidian = {Name="Obsidian", Category="Classic", Primary=Color3.fromRGB(100,110,130), Accent=Color3.fromRGB(160,180,210), Bg=Color3.fromRGB(12,13,16),  Panel=Color3.fromRGB(18,19,23),  Button=Color3.fromRGB(26,28,34),  Text=Color3.fromRGB(200,210,220), SubText=Color3.fromRGB(120,130,140)},
    Cobalt   = {Name="Cobalt",   Category="Classic", Primary=Color3.fromRGB(50,100,180),  Accent=Color3.fromRGB(100,160,240), Bg=Color3.fromRGB(10,12,18),  Panel=Color3.fromRGB(16,20,28),  Button=Color3.fromRGB(24,30,42),  Text=Color3.fromRGB(200,215,235), SubText=Color3.fromRGB(110,130,160)},
    Noir     = {Name="Noir",     Category="Classic", Primary=Color3.fromRGB(80,80,80),    Accent=Color3.fromRGB(200,200,200), Bg=Color3.fromRGB(8,8,8),     Panel=Color3.fromRGB(14,14,14),  Button=Color3.fromRGB(22,22,22),  Text=Color3.fromRGB(230,230,230), SubText=Color3.fromRGB(120,120,120)},
    Crimson  = {Name="Crimson",  Category="Classic", Primary=Color3.fromRGB(140,30,50),   Accent=Color3.fromRGB(230,90,110),  Bg=Color3.fromRGB(14,8,12),   Panel=Color3.fromRGB(22,14,18),  Button=Color3.fromRGB(34,20,26),  Text=Color3.fromRGB(230,200,205), SubText=Color3.fromRGB(150,110,120)},
    Emerald  = {Name="Emerald",  Category="Classic", Primary=Color3.fromRGB(40,140,100),  Accent=Color3.fromRGB(90,220,170),  Bg=Color3.fromRGB(8,14,12),   Panel=Color3.fromRGB(14,22,18),  Button=Color3.fromRGB(22,34,28),  Text=Color3.fromRGB(200,230,215), SubText=Color3.fromRGB(110,150,130)},
    Violet   = {Name="Violet",   Category="Classic", Primary=Color3.fromRGB(110,60,180),  Accent=Color3.fromRGB(180,120,255), Bg=Color3.fromRGB(12,10,20),  Panel=Color3.fromRGB(20,16,32),  Button=Color3.fromRGB(30,24,48),  Text=Color3.fromRGB(220,210,240), SubText=Color3.fromRGB(140,120,170)},
    Slate    = {Name="Slate",    Category="Classic", Primary=Color3.fromRGB(70,90,110),   Accent=Color3.fromRGB(130,170,200), Bg=Color3.fromRGB(10,13,18),  Panel=Color3.fromRGB(16,20,28),  Button=Color3.fromRGB(24,30,40),  Text=Color3.fromRGB(200,215,230), SubText=Color3.fromRGB(110,130,150)},
    Halloween= {Name="Halloween",Category="Special", Primary=Color3.fromRGB(255,107,26),  Accent=Color3.fromRGB(255,165,0),   Bg=Color3.fromRGB(13,6,5),    Panel=Color3.fromRGB(26,14,8),   Button=Color3.fromRGB(42,24,16),  Text=Color3.fromRGB(255,220,190), SubText=Color3.fromRGB(200,140,90)},
    Desert   = {Name="Desert",   Category="Special", Primary=Color3.fromRGB(200,148,74),  Accent=Color3.fromRGB(244,217,160), Bg=Color3.fromRGB(26,15,10),  Panel=Color3.fromRGB(42,26,15),  Button=Color3.fromRGB(58,40,24),  Text=Color3.fromRGB(240,220,190), SubText=Color3.fromRGB(180,140,90)},
    Ocean    = {Name="Ocean",    Category="Special", Primary=Color3.fromRGB(30,144,255),  Accent=Color3.fromRGB(126,200,227), Bg=Color3.fromRGB(4,18,32),   Panel=Color3.fromRGB(8,32,52),   Button=Color3.fromRGB(14,46,72),  Text=Color3.fromRGB(200,225,245), SubText=Color3.fromRGB(120,170,200)},
    Sakura   = {Name="Sakura",   Category="Special", Primary=Color3.fromRGB(245,165,184), Accent=Color3.fromRGB(255,209,220), Bg=Color3.fromRGB(26,13,18),  Panel=Color3.fromRGB(42,21,32),  Button=Color3.fromRGB(58,31,46),  Text=Color3.fromRGB(255,225,235), SubText=Color3.fromRGB(210,160,180)},
    Cyberpunk= {Name="Cyberpunk",Category="Special", Primary=Color3.fromRGB(255,0,170),   Accent=Color3.fromRGB(0,255,255),   Bg=Color3.fromRGB(10,0,20),   Panel=Color3.fromRGB(21,0,37),   Button=Color3.fromRGB(31,0,53),   Text=Color3.fromRGB(240,220,255), SubText=Color3.fromRGB(180,140,220)},
    Christmas= {Name="Christmas",Category="Special", Primary=Color3.fromRGB(212,36,38),   Accent=Color3.fromRGB(15,139,60),   Bg=Color3.fromRGB(10,26,14),  Panel=Color3.fromRGB(20,42,26),  Button=Color3.fromRGB(30,58,36),  Text=Color3.fromRGB(230,240,230), SubText=Color3.fromRGB(160,190,160)},
    Sunset   = {Name="Sunset",   Category="Special", Primary=Color3.fromRGB(255,123,84),  Accent=Color3.fromRGB(255,178,107), Bg=Color3.fromRGB(26,15,26),  Panel=Color3.fromRGB(42,22,32),  Button=Color3.fromRGB(58,32,48),  Text=Color3.fromRGB(255,230,220), SubText=Color3.fromRGB(210,160,150)},
}
local CurrentTheme = Themes.Winter

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
    Reach = false, ReachValue = 30,
    BallHitbox = false, BallSize = 2.0,
    GoalAimbot = false, GoalAimStrength = 0.5,
    AutoDive = false,
    Fullbright = false,
    
    BallESP = false,
    BallESPColor = Color3.fromRGB(255, 220, 60),
    
    BallHitboxESP = false,
    BallHitboxESPColor = Color3.fromRGB(120, 255, 140),
    
    HitboxESP = false,
    HitboxESPColor = Color3.fromRGB(120, 220, 160),
    
    Watermark = true,
    FPSDisplay = true,
    PingDisplay = true,
    GuiTransparency = 250,
    ParticlesEnabled = true,
}

-- =============================================
-- TOP & KALE BULMA
-- =============================================
local function findBall()
    local footballs = workspace:FindFirstChild("Footballs")
    if footballs then
        local ball = footballs:FindFirstChild("Ball")
        if ball and ball:IsA("BasePart") then return ball end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Shape == Enum.PartType.Ball then
            if obj.Size.X > 0.5 and obj.Size.X < 30 then return obj end
        end
    end
    return nil
end

local function findGoal()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("goal") or n:find("kale") then return obj end
        end
    end
    return nil
end

-- =============================================
-- CLEANUP
-- =============================================
for _, loc in ipairs({game:GetService("CoreGui"), LocalPlayer:FindFirstChild("PlayerGui")}) do
    pcall(function() 
        local o = loc:FindFirstChild("SOUHUB_Winter"); if o then o:Destroy() end
        local o2 = loc:FindFirstChild("SOUHUB_Snow"); if o2 then o2:Destroy() end
    end)
end
pcall(function() 
    if gethui then 
        local o = gethui():FindFirstChild("SOUHUB_Winter"); if o then o:Destroy() end
        local o2 = gethui():FindFirstChild("SOUHUB_Snow"); if o2 then o2:Destroy() end
    end 
end)

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
ScreenGui.Name = "SOUHUB_Winter"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
if guiParent:IsA("ScreenGui") then
    ScreenGui = guiParent; ScreenGui.Name = "SOUHUB_Winter"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 999
else ScreenGui.Parent = guiParent end

-- =============================================
-- KAR YAGISI
-- =============================================
local snowGui = Instance.new("ScreenGui")
snowGui.Name = "SOUHUB_Snow"
snowGui.ResetOnSpawn = false
snowGui.DisplayOrder = 1
snowGui.IgnoreGuiInset = true
snowGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
snowGui.Parent = guiParent

local snowContainer = Instance.new("Frame")
snowContainer.Name = "SnowContainer"
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
    tween(sf, dur, {
        Position = UDim2.new(sf.Position.X.Scale + drift, 0, 1.1, 0),
        Rotation = sf.Rotation + math.random(-180, 180)
    }, Enum.EasingStyle.Linear)
    task.delay(dur, function() if sf and sf.Parent then sf:Destroy() end end)
end

task.spawn(function()
    while snowContainer.Parent do
        createSnowflake()
        task.wait(math.random(5, 15) / 100)
    end
end)

-- =============================================
-- SPLASH SCREEN
-- =============================================
local splashGui = Instance.new("ScreenGui")
splashGui.Name = "SOUHUB_Splash"
splashGui.ResetOnSpawn = false
splashGui.DisplayOrder = 10000
splashGui.IgnoreGuiInset = true
splashGui.Parent = guiParent

local splashFrame = Instance.new("Frame")
splashFrame.Size = UDim2.new(1, 0, 1, 0)
splashFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
splashFrame.BorderSizePixel = 0
splashFrame.ZIndex = 1
splashFrame.Parent = splashGui

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

local splashTitle = Instance.new("TextLabel")
splashTitle.Size = UDim2.new(1, 0, 0, 40)
splashTitle.Position = UDim2.new(0, 0, 0.5, -20)
splashTitle.BackgroundTransparency = 1
splashTitle.Text = "S O U"
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
splashSub.Text = "T O U C H L I N E   E D I T I O N"
splashSub.TextColor3 = CurrentTheme.SubText
splashSub.TextSize = 9
splashSub.Font = Enum.Font.GothamSemibold
splashSub.TextTransparency = 1
splashSub.ZIndex = 3
splashSub.Parent = splashFrame

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

task.spawn(function()
    task.wait(0.15)
    tween(lineTop, 0.5, {Size = UDim2.new(0, 300, 0, 1)}, Enum.EasingStyle.Quart)
    tween(lineBottom, 0.5, {Size = UDim2.new(0, 300, 0, 1)}, Enum.EasingStyle.Quart)
    task.wait(0.3)
    tween(splashTitle, 0.4, {TextTransparency = 0})
    task.wait(0.2)
    tween(splashSub, 0.4, {TextTransparency = 0})
    task.wait(0.25)
    tween(progressBg, 0.2, {BackgroundTransparency = 0})
    tween(progressText, 0.3, {TextTransparency = 0})
    
    local messages = {"Initializing...", "Loading modules...", "Injecting...", "Ready"}
    for i, msg in ipairs(messages) do
        progressText.Text = msg
        tween(progressFill, 0.25, {Size = UDim2.new(i / #messages, 0, 1, 0)}, Enum.EasingStyle.Quad)
        task.wait(0.28)
    end
    
    task.wait(0.2)
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
-- TOAST
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
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 2, 1, 0)
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
-- MAIN FRAME
-- =============================================
local InitialTransparency = 1 - (Settings.GuiTransparency / 500)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 700, 0, 480)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
MainFrame.BackgroundColor3 = CurrentTheme.Bg
MainFrame.BackgroundTransparency = InitialTransparency
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = CurrentTheme.Button
mainStroke.Thickness = 1
mainStroke.Transparency = InitialTransparency + 0.2

-- Anime kız arka planı
local animeBg = Instance.new("ImageLabel")
animeBg.Name = "AnimeBackground"
animeBg.Size = UDim2.new(1, 0, 1, 0)
animeBg.BackgroundTransparency = 1
animeBg.ImageTransparency = 0.55
animeBg.ScaleType = Enum.ScaleType.Crop
animeBg.ZIndex = 0
animeBg.Parent = MainFrame
Instance.new("UICorner", animeBg).CornerRadius = UDim.new(0, 8)

pcall(function()
    local fn = "anime_bg.jpg"
    local url = "https://raw.githubusercontent.com/whycroxin-svg/ahh/main/hile%20gui%20arka%20plan.jpg"
    if writefile and isfile and getcustomasset then
        if not isfile(fn) then writefile(fn, game:HttpGet(url)) end
        animeBg.Image = getcustomasset(fn)
    else
        animeBg.Image = url
    end
end)

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

local mainGradient = Instance.new("UIGradient", MainFrame)
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(CurrentTheme.Bg.R*255 + 4, CurrentTheme.Bg.G*255 + 4, CurrentTheme.Bg.B*255 + 4)),
    ColorSequenceKeypoint.new(1, CurrentTheme.Bg),
})
mainGradient.Rotation = 135

local tl = Instance.new("TextLabel")
tl.Size = UDim2.new(1, 0, 0, 18); tl.Position = UDim2.new(0, 24, 0, 16)
tl.BackgroundTransparency = 1
tl.Text = "SOU HUB"
tl.TextColor3 = CurrentTheme.Text
tl.TextSize = 15
tl.Font = Enum.Font.GothamBold
tl.TextXAlignment = Enum.TextXAlignment.Left
tl.ZIndex = 5
tl.Parent = MainFrame

local cl = Instance.new("TextLabel")
cl.Size = UDim2.new(1, 0, 0, 14); cl.Position = UDim2.new(0, 24, 0, 32)
cl.BackgroundTransparency = 1
cl.Text = "TOUCHLINE EDITION"
cl.TextColor3 = CurrentTheme.SubText
cl.TextSize = 9
cl.Font = Enum.Font.GothamSemibold
cl.TextXAlignment = Enum.TextXAlignment.Left
cl.ZIndex = 5
cl.Parent = MainFrame

local versionLbl = Instance.new("TextLabel")
versionLbl.Size = UDim2.new(0, 60, 0, 14)
versionLbl.Position = UDim2.new(1, -120, 0, 20)
versionLbl.BackgroundTransparency = 1
versionLbl.Text = "v1.0"
versionLbl.TextColor3 = CurrentTheme.SubText
versionLbl.TextSize = 10
versionLbl.Font = Enum.Font.Gotham
versionLbl.TextXAlignment = Enum.TextXAlignment.Right
versionLbl.ZIndex = 5
versionLbl.Parent = MainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0, 14)
closeBtn.BackgroundColor3 = CurrentTheme.Button
closeBtn.BackgroundTransparency = InitialTransparency + 0.2
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
    tween(closeBtn, 0.15, {BackgroundColor3 = CurrentTheme.Button, BackgroundTransparency = InitialTransparency + 0.2, TextColor3 = CurrentTheme.SubText})
end)
closeBtn.MouseButton1Click:Connect(function()
    tween(MainFrame, 0.35, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.4)
    MainFrame.Visible = false
    MainFrame.Size = UDim2.new(0, 700, 0, 480)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
    MainFrame.BackgroundTransparency = 1 - (Settings.GuiTransparency / 500)
end)

-- =============================================
-- SIDEBAR
-- =============================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 155, 1, -110)
Sidebar.Position = UDim2.new(0, 15, 0, 95)
Sidebar.BackgroundColor3 = CurrentTheme.Panel
Sidebar.BackgroundTransparency = InitialTransparency + 0.3
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 4
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local sideStroke = Instance.new("UIStroke", Sidebar)
sideStroke.Color = CurrentTheme.Button
sideStroke.Thickness = 1
sideStroke.Transparency = InitialTransparency + 0.2

local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(1, -12, 0, 55)
profileFrame.Position = UDim2.new(0, 6, 0, 6)
profileFrame.BackgroundColor3 = CurrentTheme.Button
profileFrame.BackgroundTransparency = InitialTransparency + 0.4
profileFrame.BorderSizePixel = 0
profileFrame.ZIndex = 5
profileFrame.Parent = Sidebar
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(0, 4)

local avatarCircle = Instance.new("Frame")
avatarCircle.Size = UDim2.new(0, 36, 0, 36)
avatarCircle.Position = UDim2.new(0, 8, 0.5, -18)
avatarCircle.BackgroundColor3 = CurrentTheme.Button
avatarCircle.BackgroundTransparency = InitialTransparency
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
profileStatus.Text = "CONNECTED"
profileStatus.TextColor3 = CurrentTheme.SubText
profileStatus.TextSize = 9
profileStatus.Font = Enum.Font.GothamSemibold
profileStatus.TextXAlignment = Enum.TextXAlignment.Left
profileStatus.ZIndex = 6
profileStatus.Parent = profileFrame

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
-- TAB SYSTEM
-- =============================================
local tabConfig = {
    {Name = "BALL",      Sub = "Ball control"},
    {Name = "ESP",       Sub = "Visual overlay"},
    {Name = "AIMBOT",    Sub = "Goal targeting"},
    {Name = "PLAYERS",   Sub = "Player actions"},
    {Name = "WORLD",     Sub = "Environment"},
    {Name = "THEMES",    Sub = "Appearance"},
    {Name = "SETTINGS",  Sub = "Configuration"},
}

local tabPages = {}
local tabButtons = {}
local activeTab = "BALL"
local uiElements = {}
local activeKeybindBtn = nil
local keybindCallbacks = {}

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
    btn.BackgroundTransparency = i==1 and InitialTransparency or 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.ZIndex = 5
    btn.Parent = SideScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
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
            tween(btn, 0.15, {BackgroundTransparency = InitialTransparency + 0.3, BackgroundColor3 = CurrentTheme.Button})
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
                BackgroundTransparency = isActive and InitialTransparency or 1
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
-- UI BUILDERS
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
    btn.BackgroundTransparency = InitialTransparency + 0.3
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
    
    local textPad = Instance.new("UIPadding", btn)
    textPad.PaddingLeft = UDim.new(0, 14)
    
    local stateLbl = Instance.new("TextLabel")
    stateLbl.Size = UDim2.new(0, 40, 1, 0)
    stateLbl.Position = UDim2.new(1, -48, 0, 0)
    stateLbl.BackgroundTransparency = 1
    stateLbl.Text = default and "ON" or "OFF"
    stateLbl.TextColor3 = default and CurrentTheme.Accent or CurrentTheme.SubText
    stateLbl.TextSize = 11
    stateLbl.Font = Enum.Font.GothamBold
    stateLbl.TextXAlignment = Enum.TextXAlignment.Right
    stateLbl.ZIndex = 4
    stateLbl.Parent = btn
    
    table.insert(uiElements, {element=btn, type="toggle"})

    local state = default
    local function doToggle()
        state = not state
        tween(btn, 0.2, {BackgroundTransparency = state and InitialTransparency + 0.15 or InitialTransparency + 0.3})
        tween(stateLbl, 0.2, {TextColor3 = state and CurrentTheme.Accent or CurrentTheme.SubText})
        stateLbl.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end
    btn.MouseButton1Click:Connect(doToggle)
    
    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, {BackgroundTransparency = state and InitialTransparency + 0.05 or InitialTransparency + 0.15})
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, {BackgroundTransparency = state and InitialTransparency + 0.15 or InitialTransparency + 0.3})
    end)

    if withKeybind then
        local kbBtn = Instance.new("TextButton")
        kbBtn.Size = UDim2.new(0, 68, 1, 0)
        kbBtn.Position = UDim2.new(1, -68, 0, 0)
        kbBtn.BackgroundColor3 = CurrentTheme.Button
        kbBtn.BackgroundTransparency = InitialTransparency + 0.5
        kbBtn.BorderSizePixel = 0
        kbBtn.Text = "—"
        kbBtn.TextColor3 = CurrentTheme.SubText
        kbBtn.TextSize = 10
        kbBtn.Font = Enum.Font.GothamBold
        kbBtn.AutoButtonColor = false
        kbBtn.ZIndex = 4
        kbBtn.Parent = row
        Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 4)
        
        kbBtn.MouseButton1Click:Connect(function()
            if activeKeybindBtn == kbBtn then
                activeKeybindBtn = nil
                kbBtn.Text = "—"
                kbBtn.TextColor3 = CurrentTheme.SubText
                tween(kbBtn, 0.2, {BackgroundTransparency = InitialTransparency + 0.5})
                return
            end
            if activeKeybindBtn then
                activeKeybindBtn.Text = "—"
                activeKeybindBtn.TextColor3 = CurrentTheme.SubText
                tween(activeKeybindBtn, 0.2, {BackgroundTransparency = InitialTransparency + 0.5})
            end
            activeKeybindBtn = kbBtn
            kbBtn.Text = "..."
            kbBtn.TextColor3 = Color3.fromRGB(230, 180, 60)
            tween(kbBtn, 0.2, {BackgroundTransparency = InitialTransparency + 0.2})
        end)

        local function assignKeybind(keyCode)
            kbBtn.Text = keyCode.Name
            kbBtn.TextColor3 = CurrentTheme.Text
            tween(kbBtn, 0.15, {BackgroundTransparency = InitialTransparency + 0.3})
            keybindCallbacks[keyCode] = doToggle
            activeKeybindBtn = nil
        end

        if not _G.SOUHUB_KeybindAssigners then _G.SOUHUB_KeybindAssigners = {} end
        _G.SOUHUB_KeybindAssigners[kbBtn] = assignKeybind
    end

    return function() return state end, function(v)
        state = v
        tween(btn, 0.2, {BackgroundTransparency = state and InitialTransparency + 0.15 or InitialTransparency + 0.3})
        tween(stateLbl, 0.2, {TextColor3 = state and CurrentTheme.Accent or CurrentTheme.SubText})
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

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 16)
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
    valueLbl.Text = tostring(math.floor(default))
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
    bg.BackgroundTransparency = InitialTransparency + 0.3
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
        valueLbl.Text = tostring(math.floor(value))
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
    line.BackgroundTransparency = InitialTransparency
    line.BorderSizePixel = 0
    line.ZIndex = 3
    line.Parent = container
    
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

local function addCycleButton(page, name, options, default, callback, order)
    local idx = 1
    for i,v in ipairs(options) do if v == default then idx = i; break end end
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-8,0,34)
    btn.BackgroundColor3 = CurrentTheme.Button
    btn.BackgroundTransparency = InitialTransparency + 0.3
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = order or 0
    btn.ZIndex = 3
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.5, 0, 1, 0)
    nameLbl.Position = UDim2.new(0, 14, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = CurrentTheme.Text
    nameLbl.TextSize = 11
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 4
    nameLbl.Parent = btn
    
    local valueLbl = Instance.new("TextLabel")
    valueLbl.Size = UDim2.new(0.5, -14, 1, 0)
    valueLbl.Position = UDim2.new(0.5, 0, 0, 0)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text = options[idx]
    valueLbl.TextColor3 = CurrentTheme.Accent
    valueLbl.TextSize = 11
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right
    valueLbl.ZIndex = 4
    valueLbl.Parent = btn
    
    btn.MouseEnter:Connect(function() tween(btn, 0.15, {BackgroundTransparency = InitialTransparency + 0.15}) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.15, {BackgroundTransparency = InitialTransparency + 0.3}) end)
    
    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        valueLbl.Text = options[idx]
        if callback then callback(options[idx]) end
    end)
    return function() return options[idx] end
end

-- =============================================
-- TEMA UYGULAMA
-- =============================================
local function applyTheme(themeName)
    if not Themes[themeName] then return end
    CurrentTheme = Themes[themeName]
    
    local baseTransparency = 1 - (Settings.GuiTransparency / 500)
    
    MainFrame.BackgroundColor3 = CurrentTheme.Bg
    mainStroke.Color = CurrentTheme.Button
    topAccent.BackgroundColor3 = CurrentTheme.Primary
    tl.TextColor3 = CurrentTheme.Text
    cl.TextColor3 = CurrentTheme.SubText
    versionLbl.TextColor3 = CurrentTheme.SubText
    Sidebar.BackgroundColor3 = CurrentTheme.Panel
    sideStroke.Color = CurrentTheme.Button
    profileFrame.BackgroundColor3 = CurrentTheme.Button
    avatarCircle.BackgroundColor3 = CurrentTheme.Button
    avatarRing.Color = CurrentTheme.Primary
    profileName.TextColor3 = CurrentTheme.Text
    profileStatus.TextColor3 = CurrentTheme.SubText
    
    mainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(CurrentTheme.Bg.R*255 + 4, CurrentTheme.Bg.G*255 + 4, CurrentTheme.Bg.B*255 + 4)),
        ColorSequenceKeypoint.new(1, CurrentTheme.Bg),
    })
    
    for _, data in ipairs(uiElements) do
        if data.element and data.element.Parent then
            if data.type == "toggle" then
                data.element.TextColor3 = CurrentTheme.Text
                local stateLbl = data.element:FindFirstChildOfClass("TextLabel")
                if stateLbl then
                    if stateLbl.Text == "ON" then
                        stateLbl.TextColor3 = CurrentTheme.Accent
                    else
                        stateLbl.TextColor3 = CurrentTheme.SubText
                    end
                end
            elseif data.type == "fill" then
                data.element.BackgroundColor3 = CurrentTheme.Accent
            elseif data.type == "separatorLine" then
                data.element.BackgroundColor3 = CurrentTheme.Button
            elseif data.type == "sectionLabel" then
                data.element.TextColor3 = CurrentTheme.SubText
            end
        end
    end
    
    for n,b in pairs(tabButtons) do 
        local isActive = (n == activeTab)
        b.BackgroundColor3 = isActive and CurrentTheme.Button or Color3.fromRGB(0,0,0)
        local ind = b:FindFirstChild("Indicator")
        if ind then ind.BackgroundColor3 = CurrentTheme.Primary end
        for _, lbl in ipairs(b:GetChildren()) do
            if lbl:IsA("TextLabel") then
                local isMain = lbl.TextSize == 11
                if isMain then
                    lbl.TextColor3 = isActive and CurrentTheme.Text or CurrentTheme.SubText
                else
                    lbl.TextColor3 = CurrentTheme.SubText
                end
            end
        end
    end
    
    for _, page in pairs(tabPages) do
        page.ScrollBarImageColor3 = CurrentTheme.Button
    end
    SideScroll.ScrollBarImageColor3 = CurrentTheme.Button
    
    Watermark.BackgroundColor3 = CurrentTheme.Panel
    wmStroke.Color = CurrentTheme.Button
    wmTitle.TextColor3 = CurrentTheme.Text
    wmInfo.TextColor3 = CurrentTheme.SubText
    wmAccent.BackgroundColor3 = CurrentTheme.Primary
    
    for _, btn in pairs(_G.SOUHUB_ThemeButtons or {}) do
        if btn.Parent then
            local isActive = btn:GetAttribute("ThemeName") == themeName
            if isActive then
                btn.BackgroundColor3 = CurrentTheme.Button
                local stroke = btn:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Transparency = 0; stroke.Color = CurrentTheme.Primary end
            else
                btn.BackgroundColor3 = CurrentTheme.Bg
                local stroke = btn:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Transparency = 0.7; stroke.Color = CurrentTheme.Button end
            end
        end
    end
    
    showToast("Theme Applied", CurrentTheme.Name .. " • " .. CurrentTheme.Category, "success")
end

-- =============================================
-- PAGE 1: BALL (Ball Control)
-- =============================================
local p1 = tabPages["BALL"]
addLabel(p1, "BALL CONTROL", 1)
local getReach = addToggle(p1, "Reach", false, function(v) Settings.Reach = v end, 2, true)
local getReachValue = addSlider(p1, "Reach Distance", 5, 100, 30, function(v) Settings.ReachValue = v end, 3)

addSeparator(p1, 4)
addLabel(p1, "BALL HITBOX", 5)
local getBallHitbox = addToggle(p1, "Ball Hitbox (Buyut)", false, function(v) Settings.BallHitbox = v end, 6, true)
local getBallSize = addSlider(p1, "Ball Size", 1, 20, 2, function(v) Settings.BallSize = v end, 7)

addSeparator(p1, 8)
addLabel(p1, "BALL ESP", 9)
local getBallESP = addToggle(p1, "Ball ESP", false, function(v) Settings.BallESP = v end, 10, true)
local getBallESPColor = addCycleButton(p1, "ESP Color", {"Yellow","Red","Cyan","Green","Purple","White","Pink","Orange"}, "Yellow", function(v)
    local colors = {Yellow=Color3.fromRGB(255,220,60), Red=Color3.fromRGB(255,80,80), Cyan=Color3.fromRGB(100,220,255), Green=Color3.fromRGB(100,255,140), Purple=Color3.fromRGB(200,120,255), White=Color3.fromRGB(255,255,255), Pink=Color3.fromRGB(255,150,200), Orange=Color3.fromRGB(255,160,60)}
    Settings.BallESPColor = colors[v] or Color3.fromRGB(255,220,60)
end, 11)

addSeparator(p1, 12)
addLabel(p1, "BALL HITBOX ESP", 13)
local getBallHitboxESP = addToggle(p1, "Ball Hitbox ESP (Cember)", false, function(v) Settings.BallHitboxESP = v end, 14, true)

-- =============================================
-- PAGE 2: ESP
-- =============================================
local p2 = tabPages["ESP"]
addLabel(p2, "PLAYER HITBOX", 1)
local getHitboxESP = addToggle(p2, "Hitbox ESP (Karakter)", false, function(v) Settings.HitboxESP = v end, 2, true)

addSeparator(p2, 3)
addLabel(p2, "BALL ESP AYARLARI", 4)
local getBallESPBox = addToggle(p2, "Box", true, function(v) Settings.BallESPBox = v end, 5, false)
local getBallESPName = addToggle(p2, "Name", true, function(v) Settings.BallESPName = v end, 6, false)
local getBallESPDistance = addToggle(p2, "Distance", true, function(v) Settings.BallESPDistance = v end, 7, false)

-- =============================================
-- PAGE 3: AIMBOT
-- =============================================
local p3 = tabPages["AIMBOT"]
addLabel(p3, "GOAL AIMBOT", 1)
local getGoalAimbot = addToggle(p3, "Goal Aimbot", false, function(v) Settings.GoalAimbot = v end, 2, true)
local getGoalStrength = addSlider(p3, "Aim Strength", 0.1, 1.0, 0.5, function(v) Settings.GoalAimStrength = v end, 3)

addSeparator(p3, 4)
addLabel(p3, "GOALKEEPER", 5)
local getAutoDive = addToggle(p3, "Auto Dive", false, function(v) Settings.AutoDive = v end, 6, true)

-- =============================================
-- PAGE 4: PLAYERS
-- =============================================
local p4 = tabPages["PLAYERS"]
addLabel(p4, "PLAYER LIST", 1)
local playerListLabel = Instance.new("TextLabel")
playerListLabel.Size = UDim2.new(1,-8,0,20)
playerListLabel.BackgroundTransparency = 1
playerListLabel.Text = "Oyuncular yukleniyor..."
playerListLabel.TextColor3 = CurrentTheme.SubText
playerListLabel.TextSize = 10
playerListLabel.Font = Enum.Font.Gotham
playerListLabel.TextXAlignment = Enum.TextXAlignment.Left
playerListLabel.LayoutOrder = 2
playerListLabel.ZIndex = 3
playerListLabel.Parent = p4
table.insert(uiElements, {element=playerListLabel, type="sectionLabel"})

task.spawn(function()
    while playerListLabel.Parent do
        local count = #Players:GetPlayers()
        playerListLabel.Text = "Toplam " .. count .. " oyuncu • " .. LocalPlayer.Name .. " (sen)"
        task.wait(2)
    end
end)

-- =============================================
-- PAGE 5: WORLD
-- =============================================
local p5 = tabPages["WORLD"]
addLabel(p5, "LIGHTING", 1)
local getFullbright = addToggle(p5, "Fullbright", false, function(v) Settings.Fullbright = v end, 2, true)

addSeparator(p5, 3)
addLabel(p5, "SERVER", 4)
local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(1,-8,0,36)
rejoinBtn.BackgroundColor3 = CurrentTheme.Button
rejoinBtn.BackgroundTransparency = InitialTransparency + 0.2
rejoinBtn.BorderSizePixel = 0
rejoinBtn.Text = "Server Rejoin"
rejoinBtn.TextColor3 = CurrentTheme.Text
rejoinBtn.TextSize = 11
rejoinBtn.Font = Enum.Font.GothamSemibold
rejoinBtn.AutoButtonColor = false
rejoinBtn.LayoutOrder = 5
rejoinBtn.ZIndex = 3
rejoinBtn.Parent = p5
Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0,4)
rejoinBtn.MouseButton1Click:Connect(function()
    showToast("Server", "Reconnecting...", "info")
    task.wait(0.5)
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
end)

-- =============================================
-- PAGE 6: THEMES
-- =============================================
local p6 = tabPages["THEMES"]
addLabel(p6, "SELECT A THEME", 1)

_G.SOUHUB_ThemeButtons = _G.SOUHUB_ThemeButtons or {}

local function createThemeGrid(parent, category, order)
    local grid = Instance.new("Frame")
    grid.Size = UDim2.new(1, -8, 0, 200)
    grid.BackgroundTransparency = 1
    grid.LayoutOrder = order
    grid.ZIndex = 3
    grid.Parent = parent
    
    local gridLayout = Instance.new("UIGridLayout", grid)
    gridLayout.CellSize = UDim2.new(0.33, -6, 0, 62)
    gridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    for name, theme in pairs(Themes) do
        if theme.Category == category then
            local btn = Instance.new("TextButton")
            btn.Name = "ThemeBtn_" .. name
            btn.BackgroundColor3 = CurrentTheme.Bg
            btn.BackgroundTransparency = InitialTransparency
            btn.BorderSizePixel = 0
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.ZIndex = 3
            btn.Parent = grid
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = CurrentTheme.Button
            stroke.Thickness = 1.5
            stroke.Transparency = 0.7
            
            local colorRow = Instance.new("Frame")
            colorRow.Size = UDim2.new(1, -16, 0, 20)
            colorRow.Position = UDim2.new(0, 8, 0, 8)
            colorRow.BackgroundTransparency = 1
            colorRow.ZIndex = 4
            colorRow.Parent = btn
            
            local colorLayout = Instance.new("UIListLayout", colorRow)
            colorLayout.FillDirection = Enum.FillDirection.Horizontal
            colorLayout.Padding = UDim.new(0, 3)
            
            for i, c in ipairs({theme.Primary, theme.Accent, theme.Panel}) do
                local dot = Instance.new("Frame")
                dot.Size = UDim2.new(0, 14, 0, 14)
                dot.BackgroundColor3 = c
                dot.BorderSizePixel = 0
                dot.ZIndex = 5
                dot.Parent = colorRow
                Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
            end
            
            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, -8, 0, 16)
            nameLbl.Position = UDim2.new(0, 4, 1, -22)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = theme.Name
            nameLbl.TextColor3 = CurrentTheme.Text
            nameLbl.TextSize = 10
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.ZIndex = 4
            nameLbl.Parent = btn
            
            btn:SetAttribute("ThemeName", name)
            _G.SOUHUB_ThemeButtons[name] = btn
            
            if name == CurrentTheme.Name then
                stroke.Transparency = 0
                stroke.Color = CurrentTheme.Primary
                btn.BackgroundColor3 = CurrentTheme.Button
            end
            
            btn.MouseButton1Click:Connect(function() applyTheme(name) end)
        end
    end
end

createThemeGrid(p6, "Classic", 2)
createThemeGrid(p6, "Special", 3)

-- =============================================
-- PAGE 7: SETTINGS
-- =============================================
local p7 = tabPages["SETTINGS"]
addLabel(p7, "INTERFACE", 1)
local getGuiTransparency = addSlider(p7, "Gui Transparency", 0, 500, Settings.GuiTransparency, function(v)
    Settings.GuiTransparency = v
    local transparency = 1 - (v / 500)
    MainFrame.BackgroundTransparency = transparency
end, 2)

addSeparator(p7, 3)
addLabel(p7, "OVERLAY", 4)
local getWatermark = addToggle(p7, "Watermark", true, nil, 5, false)
local getFPSDisplay = addToggle(p7, "FPS Display", true, nil, 6, false)
local getPingDisplay = addToggle(p7, "Ping Display", true, nil, 7, false)

-- =============================================
-- WATERMARK
-- =============================================
local Watermark = Instance.new("Frame")
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0, 220, 0, 38)
Watermark.Position = UDim2.new(0, 15, 0, 15)
Watermark.BackgroundColor3 = CurrentTheme.Panel
Watermark.BackgroundTransparency = InitialTransparency
Watermark.BorderSizePixel = 0
Watermark.Visible = true
Watermark.ZIndex = 500
Watermark.Parent = ScreenGui
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 4)
local wmStroke = Instance.new("UIStroke", Watermark)
wmStroke.Color = CurrentTheme.Button
wmStroke.Thickness = 1
makeDraggable(Watermark, Watermark)

local wmAccent = Instance.new("Frame")
wmAccent.Size = UDim2.new(0, 30, 0, 1)
wmAccent.Position = UDim2.new(0, 12, 0, 1)
wmAccent.BackgroundColor3 = CurrentTheme.Primary
wmAccent.BorderSizePixel = 0
wmAccent.ZIndex = 502
wmAccent.Parent = Watermark

local wmTitle = Instance.new("TextLabel")
wmTitle.Size = UDim2.new(1, 0, 0, 18)
wmTitle.Position = UDim2.new(0, 12, 0, 8)
wmTitle.BackgroundTransparency = 1
wmTitle.Text = "SOU HUB"
wmTitle.TextColor3 = CurrentTheme.Text
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
        local fpsStr = getFPSDisplay() and (fps .. " FPS") or ""
        local pingStr = getPingDisplay() and (ping .. " MS") or ""
        wmInfo.Text = fpsStr .. "  |  " .. pingStr
        fpsCount = 0
        fpsTime = tick()
    end
end)
RunService.RenderStepped:Connect(function()
    Watermark.Visible = getWatermark()
end)

-- =============================================
-- ESP SYSTEM
-- =============================================
local ballHighlight = nil
local ballBillboard = nil
local ballSphere = nil
local charSphereData = {}
local ballHitboxBox = nil
local originalBallSize = nil
local originalBallPart = nil
local originalCanCollide = nil

local function updateESP()
    local ball = findBall()
    
    -- BALL ESP (Highlight + Billboard)
    if Settings.BallESP and ball then
        if not ballHighlight or ballHighlight.Parent ~= ball then
            if ballHighlight then ballHighlight:Destroy() end
            ballHighlight = Instance.new("Highlight")
            ballHighlight.FillColor = Settings.BallESPColor
            ballHighlight.OutlineColor = Settings.BallESPColor
            ballHighlight.FillTransparency = 0.5
            ballHighlight.OutlineTransparency = 0
            ballHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            ballHighlight.Adornee = ball
            ballHighlight.Parent = ball
        end
        
        if not ballBillboard or ballBillboard.Parent ~= ball then
            if ballBillboard then ballBillboard:Destroy() end
            ballBillboard = Instance.new("BillboardGui")
            ballBillboard.Name = "SOUHUB_BallInfo"
            ballBillboard.Size = UDim2.new(0, 100, 0, 32)
            ballBillboard.StudsOffset = Vector3.new(0, 2.5, 0)
            ballBillboard.AlwaysOnTop = true
            ballBillboard.Adornee = ball
            ballBillboard.Parent = ball
            
            local nameLbl = Instance.new("TextLabel")
            nameLbl.Name = "NameLbl"
            nameLbl.Size = UDim2.new(1, 0, 0, 16)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = "BALL"
            nameLbl.TextColor3 = Settings.BallESPColor
            nameLbl.TextSize = 13
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextStrokeTransparency = 0.3
            nameLbl.Parent = ballBillboard
            
            local distLbl = Instance.new("TextLabel")
            distLbl.Name = "DistLbl"
            distLbl.Size = UDim2.new(1, 0, 0, 13)
            distLbl.Position = UDim2.new(0, 0, 0, 17)
            distLbl.BackgroundTransparency = 1
            distLbl.Text = "0m"
            distLbl.TextColor3 = Settings.BallESPColor
            distLbl.TextSize = 11
            distLbl.Font = Enum.Font.GothamBold
            distLbl.TextStrokeTransparency = 0.3
            distLbl.Parent = ballBillboard
        end
        
        if ballBillboard then
            local nameLbl = ballBillboard:FindFirstChild("NameLbl")
            local distLbl = ballBillboard:FindFirstChild("DistLbl")
            if nameLbl then nameLbl.TextColor3 = Settings.BallESPColor end
            if distLbl then
                distLbl.TextColor3 = Settings.BallESPColor
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local d = (char.HumanoidRootPart.Position - ball.Position).Magnitude
                    distLbl.Text = string.format("%.0fm", d)
                end
            end
        end
    else
        if ballHighlight then ballHighlight:Destroy() ballHighlight = nil end
        if ballBillboard then ballBillboard:Destroy() ballBillboard = nil end
    end
    
    -- BALL HITBOX ESP (ÇEMBER)
    if Settings.BallHitboxESP and ball then
        if not ballSphere or ballSphere.Parent ~= ball then
            if ballSphere then ballSphere:Destroy() end
            ballSphere = Instance.new("SphereHandleAdornment")
            ballSphere.Name = "SOUHUB_BallSphere"
            ballSphere.Adornee = ball
            ballSphere.Radius = (ball.Size.X / 2) + 0.5
            ballSphere.Color3 = Settings.BallESPColor
            ballSphere.Transparency = 0.4
            ballSphere.AlwaysOnTop = true
            ballSphere.ZIndex = 5
            ballSphere.Parent = ball
        else
            ballSphere.Radius = (ball.Size.X / 2) + 0.5
            ballSphere.Color3 = Settings.BallESPColor
        end
    else
        if ballSphere then ballSphere:Destroy() ballSphere = nil end
    end
    
    -- PLAYER HITBOX ESP
    if Settings.HitboxESP then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not charSphereData[hrp] or not charSphereData[hrp].sphere.Parent then
                        local sphere = Instance.new("SphereHandleAdornment")
                        sphere.Adornee = hrp
                        sphere.Radius = math.max(hrp.Size.X, hrp.Size.Y, hrp.Size.Z) / 2 + 0.8
                        sphere.Color3 = Settings.BallESPColor
                        sphere.Transparency = 0.6
                        sphere.AlwaysOnTop = true
                        sphere.ZIndex = 5
                        sphere.Parent = hrp
                        charSphereData[hrp] = {sphere = sphere}
                    end
                end
            end
        end
    else
        for hrp, data in pairs(charSphereData) do
            if data.sphere and data.sphere.Parent then data.sphere:Destroy() end
        end
        charSphereData = {}
    end
end

-- =============================================
-- FEATURE LOOPS
-- =============================================
RunService.RenderStepped:Connect(function()
    updateESP()
    
    local ball = findBall()
    
    if ball then
        if Settings.BallHitbox then
            if originalBallPart ~= ball then
                originalBallPart = ball
                originalBallSize = ball.Size
                originalCanCollide = ball.CanCollide
            end
            local s = Settings.BallSize
            ball.Size = Vector3.new(s, s, s)
            ball.CanCollide = false
        else
            if originalBallPart and originalBallSize then
                pcall(function()
                    originalBallPart.Size = originalBallSize
                    originalBallPart.CanCollide = originalCanCollide
                end)
                originalBallPart = nil
                originalBallSize = nil
                originalCanCollide = nil
            end
        end
    end
    
    if Settings.Fullbright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.Brightness = OriginalLighting.Brightness
    end
    
    if Settings.GoalAimbot and ball then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - ball.Position).Magnitude < 30 then
                local goal = findGoal()
                if goal then
                    local targetCF = CFrame.new(ball.Position, goal.Position)
                    ball.CFrame = ball.CFrame:Lerp(targetCF, Settings.GoalAimStrength * 0.1)
                end
            end
        end
    end
    
    if Settings.AutoDive and ball then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - ball.Position).Magnitude < 25 then
                local goal = findGoal()
                if goal then
                    local dir = (goal.Position - hrp.Position).Unit
                    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + dir)
                end
            end
        end
    end
end)

-- =============================================
-- INPUT
-- =============================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if activeKeybindBtn and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
            local assignFunc = _G.SOUHUB_KeybindAssigners and _G.SOUHUB_KeybindAssigners[activeKeybindBtn]
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

    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            tween(MainFrame, 0.4, {Size = UDim2.new(0, 700, 0, 480), Position = UDim2.new(0.5, -350, 0.5, -240)}, Enum.EasingStyle.Back)
        end
    end
end)

-- =============================================
-- ESC MENU
-- =============================================
local menuOpen = false
pcall(function()
    GuiService.MenuOpened:Connect(function()
        menuOpen = true
        MainFrame.Visible = false
        Watermark.Visible = false
    end)
    GuiService.MenuClosed:Connect(function()
        menuOpen = false
    end)
end)

-- =============================================
-- SPLASH SONRASI GUI AÇ
-- =============================================
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
    showToast("SOU HUB", "Touchline Edition hazir!", "success")
    task.wait(0.6)
    showToast("Interface", "Press Right Shift to toggle", "info")
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "SOU HUB",
        Text = "Touchline Edition loaded!",
        Duration = 5
    })
end)

print("[SOU HUB] Touchline Winter Edition yuklendi!")
