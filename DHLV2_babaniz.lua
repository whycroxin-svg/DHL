--[[
    SOU HUB - CLEAN PRO EDITION (Da Hood)
]]

print("[SOU HUB] Winter Edition yukleniyor...")

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
    WallCheck = false, Smoothness = 0.450, Prediction = 0.100,
    TargetPart = "Head", Mode = "RightMouseClick", StickyAim = true, AutoSwitch = true,
    SkipDowned = true, AlwaysOn = false, TriggerBot = false, FOVVisible = true,
    FOVRadius = 150, FOVUseTheme = true,
    HighlightFillTransparency = 0.35, HighlightColor = Color3.fromRGB(140,168,200),
    GuiTransparency = 250,
    FollowPlayer = false, FollowTarget = nil,
    Kills = 0, SessionStart = tick(),
    SelectedPlayers = {}, CurrentTarget = nil,
    KillAura = false, KillAuraRange = 12, KillAuraDelay = 100,
    Spinbot = false, SpinbotSpeed = 30, SpinbotRadius = 3,
    AutoAttack = false, AutoAttackRange = 8,
}

-- =============================================
-- CLEANUP
-- =============================================
for _, loc in ipairs({game:GetService("CoreGui"), LocalPlayer:FindFirstChild("PlayerGui")}) do
    pcall(function() 
        local o = loc:FindFirstChild("SOUHUB_Winter"); if o then o:Destroy() end
    end)
end
pcall(function() 
    if gethui then 
        local o = gethui():FindFirstChild("SOUHUB_Winter"); if o then o:Destroy() end
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
-- SILENT AIM
-- =============================================
local silentAimEnabled = false
local silentAimTargetPart = "Head"

pcall(function()
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(t, k)
        if not silentAimEnabled then return oldIndex(t, k) end
        if not Settings or not Settings.CurrentTarget then return oldIndex(t, k) end
        local target = Settings.CurrentTarget
        if not target or not target.Character then return oldIndex(t, k) end
        local part = target.Character:FindFirstChild(silentAimTargetPart)
        if not part then part = target.Character:FindFirstChild("HumanoidRootPart") end
        if not part then return oldIndex(t, k) end
        if t:IsA("Mouse") then
            if k == "Hit" then return part.CFrame
            elseif k == "Target" then return part end
        end
        return oldIndex(t, k)
    end)
end)

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
-- SPLASH
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
splashFrame.Parent = splashGui

local splashTitle = Instance.new("TextLabel")
splashTitle.Size = UDim2.new(1, 0, 0, 40)
splashTitle.Position = UDim2.new(0, 0, 0.5, -20)
splashTitle.BackgroundTransparency = 1
splashTitle.Text = "S O U"
splashTitle.TextColor3 = Color3.fromRGB(255,255,255)
splashTitle.TextSize = 36
splashTitle.Font = Enum.Font.GothamBlack
splashTitle.TextTransparency = 1
splashTitle.Parent = splashFrame

local splashSub = Instance.new("TextLabel")
splashSub.Size = UDim2.new(1, 0, 0, 16)
splashSub.Position = UDim2.new(0, 0, 0.5, 22)
splashSub.BackgroundTransparency = 1
splashSub.Text = "W I N T E R   E D I T I O N"
splashSub.TextColor3 = CurrentTheme.SubText
splashSub.TextSize = 9
splashSub.Font = Enum.Font.GothamSemibold
splashSub.TextTransparency = 1
splashSub.Parent = splashFrame

task.spawn(function()
    task.wait(0.15)
    tween(splashTitle, 0.4, {TextTransparency = 0})
    task.wait(0.2)
    tween(splashSub, 0.4, {TextTransparency = 0})
    task.wait(1.2)
    tween(splashFrame, 0.5, {BackgroundTransparency = 1})
    tween(splashTitle, 0.4, {TextTransparency = 1})
    tween(splashSub, 0.4, {TextTransparency = 1})
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
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = CurrentTheme.Button
mainStroke.Thickness = 1
mainStroke.Transparency = InitialTransparency + 0.2

-- =============================================
-- KAR EFEKTİ
-- =============================================
local snowContainer = Instance.new("Frame")
snowContainer.Name = "SnowContainer"
snowContainer.Size = UDim2.new(1, 0, 1, 0)
snowContainer.BackgroundTransparency = 1
snowContainer.ClipsDescendants = true
snowContainer.ZIndex = 1
snowContainer.Parent = MainFrame
Instance.new("UICorner", snowContainer).CornerRadius = UDim.new(0, 8)

task.spawn(function()
    while snowContainer.Parent do
        if CurrentTheme.Name == "Winter" then
            local flake = Instance.new("Frame")
            local size = math.random(2, 5)
            flake.Size = UDim2.new(0, size, 0, size)
            flake.Position = UDim2.new(math.random(), 0, -0.05, 0)
            flake.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            flake.BackgroundTransparency = math.random(30, 70) / 100
            flake.BorderSizePixel = 0
            flake.ZIndex = 1
            flake.Parent = snowContainer
            Instance.new("UICorner", flake).CornerRadius = UDim.new(1, 0)

            local duration = math.random(4, 10)
            local drift = math.random(-80, 80)

            tween(flake, duration, {
                Position = UDim2.new(flake.Position.X.Scale + drift / 1000, 0, 1.05, 0),
                BackgroundTransparency = 1
            }, Enum.EasingStyle.Linear)

            task.delay(duration, function() 
                if flake and flake.Parent then flake:Destroy() end 
            end)
        end
        task.wait(math.random(8, 20) / 100)
    end
end)

-- =============================================
-- TOP ACCENT + TITLE
-- =============================================
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
cl.Text = "WINTER EDITION"
cl.TextColor3 = CurrentTheme.SubText
cl.TextSize = 9
cl.Font = Enum.Font.GothamSemibold
cl.TextXAlignment = Enum.TextXAlignment.Left
cl.ZIndex = 5
cl.Parent = MainFrame

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
closeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
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

local searchSettingBox = Instance.new("TextBox")
searchSettingBox.Size = UDim2.new(1, -12, 0, 28)
searchSettingBox.Position = UDim2.new(0, 6, 0, 6)
searchSettingBox.BackgroundColor3 = CurrentTheme.Button
searchSettingBox.BackgroundTransparency = InitialTransparency + 0.3
searchSettingBox.BorderSizePixel = 0
searchSettingBox.PlaceholderText = "Ayar ara..."
searchSettingBox.PlaceholderColor3 = CurrentTheme.SubText
searchSettingBox.Text = ""
searchSettingBox.TextColor3 = CurrentTheme.Text
searchSettingBox.TextSize = 10
searchSettingBox.Font = Enum.Font.Gotham
searchSettingBox.ClearTextOnFocus = false
searchSettingBox.ZIndex = 6
searchSettingBox.Parent = Sidebar
Instance.new("UICorner", searchSettingBox).CornerRadius = UDim.new(0, 4)

local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(1, -12, 0, 55)
profileFrame.Position = UDim2.new(0, 6, 0, 40)
profileFrame.BackgroundColor3 = CurrentTheme.Button
profileFrame.BackgroundTransparency = InitialTransparency + 0.4
profileFrame.BorderSizePixel = 0
profileFrame.ZIndex = 5
profileFrame.Parent = Sidebar
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(0, 4)

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 36, 0, 36)
avatarImg.Position = UDim2.new(0, 8, 0.5, -18)
avatarImg.BackgroundTransparency = 1
avatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
avatarImg.ZIndex = 7
avatarImg.Parent = profileFrame
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

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
SideScroll.Size = UDim2.new(1, -12, 1, -112)
SideScroll.Position = UDim2.new(0, 6, 0, 100)
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
    {Name = "AIMLOCK",   Sub = "Targeting system"},
    {Name = "ESP",       Sub = "Visual overlay"},
    {Name = "MOVEMENT",  Sub = "Speed & flight"},
    {Name = "PLAYERS",   Sub = "Player actions"},
    {Name = "COMBAT",    Sub = "Kill Aura & Spin"},
    {Name = "WORLD",     Sub = "Environment"},
    {Name = "CHARACTER", Sub = "Player state"},
    {Name = "THEMES",    Sub = "Appearance"},
    {Name = "SETTINGS",  Sub = "Configuration"},
}

local tabPages = {}
local tabButtons = {}
local activeTab = "AIMLOCK"
local activeKeybindBtn = nil
local keybindCallbacks = {}
local keybindNames = {}

for i, config in ipairs(tabConfig) do
    local name = config.Name
    local sub = config.Sub

    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. name
    btn.Size = UDim2.new(1, 0, 0, 38)
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
    nameLbl.Size = UDim2.new(1, -20, 0, 14)
    nameLbl.Position = UDim2.new(0, 14, 0, 5)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = i==1 and CurrentTheme.Text or CurrentTheme.SubText
    nameLbl.TextSize = 10
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 6
    nameLbl.Parent = btn

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -20, 0, 12)
    subLbl.Position = UDim2.new(0, 14, 0, 20)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = sub
    subLbl.TextColor3 = CurrentTheme.SubText
    subLbl.TextSize = 8
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.ZIndex = 6
    subLbl.Parent = btn

    tabButtons[name] = btn

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
            local nl = b:FindFirstChildOfClass("TextLabel")
            if nl then tween(nl, 0.15, {TextColor3 = isActive and CurrentTheme.Text or CurrentTheme.SubText}) end
        end

        tabPages[oldTab].Visible = false
        page.Visible = true
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

    local state = default
    local function doToggle()
        state = not state
        tween(btn, 0.2, {BackgroundTransparency = state and InitialTransparency + 0.15 or InitialTransparency + 0.3})
        tween(stateLbl, 0.2, {TextColor3 = state and CurrentTheme.Accent or CurrentTheme.SubText})
        stateLbl.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end
    btn.MouseButton1Click:Connect(doToggle)

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
                return
            end
            if activeKeybindBtn then
                activeKeybindBtn.Text = "—"
                activeKeybindBtn.TextColor3 = CurrentTheme.SubText
            end
            activeKeybindBtn = kbBtn
            kbBtn.Text = "..."
            kbBtn.TextColor3 = Color3.fromRGB(230, 180, 60)
        end)

        local function assignKeybind(keyCode)
            for k, v in pairs(keybindCallbacks) do
                if v == doToggle then
                    keybindCallbacks[k] = nil
                    keybindNames[k] = nil
                end
            end
            kbBtn.Text = keyCode.Name
            kbBtn.TextColor3 = CurrentTheme.Text
            keybindCallbacks[keyCode] = doToggle
            keybindNames[keyCode] = name
            activeKeybindBtn = nil
            updateKeybindPanel()
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

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,10,0,10)
    knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new((default-min)/(max-min),0,0.5,0)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 4
    knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

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

    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        valueLbl.Text = options[idx]
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
    line.BackgroundTransparency = InitialTransparency
    line.BorderSizePixel = 0
    line.ZIndex = 3
    line.Parent = container
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
end

local function addButton(page, name, callback, order, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-8,0,36)
    btn.BackgroundColor3 = color or CurrentTheme.Button
    btn.BackgroundTransparency = InitialTransparency + 0.2
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

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

local function getFOVThemeColor()
    if Settings.FOVUseTheme then return CurrentTheme.Accent end
    return Color3.fromRGB(200,80,80)
end

-- =============================================
-- KEYBIND FLOATING PANEL
-- =============================================
local keybindPanel = Instance.new("Frame")
keybindPanel.Name = "KeybindPanel"
keybindPanel.Size = UDim2.new(0, 200, 0, 0)
keybindPanel.Position = UDim2.new(0, 15, 1, -15)
keybindPanel.AnchorPoint = Vector2.new(0, 1)
keybindPanel.BackgroundColor3 = CurrentTheme.Panel
keybindPanel.BackgroundTransparency = InitialTransparency
keybindPanel.BorderSizePixel = 0
keybindPanel.ClipsDescendants = true
keybindPanel.ZIndex = 550
keybindPanel.Visible = false
keybindPanel.Parent = ScreenGui
Instance.new("UICorner", keybindPanel).CornerRadius = UDim.new(0, 6)

local kpHeader = Instance.new("Frame")
kpHeader.Size = UDim2.new(1, 0, 0, 26)
kpHeader.BackgroundColor3 = CurrentTheme.Button
kpHeader.BackgroundTransparency = 0.3
kpHeader.BorderSizePixel = 0
kpHeader.ZIndex = 551
kpHeader.Parent = keybindPanel
Instance.new("UICorner", kpHeader).CornerRadius = UDim.new(0, 6)

local kpTitle = Instance.new("TextLabel")
kpTitle.Size = UDim2.new(1, -30, 1, 0)
kpTitle.Position = UDim2.new(0, 10, 0, 0)
kpTitle.BackgroundTransparency = 1
kpTitle.Text = "KEYBINDS"
kpTitle.TextColor3 = CurrentTheme.Text
kpTitle.TextSize = 10
kpTitle.Font = Enum.Font.GothamBold
kpTitle.TextXAlignment = Enum.TextXAlignment.Left
kpTitle.ZIndex = 552
kpTitle.Parent = kpHeader

local kpClose = Instance.new("TextButton")
kpClose.Size = UDim2.new(0, 20, 0, 20)
kpClose.Position = UDim2.new(1, -24, 0, 3)
kpClose.BackgroundTransparency = 1
kpClose.Text = "×"
kpClose.TextColor3 = CurrentTheme.SubText
kpClose.TextSize = 16
kpClose.Font = Enum.Font.GothamBold
kpClose.AutoButtonColor = false
kpClose.ZIndex = 552
kpClose.Parent = kpHeader
kpClose.MouseButton1Click:Connect(function()
    keybindPanel.Visible = false
end)

local kpScroll = Instance.new("ScrollingFrame")
kpScroll.Size = UDim2.new(1, -8, 1, -34)
kpScroll.Position = UDim2.new(0, 4, 0, 30)
kpScroll.BackgroundTransparency = 1
kpScroll.BorderSizePixel = 0
kpScroll.ScrollBarThickness = 2
kpScroll.ScrollBarImageColor3 = CurrentTheme.Button
kpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
kpScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
kpScroll.ZIndex = 552
kpScroll.Parent = keybindPanel

local kpLayout = Instance.new("UIListLayout", kpScroll)
kpLayout.SortOrder = Enum.SortOrder.LayoutOrder
kpLayout.Padding = UDim.new(0, 2)

function updateKeybindPanel()
    if not kpScroll then return end
    for _, child in ipairs(kpScroll:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end

    local count = 0
    for keyCode, callback in pairs(keybindCallbacks) do
        count = count + 1
        local name = keybindNames[keyCode] or "Toggle"
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -4, 0, 22)
        lbl.BackgroundColor3 = CurrentTheme.Button
        lbl.BackgroundTransparency = 0.4
        lbl.BorderSizePixel = 0
        lbl.Text = "  " .. keyCode.Name .. "  →  " .. name
        lbl.TextColor3 = CurrentTheme.Text
        lbl.TextSize = 10
        lbl.Font = Enum.Font.Code
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.LayoutOrder = count
        lbl.ZIndex = 553
        lbl.Parent = kpScroll
        Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 3)
    end

    if count == 0 then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, -4, 0, 22)
        empty.BackgroundTransparency = 1
        empty.Text = "  No keybinds set"
        empty.TextColor3 = CurrentTheme.SubText
        empty.TextSize = 10
        empty.Font = Enum.Font.Gotham
        empty.LayoutOrder = 1
        empty.ZIndex = 553
        empty.Parent = kpScroll
    end

    local targetHeight = math.min(30 + count * 24 + 8, 250)
    keybindPanel.Size = UDim2.new(0, 200, 0, targetHeight)
end

makeDraggable(keybindPanel, kpHeader)

-- =============================================
-- PAGE 1: AIMLOCK
-- =============================================
local p1 = tabPages["AIMLOCK"]
addLabel(p1, "CAMLOCK", 1)
local getCamlock = addToggle(p1, "Camlock System", true, nil, 2, true)
local getWallCheck = addToggle(p1, "Wall Check", false, function(v) Settings.WallCheck = v end, 3, true)
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

addSeparator(p1, 27)
addLabel(p1, "SILENT AIM", 28)
local getSilentAim = addToggle(p1, "Silent Aim", false, function(v) silentAimEnabled = v end, 29, true)
local getSilentPart = addCycleButton(p1, "Silent Part", {"Head", "HumanoidRootPart", "UpperTorso"}, "Head", function(v) silentAimTargetPart = v end, 30)

-- =============================================
-- PAGE 2: ESP
-- =============================================
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

-- =============================================
-- PAGE 3: MOVEMENT
-- =============================================
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

-- =============================================
-- PAGE 4: PLAYERS
-- =============================================
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

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1,-8,0,28)
btnRow.BackgroundTransparency = 1
btnRow.LayoutOrder = 2
btnRow.ZIndex = 3
btnRow.Parent = p4

local SelectAllBtn = Instance.new("TextButton")
SelectAllBtn.Size = UDim2.new(0.48,0,1,0)
SelectAllBtn.BackgroundColor3 = CurrentTheme.Button
SelectAllBtn.BackgroundTransparency = InitialTransparency + 0.3
SelectAllBtn.BorderSizePixel = 0
SelectAllBtn.Text = "Select All"
SelectAllBtn.TextColor3 = CurrentTheme.Text
SelectAllBtn.TextSize = 10
SelectAllBtn.Font = Enum.Font.GothamSemibold
SelectAllBtn.AutoButtonColor = false
SelectAllBtn.ZIndex = 3
SelectAllBtn.Parent = btnRow
Instance.new("UICorner", SelectAllBtn).CornerRadius = UDim.new(0,4)

local ClearAllBtn = Instance.new("TextButton")
ClearAllBtn.Size = UDim2.new(0.48,0,1,0)
ClearAllBtn.Position = UDim2.new(0.52,0,0,0)
ClearAllBtn.BackgroundColor3 = CurrentTheme.Button
ClearAllBtn.BackgroundTransparency = InitialTransparency + 0.3
ClearAllBtn.BorderSizePixel = 0
ClearAllBtn.Text = "Clear"
ClearAllBtn.TextColor3 = CurrentTheme.Text
ClearAllBtn.TextSize = 10
ClearAllBtn.Font = Enum.Font.GothamSemibold
ClearAllBtn.AutoButtonColor = false
ClearAllBtn.ZIndex = 3
ClearAllBtn.Parent = btnRow
Instance.new("UICorner", ClearAllBtn).CornerRadius = UDim.new(0,4)

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1,-8,0,32)
SearchBox.BackgroundColor3 = CurrentTheme.Button
SearchBox.BackgroundTransparency = InitialTransparency + 0.3
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

addButton(p4, "Refresh Player List", function()
    refreshPlayerList()
    showToast("Players", "Liste yenilendi", "info")
end, 10, CurrentTheme.Button)

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
end, 11, Color3.fromRGB(100, 30, 35))

local getAutoSelectAttacker = addToggle(p4, "Auto Select Attacker", true, function(v)
    autoSelectAttacker = v
end, 12, false)

-- =============================================
-- PAGE 5: COMBAT
-- =============================================
local pCombat = tabPages["COMBAT"]
addLabel(pCombat, "KILL AURA", 1)
local getKillAura = addToggle(pCombat, "Kill Aura", false, nil, 2, true)
local getKillAuraRange = addSlider(pCombat, "Aura Range", 5, 30, 12, nil, 3)
local getKillAuraDelay = addSlider(pCombat, "Aura Delay (ms)", 10, 500, 100, nil, 4)
local getKillAuraTargets = addCycleButton(pCombat, "Targets", {"All", "Selected Only"}, "All", nil, 5)

addSeparator(pCombat, 6)
addLabel(pCombat, "ORBIT SPINBOT", 7)
local getSpinbot = addToggle(pCombat, "Orbit Spinbot", false, nil, 8, true)
local getSpinbotSpeed = addSlider(pCombat, "Orbit Speed", 5, 60, 30, nil, 9)
local getSpinbotRadius = addSlider(pCombat, "Orbit Radius", 1, 10, 3, nil, 10)

addSeparator(pCombat, 11)
addLabel(pCombat, "AUTO ATTACK", 12)
local getAutoAttack = addToggle(pCombat, "Auto Attack Nearest", false, nil, 13, true)
local getAutoAttackRange = addSlider(pCombat, "Auto Attack Range", 3, 20, 8, nil, 14)

addSeparator(pCombat, 15)
addLabel(pCombat, "INFO", 16)
local combatInfo = Instance.new("TextLabel")
combatInfo.Size = UDim2.new(1,-8,0,70)
combatInfo.BackgroundColor3 = CurrentTheme.Button
combatInfo.BackgroundTransparency = InitialTransparency + 0.4
combatInfo.BorderSizePixel = 0
combatInfo.Text = "  Orbit Spinbot: Hedefin etrafinda doner\n  Kill Aura: Etrafindaki herkese vurur\n  Targets = Selected Only yaparsan\n  sadece sectigin kisiye odaklanir"
combatInfo.TextColor3 = CurrentTheme.SubText
combatInfo.TextSize = 10
combatInfo.Font = Enum.Font.Code
combatInfo.TextXAlignment = Enum.TextXAlignment.Left
combatInfo.TextYAlignment = Enum.TextYAlignment.Top
combatInfo.LayoutOrder = 17
combatInfo.ZIndex = 3
combatInfo.Parent = pCombat
Instance.new("UICorner", combatInfo).CornerRadius = UDim.new(0, 4)

-- =============================================
-- PAGE 6: WORLD
-- =============================================
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
addLabel(p5, "PERFORMANCE", 12)
local getFPSBoost = addToggle(p5, "FPS Boost", false, function(state)
    if state then
        for _, obj in ipairs(game:GetDescendants()) do
            pcall(function()
                if obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                elseif obj:IsA("Beam") then
                    obj.Enabled = false
                end
            end)
        end
        Lighting.GlobalShadows = false
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        showToast("FPS Boost", "Grafikler dusuruldu", "success")
    else
        showToast("FPS Boost", "Kapatildi - yeniden baslat", "warning")
    end
end, 13, true)

-- =============================================
-- PAGE 7: CHARACTER
-- =============================================
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

-- =============================================
-- PAGE 8: THEMES
-- =============================================
local p7 = tabPages["THEMES"]
addLabel(p7, "SELECT A THEME", 1)

local themeGrid = Instance.new("Frame")
themeGrid.Size = UDim2.new(1, -8, 0, 400)
themeGrid.BackgroundTransparency = 1
themeGrid.LayoutOrder = 2
themeGrid.ZIndex = 3
themeGrid.Parent = p7

local themeLayout = Instance.new("UIGridLayout", themeGrid)
themeLayout.CellSize = UDim2.new(0.33, -6, 0, 62)
themeLayout.CellPadding = UDim2.new(0, 6, 0, 6)
themeLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function applyTheme(themeName)
    if not Themes[themeName] then return end
    CurrentTheme = Themes[themeName]
    MainFrame.BackgroundColor3 = CurrentTheme.Bg
    mainStroke.Color = CurrentTheme.Button
    topAccent.BackgroundColor3 = CurrentTheme.Primary
    tl.TextColor3 = CurrentTheme.Text
    cl.TextColor3 = CurrentTheme.SubText
    Sidebar.BackgroundColor3 = CurrentTheme.Panel
    profileFrame.BackgroundColor3 = CurrentTheme.Button
    keybindPanel.BackgroundColor3 = CurrentTheme.Panel
    kpHeader.BackgroundColor3 = CurrentTheme.Button
    kpTitle.TextColor3 = CurrentTheme.Text
    showToast("Theme Applied", CurrentTheme.Name, "success")
end

for name, theme in pairs(Themes) do
    local btn = Instance.new("TextButton")
    btn.Name = "ThemeBtn_" .. name
    btn.BackgroundColor3 = CurrentTheme.Bg
    btn.BackgroundTransparency = InitialTransparency
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    btn.Parent = themeGrid
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

    btn.MouseButton1Click:Connect(function()
        applyTheme(name)
    end)
end

-- =============================================
-- PAGE 9: SETTINGS
-- =============================================
local p8 = tabPages["SETTINGS"]

addLabel(p8, "INTERFACE", 1)
local getGuiTransparency = addSlider(p8, "Gui Transparency", 0, 500, Settings.GuiTransparency, function(v)
    Settings.GuiTransparency = v
    MainFrame.BackgroundTransparency = 1 - (v / 500)
end, 2)

addSeparator(p8, 3)
addLabel(p8, "OVERLAY", 4)
local getWatermark = addToggle(p8, "Watermark", true, nil, 5, false)
local getFPSDisplay = addToggle(p8, "FPS Display", true, nil, 6, false)
local getPingDisplay = addToggle(p8, "Ping Display", true, nil, 7, false)

addSeparator(p8, 8)
addLabel(p8, "KEYBIND WINDOW", 9)

local getKeybindVisible = addToggle(p8, "Show Keybind Panel", false, function(v)
    if v then
        updateKeybindPanel()
        keybindPanel.Visible = true
    else
        keybindPanel.Visible = false
    end
end, 10, false)

addSeparator(p8, 11)
addLabel(p8, "SESSION", 12)
local statLabel = Instance.new("TextLabel")
statLabel.Size = UDim2.new(1,-8,0,80)
statLabel.BackgroundColor3 = CurrentTheme.Button
statLabel.BackgroundTransparency = InitialTransparency + 0.4
statLabel.BorderSizePixel = 0
statLabel.Text = "  Status     : ACTIVE\n  Kills      : 0\n  Session    : 0s\n  User       : " .. LocalPlayer.Name
statLabel.TextColor3 = CurrentTheme.SubText
statLabel.TextSize = 10
statLabel.Font = Enum.Font.Code
statLabel.TextXAlignment = Enum.TextXAlignment.Left
statLabel.TextYAlignment = Enum.TextYAlignment.Top
statLabel.LayoutOrder = 13
statLabel.ZIndex = 3
statLabel.Parent = p8
Instance.new("UICorner", statLabel).CornerRadius = UDim.new(0, 4)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local sessionTime = math.floor(tick() - Settings.SessionStart)
            statLabel.Text = "  Status     : ACTIVE\n  Kills      : " .. Settings.Kills .. "\n  Session    : " .. sessionTime .. "s\n  User       : " .. LocalPlayer.Name
        end)
    end
end)

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
-- PLAYER LIST LOGIC
-- =============================================
local playerButtons = {}
local recentlyLeftPlayers = {}
local autoReselect = true
local autoSelectAttacker = true

local function updateSelectCount()
    local c = 0
    for _ in pairs(Settings.SelectedPlayers) do c = c+1 end
    SelectCountLabel.Text = c .. " players selected"
end

local function isSelected(player) return Settings.SelectedPlayers[player.Name] ~= nil end

local function toggleSelect(player, btn)
    if isSelected(player) then
        Settings.SelectedPlayers[player.Name] = nil
        tween(btn, 0.2, {BackgroundColor3 = CurrentTheme.Button, BackgroundTransparency = InitialTransparency + 0.3})
        btn.TextColor3 = CurrentTheme.SubText
    else
        Settings.SelectedPlayers[player.Name] = player
        tween(btn, 0.2, {BackgroundColor3 = CurrentTheme.Button, BackgroundTransparency = InitialTransparency + 0.15})
        btn.TextColor3 = CurrentTheme.Text
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
    btn.BackgroundTransparency = sel and (InitialTransparency + 0.15) or (InitialTransparency + 0.3)
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
    textPad.PaddingLeft = UDim.new(0, 14)

    btn.MouseButton1Click:Connect(function() toggleSelect(player, btn) end)
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

Players.PlayerAdded:Connect(function(player)
    task.wait(0.5)
    if autoReselect and recentlyLeftPlayers[player.Name] then
        Settings.SelectedPlayers[player.Name] = player
        recentlyLeftPlayers[player.Name] = nil
        showToast("Auto Reselect", player.DisplayName .. " yeniden secildi", "info")
    end
    refreshPlayerList()
end)

Players.PlayerRemoving:Connect(function(player)
    if Settings.SelectedPlayers[player.Name] then
        recentlyLeftPlayers[player.Name] = true
    end
    Settings.SelectedPlayers[player.Name] = nil
    if Settings.CurrentTarget == player then Settings.CurrentTarget = nil end
    if Settings.FollowTarget == player then Settings.FollowTarget = nil end
    removeHighlight(player.Name)
    task.wait(0.1)
    refreshPlayerList()
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(refreshPlayerList)

-- =============================================
-- AUTO SELECT ATTACKER (v5: mesafe yok, hasar verene kilit)
-- =============================================
local lastAttackerSelect = 0
local attackerCooldown = 0.5
local lastDamageSource = nil
local lastDamageTime = 0

-- Tüm oyuncuların tool kullanımını izle
local function trackPlayerTool(plr)
    if plr == LocalPlayer then return end
    
    local function watchTool(tool, char)
        if not tool:IsA("Tool") then return end
        tool.Activated:Connect(function()
            local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local thrp = char:FindFirstChild("HumanoidRootPart")
            if lhrp and thrp then
                lastDamageSource = plr
                lastDamageTime = tick()
            end
        end)
    end
    
    local function onChar(char)
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Tool") then
                watchTool(child, char)
            end
        end
        char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                watchTool(child, char)
            end
        end)
    end
    
    plr.CharacterAdded:Connect(onChar)
    if plr.Character then onChar(plr.Character) end
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then trackPlayerTool(plr) end
end
Players.PlayerAdded:Connect(trackPlayerTool)

-- LocalPlayer hasar aldığında tetikle
local function onLocalCharacter(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end

    local lastHealth = hum.Health
    hum.HealthChanged:Connect(function(newHealth)
        local damageTaken = lastHealth - newHealth
        if damageTaken >= 0.5 and autoSelectAttacker then
            local now = tick()
            if now - lastAttackerSelect < attackerCooldown then
                lastHealth = newHealth
                return
            end
            
            local attacker = nil
            
            -- 1. Öncelik: Son 1 saniye içinde tool kullanan oyuncu
            if lastDamageSource and (now - lastDamageTime) < 1 then
                if lastDamageSource.Character then
                    local thum = lastDamageSource.Character:FindFirstChildOfClass("Humanoid")
                    if thum and thum.Health > 0 then
                        attacker = lastDamageSource
                    end
                end
            end
            
            -- 2. Fallback: En yakın oyuncu (mesafe yok!)
            if not attacker then
                local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if lhrp then
                    local closest, shortest = nil, math.huge
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character then
                            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
                            local thum = plr.Character:FindFirstChildOfClass("Humanoid")
                            if thrp and thum and thum.Health > 0 then
                                local dist = (lhrp.Position - thrp.Position).Magnitude
                                if dist < shortest then
                                    shortest = dist
                                    closest = plr
                                end
                            end
                        end
                    end
                    attacker = closest
                end
            end
            
            if attacker then
                lastAttackerSelect = now
                local wasAlreadySelected = Settings.SelectedPlayers[attacker.Name] ~= nil
                
                Settings.SelectedPlayers[attacker.Name] = attacker
                refreshPlayerList()
                
                if getCamlock() then
                    Settings.CurrentTarget = attacker
                    locked = true
                end
                
                if not wasAlreadySelected then
                    showToast("Under Attack", attacker.DisplayName .. " sana vurdu!", "error")
                end
            end
        end
        lastHealth = newHealth
    end)
end

if LocalPlayer.Character then
    onLocalCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onLocalCharacter)

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
    if highlightObjects[player.Name] and highlightObjects[player.Name].Parent == player.Character then
    else
        if highlightObjects[player.Name] then highlightObjects[player.Name]:Destroy() end
        local hl = Instance.new("Highlight")
        hl.Name = "SOUHUB_Highlight"
        hl.FillColor = Settings.HighlightColor
        hl.OutlineColor = Settings.HighlightColor
        hl.FillTransparency = Settings.HighlightFillTransparency
        hl.OutlineTransparency = 0.3
        hl.Adornee = player.Character
        hl.Parent = player.Character
        highlightObjects[player.Name] = hl
    end

    if usingDrawing and not espDrawings[player.Name] then
        local esp = {}
        esp.name = Drawing.new("Text")
        esp.name.Color = Settings.HighlightColor
        esp.name.Size = 14
        esp.name.Center = true
        esp.name.Outline = true
        esp.name.OutlineColor = Color3.fromRGB(0,0,0)
        esp.name.Visible = false
        esp.name.Font = 2

        esp.distance = Drawing.new("Text")
        esp.distance.Color = Color3.fromRGB(200,200,200)
        esp.distance.Size = 12
        esp.distance.Center = true
        esp.distance.Outline = true
        esp.distance.OutlineColor = Color3.fromRGB(0,0,0)
        esp.distance.Visible = false
        esp.distance.Font = 2

        esp.healthText = Drawing.new("Text")
        esp.healthText.Color = Color3.fromRGB(0,255,0)
        esp.healthText.Size = 12
        esp.healthText.Center = true
        esp.healthText.Outline = true
        esp.healthText.OutlineColor = Color3.fromRGB(0,0,0)
        esp.healthText.Visible = false
        esp.healthText.Font = 2

        esp.tracer = Drawing.new("Line")
        esp.tracer.Color = Settings.HighlightColor
        esp.tracer.Thickness = 1
        esp.tracer.Visible = false
        esp.tracer.Transparency = 0.6

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
                            local yOff = -20

                            if getESPNames() then
                                esp.name.Text = player.DisplayName
                                esp.name.Position = Vector2.new(screenPos.X, screenPos.Y + yOff)
                                esp.name.Color = Settings.HighlightColor
                                esp.name.Visible = true
                                yOff = yOff - 16
                            else esp.name.Visible = false end

                            if getESPHealth() then
                                esp.healthText.Text = hp .. "%"
                                esp.healthText.Position = Vector2.new(screenPos.X, screenPos.Y + yOff)
                                esp.healthText.Color = Color3.fromRGB(255*(1-hp/100), 255*(hp/100), 0)
                                esp.healthText.Visible = true
                                yOff = yOff - 14
                            else esp.healthText.Visible = false end

                            if getESPDistance() then
                                esp.distance.Text = dist .. "m"
                                esp.distance.Position = Vector2.new(screenPos.X, screenPos.Y + yOff)
                                esp.distance.Visible = true
                            else esp.distance.Visible = false end

                            if getESPTracers() then
                                esp.tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                                esp.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                                esp.tracer.Color = Settings.HighlightColor
                                esp.tracer.Visible = true
                            else esp.tracer.Visible = false end
                        else
                            if espDrawings[player.Name] then
                                for _, obj in pairs(espDrawings[player.Name]) do
                                    pcall(function() obj.Visible = false end)
                                end
                            end
                        end
                    end
                else removeHighlight(player.Name) end
            else removeHighlight(player.Name) end
        end
    end
end

-- =============================================
-- WALL CHECK + DOWNED
-- =============================================
local function isVisible(targetPart)
    if not getWallCheck() then return true end
    if not targetPart or not targetPart.Parent then return false end
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    rp.IgnoreWater = true
    local result = workspace:Raycast(origin, direction, rp)
    if not result then return true end
    local targetChar = targetPart:FindFirstAncestorOfClass("Model")
    if targetChar and result.Instance:IsDescendantOf(targetChar) then return true end
    return false
end

local function isDowned(character)
    if not character then return false end
    local bodyEffects = character:FindFirstChild("BodyEffects")
    if bodyEffects then
        local ko = bodyEffects:FindFirstChild("K.O")
        if ko and ko.Value == true then return true end
    end
    if character:FindFirstChild("GRABBING_CONSTRAINT") then return true end
    return false
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
                        if isVisible(part) then
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
    end
    if input.KeyCode == Enum.KeyCode.Space and getInfJump() then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
    if input.KeyCode == Enum.KeyCode.End then
        MainFrame.Visible = false
        Watermark.Visible = false
        keybindPanel.Visible = false
        locked = false
        Settings.CurrentTarget = nil
        if fovCircle then pcall(function() fovCircle.Visible = false end) end
        showToast("PANIC", "All features disabled", "error")
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
    if getSpeed() then hum.WalkSpeed = getSpeedValue() end
    if getJumpPower() then
        local jp = getJumpValue()
        hum.JumpPower = jp
        hum.UseJumpPower = true
    end
    if getGodMode() and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    if getAntiFling() and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Velocity.Magnitude > 200 then
            hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if getInfJump() and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if getNoclip() and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- =============================================
-- KILL AURA + ORBIT SPINBOT + AUTO ATTACK
-- =============================================
local lastAuraAttack = 0
local lastAutoAttack = 0
local orbitAngle = 0

RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- ORBIT SPINBOT
    if getSpinbot() then
        local target = nil
        local shortest = getKillAuraRange()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local thum = plr.Character:FindFirstChildOfClass("Humanoid")
                if thrp and thum and thum.Health > 0 then
                    local targets = getKillAuraTargets()
                    local isValid = (targets == "All") or (Settings.SelectedPlayers[plr.Name] ~= nil)
                    if isValid then
                        local dist = (hrp.Position - thrp.Position).Magnitude
                        if dist < shortest then
                            shortest = dist
                            target = plr
                        end
                    end
                end
            end
        end
        
        if target and target.Character then
            local thrp = target.Character:FindFirstChild("HumanoidRootPart")
            if thrp then
                orbitAngle = orbitAngle + math.rad(getSpinbotSpeed())
                local radius = getSpinbotRadius()
                local offset = Vector3.new(
                    math.cos(orbitAngle) * radius,
                    0,
                    math.sin(orbitAngle) * radius
                )
                local targetPos = thrp.Position + offset
                hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos, thrp.Position), 0.3)
            end
        end
    end

    -- KILL AURA
    if getKillAura() then
        local now = tick()
        local delay = getKillAuraDelay() / 1000
        if now - lastAuraAttack >= delay then
            lastAuraAttack = now
            local range = getKillAuraRange()
            local targets = getKillAuraTargets()
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local isValidTarget = (targets == "All") or (Settings.SelectedPlayers[plr.Name] ~= nil)
                        if isValidTarget then
                            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
                            local thum = plr.Character:FindFirstChildOfClass("Humanoid")
                            if thrp and thum and thum.Health > 0 then
                                local dist = (hrp.Position - thrp.Position).Magnitude
                                if dist < range then
                                    pcall(function() tool:Activate() end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- AUTO ATTACK NEAREST
    if getAutoAttack() then
        local now = tick()
        if now - lastAutoAttack >= 0.15 then
            lastAutoAttack = now
            local range = getAutoAttackRange()
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                local closest, shortest2 = nil, range
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        local thum = plr.Character:FindFirstChildOfClass("Humanoid")
                        if thrp and thum and thum.Health > 0 then
                            local dist = (hrp.Position - thrp.Position).Magnitude
                            if dist < shortest2 then
                                shortest2 = dist
                                closest = plr
                            end
                        end
                    end
                end
                if closest then
                    pcall(function() tool:Activate() end)
                end
            end
        end
    end
end)

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
            if not flyBV or flyBV.Parent ~= root then
                if flyBV then pcall(function() flyBV:Destroy() end) end
                flyBV = Instance.new("BodyVelocity")
                flyBV.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                flyBV.Velocity = Vector3.new(0,0,0)
                flyBV.Parent = root
            end
            local speed = getFlySpeed()
            local dir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if dir.Magnitude > 0 then dir = dir.Unit end
            flyBV.Velocity = dir * speed
        end
    else
        if flyBV then pcall(function() flyBV:Destroy() end); flyBV = nil end
    end

    if not getCamlock() then locked = false; Settings.CurrentTarget = nil; return end

    if getAlwaysOn() then
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
                if getSkipDowned() and isDowned(Settings.CurrentTarget.Character) then
                    if getAutoSwitch() then
                        Settings.CurrentTarget = getClosestFromSelected(); locked = Settings.CurrentTarget ~= nil
                    else locked = false; Settings.CurrentTarget = nil end
                    return
                end
                if isVisible(part) then
                    local smoothness = getSmoothness()
                    local predictedPos = getPredictedPosition(part)
                    local targetCFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, smoothness)
                else
                    if getAutoSwitch() then
                        Settings.CurrentTarget = getClosestFromSelected(); locked = Settings.CurrentTarget ~= nil
                    else 
                        locked = false
                        Settings.CurrentTarget = nil 
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
    if getNoFog() then Lighting.FogEnd = 100000 else Lighting.FogEnd = OriginalLighting.FogEnd end
    if getRemoveShadows() then Lighting.GlobalShadows = false else Lighting.GlobalShadows = OriginalLighting.GlobalShadows end
    if getTimeChanger() then Lighting.ClockTime = getTimeValue() else Lighting.ClockTime = OriginalLighting.ClockTime end
end)

pcall(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function() vu:CaptureController(); vu:ClickButton2(Vector2.new()) end)
end)

pcall(function()
    GuiService.MenuOpened:Connect(function()
        menuOpen = true
        MainFrame.Visible = false
        Watermark.Visible = false
        keybindPanel.Visible = false
        if fovCircle then pcall(function() fovCircle.Visible = false end) end
        locked = false
        Settings.CurrentTarget = nil
    end)

    GuiService.MenuClosed:Connect(function()
        menuOpen = false
        MainFrame.Visible = true
        Watermark.Visible = getWatermark()
        if getKeybindVisible() then keybindPanel.Visible = true end
        if fovCircle and getFOVVisible() then pcall(function() fovCircle.Visible = true end) end
    end)
end)

print("[SOU HUB] Winter Edition yuklendi!")

task.spawn(function()
    task.wait(2.0)
    MainFrame.Visible = true
    task.wait(0.7)
    showToast("SOU HUB", "Winter Edition hazir!", "success")
    showToast("Interface", "Press Right Shift to toggle", "info")
end)
