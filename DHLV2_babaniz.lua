--[[
    DHL V2 - by babaniz
    Blatant Aimlock + ESP + Misc â€” Full Feature
    Tab sistemi + Keybind sistemi
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
    CamlockEnabled = true,
    WallCheck = true,
    Smoothness = 0.450,
    Prediction = 0.100,
    TargetPart = "HumanoidRootPart",
    Mode = "RightMouseClick",
    StickyAim = false,
    AutoSwitch = true,
    Resolver = false,
    SkipDowned = true,
    DownedThreshold = 0.20,
    AimShake = 0,
    FOVVisible = true,
    FOVRadius = 150,
    ESPEnabled = true,
    ESPNames = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTracers = true,
    ESPTracerOrigin = "Bottom",
    HighlightFillTransparency = 0.35,
    HighlightColor = Color3.fromRGB(0, 255, 255),
    SpeedEnabled = false,
    SpeedValue = 16,
    JumpPowerEnabled = false,
    JumpPowerValue = 50,
    InfiniteJump = false,
    Noclip = false,
    AntiAFK = true,
    FlyEnabled = false,
    FlySpeed = 50,
    SelectedPlayers = {},
    CurrentTarget = nil,
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

-- Draggable
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
MainFrame.Size = UDim2.new(0, 540, 0, 440)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local ms = Instance.new("UIStroke", MainFrame); ms.Color = Color3.fromRGB(139, 0, 0); ms.Thickness = 1.5

-- Drag handle
local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1, 0, 0, 45); DragHandle.BackgroundTransparency = 1
DragHandle.Text = ""; DragHandle.AutoButtonColor = false; DragHandle.ZIndex = 10; DragHandle.Parent = MainFrame
makeDraggable(MainFrame, DragHandle)

-- Background image
local BgImage = Instance.new("ImageLabel")
BgImage.Name = "Background"; BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1; BgImage.ImageTransparency = 0.85
BgImage.ScaleType = Enum.ScaleType.Crop; BgImage.ZIndex = 0; BgImage.Parent = MainFrame
Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 8)
pcall(function()
    local fn = "DHLV2_bg.png"
    if writefile and isfile and getcustomasset then
        if not isfile(fn) then writefile(fn, game:HttpGet("https://raw.githubusercontent.com/whycroxin-svg/DHL/main/bg.png")) end
        BgImage.Image = getcustomasset(fn)
    end
end)

-- Title
local tl = Instance.new("TextLabel"); tl.Size = UDim2.new(1,0,0,22); tl.Position = UDim2.new(0,0,0,5)
tl.BackgroundTransparency = 1; tl.Text = "DHL V2"; tl.TextColor3 = Color3.fromRGB(200,0,0)
tl.TextSize = 20; tl.Font = Enum.Font.GothamBold; tl.ZIndex = 5; tl.Parent = MainFrame

local cl = Instance.new("TextLabel"); cl.Size = UDim2.new(1,0,0,14); cl.Position = UDim2.new(0,0,0,26)
cl.BackgroundTransparency = 1; cl.Text = "By babaniz"; cl.TextColor3 = Color3.fromRGB(200,0,0)
cl.TextSize = 11; cl.Font = Enum.Font.GothamSemibold; cl.ZIndex = 5; cl.Parent = MainFrame

-- =============================================
-- TAB SYSTEM
-- =============================================
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,0,0,30); TabBar.Position = UDim2.new(0,0,0,44)
TabBar.BackgroundColor3 = Color3.fromRGB(25,25,25); TabBar.BorderSizePixel = 0; TabBar.ZIndex = 5; TabBar.Parent = MainFrame

local tabNames = {"Aimlock", "Visuals", "Players", "Misc", "Spectate"}
local tabPages = {}
local tabButtons = {}
local activeTab = "Aimlock"

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1,-20,1,-84); ContentArea.Position = UDim2.new(0,10,0,78)
ContentArea.BackgroundTransparency = 1; ContentArea.ZIndex = 2; ContentArea.Parent = MainFrame

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#tabNames,-4,1,-4); btn.Position = UDim2.new((i-1)/#tabNames,2,0,2)
    btn.BackgroundColor3 = i==1 and Color3.fromRGB(180,0,0) or Color3.fromRGB(40,40,40)
    btn.BorderSizePixel = 0; btn.Text = name; btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 12; btn.Font = Enum.Font.GothamBold; btn.AutoButtonColor = false; btn.ZIndex = 6; btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    tabButtons[name] = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1,0,1,0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0
    page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = Color3.fromRGB(139,0,0)
    page.CanvasSize = UDim2.new(0,0,0,0); page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = (i==1); page.ZIndex = 2; page.Active = true; page.Parent = ContentArea

    local layout = Instance.new("UIListLayout", page); layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0,5)
    local pad = Instance.new("UIPadding", page); pad.PaddingLeft = UDim.new(0,4); pad.PaddingRight = UDim.new(0,4); pad.PaddingTop = UDim.new(0,4)

    tabPages[name] = page
    btn.MouseButton1Click:Connect(function()
        activeTab = name
        for n,p in pairs(tabPages) do p.Visible = (n==name) end
        for n,b in pairs(tabButtons) do b.BackgroundColor3 = (n==name) and Color3.fromRGB(180,0,0) or Color3.fromRGB(40,40,40) end
    end)
end

-- =============================================
-- KEYBIND SYSTEM
-- =============================================
local activeKeybindBtn = nil -- simdiki dinlenen keybind butonu
local keybindCallbacks = {} -- keycode -> {callback, getState}

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
    btn.BackgroundColor3 = default and Color3.fromRGB(180,0,0) or Color3.fromRGB(50,50,50)
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
        btn.BackgroundColor3 = state and Color3.fromRGB(180,0,0) or Color3.fromRGB(50,50,50)
        if callback then callback(state) end
    end
    btn.MouseButton1Click:Connect(doToggle)

    -- Keybind butonu
    local assignedKey = nil
    if withKeybind then
        local kbBtn = Instance.new("TextButton")
        kbBtn.Size = UDim2.new(0, 60, 1, 0)
        kbBtn.Position = UDim2.new(1, -60, 0, 0)
        kbBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        kbBtn.BorderSizePixel = 0
        kbBtn.Text = "[ - ]"
        kbBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        kbBtn.TextSize = 10; kbBtn.Font = Enum.Font.GothamBold; kbBtn.AutoButtonColor = false; kbBtn.ZIndex = 4
        kbBtn.Parent = row
        Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 4)
        local kbStroke = Instance.new("UIStroke", kbBtn); kbStroke.Color = Color3.fromRGB(80,0,0); kbStroke.Thickness = 1

        kbBtn.MouseButton1Click:Connect(function()
            -- Eski keybind'i kaldir
            if assignedKey then
                keybindCallbacks[assignedKey] = nil
                assignedKey = nil
            end

            if activeKeybindBtn == kbBtn then
                activeKeybindBtn = nil
                kbBtn.Text = "[ - ]"
                kbBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
                return
            end

            -- Dinleme moduna gec
            if activeKeybindBtn then
                activeKeybindBtn.Text = "[ - ]"
                activeKeybindBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            activeKeybindBtn = kbBtn
            kbBtn.Text = "[...]"
            kbBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
        end)

        -- Store reference for keybind assignment
        kbBtn:SetAttribute("ToggleName", name)
        kbBtn:SetAttribute("DoToggle", "true")

        -- Keybind atama icin closure
        row:SetAttribute("IsKeybindRow", "true")

        -- Keybind assign fonksiyonu
        local function assignKeybind(keyCode)
            assignedKey = keyCode
            kbBtn.Text = "[" .. keyCode.Name .. "]"
            kbBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
            keybindCallbacks[keyCode] = doToggle
            activeKeybindBtn = nil
        end

        -- Store assign function
        kbBtn:SetAttribute("AssignFunc", "")
        -- We'll use a different approach - store in a table
        if not _G.DHL_KeybindAssigners then _G.DHL_KeybindAssigners = {} end
        _G.DHL_KeybindAssigners[kbBtn] = assignKeybind
    end

    return function() return state end, function(v)
        state = v
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(180,0,0) or Color3.fromRGB(50,50,50)
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
    bg.BackgroundColor3 = Color3.fromRGB(45,45,45); bg.BorderSizePixel = 0
    bg.Text = ""; bg.AutoButtonColor = false; bg.ZIndex = 3; bg.Parent = container
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0,4)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(180,0,0); fill.BorderSizePixel = 0; fill.ZIndex = 3; fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,4)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,12,0,12); knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new((default-min)/(max-min),0,0.5,0)
    knob.BackgroundColor3 = Color3.fromRGB(200,0,0); knob.BorderSizePixel = 0; knob.ZIndex = 4; knob.Parent = bg
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
    btn.Size = UDim2.new(1,-8,0,28); btn.BackgroundColor3 = Color3.fromRGB(50,50,50); btn.BorderSizePixel = 0
    btn.Text = name .. ": " .. options[idx]; btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 12; btn.Font = Enum.Font.GothamBold; btn.AutoButtonColor = false
    btn.LayoutOrder = order or 0; btn.ZIndex = 3; btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,5)
    local s = Instance.new("UIStroke", btn); s.Color = Color3.fromRGB(80,0,0); s.Thickness = 1
    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1; btn.Text = name .. ": " .. options[idx]
        if callback then callback(options[idx]) end
    end)
    return function() return options[idx] end
end

local function addSeparator(page, order)
    local sep = Instance.new("Frame"); sep.Size = UDim2.new(1,-16,0,1)
    sep.BackgroundColor3 = Color3.fromRGB(80,0,0); sep.BorderSizePixel = 0
    sep.LayoutOrder = order or 0; sep.ZIndex = 3; sep.Parent = page
end

local function addLabel(page, text, order)
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,-8,0,18); lbl.BackgroundTransparency = 1
    lbl.Text = text; lbl.TextColor3 = Color3.fromRGB(255,80,80); lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0; lbl.ZIndex = 3; lbl.Parent = page
end

-- =============================================
-- PAGE 1: AIMLOCK
-- =============================================
local p1 = tabPages["Aimlock"]
addLabel(p1, "-- CAMLOCK --", 1)
local getCamlock = addToggle(p1, "Camlock System", true, nil, 2, true)
local getWallCheck = addToggle(p1, "Wall Check", true, nil, 3, true)
local getStickyAim = addToggle(p1, "Sticky Aim", false, nil, 4, true)
local getAutoSwitch = addToggle(p1, "Auto Switch", true, nil, 5, false)
local getResolver = addToggle(p1, "Resolver", false, nil, 6, true)
local getSkipDowned = addToggle(p1, "Skip Downed (<20% HP)", true, nil, 7, true)

addSeparator(p1, 8)
addLabel(p1, "-- SETTINGS --", 9)
local getMode = addCycleButton(p1, "Mode", {"Right Mouse Click", "Nearest Cursor", "Toggle Q"}, "Right Mouse Click", function(v)
    Settings.Mode = v:gsub(" ", "")
end, 10)
local getTargetPart = addCycleButton(p1, "Target Part", {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso"}, "HumanoidRootPart", function(v)
    Settings.TargetPart = v
end, 11)
local getSmoothness = addSlider(p1, "Smoothness", 0.01, 1.0, 0.450, nil, 12)
local getPrediction = addSlider(p1, "Prediction", 0.0, 1.0, 0.100, nil, 13)
local getAimShake = addSlider(p1, "Aim Shake", 0, 5, 0, nil, 14)

addSeparator(p1, 15)
addLabel(p1, "-- FOV CIRCLE --", 16)
local getFOVVisible = addToggle(p1, "FOV Circle", true, nil, 17, true)
local getFOVRadius = addSlider(p1, "FOV Radius", 20, 500, 150, nil, 18)

-- =============================================
-- PAGE 2: VISUALS
-- =============================================
local p2 = tabPages["Visuals"]
addLabel(p2, "-- HIGHLIGHT ESP --", 1)
local getESP = addToggle(p2, "ESP Highlight", true, nil, 2, true)
local getHighlightColor = addCycleButton(p2, "Highlight Color", {"Cyan","Red","Green","Yellow","Purple","White","Orange"}, "Cyan", function(v)
    local colors = {Cyan=Color3.fromRGB(0,255,255), Red=Color3.fromRGB(255,0,0), Green=Color3.fromRGB(0,255,0),
        Yellow=Color3.fromRGB(255,255,0), Purple=Color3.fromRGB(180,0,255), White=Color3.fromRGB(255,255,255), Orange=Color3.fromRGB(255,150,0)}
    Settings.HighlightColor = colors[v] or Color3.fromRGB(0,255,255)
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

-- =============================================
-- PAGE 3: PLAYERS
-- =============================================
local p3 = tabPages["Players"]

local SelectCountLabel = Instance.new("TextLabel")
SelectCountLabel.Size = UDim2.new(1,-8,0,16); SelectCountLabel.BackgroundTransparency = 1
SelectCountLabel.Text = "Selected: 0"; SelectCountLabel.TextColor3 = Color3.fromRGB(255,100,100)
SelectCountLabel.TextSize = 11; SelectCountLabel.Font = Enum.Font.GothamSemibold
SelectCountLabel.TextXAlignment = Enum.TextXAlignment.Left; SelectCountLabel.LayoutOrder = 1; SelectCountLabel.ZIndex = 3
SelectCountLabel.Parent = p3

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1,-8,0,24); btnRow.BackgroundTransparency = 1; btnRow.LayoutOrder = 2; btnRow.ZIndex = 3; btnRow.Parent = p3

local SelectAllBtn = Instance.new("TextButton")
SelectAllBtn.Size = UDim2.new(0.48,0,1,0); SelectAllBtn.BackgroundColor3 = Color3.fromRGB(0,120,0)
SelectAllBtn.BorderSizePixel = 0; SelectAllBtn.Text = "Select All"; SelectAllBtn.TextColor3 = Color3.fromRGB(255,255,255)
SelectAllBtn.TextSize = 11; SelectAllBtn.Font = Enum.Font.GothamBold; SelectAllBtn.AutoButtonColor = false
SelectAllBtn.ZIndex = 3; SelectAllBtn.Parent = btnRow
Instance.new("UICorner", SelectAllBtn).CornerRadius = UDim.new(0,4)

local ClearAllBtn = Instance.new("TextButton")
ClearAllBtn.Size = UDim2.new(0.48,0,1,0); ClearAllBtn.Position = UDim2.new(0.52,0,0,0)
ClearAllBtn.BackgroundColor3 = Color3.fromRGB(120,0,0); ClearAllBtn.BorderSizePixel = 0
ClearAllBtn.Text = "Clear"; ClearAllBtn.TextColor3 = Color3.fromRGB(255,255,255)
ClearAllBtn.TextSize = 11; ClearAllBtn.Font = Enum.Font.GothamBold; ClearAllBtn.AutoButtonColor = false
ClearAllBtn.ZIndex = 3; ClearAllBtn.Parent = btnRow
Instance.new("UICorner", ClearAllBtn).CornerRadius = UDim.new(0,4)

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1,-8,0,26); SearchBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
SearchBox.BorderSizePixel = 0; SearchBox.PlaceholderText = "Search Players..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150,150,150); SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(220,220,220); SearchBox.TextSize = 12; SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false; SearchBox.LayoutOrder = 3; SearchBox.ZIndex = 3; SearchBox.Parent = p3
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,4)

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1,-8,0,220); PlayerScroll.BackgroundTransparency = 1; PlayerScroll.BorderSizePixel = 0
PlayerScroll.ScrollBarThickness = 3; PlayerScroll.ScrollBarImageColor3 = Color3.fromRGB(139,0,0)
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

-- =============================================
-- PAGE 5: SPECTATE
-- =============================================
local p5 = tabPages["Spectate"]
local spectateTarget = nil
local spectating = false

addLabel(p5, "-- SPECTATE MODE --", 1)

-- Spectate status label
local specStatusLabel = Instance.new("TextLabel")
specStatusLabel.Size = UDim2.new(1,-8,0,22); specStatusLabel.BackgroundTransparency = 1
specStatusLabel.Text = "Not Spectating"; specStatusLabel.TextColor3 = Color3.fromRGB(200,200,200)
specStatusLabel.TextSize = 13; specStatusLabel.Font = Enum.Font.GothamBold
specStatusLabel.TextXAlignment = Enum.TextXAlignment.Center; specStatusLabel.LayoutOrder = 2
specStatusLabel.ZIndex = 3; specStatusLabel.Parent = p5

addSeparator(p5, 3)

-- Spectate player search
local specSearch = Instance.new("TextBox")
specSearch.Size = UDim2.new(1,-8,0,26); specSearch.BackgroundColor3 = Color3.fromRGB(40,40,40)
specSearch.BorderSizePixel = 0; specSearch.PlaceholderText = "Search player to spectate..."
specSearch.PlaceholderColor3 = Color3.fromRGB(150,150,150); specSearch.Text = ""
specSearch.TextColor3 = Color3.fromRGB(220,220,220); specSearch.TextSize = 12; specSearch.Font = Enum.Font.Gotham
specSearch.ClearTextOnFocus = false; specSearch.LayoutOrder = 4; specSearch.ZIndex = 3; specSearch.Parent = p5
Instance.new("UICorner", specSearch).CornerRadius = UDim.new(0,4)

-- Spectate player scroll
local specScroll = Instance.new("ScrollingFrame")
specScroll.Size = UDim2.new(1,-8,0,180); specScroll.BackgroundTransparency = 1; specScroll.BorderSizePixel = 0
specScroll.ScrollBarThickness = 3; specScroll.ScrollBarImageColor3 = Color3.fromRGB(0,150,255)
specScroll.CanvasSize = UDim2.new(0,0,0,0); specScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
specScroll.LayoutOrder = 5; specScroll.ZIndex = 3; specScroll.Active = true; specScroll.Parent = p5
local specLayout = Instance.new("UIListLayout", specScroll)
specLayout.SortOrder = Enum.SortOrder.LayoutOrder; specLayout.Padding = UDim.new(0,3)

addSeparator(p5, 6)

-- Stop spectate button
local stopSpecBtn = Instance.new("TextButton")
stopSpecBtn.Size = UDim2.new(1,-8,0,30); stopSpecBtn.BackgroundColor3 = Color3.fromRGB(180,0,0)
stopSpecBtn.BorderSizePixel = 0; stopSpecBtn.Text = "Stop Spectating"
stopSpecBtn.TextColor3 = Color3.fromRGB(255,255,255); stopSpecBtn.TextSize = 13
stopSpecBtn.Font = Enum.Font.GothamBold; stopSpecBtn.AutoButtonColor = false
stopSpecBtn.LayoutOrder = 7; stopSpecBtn.ZIndex = 3; stopSpecBtn.Parent = p5
Instance.new("UICorner", stopSpecBtn).CornerRadius = UDim.new(0,5)

-- Spectate keybind
local specKeybindRow = Instance.new("Frame")
specKeybindRow.Size = UDim2.new(1,-8,0,28); specKeybindRow.BackgroundTransparency = 1
specKeybindRow.LayoutOrder = 8; specKeybindRow.ZIndex = 3; specKeybindRow.Parent = p5

local specKeyLabel = Instance.new("TextLabel")
specKeyLabel.Size = UDim2.new(1,-68,1,0); specKeyLabel.BackgroundTransparency = 1
specKeyLabel.Text = "Spectate Key:"; specKeyLabel.TextColor3 = Color3.fromRGB(200,200,200)
specKeyLabel.TextSize = 12; specKeyLabel.Font = Enum.Font.GothamBold
specKeyLabel.TextXAlignment = Enum.TextXAlignment.Left; specKeyLabel.ZIndex = 3; specKeyLabel.Parent = specKeybindRow

local specKeyBtn = Instance.new("TextButton")
specKeyBtn.Size = UDim2.new(0,60,1,0); specKeyBtn.Position = UDim2.new(1,-60,0,0)
specKeyBtn.BackgroundColor3 = Color3.fromRGB(35,35,35); specKeyBtn.BorderSizePixel = 0
specKeyBtn.Text = "[ V ]"; specKeyBtn.TextColor3 = Color3.fromRGB(0,255,150)
specKeyBtn.TextSize = 10; specKeyBtn.Font = Enum.Font.GothamBold; specKeyBtn.AutoButtonColor = false
specKeyBtn.ZIndex = 4; specKeyBtn.Parent = specKeybindRow
Instance.new("UICorner", specKeyBtn).CornerRadius = UDim.new(0,4)
local skStroke = Instance.new("UIStroke", specKeyBtn); skStroke.Color = Color3.fromRGB(0,80,120); skStroke.Thickness = 1

local spectateKey = Enum.KeyCode.V
local specKeyListening = false

specKeyBtn.MouseButton1Click:Connect(function()
    if specKeyListening then
        specKeyListening = false
        specKeyBtn.Text = spectateKey and "["..spectateKey.Name.."]" or "[ - ]"
        specKeyBtn.TextColor3 = Color3.fromRGB(0,255,150)
        return
    end
    specKeyListening = true
    specKeyBtn.Text = "[...]"
    specKeyBtn.TextColor3 = Color3.fromRGB(255,255,0)
end)

-- Spectate fonksiyonlari
local function startSpectate(player)
    if not player or not player.Character then return end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    spectateTarget = player
    spectating = true
    Camera.CameraSubject = hum
    specStatusLabel.Text = "Spectating: " .. player.DisplayName
    specStatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
end

local function stopSpectate()
    spectating = false
    spectateTarget = nil
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end)
    specStatusLabel.Text = "Not Spectating"
    specStatusLabel.TextColor3 = Color3.fromRGB(200,200,200)
end

stopSpecBtn.MouseButton1Click:Connect(stopSpectate)

-- Spectate player list (ayri liste â€” tum oyuncular)
local specButtons = {}

local function refreshSpecList()
    for _,b in pairs(specButtons) do if b and b.Parent then b:Destroy() end end
    specButtons = {}
    local search = specSearch.Text:lower()
    for _,player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if search == "" or player.DisplayName:lower():find(search,1,true) or player.Name:lower():find(search,1,true) then
                local isSpec = spectateTarget == player
                local btn = Instance.new("TextButton")
                btn.Name = "SPEC_"..player.Name; btn.Size = UDim2.new(1,-4,0,26)
                btn.BackgroundColor3 = isSpec and Color3.fromRGB(0,100,180) or Color3.fromRGB(45,45,45)
                btn.BorderSizePixel = 0; btn.Text = "  "..player.DisplayName
                btn.TextColor3 = isSpec and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,200)
                btn.TextSize = 12; btn.Font = Enum.Font.Gotham; btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.AutoButtonColor = false; btn.ZIndex = 3; btn.Parent = specScroll
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)

                btn.MouseButton1Click:Connect(function()
                    if spectateTarget == player and spectating then
                        stopSpectate()
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
    if spectateTarget == player then stopSpectate() end
    task.wait(0.1); refreshSpecList()
end)

-- Spectate target olunce/respawn olunca takip et
RunService.Heartbeat:Connect(function()
    if spectating and spectateTarget then
        if spectateTarget.Character and spectateTarget.Character:FindFirstChildOfClass("Humanoid") then
            local hum = spectateTarget.Character:FindFirstChildOfClass("Humanoid")
            if Camera.CameraSubject ~= hum then
                Camera.CameraSubject = hum
            end
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
        btn.BackgroundColor3 = Color3.fromRGB(45,45,45); btn.TextColor3 = Color3.fromRGB(200,200,200)
    else
        Settings.SelectedPlayers[player.Name] = player
        btn.BackgroundColor3 = Color3.fromRGB(139,0,0); btn.TextColor3 = Color3.fromRGB(255,255,255)
    end
    updateSelectCount()
end

local function createPlayerButton(player)
    if player == LocalPlayer then return end
    local sel = isSelected(player)
    local btn = Instance.new("TextButton")
    btn.Name = "PLR_"..player.Name; btn.Size = UDim2.new(1,-4,0,26)
    btn.BackgroundColor3 = sel and Color3.fromRGB(139,0,0) or Color3.fromRGB(45,45,45)
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
    fovCircle = Drawing.new("Circle"); fovCircle.Color = Color3.fromRGB(255,0,0)
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
                        else hideDrawings(player.Name) end
                    end
                else removeHighlight(player.Name) end
            else removeHighlight(player.Name) end
        end
    end
end

-- Character respawn
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
-- DOWNED CHECK (HP < 20%)
-- =============================================
local function isDowned(character)
    if not character then return false end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return (hum.Health / hum.MaxHealth) < 0.20
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
                -- Downed atla
                if getSkipDowned() and isDowned(player.Character) then
                    continue
                end
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

-- Cycle target
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
-- INPUT
-- =============================================
local locked = false
local menuOpen = false

UserInputService.InputBegan:Connect(function(input, gpe)
    -- Keybind dinleme
    if activeKeybindBtn and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
            local assignFunc = _G.DHL_KeybindAssigners and _G.DHL_KeybindAssigners[activeKeybindBtn]
            if assignFunc then assignFunc(input.KeyCode) end
            return
        else
            -- ESC ile iptal
            activeKeybindBtn.Text = "[ - ]"
            activeKeybindBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            activeKeybindBtn = nil
            return
        end
    end

    -- Keybind tetikleme (gpe kontrol etme â€” oyun inputu olsa bile calissin)
    if input.UserInputType == Enum.UserInputType.Keyboard and keybindCallbacks[input.KeyCode] then
        keybindCallbacks[input.KeyCode]()
    end

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
    -- Spectate keybind dinleme
    if specKeyListening and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
            spectateKey = input.KeyCode
            specKeyBtn.Text = "["..input.KeyCode.Name.."]"
            specKeyBtn.TextColor3 = Color3.fromRGB(0,255,150)
            specKeyListening = false
            return
        else
            specKeyListening = false
            specKeyBtn.Text = spectateKey and "["..spectateKey.Name.."]" or "[ - ]"
            specKeyBtn.TextColor3 = Color3.fromRGB(0,255,150)
            return
        end
    end

    -- Spectate tusu
    if input.KeyCode == spectateKey and not specKeyListening then
        if spectating then
            stopSpectate()
            refreshSpecList()
        else
            -- Ilk secili oyuncuyu spectate et
            local target = nil
            for _, p in pairs(Settings.SelectedPlayers) do
                if p and p.Character then target = p; break end
            end
            if target then
                startSpectate(target)
                refreshSpecList()
            end
        end
    end

    -- ESC fix
    if input.KeyCode == Enum.KeyCode.Escape then
        if SearchBox:IsFocused() then SearchBox:ReleaseFocus() end
        if specSearch:IsFocused() then specSearch:ReleaseFocus() end
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
RunService.RenderStepped:Connect(function()
    -- ESC menu acikken hic bir sey yapma
    if menuOpen then return end

    -- FOV
    if usingDrawing and fovCircle then
        fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        fovCircle.Radius = getFOVRadius()
        fovCircle.Visible = getFOVVisible()
    end

    -- ESP
    updateESP()

    -- Fly
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

    -- Camlock
    if not getCamlock() then locked = false; Settings.CurrentTarget = nil; return end

    if Settings.Mode == "NearestCursor" then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            Settings.CurrentTarget = getClosestFromSelected(); locked = Settings.CurrentTarget ~= nil
        else locked = false; Settings.CurrentTarget = nil end
    end

    if locked and Settings.CurrentTarget and Settings.CurrentTarget.Character then
        local part = Settings.CurrentTarget.Character:FindFirstChild(Settings.TargetPart)
        if part then
            local hum = Settings.CurrentTarget.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                -- Downed ise birak
                if getSkipDowned() and isDowned(Settings.CurrentTarget.Character) then
                    if getAutoSwitch() then
                        Settings.CurrentTarget = getClosestFromSelected(); locked = Settings.CurrentTarget ~= nil
                    else locked = false; Settings.CurrentTarget = nil end
                    return
                end

                local canSee = isVisible(part)
                if canSee or getStickyAim() then
                    local smoothness = getSmoothness()
                    local prediction = getPrediction()
                    local shake = getAimShake()
                    local vel = Vector3.new(0,0,0)
                    pcall(function() vel = part.AssemblyLinearVelocity end); vel = vel or Vector3.new(0,0,0)
                    if getResolver() then vel = vel * 1.15 end
                    local predictedPos = part.Position + (vel * prediction)
                    if shake > 0 then
                        predictedPos = predictedPos + Vector3.new(
                            math.random(-shake*10, shake*10)/10, math.random(-shake*10, shake*10)/10, math.random(-shake*10, shake*10)/10)
                    end
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, predictedPos), smoothness)
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
-- ESC MENU â€” Highlight gizle + lock koru
-- =============================================
local guiWasVisible = true
local lockWasActive = false
local savedHighlightData = {}

pcall(function()
    GuiService.MenuOpened:Connect(function()
        menuOpen = true; guiWasVisible = MainFrame.Visible; lockWasActive = locked
        MainFrame.Visible = false
        -- Highlight'lari kaldir
        savedHighlightData = {}
        for name, hl in pairs(highlightObjects) do
            pcall(function()
                savedHighlightData[name] = hl.Parent
                hl.Parent = nil
            end)
        end
        for _, esp in pairs(espDrawings) do for _,obj in pairs(esp) do pcall(function() obj.Visible = false end) end end
        if fovCircle then pcall(function() fovCircle.Visible = false end) end
    end)

    GuiService.MenuClosed:Connect(function()
        menuOpen = false; MainFrame.Visible = guiWasVisible
        -- Highlight'lari geri ekle
        for name, parent in pairs(savedHighlightData) do
            if highlightObjects[name] and parent then pcall(function() highlightObjects[name].Parent = parent end) end
        end
        savedHighlightData = {}
        if lockWasActive and Settings.CurrentTarget then locked = true end
    end)
end)

-- Cleanup
LocalPlayer.CharacterRemoving:Connect(function()
    for name in pairs(highlightObjects) do removeHighlight(name) end
    if flyBV then pcall(function() flyBV:Destroy() end); flyBV = nil end
end)

-- ZIndex fix
task.defer(function()
    task.wait(0.3)
    for _, child in ipairs(MainFrame:GetDescendants()) do
        if child:IsA("GuiObject") and child ~= BgImage and child.ZIndex < 2 then child.ZIndex = 2 end
    end
end)

-- =============================================
-- BILDIRIM
-- =============================================
print("[DHL V2] by babaniz â€” FULL LOAD!")
print("[DHL V2] Right Shift = GUI ac/kapa")
print("[DHL V2] Keybind: toggle yanindaki [ - ] butonuna tikla, tus bas")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DHL V2",
        Text = "by babaniz | Keybinds + Skip Downed",
        Duration = 5
    })
end)
