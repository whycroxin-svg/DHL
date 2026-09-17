--[[
    Sou Hub - Winter Edition FINAL
    Eski player list sistemi - CALISIYOR
]]

print("[Sou Hub] yukleniyor...")

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
    CamlockEnabled = true, WallCheck = false, Smoothness = 0.450, Prediction = 0.100,
    TargetPart = "Head", Mode = "RightMouseClick", StickyAim = true, AutoSwitch = true,
    SkipDowned = true, AlwaysOn = false, TriggerBot = false, FOVVisible = true,
    FOVRadius = 150,
    SpeedEnabled = false, SpeedValue = 16, JumpPowerEnabled = false, JumpPowerValue = 50,
    InfiniteJump = false, Noclip = false, FlyEnabled = false, FlySpeed = 50,
    AntiAFK = true, HitboxExpand = false, HitboxSize = 1.3,
    Watermark = true, FPSDisplay = true, PingDisplay = true, GuiTransparency = 250,
    FollowPlayer = false, FollowTarget = nil,
    DamageAura = false, DamageAuraRange = 10, DamageAuraAmount = 5,
    AntiFling = false, GodMode = false, CharacterSize = false, CharacterSizeValue = 1.0,
    Fullbright = false, NoFog = false,
    AutoKill = false, AutoLock = false, AutoFire = false,
    InstantKill = false, RapidKill = false, RapidKillDelay = 0.05,
    KillRange = 100, AutoKillTarget = nil,
    SpectateTarget = nil, Spectating = false,
    Kills = 0, SessionStart = tick(),
    SelectedPlayers = {}, CurrentTarget = nil,
    ESPEnabled = true, ESPNames = true, ESPHealth = true, ESPDistance = true,
    ESPTracers = true, ESPBoxes = false,
    HighlightFillTransparency = 0.35, HighlightColor = Color3.fromRGB(120,180,255),
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
for _, plr in ipairs(Players:GetPlayers()) do
    pcall(function() if plr.Character then local h = plr.Character:FindFirstChild("SouHub_Highlight"); if h then h:Destroy() end end end)
end

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

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 780, 0, 480)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -240)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Theme.Border
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3

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

makeDraggable(MainFrame, Header)

-- TAB BAR
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 45)
TabBar.Position = UDim2.new(0, 0, 0, 50)
TabBar.BackgroundColor3 = Theme.Bg
TabBar.BackgroundTransparency = 0.5
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 5
TabBar.Parent = MainFrame

local tabLine = Instance.new("Frame")
tabLine.Size = UDim2.new(1, 0, 0, 1)
tabLine.Position = UDim2.new(0, 0, 1, -1)
tabLine.BackgroundColor3 = Theme.Border
tabLine.BorderSizePixel = 0
tabLine.ZIndex = 6
tabLine.Parent = TabBar

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1, 0, 1, 0)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 0
TabScroll.CanvasSize = UDim2.new(0, 1100, 0, 0)
TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
TabScroll.ZIndex = 6
TabScroll.Parent = TabBar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -40, 1, -130)
ContentArea.Position = UDim2.new(0, 20, 0, 105)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 3
ContentArea.Parent = MainFrame

-- KEYBIND
local activeKeybindBtn = nil
local keybindCallbacks = {}
_G.SouHub_KeybindAssigners = {}

local tabPages = {}
local tabButtons = {}
local activeTab = "Aimlock"

local tabNames = {"Aimlock", "AutoKill", "ESP", "Players", "Movement", "Character", "World", "Spectate", "Themes", "Settings"}

for i, name in ipairs(tabNames) do
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Theme.Accent
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = (i==1)
    page.ZIndex = 4
    page.Parent = ContentArea
    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,6)
    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft = UDim.new(0,4); pad.PaddingRight = UDim.new(0,4); pad.PaddingTop = UDim.new(0,4)
    tabPages[name] = page
end

local tabWidth = 95
local tabGap = 4
for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, tabWidth, 0, 32)
    btn.Position = UDim2.new(0, 15 + (i-1) * (tabWidth + tabGap), 0, 6)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = i==1 and Theme.Text or Theme.SubText
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 6
    btn.Parent = TabScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    tabButtons[name] = btn
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(i==1 and 0.6 or 0, 0, 0, 2)
    indicator.Position = UDim2.new(0.5, 0, 1, -2)
    indicator.AnchorPoint = Vector2.new(0.5, 0)
    indicator.BackgroundColor3 = (name == "AutoKill") and Theme.Kill or Theme.Accent
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 7
    indicator.Parent = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 1)
    
    btn.MouseButton1Click:Connect(function()
        if activeTab == name then return end
        activeTab = name
        for n,b in pairs(tabButtons) do 
            local isActive = (n == name)
            tween(b, 0.2, {TextColor3 = isActive and Theme.Text or Theme.SubText})
            local ind = b:FindFirstChildOfClass("Frame")
            if ind then tween(ind, 0.25, {Size = UDim2.new(isActive and 0.6 or 0, 0, 0, 2)}) end
        end
        for n, p in pairs(tabPages) do p.Visible = (n == name) end
    end)
end

-- =============================================
-- UI BUILDERS
-- =============================================
local function addToggle(page, name, default, callback, order, withKeybind)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order or 0
    row.ZIndex = 4
    row.Parent = page
    
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
    switchBg.Position = withKeybind and UDim2.new(1, -110, 0.5, -13) or UDim2.new(1, -50, 0.5, -13)
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
    
    if withKeybind then
        local kbBtn = Instance.new("TextButton")
        kbBtn.Size = UDim2.new(0, 50, 0, 26)
        kbBtn.Position = UDim2.new(1, -50, 0.5, -13)
        kbBtn.BackgroundColor3 = Theme.Button
        kbBtn.BackgroundTransparency = 0.5
        kbBtn.BorderSizePixel = 0
        kbBtn.Text = "[ - ]"
        kbBtn.TextColor3 = Theme.SubText
        kbBtn.TextSize = 10
        kbBtn.Font = Enum.Font.GothamBold
        kbBtn.AutoButtonColor = false
        kbBtn.ZIndex = 5
        kbBtn.Parent = row
        Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 5)
        
        local assignedKey = nil
        
        kbBtn.MouseButton1Click:Connect(function()
            if assignedKey then
                keybindCallbacks[assignedKey] = nil
                assignedKey = nil
            end
            if activeKeybindBtn == kbBtn then
                activeKeybindBtn = nil
                kbBtn.Text = "[ - ]"
                kbBtn.TextColor3 = Theme.SubText
                return
            end
            if activeKeybindBtn then
                activeKeybindBtn.Text = "[ - ]"
                activeKeybindBtn.TextColor3 = Theme.SubText
            end
            activeKeybindBtn = kbBtn
            kbBtn.Text = "[...]"
            kbBtn.TextColor3 = Color3.fromRGB(255, 200, 60)
        end)
        
        _G.SouHub_KeybindAssigners[kbBtn] = function(keyCode)
            assignedKey = keyCode
            kbBtn.Text = "[" .. keyCode.Name .. "]"
            kbBtn.TextColor3 = Color3.fromRGB(120, 220, 160)
            keybindCallbacks[keyCode] = doToggle
            activeKeybindBtn = nil
        end
    end
    
    return function() return state end
end

local function addSlider(page, name, min, max, default, callback, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 52)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order or 0
    container.ZIndex = 4
    container.Parent = page
    
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

local function addCycleButton(page, name, options, default, callback, order)
    local idx = 1
    for i,v in ipairs(options) do if v == default then idx = i; break end end
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Theme.Button
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = order or 0
    btn.ZIndex = 5
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.5, 0, 1, 0)
    nameLbl.Position = UDim2.new(0, 14, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = Theme.Text
    nameLbl.TextSize = 12
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 6
    nameLbl.Parent = btn
    
    local valueLbl = Instance.new("TextLabel")
    valueLbl.Size = UDim2.new(0.5, -14, 1, 0)
    valueLbl.Position = UDim2.new(0.5, 0, 0, 0)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text = options[idx]
    valueLbl.TextColor3 = Theme.Accent2
    valueLbl.TextSize = 12
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right
    valueLbl.ZIndex = 6
    valueLbl.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        valueLbl.Text = options[idx]
        if callback then callback(options[idx]) end
    end)
    return function() return options[idx] end
end

local function addSeparator(page, order)
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -16, 0, 1)
    sep.BackgroundColor3 = Theme.Border
    sep.BorderSizePixel = 0
    sep.LayoutOrder = order or 0
    sep.ZIndex = 4
    sep.Parent = page
end

local function addLabel(page, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.SubText
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0
    lbl.ZIndex = 5
    lbl.Parent = page
end

local function addButton(page, name, callback, order, color)
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
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
    return btn
end

-- =============================================
-- SAYFALAR
-- =============================================
local p1 = tabPages["Aimlock"]
addLabel(p1, "-- CAMLOCK --", 1)
addToggle(p1, "Camlock System", true, function(v) Settings.CamlockEnabled = v end, 2, true)
addToggle(p1, "Wall Check", false, function(v) Settings.WallCheck = v end, 3, true)
addToggle(p1, "Sticky Aim", true, function(v) Settings.StickyAim = v end, 4, true)
addToggle(p1, "Auto Switch", true, function(v) Settings.AutoSwitch = v end, 5, false)
addToggle(p1, "Skip Downed", true, function(v) Settings.SkipDowned = v end, 6, true)
addToggle(p1, "Always On", false, function(v) Settings.AlwaysOn = v end, 7, true)
addSeparator(p1, 8)
addLabel(p1, "-- SETTINGS --", 9)
addCycleButton(p1, "Mode", {"RightMouseClick", "NearestCursor", "ToggleQ"}, "RightMouseClick", function(v) Settings.Mode = v end, 10)
addCycleButton(p1, "Target Part", {"Head", "HumanoidRootPart", "UpperTorso"}, "Head", function(v) Settings.TargetPart = v end, 11)
addSlider(p1, "Smoothness", 0.05, 1.0, 0.450, function(v) Settings.Smoothness = v end, 12)
addSlider(p1, "Prediction", 0.0, 0.5, 0.100, function(v) Settings.Prediction = v end, 13)
addSeparator(p1, 14)
addLabel(p1, "-- FOV --", 15)
addToggle(p1, "FOV Circle", true, function(v) Settings.FOVVisible = v end, 16, true)
addSlider(p1, "FOV Radius", 20, 500, 150, function(v) Settings.FOVRadius = v end, 17)

-- AUTOKILL
local p2 = tabPages["AutoKill"]
addLabel(p2, "-- AUTO ELIMINATION --", 1, Theme.Kill)
addToggle(p2, "AUTOKILL", false, function(state)
    Settings.AutoKill = state
    if state then
        showToast("AUTOKILL", "Hedefe kilitleniyor...", "kill")
        for _, plr in pairs(Settings.SelectedPlayers) do
            if plr and plr.Character then Settings.AutoKillTarget = plr; break end
        end
    end
end, 2, true)
addToggle(p2, "Auto Lock", true, function(v) Settings.AutoLock = v end, 3, true)
addToggle(p2, "Auto Fire", true, function(v) Settings.AutoFire = v end, 4, true)
addToggle(p2, "Instant Kill", true, function(v) Settings.InstantKill = v end, 5, true)
addToggle(p2, "Rapid Kill", false, function(v) Settings.RapidKill = v end, 6, true)
addSlider(p2, "Kill Range", 5, 500, 100, function(v) Settings.KillRange = v end, 7)

-- ESP
local p3 = tabPages["ESP"]
addLabel(p3, "-- ESP --", 1)
addToggle(p3, "ESP Enabled", true, function(v) Settings.ESPEnabled = v end, 2, true)
addCycleButton(p3, "Color", {"Cyan","Red","Green","Yellow","Purple","White"}, "Cyan", function(v)
    local colors = {Cyan=Color3.fromRGB(100,180,220), Red=Color3.fromRGB(255,80,80), Green=Color3.fromRGB(100,220,140),
        Yellow=Color3.fromRGB(240,220,100), Purple=Color3.fromRGB(180,120,240), White=Color3.fromRGB(255,255,255)}
    Settings.HighlightColor = colors[v] or Color3.fromRGB(100,180,220)
end, 3)
addSlider(p3, "Fill Transparency", 0, 1, 0.35, function(v) Settings.HighlightFillTransparency = v end, 4)
addToggle(p3, "Name Tags", true, nil, 5, true)
addToggle(p3, "Health Display", true, nil, 6, false)
addToggle(p3, "Distance Display", true, nil, 7, false)
addToggle(p3, "Tracers", true, nil, 8, true)

-- =============================================
-- PLAYERS PAGE - ESKI BASIT SISTEM
-- =============================================
local p4 = tabPages["Players"]
addLabel(p4, "-- SELECT PLAYERS --", 1)

local SelectCountLabel = Instance.new("TextLabel")
SelectCountLabel.Size = UDim2.new(1, 0, 0, 18)
SelectCountLabel.BackgroundTransparency = 1
SelectCountLabel.Text = "Selected: 0"
SelectCountLabel.TextColor3 = Theme.SubText
SelectCountLabel.TextSize = 10
SelectCountLabel.Font = Enum.Font.GothamSemibold
SelectCountLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectCountLabel.LayoutOrder = 2
SelectCountLabel.ZIndex = 5
SelectCountLabel.Parent = p4

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, 0, 0, 28)
btnRow.BackgroundTransparency = 1
btnRow.LayoutOrder = 3
btnRow.ZIndex = 4
btnRow.Parent = p4

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
SearchBox.Parent = p4
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
PlayerScroll.Parent = p4

local PlayerListLayout = Instance.new("UIListLayout", PlayerScroll)
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 3)

-- =============================================
-- PLAYER LIST - BASIT VE CALISAN SISTEM
-- =============================================
local playerButtons = {}

local function updateSelectCount()
    local c = 0
    for _ in pairs(Settings.SelectedPlayers) do c = c + 1 end
    SelectCountLabel.Text = "Selected: " .. c
end

local function isSelected(player)
    return Settings.SelectedPlayers[player.Name] ~= nil
end

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
    if playerButtons[player.Name] then return end
    
    local btn = Instance.new("TextButton")
    btn.Name = "PLR_" .. player.Name
    btn.Size = UDim2.new(1, -4, 0, 32)
    btn.BackgroundColor3 = isSelected(player) and Theme.Accent or Theme.Button
    btn.BackgroundTransparency = isSelected(player) and 0 or 0.3
    btn.BorderSizePixel = 0
    btn.Text = "  " .. player.DisplayName
    btn.TextColor3 = isSelected(player) and Theme.Text or Theme.SubText
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    btn.Parent = PlayerScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        toggleSelect(player, btn)
    end)
    
    playerButtons[player.Name] = btn
end

local function refreshPlayerList()
    -- Eski butonlari temizle
    for name, btn in pairs(playerButtons) do
        if btn and btn.Parent then
            btn:Destroy()
        end
    end
    playerButtons = {}
    
    -- Yeni butonlari olustur
    local search = SearchBox.Text:lower()
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if search == "" or p.DisplayName:lower():find(search, 1, true) or p.Name:lower():find(search, 1, true) then
                createPlayerButton(p)
                count = count + 1
            end
        end
    end
    updateSelectCount()
end

-- Butonlar
SelectAllBtn.MouseButton1Click:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            Settings.SelectedPlayers[p.Name] = p
        end
    end
    refreshPlayerList()
end)

ClearAllBtn.MouseButton1Click:Connect(function()
    Settings.SelectedPlayers = {}
    Settings.CurrentTarget = nil
    Settings.AutoKillTarget = nil
    refreshPlayerList()
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshPlayerList()
end)

-- Oyuncu ekleme/çıkarma
Players.PlayerAdded:Connect(function(player)
    task.wait(0.5)
    refreshPlayerList()
end)

Players.PlayerRemoving:Connect(function(player)
    Settings.SelectedPlayers[player.Name] = nil
    if Settings.CurrentTarget == player then Settings.CurrentTarget = nil end
    if Settings.AutoKillTarget == player then Settings.AutoKillTarget = nil end
    playerButtons[player.Name] = nil
    task.wait(0.1)
    refreshPlayerList()
end)

-- ILK DEFA LISTE OLUSTUR (KRITIK!)
refreshPlayerList()

-- =============================================
-- MOVEMENT
-- =============================================
local p5 = tabPages["Movement"]
addLabel(p5, "-- SPEED --", 1)
addToggle(p5, "Speed Hack", false, function(v) Settings.SpeedEnabled = v end, 2, true)
addSlider(p5, "Walk Speed", 16, 500, 16, function(v) Settings.SpeedValue = v end, 3)
addSeparator(p5, 4)
addLabel(p5, "-- JUMP --", 5)
addToggle(p5, "Jump Power", false, function(v) Settings.JumpPowerEnabled = v end, 6, true)
addSlider(p5, "Jump Value", 50, 500, 50, function(v) Settings.JumpPowerValue = v end, 7)
addToggle(p5, "Infinite Jump", false, function(v) Settings.InfiniteJump = v end, 8, true)
addSeparator(p5, 9)
addLabel(p5, "-- FLIGHT --", 10)
addToggle(p5, "Fly", false, function(v) Settings.FlyEnabled = v end, 11, true)
addSlider(p5, "Fly Speed", 10, 500, 50, function(v) Settings.FlySpeed = v end, 12)
addSeparator(p5, 13)
addLabel(p5, "-- NOCLIP --", 14)
addToggle(p5, "Noclip", false, function(v) Settings.Noclip = v end, 15, true)
addSeparator(p5, 16)
addLabel(p5, "-- TELEPORT --", 17)
addButton(p5, "Teleport to Mouse", function()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)) end
    end
end, 18)

-- CHARACTER
local p6 = tabPages["Character"]
addLabel(p6, "-- CHARACTER --", 1)
addToggle(p6, "God Mode", false, function(v) Settings.GodMode = v end, 2, true)
addToggle(p6, "Anti Fling", false, function(v) Settings.AntiFling = v end, 3, true)
addToggle(p6, "Character Size", false, function(v) Settings.CharacterSize = v end, 4, false)
addSlider(p6, "Size Scale", 0.5, 5.0, 1.0, function(v) Settings.CharacterSizeValue = v end, 5)
addSeparator(p6, 6)
addLabel(p6, "-- DAMAGE AURA --", 7)
addToggle(p6, "Damage Aura", false, function(v) Settings.DamageAura = v end, 8, true)
addSlider(p6, "Aura Range", 3, 30, 10, function(v) Settings.DamageAuraRange = v end, 9)
addSlider(p6, "Damage Amount", 1, 50, 5, function(v) Settings.DamageAuraAmount = v end, 10)
addSeparator(p6, 11)
addLabel(p6, "-- ACTIONS --", 12)
addButton(p6, "Respawn", function()
    pcall(function() LocalPlayer.Character:BreakJoints() end)
end, 13)
addButton(p6, "Full Heal", function()
    pcall(function()
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end)
end, 14)

-- WORLD
local p7 = tabPages["World"]
addLabel(p7, "-- LIGHTING --", 1)
addToggle(p7, "Fullbright", false, function(v) Settings.Fullbright = v end, 2, true)
addToggle(p7, "No Fog", false, function(v) Settings.NoFog = v end, 3, true)
addSeparator(p7, 4)
addLabel(p7, "-- SERVER --", 5)
addButton(p7, "Server Rejoin", function()
    task.wait(0.5)
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
end, 6)
addButton(p7, "Server Hop", function()
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
end, 7)

-- SPECTATE
local p8 = tabPages["Spectate"]
addLabel(p8, "-- SPECTATE MODE --", 1)
local specStatusLabel = Instance.new("TextLabel")
specStatusLabel.Size = UDim2.new(1, 0, 0, 22)
specStatusLabel.BackgroundTransparency = 1
specStatusLabel.Text = "Not Spectating"
specStatusLabel.TextColor3 = Theme.SubText
specStatusLabel.TextSize = 12
specStatusLabel.Font = Enum.Font.GothamBold
specStatusLabel.TextXAlignment = Enum.TextXAlignment.Center
specStatusLabel.LayoutOrder = 2
specStatusLabel.ZIndex = 5
specStatusLabel.Parent = p8

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
specScroll.Parent = p8
local specLayout = Instance.new("UIListLayout", specScroll)
specLayout.SortOrder = Enum.SortOrder.LayoutOrder
specLayout.Padding = UDim.new(0, 3)

addButton(p8, "Stop Spectating", function()
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
            btn.Text = "  " .. player.DisplayName
            btn.TextColor3 = Theme.Text
            btn.TextSize = 11
            btn.Font = Enum.Font.Gotham
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.AutoButtonColor = false
            btn.ZIndex = 5
            btn.Parent = specScroll
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
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
local p9 = tabPages["Themes"]
addLabel(p9, "-- THEMES --", 1)
local themeGrid = Instance.new("Frame")
themeGrid.Size = UDim2.new(1, 0, 0, 240)
themeGrid.BackgroundTransparency = 1
themeGrid.LayoutOrder = 2
themeGrid.ZIndex = 4
themeGrid.Parent = p9
local themeGridLayout = Instance.new("UIGridLayout", themeGrid)
themeGridLayout.CellSize = UDim2.new(0.25, -6, 0, 60)
themeGridLayout.CellPadding = UDim.new(0, 6)

local themeList = {
    {Name="Winter", Color=Color3.fromRGB(140,168,200)},
    {Name="Obsidian", Color=Color3.fromRGB(100,110,130)},
    {Name="Cobalt", Color=Color3.fromRGB(50,100,180)},
    {Name="Noir", Color=Color3.fromRGB(80,80,80)},
    {Name="Crimson", Color=Color3.fromRGB(140,30,50)},
    {Name="Emerald", Color=Color3.fromRGB(40,140,100)},
    {Name="Violet", Color=Color3.fromRGB(110,60,180)},
    {Name="Ocean", Color=Color3.fromRGB(30,144,255)},
}

for _, t in ipairs(themeList) do
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = t.Color
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = t.Name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    btn.Parent = themeGrid
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        Theme.Accent = t.Color
        Theme.Accent2 = t.Color
        Settings.HighlightColor = t.Color
        showToast("Theme", t.Name, "success")
    end)
end

-- SETTINGS
local p10 = tabPages["Settings"]
addLabel(p10, "-- INTERFACE --", 1)
addSlider(p10, "GUI Transparency", 0, 500, 250, function(v)
    Settings.GuiTransparency = v
    MainFrame.BackgroundTransparency = 1 - (v / 500)
end, 2)
addSeparator(p10, 3)
addLabel(p10, "-- OVERLAY --", 4)
addToggle(p10, "Watermark", true, function(v) Settings.Watermark = v end, 5, true)
addToggle(p10, "FPS Display", true, function(v) Settings.FPSDisplay = v end, 6, false)
addToggle(p10, "Ping Display", true, function(v) Settings.PingDisplay = v end, 7, false)

-- =============================================
-- LOOPS
-- =============================================
local flyBV = nil
local originalSizes = {}

RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if Settings.SpeedEnabled then
        local spd = Settings.SpeedValue
        hum.WalkSpeed = spd
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and spd > 16 then
            local md = hum.MoveDirection
            if md.Magnitude > 0 then
                hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
            end
        end
    end
    if Settings.JumpPowerEnabled then
        hum.JumpPower = Settings.JumpPowerValue
        hum.UseJumpPower = true
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
    if Settings.FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
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
        local spd = Settings.FlySpeed
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

RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    if Settings.CharacterSize then
        local scale = Settings.CharacterSizeValue
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                if not originalSizes[part] then originalSizes[part] = part.Size end
                part.Size = originalSizes[part] * scale
            end
        end
    else
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and originalSizes[part] then part.Size = originalSizes[part] end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if activeKeybindBtn and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
            local assignFunc = _G.SouHub_KeybindAssigners and _G.SouHub_KeybindAssigners[activeKeybindBtn]
            if assignFunc then assignFunc(input.KeyCode) end
            return
        else
            activeKeybindBtn.Text = "[ - ]"
            activeKeybindBtn.TextColor3 = Theme.SubText
            activeKeybindBtn = nil
            return
        end
    end
    
    if input.UserInputType == Enum.UserInputType.Keyboard and keybindCallbacks[input.KeyCode] then
        keybindCallbacks[input.KeyCode]()
    end
    
    if gpe then return end
    
    if input.KeyCode == Enum.KeyCode.Space and Settings.InfiniteJump then
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

local lastKillTick = 0
RunService.RenderStepped:Connect(function()
    if not Settings.AutoKill then return end
    local target = Settings.AutoKillTarget
    if not target or not target.Character then
        for _, plr in pairs(Settings.SelectedPlayers) do
            if plr and plr.Character then
                local h = plr.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 then Settings.AutoKillTarget = plr; target = plr; break end
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
                if hum and hum.Health > 0 then addHighlight(player) else removeHighlight(player.Name) end
            else removeHighlight(player.Name) end
        end
    end
end

-- FOV
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

local locked = false
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
        if Settings.CamlockEnabled then
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
    if Settings.AlwaysOn and Settings.CamlockEnabled then
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
makeDraggable(Watermark, Watermark)

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

print("[Sou Hub] Yuklendi!")
print("[Sou Hub] Player listesi aktif - " .. #Players:GetPlayers() .. " oyuncu")

task.wait(0.3)
showToast("❄ Sou Hub", "Winter Edition hazir!", "success")
