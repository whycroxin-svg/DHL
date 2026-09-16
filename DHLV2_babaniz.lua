--[[
    DHL V2 - by babaniz
    Sadece Camlock + ESP + Misc
    Hook'suz guvenli surum - Adonis tespit etmez
    ESC sonrasi silah ates etme sorunu DUZELTILDI
    Zengin surum - Tema, Config, Watermark, FPS/Ping
]]

print("[DHL V2] Script yukleniyor...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
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
    Blue    = {Name="Blue",    Primary=Color3.fromRGB(0,120,200),  Accent=Color3.fromRGB(0,200,255),  Bg=Color3.fromRGB(10,20,40),  Panel=Color3.fromRGB(15,25,45),  Button=Color3.fromRGB(30,40,60),  Text=Color3.fromRGB(100,200,255)},
    Purple  = {Name="Purple",  Primary=Color3.fromRGB(120,0,200),  Accent=Color3.fromRGB(180,100,255),Bg=Color3.fromRGB(20,10,40),  Panel=Color3.fromRGB(30,15,55),  Button=Color3.fromRGB(45,30,70),  Text=Color3.fromRGB(200,150,255)},
    Green   = {Name="Green",   Primary=Color3.fromRGB(0,150,80),   Accent=Color3.fromRGB(0,255,150),  Bg=Color3.fromRGB(10,30,20),  Panel=Color3.fromRGB(15,45,30),  Button=Color3.fromRGB(30,60,45),  Text=Color3.fromRGB(100,255,180)},
    Red     = {Name="Red",     Primary=Color3.fromRGB(200,30,30),  Accent=Color3.fromRGB(255,100,100),Bg=Color3.fromRGB(40,10,10),  Panel=Color3.fromRGB(55,15,15),  Button=Color3.fromRGB(70,30,30),  Text=Color3.fromRGB(255,150,150)},
    Orange  = {Name="Orange",  Primary=Color3.fromRGB(200,100,0),  Accent=Color3.fromRGB(255,180,80), Bg=Color3.fromRGB(40,20,5),   Panel=Color3.fromRGB(55,30,10),  Button=Color3.fromRGB(70,45,25),  Text=Color3.fromRGB(255,200,120)},
    Pink    = {Name="Pink",    Primary=Color3.fromRGB(200,50,150), Accent=Color3.fromRGB(255,120,200),Bg=Color3.fromRGB(40,10,30),  Panel=Color3.fromRGB(55,20,45),  Button=Color3.fromRGB(70,35,60),  Text=Color3.fromRGB(255,150,220)},
    Cyan    = {Name="Cyan",    Primary=Color3.fromRGB(0,150,180),  Accent=Color3.fromRGB(0,240,255),  Bg=Color3.fromRGB(10,30,40),  Panel=Color3.fromRGB(15,45,55),  Button=Color3.fromRGB(30,60,70),  Text=Color3.fromRGB(100,240,255)},
}
local CurrentTheme = Themes.Blue

-- =============================================
-- SETTINGS
-- =============================================
local Settings = {
    CamlockEnabled = true,
    WallCheck = false,
    Smoothness = 0.450,
    Prediction = 0.100,
    TargetPart = "Head",
    Mode = "RightMouseClick",
    StickyAim = true,
    AutoSwitch = true,
    Resolver = true,
    SkipDowned = true,
    DownedThreshold = 0.20,
    AimShake = 0,
    AlwaysOn = false,
    FOVVisible = true,
    FOVRadius = 150,
    ESPEnabled = true,
    ESPNames = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTracers = true,
    ESPBoxes = false,
    ESPTracerOrigin = "Bottom",
    HighlightFillTransparency = 0.35,
    HighlightColor = Color3.fromRGB(0, 200, 255),
    SpeedEnabled = false,
    SpeedValue = 16,
    JumpPowerEnabled = false,
    JumpPowerValue = 50,
    InfiniteJump = false,
    Noclip = false,
    AntiAFK = true,
    FlyEnabled = false,
    FlySpeed = 50,
    HitboxExpand = false,
    HitboxSize = 1.3,
    -- Yeni
    Watermark = true,
    FPSDisplay = true,
    PingDisplay = true,
    HitSound = true,
    GuiTransparency = 0.03,
    GuiScale = 1.0,
    SelectedPlayers = {},
    CurrentTarget = nil,
    -- Istatistik
    Kills = 0,
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
-- GUI
-- =============================================
local guiParent = getGuiParent()
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DHLV2_babaniz"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
if guiParent:IsA("ScreenGui") then
    ScreenGui = guiParent; ScreenGui.Name = "DHLV2_babaniz"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 999
else ScreenGui.Parent = guiParent end

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
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 620, 0, 460)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -230)
MainFrame.BackgroundColor3 = CurrentTheme.Bg
MainFrame.BackgroundTransparency = Settings.GuiTransparency
MainFrame.BorderSizePixel = 0
MainFrame.Active = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", MainFrame); mainStroke.Color = CurrentTheme.Primary; mainStroke.Thickness = 1.5

local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1, 0, 0, 45); DragHandle.BackgroundTransparency = 1
DragHandle.Text = ""; DragHandle.AutoButtonColor = false; DragHandle.ZIndex = 10; DragHandle.Parent = MainFrame
makeDraggable(MainFrame, DragHandle)

local BgImage = Instance.new("ImageLabel")
BgImage.Name = "Background"; BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1; BgImage.ImageTransparency = 0.6
BgImage.ScaleType = Enum.ScaleType.Crop; BgImage.ZIndex = 0; BgImage.Parent = MainFrame
Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 10)
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

-- Baslik
local tl = Instance.new("TextLabel"); tl.Size = UDim2.new(1,0,0,22); tl.Position = UDim2.new(0,0,0,6)
tl.BackgroundTransparency = 1; tl.Text = "DHL V2"; tl.TextColor3 = CurrentTheme.Text
tl.TextSize = 20; tl.Font = Enum.Font.GothamBold; tl.ZIndex = 5; tl.Parent = MainFrame

local cl = Instance.new("TextLabel"); cl.Size = UDim2.new(1,0,0,14); cl.Position = UDim2.new(0,0,0,27)
cl.BackgroundTransparency = 1; cl.Text = "By babaniz | Enhanced Edition"; cl.TextColor3 = CurrentTheme.Text
cl.TextSize = 11; cl.Font = Enum.Font.GothamSemibold; cl.ZIndex = 5; cl.Parent = MainFrame

-- Kapat butonu
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24); closeBtn.Position = UDim2.new(1, -32, 0, 12)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40); closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"; closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextSize = 18; closeBtn.Font = Enum.Font.GothamBold; closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 11; closeBtn.Parent = MainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
closeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- Minimize butonu
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 24, 0, 24); minBtn.Position = UDim2.new(1, -60, 0, 12)
minBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0); minBtn.BorderSizePixel = 0
minBtn.Text = "—"; minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.TextSize = 18; minBtn.Font = Enum.Font.GothamBold; minBtn.AutoButtonColor = false
minBtn.ZIndex = 11; minBtn.Parent = MainFrame
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

-- =============================================
-- SIDEBAR
-- =============================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 130, 1, -90)
Sidebar.Position = UDim2.new(0, 10, 0, 78)
Sidebar.BackgroundColor3 = CurrentTheme.Panel
Sidebar.BackgroundTransparency = 0.15
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 4
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
local sideStroke = Instance.new("UIStroke", Sidebar); sideStroke.Color = CurrentTheme.Primary; sideStroke.Thickness = 1

local sideLayout = Instance.new("UIListLayout", Sidebar)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Padding = UDim.new(0, 6)
local sidePad = Instance.new("UIPadding", Sidebar)
sidePad.PaddingTop = UDim.new(0, 8)
sidePad.PaddingLeft = UDim.new(0, 6)
sidePad.PaddingRight = UDim.new(0, 6)

-- =============================================
-- CONTENT AREA
-- =============================================
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -150, 1, -90)
ContentArea.Position = UDim2.new(0, 145, 0, 78)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 3
ContentArea.Parent = MainFrame

-- =============================================
-- TAB SYSTEM
-- =============================================
local tabNames = {"Aimlock", "Visuals", "Players", "Misc", "Settings"}
local tabPages = {}
local tabButtons = {}
local activeTab = "Aimlock"

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. name
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = i==1 and CurrentTheme.Primary or CurrentTheme.Button
    btn.BackgroundTransparency = i==1 and 0 or 0.4
    btn.BorderSizePixel = 0
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = i
    btn.ZIndex = 5
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 3, 0.6, 0)
    indicator.Position = UDim2.new(0, 3, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.BackgroundColor3 = CurrentTheme.Accent
    indicator.BorderSizePixel = 0
    indicator.Visible = (i == 1)
    indicator.ZIndex = 6
    indicator.Parent = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    
    tabButtons[name] = btn

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
    layout.Padding = UDim.new(0,5)
    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft = UDim.new(0,4)
    pad.PaddingRight = UDim.new(0,4)
    pad.PaddingTop = UDim.new(0,4)

    tabPages[name] = page
    
    btn.MouseButton1Click:Connect(function()
        activeTab = name
        for n,p in pairs(tabPages) do p.Visible = (n==name) end
        for n,b in pairs(tabButtons) do 
            b.BackgroundColor3 = (n==name) and CurrentTheme.Primary or CurrentTheme.Button
            b.BackgroundTransparency = (n==name) and 0 or 0.4
            local ind = b:FindFirstChild("Indicator")
            if ind then ind.Visible = (n==name) end
        end
    end)
end

-- =============================================
-- KEYBIND SYSTEM
-- =============================================
local activeKeybindBtn = nil
local keybindCallbacks = {}

local function addToggle(page, name, default, callback, order, withKeybind)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 28)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order or 0
    row.ZIndex = 3
    row.Parent = page

    local toggleWidth = withKeybind and UDim2.new(1, -68, 1, 0) or UDim2.new(1, 0, 1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = toggleWidth
    btn.BackgroundColor3 = default and CurrentTheme.Primary or CurrentTheme.Button
    btn.BorderSizePixel = 0
    btn.Text = name .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 12; btn.Font = Enum.Font.GothamBold; btn.AutoButtonColor = false; btn.ZIndex = 3
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,5)

    local state = default
    local function doToggle()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and CurrentTheme.Primary or CurrentTheme.Button
        if callback then callback(state) end
    end
    btn.MouseButton1Click:Connect(doToggle)

    if withKeybind then
        local kbBtn = Instance.new("TextButton")
        kbBtn.Size = UDim2.new(0, 60, 1, 0)
        kbBtn.Position = UDim2.new(1, -60, 0, 0)
        kbBtn.BackgroundColor3 = CurrentTheme.Button
        kbBtn.BorderSizePixel = 0
        kbBtn.Text = "[ - ]"
        kbBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        kbBtn.TextSize = 10; kbBtn.Font = Enum.Font.GothamBold; kbBtn.AutoButtonColor = false; kbBtn.ZIndex = 4
        kbBtn.Parent = row
        Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 4)
        local kbStroke = Instance.new("UIStroke", kbBtn); kbStroke.Color = CurrentTheme.Primary; kbStroke.Thickness = 1

        kbBtn.MouseButton1Click:Connect(function()
            if activeKeybindBtn == kbBtn then
                activeKeybindBtn = nil
                kbBtn.Text = "[ - ]"
                kbBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
                return
            end
            if activeKeybindBtn then
                activeKeybindBtn.Text = "[ - ]"
                activeKeybindBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            activeKeybindBtn = kbBtn
            kbBtn.Text = "[...]"
            kbBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
        end)

        local function assignKeybind(keyCode)
            kbBtn.Text = "[" .. keyCode.Name .. "]"
            kbBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
            keybindCallbacks[keyCode] = doToggle
            activeKeybindBtn = nil
        end

        if not _G.DHL_KeybindAssigners then _G.DHL_KeybindAssigners = {} end
        _G.DHL_KeybindAssigners[kbBtn] = assignKeybind
    end

    return function() return state end, function(v)
        state = v
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and CurrentTheme.Primary or CurrentTheme.Button
        if callback then callback(state) end
    end
end

local function addSlider(page, name, min, max, default, callback, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,-8,0,36); container.BackgroundTransparency = 1
    container.LayoutOrder = order or 0; container.ZIndex = 3; container.Parent = page

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,14); label.BackgroundTransparency = 1
    label.Text = name .. ": " .. string.format("%.3f", default)
    label.TextColor3 = Color3.fromRGB(210,210,210); label.TextSize = 11
    label.Font = Enum.Font.GothamSemibold; label.TextXAlignment = Enum.TextXAlignment.Center
    label.ZIndex = 3; label.Parent = container

    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(1,0,0,10); bg.Position = UDim2.new(0,0,0,18)
    bg.BackgroundColor3 = CurrentTheme.Button; bg.BorderSizePixel = 0
    bg.Text = ""; bg.AutoButtonColor = false; bg.ZIndex = 3; bg.Parent = container
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0,4)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = CurrentTheme.Primary; fill.BorderSizePixel = 0; fill.ZIndex = 3; fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,4)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,12,0,12); knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new((default-min)/(max-min),0,0.5,0)
    knob.BackgroundColor3 = CurrentTheme.Accent; knob.BorderSizePixel = 0; knob.ZIndex = 4; knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local value = default
    local sliding = false
    local function update(px)
        local ax,as = bg.AbsolutePosition.X, bg.AbsoluteSize.X
        if as == 0 then return end
        local p = math.clamp((px-ax)/as, 0, 1)
        value = min + (max-min)*p
        fill.Size = UDim2.new(p,0,1,0); knob.Position = UDim2.new(p,0,0.5,0)
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
    btn.Size = UDim2.new(1,-8,0,28); btn.BackgroundColor3 = CurrentTheme.Button; btn.BorderSizePixel = 0
    btn.Text = name .. ": " .. options[idx]; btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 12; btn.Font = Enum.Font.GothamBold; btn.AutoButtonColor = false
    btn.LayoutOrder = order or 0; btn.ZIndex = 3; btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,5)
    local s = Instance.new("UIStroke", btn); s.Color = CurrentTheme.Primary; s.Thickness = 1
    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1; btn.Text = name .. ": " .. options[idx]
        if callback then callback(options[idx]) end
    end)
    return function() return options[idx] end
end

local function addSeparator(page, order)
    local sep = Instance.new("Frame"); sep.Size = UDim2.new(1,-16,0,1)
    sep.BackgroundColor3 = CurrentTheme.Primary; sep.BorderSizePixel = 0
    sep.LayoutOrder = order or 0; sep.ZIndex = 3; sep.Parent = page
end

local function addLabel(page, text, order)
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,-8,0,18); lbl.BackgroundTransparency = 1
    lbl.Text = text; lbl.TextColor3 = CurrentTheme.Text; lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0; lbl.ZIndex = 3; lbl.Parent = page
end

local function addButton(page, name, callback, order, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-8,0,30)
    btn.BackgroundColor3 = color or CurrentTheme.Primary
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.LayoutOrder = order or 0
    btn.ZIndex = 3
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,5)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

-- =============================================
-- PAGE 1: AIMLOCK
-- =============================================
local p1 = tabPages["Aimlock"]
addLabel(p1, "-- CAMLOCK --", 1)
local getCamlock = addToggle(p1, "Camlock System", true, nil, 2, true)
local getWallCheck = addToggle(p1, "Wall Check", false, nil, 3, true)
local getStickyAim = addToggle(p1, "Sticky Aim", true, nil, 4, true)
local getAutoSwitch = addToggle(p1, "Auto Switch", true, nil, 5, false)
local getResolver = addToggle(p1, "Resolver", true, nil, 6, true)
local getSkipDowned = addToggle(p1, "Skip Downed (<20% HP)", true, nil, 7, true)
local getAlwaysOn = addToggle(p1, "Always On", false, nil, 8, true)

addSeparator(p1, 9)
addLabel(p1, "-- SETTINGS --", 10)
local getMode = addCycleButton(p1, "Mode", {"Right Mouse Click", "Nearest Cursor", "Toggle Q"}, "Right Mouse Click", function(v)
    Settings.Mode = v:gsub(" ", "")
end, 11)
local getTargetPart = addCycleButton(p1, "Target Part", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, "Head", function(v)
    Settings.TargetPart = v
end, 12)
local getSmoothness = addSlider(p1, "Smoothness", 0.05, 1.0, 0.450, nil, 13)
local getPrediction = addSlider(p1, "Prediction", 0.0, 0.5, 0.100, nil, 14)
local getAimShake = addSlider(p1, "Aim Shake", 0, 5, 0, nil, 15)

addSeparator(p1, 16)
addLabel(p1, "-- HITBOX --", 17)
local getHitboxExpand = addToggle(p1, "Hitbox Expand", false, nil, 18, false)
local getHitboxSize = addSlider(p1, "Hitbox Size", 1.0, 3.0, 1.3, nil, 19)

addSeparator(p1, 20)
addLabel(p1, "-- FOV CIRCLE --", 21)
local getFOVVisible = addToggle(p1, "FOV Circle", true, nil, 22, true)
local getFOVRadius = addSlider(p1, "FOV Radius", 20, 500, 150, nil, 23)

-- =============================================
-- PAGE 2: VISUALS
-- =============================================
local p2 = tabPages["Visuals"]
addLabel(p2, "-- HIGHLIGHT ESP --", 1)
local getESP = addToggle(p2, "ESP Highlight", true, nil, 2, true)
local getHighlightColor = addCycleButton(p2, "Highlight Color", {"Cyan","Blue","Green","Yellow","Purple","White","Orange","Red","Pink"}, "Cyan", function(v)
    local colors = {Cyan=Color3.fromRGB(0,200,255), Blue=Color3.fromRGB(0,120,255), Green=Color3.fromRGB(0,255,0),
        Yellow=Color3.fromRGB(255,255,0), Purple=Color3.fromRGB(180,0,255), White=Color3.fromRGB(255,255,255),
        Orange=Color3.fromRGB(255,150,0), Red=Color3.fromRGB(255,50,50), Pink=Color3.fromRGB(255,100,200)}
    Settings.HighlightColor = colors[v] or Color3.fromRGB(0,200,255)
end, 3)
local getFillTransparency = addSlider(p2, "Fill Transparency", 0, 1, 0.35, nil, 4)

addSeparator(p2, 5)
addLabel(p2, "-- INFO DISPLAY --", 6)
local getESPNames = addToggle(p2, "Name Tags", true, nil, 7, true)
local getESPHealth = addToggle(p2, "Health Display", true, nil, 8, false)
local getESPDistance = addToggle(p2, "Distance Display", true, nil, 9, false)

addSeparator(p2, 10)
addLabel(p2, "-- TRACERS --", 11)
local getESPTracers = addToggle(p2, "Tracers", true, nil, 12, true)
local getTracerOrigin = addCycleButton(p2, "Tracer Origin", {"Bottom","Center","Mouse"}, "Bottom", nil, 13)

addSeparator(p2, 14)
addLabel(p2, "-- BOX ESP --", 15)
local getESPBoxes = addToggle(p2, "Box ESP", false, nil, 16, true)

-- =============================================
-- PAGE 3: PLAYERS
-- =============================================
local p3 = tabPages["Players"]

local SelectCountLabel = Instance.new("TextLabel")
SelectCountLabel.Size = UDim2.new(1,-8,0,16); SelectCountLabel.BackgroundTransparency = 1
SelectCountLabel.Text = "Selected: 0"; SelectCountLabel.TextColor3 = CurrentTheme.Text
SelectCountLabel.TextSize = 11; SelectCountLabel.Font = Enum.Font.GothamSemibold
SelectCountLabel.TextXAlignment = Enum.TextXAlignment.Left; SelectCountLabel.LayoutOrder = 1; SelectCountLabel.ZIndex = 3
SelectCountLabel.Parent = p3

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1,-8,0,24); btnRow.BackgroundTransparency = 1; btnRow.LayoutOrder = 2; btnRow.ZIndex = 3; btnRow.Parent = p3

local SelectAllBtn = Instance.new("TextButton")
SelectAllBtn.Size = UDim2.new(0.48,0,1,0); SelectAllBtn.BackgroundColor3 = CurrentTheme.Primary
SelectAllBtn.BorderSizePixel = 0; SelectAllBtn.Text = "Select All"; SelectAllBtn.TextColor3 = Color3.fromRGB(255,255,255)
SelectAllBtn.TextSize = 11; SelectAllBtn.Font = Enum.Font.GothamBold; SelectAllBtn.AutoButtonColor = false
SelectAllBtn.ZIndex = 3; SelectAllBtn.Parent = btnRow
Instance.new("UICorner", SelectAllBtn).CornerRadius = UDim.new(0,4)

local ClearAllBtn = Instance.new("TextButton")
ClearAllBtn.Size = UDim2.new(0.48,0,1,0); ClearAllBtn.Position = UDim2.new(0.52,0,0,0)
ClearAllBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30); ClearAllBtn.BorderSizePixel = 0
ClearAllBtn.Text = "Clear"; ClearAllBtn.TextColor3 = Color3.fromRGB(255,255,255)
ClearAllBtn.TextSize = 11; ClearAllBtn.Font = Enum.Font.GothamBold; ClearAllBtn.AutoButtonColor = false
ClearAllBtn.ZIndex = 3; ClearAllBtn.Parent = btnRow
Instance.new("UICorner", ClearAllBtn).CornerRadius = UDim.new(0,4)

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1,-8,0,26); SearchBox.BackgroundColor3 = CurrentTheme.Button
SearchBox.BorderSizePixel = 0; SearchBox.PlaceholderText = "Search Players..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150,150,150); SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(220,220,220); SearchBox.TextSize = 12; SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false; SearchBox.LayoutOrder = 3; SearchBox.ZIndex = 3; SearchBox.Parent = p3
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,4)

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1,-8,0,260); PlayerScroll.BackgroundTransparency = 1; PlayerScroll.BorderSizePixel = 0
PlayerScroll.ScrollBarThickness = 3; PlayerScroll.ScrollBarImageColor3 = CurrentTheme.Primary
PlayerScroll.CanvasSize = UDim2.new(0,0,0,0); PlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerScroll.LayoutOrder = 4; PlayerScroll.ZIndex = 3; PlayerScroll.Active = true; PlayerScroll.Parent = p3

local PlayerListLayout = Instance.new("UIListLayout", PlayerScroll)
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder; PlayerListLayout.Padding = UDim.new(0,3)

-- =============================================
-- PAGE 4: MISC
-- =============================================
local p4 = tabPages["Misc"]
addLabel(p4, "-- MOVEMENT --", 1)
local getSpeed = addToggle(p4, "Speed Hack", false, nil, 2, true)
local getSpeedValue = addSlider(p4, "Walk Speed", 16, 200, 16, nil, 3)
local getJumpPower = addToggle(p4, "Jump Power", false, nil, 4, true)
local getJumpValue = addSlider(p4, "Jump Value", 50, 500, 50, nil, 5)
local getInfJump = addToggle(p4, "Infinite Jump", false, nil, 6, true)

addSeparator(p4, 7)
addLabel(p4, "-- EXPLOITS --", 8)
local getNoclip = addToggle(p4, "Noclip", false, nil, 9, true)
local getFly = addToggle(p4, "Fly", false, nil, 10, true)
local getFlySpeed = addSlider(p4, "Fly Speed", 10, 300, 50, nil, 11)

addSeparator(p4, 12)
addLabel(p4, "-- UTILITY --", 13)
local getAntiAFK = addToggle(p4, "Anti-AFK", true, nil, 14, false)

addSeparator(p4, 15)
addLabel(p4, "-- GORUNUM --", 16)
local getWatermark = addToggle(p4, "Watermark", true, nil, 17, false)
local getFPSDisplay = addToggle(p4, "FPS Gostergesi", true, nil, 18, false)
local getPingDisplay = addToggle(p4, "Ping Gostergesi", true, nil, 19, false)
local getHitSound = addToggle(p4, "Hit Sound", true, nil, 20, false)

-- =============================================
-- PAGE 5: SETTINGS
-- =============================================
local p5 = tabPages["Settings"]
addLabel(p5, "-- TEMA --", 1)
local getTheme = addCycleButton(p5, "Theme", {"Blue","Purple","Green","Red","Orange","Pink","Cyan"}, "Blue", function(v)
    if Themes[v] then
        CurrentTheme = Themes[v]
        -- Renkleri guncelle
        MainFrame.BackgroundColor3 = CurrentTheme.Bg
        mainStroke.Color = CurrentTheme.Primary
        tl.TextColor3 = CurrentTheme.Text
        cl.TextColor3 = CurrentTheme.Text
        Sidebar.BackgroundColor3 = CurrentTheme.Panel
        sideStroke.Color = CurrentTheme.Primary
        for _, b in pairs(tabButtons) do
            if b.BackgroundColor3 ~= CurrentTheme.Primary and b.BackgroundColor3 ~= CurrentTheme.Button then
                -- skip
            end
        end
    end
end, 2)

addSeparator(p5, 3)
addLabel(p5, "-- GUI AYARLARI --", 4)
local getGuiTransparency = addSlider(p5, "Gui Transparency", 0, 0.9, 0.03, function(v)
    MainFrame.BackgroundTransparency = v
end, 5)

addSeparator(p5, 6)
addLabel(p5, "-- CONFIG --", 7)
addButton(p5, "💾 Ayarlari Kaydet", function()
    local saveData = {
        Smoothness = Settings.Smoothness,
        Prediction = Settings.Prediction,
        TargetPart = Settings.TargetPart,
        FOVRadius = Settings.FOVRadius,
        HighlightColor = Settings.HighlightColor,
        SpeedValue = Settings.SpeedValue,
        JumpPowerValue = Settings.JumpPowerValue,
        FlySpeed = Settings.FlySpeed,
        HitboxSize = Settings.HitboxSize,
        Theme = CurrentTheme.Name,
    }
    if writefile then
        pcall(function()
            writefile("DHLV2_config.json", game:GetService("HttpService"):JSONEncode(saveData))
        end)
    end
end, 8, CurrentTheme.Primary)

addButton(p5, "📂 Ayarlari Yukle", function()
    if readfile and isfile then
        pcall(function()
            if isfile("DHLV2_config.json") then
                local data = game:GetService("HttpService"):JSONDecode(readfile("DHLV2_config.json"))
                if data.Smoothness then getSmoothness(data.Smoothness) end
                if data.Prediction then getPrediction(data.Prediction) end
                if data.FOVRadius then getFOVRadius(data.FOVRadius) end
                if data.SpeedValue then getSpeedValue(data.SpeedValue) end
                if data.JumpPowerValue then getJumpValue(data.JumpPowerValue) end
                if data.FlySpeed then getFlySpeed(data.FlySpeed) end
                if data.HitboxSize then getHitboxSize(data.HitboxSize) end
            end
        end)
    end
end, 9, CurrentTheme.Primary)

addButton(p5, "🔄 Ayarlari Sifirla", function()
    Settings.Smoothness = 0.450
    Settings.Prediction = 0.100
    Settings.FOVRadius = 150
    Settings.SpeedValue = 16
    Settings.JumpPowerValue = 50
    Settings.FlySpeed = 50
    Settings.HitboxSize = 1.3
    getSmoothness(0.450); getPrediction(0.100); getFOVRadius(150)
    getSpeedValue(16); getJumpValue(50); getFlySpeed(50); getHitboxSize(1.3)
end, 10, Color3.fromRGB(80, 30, 30))

addSeparator(p5, 11)
addLabel(p5, "-- BILGI --", 12)

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1,-8,0,80)
infoLabel.BackgroundColor3 = CurrentTheme.Button
infoLabel.BackgroundTransparency = 0.4
infoLabel.BorderSizePixel = 0
infoLabel.Text = "DHL V2 - by babaniz\nSidebar Edition\nHook-free & Safe\n\nRight Shift = GUI\nE = Cycle Target\nV = Spectate"
infoLabel.TextColor3 = Color3.fromRGB(220,220,220)
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.LayoutOrder = 13
infoLabel.ZIndex = 3
infoLabel.Parent = p5
Instance.new("UICorner", infoLabel).CornerRadius = UDim.new(0, 6)
local infoPad = Instance.new("UIPadding", infoLabel)
infoPad.PaddingLeft = UDim.new(0, 8)
infoPad.PaddingTop = UDim.new(0, 6)

-- =============================================
-- WATERMARK
-- =============================================
local Watermark = Instance.new("Frame")
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0, 200, 0, 36)
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.BackgroundColor3 = CurrentTheme.Bg
Watermark.BackgroundTransparency = 0.2
Watermark.BorderSizePixel = 0
Watermark.Visible = true
Watermark.ZIndex = 500
Watermark.Parent = ScreenGui
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 6)
local wmStroke = Instance.new("UIStroke", Watermark); wmStroke.Color = CurrentTheme.Primary; wmStroke.Thickness = 1
makeDraggable(Watermark, Watermark)

local wmTitle = Instance.new("TextLabel")
wmTitle.Size = UDim2.new(1, 0, 0, 18); wmTitle.Position = UDim2.new(0, 8, 0, 2)
wmTitle.BackgroundTransparency = 1
wmTitle.Text = "DHL V2"
wmTitle.TextColor3 = CurrentTheme.Text
wmTitle.TextSize = 12; wmTitle.Font = Enum.Font.GothamBold
wmTitle.TextXAlignment = Enum.TextXAlignment.Left
wmTitle.ZIndex = 501; wmTitle.Parent = Watermark

local wmInfo = Instance.new("TextLabel")
wmInfo.Size = UDim2.new(1, 0, 0, 14); wmInfo.Position = UDim2.new(0, 8, 0, 19)
wmInfo.BackgroundTransparency = 1
wmInfo.Text = "babaniz | 60 FPS | 0 MS"
wmInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
wmInfo.TextSize = 10; wmInfo.Font = Enum.Font.Gotham
wmInfo.TextXAlignment = Enum.TextXAlignment.Left
wmInfo.ZIndex = 501; wmInfo.Parent = Watermark

-- =============================================
-- FPS/PING GUNCELLE
-- =============================================
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
            wmInfo.Text = "babaniz | " .. fpsStr .. " | " .. pingStr
        else
            wmInfo.Text = "babaniz"
        end
        
        fpsCount = 0
        fpsTime = tick()
    end
end)

RunService.RenderStepped:Connect(function()
    Watermark.Visible = getWatermark()
end)

-- =============================================
-- PAGE 5: SPECTATE
-- =============================================
-- Not: Spectate artik Settings altinda degil, kendi sekmesi yok
-- Spectate kodu Players sekmesinde gomulu olarak kalacak

local spectateTarget = nil
local spectating = false

-- Spectate fonksiyonlari (sidebar'da Spectate sekmesi olmadigi icin
-- Players sekmesine kisayol ekleyelim)
local specFrame = Instance.new("Frame")
specFrame.Size = UDim2.new(1,-8,0,120); specFrame.BackgroundTransparency = 1
specFrame.LayoutOrder = 20; specFrame.ZIndex = 3; specFrame.Parent = p3

local specStatusLabel = Instance.new("TextLabel")
specStatusLabel.Size = UDim2.new(1,0,0,20); specStatusLabel.BackgroundTransparency = 1
specStatusLabel.Text = "Spectate: Not active"; specStatusLabel.TextColor3 = Color3.fromRGB(200,200,200)
specStatusLabel.TextSize = 12; specStatusLabel.Font = Enum.Font.GothamBold
specStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
specStatusLabel.ZIndex = 3; specStatusLabel.Parent = specFrame

local stopSpecBtn = Instance.new("TextButton")
stopSpecBtn.Size = UDim2.new(1,0,0,26); stopSpecBtn.Position = UDim2.new(0,0,0,24)
stopSpecBtn.BackgroundColor3 = CurrentTheme.Primary
stopSpecBtn.BorderSizePixel = 0; stopSpecBtn.Text = "Stop Spectating"
stopSpecBtn.TextColor3 = Color3.fromRGB(255,255,255); stopSpecBtn.TextSize = 12
stopSpecBtn.Font = Enum.Font.GothamBold; stopSpecBtn.AutoButtonColor = false
stopSpecBtn.ZIndex = 3; stopSpecBtn.Parent = specFrame
Instance.new("UICorner", stopSpecBtn).CornerRadius = UDim.new(0,5)

local specHint = Instance.new("TextLabel")
specHint.Size = UDim2.new(1,0,0,14); specHint.Position = UDim2.new(0,0,0,56)
specHint.BackgroundTransparency = 1
specHint.Text = "Spectate Key: V (oyuncu sec ve V'ye bas)"
specHint.TextColor3 = Color3.fromRGB(180,180,180)
specHint.TextSize = 10; specHint.Font = Enum.Font.Gotham
specHint.TextXAlignment = Enum.TextXAlignment.Left
specHint.ZIndex = 3; specHint.Parent = specFrame

local function startSpectate(player)
    if not player or not player.Character then return end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    spectateTarget = player
    spectating = true
    Camera.CameraSubject = hum
    specStatusLabel.Text = "Spectate: " .. player.DisplayName
    specStatusLabel.TextColor3 = CurrentTheme.Accent
end

local function stopSpectate()
    spectating = false
    spectateTarget = nil
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end)
    specStatusLabel.Text = "Spectate: Not active"
    specStatusLabel.TextColor3 = Color3.fromRGB(200,200,200)
end

stopSpecBtn.MouseButton1Click:Connect(stopSpectate)

RunService.Heartbeat:Connect(function()
    if spectating and spectateTarget then
        if spectateTarget.Character and spectateTarget.Character:FindFirstChildOfClass("Humanoid") then
            local hum = spectateTarget.Character:FindFirstChildOfClass("Humanoid")
            if Camera.CameraSubject ~= hum then Camera.CameraSubject = hum end
        end
    end
end)

-- =============================================
-- PLAYER LIST LOGIC
-- =============================================
local playerButtons = {}

local function updateSelectCount()
    local c = 0; for _ in pairs(Settings.SelectedPlayers) do c = c+1 end
    SelectCountLabel.Text = "Selected: " .. c
end

local function isSelected(player) return Settings.SelectedPlayers[player.Name] ~= nil end

local function toggleSelect(player, btn)
    if isSelected(player) then
        Settings.SelectedPlayers[player.Name] = nil
        btn.BackgroundColor3 = CurrentTheme.Button; btn.TextColor3 = Color3.fromRGB(200,200,200)
    else
        Settings.SelectedPlayers[player.Name] = player
        btn.BackgroundColor3 = CurrentTheme.Primary; btn.TextColor3 = Color3.fromRGB(255,255,255)
    end
    updateSelectCount()
end

local function createPlayerButton(player)
    if player == LocalPlayer then return end
    local sel = isSelected(player)
    local btn = Instance.new("TextButton")
    btn.Name = "PLR_"..player.Name; btn.Size = UDim2.new(1,-4,0,26)
    btn.BackgroundColor3 = sel and CurrentTheme.Primary or CurrentTheme.Button
    btn.BorderSizePixel = 0; btn.Text = "  "..player.DisplayName
    btn.TextColor3 = sel and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,200)
    btn.TextSize = 12; btn.Font = Enum.Font.Gotham; btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false; btn.ZIndex = 3; btn.Parent = PlayerScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    btn.MouseButton1Click:Connect(function() toggleSelect(player, btn) end)
    playerButtons[player.Name] = btn
end

local function refreshPlayerList()
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
    removeHighlight(player.Name); task.wait(0.1); refreshPlayerList()
end)
SearchBox:GetPropertyChangedSignal("Text"):Connect(refreshPlayerList)

-- =============================================
-- FOV CIRCLE
-- =============================================
local fovCircle, usingDrawing = nil, false
pcall(function()
    fovCircle = Drawing.new("Circle"); fovCircle.Color = CurrentTheme.Accent
    fovCircle.Thickness = 1.5; fovCircle.NumSides = 64; fovCircle.Radius = 150
    fovCircle.Filled = false; fovCircle.Visible = true; fovCircle.Transparency = 0.8
    usingDrawing = true
end)

-- =============================================
-- HIGHLIGHT ESP
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
    local hl = Instance.new("Highlight"); hl.Name = "DHL_Highlight"
    hl.FillColor = Settings.HighlightColor; hl.OutlineColor = Settings.HighlightColor
    hl.FillTransparency = Settings.HighlightFillTransparency; hl.OutlineTransparency = 0
    hl.Adornee = player.Character; hl.Parent = player.Character
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
        -- Box ESP icin 4 cizgi
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
                            -- BOX ESP
                            if getESPBoxes() and rootPart then
                                local topLeft = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0))
                                local bottomRight = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                                if topLeft and bottomRight then
                                    local tl, br = Vector2.new(topLeft.X, topLeft.Y), Vector2.new(bottomRight.X, bottomRight.Y)
                                    local w = 40
                                    local corners = {
                                        TL = Vector2.new(tl.X - w, tl.Y),
                                        TR = Vector2.new(tl.X + w, tl.Y),
                                        BL = Vector2.new(br.X - w, br.Y),
                                        BR = Vector2.new(br.X + w, br.Y),
                                    }
                                    esp.boxTop.From = corners.TL; esp.boxTop.To = corners.TR
                                    esp.boxBottom.From = corners.BL; esp.boxBottom.To = corners.BR
                                    esp.boxLeft.From = corners.TL; esp.boxLeft.To = corners.BL
                                    esp.boxRight.From = corners.TR; esp.boxRight.To = corners.BR
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
-- WALL CHECK
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

-- =============================================
-- DOWNED CHECK
-- =============================================
local function isDowned(character)
    if not character then return false end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return (hum.Health / hum.MaxHealth) < 0.20
end

-- =============================================
-- PREDICTION
-- =============================================
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

-- =============================================
-- CLOSEST TARGET
-- =============================================
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

local cycleIdx = 0
local function cycleTarget()
    local list = {}
    for _, p in pairs(Settings.SelectedPlayers) do
        if p and p.Character then
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then
                if not (getSkipDowned() and isDowned(p.Character)) then
                    table.insert(list, p)
                end
            end
        end
    end
    if #list == 0 then Settings.CurrentTarget = nil; return end
    cycleIdx = (cycleIdx % #list) + 1
    Settings.CurrentTarget = list[cycleIdx]
end

-- =============================================
-- HITBOX EXPAND
-- =============================================
local originalSizes = {}

local function expandHitbox(character)
    if not character then return end
    if not getHitboxExpand() then return end
    local sizeMult = getHitboxSize()
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if not originalSizes[part] then originalSizes[part] = part.Size end
            pcall(function() part.Size = originalSizes[part] * sizeMult end)
        end
    end
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
            activeKeybindBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
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
    if input.KeyCode == Enum.KeyCode.E and locked then cycleTarget() end
    if input.KeyCode == Enum.KeyCode.RightShift then MainFrame.Visible = not MainFrame.Visible end

    if input.KeyCode == Enum.KeyCode.Space and getInfJump() then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end

    -- Spectate (V tusu)
    if input.KeyCode == Enum.KeyCode.V then
        if spectating then
            stopSpectate()
        else
            local target = nil
            for _, p in pairs(Settings.SelectedPlayers) do
                if p and p.Character then target = p; break end
            end
            if target then startSpectate(target) end
        end
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
-- MISC FEATURES
-- =============================================
RunService.Stepped:Connect(function()
    if getNoclip() and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

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

-- =============================================
-- FLY + AIMLOCK
-- =============================================
local flyBV = nil
RunService.RenderStepped:Connect(function()
    if menuOpen then return end

    if usingDrawing and fovCircle then
        fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        fovCircle.Radius = getFOVRadius()
        fovCircle.Visible = getFOVVisible()
        fovCircle.Color = CurrentTheme.Accent
    end

    updateESP()

    if Settings.CurrentTarget and Settings.CurrentTarget.Character then
        if getHitboxExpand() then expandHitbox(Settings.CurrentTarget.Character) end
    end

    if getFly() then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            if not flyBV or flyBV.Parent ~= root then
                if flyBV then pcall(function() flyBV:Destroy() end) end
                flyBV = Instance.new("BodyVelocity"); flyBV.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                flyBV.Velocity = Vector3.new(0,0,0); flyBV.Parent = root
                local bg = Instance.new("BodyGyro"); bg.Name = "DHL_AntiGrav"
                bg.MaxTorque = Vector3.new(math.huge,math.huge,math.huge); bg.Parent = root
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

-- Anti-AFK
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
            if highlightObjects[name] and parent then 
                pcall(function() highlightObjects[name].Parent = parent end) 
            end
        end
        savedHighlightData = {}
        if fovCircle and getFOVVisible() then
            pcall(function() fovCircle.Visible = true end)
        end
        resetInput(); task.wait(0.1); resetInput(); task.wait(0.15); resetInput()
    end)
end)

LocalPlayer.CharacterRemoving:Connect(function()
    for name in pairs(highlightObjects) do removeHighlight(name) end
    if flyBV then pcall(function() flyBV:Destroy() end); flyBV = nil end
end)

task.defer(function()
    task.wait(0.3)
    for _, child in ipairs(MainFrame:GetDescendants()) do
        if child:IsA("GuiObject") and child ~= BgImage and child.ZIndex < 2 then child.ZIndex = 2 end
    end
end)

-- =============================================
-- PENCERE ODAK
-- =============================================
UserInputService.WindowFocused:Connect(function()
    task.wait(0.2); resetInput()
end)
UserInputService.WindowFocusReleased:Connect(function()
    resetInput()
end)

print("[DHL V2] Input reset aktif")

-- =============================================
-- BILDIRIM
-- =============================================
print("[DHL V2] by babaniz - FULL LOAD!")
print("[DHL V2] Right Shift = GUI ac/kapa")
print("[DHL V2] Sadece Camlock - Hook YOK")
print("[DHL V2] Enhanced Edition - Tema, Config, Watermark")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DHL V2",
        Text = "by babaniz | Enhanced Edition",
        Duration = 5
    })
end)
