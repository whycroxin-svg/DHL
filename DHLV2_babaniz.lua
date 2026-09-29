--[[
    SOU HUB - RAGE EDITION (Da Hood)
]]

print("[SOU HUB] Yukleniyor...")

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

local CurrentTheme = {
    Name = "Rage",
    Primary = Color3.fromRGB(200, 30, 30),
    Accent = Color3.fromRGB(255, 60, 60),
    Bg = Color3.fromRGB(12, 12, 14),
    Panel = Color3.fromRGB(18, 18, 20),
    Button = Color3.fromRGB(28, 28, 32),
    Text = Color3.fromRGB(230, 230, 235),
    SubText = Color3.fromRGB(130, 130, 140),
}

local LOGO_URL = "https://raw.githubusercontent.com/whycroxin-svg/logo/main/3a51ccbf-3a34-4037-af47-0489047fa126.png"

local Settings = {
    WallCheck = false, Smoothness = 0.450, Prediction = 0.100,
    TargetPart = "Head", Mode = "RightMouseClick", StickyAim = true, AutoSwitch = true,
    SkipDowned = true, AlwaysOn = false, FOVVisible = true,
    FOVRadius = 150,
    CurrentTarget = nil,
    KillAura = false, KillAuraRange = 12, KillAuraDelay = 100,
    Spinbot = false, SpinbotSpeed = 30, SpinbotRadius = 3,
    AutoAttack = false, AutoAttackRange = 8,
    LockMode = "Normal",
    ESPMode = "All",
    SelectedPlayers = {},
}

for _, loc in ipairs({game:GetService("CoreGui"), LocalPlayer:FindFirstChild("PlayerGui")}) do
    pcall(function() 
        local o = loc:FindFirstChild("SOUHUB_Rage"); if o then o:Destroy() end
    end)
end
pcall(function() 
    if gethui then 
        local o = gethui():FindFirstChild("SOUHUB_Rage"); if o then o:Destroy() end
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
ScreenGui.Name = "SOUHUB_Rage"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
if guiParent:IsA("ScreenGui") then
    ScreenGui = guiParent; ScreenGui.Name = "SOUHUB_Rage"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 999
else ScreenGui.Parent = guiParent end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 700, 0, 480)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
MainFrame.BackgroundColor3 = CurrentTheme.Bg
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = CurrentTheme.Primary
mainStroke.Thickness = 1
mainStroke.Transparency = 0.5

local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1, 0, 0, 40)
DragHandle.BackgroundTransparency = 1
DragHandle.Text = ""
DragHandle.AutoButtonColor = false
DragHandle.ZIndex = 10
DragHandle.Parent = MainFrame

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
makeDraggable(MainFrame, DragHandle)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 8)
closeBtn.BackgroundColor3 = CurrentTheme.Button
closeBtn.BackgroundTransparency = 0.5
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

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = CurrentTheme.Panel
Sidebar.BackgroundTransparency = 0
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 4
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local logoFrame = Instance.new("Frame")
logoFrame.Size = UDim2.new(1, 0, 0, 90)
logoFrame.Position = UDim2.new(0, 0, 0, 0)
logoFrame.BackgroundTransparency = 1
logoFrame.ZIndex = 5
logoFrame.Parent = Sidebar

local logoImg = Instance.new("ImageLabel")
logoImg.Size = UDim2.new(0, 70, 0, 70)
logoImg.Position = UDim2.new(0.5, -35, 0, 10)
logoImg.BackgroundTransparency = 1
logoImg.ZIndex = 6
logoImg.Parent = logoFrame

pcall(function()
    local fileName = "souhub_logo.png"
    local logoURL = "https://raw.githubusercontent.com/whycroxin-svg/logo/main/3a51ccbf-3a34-4037-af47-0489047fa126.png"
    if writefile and isfile and getcustomasset then
        if not isfile(fileName) then
            writefile(fileName, game:HttpGet(logoURL))
        end
        logoImg.Image = getcustomasset(fileName)
    else
        logoImg.Image = logoURL
    end
end)

local SideScroll = Instance.new("ScrollingFrame")
SideScroll.Size = UDim2.new(1, 0, 1, -90)
SideScroll.Position = UDim2.new(0, 0, 0, 90)
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
sideLayout.Padding = UDim.new(0, 2)
local sidePad = Instance.new("UIPadding", SideScroll)
sidePad.PaddingTop = UDim.new(0, 6)

local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -170, 1, -20)
ContentArea.Position = UDim2.new(0, 165, 0, 10)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 3
ContentArea.Parent = MainFrame

local tabConfig = {
    {Name = "AIMLOCK",       Sub = "Aimbot"},
    {Name = "SILENT",        Sub = "Silent Aim"},
    {Name = "TRIGGER",       Sub = "Trigger Bot"},
    {Name = "VISUALS",       Sub = "ESP"},
    {Name = "RAGE",          Sub = "Rage Features"},
    {Name = "PLAYER",        Sub = "Player Actions"},
    {Name = "LOCAL_PLAYERS", Sub = "Local"},
    {Name = "SETTINGS",      Sub = "Config"},
    {Name = "CONFIG",        Sub = "Save/Load"},
    {Name = "DEX",           Sub = "Explorer"},
    {Name = "COLORS",        Sub = "Theme"},
}

local tabPages = {}
local tabButtons = {}
local activeTab = "AIMLOCK"
local activeKeybindBtn = nil
local keybindCallbacks = {}
local keybindNames = {}

for i, config in ipairs(tabConfig) do
    local name = config.Name
    local displayName = name:gsub("_", " ")
    displayName = displayName:sub(1,1) .. displayName:sub(2):lower()

    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. name
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = CurrentTheme.Button
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.ZIndex = 5
    btn.Parent = SideScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.Position = UDim2.new(0, 0, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.BackgroundColor3 = CurrentTheme.Primary
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.ZIndex = 7
    indicator.Parent = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name = "NameLabel"
    nameLbl.Size = UDim2.new(1, -14, 1, 0)
    nameLbl.Position = UDim2.new(0, 14, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = displayName
    nameLbl.TextColor3 = CurrentTheme.SubText
    nameLbl.TextSize = 12
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 6
    nameLbl.Parent = btn

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
    layout.Padding = UDim.new(0, 5)
    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
    pad.PaddingTop = UDim.new(0, 6)

    tabPages[name] = page

    if i == 1 then
        btn.BackgroundTransparency = 0.3
        btn.BackgroundColor3 = CurrentTheme.Button
        nameLbl.TextColor3 = CurrentTheme.Text
        indicator.Visible = true
        indicator.Size = UDim2.new(0, 3, 0, 20)
    end

    btn.MouseEnter:Connect(function()
        if activeTab ~= name then
            tween(btn, 0.15, {BackgroundTransparency = 0.7, BackgroundColor3 = CurrentTheme.Button})
            tween(nameLbl, 0.15, {TextColor3 = CurrentTheme.Text})
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= name then
            tween(btn, 0.15, {BackgroundTransparency = 1})
            tween(nameLbl, 0.15, {TextColor3 = CurrentTheme.SubText})
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if activeTab == name then return end
        local oldTab = activeTab
        activeTab = name

        for n,b in pairs(tabButtons) do 
            local isActive = (n == name)
            local ind = b:FindFirstChild("Indicator")
            local nl = b:FindFirstChild("NameLabel")
            if ind then 
                ind.Visible = isActive
                tween(ind, 0.2, {Size = isActive and UDim2.new(0, 3, 0, 20) or UDim2.new(0, 3, 0, 0)})
            end
            if nl then
                tween(nl, 0.15, {TextColor3 = isActive and CurrentTheme.Text or CurrentTheme.SubText})
            end
            tween(b, 0.2, {
                BackgroundTransparency = isActive and 0.3 or 1,
                BackgroundColor3 = CurrentTheme.Button
            })
        end

        tabPages[oldTab].Visible = false
        page.Visible = true
    end)
end

-- UI BUILDERS
local function addToggle(page, name, default, callback, order, withKeybind)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 26)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order or 0
    row.ZIndex = 3
    row.Parent = page

    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0, 14, 0, 14)
    cb.Position = UDim2.new(0, 0, 0.5, -7)
    cb.BackgroundColor3 = default and CurrentTheme.Primary or Color3.fromRGB(40, 40, 45)
    cb.BorderSizePixel = 0
    cb.Text = ""
    cb.AutoButtonColor = false
    cb.ZIndex = 4
    cb.Parent = row
    Instance.new("UICorner", cb).CornerRadius = UDim.new(0, 2)

    local check = Instance.new("TextLabel")
    check.Size = UDim2.new(1, 0, 1, 0)
    check.BackgroundTransparency = 1
    check.Text = default and "✓" or ""
    check.TextColor3 = Color3.fromRGB(255, 255, 255)
    check.TextSize = 12
    check.Font = Enum.Font.GothamBold
    check.ZIndex = 5
    check.Parent = cb

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -80, 1, 0)
    nameLbl.Position = UDim2.new(0, 22, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = default and CurrentTheme.Text or CurrentTheme.SubText
    nameLbl.TextSize = 11
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 3
    nameLbl.Parent = row

    local state = default
    local function doToggle()
        state = not state
        cb.BackgroundColor3 = state and CurrentTheme.Primary or Color3.fromRGB(40, 40, 45)
        check.Text = state and "✓" or ""
        tween(nameLbl, 0.15, {TextColor3 = state and CurrentTheme.Text or CurrentTheme.SubText})
        if callback then callback(state) end
    end
    cb.MouseButton1Click:Connect(doToggle)

    if withKeybind then
        local kbBtn = Instance.new("TextButton")
        kbBtn.Size = UDim2.new(0, 60, 1, 0)
        kbBtn.Position = UDim2.new(1, -60, 0, 0)
        kbBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        kbBtn.BackgroundTransparency = 0.3
        kbBtn.BorderSizePixel = 0
        kbBtn.Text = "[unbound]"
        kbBtn.TextColor3 = CurrentTheme.SubText
        kbBtn.TextSize = 9
        kbBtn.Font = Enum.Font.Gotham
        kbBtn.AutoButtonColor = false
        kbBtn.ZIndex = 4
        kbBtn.Parent = row
        Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 2)

        kbBtn.MouseButton1Click:Connect(function()
            if activeKeybindBtn == kbBtn then
                activeKeybindBtn = nil
                kbBtn.Text = "[unbound]"
                kbBtn.TextColor3 = CurrentTheme.SubText
                return
            end
            if activeKeybindBtn then
                activeKeybindBtn.Text = "[unbound]"
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
            kbBtn.Text = "[" .. keyCode.Name .. "]"
            kbBtn.TextColor3 = CurrentTheme.Text
            keybindCallbacks[keyCode] = doToggle
            keybindNames[keyCode] = name
            activeKeybindBtn = nil
            updateKeybindPanel()
        end

        if not _G.SOUHUB_KeybindAssigners then _G.SOUHUB_KeybindAssigners = {} end
        _G.SOUHUB_KeybindAssigners[kbBtn] = assignKeybind
    end

    return function() return state end
end

local function addSlider(page, name, min, max, default, callback, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,-8,0,40)
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
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    label.Parent = container

    local valueLbl = Instance.new("TextLabel")
    valueLbl.Size = UDim2.new(0.4, -4, 0, 16)
    valueLbl.Position = UDim2.new(0.6, 0, 0, 0)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text = tostring(math.floor(default))
    valueLbl.TextColor3 = CurrentTheme.Text
    valueLbl.TextSize = 11
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right
    valueLbl.ZIndex = 3
    valueLbl.Parent = container

    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(1,0,0,2)
    bg.Position = UDim2.new(0,0,0,24)
    bg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    bg.BorderSizePixel = 0
    bg.Text = ""
    bg.AutoButtonColor = false
    bg.ZIndex = 3
    bg.Parent = container

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = CurrentTheme.Primary
    fill.BorderSizePixel = 0
    fill.ZIndex = 3
    fill.Parent = bg

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
    btn.Size = UDim2.new(1,-8,0,26)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = order or 0
    btn.ZIndex = 3
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,2)

    local valueLbl = Instance.new("TextLabel")
    valueLbl.Size = UDim2.new(1, -30, 1, 0)
    valueLbl.Position = UDim2.new(0, 10, 0, 0)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text = options[idx]
    valueLbl.TextColor3 = CurrentTheme.Text
    valueLbl.TextSize = 11
    valueLbl.Font = Enum.Font.GothamMedium
    valueLbl.TextXAlignment = Enum.TextXAlignment.Left
    valueLbl.ZIndex = 4
    valueLbl.Parent = btn

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -22, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = CurrentTheme.SubText
    arrow.TextSize = 8
    arrow.Font = Enum.Font.GothamBold
    arrow.ZIndex = 4
    arrow.Parent = btn

    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        valueLbl.Text = options[idx]
        if callback then callback(options[idx]) end
    end)
    return function() return options[idx] end
end

local function addSeparator(page, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,-16,0,14)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order or 0
    container.ZIndex = 3
    container.Parent = page

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = CurrentTheme.Button
    line.BackgroundTransparency = 0.3
    line.BorderSizePixel = 0
    line.ZIndex = 3
    line.Parent = container
end

local function addLabel(page, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-8,0,18)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = CurrentTheme.Primary
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0
    lbl.ZIndex = 3
    lbl.Parent = page
end

local function addButton(page, name, callback, order, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-8,0,32)
    btn.BackgroundColor3 = color or CurrentTheme.Button
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = CurrentTheme.Text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
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

-- AIMLOCK
local p1 = tabPages["AIMLOCK"]
addLabel(p1, "LOCK MODE", 1)
local getLockMode = addCycleButton(p1, "Lock Mode", {"Normal", "Selected"}, "Normal", function(v) 
    Settings.LockMode = v 
end, 2)
addSeparator(p1, 3)
addLabel(p1, "AIMBOT", 4)
local getCamlock = addToggle(p1, "Aimbot", true, nil, 5, true)
local getWallCheck = addToggle(p1, "Wall Check", false, function(v) Settings.WallCheck = v end, 6, true)
local getStickyAim = addToggle(p1, "Sticky Aim", true, nil, 7, true)
local getAutoSwitch = addToggle(p1, "Auto Switch", true, nil, 8, false)
local getSkipDowned = addToggle(p1, "Skip Downed", true, nil, 9, true)
local getAlwaysOn = addToggle(p1, "Always On", false, nil, 10, true)
addSeparator(p1, 11)
addLabel(p1, "PARAMETERS", 12)
local getMode = addCycleButton(p1, "Mode", {"Right Mouse Click", "Nearest Cursor", "Toggle Q"}, "Right Mouse Click", function(v) Settings.Mode = v:gsub(" ", "") end, 13)
local getTargetPart = addCycleButton(p1, "Target Part", {"Head", "HumanoidRootPart", "UpperTorso"}, "Head", function(v) Settings.TargetPart = v end, 14)
local getSmoothness = addSlider(p1, "Smoothness", 0.05, 1.0, 0.450, nil, 15)
local getPrediction = addSlider(p1, "Prediction", 0.0, 0.5, 0.100, nil, 16)
addSeparator(p1, 17)
addLabel(p1, "FOV", 18)
local getFOVVisible = addToggle(p1, "FOV Circle", true, nil, 19, true)
local getFOVRadius = addSlider(p1, "FOV Radius", 20, 500, 150, nil, 20)

-- SILENT
local pSilent = tabPages["SILENT"]
addLabel(pSilent, "SILENT AIM", 1)
local getSilentAim = addToggle(pSilent, "Silent Aim", false, function(v) silentAimEnabled = v end, 2, true)
local getSilentPart = addCycleButton(pSilent, "Silent Part", {"Head", "HumanoidRootPart", "UpperTorso"}, "Head", function(v) silentAimTargetPart = v end, 3)

-- TRIGGER
local pTrigger = tabPages["TRIGGER"]
addLabel(pTrigger, "TRIGGER BOT", 1)
local getTriggerBot = addToggle(pTrigger, "Trigger Bot", false, nil, 2, true)
local getTriggerRange = addSlider(pTrigger, "Trigger Range", 5, 50, 15, nil, 3)

-- VISUALS
local pVis = tabPages["VISUALS"]
addLabel(pVis, "ESP MODE", 1)
local getESPMode = addCycleButton(pVis, "ESP Mode", {"All", "Selected"}, "All", function(v) 
    Settings.ESPMode = v 
end, 2)
addSeparator(pVis, 3)
addLabel(pVis, "BOX ESP", 4)
local getESP = addToggle(pVis, "Box ESP", true, nil, 5, true)
addSeparator(pVis, 6)
addLabel(pVis, "INFO OVERLAY", 7)
local getESPNames = addToggle(pVis, "Name Tags", true, nil, 8, true)
local getESPHealth = addToggle(pVis, "Health Display", true, nil, 9, false)
local getESPDistance = addToggle(pVis, "Distance Display", true, nil, 10, false)

-- RAGE
local pRage = tabPages["RAGE"]
addLabel(pRage, "KILL AURA", 1)
local getKillAura = addToggle(pRage, "Kill Aura", false, nil, 2, true)
local getKillAuraRange = addSlider(pRage, "Aura Range", 5, 30, 12, nil, 3)
local getKillAuraDelay = addSlider(pRage, "Aura Delay (ms)", 10, 500, 100, nil, 4)
addSeparator(pRage, 5)
addLabel(pRage, "SPINBOT", 6)
local getSpinbot = addToggle(pRage, "Orbit Spinbot", false, nil, 7, true)
local getSpinbotSpeed = addSlider(pRage, "Orbit Speed", 5, 60, 30, nil, 8)
local getSpinbotRadius = addSlider(pRage, "Orbit Radius", 1, 10, 3, nil, 9)
addSeparator(pRage, 10)
addLabel(pRage, "AUTO ATTACK", 11)
local getAutoAttack = addToggle(pRage, "Auto Attack Nearest", false, nil, 12, true)
local getAutoAttackRange = addSlider(pRage, "Auto Attack Range", 3, 20, 8, nil, 13)

-- PLAYER
local pPlayer = tabPages["PLAYER"]
addLabel(pPlayer, "SELECTED PLAYERS", 1)
local selectCountLabel = Instance.new("TextLabel")
selectCountLabel.Size = UDim2.new(1, -8, 0, 20)
selectCountLabel.BackgroundTransparency = 1
selectCountLabel.Text = "0 players selected"
selectCountLabel.TextColor3 = CurrentTheme.SubText
selectCountLabel.TextSize = 10
selectCountLabel.Font = Enum.Font.Gotham
selectCountLabel.TextXAlignment = Enum.TextXAlignment.Left
selectCountLabel.LayoutOrder = 2
selectCountLabel.ZIndex = 3
selectCountLabel.Parent = pPlayer

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, -8, 0, 28)
btnRow.BackgroundTransparency = 1
btnRow.LayoutOrder = 3
btnRow.ZIndex = 3
btnRow.Parent = pPlayer

local selectAllBtn = Instance.new("TextButton")
selectAllBtn.Size = UDim2.new(0.48, 0, 1, 0)
selectAllBtn.BackgroundColor3 = CurrentTheme.Button
selectAllBtn.BackgroundTransparency = 0.3
selectAllBtn.BorderSizePixel = 0
selectAllBtn.Text = "Select All"
selectAllBtn.TextColor3 = CurrentTheme.Text
selectAllBtn.TextSize = 10
selectAllBtn.Font = Enum.Font.GothamMedium
selectAllBtn.AutoButtonColor = false
selectAllBtn.ZIndex = 3
selectAllBtn.Parent = btnRow
Instance.new("UICorner", selectAllBtn).CornerRadius = UDim.new(0, 4)

local clearAllBtn = Instance.new("TextButton")
clearAllBtn.Size = UDim2.new(0.48, 0, 1, 0)
clearAllBtn.Position = UDim2.new(0.52, 0, 0, 0)
clearAllBtn.BackgroundColor3 = CurrentTheme.Button
clearAllBtn.BackgroundTransparency = 0.3
clearAllBtn.BorderSizePixel = 0
clearAllBtn.Text = "Clear"
clearAllBtn.TextColor3 = CurrentTheme.Text
clearAllBtn.TextSize = 10
clearAllBtn.Font = Enum.Font.GothamMedium
clearAllBtn.AutoButtonColor = false
clearAllBtn.ZIndex = 3
clearAllBtn.Parent = btnRow
Instance.new("UICorner", clearAllBtn).CornerRadius = UDim.new(0, 4)

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -8, 0, 28)
searchBox.BackgroundColor3 = CurrentTheme.Button
searchBox.BackgroundTransparency = 0.4
searchBox.BorderSizePixel = 0
searchBox.PlaceholderText = "Search players..."
searchBox.PlaceholderColor3 = CurrentTheme.SubText
searchBox.Text = ""
searchBox.TextColor3 = CurrentTheme.Text
searchBox.TextSize = 10
searchBox.Font = Enum.Font.Gotham
searchBox.ClearTextOnFocus = false
searchBox.LayoutOrder = 4
searchBox.ZIndex = 3
searchBox.Parent = pPlayer
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)

local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, -8, 0, 260)
playerScroll.BackgroundTransparency = 1
playerScroll.BorderSizePixel = 0
playerScroll.ScrollBarThickness = 3
playerScroll.ScrollBarImageColor3 = CurrentTheme.Primary
playerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerScroll.LayoutOrder = 5
playerScroll.ZIndex = 3
playerScroll.Active = true
playerScroll.Parent = pPlayer

local playerListLayout = Instance.new("UIListLayout", playerScroll)
playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerListLayout.Padding = UDim.new(0, 3)

local playerButtons = {}

local function updateSelectCount()
    local c = 0
    for _ in pairs(Settings.SelectedPlayers) do c = c + 1 end
    selectCountLabel.Text = c .. " players selected"
end

local function isSelected(player)
    return Settings.SelectedPlayers[player.Name] ~= nil
end

local function toggleSelect(player, btn)
    if isSelected(player) then
        Settings.SelectedPlayers[player.Name] = nil
        tween(btn, 0.2, {BackgroundTransparency = 0.4})
        btn.TextColor3 = CurrentTheme.SubText
    else
        Settings.SelectedPlayers[player.Name] = player
        tween(btn, 0.2, {BackgroundTransparency = 0.15})
        btn.TextColor3 = CurrentTheme.Text
    end
    updateSelectCount()
end

local function createPlayerButton(player)
    if player == LocalPlayer then return end
    local sel = isSelected(player)
    local btn = Instance.new("TextButton")
    btn.Name = "PLR_" .. player.Name
    btn.Size = UDim2.new(1, -4, 0, 28)
    btn.BackgroundColor3 = CurrentTheme.Button
    btn.BackgroundTransparency = sel and 0.15 or 0.4
    btn.BorderSizePixel = 0
    btn.Text = player.DisplayName
    btn.TextColor3 = sel and CurrentTheme.Text or CurrentTheme.SubText
    btn.TextSize = 10
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    btn.Parent = playerScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    local textPad = Instance.new("UIPadding", btn)
    textPad.PaddingLeft = UDim.new(0, 12)
    btn.MouseButton1Click:Connect(function() toggleSelect(player, btn) end)
    playerButtons[player.Name] = btn
end

local function refreshPlayerList()
    for _, b in pairs(playerButtons) do 
        if b and b.Parent then b:Destroy() end 
    end
    playerButtons = {}
    local search = searchBox.Text:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if search == "" or p.DisplayName:lower():find(search, 1, true) or p.Name:lower():find(search, 1, true) then
                createPlayerButton(p)
            end
        end
    end
    updateSelectCount()
end

selectAllBtn.MouseButton1Click:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do 
        if p ~= LocalPlayer then 
            Settings.SelectedPlayers[p.Name] = p 
        end 
    end
    refreshPlayerList()
end)

clearAllBtn.MouseButton1Click:Connect(function()
    Settings.SelectedPlayers = {}
    refreshPlayerList()
end)

searchBox:GetPropertyChangedSignal("Text"):Connect(refreshPlayerList)

Players.PlayerAdded:Connect(function() 
    task.wait(0.5) 
    refreshPlayerList() 
end)

Players.PlayerRemoving:Connect(function(player)
    Settings.SelectedPlayers[player.Name] = nil
    task.wait(0.1)
    refreshPlayerList()
end)

refreshPlayerList()

-- LOCAL PLAYERS
local pLocal = tabPages["LOCAL_PLAYERS"]
addLabel(pLocal, "SPEED", 1)
local getSpeed = addToggle(pLocal, "Speed Hack", false, nil, 2, true)
local getSpeedValue = addSlider(pLocal, "Walk Speed", 16, 500, 16, nil, 3)
addSeparator(pLocal, 4)
addLabel(pLocal, "JUMP", 5)
local getJumpPower = addToggle(pLocal, "Jump Power", false, nil, 6, true)
local getJumpValue = addSlider(pLocal, "Jump Value", 50, 500, 50, nil, 7)
local getInfJump = addToggle(pLocal, "Infinite Jump", false, nil, 8, true)
addSeparator(pLocal, 9)
addLabel(pLocal, "FLIGHT", 10)
local getFly = addToggle(pLocal, "Fly", false, nil, 11, true)
local getFlySpeed = addSlider(pLocal, "Fly Speed", 10, 500, 50, nil, 12)
local getNoclipFly = addToggle(pLocal, "Noclip Fly", false, nil, 13, true)
addSeparator(pLocal, 14)
addLabel(pLocal, "NOCLIP", 15)
local getNoclip = addToggle(pLocal, "Noclip", false, nil, 16, true)

-- SETTINGS
local pSet = tabPages["SETTINGS"]
addLabel(pSet, "INTERFACE", 1)
addSeparator(pSet, 3)
addLabel(pSet, "OVERLAY", 4)
local getFPSDisplay = addToggle(pSet, "FPS Display", true, nil, 5, false)
local getPingDisplay = addToggle(pSet, "Ping Display", true, nil, 6, false)
addSeparator(pSet, 7)
addLabel(pSet, "KEYBIND WINDOW", 8)
local getKeybindVisible = addToggle(pSet, "Show Keybind Panel", false, function(v)
    if v then
        updateKeybindPanel()
        keybindPanel.Visible = true
    else
        keybindPanel.Visible = false
    end
end, 9, false)
addSeparator(pSet, 10)
addLabel(pSet, "SERVER", 11)
addButton(pSet, "Server Rejoin", function()
    showToast("Server", "Reconnecting...", "info")
    task.wait(0.5)
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end, 12, CurrentTheme.Button)

-- CONFIG
local pConfig = tabPages["CONFIG"]
addLabel(pConfig, "CONFIGURATION", 1)
local CONFIG_FILE = "SOUHUB_config.json"
local function hasFileSupport()
    return writefile ~= nil and readfile ~= nil and isfile ~= nil
end
addButton(pConfig, "Save Config", function()
    if not hasFileSupport() then
        showToast("Config Error", "Executor desteklemiyor", "error")
        return
    end
    local data = {
        Theme = CurrentTheme.Name,
        FOVRadius = Settings.FOVRadius,
        Smoothness = Settings.Smoothness,
        Prediction = Settings.Prediction,
        Version = "2.0",
    }
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(data))
        showToast("Config Saved", "Ayarlar kaydedildi", "success")
    end)
end, 2, CurrentTheme.Button)
addButton(pConfig, "Load Config", function()
    if not hasFileSupport() then
        showToast("Config Error", "Executor desteklemiyor", "error")
        return
    end
    local exists = false
    pcall(function() exists = isfile(CONFIG_FILE) end)
    if not exists then
        showToast("Config Error", "Kayit bulunamadi", "warning")
        return
    end
    pcall(function()
        local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if data.FOVRadius then getFOVRadius(data.FOVRadius) end
        if data.Smoothness then getSmoothness(data.Smoothness) end
        if data.Prediction then getPrediction(data.Prediction) end
        showToast("Config Loaded", "Ayarlar yuklendi", "success")
    end)
end, 3, CurrentTheme.Button)

-- DEX
local pDex = tabPages["DEX"]
addLabel(pDex, "DEX EXPLORER", 1)
local getDexEnabled = addToggle(pDex, "Dex Enabled", false, function(v)
    if v then showToast("Dex", "Dex aktif (harici gerekli)", "info") end
end, 2, true)

-- COLORS
local pColors = tabPages["COLORS"]
addLabel(pColors, "PRIMARY COLOR", 1)
local getColorR = addSlider(pColors, "Red", 0, 255, 200, function(v)
    CurrentTheme.Primary = Color3.fromRGB(v, CurrentTheme.Primary.G*255, CurrentTheme.Primary.B*255)
    mainStroke.Color = CurrentTheme.Primary
    for _, page in pairs(tabPages) do page.ScrollBarImageColor3 = CurrentTheme.Primary end
end, 2)
local getColorG = addSlider(pColors, "Green", 0, 255, 30, function(v)
    CurrentTheme.Primary = Color3.fromRGB(CurrentTheme.Primary.R*255, v, CurrentTheme.Primary.B*255)
    mainStroke.Color = CurrentTheme.Primary
    for _, page in pairs(tabPages) do page.ScrollBarImageColor3 = CurrentTheme.Primary end
end, 3)
local getColorB = addSlider(pColors, "Blue", 0, 255, 30, function(v)
    CurrentTheme.Primary = Color3.fromRGB(CurrentTheme.Primary.R*255, CurrentTheme.Primary.G*255, v)
    mainStroke.Color = CurrentTheme.Primary
    for _, page in pairs(tabPages) do page.ScrollBarImageColor3 = CurrentTheme.Primary end
end, 4)

-- FOV
local fovFrame = Instance.new("Frame")
fovFrame.Name = "FOVCircle"
fovFrame.Size = UDim2.new(0, 300, 0, 300)
fovFrame.BackgroundTransparency = 1
fovFrame.ZIndex = 999
fovFrame.Visible = false
fovFrame.Parent = ScreenGui

local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(1, 0, 1, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.ZIndex = 1000
fovCircle.Parent = fovFrame
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)

local fovStroke = Instance.new("UIStroke", fovCircle)
fovStroke.Color = Color3.fromRGB(255, 255, 255)
fovStroke.Thickness = 1.5
fovStroke.Transparency = 0.2

RunService.RenderStepped:Connect(function(dt)
    if not getFOVVisible() then
        fovFrame.Visible = false
        return
    end
    fovFrame.Visible = true
    local radius = getFOVRadius()
    fovFrame.Size = UDim2.new(0, radius*2, 0, radius*2)
    fovFrame.Position = UDim2.new(0.5, -radius, 0.5, -radius)
end)

-- FPS
local fpsFrame = Instance.new("Frame")
fpsFrame.Size = UDim2.new(0, 100, 0, 20)
fpsFrame.Position = UDim2.new(0, 15, 0, 15)
fpsFrame.BackgroundColor3 = CurrentTheme.Panel
fpsFrame.BackgroundTransparency = 0.4
fpsFrame.ZIndex = 500
fpsFrame.Parent = ScreenGui
Instance.new("UICorner", fpsFrame).CornerRadius = UDim.new(0, 4)

local fpsText = Instance.new("TextLabel")
fpsText.Size = UDim2.new(1, 0, 1, 0)
fpsText.BackgroundTransparency = 1
fpsText.Text = "60 FPS | 0 MS"
fpsText.TextColor3 = CurrentTheme.SubText
fpsText.TextSize = 9
fpsText.Font = Enum.Font.Code
fpsText.ZIndex = 501
fpsText.Parent = fpsFrame

local fpsCount, fpsTime = 0, tick()
RunService.RenderStepped:Connect(function()
    fpsCount = fpsCount + 1
    if tick() - fpsTime >= 1 then
        local fps = fpsCount
        local ping = 0
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        fpsText.Text = fps .. " FPS | " .. ping .. " MS"
        fpsText.Visible = getFPSDisplay() or getPingDisplay()
        fpsFrame.Visible = getFPSDisplay() or getPingDisplay()
        fpsCount = 0
        fpsTime = tick()
    end
end)

-- ESP
local usingDrawing = pcall(function() 
    local test = Drawing.new("Line"); test:Remove() 
end)
local espDrawings = {}

local function updateESP()
    for name, esp in pairs(espDrawings) do
        local plr = Players:FindFirstChild(name)
        if not plr or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(esp) do
                pcall(function() obj:Remove() end)
            end
            espDrawings[name] = nil
        end
    end
    
    local espEnabled = getESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local shouldShow = espEnabled
            if Settings.ESPMode == "Selected" then
                shouldShow = shouldShow and (Settings.SelectedPlayers[player.Name] ~= nil)
            end
            if shouldShow and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local head = player.Character:FindFirstChild("Head")
                if humanoid and humanoid.Health > 0 and rootPart then
                    if usingDrawing and not espDrawings[player.Name] then
                        local esp = {}
                        esp.boxTop = Drawing.new("Line")
                        esp.boxBottom = Drawing.new("Line")
                        esp.boxLeft = Drawing.new("Line")
                        esp.boxRight = Drawing.new("Line")
                        esp.name = Drawing.new("Text")
                        esp.name.Size = 13
                        esp.name.Center = true
                        esp.name.Outline = true
                        esp.name.OutlineColor = Color3.fromRGB(0,0,0)
                        esp.name.Visible = false
                        esp.name.Font = 2
                        esp.healthText = Drawing.new("Text")
                        esp.healthText.Size = 11
                        esp.healthText.Center = true
                        esp.healthText.Outline = true
                        esp.healthText.OutlineColor = Color3.fromRGB(0,0,0)
                        esp.healthText.Visible = false
                        esp.healthText.Font = 2
                        esp.distance = Drawing.new("Text")
                        esp.distance.Size = 11
                        esp.distance.Center = true
                        esp.distance.Outline = true
                        esp.distance.OutlineColor = Color3.fromRGB(0,0,0)
                        esp.distance.Visible = false
                        esp.distance.Font = 2
                        espDrawings[player.Name] = esp
                    end

                    if usingDrawing and espDrawings[player.Name] then
                        local esp = espDrawings[player.Name]
                        local headPos = head and head.Position or rootPart.Position + Vector3.new(0,2,0)
local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)

-- Karakterin gerçek boyutunu kullan
local leftShoulder = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(-2, 3, 0))
local rightShoulder = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(2, 3, 0))
local topPos = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3.5, 0))
local bottomPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3.5, 0))

if onScreen and topPos and bottomPos and leftShoulder and rightShoulder then
    local color = Color3.fromRGB(255, 255, 255)
    local dist = math.floor((Camera.CFrame.Position - rootPart.Position).Magnitude)
    local topY = topPos.Y
    local bottomY = bottomPos.Y
    local leftX = leftShoulder.X
    local rightX = rightShoulder.X
    local centerX = (leftX + rightX) / 2
    local boxWidth = math.abs(rightX - leftX) / 2
                            
                            if dist < 300 then
                                esp.boxTop.From = Vector2.new(centerX - boxWidth, topY)
esp.boxTop.To = Vector2.new(centerX + boxWidth, topY)
esp.boxBottom.From = Vector2.new(centerX - boxWidth, bottomY)
esp.boxBottom.To = Vector2.new(centerX + boxWidth, bottomY)
esp.boxLeft.From = Vector2.new(centerX - boxWidth, topY)
esp.boxLeft.To = Vector2.new(centerX - boxWidth, bottomY)
esp.boxRight.From = Vector2.new(centerX + boxWidth, topY)
esp.boxRight.To = Vector2.new(centerX + boxWidth, bottomY)
                                
                                esp.boxTop.Color = color
                                esp.boxBottom.Color = color
                                esp.boxLeft.Color = color
                                esp.boxRight.Color = color
                                esp.boxTop.Thickness = 1
                                esp.boxBottom.Thickness = 1
                                esp.boxLeft.Thickness = 1
                                esp.boxRight.Thickness = 1
                                esp.boxTop.Visible = true
                                esp.boxBottom.Visible = true
                                esp.boxLeft.Visible = true
                                esp.boxRight.Visible = true
                            else
                                esp.boxTop.Visible = false
                                esp.boxBottom.Visible = false
                                esp.boxLeft.Visible = false
                                esp.boxRight.Visible = false
                            end
                            
                            local hp = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                            local yOff = topY - 20
                            
                            if getESPNames() then
                                esp.name.Text = player.DisplayName
                                esp.name.Position = Vector2.new(centerX, yOff)
                                esp.name.Color = color
                                esp.name.Visible = true
                                yOff = yOff - 14
                            else
                                esp.name.Visible = false
                            end
                            
                            if getESPHealth() then
                                esp.healthText.Text = hp .. "%"
                                esp.healthText.Position = Vector2.new(centerX, yOff)
                                esp.healthText.Color = Color3.fromRGB(255*(1-hp/100), 255*(hp/100), 0)
                                esp.healthText.Visible = true
                                yOff = yOff - 13
                            else
                                esp.healthText.Visible = false
                            end
                            
                            if getESPDistance() then
                                esp.distance.Text = dist .. "m"
                                esp.distance.Position = Vector2.new(centerX, yOff)
                                esp.distance.Color = Color3.fromRGB(200,200,200)
                                esp.distance.Visible = true
                            else
                                esp.distance.Visible = false
                            end
                        else
                            if espDrawings[player.Name] then
                                for _, obj in pairs(espDrawings[player.Name]) do
                                    pcall(function() obj.Visible = false end)
                                end
                            end
                        end
                    end
                end
            else
                if espDrawings[player.Name] then
                    for _, obj in pairs(espDrawings[player.Name]) do
                        pcall(function() obj:Remove() end)
                    end
                    espDrawings[player.Name] = nil
                end
            end
        end
    end
end

-- UTILS
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
    local playersToCheck = {}
    if Settings.LockMode == "Selected" then
        for name, plr in pairs(Settings.SelectedPlayers) do
            if plr and plr.Parent and plr.Character then
                table.insert(playersToCheck, plr)
            end
        end
        if #playersToCheck == 0 then return nil end
    else
        playersToCheck = Players:GetPlayers()
    end
    for _, player in ipairs(playersToCheck) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Settings.TargetPart) then
            local part = player.Character[Settings.TargetPart]
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                if getSkipDowned() and isDowned(player.Character) then continue end
                local sp, onScreen = Camera:WorldToScreenPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
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

-- KEYBIND PANEL
local keybindPanel = Instance.new("Frame")
keybindPanel.Name = "KeybindPanel"
keybindPanel.Size = UDim2.new(0, 200, 0, 0)
keybindPanel.Position = UDim2.new(0, 15, 1, -15)
keybindPanel.AnchorPoint = Vector2.new(0, 1)
keybindPanel.BackgroundColor3 = CurrentTheme.Panel
keybindPanel.BackgroundTransparency = 0.1
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
kpScroll.ScrollBarImageColor3 = CurrentTheme.Primary
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

local function makeDraggable2(frame, handle)
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
makeDraggable2(keybindPanel, kpHeader)

-- TOAST
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

function showToast(title, message, toastType)
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
    stroke.Color = CurrentTheme.Primary
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

-- SILENT AIM HOOK
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
            activeKeybindBtn.Text = "[unbound]"
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
        keybindPanel.Visible = false
        fpsFrame.Visible = false
        fovFrame.Visible = false
        locked = false
        Settings.CurrentTarget = nil
        showToast("PANIC", "All features disabled", "error")
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if Settings.Mode == "RightMouseClick" and input.UserInputType == Enum.UserInputType.MouseButton2 then
        locked = false; Settings.CurrentTarget = nil
    end
end)

-- LOOPS
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

local lastAuraAttack = 0
local lastAutoAttack = 0
local orbitAngle = 0

RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if getSpinbot() then
        local target = nil
        local shortest = getKillAuraRange()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local thum = plr.Character:FindFirstChildOfClass("Humanoid")
                if thrp and thum and thum.Health > 0 then
                    local dist = (hrp.Position - thrp.Position).Magnitude
                    if dist < shortest then
                        shortest = dist
                        target = plr
                    end
                end
            end
        end
        if target and target.Character then
            local thrp = target.Character:FindFirstChild("HumanoidRootPart")
            if thrp then
                orbitAngle = orbitAngle + math.rad(getSpinbotSpeed())
                local radius = getSpinbotRadius()
                local offset = Vector3.new(math.cos(orbitAngle) * radius, 0, math.sin(orbitAngle) * radius)
                local targetPos = thrp.Position + offset
                hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos, thrp.Position), 0.3)
            end
        end
    end
    if getKillAura() then
        local now = tick()
        local delay = getKillAuraDelay() / 1000
        if now - lastAuraAttack >= delay then
            lastAuraAttack = now
            local range = getKillAuraRange()
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
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

    if getTriggerBot() then
        local target = Settings.CurrentTarget
        if not target or not target.Character then
            target = getClosestFromSelected()
        end
        if target and target.Character then
            local wasTarget = Settings.CurrentTarget
            Settings.CurrentTarget = target
            local part = target.Character:FindFirstChild(Settings.TargetPart)
            if part then
                local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local triggerRange = getTriggerRange()
                    local dist = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if dist < triggerRange then
                        pcall(function()
                            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end)
                    end
                end
            end
            if not wasTarget then
                Settings.CurrentTarget = nil
            end
        end
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
                    else locked = false; Settings.CurrentTarget = nil end
                end
            else
                if getAutoSwitch() then
                    Settings.CurrentTarget = getClosestFromSelected(); locked = Settings.CurrentTarget ~= nil
                else locked = false; Settings.CurrentTarget = nil end
            end
        end
    end
end)

pcall(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function() vu:CaptureController(); vu:ClickButton2(Vector2.new()) end)
end)

pcall(function()
    GuiService.MenuOpened:Connect(function()
        menuOpen = true
        MainFrame.Visible = false
        keybindPanel.Visible = false
        fpsFrame.Visible = false
        fovFrame.Visible = false
        locked = false
        Settings.CurrentTarget = nil
    end)
    GuiService.MenuClosed:Connect(function()
        menuOpen = false
        MainFrame.Visible = true
        fpsFrame.Visible = getFPSDisplay() or getPingDisplay()
        if getKeybindVisible() then keybindPanel.Visible = true end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    Settings.SelectedPlayers[player.Name] = nil
    if espDrawings[player.Name] then
        for _, obj in pairs(espDrawings[player.Name]) do
            pcall(function() obj:Remove() end)
        end
        espDrawings[player.Name] = nil
    end
end)

print("[SOU HUB] Rage Edition Yuklendi!")

task.spawn(function()
    task.wait(1.5)
    MainFrame.Visible = true
    task.wait(0.5)
    showToast("SOU HUB", "Rage Edition Hazir!", "success")
    showToast("Interface", "Right Shift to toggle", "info")
end)
