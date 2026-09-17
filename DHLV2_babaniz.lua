--[[
    Sou Hub - Winter Edition v5
    KESIN CALISAN SURUM
]]

print("[Sou Hub] Winter Edition v5 yukleniyor...")

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
    Border = Color3.fromRGB(45, 55, 75),
    Kill = Color3.fromRGB(255, 90, 100),
}

local OriginalLighting = {
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness, FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows, ClockTime = Lighting.ClockTime,
}

local Settings = {
    SpeedHack = false, SpeedHackValue = 16,
    Noclip = false, Flight = false, FlightSpeed = 50,
    Mode = "Camera", Fullbright = false, NoFog = false,
    Camlock = true, Smoothness = 0.450, Prediction = 0.100,
    TargetPart = "Head", FOVVisible = true, FOVRadius = 150,
    WallCheck = false, StickyAim = true, AutoSwitch = true,
    SkipDowned = true, AlwaysOn = false, TriggerBot = false,
    HitboxExpand = false, HitboxSize = 1.3,
    AutoKill = false, AutoLock = false, AutoFire = false,
    InstantKill = false, RapidKill = false, RapidKillDelay = 0.05,
    KillRange = 100, AutoKillTarget = nil,
    ESPEnabled = true, ESPNames = true, ESPHealth = true, ESPDistance = true,
    ESPTracers = true, ESPBoxes = false,
    HighlightFillTransparency = 0.35, HighlightColor = Color3.fromRGB(120,180,255),
    InfJump = false, GodMode = false, AntiFling = false,
    DamageAura = false, DamageAuraRange = 10, DamageAuraAmount = 5,
    AntiAFK = true, Watermark = true, FPSDisplay = true, PingDisplay = true,
    GuiTransparency = 250, TimeChanger = false, TimeValue = 12,
    SpectateTarget = nil, Spectating = false,
    FollowPlayer = false, FollowTarget = nil,
    Kills = 0, SessionStart = tick(),
    SelectedPlayers = {}, CurrentTarget = nil,
}

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

-- KAR
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

-- MAIN
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

minBtn.MouseButton1Click:Connect(function()
    if MainFrame.Size.Y.Offset == 480 then
        tween(MainFrame, 0.3, {Size = UDim2.new(0, 780, 0, 50)})
    else
        tween(MainFrame, 0.3, {Size = UDim2.new(0, 780, 0, 480)})
    end
end)

-- DRAG
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

-- TAB BAR
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
TabBarScroll.CanvasSize = UDim2.new(0, 2000, 0, 0)
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

-- CONTENT AREA
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -40, 1, -130)
ContentArea.Position = UDim2.new(0, 20, 0, 105)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 3
ContentArea.Parent = MainFrame

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

-- ============================================
-- SAYFALARI OLUSTUR
-- ============================================
local function createPage(visible)
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

local pages = {}

-- VISUAL
pages.Visual = createPage(true)
addSection(pages.Visual, "❄ Visual", 1)
addToggle(pages.Visual, "Speed Hack", false, function(v) Settings.SpeedHack = v end, 2)
addSlider(pages.Visual, "Speed Value", 0, 1000, 16, function(v) Settings.SpeedHackValue = v end, 3)
addToggle(pages.Visual, "Noclip", false, function(v) Settings.Noclip = v end, 4)
addToggle(pages.Visual, "Flight", false, function(v) Settings.Flight = v end, 5)
addSlider(pages.Visual, "Flight Speed", 0, 1000, 50, function(v) Settings.FlightSpeed = v end, 6)
addToggle(pages.Visual, "Fullbright", false, function(v) Settings.Fullbright = v end, 7)
addToggle(pages.Visual, "No Fog", false, function(v) Settings.NoFog = v end, 8)

-- AIMBOT
pages.AimBot = createPage()
addSection(pages.AimBot, "❄ Camlock", 1)
addToggle(pages.AimBot, "Camlock System", true, function(v) Settings.Camlock = v end, 2)
addToggle(pages.AimBot, "Wall Check", false, function(v) Settings.WallCheck = v end, 3)
addToggle(pages.AimBot, "Sticky Aim", true, function(v) Settings.StickyAim = v end, 4)
addToggle(pages.AimBot, "Auto Switch", true, function(v) Settings.AutoSwitch = v end, 5)
addToggle(pages.AimBot, "Skip Downed", true, function(v) Settings.SkipDowned = v end, 6)
addToggle(pages.AimBot, "Always On", false, function(v) Settings.AlwaysOn = v end, 7)
addSection(pages.AimBot, "Parameters", 8)
addSlider(pages.AimBot, "Smoothness", 0.05, 1.0, 0.450, function(v) Settings.Smoothness = v end, 9)
addSlider(pages.AimBot, "Prediction", 0.0, 0.5, 0.100, function(v) Settings.Prediction = v end, 10)
addSection(pages.AimBot, "FOV", 11)
addToggle(pages.AimBot, "FOV Circle", true, function(v) Settings.FOVVisible = v end, 12)
addSlider(pages.AimBot, "FOV Radius", 20, 500, 150, function(v) Settings.FOVRadius = v end, 13)

-- AUTOKILL
pages.AutoKill = createPage()
addSection(pages.AutoKill, "⚔ AUTO ELIMINATION", 1, Theme.Kill)
addToggle(pages.AutoKill, "AUTOKILL", false, function(state)
    Settings.AutoKill = state
    if state then
        showToast("AUTOKILL", "Hedefe kilitleniyor...", "kill")
        for _, plr in pairs(Settings.SelectedPlayers) do
            if plr and plr.Character then Settings.AutoKillTarget = plr; break end
        end
    end
end, 2)
addToggle(pages.AutoKill, "Auto Lock", true, function(v) Settings.AutoLock = v end, 3)
addToggle(pages.AutoKill, "Auto Fire", true, function(v) Settings.AutoFire = v end, 4)
addToggle(pages.AutoKill, "Instant Kill", true, function(v) Settings.InstantKill = v end, 5)
addToggle(pages.AutoKill, "Rapid Kill", false, function(v) Settings.RapidKill = v end, 6)
addSlider(pages.AutoKill, "Kill Range", 5, 500, 100, function(v) Settings.KillRange = v end, 7)

-- ESP
pages.ESP = createPage()
addSection(pages.ESP, "❄ ESP", 1)
addToggle(pages.ESP, "ESP Enabled", true, function(v) Settings.ESPEnabled = v end, 2)
addToggle(pages.ESP, "Name Tags", true, function(v) Settings.ESPNames = v end, 3)
addToggle(pages.ESP, "Health Display", true, function(v) Settings.ESPHealth = v end, 4)
addToggle(pages.ESP, "Distance Display", true, function(v) Settings.ESPDistance = v end, 5)
addToggle(pages.ESP, "Tracers", true, function(v) Settings.ESPTracers = v end, 6)
addSlider(pages.ESP, "Fill Transparency", 0, 1, 0.35, function(v) Settings.HighlightFillTransparency = v end, 7)

-- MOVEMENT
pages.Movement = createPage()
addSection(pages.Movement, "❄ Movement", 1)
addToggle(pages.Movement, "Infinite Jump", false, function(v) Settings.InfJump = v end, 2)
addSection(pages.Movement, "Teleport", 3)
addButton(pages.Movement, "Teleport to Mouse", function()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)) end
    end
end, 4)
addButton(pages.Movement, "Teleport to Target", function()
    local target = Settings.AutoKillTarget or Settings.CurrentTarget
    if target and target.Character then
        local thrp = target.Character:FindFirstChild("HumanoidRootPart")
        local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if thrp and lhrp then lhrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 3) end
    end
end, 5)

-- PLAYERS
pages.Players = createPage()
addSection(pages.Players, "❄ Players", 1)

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
SelectCountLabel.Parent = pages.Players

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, 0, 0, 28)
btnRow.BackgroundTransparency = 1
btnRow.LayoutOrder = 3
btnRow.ZIndex = 4
btnRow.Parent = pages.Players

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
SearchBox.Parent = pages.Players
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, 0, 0, 180)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.BorderSizePixel = 0
PlayerScroll.ScrollBarThickness = 3
PlayerScroll.ScrollBarImageColor3 = Theme.Accent
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerScroll.LayoutOrder = 5
PlayerScroll.ZIndex = 4
PlayerScroll.Active = true
PlayerScroll.Parent = pages.Players

local PlayerListLayout = Instance.new("UIListLayout", PlayerScroll)
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 3)

addSection(pages.Players, "Actions", 6)
addButton(pages.Players, "Goto First Selected", function()
    for _, plr in pairs(Settings.SelectedPlayers) do
        if plr and plr.Character then
            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if thrp and lhrp then lhrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 3) end
            break
        end
    end
end, 7)
addButton(pages.Players, "Bring First Selected", function()
    for _, plr in pairs(Settings.SelectedPlayers) do
        if plr and plr.Character then
            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if thrp and lhrp then thrp.CFrame = lhrp.CFrame * CFrame.new(0, 0, 5) end
            break
        end
    end
end, 8)
addToggle(pages.Players, "Follow First Selected", false, function(state)
    Settings.FollowPlayer = state
    if state then
        for _, plr in pairs(Settings.SelectedPlayers) do
            if plr and plr.Character then Settings.FollowTarget = plr; break end
        end
    else Settings.FollowTarget = nil end
end, 9)
addButton(pages.Players, "Kill First Selected", function()
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

-- WORLD
pages.World = createPage()
addSection(pages.World, "❄ World", 1)
addButton(pages.World, "Server Rejoin", function()
    task.wait(0.5)
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
end, 2)
addButton(pages.World, "Server Hop", function()
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
addSection(pages.World, "Time", 4)
addToggle(pages.World, "Time Changer", false, function(v) Settings.TimeChanger = v end, 5)
addSlider(pages.World, "Time (0-24)", 0, 24, 12, function(v) Settings.TimeValue = v end, 6)

-- CHARACTER
pages.Character = createPage()
addSection(pages.Character, "❄ Character", 1)
addToggle(pages.Character, "God Mode", false, function(v) Settings.GodMode = v end, 2)
addToggle(pages.Character, "Anti Fling", false, function(v) Settings.AntiFling = v end, 3)
addSection(pages.Character, "Damage Aura", 4)
addToggle(pages.Character, "Damage Aura", false, function(v) Settings.DamageAura = v end, 5)
addSlider(pages.Character, "Aura Range", 3, 30, 10, function(v) Settings.DamageAuraRange = v end, 6)
addSlider(pages.Character, "Damage Amount", 1, 50, 5, function(v) Settings.DamageAuraAmount = v end, 7)
addSection(pages.Character, "Actions", 8)
addButton(pages.Character, "Respawn", function()
    pcall(function() LocalPlayer.Character:BreakJoints() end)
end, 9)
addButton(pages.Character, "Full Heal", function()
    pcall(function()
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end)
end, 10)

-- SPECTATE
pages.Spectate = createPage()
addSection(pages.Spectate, "❄ Spectate Mode", 1)

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
specStatusLabel.Parent = pages.Spectate

local specScroll = Instance.new("ScrollingFrame")
specScroll.Size = UDim2.new(1, 0, 0, 180)
specScroll.BackgroundTransparency = 1
specScroll.BorderSizePixel = 0
specScroll.ScrollBarThickness = 3
specScroll.ScrollBarImageColor3 = Theme.Accent
specScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
specScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
specScroll.LayoutOrder = 3
specScroll.ZIndex = 4
specScroll.Active = true
specScroll.Parent = pages.Spectate
local specLayout = Instance.new("UIListLayout", specScroll)
specLayout.SortOrder = Enum.SortOrder.LayoutOrder
specLayout.Padding = UDim.new(0, 3)

addButton(pages.Spectate, "Stop Spectating", function()
    Settings.Spectating = false
    Settings.SpectateTarget = nil
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end)
    specStatusLabel.Text = "Not Spectating"
    specStatusLabel.TextColor3 = Theme.SubText
end, 4)

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
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
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
refreshSpecList()
Players.PlayerAdded:Connect(function() task.wait(0.5); refreshSpecList() end)
Players.PlayerRemoving:Connect(function(player)
    if Settings.SpectateTarget == player then
        Settings.Spectating = false
        Settings.SpectateTarget = nil
    end
    task.wait(0.1)
    refreshSpecList()
end)

-- THEMES
pages.Themes = createPage()
addSection(pages.Themes, "❄ Themes", 1)
local themeGrid = Instance.new("Frame")
themeGrid.Size = UDim2.new(1, 0, 0, 240)
themeGrid.BackgroundTransparency = 1
themeGrid.LayoutOrder = 2
themeGrid.ZIndex = 4
themeGrid.Parent = pages.Themes
local themeGridLayout = Instance.new("UIGridLayout", themeGrid)
themeGridLayout.CellSize = UDim2.new(0.25, -6, 0, 60)
themeGridLayout.CellPadding = UDim.new(0, 6)

local themesList = {
    {Name="Winter",   Primary=Color3.fromRGB(140,168,200)},
    {Name="Obsidian", Primary=Color3.fromRGB(100,110,130)},
    {Name="Cobalt",   Primary=Color3.fromRGB(50,100,180)},
    {Name="Noir",     Primary=Color3.fromRGB(80,80,80)},
    {Name="Crimson",  Primary=Color3.fromRGB(140,30,50)},
    {Name="Emerald",  Primary=Color3.fromRGB(40,140,100)},
    {Name="Violet",   Primary=Color3.fromRGB(110,60,180)},
    {Name="Slate",    Primary=Color3.fromRGB(70,90,110)},
    {Name="Halloween",Primary=Color3.fromRGB(255,107,26)},
    {Name="Desert",   Primary=Color3.fromRGB(200,148,74)},
    {Name="Ocean",    Primary=Color3.fromRGB(30,144,255)},
    {Name="Sakura",   Primary=Color3.fromRGB(245,165,184)},
}

for _, theme in ipairs(themesList) do
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = theme.Primary
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = theme.Name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    btn.Parent = themeGrid
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        Settings.HighlightColor = theme.Primary
        Theme.Accent = theme.Primary
        showToast("Theme", theme.Name .. " uygulandı", "success")
    end)
end

-- MISC
pages.Misc = createPage()
addSection(pages.Misc, "❄ Miscellaneous", 1)
addToggle(pages.Misc, "Anti-AFK", true, function(v) Settings.AntiAFK = v end, 2)
addToggle(pages.Misc, "Watermark", true, function(v) Settings.Watermark = v end, 3)
addToggle(pages.Misc, "FPS Display", true, function(v) Settings.FPSDisplay = v end, 4)
addToggle(pages.Misc, "Ping Display", true, function(v) Settings.PingDisplay = v end, 5)
addSlider(pages.Misc, "GUI Transparency", 0, 500, 250, function(v)
    Settings.GuiTransparency = v
    MainFrame.BackgroundTransparency = 1 - (v / 500)
end, 6)
addSection(pages.Misc, "Config", 7)
addButton(pages.Misc, "Save Config", function()
    if writefile then
        pcall(function()
            local data = {SpeedValue = Settings.SpeedHackValue, KillRange = Settings.KillRange}
            writefile("SouHub_config.json", HttpService:JSONEncode(data))
        end)
        showToast("Config", "Kaydedildi", "success")
    end
end, 8)
addButton(pages.Misc, "Load Config", function()
    if readfile and isfile then
        pcall(function()
            if isfile("SouHub_config.json") then
                local data = HttpService:JSONDecode(readfile("SouHub_config.json"))
                showToast("Config", "Yuklendi", "success")
            end
        end)
    end
end, 9)

-- ============================================
-- TAB BUTONLARI (EN SON!)
-- ============================================
local tabNames = {"Visual", "AimBot", "AutoKill", "ESP", "Movement", "Players", "World", "Character", "Spectate", "Themes", "Misc"}
local tabButtons = {}
local activeTab = "Visual"

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
    tabBtn.LayoutOrder = i
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
    
    tabBtn.MouseButton1Click:Connect(function()
        if activeTab == name then return end
        for n, page in pairs(pages) do page.Visible = false end
        for n, btn in pairs(tabButtons) do
            local isActive = (n == name)
            tween(btn, 0.2, {TextColor3 = isActive and Theme.Text or Theme.SubText})
            local ind = btn:FindFirstChild("Indicator")
            if ind then
                tween(ind, 0.25, {Size = isActive and UDim2.new(0.6, 0, 0, 2) or UDim2.new(0, 0, 0, 2)})
            end
        end
        local targetPage = pages[name]
        if targetPage then
            targetPage.Visible = true
        end
        activeTab = name
    end)
end

-- ============================================
-- LOOPS
-- ============================================
local flyBV = nil
local originalSizes = {}

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

pcall(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function() vu:CaptureController(); vu:ClickButton2(Vector2.new()) end)
end)

-- PLAYER LIST
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

-- ESP
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

-- FOV CIRCLE
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

-- AIMBOT
local locked = falselocal function isVisible(targetPart)
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
    return part.Position + (vel * Settings.Prediction)
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
                local predictedPos = getPredictedPosition(part)
                local targetCFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.Smoothness)
            end
        end
    end
end)

-- SPECTATE LOOP
RunService.Heartbeat:Connect(function()
    if Settings.Spectating and Settings.SpectateTarget then
        if Settings.SpectateTarget.Character and Settings.SpectateTarget.Character:FindFirstChildOfClass("Humanoid") then
            local hum = Settings.SpectateTarget.Character:FindFirstChildOfClass("Humanoid")
            if Camera.CameraSubject ~= hum then Camera.CameraSubject = hum end
        end
    end
end)

-- WATERMARK
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

print("[Sou Hub] Winter Edition v5 yuklendi!")

task.wait(0.5)
showToast("❄ Sou Hub", "Winter Edition hazir!", "success")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❄ Sou Hub",
        Text = "Winter Edition loaded!",
        Duration = 5
    })
end)
