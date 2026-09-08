--[[
    DHL V2 - by babanız
    Camlock Script for Roblox
    Executor uyumlu (Realius, Solara, Fluxus, vb.)
]]

print("[DHL V2] Script yükleniyor...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════
-- GUI PARENT — executor uyumlu
-- ═══════════════════════════════════════
local function getGuiParent()
    -- gethui varsa kullan (çoğu modern executor)
    if gethui then
        print("[DHL V2] gethui() kullanılıyor")
        return gethui()
    end

    -- syn.protect_gui varsa CoreGui'ye koy
    if syn and syn.protect_gui then
        print("[DHL V2] syn.protect_gui kullanılıyor")
        local sg = Instance.new("ScreenGui")
        syn.protect_gui(sg)
        sg.Parent = game:GetService("CoreGui")
        return sg
    end

    -- CoreGui'ye direkt dene
    local ok, _ = pcall(function()
        local test = Instance.new("ScreenGui")
        test.Parent = game:GetService("CoreGui")
        test:Destroy()
    end)
    if ok then
        print("[DHL V2] CoreGui kullanılıyor")
        return game:GetService("CoreGui")
    end

    -- Son çare: PlayerGui
    print("[DHL V2] PlayerGui kullanılıyor (fallback)")
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- ═══════════════════════════════════════
-- SETTINGS
-- ═══════════════════════════════════════
local Settings = {
    CamlockEnabled = true,
    WallCheck = true,
    Smoothness = 0.450,
    Prediction = 0.100,
    TargetPart = "HumanoidRootPart",
    SelectedPlayer = nil,
    Locked = false,
    Mode = "RightMouseClick"
}

-- ═══════════════════════════════════════
-- ESKİ GUI TEMİZLE (tekrar execute için)
-- ═══════════════════════════════════════
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

print("[DHL V2] Eski GUI temizlendi")

-- ═══════════════════════════════════════
-- GUI OLUŞTUR
-- ═══════════════════════════════════════
local guiParent = getGuiParent()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DHLV2_babaniz"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

-- Eğer parent zaten bir ScreenGui ise (syn durumu), ScreenGui yerine Frame kullan
if guiParent:IsA("ScreenGui") then
    ScreenGui = guiParent
    ScreenGui.Name = "DHLV2_babaniz"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
else
    ScreenGui.Parent = guiParent
end

print("[DHL V2] ScreenGui oluşturuldu, parent: " .. tostring(ScreenGui.Parent))

-- Draggable utility
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

-- ═══════════════════════════════════════
-- MAIN FRAME
-- ═══════════════════════════════════════
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 370)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -185)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

print("[DHL V2] MainFrame oluşturuldu")

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(139, 0, 0)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

makeDraggable(MainFrame)

-- ═══════════════════════════════════════
-- TITLE
-- ═══════════════════════════════════════
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 8)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "DHL V2"
TitleLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
TitleLabel.TextSize = 22
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Name = "Credit"
CreditLabel.Size = UDim2.new(1, 0, 0, 18)
CreditLabel.Position = UDim2.new(0, 0, 0, 35)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "By babanız"
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

-- ═══════════════════════════════════════
-- LEFT PANEL — PLAYER LIST
-- ═══════════════════════════════════════
local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0, 220, 0, 285)
LeftPanel.Position = UDim2.new(0, 15, 0, 68)
LeftPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LeftPanel.BackgroundTransparency = 0.3
LeftPanel.BorderSizePixel = 0
LeftPanel.Parent = MainFrame

local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 6)
LeftCorner.Parent = LeftPanel

local LeftStroke = Instance.new("UIStroke")
LeftStroke.Color = Color3.fromRGB(80, 0, 0)
LeftStroke.Thickness = 1
LeftStroke.Parent = LeftPanel

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
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

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Name = "PlayerList"
PlayerScroll.Size = UDim2.new(1, -16, 1, -44)
PlayerScroll.Position = UDim2.new(0, 8, 0, 40)
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

-- ═══════════════════════════════════════
-- RIGHT PANEL — CONTROLS
-- ═══════════════════════════════════════
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0, 255, 0, 285)
RightPanel.Position = UDim2.new(0, 248, 0, 68)
RightPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
RightPanel.BackgroundTransparency = 0.3
RightPanel.BorderSizePixel = 0
RightPanel.Parent = MainFrame

local RightCorner = Instance.new("UICorner")
RightCorner.CornerRadius = UDim.new(0, 6)
RightCorner.Parent = RightPanel

local RightStroke = Instance.new("UIStroke")
RightStroke.Color = Color3.fromRGB(80, 0, 0)
RightStroke.Thickness = 1
RightStroke.Parent = RightPanel

-- Toggle button helper
local function createToggleButton(name, default, posY, parent)
    local btn = Instance.new("TextButton")
    btn.Name = name:gsub(" ", "")
    btn.Size = UDim2.new(1, -20, 0, 32)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = default and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(60, 60, 60)
    btn.BorderSizePixel = 0
    btn.Text = name .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
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

    return btn, function() return state end, function(v)
        state = v
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(60, 60, 60)
    end
end

-- Slider helper
local function createSlider(name, min, max, default, posY, parent)
    local container = Instance.new("Frame")
    container.Name = name:gsub(" ", "") .. "Container"
    container.Size = UDim2.new(1, -20, 0, 45)
    container.Position = UDim2.new(0, 10, 0, posY)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. string.format("%.3f", default)
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Parent = container

    local sliderBg = Instance.new("TextButton")
    sliderBg.Name = "SliderBg"
    sliderBg.Size = UDim2.new(1, 0, 0, 12)
    sliderBg.Position = UDim2.new(0, 0, 0, 22)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.AutoButtonColor = false
    sliderBg.Parent = container

    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 4)
    sliderBgCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Name = "Knob"
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

    sliderBg.MouseButton1Down:Connect(function(x, y)
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

-- ═══════════════════════════════════════
-- BUILD CONTROLS
-- ═══════════════════════════════════════
local _, getCamlock, _ = createToggleButton("Camlock System", Settings.CamlockEnabled, 10, RightPanel)
local _, getWallCheck, _ = createToggleButton("Wall Check", Settings.WallCheck, 50, RightPanel)

print("[DHL V2] Toggle butonları oluşturuldu")

-- Mode button
local ModeBtn = Instance.new("TextButton")
ModeBtn.Name = "ModeBtn"
ModeBtn.Size = UDim2.new(1, -20, 0, 32)
ModeBtn.Position = UDim2.new(0, 10, 0, 90)
ModeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ModeBtn.BorderSizePixel = 0
ModeBtn.Text = "Mode: Right Mouse Click"
ModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeBtn.TextSize = 13
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
local getSmoothness = createSlider("Smoothness", 0.01, 1.0, Settings.Smoothness, 130, RightPanel)
local getPrediction = createSlider("Prediction", 0.0, 1.0, Settings.Prediction, 185, RightPanel)

print("[DHL V2] Sliderlar oluşturuldu")

-- Target Part button
local targetParts = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso"}
local currentTargetIdx = 1

local TargetBtn = Instance.new("TextButton")
TargetBtn.Name = "TargetPartBtn"
TargetBtn.Size = UDim2.new(1, -20, 0, 32)
TargetBtn.Position = UDim2.new(0, 10, 0, 242)
TargetBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TargetBtn.BorderSizePixel = 0
TargetBtn.Text = "Target Part: " .. Settings.TargetPart
TargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBtn.TextSize = 13
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

-- ═══════════════════════════════════════
-- PLAYER LIST
-- ═══════════════════════════════════════
local playerButtons = {}

local function createPlayerButton(player)
    if player == LocalPlayer then return end

    local btn = Instance.new("TextButton")
    btn.Name = "PLR_" .. player.Name
    btn.Size = UDim2.new(1, -4, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.BorderSizePixel = 0
    btn.Text = "  " .. player.DisplayName
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = PlayerScroll

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(playerButtons) do
            if b and b.Parent then
                b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                b.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Settings.SelectedPlayer = player
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
end

refreshPlayerList()
print("[DHL V2] Oyuncu listesi yüklendi: " .. tostring(#Players:GetPlayers() - 1) .. " oyuncu")

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    refreshPlayerList()
end)

Players.PlayerRemoving:Connect(function(player)
    if Settings.SelectedPlayer == player then
        Settings.SelectedPlayer = nil
        Settings.Locked = false
    end
    task.wait(0.1)
    refreshPlayerList()
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshPlayerList()
end)

-- ═══════════════════════════════════════
-- WALL CHECK
-- ═══════════════════════════════════════
local function isVisible(targetPart)
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

-- ═══════════════════════════════════════
-- CLOSEST PLAYER
-- ═══════════════════════════════════════
local function getClosestPlayer()
    local closest = nil
    local shortestDist = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Settings.TargetPart) then
            local part = player.Character[Settings.TargetPart]
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = Camera:WorldToScreenPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if dist < shortestDist and isVisible(part) then
                        shortestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

-- ═══════════════════════════════════════
-- CAMLOCK LOGIC
-- ═══════════════════════════════════════
local targetPlayer = nil
local locked = false

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    -- Right Mouse Click mode
    if Settings.Mode == "RightMouseClick" and input.UserInputType == Enum.UserInputType.MouseButton2 then
        if getCamlock() then
            if Settings.SelectedPlayer then
                targetPlayer = Settings.SelectedPlayer
                locked = true
            else
                targetPlayer = getClosestPlayer()
                locked = targetPlayer ~= nil
            end
        end
    end

    -- Toggle Q mode
    if Settings.Mode == "ToggleQ" and input.KeyCode == Enum.KeyCode.Q then
        if getCamlock() then
            if locked then
                locked = false
                targetPlayer = nil
            else
                if Settings.SelectedPlayer then
                    targetPlayer = Settings.SelectedPlayer
                    locked = true
                else
                    targetPlayer = getClosestPlayer()
                    locked = targetPlayer ~= nil
                end
            end
        end
    end

    -- Right Shift = GUI aç/kapa
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if Settings.Mode == "RightMouseClick" and input.UserInputType == Enum.UserInputType.MouseButton2 then
        locked = false
        targetPlayer = nil
    end
end)

-- ═══════════════════════════════════════
-- RENDER STEP — CAMERA LOCK
-- ═══════════════════════════════════════
RunService.RenderStepped:Connect(function()
    if not getCamlock() then
        locked = false
        targetPlayer = nil
        return
    end

    -- Nearest cursor mode
    if Settings.Mode == "NearestCursor" then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            targetPlayer = getClosestPlayer()
            locked = targetPlayer ~= nil
        else
            locked = false
            targetPlayer = nil
        end
    end

    if locked and targetPlayer and targetPlayer.Character then
        local part = targetPlayer.Character:FindFirstChild(Settings.TargetPart)
        if part then
            local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                if isVisible(part) then
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
                        targetPlayer = nil
                    end
                end
            else
                locked = false
                targetPlayer = nil
            end
        end
    end
end)

-- ═══════════════════════════════════════
-- BİLDİRİM
-- ═══════════════════════════════════════
print("[DHL V2] by babanız — TAMAMEN YÜKLENDI!")
print("[DHL V2] Right Shift = GUI aç/kapa")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DHL V2",
        Text = "by babanız — Yüklendi! | RShift aç/kapa",
        Duration = 5
    })
end)
