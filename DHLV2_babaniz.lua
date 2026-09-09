--[[
    DHL V2 - by babaniz
    Camlock + Highlight ESP + Multi-Select + FOV Circle
    Executor uyumlu (Realius, Solara, Fluxus, vb.)
]]

print("[DHL V2] Script yukleniyor...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- =============================================
-- GUI PARENT
-- =============================================
local function getGuiParent()
    if gethui then
        return gethui()
    end
    if syn and syn.protect_gui then
        local sg = Instance.new("ScreenGui")
        syn.protect_gui(sg)
        sg.Parent = game:GetService("CoreGui")
        return sg
    end
    local ok, _ = pcall(function()
        local test = Instance.new("ScreenGui")
        test.Parent = game:GetService("CoreGui")
        test:Destroy()
    end)
    if ok then
        return game:GetService("CoreGui")
    end
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
    SelectedPlayers = {},
    CurrentTarget = nil,
    Locked = false,
    Mode = "RightMouseClick",
    FOVVisible = true,
    FOVRadius = 150,
    ESPEnabled = true,
}

-- =============================================
-- ESKI GUI TEMIZLE
-- =============================================
pcall(function()
    local old = game:GetService("CoreGui"):FindFirstChild("DHLV2_babaniz")
    if old then old:Destroy() end
end)
pcall(function()
    if gethui then
        local old = gethui():FindFirstChild("DHLV2_babaniz")
        if old then old:Destroy() end
    end
end)
pcall(function()
    local old = LocalPlayer.PlayerGui:FindFirstChild("DHLV2_babaniz")
    if old then old:Destroy() end
end)

-- Eski highlight temizle
for _, plr in ipairs(Players:GetPlayers()) do
    if plr.Character then
        local oldHL = plr.Character:FindFirstChild("DHL_Highlight")
        if oldHL then oldHL:Destroy() end
    end
end

-- =============================================
-- GUI OLUSTUR
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
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- =============================================
-- MAIN FRAME
-- =============================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 480)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = false -- oyun inputunu bloke etmesin
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(139, 0, 0)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Drag handle â€” sadece ust kisim (title alani) suruklenebilir
local DragHandle = Instance.new("TextButton")
DragHandle.Name = "DragHandle"
DragHandle.Size = UDim2.new(1, 0, 0, 58)
DragHandle.Position = UDim2.new(0, 0, 0, 0)
DragHandle.BackgroundTransparency = 1
DragHandle.Text = ""
DragHandle.AutoButtonColor = false
DragHandle.ZIndex = 10
DragHandle.Parent = MainFrame

makeDraggable(MainFrame, DragHandle)

-- =============================================
-- BACKGROUND IMAGE
-- =============================================
local BgImage = Instance.new("ImageLabel")
BgImage.Name = "Background"
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Position = UDim2.new(0, 0, 0, 0)
BgImage.BackgroundTransparency = 1
BgImage.ImageTransparency = 0.82
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ZIndex = 0
BgImage.ClipsDescendants = true
BgImage.Parent = MainFrame

local BgCorner = Instance.new("UICorner")
BgCorner.CornerRadius = UDim.new(0, 8)
BgCorner.Parent = BgImage

-- Resmi GitHub'dan indir ve yukle
pcall(function()
    local imageUrl = "https://raw.githubusercontent.com/whycroxin-svg/DHL/main/bg.png"
    local fileName = "DHLV2_bg.png"

    if writefile and isfile and getcustomasset then
        if not isfile(fileName) then
            local imgData = game:HttpGet(imageUrl)
            writefile(fileName, imgData)
            print("[DHL V2] Arka plan resmi indirildi")
        end
        BgImage.Image = getcustomasset(fileName)
        print("[DHL V2] Arka plan resmi yuklendi")
    else
        print("[DHL V2] getcustomasset desteklenmiyor, arka plan yuklenemedi")
    end
end)

-- Tum elementlerin ZIndex'ini yukselt (arka planin ustunde gorunsun)
task.defer(function()
    task.wait(0.2)
    for _, child in ipairs(MainFrame:GetDescendants()) do
        if child:IsA("GuiObject") and child ~= BgImage and child.ZIndex < 2 then
            child.ZIndex = 2
        end
    end
end)

-- =============================================
-- TITLE
-- =============================================
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 8)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "DHL V2"
TitleLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
TitleLabel.TextSize = 22
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Size = UDim2.new(1, 0, 0, 18)
CreditLabel.Position = UDim2.new(0, 0, 0, 35)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "By babaniz"
CreditLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
CreditLabel.TextSize = 14
CreditLabel.Font = Enum.Font.GothamSemibold
CreditLabel.Parent = MainFrame

local Sep = Instance.new("Frame")
Sep.Size = UDim2.new(0.9, 0, 0, 1)
Sep.Position = UDim2.new(0.05, 0, 0, 58)
Sep.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
Sep.BorderSizePixel = 0
Sep.Parent = MainFrame

local SelectCountLabel = Instance.new("TextLabel")
SelectCountLabel.Size = UDim2.new(0, 220, 0, 16)
SelectCountLabel.Position = UDim2.new(0, 15, 0, 60)
SelectCountLabel.BackgroundTransparency = 1
SelectCountLabel.Text = "Selected: 0"
SelectCountLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
SelectCountLabel.TextSize = 11
SelectCountLabel.Font = Enum.Font.GothamSemibold
SelectCountLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectCountLabel.Parent = MainFrame

-- =============================================
-- LEFT PANEL â€” PLAYER LIST
-- =============================================
local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0, 220, 0, 390)
LeftPanel.Position = UDim2.new(0, 15, 0, 78)
LeftPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LeftPanel.BackgroundTransparency = 0.3
LeftPanel.BorderSizePixel = 0
LeftPanel.Active = true
LeftPanel.Parent = MainFrame

local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 6)
LeftCorner.Parent = LeftPanel

local LeftStroke = Instance.new("UIStroke")
LeftStroke.Color = Color3.fromRGB(80, 0, 0)
LeftStroke.Thickness = 1
LeftStroke.Parent = LeftPanel

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -16, 0, 28)
SearchBox.Position = UDim2.new(0, 8, 0, 8)
SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "Search Players..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
SearchBox.TextSize = 13
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = LeftPanel

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 4)
SearchCorner.Parent = SearchBox

local SelectAllBtn = Instance.new("TextButton")
SelectAllBtn.Size = UDim2.new(0.48, 0, 0, 22)
SelectAllBtn.Position = UDim2.new(0, 8, 0, 40)
SelectAllBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
SelectAllBtn.BorderSizePixel = 0
SelectAllBtn.Text = "Select All"
SelectAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectAllBtn.TextSize = 11
SelectAllBtn.Font = Enum.Font.GothamBold
SelectAllBtn.AutoButtonColor = false
SelectAllBtn.Parent = LeftPanel

local SelectAllCorner = Instance.new("UICorner")
SelectAllCorner.CornerRadius = UDim.new(0, 4)
SelectAllCorner.Parent = SelectAllBtn

local ClearAllBtn = Instance.new("TextButton")
ClearAllBtn.Size = UDim2.new(0.48, 0, 0, 22)
ClearAllBtn.Position = UDim2.new(0.5, 2, 0, 40)
ClearAllBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
ClearAllBtn.BorderSizePixel = 0
ClearAllBtn.Text = "Clear"
ClearAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearAllBtn.TextSize = 11
ClearAllBtn.Font = Enum.Font.GothamBold
ClearAllBtn.AutoButtonColor = false
ClearAllBtn.Parent = LeftPanel

local ClearAllCorner = Instance.new("UICorner")
ClearAllCorner.CornerRadius = UDim.new(0, 4)
ClearAllCorner.Parent = ClearAllBtn

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, -16, 1, -72)
PlayerScroll.Position = UDim2.new(0, 8, 0, 66)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.BorderSizePixel = 0
PlayerScroll.ScrollBarThickness = 4
PlayerScroll.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerScroll.Parent = LeftPanel

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 4)
PlayerListLayout.Parent = PlayerScroll

-- =============================================
-- RIGHT PANEL â€” CONTROLS
-- =============================================
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(0, 255, 0, 390)
RightPanel.Position = UDim2.new(0, 248, 0, 78)
RightPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
RightPanel.BackgroundTransparency = 0.3
RightPanel.BorderSizePixel = 0
RightPanel.Active = true
RightPanel.Parent = MainFrame

local RightCorner = Instance.new("UICorner")
RightCorner.CornerRadius = UDim.new(0, 6)
RightCorner.Parent = RightPanel

local RightStroke = Instance.new("UIStroke")
RightStroke.Color = Color3.fromRGB(80, 0, 0)
RightStroke.Thickness = 1
RightStroke.Parent = RightPanel

-- Toggle helper
local function createToggleButton(name, default, posY, parent)
    local btn = Instance.new("TextButton")
    btn.Name = name:gsub(" ", "")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = default and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(60, 60, 60)
    btn.BorderSizePixel = 0
    btn.Text = name .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = parent

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(60, 60, 60)
    end)

    return btn, function() return state end
end

-- Slider helper
local function createSlider(name, min, max, default, posY, parent)
    local container = Instance.new("Frame")
    container.Name = name:gsub(" ", "") .. "Container"
    container.Size = UDim2.new(1, -20, 0, 40)
    container.Position = UDim2.new(0, 10, 0, posY)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 16)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. string.format("%.3f", default)
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 12
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Parent = container

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, 0, 0, 10)
    sliderBg.Position = UDim2.new(0, 0, 0, 20)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.AutoButtonColor = false
    sliderBg.Parent = container

    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 4)
    sliderBgCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    knob.BorderSizePixel = 0
    knob.ZIndex = 5
    knob.Parent = sliderBg

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local value = default
    local sliding = false

    local function update(inputPos)
        local absPos = sliderBg.AbsolutePosition.X
        local absSize = sliderBg.AbsoluteSize.X
        if absSize == 0 then return end
        local pos = math.clamp((inputPos - absPos) / absSize, 0, 1)
        value = min + (max - min) * pos
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, 0, 0.5, 0)
        label.Text = name .. ": " .. string.format("%.3f", value)
    end

    sliderBg.MouseButton1Down:Connect(function(x)
        sliding = true
        update(x)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)

    return function() return value end
end

-- =============================================
-- BUILD CONTROLS
-- =============================================
local _, getCamlock = createToggleButton("Camlock System", Settings.CamlockEnabled, 8, RightPanel)
local _, getWallCheck = createToggleButton("Wall Check", Settings.WallCheck, 42, RightPanel)

-- Mode
local ModeBtn = Instance.new("TextButton")
ModeBtn.Size = UDim2.new(1, -20, 0, 30)
ModeBtn.Position = UDim2.new(0, 10, 0, 76)
ModeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ModeBtn.BorderSizePixel = 0
ModeBtn.Text = "Mode: Right Mouse Click"
ModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeBtn.TextSize = 12
ModeBtn.Font = Enum.Font.GothamBold
ModeBtn.AutoButtonColor = false
ModeBtn.Parent = RightPanel

local ModeBtnCorner = Instance.new("UICorner")
ModeBtnCorner.CornerRadius = UDim.new(0, 6)
ModeBtnCorner.Parent = ModeBtn

local ModeBtnStroke = Instance.new("UIStroke")
ModeBtnStroke.Color = Color3.fromRGB(100, 0, 0)
ModeBtnStroke.Thickness = 1
ModeBtnStroke.Parent = ModeBtn

local modes = {"Right Mouse Click", "Nearest Cursor", "Toggle Q"}
local currentModeIdx = 1

ModeBtn.MouseButton1Click:Connect(function()
    currentModeIdx = currentModeIdx % #modes + 1
    Settings.Mode = modes[currentModeIdx]:gsub(" ", "")
    ModeBtn.Text = "Mode: " .. modes[currentModeIdx]
end)

-- Sliders
local getSmoothness = createSlider("Smoothness", 0.01, 1.0, Settings.Smoothness, 110, RightPanel)
local getPrediction = createSlider("Prediction", 0.0, 1.0, Settings.Prediction, 155, RightPanel)

-- Target Part
local targetParts = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso"}
local currentTargetIdx = 1

local TargetBtn = Instance.new("TextButton")
TargetBtn.Size = UDim2.new(1, -20, 0, 30)
TargetBtn.Position = UDim2.new(0, 10, 0, 200)
TargetBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TargetBtn.BorderSizePixel = 0
TargetBtn.Text = "Target Part: " .. Settings.TargetPart
TargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBtn.TextSize = 12
TargetBtn.Font = Enum.Font.GothamBold
TargetBtn.AutoButtonColor = false
TargetBtn.Parent = RightPanel

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(0, 6)
TargetCorner.Parent = TargetBtn

local TargetStroke = Instance.new("UIStroke")
TargetStroke.Color = Color3.fromRGB(100, 0, 0)
TargetStroke.Thickness = 1
TargetStroke.Parent = TargetBtn

TargetBtn.MouseButton1Click:Connect(function()
    currentTargetIdx = currentTargetIdx % #targetParts + 1
    Settings.TargetPart = targetParts[currentTargetIdx]
    TargetBtn.Text = "Target Part: " .. Settings.TargetPart
end)

-- Separator
local Sep2 = Instance.new("Frame")
Sep2.Size = UDim2.new(1, -20, 0, 1)
Sep2.Position = UDim2.new(0, 10, 0, 238)
Sep2.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
Sep2.BorderSizePixel = 0
Sep2.Parent = RightPanel

-- FOV Circle
local _, getFOVVisible = createToggleButton("FOV Circle", Settings.FOVVisible, 245, RightPanel)
local getFOVRadius = createSlider("FOV Radius", 20, 500, Settings.FOVRadius, 279, RightPanel)

-- Separator
local Sep3 = Instance.new("Frame")
Sep3.Size = UDim2.new(1, -20, 0, 1)
Sep3.Position = UDim2.new(0, 10, 0, 324)
Sep3.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
Sep3.BorderSizePixel = 0
Sep3.Parent = RightPanel

-- ESP toggle
local _, getESP = createToggleButton("ESP Highlight", Settings.ESPEnabled, 331, RightPanel)

-- =============================================
-- FOV CIRCLE
-- =============================================
local fovCircle = nil
local usingDrawing = false

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

local fovCircleGui = nil
if not usingDrawing then
    fovCircleGui = Instance.new("Frame")
    fovCircleGui.Name = "FOVCircle"
    fovCircleGui.Size = UDim2.new(0, Settings.FOVRadius * 2, 0, Settings.FOVRadius * 2)
    fovCircleGui.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircleGui.BackgroundTransparency = 1
    fovCircleGui.BorderSizePixel = 0
    fovCircleGui.Parent = ScreenGui

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = fovCircleGui

    local circleStroke = Instance.new("UIStroke")
    circleStroke.Color = Color3.fromRGB(255, 0, 0)
    circleStroke.Thickness = 1.5
    circleStroke.Transparency = 0.2
    circleStroke.Parent = fovCircleGui
end

-- =============================================
-- HIGHLIGHT ESP â€” CYAN, TAMAMINI KAPLAR
-- =============================================
local highlightObjects = {} -- player.Name -> Highlight instance
local espDrawings = {} -- player.Name -> {name, tracer} Drawing objeleri

local function addHighlight(player)
    if not player or not player.Character then return end

    -- Highlight zaten varsa atla
    if highlightObjects[player.Name] then
        -- Character degismis olabilir, parent kontrol et
        if highlightObjects[player.Name].Parent ~= player.Character then
            highlightObjects[player.Name]:Destroy()
            highlightObjects[player.Name] = nil
        else
            return
        end
    end

    local hl = Instance.new("Highlight")
    hl.Name = "DHL_Highlight"
    hl.FillColor = Color3.fromRGB(0, 255, 255) -- CYAN
    hl.OutlineColor = Color3.fromRGB(0, 255, 255) -- CYAN outline
    hl.FillTransparency = 0.35
    hl.OutlineTransparency = 0
    hl.Adornee = player.Character
    hl.Parent = player.Character

    highlightObjects[player.Name] = hl

    -- Drawing name + tracer
    if usingDrawing and not espDrawings[player.Name] then
        local esp = {}

        esp.name = Drawing.new("Text")
        esp.name.Color = Color3.fromRGB(0, 255, 255)
        esp.name.Size = 14
        esp.name.Center = true
        esp.name.Outline = true
        esp.name.OutlineColor = Color3.fromRGB(0, 0, 0)
        esp.name.Visible = false
        esp.name.Font = 2

        esp.distance = Drawing.new("Text")
        esp.distance.Color = Color3.fromRGB(200, 200, 200)
        esp.distance.Size = 12
        esp.distance.Center = true
        esp.distance.Outline = true
        esp.distance.OutlineColor = Color3.fromRGB(0, 0, 0)
        esp.distance.Visible = false
        esp.distance.Font = 2

        esp.healthText = Drawing.new("Text")
        esp.healthText.Color = Color3.fromRGB(0, 255, 0)
        esp.healthText.Size = 12
        esp.healthText.Center = true
        esp.healthText.Outline = true
        esp.healthText.OutlineColor = Color3.fromRGB(0, 0, 0)
        esp.healthText.Visible = false
        esp.healthText.Font = 2

        esp.tracer = Drawing.new("Line")
        esp.tracer.Color = Color3.fromRGB(0, 255, 255)
        esp.tracer.Thickness = 1
        esp.tracer.Visible = false
        esp.tracer.Transparency = 0.7

        espDrawings[player.Name] = esp
    end
end

local function removeHighlight(playerName)
    if highlightObjects[playerName] then
        pcall(function() highlightObjects[playerName]:Destroy() end)
        highlightObjects[playerName] = nil
    end
    if espDrawings[playerName] then
        for _, obj in pairs(espDrawings[playerName]) do
            pcall(function() obj:Remove() end)
        end
        espDrawings[playerName] = nil
    end
end

local function hideDrawings(playerName)
    if espDrawings[playerName] then
        for _, obj in pairs(espDrawings[playerName]) do
            pcall(function() obj.Visible = false end)
        end
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
                    -- Highlight ekle
                    addHighlight(player)

                    -- Drawing objelerini guncelle
                    if usingDrawing and espDrawings[player.Name] then
                        local esp = espDrawings[player.Name]
                        local headPos = head and head.Position or rootPart.Position + Vector3.new(0, 2, 0)
                        local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)

                        if onScreen then
                            local dist = math.floor((Camera.CFrame.Position - rootPart.Position).Magnitude)
                            local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)

                            -- Name
                            esp.name.Text = player.DisplayName
                            esp.name.Position = Vector2.new(screenPos.X, screenPos.Y - 30)
                            esp.name.Visible = true

                            -- Distance
                            esp.distance.Text = "[" .. dist .. "m]"
                            esp.distance.Position = Vector2.new(screenPos.X, screenPos.Y - 16)
                            esp.distance.Visible = true

                            -- Health
                            esp.healthText.Text = healthPercent .. "%"
                            esp.healthText.Position = Vector2.new(screenPos.X, screenPos.Y - 44)
                            esp.healthText.Color = Color3.fromRGB(255 * (1 - healthPercent/100), 255 * (healthPercent/100), 0)
                            esp.healthText.Visible = true

                            -- Tracer
                            esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            esp.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                            esp.tracer.Visible = true
                        else
                            hideDrawings(player.Name)
                        end
                    end
                else
                    -- Oldu, highlight kaldir
                    removeHighlight(player.Name)
                end
            else
                -- Secili degil veya ESP kapali
                removeHighlight(player.Name)
            end
        end
    end
end

-- =============================================
-- MULTI-SELECT PLAYER LIST
-- =============================================
local playerButtons = {}

local function updateSelectCount()
    local count = 0
    for _ in pairs(Settings.SelectedPlayers) do count = count + 1 end
    SelectCountLabel.Text = "Selected: " .. count
end

local function isSelected(player)
    return Settings.SelectedPlayers[player.Name] ~= nil
end

local function toggleSelect(player, btn)
    if isSelected(player) then
        Settings.SelectedPlayers[player.Name] = nil
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        removeHighlight(player.Name)
    else
        Settings.SelectedPlayers[player.Name] = player
        btn.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        if getESP() then
            addHighlight(player)
        end
    end
    updateSelectCount()
end

local function createPlayerButton(player)
    if player == LocalPlayer then return end

    local selected = isSelected(player)

    local btn = Instance.new("TextButton")
    btn.Name = "PLR_" .. player.Name
    btn.Size = UDim2.new(1, -4, 0, 30)
    btn.BackgroundColor3 = selected and Color3.fromRGB(139, 0, 0) or Color3.fromRGB(45, 45, 45)
    btn.BorderSizePixel = 0
    btn.Text = "  " .. player.DisplayName
    btn.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = PlayerScroll

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        toggleSelect(player, btn)
    end)

    playerButtons[player.Name] = btn
end

local function refreshPlayerList()
    for _, btn in pairs(playerButtons) do
        if btn and btn.Parent then
            btn:Destroy()
        end
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
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            Settings.SelectedPlayers[player.Name] = player
        end
    end
    refreshPlayerList()
end)

ClearAllBtn.MouseButton1Click:Connect(function()
    -- Tum highlight temizle
    for name, _ in pairs(highlightObjects) do
        removeHighlight(name)
    end
    Settings.SelectedPlayers = {}
    Settings.CurrentTarget = nil
    refreshPlayerList()
end)

refreshPlayerList()

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    refreshPlayerList()
end)

Players.PlayerRemoving:Connect(function(player)
    Settings.SelectedPlayers[player.Name] = nil
    if Settings.CurrentTarget == player then
        Settings.CurrentTarget = nil
    end
    removeHighlight(player.Name)
    task.wait(0.1)
    refreshPlayerList()
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshPlayerList()
end)

-- Character respawn handling
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if isSelected(player) and getESP() then
                addHighlight(player)
            end
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if isSelected(player) and getESP() then
            addHighlight(player)
        end
    end)
end)

-- =============================================
-- WALL CHECK
-- =============================================
local function isVisibleCheck(targetPart)
    if not getWallCheck() then return true end

    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}

    local result = workspace:Raycast(origin, direction, rayParams)
    if result then
        local targetChar = targetPart:FindFirstAncestorWhichIsA("Model")
        if targetChar and result.Instance:IsDescendantOf(targetChar) then
            return true
        end
        return false
    end
    return true
end

-- =============================================
-- GET TARGET â€” SADECE SECILI OYUNCULARDAN
-- =============================================
local function getClosestFromSelected()
    local closest = nil
    local shortestDist = math.huge
    local fovRadius = getFOVRadius()

    local hasSelected = false
    for _ in pairs(Settings.SelectedPlayers) do
        hasSelected = true
        break
    end
    if not hasSelected then return nil end

    for _, player in pairs(Settings.SelectedPlayers) do
        if player and player.Character and player.Character:FindFirstChild(Settings.TargetPart) then
            local part = player.Character[Settings.TargetPart]
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = Camera:WorldToScreenPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if dist < fovRadius and dist < shortestDist and isVisibleCheck(part) then
                        shortestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

-- E tusuyla gecis
local cycleIndex = 0

local function cycleTarget()
    local selectedList = {}
    for _, player in pairs(Settings.SelectedPlayers) do
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum.Health > 0 then
                table.insert(selectedList, player)
            end
        end
    end

    if #selectedList == 0 then
        Settings.CurrentTarget = nil
        return
    end

    cycleIndex = (cycleIndex % #selectedList) + 1
    Settings.CurrentTarget = selectedList[cycleIndex]
    print("[DHL V2] Target: " .. Settings.CurrentTarget.DisplayName)
end

-- =============================================
-- CAMLOCK LOGIC
-- =============================================
local locked = false

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if Settings.Mode == "RightMouseClick" and input.UserInputType == Enum.UserInputType.MouseButton2 then
        if getCamlock() then
            Settings.CurrentTarget = getClosestFromSelected()
            locked = Settings.CurrentTarget ~= nil
        end
    end

    if Settings.Mode == "ToggleQ" and input.KeyCode == Enum.KeyCode.Q then
        if getCamlock() then
            if locked then
                locked = false
                Settings.CurrentTarget = nil
            else
                Settings.CurrentTarget = getClosestFromSelected()
                locked = Settings.CurrentTarget ~= nil
            end
        end
    end

    if input.KeyCode == Enum.KeyCode.E and locked then
        cycleTarget()
    end

    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if Settings.Mode == "RightMouseClick" and input.UserInputType == Enum.UserInputType.MouseButton2 then
        locked = false
        Settings.CurrentTarget = nil
    end
end)

-- =============================================
-- RENDER STEP
-- =============================================
RunService.RenderStepped:Connect(function()
    -- FOV Circle
    local fovRadius = getFOVRadius()
    local fovVisible = getFOVVisible()

    if usingDrawing and fovCircle then
        fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        fovCircle.Radius = fovRadius
        fovCircle.Visible = fovVisible
    elseif fovCircleGui then
        fovCircleGui.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
        fovCircleGui.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
        fovCircleGui.Visible = fovVisible
    end

    -- ESP
    updateESP()

    -- Camlock
    if not getCamlock() then
        locked = false
        Settings.CurrentTarget = nil
        return
    end

    if Settings.Mode == "NearestCursor" then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            Settings.CurrentTarget = getClosestFromSelected()
            locked = Settings.CurrentTarget ~= nil
        else
            locked = false
            Settings.CurrentTarget = nil
        end
    end

    if locked and Settings.CurrentTarget and Settings.CurrentTarget.Character then
        local part = Settings.CurrentTarget.Character:FindFirstChild(Settings.TargetPart)
        if part then
            local humanoid = Settings.CurrentTarget.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                if isVisibleCheck(part) then
                    local smoothness = getSmoothness()
                    local prediction = getPrediction()

                    local velocity = Vector3.new(0, 0, 0)
                    pcall(function()
                        velocity = part.AssemblyLinearVelocity
                    end)
                    if not velocity then
                        pcall(function() velocity = part.Velocity end)
                    end
                    velocity = velocity or Vector3.new(0, 0, 0)

                    local predictedPos = part.Position + (velocity * prediction)
                    local currentCF = Camera.CFrame
                    local targetCF = CFrame.new(currentCF.Position, predictedPos)

                    Camera.CFrame = currentCF:Lerp(targetCF, smoothness)
                else
                    if getWallCheck() then
                        locked = false
                        Settings.CurrentTarget = nil
                    end
                end
            else
                locked = false
                Settings.CurrentTarget = nil
            end
        end
    end
end)

-- =============================================
-- CLEANUP
-- =============================================
LocalPlayer.CharacterRemoving:Connect(function()
    for name, _ in pairs(highlightObjects) do
        removeHighlight(name)
    end
end)

-- =============================================
-- ESC + INPUT FIX
-- =============================================
local GuiService = game:GetService("GuiService")

-- SearchBox ESC ile focustan ciksin
SearchBox.FocusLost:Connect(function(enterPressed)
    -- normal
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Escape then
        if SearchBox:IsFocused() then
            SearchBox:ReleaseFocus()
        end
    end
end)

-- ESC menusu acilinca GUI'yi gizle, kapaninca goster
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

-- =============================================
-- BILDIRIM
-- =============================================
print("[DHL V2] by babaniz â€” YUKLENDI! (Highlight ESP + FOV)")
print("[DHL V2] Right Shift = GUI ac/kapa")
print("[DHL V2] E = Secili hedefler arasi gecis")
print("[DHL V2] Sadece secili oyunculara lock + ESP!")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DHL V2",
        Text = "by babaniz | Cyan Highlight ESP + FOV",
        Duration = 5
    })
end)
