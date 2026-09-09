--[[
    DHL V2 - by babaniz
    Blatant Aimlock + ESP + Misc â€” Full Feature
    Tab sistemi ile sayfa sayfa
]]

print("[DHL V2] Script yukleniyor...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
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
-- SETTINGS
-- =============================================
local Settings = {
    -- Aimlock
    CamlockEnabled = true,
    WallCheck = true,
    Smoothness = 0.450,
    Prediction = 0.100,
    TargetPart = "HumanoidRootPart",
    Mode = "RightMouseClick",
    StickyAim = false,
    AutoSwitch = true,
    Resolver = false,
    AimShake = 0,
    -- FOV
    FOVVisible = true,
    FOVRadius = 150,
    -- ESP
    ESPEnabled = true,
    ESPNames = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTracers = true,
    ESPTracerOrigin = "Bottom",
    HighlightFillTransparency = 0.35,
    HighlightColor = Color3.fromRGB(0, 255, 255),
    -- Misc
    SpeedEnabled = false,
    SpeedValue = 16,
    JumpPowerEnabled = false,
    JumpPowerValue = 50,
    InfiniteJump = false,
    Noclip = false,
    AntiAFK = true,
    FlyEnabled = false,
    FlySpeed = 50,
    -- Internal
    SelectedPlayers = {},
    CurrentTarget = nil,
    Locked = false,
}

-- =============================================
-- CLEANUP ESKI GUI
-- =============================================
for _, loc in ipairs({game:GetService("CoreGui"), LocalPlayer:FindFirstChild("PlayerGui")}) do
    pcall(function()
        local old = loc:FindFirstChild("DHLV2_babaniz")
        if old then old:Destroy() end
    end)
end
pcall(function()
    if gethui then
        local old = gethui():FindFirstChild("DHLV2_babaniz")
        if old then old:Destroy() end
    end
end)
for _, plr in ipairs(Players:GetPlayers()) do
    pcall(function()
        if plr.Character then
            local h = plr.Character:FindFirstChild("DHL_Highlight")
            if h then h:Destroy() end
        end
    end)
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
    ScreenGui = guiParent
    ScreenGui.Name = "DHLV2_babaniz"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
else
    ScreenGui.Parent = guiParent
end

-- Draggable
local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or frame
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
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
MainFrame.Size = UDim2.new(0, 540, 0, 420)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(139, 0, 0)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Drag handle (title bar)
local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1, 0, 0, 45)
DragHandle.BackgroundTransparency = 1
DragHandle.Text = ""
DragHandle.AutoButtonColor = false
DragHandle.ZIndex = 10
DragHandle.Parent = MainFrame
makeDraggable(MainFrame, DragHandle)

-- Background image
local BgImage = Instance.new("ImageLabel")
BgImage.Name = "Background"
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.ImageTransparency = 0.85
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ZIndex = 0
BgImage.Parent = MainFrame
local BgCorner = Instance.new("UICorner")
BgCorner.CornerRadius = UDim.new(0, 8)
BgCorner.Parent = BgImage

pcall(function()
    local url = "https://raw.githubusercontent.com/whycroxin-svg/DHL/main/bg.png"
    local fn = "DHLV2_bg.png"
    if writefile and isfile and getcustomasset then
        if not isfile(fn) then writefile(fn, game:HttpGet(url)) end
        BgImage.Image = getcustomasset(fn)
    end
end)

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 22)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "DHL V2"
TitleLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.ZIndex = 5
TitleLabel.Parent = MainFrame

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Size = UDim2.new(1, 0, 0, 14)
CreditLabel.Position = UDim2.new(0, 0, 0, 26)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "By babaniz"
CreditLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
CreditLabel.TextSize = 11
CreditLabel.Font = Enum.Font.GothamSemibold
CreditLabel.ZIndex = 5
CreditLabel.Parent = MainFrame

-- =============================================
-- TAB SYSTEM
-- =============================================
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 44)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 5
TabBar.Parent = MainFrame

local tabNames = {"Aimlock", "Visuals", "Players", "Misc"}
local tabPages = {}
local tabButtons = {}
local activeTab = "Aimlock"

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -20, 1, -84)
ContentArea.Position = UDim2.new(0, 10, 0, 78)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.ZIndex = 2
ContentArea.Parent = MainFrame

for i, name in ipairs(tabNames) do
    -- Tab button
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1 / #tabNames, -4, 1, -4)
    btn.Position = UDim2.new((i - 1) / #tabNames, 2, 0, 2)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 6
    btn.Parent = TabBar

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 4)
    bc.Parent = btn

    tabButtons[name] = btn

    -- Tab page (ScrollingFrame)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = (i == 1)
    page.ZIndex = 2
    page.Active = true
    page.Parent = ContentArea

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = page

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 4)
    padding.PaddingTop = UDim.new(0, 4)
    padding.Parent = page

    tabPages[name] = page

    btn.MouseButton1Click:Connect(function()
        activeTab = name
        for n, p in pairs(tabPages) do
            p.Visible = (n == name)
        end
        for n, b in pairs(tabButtons) do
            b.BackgroundColor3 = (n == name) and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(40, 40, 40)
        end
    end)
end

-- =============================================
-- UI HELPERS
-- =============================================
local function addToggle(page, name, default, callback, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 28)
    btn.BackgroundColor3 = default and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(50, 50, 50)
    btn.BorderSizePixel = 0
    btn.Text = name .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.LayoutOrder = order or 0
    btn.ZIndex = 3
    btn.Parent = page

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(50, 50, 50)
        if callback then callback(state) end
    end)

    return function() return state end, function(v)
        state = v
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(50, 50, 50)
        if callback then callback(state) end
    end
end

local function addSlider(page, name, min, max, default, callback, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -8, 0, 36)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order or 0
    container.ZIndex = 3
    container.Parent = page

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 14)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. string.format("%.3f", default)
    label.TextColor3 = Color3.fromRGB(210, 210, 210)
    label.TextSize = 11
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.ZIndex = 3
    label.Parent = container

    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(1, 0, 0, 10)
    bg.Position = UDim2.new(0, 0, 0, 18)
    bg.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    bg.BorderSizePixel = 0
    bg.Text = ""
    bg.AutoButtonColor = false
    bg.ZIndex = 3
    bg.Parent = container

    local bgC = Instance.new("UICorner")
    bgC.CornerRadius = UDim.new(0, 4)
    bgC.Parent = bg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    fill.BorderSizePixel = 0
    fill.ZIndex = 3
    fill.Parent = bg

    local fC = Instance.new("UICorner")
    fC.CornerRadius = UDim.new(0, 4)
    fC.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    knob.BorderSizePixel = 0
    knob.ZIndex = 4
    knob.Parent = bg

    local kC = Instance.new("UICorner")
    kC.CornerRadius = UDim.new(1, 0)
    kC.Parent = knob

    local value = default
    local sliding = false

    local function update(px)
        local ax, as = bg.AbsolutePosition.X, bg.AbsoluteSize.X
        if as == 0 then return end
        local p = math.clamp((px - ax) / as, 0, 1)
        value = min + (max - min) * p
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, 0, 0.5, 0)
        label.Text = name .. ": " .. string.format("%.3f", value)
        if callback then callback(value) end
    end

    bg.MouseButton1Down:Connect(function(x) sliding = true; update(x) end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)

    return function() return value end
end

local function addCycleButton(page, name, options, default, callback, order)
    local idx = 1
    for i, v in ipairs(options) do
        if v == default then idx = i; break end
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.BorderSizePixel = 0
    btn.Text = name .. ": " .. options[idx]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.LayoutOrder = order or 0
    btn.ZIndex = 3
    btn.Parent = page

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(80, 0, 0)
    s.Thickness = 1
    s.Parent = btn

    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        btn.Text = name .. ": " .. options[idx]
        if callback then callback(options[idx]) end
    end)

    return function() return options[idx] end
end

local function addSeparator(page, order)
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -16, 0, 1)
    sep.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    sep.BorderSizePixel = 0
    sep.LayoutOrder = order or 0
    sep.ZIndex = 3
    sep.Parent = page
end

local function addLabel(page, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -8, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 80, 80)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0
    lbl.ZIndex = 3
    lbl.Parent = page
end

-- =============================================
-- PAGE 1: AIMLOCK
-- =============================================
local p1 = tabPages["Aimlock"]

addLabel(p1, "-- CAMLOCK --", 1)
local getCamlock = addToggle(p1, "Camlock System", Settings.CamlockEnabled, function(v) Settings.CamlockEnabled = v end, 2)
local getWallCheck = addToggle(p1, "Wall Check", Settings.WallCheck, function(v) Settings.WallCheck = v end, 3)
local getStickyAim = addToggle(p1, "Sticky Aim", Settings.StickyAim, function(v) Settings.StickyAim = v end, 4)
local getAutoSwitch = addToggle(p1, "Auto Switch", Settings.AutoSwitch, function(v) Settings.AutoSwitch = v end, 5)
local getResolver = addToggle(p1, "Resolver", Settings.Resolver, function(v) Settings.Resolver = v end, 6)

addSeparator(p1, 7)
addLabel(p1, "-- SETTINGS --", 8)

local getMode = addCycleButton(p1, "Mode", {"Right Mouse Click", "Nearest Cursor", "Toggle Q"}, "Right Mouse Click", function(v)
    Settings.Mode = v:gsub(" ", "")
end, 9)

local getTargetPart = addCycleButton(p1, "Target Part", {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso"}, Settings.TargetPart, function(v)
    Settings.TargetPart = v
end, 10)

local getSmoothness = addSlider(p1, "Smoothness", 0.01, 1.0, Settings.Smoothness, function(v) Settings.Smoothness = v end, 11)
local getPrediction = addSlider(p1, "Prediction", 0.0, 1.0, Settings.Prediction, function(v) Settings.Prediction = v end, 12)
local getAimShake = addSlider(p1, "Aim Shake", 0, 5, Settings.AimShake, function(v) Settings.AimShake = v end, 13)

addSeparator(p1, 14)
addLabel(p1, "-- FOV CIRCLE --", 15)

local getFOVVisible = addToggle(p1, "FOV Circle", Settings.FOVVisible, function(v) Settings.FOVVisible = v end, 16)
local getFOVRadius = addSlider(p1, "FOV Radius", 20, 500, Settings.FOVRadius, function(v) Settings.FOVRadius = v end, 17)

-- =============================================
-- PAGE 2: VISUALS (ESP)
-- =============================================
local p2 = tabPages["Visuals"]

addLabel(p2, "-- HIGHLIGHT ESP --", 1)
local getESP = addToggle(p2, "ESP Highlight", Settings.ESPEnabled, function(v) Settings.ESPEnabled = v end, 2)

local getHighlightColor = addCycleButton(p2, "Highlight Color", {"Cyan", "Red", "Green", "Yellow", "Purple", "White", "Orange"}, "Cyan", function(v)
    local colors = {
        Cyan = Color3.fromRGB(0, 255, 255),
        Red = Color3.fromRGB(255, 0, 0),
        Green = Color3.fromRGB(0, 255, 0),
        Yellow = Color3.fromRGB(255, 255, 0),
        Purple = Color3.fromRGB(180, 0, 255),
        White = Color3.fromRGB(255, 255, 255),
        Orange = Color3.fromRGB(255, 150, 0),
    }
    Settings.HighlightColor = colors[v] or Color3.fromRGB(0, 255, 255)
end, 3)

local getFillTransparency = addSlider(p2, "Fill Transparency", 0, 1, Settings.HighlightFillTransparency, function(v)
    Settings.HighlightFillTransparency = v
end, 4)

addSeparator(p2, 5)
addLabel(p2, "-- INFO DISPLAY --", 6)

local getESPNames = addToggle(p2, "Name Tags", Settings.ESPNames, function(v) Settings.ESPNames = v end, 7)
local getESPHealth = addToggle(p2, "Health Display", Settings.ESPHealth, function(v) Settings.ESPHealth = v end, 8)
local getESPDistance = addToggle(p2, "Distance Display", Settings.ESPDistance, function(v) Settings.ESPDistance = v end, 9)

addSeparator(p2, 10)
addLabel(p2, "-- TRACERS --", 11)

local getESPTracers = addToggle(p2, "Tracers", Settings.ESPTracers, function(v) Settings.ESPTracers = v end, 12)
local getTracerOrigin = addCycleButton(p2, "Tracer Origin", {"Bottom", "Center", "Mouse"}, Settings.ESPTracerOrigin, function(v)
    Settings.ESPTracerOrigin = v
end, 13)

-- =============================================
-- PAGE 3: PLAYERS
-- =============================================
local p3 = tabPages["Players"]

-- Selected count
local SelectCountLabel = Instance.new("TextLabel")
SelectCountLabel.Size = UDim2.new(1, -8, 0, 16)
SelectCountLabel.BackgroundTransparency = 1
SelectCountLabel.Text = "Selected: 0"
SelectCountLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
SelectCountLabel.TextSize = 11
SelectCountLabel.Font = Enum.Font.GothamSemibold
SelectCountLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectCountLabel.LayoutOrder = 1
SelectCountLabel.ZIndex = 3
SelectCountLabel.Parent = p3

-- Select All / Clear
local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, -8, 0, 24)
btnRow.BackgroundTransparency = 1
btnRow.LayoutOrder = 2
btnRow.ZIndex = 3
btnRow.Parent = p3

local SelectAllBtn = Instance.new("TextButton")
SelectAllBtn.Size = UDim2.new(0.48, 0, 1, 0)
SelectAllBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
SelectAllBtn.BorderSizePixel = 0
SelectAllBtn.Text = "Select All"
SelectAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectAllBtn.TextSize = 11
SelectAllBtn.Font = Enum.Font.GothamBold
SelectAllBtn.AutoButtonColor = false
SelectAllBtn.ZIndex = 3
SelectAllBtn.Parent = btnRow
Instance.new("UICorner", SelectAllBtn).CornerRadius = UDim.new(0, 4)

local ClearAllBtn = Instance.new("TextButton")
ClearAllBtn.Size = UDim2.new(0.48, 0, 1, 0)
ClearAllBtn.Position = UDim2.new(0.52, 0, 0, 0)
ClearAllBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
ClearAllBtn.BorderSizePixel = 0
ClearAllBtn.Text = "Clear"
ClearAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearAllBtn.TextSize = 11
ClearAllBtn.Font = Enum.Font.GothamBold
ClearAllBtn.AutoButtonColor = false
ClearAllBtn.ZIndex = 3
ClearAllBtn.Parent = btnRow
Instance.new("UICorner", ClearAllBtn).CornerRadius = UDim.new(0, 4)

-- Search
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -8, 0, 26)
SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "Search Players..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
SearchBox.TextSize = 12
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false
SearchBox.LayoutOrder = 3
SearchBox.ZIndex = 3
SearchBox.Parent = p3
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

-- Player scroll
local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, -8, 0, 220)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.BorderSizePixel = 0
PlayerScroll.ScrollBarThickness = 3
PlayerScroll.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerScroll.LayoutOrder = 4
PlayerScroll.ZIndex = 3
PlayerScroll.Active = true
PlayerScroll.Parent = p3

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 3)
PlayerListLayout.Parent = PlayerScroll

-- =============================================
-- PAGE 4: MISC
-- =============================================
local p4 = tabPages["Misc"]

addLabel(p4, "-- MOVEMENT --", 1)

local getSpeed, setSpeed = addToggle(p4, "Speed Hack", Settings.SpeedEnabled, function(v) Settings.SpeedEnabled = v end, 2)
local getSpeedValue = addSlider(p4, "Walk Speed", 16, 200, Settings.SpeedValue, function(v) Settings.SpeedValue = v end, 3)
local getJumpPower, setJumpPower = addToggle(p4, "Jump Power", Settings.JumpPowerEnabled, function(v) Settings.JumpPowerEnabled = v end, 4)
local getJumpValue = addSlider(p4, "Jump Value", 50, 500, Settings.JumpPowerValue, function(v) Settings.JumpPowerValue = v end, 5)
local getInfJump = addToggle(p4, "Infinite Jump", Settings.InfiniteJump, function(v) Settings.InfiniteJump = v end, 6)

addSeparator(p4, 7)
addLabel(p4, "-- EXPLOITS --", 8)

local getNoclip = addToggle(p4, "Noclip", Settings.Noclip, function(v) Settings.Noclip = v end, 9)
local getFly, setFly = addToggle(p4, "Fly", Settings.FlyEnabled, function(v) Settings.FlyEnabled = v end, 10)
local getFlySpeed = addSlider(p4, "Fly Speed", 10, 300, Settings.FlySpeed, function(v) Settings.FlySpeed = v end, 11)

addSeparator(p4, 12)
addLabel(p4, "-- UTILITY --", 13)

local getAntiAFK = addToggle(p4, "Anti-AFK", Settings.AntiAFK, function(v) Settings.AntiAFK = v end, 14)

-- =============================================
-- PLAYER LIST LOGIC
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
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        Settings.SelectedPlayers[player.Name] = player
        btn.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    updateSelectCount()
end

local function createPlayerButton(player)
    if player == LocalPlayer then return end
    local sel = isSelected(player)
    local btn = Instance.new("TextButton")
    btn.Name = "PLR_" .. player.Name
    btn.Size = UDim2.new(1, -4, 0, 26)
    btn.BackgroundColor3 = sel and Color3.fromRGB(139, 0, 0) or Color3.fromRGB(45, 45, 45)
    btn.BorderSizePixel = 0
    btn.Text = "  " .. player.DisplayName
    btn.TextColor3 = sel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    btn.Parent = PlayerScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(function() toggleSelect(player, btn) end)
    playerButtons[player.Name] = btn
end

local function refreshPlayerList()
    for _, btn in pairs(playerButtons) do
        if btn and btn.Parent then btn:Destroy() end
    end
    playerButtons = {}
    local search = SearchBox.Text:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if search == "" or player.DisplayName:lower():find(search, 1, true) or player.Name:lower():find(search, 1, true) then
                createPlayerButton(player)
            end
        end
    end
    updateSelectCount()
end

SelectAllBtn.MouseButton1Click:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then Settings.SelectedPlayers[p.Name] = p end
    end
    refreshPlayerList()
end)

ClearAllBtn.MouseButton1Click:Connect(function()
    for name in pairs(highlightObjects) do removeHighlight(name) end
    Settings.SelectedPlayers = {}
    Settings.CurrentTarget = nil
    refreshPlayerList()
end)

refreshPlayerList()
Players.PlayerAdded:Connect(function() task.wait(0.5); refreshPlayerList() end)
Players.PlayerRemoving:Connect(function(player)
    Settings.SelectedPlayers[player.Name] = nil
    if Settings.CurrentTarget == player then Settings.CurrentTarget = nil end
    removeHighlight(player.Name)
    task.wait(0.1); refreshPlayerList()
end)
SearchBox:GetPropertyChangedSignal("Text"):Connect(refreshPlayerList)

-- =============================================
-- FOV CIRCLE
-- =============================================
local fovCircle, usingDrawing = nil, false
pcall(function()
    fovCircle = Drawing.new("Circle")
    fovCircle.Color = Color3.fromRGB(255, 0, 0)
    fovCircle.Thickness = 1.5
    fovCircle.NumSides = 64
    fovCircle.Radius = Settings.FOVRadius
    fovCircle.Filled = false
    fovCircle.Visible = Settings.FOVVisible
    fovCircle.Transparency = 0.8
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
            highlightObjects[player.Name]:Destroy()
            highlightObjects[player.Name] = nil
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
        esp.name = Drawing.new("Text"); esp.name.Color = Settings.HighlightColor; esp.name.Size = 14; esp.name.Center = true; esp.name.Outline = true; esp.name.OutlineColor = Color3.fromRGB(0,0,0); esp.name.Visible = false; esp.name.Font = 2
        esp.distance = Drawing.new("Text"); esp.distance.Color = Color3.fromRGB(200,200,200); esp.distance.Size = 12; esp.distance.Center = true; esp.distance.Outline = true; esp.distance.OutlineColor = Color3.fromRGB(0,0,0); esp.distance.Visible = false; esp.distance.Font = 2
        esp.healthText = Drawing.new("Text"); esp.healthText.Color = Color3.fromRGB(0,255,0); esp.healthText.Size = 12; esp.healthText.Center = true; esp.healthText.Outline = true; esp.healthText.OutlineColor = Color3.fromRGB(0,0,0); esp.healthText.Visible = false; esp.healthText.Font = 2
        esp.tracer = Drawing.new("Line"); esp.tracer.Color = Settings.HighlightColor; esp.tracer.Thickness = 1; esp.tracer.Visible = false; esp.tracer.Transparency = 0.7
        espDrawings[player.Name] = esp
    end
end

function removeHighlight(playerName)
    if highlightObjects[playerName] then
        pcall(function() highlightObjects[playerName]:Destroy() end)
        highlightObjects[playerName] = nil
    end
    if espDrawings[playerName] then
        for _, obj in pairs(espDrawings[playerName]) do pcall(function() obj:Remove() end) end
        espDrawings[playerName] = nil
    end
end

local function hideDrawings(playerName)
    if espDrawings[playerName] then
        for _, obj in pairs(espDrawings[playerName]) do pcall(function() obj.Visible = false end) end
    end
end

local function updateESP()
    if not usingDrawing then return end
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

                    -- Update highlight properties
                    if highlightObjects[player.Name] then
                        highlightObjects[player.Name].FillColor = Settings.HighlightColor
                        highlightObjects[player.Name].OutlineColor = Settings.HighlightColor
                        highlightObjects[player.Name].FillTransparency = getFillTransparency()
                    end

                    if espDrawings[player.Name] then
                        local esp = espDrawings[player.Name]
                        local headPos = head and head.Position or rootPart.Position + Vector3.new(0, 2, 0)
                        local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)

                        if onScreen then
                            local dist = math.floor((Camera.CFrame.Position - rootPart.Position).Magnitude)
                            local hp = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                            local yOff = -16

                            -- Name
                            if getESPNames() then
                                esp.name.Text = player.DisplayName
                                esp.name.Position = Vector2.new(screenPos.X, screenPos.Y + yOff)
                                esp.name.Color = Settings.HighlightColor
                                esp.name.Visible = true
                                yOff = yOff - 16
                            else esp.name.Visible = false end

                            -- Health
                            if getESPHealth() then
                                esp.healthText.Text = hp .. "% HP"
                                esp.healthText.Position = Vector2.new(screenPos.X, screenPos.Y + yOff)
                                esp.healthText.Color = Color3.fromRGB(255*(1-hp/100), 255*(hp/100), 0)
                                esp.healthText.Visible = true
                                yOff = yOff - 14
                            else esp.healthText.Visible = false end

                            -- Distance
                            if getESPDistance() then
                                esp.distance.Text = "[" .. dist .. "m]"
                                esp.distance.Position = Vector2.new(screenPos.X, screenPos.Y + yOff)
                                esp.distance.Visible = true
                            else esp.distance.Visible = false end

                            -- Tracer
                            if getESPTracers() then
                                local origin = getTracerOrigin()
                                local fromPos
                                if origin == "Bottom" then
                                    fromPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                elseif origin == "Center" then
                                    fromPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                                else
                                    fromPos = Vector2.new(Mouse.X, Mouse.Y)
                                end
                                esp.tracer.From = fromPos
                                esp.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                                esp.tracer.Color = Settings.HighlightColor
                                esp.tracer.Visible = true
                            else esp.tracer.Visible = false end
                        else
                            hideDrawings(player.Name)
                        end
                    end
                else
                    removeHighlight(player.Name)
                end
            else
                removeHighlight(player.Name)
            end
        end
    end
end

-- Character respawn
for _, plr in ipairs(Players:GetPlayers()) do
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
    local dir = (targetPart.Position - origin)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {LocalPlayer.Character}
    local result = workspace:Raycast(origin, dir, rp)
    if result then
        local tc = targetPart:FindFirstAncestorWhichIsA("Model")
        if tc and result.Instance:IsDescendantOf(tc) then return true end
        return false
    end
    return true
end

-- =============================================
-- CLOSEST TARGET (secili oyunculardan)
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
                local sp, onScreen = Camera:WorldToScreenPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if d < fov and d < shortest then
                        if getStickyAim() or isVisible(part) then
                            shortest = d; closest = player
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- Cycle target
local cycleIdx = 0
local function cycleTarget()
    local list = {}
    for _, p in pairs(Settings.SelectedPlayers) do
        if p and p.Character then
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then table.insert(list, p) end
        end
    end
    if #list == 0 then Settings.CurrentTarget = nil; return end
    cycleIdx = (cycleIdx % #list) + 1
    Settings.CurrentTarget = list[cycleIdx]
end

-- =============================================
-- INPUT
-- =============================================
local locked = false

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    -- Camlock
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

    -- Infinite jump
    if input.KeyCode == Enum.KeyCode.Space and getInfJump() then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end

    -- ESC fix
    if input.KeyCode == Enum.KeyCode.Escape and SearchBox:IsFocused() then
        SearchBox:ReleaseFocus()
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
-- Noclip
local noclipConn
RunService.Stepped:Connect(function()
    if getNoclip() and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Speed + Jump Power
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if getSpeed() then hum.WalkSpeed = getSpeedValue() end
            if getJumpPower() then hum.JumpPower = getJumpValue() end
        end
    end
end)

-- Fly
local flyBV = nil
local flyConn = nil

RunService.RenderStepped:Connect(function()
    if getFly() then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            if not flyBV or flyBV.Parent ~= root then
                if flyBV then pcall(function() flyBV:Destroy() end) end
                flyBV = Instance.new("BodyVelocity")
                flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                flyBV.Velocity = Vector3.new(0, 0, 0)
                flyBV.Parent = root

                -- Anti-gravity
                local bg = root:FindFirstChild("DHL_AntiGrav")
                if not bg then
                    bg = Instance.new("BodyGyro")
                    bg.Name = "DHL_AntiGrav"
                    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    bg.Parent = root
                end
            end

            local speed = getFlySpeed()
            local dir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

            if dir.Magnitude > 0 then dir = dir.Unit end
            flyBV.Velocity = dir * speed

            local bg = root:FindFirstChild("DHL_AntiGrav")
            if bg then bg.CFrame = Camera.CFrame end
        end
    else
        if flyBV then pcall(function() flyBV:Destroy() end); flyBV = nil end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local bg = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("DHL_AntiGrav")
            if bg then bg:Destroy() end
        end
    end
end)

-- Anti-AFK
pcall(function()
    if getAntiAFK() then
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    end
end)

-- =============================================
-- RENDER STEP â€” CAMLOCK + FOV + ESP
-- =============================================
RunService.RenderStepped:Connect(function()
    -- FOV
    local fovR = getFOVRadius()
    local fovV = getFOVVisible()
    if usingDrawing and fovCircle then
        fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        fovCircle.Radius = fovR
        fovCircle.Visible = fovV
    end

    -- ESP
    updateESP()

    -- Camlock
    if not getCamlock() then
        locked = false; Settings.CurrentTarget = nil; return
    end

    if Settings.Mode == "NearestCursor" then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            Settings.CurrentTarget = getClosestFromSelected()
            locked = Settings.CurrentTarget ~= nil
        else locked = false; Settings.CurrentTarget = nil end
    end

    if locked and Settings.CurrentTarget and Settings.CurrentTarget.Character then
        local part = Settings.CurrentTarget.Character:FindFirstChild(Settings.TargetPart)
        if part then
            local hum = Settings.CurrentTarget.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local canSee = isVisible(part)
                if canSee or getStickyAim() then
                    local smoothness = getSmoothness()
                    local prediction = getPrediction()
                    local shake = getAimShake()

                    local vel = Vector3.new(0,0,0)
                    pcall(function() vel = part.AssemblyLinearVelocity end)
                    vel = vel or Vector3.new(0,0,0)

                    -- Resolver (velocity desync correction)
                    if getResolver() then
                        vel = vel * 1.15
                    end

                    local predictedPos = part.Position + (vel * prediction)

                    -- Shake
                    if shake > 0 then
                        predictedPos = predictedPos + Vector3.new(
                            math.random(-shake * 10, shake * 10) / 10,
                            math.random(-shake * 10, shake * 10) / 10,
                            math.random(-shake * 10, shake * 10) / 10
                        )
                    end

                    local curCF = Camera.CFrame
                    local tgtCF = CFrame.new(curCF.Position, predictedPos)
                    Camera.CFrame = curCF:Lerp(tgtCF, smoothness)
                else
                    if getWallCheck() and not getStickyAim() then
                        -- Auto switch
                        if getAutoSwitch() then
                            Settings.CurrentTarget = getClosestFromSelected()
                            locked = Settings.CurrentTarget ~= nil
                        else
                            locked = false; Settings.CurrentTarget = nil
                        end
                    end
                end
            else
                -- Target oldu, auto switch
                if getAutoSwitch() then
                    Settings.CurrentTarget = getClosestFromSelected()
                    locked = Settings.CurrentTarget ~= nil
                else
                    locked = false; Settings.CurrentTarget = nil
                end
            end
        end
    end
end)

-- =============================================
-- ESC MENU HIDE
-- =============================================
local guiWasVisible = true
pcall(function()
    GuiService.MenuOpened:Connect(function()
        guiWasVisible = MainFrame.Visible
        MainFrame.Visible = false
    end)
    GuiService.MenuClosed:Connect(function()
        MainFrame.Visible = guiWasVisible
    end)
end)

-- Cleanup on death
LocalPlayer.CharacterRemoving:Connect(function()
    for name in pairs(highlightObjects) do removeHighlight(name) end
    if flyBV then pcall(function() flyBV:Destroy() end); flyBV = nil end
end)

-- ZIndex fix
task.defer(function()
    task.wait(0.3)
    for _, child in ipairs(MainFrame:GetDescendants()) do
        if child:IsA("GuiObject") and child ~= BgImage and child.ZIndex < 2 then
            child.ZIndex = 2
        end
    end
end)

-- =============================================
-- BILDIRIM
-- =============================================
print("[DHL V2] by babaniz â€” FULL LOAD!")
print("[DHL V2] Right Shift = GUI ac/kapa")
print("[DHL V2] Tabs: Aimlock | Visuals | Players | Misc")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DHL V2",
        Text = "by babaniz | Full Blatant Suite",
        Duration = 5
    })
end)
