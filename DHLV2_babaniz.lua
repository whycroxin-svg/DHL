--[[
    SOU HUB - RAGE EDITION (Da Hood)
    lang: Lua, file: SOU_HUB_Rage.lua, target: Roblox executor
    v3.1 — all bugs fixed
]]

print("[SOU HUB] Yukleniyor...")

-- ─── SERVICES ────────────────────────────────────────────────────────────────
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService       = game:GetService("GuiService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local Stats            = game:GetService("Stats")

local Camera      = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ─── GUI PARENT ──────────────────────────────────────────────────────────────
local function getGuiParent()
    if gethui then return gethui() end
    if syn and syn.protect_gui then
        local sg = Instance.new("ScreenGui")
        syn.protect_gui(sg)
        sg.Parent = game:GetService("CoreGui")
        return sg
    end
    local ok = pcall(function()
        local t = Instance.new("ScreenGui")
        t.Parent = game:GetService("CoreGui")
        t:Destroy()
    end)
    if ok then return game:GetService("CoreGui") end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- ─── THEME ───────────────────────────────────────────────────────────────────
local Theme = {
    Primary  = Color3.fromRGB(200, 30,  30),
    Accent   = Color3.fromRGB(255, 60,  60),
    Bg       = Color3.fromRGB(12,  12,  14),
    Panel    = Color3.fromRGB(18,  18,  20),
    Button   = Color3.fromRGB(28,  28,  32),
    Text     = Color3.fromRGB(230, 230, 235),
    SubText  = Color3.fromRGB(130, 130, 140),
}

-- ─── SETTINGS ────────────────────────────────────────────────────────────────
local S = {
    -- aimlock
    AimbotEnabled  = true,
    WallCheck      = false,
    StickyAim      = true,
    AutoSwitch     = true,
    SkipDowned     = true,
    AlwaysOn       = false,
    Smoothness     = 0.45,
    Prediction     = 0.10,
    TargetPart     = "Head",
    Mode           = "RightMouseClick",
    LockMode       = "Normal",
    FOVVisible     = true,
    FOVRadius      = 150,

    -- silent aim
    SilentAim      = false,
    SilentPart     = "Head",

    -- trigger
    TriggerBot     = false,
    TriggerRange   = 15,

    -- esp
    ESPEnabled     = true,
    ESPMode        = "All",
    ESPNames       = true,
    ESPHealth      = true,
    ESPDistance     = true,

    -- rage
    KillAura       = false,
    KillAuraRange  = 12,
    KillAuraDelay  = 0.10,
    Spinbot        = false,
    SpinbotSpeed   = 30,
    SpinbotRadius  = 3,
    AutoAttack     = false,
    AutoAttackRange = 8,

    -- local
    SpeedHack      = false,
    WalkSpeed      = 16,
    JumpHack       = false,
    JumpPower      = 50,
    InfJump        = false,
    Fly            = false,
    FlySpeed       = 50,
    Noclip         = false,

    -- ui
    FPSDisplay     = true,
    PingDisplay    = true,
    KeybindPanel   = false,

    -- runtime
    CurrentTarget    = nil,
    SelectedPlayers  = {},
}

-- ─── CLEAN OLD GUI ───────────────────────────────────────────────────────────
for _, loc in ipairs({game:GetService("CoreGui"), LocalPlayer:FindFirstChild("PlayerGui")}) do
    pcall(function()
        local o = loc and loc:FindFirstChild("SOUHUB_Rage")
        if o then o:Destroy() end
    end)
end
pcall(function()
    if gethui then
        local o = gethui():FindFirstChild("SOUHUB_Rage")
        if o then o:Destroy() end
    end
end)

-- ─── TWEEN UTIL ──────────────────────────────────────────────────────────────
local function tw(obj, t, props, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
        props):Play()
end

-- ─── SCREEN GUI ──────────────────────────────────────────────────────────────
local guiParent = getGuiParent()
local ScreenGui

if guiParent:IsA("ScreenGui") then
    ScreenGui = guiParent
else
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = guiParent
end
ScreenGui.Name            = "SOUHUB_Rage"
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder    = 999
ScreenGui.IgnoreGuiInset  = true

-- ─── TOAST (forward declare so Config tab can call showNotice) ───────────────
local toastContainer = Instance.new("Frame")
toastContainer.Name               = "ToastContainer"
toastContainer.Size               = UDim2.new(0, 320, 1, -20)
toastContainer.Position           = UDim2.new(1, -340, 0, 10)
toastContainer.BackgroundTransparency = 1
toastContainer.ZIndex             = 1000
toastContainer.Parent             = ScreenGui

local toastLayout = Instance.new("UIListLayout", toastContainer)
toastLayout.SortOrder        = Enum.SortOrder.LayoutOrder
toastLayout.Padding          = UDim.new(0, 8)
toastLayout.VerticalAlignment = Enum.VerticalAlignment.Top

function showNotice(title, msg, kind)
    local colors = {
        info    = Theme.Accent,
        success = Color3.fromRGB(80, 200, 130),
        warning = Color3.fromRGB(230, 180, 60),
        error   = Color3.fromRGB(220, 70, 80),
    }
    local toast = Instance.new("Frame")
    toast.Size               = UDim2.new(0, 0, 0, 52)
    toast.Position           = UDim2.new(1, 20, 0, 0)
    toast.BackgroundColor3   = Theme.Panel
    toast.BackgroundTransparency = 0.05
    toast.BorderSizePixel    = 0
    toast.ZIndex             = 1001
    toast.Parent             = toastContainer
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", toast)
    stroke.Color    = Theme.Primary
    stroke.Thickness = 1

    local bar = Instance.new("Frame", toast)
    bar.Size            = UDim2.new(0, 3, 1, 0)
    bar.BackgroundColor3 = colors[kind] or Theme.Accent
    bar.BorderSizePixel = 0
    bar.ZIndex          = 1002

    local titleLbl = Instance.new("TextLabel", toast)
    titleLbl.Size             = UDim2.new(1, -24, 0, 18)
    titleLbl.Position         = UDim2.new(0, 14, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text             = title
    titleLbl.TextColor3       = Theme.Text
    titleLbl.TextSize         = 12
    titleLbl.Font             = Enum.Font.GothamBold
    titleLbl.TextXAlignment   = Enum.TextXAlignment.Left
    titleLbl.ZIndex           = 1002

    local msgLbl = Instance.new("TextLabel", toast)
    msgLbl.Size               = UDim2.new(1, -24, 0, 16)
    msgLbl.Position           = UDim2.new(0, 14, 0, 28)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text               = msg
    msgLbl.TextColor3         = Theme.SubText
    msgLbl.TextSize           = 10
    msgLbl.Font               = Enum.Font.Gotham
    msgLbl.TextXAlignment     = Enum.TextXAlignment.Left
    msgLbl.ZIndex             = 1002

    tw(toast, 0.4, {Size = UDim2.new(0, 320, 0, 52), Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quint)

    task.delay(3, function()
        tw(toast,    0.3, {Position = UDim2.new(1, 20, 0, 0)}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        tw(toast,    0.3, {BackgroundTransparency = 1})
        tw(titleLbl, 0.25, {TextTransparency = 1})
        tw(msgLbl,   0.25, {TextTransparency = 1})
        tw(stroke,   0.25, {Transparency = 1})
        task.wait(0.35)
        toast:Destroy()
    end)
end

-- ─── MAIN FRAME ──────────────────────────────────────────────────────────────
local MainFrame = Instance.new("Frame")
MainFrame.Name                = "MainFrame"
MainFrame.Size                = UDim2.new(0, 700, 0, 480)
MainFrame.Position            = UDim2.new(0.5, -350, 0.5, -240)
MainFrame.BackgroundColor3    = Theme.Bg
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel     = 0
MainFrame.Visible             = false
MainFrame.Parent              = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color       = Theme.Primary
mainStroke.Thickness   = 1
mainStroke.Transparency = 0.5

-- drag
local DragHandle = Instance.new("TextButton")
DragHandle.Size                 = UDim2.new(1, 0, 0, 40)
DragHandle.BackgroundTransparency = 1
DragHandle.Text                 = ""
DragHandle.AutoButtonColor      = false
DragHandle.ZIndex               = 10
DragHandle.Parent               = MainFrame

local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or frame
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end
makeDraggable(MainFrame, DragHandle)

-- close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size                 = UDim2.new(0, 28, 0, 28)
closeBtn.Position             = UDim2.new(1, -36, 0, 8)
closeBtn.BackgroundColor3     = Theme.Button
closeBtn.BackgroundTransparency = 0.5
closeBtn.BorderSizePixel      = 0
closeBtn.Text                 = "x"
closeBtn.TextColor3           = Theme.SubText
closeBtn.TextSize             = 20
closeBtn.Font                 = Enum.Font.Gotham
closeBtn.AutoButtonColor      = false
closeBtn.ZIndex               = 11
closeBtn.Parent               = MainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)
closeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- ─── SIDEBAR ─────────────────────────────────────────────────────────────────
local Sidebar = Instance.new("Frame")
Sidebar.Size             = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Theme.Panel
Sidebar.BorderSizePixel  = 0
Sidebar.ZIndex           = 4
Sidebar.Parent           = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local logoFrame = Instance.new("Frame")
logoFrame.Size                = UDim2.new(1, 0, 0, 90)
logoFrame.BackgroundTransparency = 1
logoFrame.ZIndex              = 5
logoFrame.Parent              = Sidebar

local logoImg = Instance.new("ImageLabel")
logoImg.Size                  = UDim2.new(0, 70, 0, 70)
logoImg.Position              = UDim2.new(0.5, -35, 0, 10)
logoImg.BackgroundTransparency = 1
logoImg.ZIndex                = 6
logoImg.Parent                = logoFrame

pcall(function()
    local url  = "https://raw.githubusercontent.com/whycroxin-svg/logo/main/3a51ccbf-3a34-4037-af47-0489047fa126.png"
    local file = "souhub_logo.png"
    if writefile and isfile and getcustomasset then
        if not isfile(file) then writefile(file, game:HttpGet(url)) end
        logoImg.Image = getcustomasset(file)
    else
        logoImg.Image = url
    end
end)

local SideScroll = Instance.new("ScrollingFrame")
SideScroll.Size                  = UDim2.new(1, 0, 1, -90)
SideScroll.Position              = UDim2.new(0, 0, 0, 90)
SideScroll.BackgroundTransparency = 1
SideScroll.BorderSizePixel       = 0
SideScroll.ScrollBarThickness    = 2
SideScroll.ScrollBarImageColor3  = Theme.Primary
SideScroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
SideScroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
SideScroll.ZIndex                = 5
SideScroll.Parent                = Sidebar

local sideLayout = Instance.new("UIListLayout", SideScroll)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Padding   = UDim.new(0, 2)
local sidePad = Instance.new("UIPadding", SideScroll)
sidePad.PaddingTop = UDim.new(0, 6)

-- ─── CONTENT AREA ────────────────────────────────────────────────────────────
local ContentArea = Instance.new("Frame")
ContentArea.Size              = UDim2.new(1, -170, 1, -20)
ContentArea.Position          = UDim2.new(0, 165, 0, 10)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants  = true
ContentArea.ZIndex            = 3
ContentArea.Parent            = MainFrame

-- ─── TAB SYSTEM ──────────────────────────────────────────────────────────────
local tabConfig = {
    {id = "AIMLOCK",  label = "Aimlock"},
    {id = "SILENT",   label = "Silent"},
    {id = "TRIGGER",  label = "Trigger"},
    {id = "VISUALS",  label = "Visuals"},
    {id = "RAGE",     label = "Rage"},
    {id = "PLAYER",   label = "Player"},
    {id = "LOCAL",    label = "Local"},
    {id = "SETTINGS", label = "Settings"},
    {id = "CONFIG",   label = "Config"},
    {id = "COLORS",   label = "Colors"},
}

local tabPages   = {}
local tabButtons = {}
local activeTab  = tabConfig[1].id

local keybindMap   = {}
local pendingKbBtn = nil

local function makeTabPage(i, cfg)
    local page = Instance.new("ScrollingFrame")
    page.Size                   = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel        = 0
    page.ScrollBarThickness     = 3
    page.ScrollBarImageColor3   = Theme.Primary
    page.CanvasSize             = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    page.Visible                = (i == 1)
    page.ZIndex                 = 2
    page.Active                 = true
    page.Parent                 = ContentArea

    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding   = UDim.new(0, 5)

    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft  = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
    pad.PaddingTop   = UDim.new(0, 6)

    return page
end

local function makeTabBtn(i, cfg)
    local btn = Instance.new("TextButton")
    btn.Name                   = "Tab_" .. cfg.id
    btn.Size                   = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3       = Theme.Button
    btn.BackgroundTransparency = (i == 1) and 0.3 or 1
    btn.BorderSizePixel        = 0
    btn.Text                   = ""
    btn.AutoButtonColor        = false
    btn.LayoutOrder            = i
    btn.ZIndex                 = 5
    btn.Parent                 = SideScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local indicator = Instance.new("Frame")
    indicator.Name            = "Indicator"
    indicator.Size            = (i == 1) and UDim2.new(0, 3, 0, 20) or UDim2.new(0, 3, 0, 0)
    indicator.Position        = UDim2.new(0, 0, 0.5, 0)
    indicator.AnchorPoint     = Vector2.new(0, 0.5)
    indicator.BackgroundColor3 = Theme.Primary
    indicator.BorderSizePixel = 0
    indicator.Visible         = (i == 1)
    indicator.ZIndex          = 7
    indicator.Parent          = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name               = "Label"
    nameLbl.Size               = UDim2.new(1, -14, 1, 0)
    nameLbl.Position           = UDim2.new(0, 14, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text               = cfg.label
    nameLbl.TextColor3         = (i == 1) and Theme.Text or Theme.SubText
    nameLbl.TextSize           = 12
    nameLbl.Font               = Enum.Font.GothamMedium
    nameLbl.TextXAlignment     = Enum.TextXAlignment.Left
    nameLbl.ZIndex             = 6
    nameLbl.Parent             = btn

    btn.MouseEnter:Connect(function()
        if activeTab ~= cfg.id then
            tw(btn,    0.15, {BackgroundTransparency = 0.7, BackgroundColor3 = Theme.Button})
            tw(nameLbl, 0.15, {TextColor3 = Theme.Text})
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= cfg.id then
            tw(btn,    0.15, {BackgroundTransparency = 1})
            tw(nameLbl, 0.15, {TextColor3 = Theme.SubText})
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if activeTab == cfg.id then return end
        tabPages[activeTab].Visible = false
        activeTab = cfg.id
        tabPages[cfg.id].Visible = true

        for _, c in ipairs(tabConfig) do
            local b   = tabButtons[c.id]
            local nl  = b:FindFirstChild("Label")
            local ind = b:FindFirstChild("Indicator")
            local active = (c.id == cfg.id)
            if ind then
                ind.Visible = active
                tw(ind, 0.2, {Size = active and UDim2.new(0,3,0,20) or UDim2.new(0,3,0,0)})
            end
            if nl then tw(nl, 0.15, {TextColor3 = active and Theme.Text or Theme.SubText}) end
            tw(b, 0.2, {BackgroundTransparency = active and 0.3 or 1, BackgroundColor3 = Theme.Button})
        end
    end)

    return btn
end

for i, cfg in ipairs(tabConfig) do
    tabPages[cfg.id]   = makeTabPage(i, cfg)
    tabButtons[cfg.id] = makeTabBtn(i, cfg)
end

-- ─── UI BUILDERS ─────────────────────────────────────────────────────────────
local function addLabel(page, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size               = UDim2.new(1, -8, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Text               = text
    lbl.TextColor3         = Theme.Primary
    lbl.TextSize           = 10
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.LayoutOrder        = order or 0
    lbl.ZIndex             = 3
    lbl.Parent             = page
end

local function addSeparator(page, order)
    local f = Instance.new("Frame")
    f.Size               = UDim2.new(1, -16, 0, 14)
    f.BackgroundTransparency = 1
    f.LayoutOrder        = order or 0
    f.ZIndex             = 3
    f.Parent             = page
    local line = Instance.new("Frame", f)
    line.Size            = UDim2.new(1, 0, 0, 1)
    line.Position        = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = Theme.Button
    line.BackgroundTransparency = 0.3
    line.BorderSizePixel = 0
    line.ZIndex          = 3
end

local function makeKeybindBtn(parent)
    local kbBtn = Instance.new("TextButton")
    kbBtn.Size                 = UDim2.new(0, 60, 1, 0)
    kbBtn.Position             = UDim2.new(1, -60, 0, 0)
    kbBtn.BackgroundColor3     = Color3.fromRGB(40, 40, 45)
    kbBtn.BackgroundTransparency = 0.3
    kbBtn.BorderSizePixel      = 0
    kbBtn.Text                 = "[none]"
    kbBtn.TextColor3           = Theme.SubText
    kbBtn.TextSize             = 9
    kbBtn.Font                 = Enum.Font.Gotham
    kbBtn.AutoButtonColor      = false
    kbBtn.ZIndex               = 4
    kbBtn.Parent               = parent
    Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 2)

    kbBtn.MouseButton1Click:Connect(function()
        if pendingKbBtn == kbBtn then
            pendingKbBtn = nil
            kbBtn.Text      = "[none]"
            kbBtn.TextColor3 = Theme.SubText
        else
            if pendingKbBtn then
                pendingKbBtn.Text      = "[none]"
                pendingKbBtn.TextColor3 = Theme.SubText
            end
            pendingKbBtn = kbBtn
            kbBtn.Text      = "..."
            kbBtn.TextColor3 = Color3.fromRGB(230, 180, 60)
        end
    end)

    return kbBtn
end

local function addToggle(page, name, default, onChange, order, withKeybind)
    local row = Instance.new("Frame")
    row.Size               = UDim2.new(1, -8, 0, 26)
    row.BackgroundTransparency = 1
    row.LayoutOrder        = order or 0
    row.ZIndex             = 3
    row.Parent             = page

    local cb = Instance.new("TextButton")
    cb.Size                = UDim2.new(0, 14, 0, 14)
    cb.Position            = UDim2.new(0, 0, 0.5, -7)
    cb.BackgroundColor3    = default and Theme.Primary or Color3.fromRGB(40, 40, 45)
    cb.BorderSizePixel     = 0
    cb.Text                = ""
    cb.AutoButtonColor     = false
    cb.ZIndex              = 4
    cb.Parent              = row
    Instance.new("UICorner", cb).CornerRadius = UDim.new(0, 2)

    local check = Instance.new("TextLabel", cb)
    check.Size               = UDim2.new(1, 0, 1, 0)
    check.BackgroundTransparency = 1
    check.Text               = default and "v" or ""
    check.TextColor3         = Color3.fromRGB(255, 255, 255)
    check.TextSize           = 12
    check.Font               = Enum.Font.GothamBold
    check.ZIndex             = 5

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size             = UDim2.new(1, withKeybind and -88 or -22, 1, 0)
    nameLbl.Position         = UDim2.new(0, 22, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text             = name
    nameLbl.TextColor3       = default and Theme.Text or Theme.SubText
    nameLbl.TextSize         = 11
    nameLbl.Font             = Enum.Font.GothamMedium
    nameLbl.TextXAlignment   = Enum.TextXAlignment.Left
    nameLbl.ZIndex           = 3
    nameLbl.Parent           = row

    local state = default
    local kbBtn = withKeybind and makeKeybindBtn(row) or nil

    local function doToggle()
        state = not state
        cb.BackgroundColor3 = state and Theme.Primary or Color3.fromRGB(40, 40, 45)
        check.Text          = state and "v" or ""
        tw(nameLbl, 0.15, {TextColor3 = state and Theme.Text or Theme.SubText})
        if onChange then onChange(state) end
    end
    cb.MouseButton1Click:Connect(doToggle)

    if kbBtn then
        kbBtn._toggle = doToggle
        kbBtn._name   = name
    end

    return function() return state end, kbBtn
end

local function addSlider(page, name, min, max, default, onChange, order)
    local container = Instance.new("Frame")
    container.Size               = UDim2.new(1, -8, 0, 40)
    container.BackgroundTransparency = 1
    container.LayoutOrder        = order or 0
    container.ZIndex             = 3
    container.Parent             = page

    local label = Instance.new("TextLabel")
    label.Size             = UDim2.new(0.6, 0, 0, 16)
    label.BackgroundTransparency = 1
    label.Text             = name
    label.TextColor3       = Theme.Text
    label.TextSize         = 11
    label.Font             = Enum.Font.GothamMedium
    label.TextXAlignment   = Enum.TextXAlignment.Left
    label.ZIndex           = 3
    label.Parent           = container

    local valueLbl = Instance.new("TextLabel")
    valueLbl.Size            = UDim2.new(0.4, -4, 0, 16)
    valueLbl.Position        = UDim2.new(0.6, 0, 0, 0)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text            = tostring(math.floor(default))
    valueLbl.TextColor3      = Theme.Text
    valueLbl.TextSize        = 11
    valueLbl.Font            = Enum.Font.GothamBold
    valueLbl.TextXAlignment  = Enum.TextXAlignment.Right
    valueLbl.ZIndex          = 3
    valueLbl.Parent          = container

    local bg = Instance.new("TextButton")
    bg.Size              = UDim2.new(1, 0, 0, 4)
    bg.Position          = UDim2.new(0, 0, 0, 22)
    bg.BackgroundColor3  = Color3.fromRGB(40, 40, 45)
    bg.BorderSizePixel   = 0
    bg.Text              = ""
    bg.AutoButtonColor   = false
    bg.ZIndex            = 3
    bg.Parent            = container
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bg)
    fill.Size            = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Primary
    fill.BorderSizePixel = 0
    fill.ZIndex          = 3
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", bg)
    knob.Size            = UDim2.new(0, 10, 0, 10)
    knob.AnchorPoint     = Vector2.new(0.5, 0.5)
    knob.Position        = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex          = 4
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local value   = default
    local sliding = false

    local function update(px)
        local ax, as = bg.AbsolutePosition.X, bg.AbsoluteSize.X
        if as == 0 then return end
        local p = math.clamp((px - ax) / as, 0, 1)
        value = min + (max - min) * p
        tw(fill, 0.06, {Size = UDim2.new(p, 0, 1, 0)})
        tw(knob, 0.06, {Position = UDim2.new(p, 0, 0.5, 0)})
        valueLbl.Text = tostring(math.floor(value))
        if onChange then onChange(value) end
    end

    bg.MouseButton1Down:Connect(function(x) sliding = true; update(x) end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement
                     or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)

    return function() return value end
end

local function addCycle(page, name, options, default, onChange, order)
    local idx = 1
    for i, v in ipairs(options) do if v == default then idx = i; break end end

    local btn = Instance.new("TextButton")
    btn.Size               = UDim2.new(1, -8, 0, 26)
    btn.BackgroundColor3   = Color3.fromRGB(40, 40, 45)
    btn.BorderSizePixel    = 0
    btn.Text               = ""
    btn.AutoButtonColor    = false
    btn.LayoutOrder        = order or 0
    btn.ZIndex             = 3
    btn.Parent             = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 2)

    local valueLbl = Instance.new("TextLabel", btn)
    valueLbl.Size            = UDim2.new(1, -30, 1, 0)
    valueLbl.Position        = UDim2.new(0, 10, 0, 0)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text            = options[idx]
    valueLbl.TextColor3      = Theme.Text
    valueLbl.TextSize        = 11
    valueLbl.Font            = Enum.Font.GothamMedium
    valueLbl.TextXAlignment  = Enum.TextXAlignment.Left
    valueLbl.ZIndex          = 4

    local arrow = Instance.new("TextLabel", btn)
    arrow.Size               = UDim2.new(0, 20, 1, 0)
    arrow.Position           = UDim2.new(1, -22, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text               = "v"
    arrow.TextColor3         = Theme.SubText
    arrow.TextSize           = 8
    arrow.Font               = Enum.Font.GothamBold
    arrow.ZIndex             = 4

    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        valueLbl.Text = options[idx]
        if onChange then onChange(options[idx]) end
    end)

    return function() return options[idx] end
end

local function addButton(page, name, callback, order, color)
    local btn = Instance.new("TextButton")
    btn.Size               = UDim2.new(1, -8, 0, 32)
    btn.BackgroundColor3   = color or Theme.Button
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel    = 0
    btn.Text               = name
    btn.TextColor3         = Theme.Text
    btn.TextSize           = 11
    btn.Font               = Enum.Font.GothamMedium
    btn.AutoButtonColor    = false
    btn.LayoutOrder        = order or 0
    btn.ZIndex             = 3
    btn.Parent             = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
    return btn
end

-- ─── TAB: AIMLOCK ────────────────────────────────────────────────────────────
local p = tabPages["AIMLOCK"]
addLabel(p, "LOCK MODE", 1)
addCycle(p, "Lock Mode", {"Normal", "Selected"}, "Normal", function(v) S.LockMode = v end, 2)
addSeparator(p, 3)
addLabel(p, "AIMBOT", 4)
local getAimbot  = addToggle(p, "Aimbot",       S.AimbotEnabled, function(v) S.AimbotEnabled = v end,  5,  true)
local getWall    = addToggle(p, "Wall Check",   S.WallCheck,     function(v) S.WallCheck = v end,       6,  true)
                   addToggle(p, "Sticky Aim",   S.StickyAim,     function(v) S.StickyAim = v end,       7,  true)
                   addToggle(p, "Auto Switch",  S.AutoSwitch,    function(v) S.AutoSwitch = v end,       8,  false)
                   addToggle(p, "Skip Downed",  S.SkipDowned,    function(v) S.SkipDowned = v end,       9,  true)
                   addToggle(p, "Always On",    S.AlwaysOn,      function(v) S.AlwaysOn = v end,         10, true)
addSeparator(p, 11)
addLabel(p, "PARAMETERS", 12)
addCycle(p, "Mode", {"Right Mouse Click", "Nearest Cursor", "Toggle Q"}, "Right Mouse Click", function(v)
    local map = {["Right Mouse Click"] = "RightMouseClick", ["Nearest Cursor"] = "NearestCursor", ["Toggle Q"] = "ToggleQ"}
    S.Mode = map[v] or "RightMouseClick"
end, 13)
addCycle(p, "Target Part", {"Head", "HumanoidRootPart", "UpperTorso"}, "Head", function(v) S.TargetPart = v end, 14)
local getSmoothness = addSlider(p, "Smoothness", 0.05, 1.0, S.Smoothness, function(v) S.Smoothness = v end, 15)
local getPrediction = addSlider(p, "Prediction", 0.0, 0.5, S.Prediction, function(v) S.Prediction = v end, 16)
addSeparator(p, 17)
addLabel(p, "FOV", 18)
local getFOVVisible = addToggle(p, "FOV Circle", S.FOVVisible, function(v) S.FOVVisible = v end, 19, true)
local getFOVRadius  = addSlider(p, "FOV Radius", 20, 500, S.FOVRadius, function(v) S.FOVRadius = v end, 20)

-- ─── TAB: SILENT ─────────────────────────────────────────────────────────────
p = tabPages["SILENT"]
addLabel(p, "SILENT AIM", 1)
addToggle(p, "Silent Aim", S.SilentAim, function(v) S.SilentAim = v end, 2, true)
addCycle(p, "Silent Part", {"Head", "HumanoidRootPart", "UpperTorso"}, "Head", function(v) S.SilentPart = v end, 3)

-- ─── TAB: TRIGGER ────────────────────────────────────────────────────────────
p = tabPages["TRIGGER"]
addLabel(p, "TRIGGER BOT", 1)
addToggle(p, "Trigger Bot", S.TriggerBot, function(v) S.TriggerBot = v end, 2, true)
local getTriggerRange = addSlider(p, "Trigger Range", 5, 50, S.TriggerRange, function(v) S.TriggerRange = v end, 3)

-- ─── TAB: VISUALS ────────────────────────────────────────────────────────────
p = tabPages["VISUALS"]
addLabel(p, "ESP MODE", 1)
addCycle(p, "ESP Mode", {"All", "Selected"}, "All", function(v) S.ESPMode = v end, 2)
addSeparator(p, 3)
addLabel(p, "BOX ESP", 4)
addToggle(p, "Box ESP",          S.ESPEnabled,  function(v) S.ESPEnabled = v end,  5, true)
addSeparator(p, 6)
addLabel(p, "INFO OVERLAY", 7)
addToggle(p, "Name Tags",        S.ESPNames,    function(v) S.ESPNames = v end,    8,  true)
addToggle(p, "Health Display",   S.ESPHealth,   function(v) S.ESPHealth = v end,   9,  false)
addToggle(p, "Distance Display", S.ESPDistance, function(v) S.ESPDistance = v end, 10, false)

-- ─── TAB: RAGE ───────────────────────────────────────────────────────────────
p = tabPages["RAGE"]
addLabel(p, "KILL AURA", 1)
addToggle(p, "Kill Aura", S.KillAura, function(v) S.KillAura = v end, 2, true)
local getKARange = addSlider(p, "Aura Range",    5,  30,  S.KillAuraRange, function(v) S.KillAuraRange = v end,        3)
local getKADelay = addSlider(p, "Aura Delay ms", 10, 500, S.KillAuraDelay * 1000, function(v) S.KillAuraDelay = v / 1000 end, 4)
addSeparator(p, 5)
addLabel(p, "SPINBOT", 6)
addToggle(p, "Orbit Spinbot", S.Spinbot, function(v) S.Spinbot = v end, 7, true)
local getSBSpeed  = addSlider(p, "Orbit Speed",  5, 60, S.SpinbotSpeed,  function(v) S.SpinbotSpeed = v end,  8)
local getSBRadius = addSlider(p, "Orbit Radius", 1, 10, S.SpinbotRadius, function(v) S.SpinbotRadius = v end, 9)
addSeparator(p, 10)
addLabel(p, "AUTO ATTACK", 11)
addToggle(p, "Auto Attack Nearest", S.AutoAttack, function(v) S.AutoAttack = v end, 12, true)
local getAARange = addSlider(p, "Auto Attack Range", 3, 20, S.AutoAttackRange, function(v) S.AutoAttackRange = v end, 13)

-- ─── TAB: PLAYER ─────────────────────────────────────────────────────────────
p = tabPages["PLAYER"]
addLabel(p, "SELECTED PLAYERS", 1)

local selectCountLbl = Instance.new("TextLabel")
selectCountLbl.Size               = UDim2.new(1, -8, 0, 20)
selectCountLbl.BackgroundTransparency = 1
selectCountLbl.Text               = "0 players selected"
selectCountLbl.TextColor3         = Theme.SubText
selectCountLbl.TextSize           = 10
selectCountLbl.Font               = Enum.Font.Gotham
selectCountLbl.TextXAlignment     = Enum.TextXAlignment.Left
selectCountLbl.LayoutOrder        = 2
selectCountLbl.ZIndex             = 3
selectCountLbl.Parent             = p

local btnRow = Instance.new("Frame")
btnRow.Size               = UDim2.new(1, -8, 0, 28)
btnRow.BackgroundTransparency = 1
btnRow.LayoutOrder        = 3
btnRow.ZIndex             = 3
btnRow.Parent             = p

local function makeSplitBtn(parent, text, xScale, xOff)
    local b = Instance.new("TextButton")
    b.Size               = UDim2.new(xScale, 0, 1, 0)
    b.Position           = UDim2.new(xOff, 0, 0, 0)
    b.BackgroundColor3   = Theme.Button
    b.BackgroundTransparency = 0.3
    b.BorderSizePixel    = 0
    b.Text               = text
    b.TextColor3         = Theme.Text
    b.TextSize           = 10
    b.Font               = Enum.Font.GothamMedium
    b.AutoButtonColor    = false
    b.ZIndex             = 3
    b.Parent             = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

local selectAllBtn = makeSplitBtn(btnRow, "Select All", 0.48, 0)
local clearAllBtn  = makeSplitBtn(btnRow, "Clear",      0.48, 0.52)

local searchBox = Instance.new("TextBox")
searchBox.Size               = UDim2.new(1, -8, 0, 28)
searchBox.BackgroundColor3   = Theme.Button
searchBox.BackgroundTransparency = 0.4
searchBox.BorderSizePixel    = 0
searchBox.PlaceholderText    = "Search players..."
searchBox.PlaceholderColor3  = Theme.SubText
searchBox.Text               = ""
searchBox.TextColor3         = Theme.Text
searchBox.TextSize           = 10
searchBox.Font               = Enum.Font.Gotham
searchBox.ClearTextOnFocus   = false
searchBox.LayoutOrder        = 4
searchBox.ZIndex             = 3
searchBox.Parent             = p
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)

local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size                 = UDim2.new(1, -8, 0, 260)
playerScroll.BackgroundTransparency = 1
playerScroll.BorderSizePixel      = 0
playerScroll.ScrollBarThickness   = 3
playerScroll.ScrollBarImageColor3 = Theme.Primary
playerScroll.CanvasSize           = UDim2.new(0, 0, 0, 0)
playerScroll.AutomaticCanvasSize  = Enum.AutomaticSize.Y
playerScroll.LayoutOrder          = 5
playerScroll.ZIndex               = 3
playerScroll.Active               = true
playerScroll.Parent               = p
Instance.new("UIListLayout", playerScroll).Padding = UDim.new(0, 3)

local playerBtns = {}

local function updateSelectCount()
    local c = 0
    for _ in pairs(S.SelectedPlayers) do c = c + 1 end
    selectCountLbl.Text = c .. " player" .. (c == 1 and "" or "s") .. " selected"
end

local function refreshPlayerList()
    for _, b in pairs(playerBtns) do if b and b.Parent then b:Destroy() end end
    playerBtns = {}
    local search = searchBox.Text:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if search == "" or plr.DisplayName:lower():find(search, 1, true) or plr.Name:lower():find(search, 1, true) then
                local sel = S.SelectedPlayers[plr.Name] ~= nil
                local b = Instance.new("TextButton")
                b.Name                    = "PLR_" .. plr.Name
                b.Size                    = UDim2.new(1, -4, 0, 28)
                b.BackgroundColor3        = Theme.Button
                b.BackgroundTransparency  = sel and 0.15 or 0.4
                b.BorderSizePixel         = 0
                b.Text                    = plr.DisplayName
                b.TextColor3              = sel and Theme.Text or Theme.SubText
                b.TextSize                = 10
                b.Font                    = Enum.Font.Gotham
                b.TextXAlignment          = Enum.TextXAlignment.Left
                b.AutoButtonColor         = false
                b.ZIndex                  = 3
                b.Parent                  = playerScroll
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                Instance.new("UIPadding", b).PaddingLeft = UDim.new(0, 12)

                b.MouseButton1Click:Connect(function()
                    if S.SelectedPlayers[plr.Name] then
                        S.SelectedPlayers[plr.Name] = nil
                        tw(b, 0.2, {BackgroundTransparency = 0.4})
                        b.TextColor3 = Theme.SubText
                    else
                        S.SelectedPlayers[plr.Name] = plr
                        tw(b, 0.2, {BackgroundTransparency = 0.15})
                        b.TextColor3 = Theme.Text
                    end
                    updateSelectCount()
                end)
                playerBtns[plr.Name] = b
            end
        end
    end
    updateSelectCount()
end

selectAllBtn.MouseButton1Click:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then S.SelectedPlayers[plr.Name] = plr end
    end
    refreshPlayerList()
end)
clearAllBtn.MouseButton1Click:Connect(function()
    S.SelectedPlayers = {}
    refreshPlayerList()
end)
searchBox:GetPropertyChangedSignal("Text"):Connect(refreshPlayerList)
refreshPlayerList()

-- single PlayerAdded/Removing (no duplicates)
Players.PlayerAdded:Connect(function() task.wait(0.5); refreshPlayerList() end)
Players.PlayerRemoving:Connect(function(plr)
    S.SelectedPlayers[plr.Name] = nil
    if S.CurrentTarget == plr then S.CurrentTarget = nil end
    removeESPObjects(plr.Name)
    task.wait(0.1); refreshPlayerList()
end)

-- ─── TAB: LOCAL ──────────────────────────────────────────────────────────────
p = tabPages["LOCAL"]
addLabel(p, "SPEED", 1)
addToggle(p, "Speed Hack", S.SpeedHack, function(v) S.SpeedHack = v end, 2, true)
local getSpeedVal = addSlider(p, "Walk Speed", 16, 500, S.WalkSpeed, function(v) S.WalkSpeed = v end, 3)
addSeparator(p, 4)
addLabel(p, "JUMP", 5)
addToggle(p, "Jump Power",    S.JumpHack, function(v) S.JumpHack = v end, 6, true)
local getJumpVal = addSlider(p, "Jump Value", 50, 500, S.JumpPower, function(v) S.JumpPower = v end, 7)
addToggle(p, "Infinite Jump", S.InfJump,  function(v) S.InfJump = v end,  8, true)
addSeparator(p, 9)
addLabel(p, "FLIGHT", 10)
addToggle(p, "Fly",           S.Fly,       function(v) S.Fly = v end,      11, true)
local getFlySpeed = addSlider(p, "Fly Speed", 10, 500, S.FlySpeed, function(v) S.FlySpeed = v end, 12)
addSeparator(p, 13)
addLabel(p, "NOCLIP", 14)
addToggle(p, "Noclip", S.Noclip, function(v)
    S.Noclip = v
    if not v and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end, 15, true)

-- ─── TAB: SETTINGS ───────────────────────────────────────────────────────────
p = tabPages["SETTINGS"]
addLabel(p, "OVERLAY", 1)
addToggle(p, "FPS Display",  S.FPSDisplay,  function(v) S.FPSDisplay  = v end, 2, false)
addToggle(p, "Ping Display", S.PingDisplay, function(v) S.PingDisplay = v end, 3, false)
addSeparator(p, 4)
addLabel(p, "KEYBIND WINDOW", 5)
addToggle(p, "Show Keybind Panel", false, function(v)
    S.KeybindPanel = v
    keybindPanel.Visible = v
end, 6, false)
addSeparator(p, 7)
addLabel(p, "SERVER", 8)
addButton(p, "Server Rejoin", function()
    showNotice("Server", "Reconnecting...", "info")
    task.wait(0.5)
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end, 9, Theme.Button)

-- ─── TAB: CONFIG ─────────────────────────────────────────────────────────────
p = tabPages["CONFIG"]
addLabel(p, "CONFIGURATION", 1)

local CONFIG_FILE = "SOUHUB_config.json"

addButton(p, "Save Config", function()
    if not writefile then showNotice("Config", "Executor desteklemiyor", "error"); return end
    local data = {
        Smoothness    = S.Smoothness,
        Prediction    = S.Prediction,
        FOVRadius     = S.FOVRadius,
        KillAuraRange = S.KillAuraRange,
        WalkSpeed     = S.WalkSpeed,
        JumpPower     = S.JumpPower,
        FlySpeed      = S.FlySpeed,
        Version       = "3.1",
    }
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(data))
        showNotice("Config Saved", "Ayarlar kaydedildi", "success")
    end)
end, 2, Theme.Button)

addButton(p, "Load Config", function()
    if not readfile or not isfile then showNotice("Config", "Executor desteklemiyor", "error"); return end
    local ok, exists = pcall(isfile, CONFIG_FILE)
    if not ok or not exists then showNotice("Config", "Kayit bulunamadi", "warning"); return end
    pcall(function()
        local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if data.Smoothness    then S.Smoothness    = data.Smoothness    end
        if data.Prediction    then S.Prediction    = data.Prediction    end
        if data.FOVRadius     then S.FOVRadius     = data.FOVRadius     end
        if data.KillAuraRange then S.KillAuraRange = data.KillAuraRange end
        if data.WalkSpeed     then S.WalkSpeed     = data.WalkSpeed     end
        if data.JumpPower     then S.JumpPower     = data.JumpPower     end
        if data.FlySpeed      then S.FlySpeed      = data.FlySpeed      end
        showNotice("Config Loaded", "Ayarlar yuklendi", "success")
    end)
end, 3, Theme.Button)

-- ─── TAB: COLORS ─────────────────────────────────────────────────────────────
p = tabPages["COLORS"]
addLabel(p, "PRIMARY COLOR", 1)

local colorRGB = {
    r = math.round(Theme.Primary.R * 255),
    g = math.round(Theme.Primary.G * 255),
    b = math.round(Theme.Primary.B * 255),
}

local function applyThemeColor()
    Theme.Primary = Color3.fromRGB(colorRGB.r, colorRGB.g, colorRGB.b)
    mainStroke.Color = Theme.Primary
    for _, pg in pairs(tabPages) do pg.ScrollBarImageColor3 = Theme.Primary end
    SideScroll.ScrollBarImageColor3 = Theme.Primary
end

addSlider(p, "Red",   0, 255, colorRGB.r, function(v) colorRGB.r = math.round(v); applyThemeColor() end, 2)
addSlider(p, "Green", 0, 255, colorRGB.g, function(v) colorRGB.g = math.round(v); applyThemeColor() end, 3)
addSlider(p, "Blue",  0, 255, colorRGB.b, function(v) colorRGB.b = math.round(v); applyThemeColor() end, 4)

-- ─── KEYBIND PANEL ───────────────────────────────────────────────────────────
local keybindPanel = Instance.new("Frame")
keybindPanel.Name                = "KeybindPanel"
keybindPanel.Size                = UDim2.new(0, 200, 0, 30)
keybindPanel.Position            = UDim2.new(0, 15, 1, -15)
keybindPanel.AnchorPoint         = Vector2.new(0, 1)
keybindPanel.BackgroundColor3    = Theme.Panel
keybindPanel.BackgroundTransparency = 0.1
keybindPanel.BorderSizePixel     = 0
keybindPanel.ClipsDescendants    = true
keybindPanel.ZIndex              = 550
keybindPanel.Visible             = false
keybindPanel.Parent              = ScreenGui
Instance.new("UICorner", keybindPanel).CornerRadius = UDim.new(0, 6)

local kpHeader = Instance.new("Frame", keybindPanel)
kpHeader.Size             = UDim2.new(1, 0, 0, 26)
kpHeader.BackgroundColor3 = Theme.Button
kpHeader.BackgroundTransparency = 0.3
kpHeader.BorderSizePixel  = 0
kpHeader.ZIndex           = 551
Instance.new("UICorner", kpHeader).CornerRadius = UDim.new(0, 6)

local kpTitle = Instance.new("TextLabel", kpHeader)
kpTitle.Size             = UDim2.new(1, -30, 1, 0)
kpTitle.Position         = UDim2.new(0, 10, 0, 0)
kpTitle.BackgroundTransparency = 1
kpTitle.Text             = "KEYBINDS"
kpTitle.TextColor3       = Theme.Text
kpTitle.TextSize         = 10
kpTitle.Font             = Enum.Font.GothamBold
kpTitle.TextXAlignment   = Enum.TextXAlignment.Left
kpTitle.ZIndex           = 552

local kpClose = Instance.new("TextButton", kpHeader)
kpClose.Size             = UDim2.new(0, 20, 0, 20)
kpClose.Position         = UDim2.new(1, -24, 0, 3)
kpClose.BackgroundTransparency = 1
kpClose.Text             = "x"
kpClose.TextColor3       = Theme.SubText
kpClose.TextSize         = 16
kpClose.Font             = Enum.Font.GothamBold
kpClose.AutoButtonColor  = false
kpClose.ZIndex           = 552
kpClose.MouseButton1Click:Connect(function() keybindPanel.Visible = false end)

local kpScroll = Instance.new("ScrollingFrame", keybindPanel)
kpScroll.Size                  = UDim2.new(1, -8, 1, -32)
kpScroll.Position              = UDim2.new(0, 4, 0, 30)
kpScroll.BackgroundTransparency = 1
kpScroll.BorderSizePixel       = 0
kpScroll.ScrollBarThickness    = 2
kpScroll.ScrollBarImageColor3  = Theme.Primary
kpScroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
kpScroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
kpScroll.ZIndex                = 552
Instance.new("UIListLayout", kpScroll).Padding = UDim.new(0, 2)

makeDraggable(keybindPanel, kpHeader)

local function refreshKeybindPanel()
    for _, child in ipairs(kpScroll:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
    local count = 0
    for kc, entry in pairs(keybindMap) do
        count = count + 1
        local lbl = Instance.new("TextLabel", kpScroll)
        lbl.Size             = UDim2.new(1, -4, 0, 22)
        lbl.BackgroundColor3 = Theme.Button
        lbl.BackgroundTransparency = 0.4
        lbl.BorderSizePixel  = 0
        lbl.Text             = "  " .. kc.Name .. "  ->  " .. entry.name
        lbl.TextColor3       = Theme.Text
        lbl.TextSize         = 10
        lbl.Font             = Enum.Font.Code
        lbl.TextXAlignment   = Enum.TextXAlignment.Left
        lbl.TextTruncate     = Enum.TextTruncate.AtEnd
        lbl.LayoutOrder      = count
        lbl.ZIndex           = 553
        Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 3)
    end
    if count == 0 then
        local e = Instance.new("TextLabel", kpScroll)
        e.Size             = UDim2.new(1, -4, 0, 22)
        e.BackgroundTransparency = 1
        e.Text             = "  No keybinds set"
        e.TextColor3       = Theme.SubText
        e.TextSize         = 10
        e.Font             = Enum.Font.Gotham
        e.LayoutOrder      = 1
        e.ZIndex           = 553
    end
    keybindPanel.Size = UDim2.new(0, 200, 0, math.min(30 + count * 24 + 8, 250))
end

-- ─── FOV CIRCLE ──────────────────────────────────────────────────────────────
local fovFrame = Instance.new("Frame", ScreenGui)
fovFrame.Name               = "FOVCircle"
fovFrame.Size               = UDim2.new(0, 300, 0, 300)
fovFrame.BackgroundTransparency = 1
fovFrame.ZIndex             = 999

local fovCircle = Instance.new("Frame", fovFrame)
fovCircle.Size              = UDim2.new(1, 0, 1, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.ZIndex            = 1000
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
local fovStroke = Instance.new("UIStroke", fovCircle)
fovStroke.Color       = Color3.fromRGB(255, 255, 255)
fovStroke.Thickness   = 1.5
fovStroke.Transparency = 0.2

-- ─── FPS DISPLAY ─────────────────────────────────────────────────────────────
local fpsFrame = Instance.new("Frame", ScreenGui)
fpsFrame.Size             = UDim2.new(0, 110, 0, 20)
fpsFrame.Position         = UDim2.new(0, 15, 0, 15)
fpsFrame.BackgroundColor3 = Theme.Panel
fpsFrame.BackgroundTransparency = 0.4
fpsFrame.ZIndex           = 500
Instance.new("UICorner", fpsFrame).CornerRadius = UDim.new(0, 4)

local fpsText = Instance.new("TextLabel", fpsFrame)
fpsText.Size             = UDim2.new(1, 0, 1, 0)
fpsText.BackgroundTransparency = 1
fpsText.Text             = "60 FPS | 0 MS"
fpsText.TextColor3       = Theme.SubText
fpsText.TextSize         = 9
fpsText.Font             = Enum.Font.Code
fpsText.ZIndex           = 501

-- ─── ESP (Drawing-based) ─────────────────────────────────────────────────────
local hasDrawing = false
pcall(function()
    local t = Drawing.new("Line"); t:Remove(); hasDrawing = true
end)

local espObjects = {}

local function createESPObjects(playerName)
    if not hasDrawing then return end
    local function newLine()
        local l = Drawing.new("Line"); l.Thickness = 1
        l.Color = Color3.fromRGB(255,255,255); l.Visible = false; return l
    end
    local function newText(size)
        local t = Drawing.new("Text"); t.Size = size or 13; t.Center = true
        t.Outline = true; t.OutlineColor = Color3.fromRGB(0,0,0)
        t.Font = 2; t.Visible = false; return t
    end
    espObjects[playerName] = {
        boxTop = newLine(), boxBottom = newLine(),
        boxLeft = newLine(), boxRight = newLine(),
        name = newText(13), health = newText(11), distance = newText(11),
    }
end

function removeESPObjects(playerName)
    local obj = espObjects[playerName]
    if not obj then return end
    for _, v in pairs(obj) do pcall(function() v:Remove() end) end
    espObjects[playerName] = nil
end

local function hideESPObjects(playerName)
    local obj = espObjects[playerName]
    if not obj then return end
    for _, v in pairs(obj) do pcall(function() v.Visible = false end) end
end

local function updateESP()
    if not hasDrawing then return end

    for name, _ in pairs(espObjects) do
        if not Players:FindFirstChild(name) then removeESPObjects(name) end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        local shouldShow = S.ESPEnabled
        if S.ESPMode == "Selected" then
            shouldShow = shouldShow and (S.SelectedPlayers[player.Name] ~= nil)
        end

        if not shouldShow or not player.Character then
            hideESPObjects(player.Name); continue
        end

        local char = player.Character
        local hum  = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")

        if not hum or hum.Health <= 0 or not root then
            hideESPObjects(player.Name); continue
        end

        if not espObjects[player.Name] then createESPObjects(player.Name) end

        local obj     = espObjects[player.Name]
        local headPos = head and head.Position or (root.Position + Vector3.new(0, 2, 0))
        local sp, onScreen = Camera:WorldToViewportPoint(headPos)
        local topSP  = Camera:WorldToViewportPoint(headPos + Vector3.new(0, 1, 0))
        local botSP  = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
        local lSP    = Camera:WorldToViewportPoint(root.Position + Vector3.new(-1, 1, 0))
        local rSP    = Camera:WorldToViewportPoint(root.Position + Vector3.new(1, 1, 0))
        local dist   = math.floor((Camera.CFrame.Position - root.Position).Magnitude)

        if not onScreen or dist >= 300 then hideESPObjects(player.Name); continue end

        local cx   = (lSP.X + rSP.X) / 2
        local half = math.abs(rSP.X - lSP.X) / 2
        local topY = topSP.Y
        local botY = botSP.Y

        obj.boxTop.From    = Vector2.new(cx-half, topY); obj.boxTop.To    = Vector2.new(cx+half, topY); obj.boxTop.Visible    = true
        obj.boxBottom.From = Vector2.new(cx-half, botY); obj.boxBottom.To = Vector2.new(cx+half, botY); obj.boxBottom.Visible = true
        obj.boxLeft.From   = Vector2.new(cx-half, topY); obj.boxLeft.To   = Vector2.new(cx-half, botY); obj.boxLeft.Visible   = true
        obj.boxRight.From  = Vector2.new(cx+half, topY); obj.boxRight.To  = Vector2.new(cx+half, botY); obj.boxRight.Visible  = true

        local hp   = math.floor((hum.Health / math.max(hum.MaxHealth, 1)) * 100)
        local yOff = topY - 20

        if S.ESPNames then
            obj.name.Text = player.DisplayName; obj.name.Position = Vector2.new(cx, yOff)
            obj.name.Color = Color3.fromRGB(255,255,255); obj.name.Visible = true; yOff = yOff - 14
        else obj.name.Visible = false end

        if S.ESPHealth then
            local hr = math.clamp(1 - hp / 100, 0, 1)
            obj.health.Text = hp .. "%"; obj.health.Position = Vector2.new(cx, yOff)
            obj.health.Color = Color3.fromRGB(255*hr, 255*(1-hr), 0); obj.health.Visible = true; yOff = yOff - 13
        else obj.health.Visible = false end

        if S.ESPDistance then
            obj.distance.Text = dist .. "m"; obj.distance.Position = Vector2.new(cx, yOff)
            obj.distance.Color = Color3.fromRGB(200,200,200); obj.distance.Visible = true
        else obj.distance.Visible = false end
    end
end

-- ─── GAMEPLAY UTILS ──────────────────────────────────────────────────────────
local function isVisible(part)
    if not S.WallCheck then return true end
    if not part or not part.Parent then return false end
    local origin = Camera.CFrame.Position
    local dir    = part.Position - origin
    local rp     = RaycastParams.new()
    rp.FilterType                 = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    rp.IgnoreWater                = true
    local hit = workspace:Raycast(origin, dir, rp)
    if not hit then return true end
    local targetChar = part:FindFirstAncestorOfClass("Model")
    return targetChar and hit.Instance:IsDescendantOf(targetChar)
end

local function isDowned(char)
    if not char then return false end
    local fx = char:FindFirstChild("BodyEffects")
    if fx then
        local ko = fx:FindFirstChild("K.O")
        if ko and ko.Value then return true end
    end
    return char:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
end

local function predictedPos(part)
    if not part then return Vector3.new() end
    local pred = S.Prediction
    if pred <= 0 then return part.Position end
    local vel = Vector3.new()
    pcall(function() vel = part.AssemblyLinearVelocity end)
    local ping = 0
    pcall(function() ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000 end)
    return part.Position + vel * (pred * 0.3 + ping * 0.5)
end

-- FIX: StickyAim now actually works in getClosest
local function getClosest()
    local list
    if S.LockMode == "Selected" then
        list = {}
        for _, plr in pairs(S.SelectedPlayers) do
            if plr and plr.Parent then list[#list + 1] = plr end
        end
        if #list == 0 then return nil end
    else
        list = Players:GetPlayers()
    end

    local shortest = math.huge
    local best     = nil
    local cx       = Camera.ViewportSize.X / 2
    local cy       = Camera.ViewportSize.Y / 2
    local fov      = S.FOVRadius

    for _, plr in ipairs(list) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then continue end
        local part = char:FindFirstChild(S.TargetPart)
        if not part then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        if S.SkipDowned and isDowned(char) then continue end
        local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end
        local d = math.sqrt((sp.X - cx)^2 + (sp.Y - cy)^2)
        -- FIX: StickyAim bypasses wall check
        if d < fov and d < shortest and (S.StickyAim or isVisible(part)) then
            shortest = d
            best     = plr
        end
    end
    return best
end

-- ─── SILENT AIM ──────────────────────────────────────────────────────────────
pcall(function()
    local _origIndex = hookmetamethod(game, "__index", function(t, k)
        if S.SilentAim and S.CurrentTarget and S.CurrentTarget.Character then
            local part = S.CurrentTarget.Character:FindFirstChild(S.SilentPart)
                      or S.CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
            if part and t:IsA("Mouse") then
                if k == "Hit"    then return part.CFrame end
                if k == "Target" then return part end
            end
        end
        return _origIndex(t, k)
    end)
end)

-- ─── INPUT ───────────────────────────────────────────────────────────────────
local locked   = false
local menuOpen = false

UserInputService.InputBegan:Connect(function(input, gpe)
    -- keybind assignment
    if pendingKbBtn and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Unknown then
            pendingKbBtn.Text      = "[none]"
            pendingKbBtn.TextColor3 = Theme.SubText
            pendingKbBtn = nil
        else
            keybindMap[input.KeyCode] = nil
            local toggleFn = pendingKbBtn._toggle
            local name     = pendingKbBtn._name
            keybindMap[input.KeyCode] = {callback = toggleFn, name = name, btn = pendingKbBtn}
            pendingKbBtn.Text      = "[" .. input.KeyCode.Name .. "]"
            pendingKbBtn.TextColor3 = Theme.Text
            pendingKbBtn = nil
            refreshKeybindPanel()
        end
        return
    end

    -- fire keybinds (works even in-game)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local entry = keybindMap[input.KeyCode]
        if entry then entry.callback() end
    end

    -- aimbot activation
    if S.AimbotEnabled then
        if S.Mode == "RightMouseClick" and input.UserInputType == Enum.UserInputType.MouseButton2 then
            S.CurrentTarget = getClosest()
            locked = S.CurrentTarget ~= nil
        elseif S.Mode == "ToggleQ" and input.KeyCode == Enum.KeyCode.Q and not gpe then
            if locked then
                locked = false; S.CurrentTarget = nil
            else
                S.CurrentTarget = getClosest(); locked = S.CurrentTarget ~= nil
            end
        end
    end

    -- menu toggle
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end

    -- infinite jump
    if input.KeyCode == Enum.KeyCode.Space and S.InfJump and not gpe then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end

    -- panic key
    if input.KeyCode == Enum.KeyCode.End then
        MainFrame.Visible    = false
        keybindPanel.Visible = false
        fpsFrame.Visible     = false
        fovFrame.Visible     = false
        locked               = false
        S.CurrentTarget      = nil
        S.AimbotEnabled      = false
        S.KillAura           = false
        S.Spinbot            = false
        S.AutoAttack         = false
        showNotice("PANIC", "All features disabled", "error")
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if S.Mode == "RightMouseClick" and input.UserInputType == Enum.UserInputType.MouseButton2 then
        -- FIX: AlwaysOn ise birakma
        if not S.AlwaysOn then
            locked = false; S.CurrentTarget = nil
        end
    end
end)

-- ─── NOCLIP ──────────────────────────────────────────────────────────────────
RunService.Stepped:Connect(function()
    if not S.Noclip then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
end)

-- ─── FLY (LinearVelocity) ────────────────────────────────────────────────────
local flyAttachment = nil
local flyLV        = nil

local function cleanFly()
    if flyAttachment then pcall(function() flyAttachment:Destroy() end); flyAttachment = nil end
    if flyLV         then pcall(function() flyLV:Destroy() end);         flyLV = nil end
end

-- FIX: Fly checks menuOpen
RunService.RenderStepped:Connect(function()
    if menuOpen then cleanFly(); return end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not S.Fly or not root then
        cleanFly(); return
    end

    if not flyLV or flyLV.Parent ~= root then
        cleanFly()
        flyAttachment = Instance.new("Attachment", root)
        flyLV = Instance.new("LinearVelocity", root)
        flyLV.Attachment0       = flyAttachment
        flyLV.MaxForce          = math.huge
        flyLV.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        flyLV.VectorVelocity    = Vector3.new()
    end

    local dir = Vector3.new()
    local UIS = UserInputService
    if UIS:IsKeyDown(Enum.KeyCode.W)     then dir = dir + Camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S)     then dir = dir - Camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A)     then dir = dir - Camera.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D)     then dir = dir + Camera.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
    if dir.Magnitude > 0 then dir = dir.Unit end
    flyLV.VectorVelocity = dir * S.FlySpeed
end)

-- ─── MAIN HEARTBEAT: local mods, rage ────────────────────────────────────────
local lastAuraTime = 0
local lastAATime   = 0
local orbitAngle   = 0

RunService.Heartbeat:Connect(function(dt)
    local char = LocalPlayer.Character
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if hum then
        -- FIX: Speed hack with velocity boost for Da Hood
        if S.SpeedHack then
            hum.WalkSpeed = S.WalkSpeed
            if root and S.WalkSpeed > 16 then
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    root.Velocity = Vector3.new(
                        moveDir.X * S.WalkSpeed,
                        root.Velocity.Y,
                        moveDir.Z * S.WalkSpeed
                    )
                end
            end
        end

        if S.JumpHack then
            hum.UseJumpPower = true
            hum.JumpPower    = S.JumpPower
        end

        if S.InfJump and hum:GetState() == Enum.HumanoidStateType.Freefall then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end

    if not root then return end
    local now = tick()

    -- spinbot
    if S.Spinbot then
        local best, bestDist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            local c = plr.Character
            if not c then continue end
            local r = c:FindFirstChild("HumanoidRootPart")
            local h = c:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 then
                local d = (root.Position - r.Position).Magnitude
                if d < S.KillAuraRange and d < bestDist then
                    bestDist = d; best = plr
                end
            end
        end
        if best and best.Character then
            local tr = best.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                orbitAngle = orbitAngle + math.rad(S.SpinbotSpeed) * dt * 60
                local offset = Vector3.new(math.cos(orbitAngle), 0, math.sin(orbitAngle)) * S.SpinbotRadius
                root.CFrame = root.CFrame:Lerp(CFrame.new(tr.Position + offset, tr.Position), 0.3)
            end
        end
    end

    -- kill aura
    if S.KillAura and (now - lastAuraTime) >= S.KillAuraDelay then
        lastAuraTime = now
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr == LocalPlayer then continue end
                local c = plr.Character
                if not c then continue end
                local r = c:FindFirstChild("HumanoidRootPart")
                local h = c:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 then
                    if (root.Position - r.Position).Magnitude < S.KillAuraRange then
                        pcall(function() tool:Activate() end)
                    end
                end
            end
        end
    end

    -- auto attack
    if S.AutoAttack and (now - lastAATime) >= 0.15 then
        lastAATime = now
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            local best2, bestDist2 = nil, S.AutoAttackRange
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr == LocalPlayer then continue end
                local c = plr.Character
                if not c then continue end
                local r = c:FindFirstChild("HumanoidRootPart")
                local h = c:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 then
                    local d = (root.Position - r.Position).Magnitude
                    if d < bestDist2 then bestDist2 = d; best2 = plr end
                end
            end
            if best2 then pcall(function() tool:Activate() end) end
        end
    end
end)

-- ─── MAIN RENDER: aimbot, trigger, FOV, FPS ──────────────────────────────────
local fpsCount = 0
local fpsLast  = tick()

RunService.RenderStepped:Connect(function(dt)
    if menuOpen then return end

    -- ESP
    updateESP()

    -- FOV circle
    fovFrame.Visible = S.FOVVisible
    if S.FOVVisible then
        local r = S.FOVRadius
        fovFrame.Size     = UDim2.new(0, r * 2, 0, r * 2)
        fovFrame.Position = UDim2.new(0.5, -r, 0.5, -r)
    end

    -- FPS counter
    fpsCount = fpsCount + 1
    if tick() - fpsLast >= 1 then
        local fps  = fpsCount
        local ping = 0
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        local show = S.FPSDisplay or S.PingDisplay
        fpsFrame.Visible = show
        if show then
            fpsText.Text = (S.FPSDisplay and fps .. " FPS" or "")
                        .. (S.FPSDisplay and S.PingDisplay and " | " or "")
                        .. (S.PingDisplay and ping .. " MS" or "")
        end
        fpsCount = 0
        fpsLast  = tick()
    end

    -- aimbot
    if not S.AimbotEnabled then locked = false; S.CurrentTarget = nil end

    -- FIX: AlwaysOn — sadece hedef yoksa yeni hedef bul
    if S.AlwaysOn and S.AimbotEnabled then
        if not S.CurrentTarget or not S.CurrentTarget.Character then
            S.CurrentTarget = getClosest()
            locked = S.CurrentTarget ~= nil
        else
            -- hedef hala yasiyorsa devam et
            local h = S.CurrentTarget.Character:FindFirstChildOfClass("Humanoid")
            if not h or h.Health <= 0 then
                S.CurrentTarget = getClosest()
                locked = S.CurrentTarget ~= nil
            end
        end
    end

    -- FIX: NearestCursor sadece sag tik basili iken calisir
    if S.Mode == "NearestCursor" and S.AimbotEnabled then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            S.CurrentTarget = getClosest()
            locked = S.CurrentTarget ~= nil
        else
            if not S.AlwaysOn then
                locked = false; S.CurrentTarget = nil
            end
        end
    end

    if locked and S.CurrentTarget and S.CurrentTarget.Character then
        local part = S.CurrentTarget.Character:FindFirstChild(S.TargetPart)
                  or S.CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
        if part then
            local h = S.CurrentTarget.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then
                if S.SkipDowned and isDowned(S.CurrentTarget.Character) then
                    if S.AutoSwitch then S.CurrentTarget = getClosest(); locked = S.CurrentTarget ~= nil
                    else locked = false; S.CurrentTarget = nil end
                -- FIX: StickyAim bypasses wall check during lock
                elseif not S.StickyAim and not isVisible(part) then
                    if S.AutoSwitch then S.CurrentTarget = getClosest(); locked = S.CurrentTarget ~= nil
                    else locked = false; S.CurrentTarget = nil end
                else
                    local target = CFrame.new(Camera.CFrame.Position, predictedPos(part))
                    Camera.CFrame = Camera.CFrame:Lerp(target, S.Smoothness)
                end
            else
                if S.AutoSwitch then S.CurrentTarget = getClosest(); locked = S.CurrentTarget ~= nil
                else locked = false; S.CurrentTarget = nil end
            end
        end
    end

    -- trigger bot
    if S.TriggerBot then
        local tgt = S.CurrentTarget or getClosest()
        if tgt and tgt.Character then
            local part = tgt.Character:FindFirstChild(S.TargetPart)
            if part then
                local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local cx = Camera.ViewportSize.X / 2
                    local cy = Camera.ViewportSize.Y / 2
                    local d  = math.sqrt((sp.X - cx)^2 + (sp.Y - cy)^2)
                    if d < S.TriggerRange then
                        local char = LocalPlayer.Character
                        if char then
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then pcall(function() tool:Activate() end) end
                        end
                    end
                end
            end
        end
    end
end)

-- ─── MENU / IDLE ─────────────────────────────────────────────────────────────
pcall(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:CaptureController(); vu:ClickButton2(Vector2.new())
    end)
end)

-- FIX: ESC menu — save/restore MainFrame visibility
local guiWasVisible = false

pcall(function()
    GuiService.MenuOpened:Connect(function()
        menuOpen         = true
        guiWasVisible    = MainFrame.Visible
        MainFrame.Visible = false
        keybindPanel.Visible = false
        fpsFrame.Visible     = false
        fovFrame.Visible     = false
        -- ESPyi gizle
        for name, _ in pairs(espObjects) do hideESPObjects(name) end
    end)
    GuiService.MenuClosed:Connect(function()
        menuOpen          = false
        MainFrame.Visible = guiWasVisible  -- FIX: onceki duruma don
        fpsFrame.Visible  = S.FPSDisplay or S.PingDisplay
        if S.KeybindPanel then keybindPanel.Visible = true end
    end)
end)

-- ─── BOOT ────────────────────────────────────────────────────────────────────
print("[SOU HUB] Rage Edition v3.1 yuklendi!")
print("[SOU HUB] Right Shift = menu ac/kapa | End = panic")

MainFrame.Visible = true

task.spawn(function()
    task.wait(0.5)
    showNotice("SOU HUB", "Rage Edition v3.1 hazir!", "success")
    showNotice("Interface", "Right Shift = toggle menu | End = panic", "info")
end)
