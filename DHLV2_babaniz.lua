--[[
    Sou Hub - Winter Edition
    MatrixHub tarzi UI
    Kar temali + kar yagisi efekti
]]

print("[Sou Hub] Winter Edition yukleniyor...")

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
-- KAR TEMASI RENKLERI
-- =============================================
local Theme = {
    Bg = Color3.fromRGB(15, 20, 32),           -- Koyu gece mavisi
    Panel = Color3.fromRGB(22, 28, 42),        -- Panel
    Header = Color3.fromRGB(18, 24, 38),       -- Header
    Button = Color3.fromRGB(32, 40, 58),       -- Buton
    ButtonHover = Color3.fromRGB(42, 52, 72),  -- Buton hover
    Slider = Color3.fromRGB(30, 38, 55),       -- Slider arka
    SliderFill = Color3.fromRGB(120, 180, 255),-- Slider dolu (buz mavisi)
    Text = Color3.fromRGB(230, 240, 255),      -- Ana text (kar beyazi)
    SubText = Color3.fromRGB(140, 160, 190),   -- Alt text
    Accent = Color3.fromRGB(120, 180, 255),    -- Vurgu (buz)
    Accent2 = Color3.fromRGB(180, 220, 255),   -- Acik vurgu
    ToggleOn = Color3.fromRGB(120, 180, 255),  -- Toggle acik
    ToggleOff = Color3.fromRGB(50, 60, 80),    -- Toggle kapali
    Snow = Color3.fromRGB(255, 255, 255),      -- Kar tanesi
    Border = Color3.fromRGB(45, 55, 75),       -- Kenarlik
}

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
    -- Visual
    SpeedHack = false,
    SpeedHackValue = 16,
    Noclip = false,
    NoclipSpeed = 0,
    Flight = false,
    FlightSpeed = 0,
    Mode = "Camera",
    
    -- AimBot
    AimBotEnabled = false,
    Smoothness = 0.450,
    FOVRadius = 150,
    TargetPart = "Head",
    Prediction = 0.100,
    WallCheck = false,
    StickyAim = true,
    SkipDowned = true,
    
    -- Misc
    TeleportToPlayer = false,
    AntiAFK = true,
    Fullbright = false,
    NoFog = false,
    
    -- Whitelist
    WhitelistEnabled = false,
    Whitelist = {},
    
    -- Extra
    SelectedPlayers = {},
    CurrentTarget = nil,
}

-- =============================================
-- CLEANUP
-- =============================================
for _, loc in ipairs({game:GetService("CoreGui"), LocalPlayer:FindFirstChild("PlayerGui")}) do
    pcall(function() local o = loc:FindFirstChild("SouHub_Winter"); if o then o:Destroy() end end)
end
pcall(function() if gethui then local o = gethui():FindFirstChild("SouHub_Winter"); if o then o:Destroy() end end end)

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

-- =============================================
-- KAR YAGISI EFEKTI
-- =============================================
local snowContainer = Instance.new("Frame")
snowContainer.Name = "SnowContainer"
snowContainer.Size = UDim2.new(1, 0, 1, 0)
snowContainer.BackgroundTransparency = 1
snowContainer.ZIndex = 0
snowContainer.Parent = ScreenGui

-- Kar taneleri olustur
local function createSnowflake()
    local snowflake = Instance.new("TextLabel")
    snowflake.Size = UDim2.new(0, math.random(8, 18), 0, math.random(8, 18))
    snowflake.Position = UDim2.new(math.random(), 0, -0.05, 0)
    snowflake.BackgroundTransparency = 1
    snowflake.Text = "❄"
    snowflake.TextColor3 = Theme.Snow
    snowflake.TextSize = math.random(8, 18)
    snowflake.TextTransparency = math.random(3, 7) / 10
    snowflake.Font = Enum.Font.GothamBold
    snowflake.Rotation = math.random(0, 360)
    snowflake.ZIndex = 1
    snowflake.Parent = snowContainer
    
    local fallDuration = math.random(6, 14)
    local drift = math.random(-20, 20) / 100
    local rotateSpeed = math.random(-180, 180)
    
    local targetPos = UDim2.new(snowflake.Position.X.Scale + drift, 0, 1.1, 0)
    
    tween(snowflake, fallDuration, {
        Position = targetPos,
        Rotation = snowflake.Rotation + rotateSpeed
    }, Enum.EasingStyle.Linear)
    
    task.delay(fallDuration, function()
        if snowflake and snowflake.Parent then
            snowflake:Destroy()
        end
    end)
end

-- Surekli kar yagisi
task.spawn(function()
    while snowContainer.Parent do
        createSnowflake()
        task.wait(math.random(5, 15) / 100)
    end
end)

-- =============================================
-- ANA FRAME (MatrixHub tarzi - genis, yatay)
-- =============================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
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

-- Hafif glow
local glowStroke = Instance.new("UIStroke", MainFrame)
glowStroke.Color = Theme.Accent
glowStroke.Thickness = 3
glowStroke.Transparency = 0.85

task.spawn(function()
    while MainFrame.Parent do
        tween(glowStroke, 2.5, {Transparency = 0.95}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.5)
        tween(glowStroke, 2.5, {Transparency = 0.75}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.5)
    end
end)

-- =============================================
-- HEADER (Sou Hub yazisi + icons)
-- =============================================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 50)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Theme.Header
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.ZIndex = 5
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

-- Header alt cizgisi
local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.BackgroundColor3 = Theme.Border
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 6
headerLine.Parent = Header

-- Logo / Baslik
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

-- Discord icon
local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0, 32, 0, 32)
discordBtn.Position = UDim2.new(1, -120, 0.5, -16)
discordBtn.BackgroundColor3 = Theme.Button
discordBtn.BackgroundTransparency = 0.5
discordBtn.BorderSizePixel = 0
discordBtn.Text = "◆"
discordBtn.TextColor3 = Theme.Text
discordBtn.TextSize = 18
discordBtn.Font = Enum.Font.GothamBold
discordBtn.AutoButtonColor = false
discordBtn.ZIndex = 7
discordBtn.Parent = Header
Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 6)

-- Settings icon
local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.new(0, 32, 0, 32)
settingsBtn.Position = UDim2.new(1, -80, 0.5, -16)
settingsBtn.BackgroundColor3 = Theme.Button
settingsBtn.BackgroundTransparency = 0.5
settingsBtn.BorderSizePixel = 0
settingsBtn.Text = "⚙"
settingsBtn.TextColor3 = Theme.Text
settingsBtn.TextSize = 18
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.AutoButtonColor = false
settingsBtn.ZIndex = 7
settingsBtn.Parent = Header
Instance.new("UICorner", settingsBtn).CornerRadius = UDim.new(0, 6)

-- Minimize butonu
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

-- Hover efektleri
for _, btn in ipairs({discordBtn, settingsBtn, minBtn}) do
    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, {BackgroundColor3 = Theme.ButtonHover, BackgroundTransparency = 0.3})
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, {BackgroundColor3 = Theme.Button, BackgroundTransparency = 0.5})
    end)
end

-- Minimize butonuna bas
local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        tween(MainFrame, 0.3, {Size = UDim2.new(0, 780, 0, 50)}, Enum.EasingStyle.Quint)
    else
        tween(MainFrame, 0.3, {Size = UDim2.new(0, 780, 0, 480)}, Enum.EasingStyle.Quint)
    end
end)

-- =============================================
-- DRAGGABLE
-- =============================================
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local d = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- =============================================
-- TAB BAR (Header altinda)
-- =============================================
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 45)
TabBar.Position = UDim2.new(0, 0, 0, 50)
TabBar.BackgroundColor3 = Theme.Bg
TabBar.BackgroundTransparency = 0.5
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 5
TabBar.Parent = MainFrame

local tabNames = {"Visual", "AimBot", "Misc", "Whitelist", "Teleport"}
local tabButtons = {}
local tabContents = {}
local activeTab = "Visual"

local tabLayout = Instance.new("UIListLayout", TabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 2)
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
local tabPad = Instance.new("UIPadding", TabBar)
tabPad.PaddingLeft = UDim.new(0, 20)

for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 110, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tabBtn.BackgroundTransparency = 1
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = name
    tabBtn.TextColor3 = Theme.SubText
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.AutoButtonColor = false
    tabBtn.ZIndex = 6
    tabBtn.Parent = TabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    tabButtons[name] = tabBtn
    
    -- Aktif tab gostergesi (alt cizgi)
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 0, 0, 2)
    indicator.Position = UDim2.new(0.5, 0, 1, -2)
    indicator.AnchorPoint = Vector2.new(0.5, 0)
    indicator.BackgroundColor3 = Theme.Accent
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 7
    indicator.Parent = tabBtn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 1)
    
    if i == 1 then
        tabBtn.TextColor3 = Theme.Text
        indicator.Size = UDim2.new(0.6, 0, 0, 2)
    end
    
    tabBtn.MouseEnter:Connect(function()
        if activeTab ~= name then
            tween(tabBtn, 0.15, {TextColor3 = Theme.Accent2})
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if activeTab ~= name then
            tween(tabBtn, 0.15, {TextColor3 = Theme.SubText})
        end
    end)
end

-- Tab alt cizgisi
local tabLine = Instance.new("Frame")
tabLine.Size = UDim2.new(1, 0, 0, 1)
tabLine.Position = UDim2.new(0, 0, 1, -1)
tabLine.BackgroundColor3 = Theme.Border
tabLine.BorderSizePixel = 0
tabLine.ZIndex = 6
tabLine.Parent = TabBar

-- =============================================
-- CONTENT AREA
-- =============================================
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -40, 1, -130)
ContentArea.Position = UDim2.new(0, 20, 0, 105)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 3
ContentArea.Parent = MainFrame

-- =============================================
-- UI BUILDERS
-- =============================================
local uiElements = {}

-- Toggle (iOS tarzi)
local function addToggle(parent, name, default, callback, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order or 0
    row.ZIndex = 4
    row.Parent = parent
    
    -- Isim label
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.7, 0, 1, 0)
    nameLbl.Position = UDim2.new(0, 0, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = Theme.Text
    nameLbl.TextSize = 13
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 5
    nameLbl.Parent = row
    
    -- Toggle switch (sagda)
    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 44, 0, 22)
    switchBg.Position = UDim2.new(1, -44, 0.5, -11)
    switchBg.BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff
    switchBg.BackgroundTransparency = 0.1
    switchBg.BorderSizePixel = 0
    switchBg.Text = ""
    switchBg.AutoButtonColor = false
    switchBg.ZIndex = 5
    switchBg.Parent = row
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    
    -- Toggle knob
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 6
    knob.Parent = switchBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local state = default
    
    local function doToggle()
        state = not state
        if state then
            tween(switchBg, 0.25, {BackgroundColor3 = Theme.ToggleOn, BackgroundTransparency = 0.1})
            tween(knob, 0.25, {Position = UDim2.new(1, -20, 0.5, -9)}, Enum.EasingStyle.Back)
        else
            tween(switchBg, 0.25, {BackgroundColor3 = Theme.ToggleOff, BackgroundTransparency = 0.3})
            tween(knob, 0.25, {Position = UDim2.new(0, 2, 0.5, -9)}, Enum.EasingStyle.Back)
        end
        if callback then callback(state) end
    end
    
    switchBg.MouseButton1Click:Connect(doToggle)
    nameLbl.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            doToggle()
        end
    end)
    
    table.insert(uiElements, {element=switchBg, type="toggleSwitch"})
    table.insert(uiElements, {element=nameLbl, type="toggleLabel"})
    
    return function() return state end, function(v)
        state = v
        if state then
            tween(switchBg, 0.25, {BackgroundColor3 = Theme.ToggleOn, BackgroundTransparency = 0.1})
            tween(knob, 0.25, {Position = UDim2.new(1, -20, 0.5, -9)})
        else
            tween(switchBg, 0.25, {BackgroundColor3 = Theme.ToggleOff, BackgroundTransparency = 0.3})
            tween(knob, 0.25, {Position = UDim2.new(0, 2, 0.5, -9)})
        end
        if callback then callback(state) end
    end
end

-- Slider (MatrixHub tarzi)
local function addSlider(parent, name, min, max, default, callback, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 52)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order or 0
    container.ZIndex = 4
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 18)
    label.Position = UDim2.new(0, 0, 0, 0)
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
    bg.Size = UDim2.new(1, 0, 0, 8)
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
    
    -- Fill gradient
    local fillGrad = Instance.new("UIGradient", fill)
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(1, Theme.Accent2),
    })
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default-min)/(max-min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 6
    knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local knobStroke = Instance.new("UIStroke", knob)
    knobStroke.Color = Theme.Accent
    knobStroke.Thickness = 2
    
    -- Tooltip (MatrixHub'daki gibi)
    local tooltip = Instance.new("Frame")
    tooltip.Size = UDim2.new(0, 160, 0, 60)
    tooltip.Position = UDim2.new(0, 20, 0, -70)
    tooltip.BackgroundColor3 = Theme.Header
    tooltip.BackgroundTransparency = 0.1
    tooltip.BorderSizePixel = 0
    tooltip.Visible = false
    tooltip.ZIndex = 100
    tooltip.Parent = bg
    Instance.new("UICorner", tooltip).CornerRadius = UDim.new(0, 6)
    local tooltipStroke = Instance.new("UIStroke", tooltip)
    tooltipStroke.Color = Theme.Accent
    tooltipStroke.Thickness = 1
    
    local tipTitle = Instance.new("TextLabel")
    tipTitle.Size = UDim2.new(1, -12, 0, 18)
    tipTitle.Position = UDim2.new(0, 6, 0, 6)
    tipTitle.BackgroundTransparency = 1
    tipTitle.Text = name .. " " .. string.format("%.3f", default)
    tipTitle.TextColor3 = Theme.Text
    tipTitle.TextSize = 11
    tipTitle.Font = Enum.Font.GothamBold
    tipTitle.TextXAlignment = Enum.TextXAlignment.Left
    tipTitle.ZIndex = 101
    tipTitle.Parent = tooltip
    
    local tipRange = Instance.new("TextLabel")
    tipRange.Size = UDim2.new(1, -12, 0, 14)
    tipRange.Position = UDim2.new(0, 6, 0, 24)
    tipRange.BackgroundTransparency = 1
    tipRange.Text = "Range: " .. min .. " - " .. max
    tipRange.TextColor3 = Theme.Accent2
    tipRange.TextSize = 10
    tipRange.Font = Enum.Font.Gotham
    tipRange.TextXAlignment = Enum.TextXAlignment.Left
    tipRange.ZIndex = 101
    tipRange.Parent = tooltip
    
    local tipHint = Instance.new("TextLabel")
    tipHint.Size = UDim2.new(1, -12, 0, 14)
    tipHint.Position = UDim2.new(0, 6, 0, 40)
    tipHint.BackgroundTransparency = 1
    tipHint.Text = "Click and drag to adjust"
    tipHint.TextColor3 = Theme.SubText
    tipHint.TextSize = 9
    tipHint.Font = Enum.Font.Gotham
    tipHint.TextXAlignment = Enum.TextXAlignment.Left
    tipHint.ZIndex = 101
    tipHint.Parent = tooltip
    
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
        tipTitle.Text = name .. " " .. string.format("%.3f", value)
        if callback then callback(value) end
    end
    
    bg.MouseButton1Down:Connect(function(x)
        sliding = true
        update(x)
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    
    -- Tooltip hover
    bg.MouseEnter:Connect(function()
        tooltip.Visible = true
        tooltip.Position = UDim2.new(0, 20, 0, -70)
        tooltip.BackgroundTransparency = 1
        tween(tooltip, 0.2, {BackgroundTransparency = 0.1})
    end)
    bg.MouseLeave:Connect(function()
        tween(tooltip, 0.15, {BackgroundTransparency = 1})
        task.delay(0.15, function()
            if tooltip.BackgroundTransparency >= 0.99 then
                tooltip.Visible = false
            end
        end)
    end)
    
    table.insert(uiElements, {element=fill, type="sliderFill"})
    table.insert(uiElements, {element=bg, type="sliderBg"})
    table.insert(uiElements, {element=label, type="sliderLabel"})
    table.insert(uiElements, {element=valueLbl, type="sliderValue"})
    
    return function() return value end
end

-- Section header
local function addSection(parent, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Text
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0
    lbl.ZIndex = 5
    lbl.Parent = parent
    
    table.insert(uiElements, {element=lbl, type="sectionLabel"})
    return lbl
end

-- =============================================
-- TAB 1: VISUAL
-- =============================================
local visualPage = Instance.new("ScrollingFrame")
visualPage.Size = UDim2.new(0.5, -10, 1, 0)
visualPage.Position = UDim2.new(0, 0, 0, 0)
visualPage.BackgroundTransparency = 1
visualPage.BorderSizePixel = 0
visualPage.ScrollBarThickness = 3
visualPage.ScrollBarImageColor3 = Theme.Accent
visualPage.CanvasSize = UDim2.new(0, 0, 0, 0)
visualPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
visualPage.Visible = true
visualPage.ZIndex = 4
visualPage.Parent = ContentArea

local visualLayout = Instance.new("UIListLayout", visualPage)
visualLayout.SortOrder = Enum.SortOrder.LayoutOrder
visualLayout.Padding = UDim.new(0, 6)

addSection(visualPage, "Movement", 1)
local getSpeedHack = addToggle(visualPage, "Speed Hack", false, function(v) Settings.SpeedHack = v end, 2)
local getSpeedHackValue = addSlider(visualPage, "Speed Hack Value", 0, 1000, 16, function(v) Settings.SpeedHackValue = v end, 3)
local getNoclip = addToggle(visualPage, "Noclip", false, function(v) Settings.Noclip = v end, 4)
local getNoclipSpeed = addSlider(visualPage, "NoClip Speed", 0, 1000, 0, function(v) Settings.NoclipSpeed = v end, 5)
local getFlight = addToggle(visualPage, "Flight", false, function(v) Settings.Flight = v end, 6)
local getFlightSpeed = addSlider(visualPage, "Flight Speed", 0, 1000, 0, function(v) Settings.FlightSpeed = v end, 7)

local modeOptions = {"Camera", "Movement", "Velocity"}
local modeIdx = 1
local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(1, 0, 0, 32)
modeBtn.BackgroundColor3 = Theme.Button
modeBtn.BackgroundTransparency = 0.3
modeBtn.BorderSizePixel = 0
modeBtn.Text = ""
modeBtn.AutoButtonColor = false
modeBtn.LayoutOrder = 8
modeBtn.ZIndex = 5
modeBtn.Parent = visualPage
Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 6)
local modeLbl = Instance.new("TextLabel")
modeLbl.Size = UDim2.new(0.5, 0, 1, 0)
modeLbl.Position = UDim2.new(0, 12, 0, 0)
modeLbl.BackgroundTransparency = 1
modeLbl.Text = "Mode"
modeLbl.TextColor3 = Theme.Text
modeLbl.TextSize = 12
modeLbl.Font = Enum.Font.GothamSemibold
modeLbl.TextXAlignment = Enum.TextXAlignment.Left
modeLbl.ZIndex = 6
modeLbl.Parent = modeBtn
local modeValue = Instance.new("TextLabel")
modeValue.Size = UDim2.new(0.5, -12, 1, 0)
modeValue.Position = UDim2.new(0.5, 0, 0, 0)
modeValue.BackgroundTransparency = 1
modeValue.Text = modeOptions[modeIdx]
modeValue.TextColor3 = Theme.Accent2
modeValue.TextSize = 12
modeValue.Font = Enum.Font.GothamBold
modeValue.TextXAlignment = Enum.TextXAlignment.Right
modeValue.ZIndex = 6
modeValue.Parent = modeBtn
modeBtn.MouseButton1Click:Connect(function()
    modeIdx = modeIdx % #modeOptions + 1
    modeValue.Text = modeOptions[modeIdx]
    Settings.Mode = modeOptions[modeIdx]
end)

-- =============================================
-- TAB 2: AIMBOT
-- =============================================
local aimbotPage = Instance.new("ScrollingFrame")
aimbotPage.Size = UDim2.new(0.5, -10, 1, 0)
aimbotPage.Position = UDim2.new(0, 0, 0, 0)
aimbotPage.BackgroundTransparency = 1
aimbotPage.BorderSizePixel = 0
aimbotPage.ScrollBarThickness = 3
aimbotPage.ScrollBarImageColor3 = Theme.Accent
aimbotPage.CanvasSize = UDim2.new(0, 0, 0, 0)
aimbotPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
aimbotPage.Visible = false
aimbotPage.ZIndex = 4
aimbotPage.Parent = ContentArea

local aimbotLayout = Instance.new("UIListLayout", aimbotPage)
aimbotLayout.SortOrder = Enum.SortOrder.LayoutOrder
aimbotLayout.Padding = UDim.new(0, 6)

addSection(aimbotPage, "AimBot Settings", 1)
local getAimBot = addToggle(aimbotPage, "AimBot Enabled", false, function(v) Settings.AimBotEnabled = v end, 2)
local getSmoothness = addSlider(aimbotPage, "Smoothness", 0.01, 1.0, 0.450, function(v) Settings.Smoothness = v end, 3)
local getFOVRadius = addSlider(aimbotPage, "FOV Radius", 20, 500, 150, function(v) Settings.FOVRadius = v end, 4)
local getPrediction = addSlider(aimbotPage, "Prediction", 0, 0.5, 0.100, function(v) Settings.Prediction = v end, 5)
local getWallCheck = addToggle(aimbotPage, "Wall Check", false, function(v) Settings.WallCheck = v end, 6)
local getStickyAim = addToggle(aimbotPage, "Sticky Aim", true, function(v) Settings.StickyAim = v end, 7)
local getSkipDowned = addToggle(aimbotPage, "Skip Downed", true, function(v) Settings.SkipDowned = v end, 8)

-- =============================================
-- TAB 3: MISC
-- =============================================
local miscPage = Instance.new("ScrollingFrame")
miscPage.Size = UDim2.new(0.5, -10, 1, 0)
miscPage.Position = UDim2.new(0, 0, 0, 0)
miscPage.BackgroundTransparency = 1
miscPage.BorderSizePixel = 0
miscPage.ScrollBarThickness = 3
miscPage.ScrollBarImageColor3 = Theme.Accent
miscPage.CanvasSize = UDim2.new(0, 0, 0, 0)
miscPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
miscPage.Visible = false
miscPage.ZIndex = 4
miscPage.Parent = ContentArea

local miscLayout = Instance.new("UIListLayout", miscPage)
miscLayout.SortOrder = Enum.SortOrder.LayoutOrder
miscLayout.Padding = UDim.new(0, 6)

addSection(miscPage, "Miscellaneous", 1)
local getTeleportToPlayer = addToggle(miscPage, "TeleportToPlayer", false, function(v) Settings.TeleportToPlayer = v end, 2)
local getAntiAFK = addToggle(miscPage, "Anti-AFK", true, function(v) Settings.AntiAFK = v end, 3)
local getFullbright = addToggle(miscPage, "Fullbright", false, function(v) Settings.Fullbright = v end, 4)
local getNoFog = addToggle(miscPage, "No Fog", false, function(v) Settings.NoFog = v end, 5)

-- =============================================
-- TAB 4: WHITELIST
-- =============================================
local whitelistPage = Instance.new("ScrollingFrame")
whitelistPage.Size = UDim2.new(0.5, -10, 1, 0)
whitelistPage.Position = UDim2.new(0, 0, 0, 0)
whitelistPage.BackgroundTransparency = 1
whitelistPage.BorderSizePixel = 0
whitelistPage.ScrollBarThickness = 3
whitelistPage.ScrollBarImageColor3 = Theme.Accent
whitelistPage.CanvasSize = UDim2.new(0, 0, 0, 0)
whitelistPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
whitelistPage.Visible = false
whitelistPage.ZIndex = 4
whitelistPage.Parent = ContentArea

local whitelistLayout = Instance.new("UIListLayout", whitelistPage)
whitelistLayout.SortOrder = Enum.SortOrder.LayoutOrder
whitelistLayout.Padding = UDim.new(0, 6)

addSection(whitelistPage, "Whitelist System", 1)
local getWhitelistEnabled = addToggle(whitelistPage, "Whitelist Enabled", false, function(v) Settings.WhitelistEnabled = v end, 2)

local wlInfo = Instance.new("TextLabel")
wlInfo.Size = UDim2.new(1, 0, 0, 60)
wlInfo.BackgroundColor3 = Theme.Button
wlInfo.BackgroundTransparency = 0.4
wlInfo.BorderSizePixel = 0
wlInfo.Text = "  Whitelist Count: 0\n  Only whitelisted players are targeted"
wlInfo.TextColor3 = Theme.SubText
wlInfo.TextSize = 11
wlInfo.Font = Enum.Font.Code
wlInfo.TextXAlignment = Enum.TextXAlignment.Left
wlInfo.TextYAlignment = Enum.TextYAlignment.Top
wlInfo.LayoutOrder = 3
wlInfo.ZIndex = 5
wlInfo.Parent = whitelistPage
Instance.new("UICorner", wlInfo).CornerRadius = UDim.new(0, 6)
local wlInfoPad = Instance.new("UIPadding", wlInfo)
wlInfoPad.PaddingLeft = UDim.new(0, 8)
wlInfoPad.PaddingTop = UDim.new(0, 8)

-- =============================================
-- TAB 5: TELEPORT
-- =============================================
local teleportPage = Instance.new("ScrollingFrame")
teleportPage.Size = UDim2.new(0.5, -10, 1, 0)
teleportPage.Position = UDim2.new(0, 0, 0, 0)
teleportPage.BackgroundTransparency = 1
teleportPage.BorderSizePixel = 0
teleportPage.ScrollBarThickness = 3
teleportPage.ScrollBarImageColor3 = Theme.Accent
teleportPage.CanvasSize = UDim2.new(0, 0, 0, 0)
teleportPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
teleportPage.Visible = false
teleportPage.ZIndex = 4
teleportPage.Parent = ContentArea

local teleportLayout = Instance.new("UIListLayout", teleportPage)
teleportLayout.SortOrder = Enum.SortOrder.LayoutOrder
teleportLayout.Padding = UDim.new(0, 6)

addSection(teleportPage, "Teleport Options", 1)

local tpMouseBtn = Instance.new("TextButton")
tpMouseBtn.Size = UDim2.new(1, 0, 0, 34)
tpMouseBtn.BackgroundColor3 = Theme.Button
tpMouseBtn.BackgroundTransparency = 0.2
tpMouseBtn.BorderSizePixel = 0
tpMouseBtn.Text = "Teleport to Mouse"
tpMouseBtn.TextColor3 = Theme.Text
tpMouseBtn.TextSize = 12
tpMouseBtn.Font = Enum.Font.GothamSemibold
tpMouseBtn.AutoButtonColor = false
tpMouseBtn.LayoutOrder = 2
tpMouseBtn.ZIndex = 5
tpMouseBtn.Parent = teleportPage
Instance.new("UICorner", tpMouseBtn).CornerRadius = UDim.new(0, 6)
local tpStroke = Instance.new("UIStroke", tpMouseBtn)
tpStroke.Color = Theme.Border
tpStroke.Thickness = 1
tpMouseBtn.MouseEnter:Connect(function() tween(tpMouseBtn, 0.15, {BackgroundColor3 = Theme.ButtonHover, BackgroundTransparency = 0.1}) end)
tpMouseBtn.MouseLeave:Connect(function() tween(tpMouseBtn, 0.15, {BackgroundColor3 = Theme.Button, BackgroundTransparency = 0.2}) end)
tpMouseBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)) end
    end
end)

local tpPlayerBtn = Instance.new("TextButton")
tpPlayerBtn.Size = UDim2.new(1, 0, 0, 34)
tpPlayerBtn.BackgroundColor3 = Theme.Button
tpPlayerBtn.BackgroundTransparency = 0.2
tpPlayerBtn.BorderSizePixel = 0
tpPlayerBtn.Text = "Teleport to Selected Player"
tpPlayerBtn.TextColor3 = Theme.Text
tpPlayerBtn.TextSize = 12
tpPlayerBtn.Font = Enum.Font.GothamSemibold
tpPlayerBtn.AutoButtonColor = false
tpPlayerBtn.LayoutOrder = 3
tpPlayerBtn.ZIndex = 5
tpPlayerBtn.Parent = teleportPage
Instance.new("UICorner", tpPlayerBtn).CornerRadius = UDim.new(0, 6)
local tpStroke2 = Instance.new("UIStroke", tpPlayerBtn)
tpStroke2.Color = Theme.Border
tpStroke2.Thickness = 1
tpPlayerBtn.MouseEnter:Connect(function() tween(tpPlayerBtn, 0.15, {BackgroundColor3 = Theme.ButtonHover, BackgroundTransparency = 0.1}) end)
tpPlayerBtn.MouseLeave:Connect(function() tween(tpPlayerBtn, 0.15, {BackgroundColor3 = Theme.Button, BackgroundTransparency = 0.2}) end)
tpPlayerBtn.MouseButton1Click:Connect(function()
    local target = Settings.CurrentTarget
    if target and target.Character then
        local thrp = target.Character:FindFirstChild("HumanoidRootPart")
        local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if thrp and lhrp then lhrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 3) end
    end
end)

-- =============================================
-- SAYFA GECIS ANIMASYONU
-- =============================================
local pages = {
    Visual = visualPage,
    AimBot = aimbotPage,
    Misc = miscPage,
    Whitelist = whitelistPage,
    Teleport = teleportPage,
}

local function switchTab(tabName)
    if activeTab == tabName then return end
    
    for name, page in pairs(pages) do
        page.Visible = false
    end
    
    for name, btn in pairs(tabButtons) do
        local isActive = (name == tabName)
        tween(btn, 0.2, {TextColor3 = isActive and Theme.Text or Theme.SubText})
        local ind = btn:FindFirstChild("Indicator")
        if ind then
            tween(ind, 0.25, {Size = isActive and UDim2.new(0.6, 0, 0, 2) or UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Quart)
        end
    end
    
    local targetPage = pages[tabName]
    if targetPage then
        targetPage.Visible = true
        targetPage.Position = UDim2.new(0, 15, 0, 0)
        tween(targetPage, 0.25, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quint)
    end
    
    activeTab = tabName
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
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
    if getSpeedHack() then
        local spd = getSpeedHackValue()
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
    if getNoclip() and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Flight
RunService.RenderStepped:Connect(function()
    if getFlight() and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
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
        local spd = getFlightSpeed()
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

-- Fullbright / NoFog
RunService.Heartbeat:Connect(function()
    if getFullbright() then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
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
end)

-- Anti-AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function() vu:CaptureController(); vu:ClickButton2(Vector2.new()) end)
end)

-- =============================================
-- AIMBOT (Target secili oyunculara kilitlenir)
-- =============================================
local FOVCircle, usingDrawing = nil, false
pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Color = Theme.Accent
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 64
    FOVCircle.Radius = 150
    FOVCircle.Filled = false
    FOVCircle.Visible = false
    FOVCircle.Transparency = 0.8
    usingDrawing = true
end)

RunService.RenderStepped:Connect(function()
    if usingDrawing and FOVCircle then
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        FOVCircle.Radius = getFOVRadius()
        FOVCircle.Visible = getAimBot()
        FOVCircle.Color = Theme.Accent
    end
    
    if not getAimBot() then return end
    
    -- En yakin hedef bul
    local closest, shortest = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            local part = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and part then
                local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if d < getFOVRadius() and d < shortest then
                        shortest = d
                        closest = player
                    end
                end
            end
        end
    end
    
    Settings.CurrentTarget = closest
    
    if closest and closest.Character then
        local part = closest.Character:FindFirstChild("Head") or closest.Character:FindFirstChild("HumanoidRootPart")
        if part then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, getSmoothness())
        end
    end
end)

-- =============================================
-- BILDIRIM
-- =============================================
print("[Sou Hub] Winter Edition yuklendi!")
print("[Sou Hub] Kar yagisi aktif")

task.wait(1)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❄ Sou Hub",
        Text = "Winter Edition loaded!",
        Duration = 5
    })
end)
