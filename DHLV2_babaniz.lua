--[[
    SOU HUB - CLEAN PRO EDITION (Da Hood)
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

local Themes = {
    Winter   = {Name="Winter",   Primary=Color3.fromRGB(140,168,200), Accent=Color3.fromRGB(232,244,255), Bg=Color3.fromRGB(10,18,32),  Panel=Color3.fromRGB(16,28,46),  Button=Color3.fromRGB(26,42,66),  Text=Color3.fromRGB(220,235,250), SubText=Color3.fromRGB(140,165,195)},
    Obsidian = {Name="Obsidian", Primary=Color3.fromRGB(100,110,130), Accent=Color3.fromRGB(160,180,210), Bg=Color3.fromRGB(12,13,16),  Panel=Color3.fromRGB(18,19,23),  Button=Color3.fromRGB(26,28,34),  Text=Color3.fromRGB(200,210,220), SubText=Color3.fromRGB(120,130,140)},
    Crimson  = {Name="Crimson",  Primary=Color3.fromRGB(140,30,50),   Accent=Color3.fromRGB(230,90,110),  Bg=Color3.fromRGB(14,8,12),   Panel=Color3.fromRGB(22,14,18),  Button=Color3.fromRGB(34,20,26),  Text=Color3.fromRGB(230,200,205), SubText=Color3.fromRGB(150,110,120)},
    Cyberpunk= {Name="Cyberpunk",Primary=Color3.fromRGB(255,0,170),   Accent=Color3.fromRGB(0,255,255),   Bg=Color3.fromRGB(10,0,20),   Panel=Color3.fromRGB(21,0,37),   Button=Color3.fromRGB(31,0,53),   Text=Color3.fromRGB(240,220,255), SubText=Color3.fromRGB(180,140,220)},
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

local Settings = {
    WallCheck = false, Smoothness = 0.450, Prediction = 0.100,
    TargetPart = "Head", Mode = "RightMouseClick", StickyAim = true, AutoSwitch = true,
    SkipDowned = true, AlwaysOn = false, TriggerBot = false, FOVVisible = true,
    FOVRadius = 150, FOVUseTheme = true,
    HighlightFillTransparency = 0.35, HighlightColor = Color3.fromRGB(140,168,200),
    GuiTransparency = 500,
    FollowPlayer = false, FollowTarget = nil,
    Kills = 0, SessionStart = tick(),
    CurrentTarget = nil,
    KillAura = false, KillAuraRange = 12, KillAuraDelay = 100,
    Spinbot = false, SpinbotSpeed = 30, SpinbotRadius = 3,
    AutoAttack = false, AutoAttackRange = 8,
}

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

local function tween(obj, time, props, style, dir)
    local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

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

local InitialTransparency = 1 - (Settings.GuiTransparency / 500)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 640, 0, 440)
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -220)
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

local topAccent = Instance.new("Frame")
topAccent.Size = UDim2.new(0, 120, 0, 1)
topAccent.Position = UDim2.new(0, 24, 0, 1)
topAccent.BackgroundColor3 = CurrentTheme.Primary
topAccent.BorderSizePixel = 0
topAccent.ZIndex = 5
topAccent.Parent = MainFrame

local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1, 0, 0, 50); DragHandle.BackgroundTransparency = 1
DragHandle.Text = ""; DragHandle.AutoButtonColor = false; DragHandle.ZIndex = 10; DragHandle.Parent = MainFrame
makeDraggable(MainFrame, DragHandle)

local tl = Instance.new("TextLabel")
tl.Size = UDim2.new(0, 200, 0, 18); tl.Position = UDim2.new(0, 24, 0, 14)
tl.BackgroundTransparency = 1
tl.Text = "SOU HUB"
tl.TextColor3 = CurrentTheme.Text
tl.TextSize = 15
tl.Font = Enum.Font.GothamBold
tl.TextXAlignment = Enum.TextXAlignment.Left
tl.ZIndex = 5
tl.Parent = MainFrame

local titleHue = 0
RunService.RenderStepped:Connect(function(dt)
    titleHue = (titleHue + dt * 0.3) % 1
    tl.TextColor3 = Color3.fromHSV(titleHue, 1, 1)
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0, 12)
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

-- PROFILE (üst sağ)
local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(0, 180, 0, 32)
profileFrame.Position = UDim2.new(1, -220, 0, 14)
profileFrame.BackgroundColor3 = CurrentTheme.Button
profileFrame.BackgroundTransparency = InitialTransparency + 0.4
profileFrame.BorderSizePixel = 0
profileFrame.ZIndex = 5
profileFrame.Parent = MainFrame
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(0, 4)

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 26, 0, 26)
avatarImg.Position = UDim2.new(0, 3, 0.5, -13)
avatarImg.BackgroundTransparency = 1
avatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
avatarImg.ZIndex = 7
avatarImg.Parent = profileFrame
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

local profileName = Instance.new("TextLabel")
profileName.Size = UDim2.new(1, -36, 0, 14)
profileName.Position = UDim2.new(0, 34, 0, 4)
profileName.BackgroundTransparency = 1
profileName.Text = LocalPlayer.DisplayName
profileName.TextColor3 = CurrentTheme.Text
profileName.TextSize = 10
profileName.Font = Enum.Font.GothamBold
profileName.TextXAlignment = Enum.TextXAlignment.Left
profileName.TextTruncate = Enum.TextTruncate.AtEnd
profileName.ZIndex = 6
profileName.Parent = profileFrame

local profileStatus = Instance.new("TextLabel")
profileStatus.Size = UDim2.new(1, -36, 0, 10)
profileStatus.Position = UDim2.new(0, 34, 0, 18)
profileStatus.BackgroundTransparency = 1
profileStatus.Text = "CONNECTED"
profileStatus.TextColor3 = CurrentTheme.SubText
profileStatus.TextSize = 7
profileStatus.Font = Enum.Font.GothamSemibold
profileStatus.TextXAlignment = Enum.TextXAlignment.Left
profileStatus.ZIndex = 6
profileStatus.Parent = profileFrame

-- TAB BAR (yatay, üstte)
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -30, 0, 34)
TabBar.Position = UDim2.new(0, 15, 0, 58)
TabBar.BackgroundColor3 = CurrentTheme.Panel
TabBar.BackgroundTransparency = InitialTransparency + 0.3
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 4
TabBar.Parent = MainFrame
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 6)

local tabBarLayout = Instance.new("UIListLayout", TabBar)
tabBarLayout.FillDirection = Enum.FillDirection.Horizontal
tabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabBarLayout.Padding = UDim.new(0, 4)
tabBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

local tabBarPadding = Instance.new("UIPadding", TabBar)
tabBarPadding.PaddingLeft = UDim.new(0, 6)
tabBarPadding.PaddingRight = UDim.new(0, 6)

-- CONTENT AREA
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -30, 1, -110)
ContentArea.Position = UDim2.new(0, 15, 0, 100)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 3
ContentArea.Parent = MainFrame

local tabConfig = {
    {Name = "AIMLOCK",   Sub = "Targeting"},
    {Name = "ESP",       Sub = "Visual"},
    {Name = "MOVEMENT",  Sub = "Speed"},
    {Name = "COMBAT",    Sub = "Kill Aura"},
    {Name = "SETTINGS",  Sub = "Config"},
}

local tabPages = {}
local tabButtons = {}
local activeTab = "AIMLOCK"
local activeKeybindBtn = nil
local keybindCallbacks = {}
local keybindNames = {}

for i, config in ipairs(tabConfig) do
    local name = config.Name

    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. name
    btn.Size = UDim2.new(0, 110, 0, 24)
    btn.BackgroundColor3 = i==1 and CurrentTheme.Button or Color3.fromRGB(0,0,0)
    btn.BackgroundTransparency = i==1 and 0.2 or 1
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = i==1 and CurrentTheme.Text or CurrentTheme.SubText
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.ZIndex = 5
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

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
    layout.Padding = UDim.new(0,4)
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
                BackgroundTransparency = isActive and 0.2 or 1,
                TextColor3 = isActive and CurrentTheme.Text or CurrentTheme.SubText
            })
        end

        tabPages[oldTab].Visible = false
        page.Visible = true
    end)
end

local function addToggle(page, name, default, callback, order, withKeybind)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 32)
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

    return function() return state end
end

local function addSlider(page, name, min, max, default, callback, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,-8,0,44)
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
    btn.Size = UDim2.new(1,-8,0,32)
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
    container.Size = UDim2.new(1,-16,0,14)
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
    lbl.Size = UDim2.new(1,-8,0,18)
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
    btn.Size = UDim2.new(1,-8,0,34)
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

addSeparator(p1, 14)
addLabel(p1, "TRIGGER", 15)
local getTriggerBot = addToggle(p1, "Trigger Bot", false, nil, 16, true)

addSeparator(p1, 17)
addLabel(p1, "FOV", 18)
local getFOVVisible = addToggle(p1, "FOV Circle", true, nil, 19, true)
local getFOVRadius = addSlider(p1, "FOV Radius", 20, 500, 150, nil, 20)

addSeparator(p1, 21)
addLabel(p1, "SILENT AIM", 22)
local getSilentAim = addToggle(p1, "Silent Aim", false, function(v) silentAimEnabled = v end, 23, true)
local getSilentPart = addCycleButton(p1, "Silent Part", {"Head", "HumanoidRootPart", "UpperTorso"}, "Head", function(v) silentAimTargetPart = v end, 24)

local p2 = tabPages["ESP"]
addLabel(p2, "BOX ESP", 1)
local getESP = addToggle(p2, "Box ESP Enabled", true, nil, 2, true)

addSeparator(p2, 4)
addLabel(p2, "INFO OVERLAY", 5)
local getESPNames = addToggle(p2, "Name Tags", true, nil, 6, true)
local getESPHealth = addToggle(p2, "Health Display", true, nil, 7, false)
local getESPDistance = addToggle(p2, "Distance Display", true, nil, 8, false)

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

local pCombat = tabPages["COMBAT"]
addLabel(pCombat, "KILL AURA", 1)
local getKillAura = addToggle(pCombat, "Kill Aura", false, nil, 2, true)
local getKillAuraRange = addSlider(pCombat, "Aura Range", 5, 30, 12, nil, 3)
local getKillAuraDelay = addSlider(pCombat, "Aura Delay (ms)", 10, 500, 100, nil, 4)

addSeparator(pCombat, 5)
addLabel(pCombat, "ORBIT SPINBOT", 6)
local getSpinbot = addToggle(pCombat, "Orbit Spinbot", false, nil, 7, true)
local getSpinbotSpeed = addSlider(pCombat, "Orbit Speed", 5, 60, 30, nil, 8)
local getSpinbotRadius = addSlider(pCombat, "Orbit Radius", 1, 10, 3, nil, 9)

addSeparator(pCombat, 10)
addLabel(pCombat, "AUTO ATTACK", 11)
local getAutoAttack = addToggle(pCombat, "Auto Attack Nearest", false, nil, 12, true)
local getAutoAttackRange = addSlider(pCombat, "Auto Attack Range", 3, 20, 8, nil, 13)

local p8 = tabPages["SETTINGS"]

addLabel(p8, "INTERFACE", 1)
local getGuiTransparency = addSlider(p8, "Gui Transparency", 0, 500, Settings.GuiTransparency, function(v)
    Settings.GuiTransparency = v
    MainFrame.BackgroundTransparency = 1 - (v / 500)
end, 2)

addSeparator(p8, 3)
addLabel(p8, "OVERLAY", 4)
local getFPSDisplay = addToggle(p8, "FPS Display", true, nil, 5, false)
local getPingDisplay = addToggle(p8, "Ping Display", true, nil, 6, false)

addSeparator(p8, 7)
addLabel(p8, "KEYBIND WINDOW", 8)
local getKeybindVisible = addToggle(p8, "Show Keybind Panel", false, function(v)
    if v then
        updateKeybindPanel()
        keybindPanel.Visible = true
    else
        keybindPanel.Visible = false
    end
end, 9, false)

addSeparator(p8, 10)
addLabel(p8, "SERVER", 11)
addButton(p8, "Server Rejoin", function()
    showToast("Server", "Reconnecting...", "info")
    task.wait(0.5)
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end, 12, CurrentTheme.Button)

-- =============================================
-- FOV CIRCLE (siyah-beyaz, sade)
-- =============================================
local fovFrame = Instance.new("Frame")
fovFrame.Name = "FOVCircle"
fovFrame.Size = UDim2.new(0, 300, 0, 300)
fovFrame.BackgroundTransparency = 1
fovFrame.BorderSizePixel = 0
fovFrame.ZIndex = 999
fovFrame.Visible = false
fovFrame.Parent = ScreenGui

-- İç çember (beyaz)
local fovCircle = Instance.new("Frame")
fovCircle.Name = "Circle"
fovCircle.Size = UDim2.new(1, 0, 1, 0)
fovCircle.Position = UDim2.new(0, 0, 0, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.ZIndex = 1000
fovCircle.Parent = fovFrame
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)

local fovStroke = Instance.new("UIStroke", fovCircle)
fovStroke.Color = Color3.fromRGB(255, 255, 255)
fovStroke.Thickness = 1.5
fovStroke.Transparency = 0.2

-- Dış çember (siyah outline)
local fovCircleOuter = Instance.new("Frame")
fovCircleOuter.Name = "CircleOuter"
fovCircleOuter.Size = UDim2.new(1, 2, 1, 2)
fovCircleOuter.Position = UDim2.new(0, -1, 0, -1)
fovCircleOuter.BackgroundTransparency = 1
fovCircleOuter.BorderSizePixel = 0
fovCircleOuter.ZIndex = 999
fovCircleOuter.Parent = fovFrame
Instance.new("UICorner", fovCircleOuter).CornerRadius = UDim.new(1, 0)

local fovStrokeOuter = Instance.new("UIStroke", fovCircleOuter)
fovStrokeOuter.Color = Color3.fromRGB(0, 0, 0)
fovStrokeOuter.Thickness = 1
fovStrokeOuter.Transparency = 0.5

RunService.RenderStepped:Connect(function(dt)
    if not getFOVVisible() then
        fovFrame.Visible = false
        return
    end
    fovFrame.Visible = true
    local radius = getFOVRadius()
    fovFrame.Size = UDim2.new(0, radius*2, 0, radius*2)
    fovFrame.Position = UDim2.new(0, Mouse.X - radius, 0, Mouse.Y - radius)
end)

local fpsFrame = Instance.new("Frame")
fpsFrame.Size = UDim2.new(0, 100, 0, 20)
fpsFrame.Position = UDim2.new(0, 15, 0, 15)
fpsFrame.BackgroundColor3 = CurrentTheme.Panel
fpsFrame.BackgroundTransparency = 0.5
fpsFrame.BorderSizePixel = 0
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

local usingDrawing = pcall(function() 
    local test = Drawing.new("Line"); test:Remove() 
end)
local espDrawings = {}

local function updateESP()
    local espEnabled = getESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local shouldShow = espEnabled
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
                        local topPos = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0))
                        local bottomPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                        
                        if onScreen and topPos and bottomPos then
                            local color = Color3.fromRGB(255, 255, 255) 
                            local boxWidth = 20
                            local topY = topPos.Y
                            local bottomY = bottomPos.Y
                            local centerX = topPos.X
                            
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
                            
                            local dist = math.floor((Camera.CFrame.Position - rootPart.Position).Magnitude)
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
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Settings.TargetPart) then
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

print("[SOU HUB] Yuklendi!")

task.spawn(function()
    task.wait(1.5)
    MainFrame.Visible = true
    task.wait(0.5)
    showToast("SOU HUB", "Hazir!", "success")
    showToast("Interface", "Right Shift to toggle", "info")
end)
