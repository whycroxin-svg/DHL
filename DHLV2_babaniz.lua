-- DHL V2 by babanız
-- Roblox Aimlock + ESP Script (Highlight + FOV Circle)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ========================
-- SETTINGS
-- ========================
local Settings = {
    CamlockEnabled = true,
    WallCheck = true,
    Mode = "RightMouseClick", -- "RightMouseClick" / "Nearest" / "Hold"
    Smoothness = 0.450,
    Prediction = 0.100,
    TargetPart = "HumanoidRootPart",
    FOVRadius = 200,
    FOVVisible = true,
    ESPEnabled = true,
}

local TargetPlayer = nil
local Locked = false
local Highlights = {}

-- ========================
-- UI CREATION
-- ========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DHL_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Try to parent to CoreGui, fallback to PlayerGui
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 530, 0, 420)
MainFrame.Position = UDim2.new(0.5, -265, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 5, 5)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(139, 0, 0)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "DHL V2"
Title.TextColor3 = Color3.fromRGB(200, 0, 0)
Title.TextSize = 28
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Credit
local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1, 0, 0, 18)
Credit.Position = UDim2.new(0, 0, 0, 38)
Credit.BackgroundTransparency = 1
Credit.Text = "By babanız"
Credit.TextColor3 = Color3.fromRGB(255, 60, 60)
Credit.TextSize = 14
Credit.Font = Enum.Font.Gotham
Credit.Parent = MainFrame

-- Watermark (top right corner)
local Watermark = Instance.new("TextLabel")
Watermark.Size = UDim2.new(0, 200, 0, 20)
Watermark.Position = UDim2.new(1, -205, 0, -22)
Watermark.BackgroundTransparency = 1
Watermark.Text = "do4ctte1i0xqocmwizt"
Watermark.TextColor3 = Color3.fromRGB(255, 50, 50)
Watermark.TextSize = 12
Watermark.Font = Enum.Font.Gotham
Watermark.TextXAlignment = Enum.TextXAlignment.Right
Watermark.Parent = MainFrame

-- ========================
-- LEFT PANEL (Player List)
-- ========================
local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0, 210, 0, 320)
LeftPanel.Position = UDim2.new(0, 15, 0, 70)
LeftPanel.BackgroundColor3 = Color3.fromRGB(15, 3, 3)
LeftPanel.BackgroundTransparency = 0.2
LeftPanel.BorderSizePixel = 0
LeftPanel.Parent = MainFrame

local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 6)
LeftCorner.Parent = LeftPanel

local LeftStroke = Instance.new("UIStroke")
LeftStroke.Color = Color3.fromRGB(80, 0, 0)
LeftStroke.Thickness = 1
LeftStroke.Parent = LeftPanel

-- Search Box
local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, -20, 0, 28)
SearchBox.Position = UDim2.new(0, 10, 0, 8)
SearchBox.BackgroundColor3 = Color3.fromRGB(25, 8, 8)
SearchBox.BackgroundTransparency = 0.3
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

-- Scrolling Player List
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Name = "PlayerList"
PlayerList.Size = UDim2.new(1, -10, 1, -45)
PlayerList.Position = UDim2.new(0, 5, 0, 40)
PlayerList.BackgroundTransparency = 1
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 3
PlayerList.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = LeftPanel

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 2)
ListLayout.Parent = PlayerList

-- ========================
-- RIGHT PANEL (Controls)
-- ========================
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0, 270, 0, 320)
RightPanel.Position = UDim2.new(0, 245, 0, 70)
RightPanel.BackgroundTransparency = 1
RightPanel.Parent = MainFrame

-- Helper: Create Toggle Button
local function CreateToggleButton(name, text, pos, default)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 32)
    btn.Position = pos
    btn.BackgroundColor3 = default and Color3.fromRGB(139, 0, 0) or Color3.fromRGB(60, 10, 10)
    btn.BorderSizePixel = 0
    btn.Text = text .. (default and ": ON" or ": OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = RightPanel

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(180, 0, 0)
    stroke.Thickness = 1
    stroke.Parent = btn

    return btn
end

-- Helper: Create Info Button (non-toggle)
local function CreateInfoButton(name, text, pos)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 32)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 8, 8)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = RightPanel

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(120, 0, 0)
    stroke.Thickness = 1
    stroke.Parent = btn

    return btn
end

-- Helper: Create Slider
local function CreateSlider(name, text, pos, min, max, default, callback)
    local label = Instance.new("TextLabel")
    label.Name = name .. "Label"
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = pos
    label.BackgroundTransparency = 1
    label.Text = text .. " " .. string.format("%.3f", default)
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Parent = RightPanel

    local sliderBg = Instance.new("Frame")
    sliderBg.Name = name .. "SliderBg"
    sliderBg.Size = UDim2.new(1, -60, 0, 6)
    sliderBg.Position = UDim2.new(0, 30, pos.Y.Scale, pos.Y.Offset + 24)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 10, 10)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = RightPanel

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 3)
    bgCorner.Parent = sliderBg

    local knob = Instance.new("Frame")
    knob.Name = name .. "Knob"
    knob.Size = UDim2.new(0, 14, 0, 14)
    local ratio = (default - min) / (max - min)
    knob.Position = UDim2.new(ratio, -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBg

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    -- Slider drag logic
    local dragging = false

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local absPos = sliderBg.AbsolutePosition.X
            local absSize = sliderBg.AbsoluteSize.X
            local mouseX = input.Position.X
            local r = math.clamp((mouseX - absPos) / absSize, 0, 1)
            knob.Position = UDim2.new(r, -7, 0.5, -7)
            local val = min + (max - min) * r
            label.Text = text .. " " .. string.format("%.3f", val)
            if callback then callback(val) end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return label, sliderBg, knob
end

-- Camlock Toggle
local CamlockBtn = CreateToggleButton("CamlockBtn", "Camlock System", UDim2.new(0, 10, 0, 0), Settings.CamlockEnabled)
CamlockBtn.MouseButton1Click:Connect(function()
    Settings.CamlockEnabled = not Settings.CamlockEnabled
    CamlockBtn.Text = "Camlock System: " .. (Settings.CamlockEnabled and "ON" or "OFF")
    CamlockBtn.BackgroundColor3 = Settings.CamlockEnabled and Color3.fromRGB(139, 0, 0) or Color3.fromRGB(60, 10, 10)
    if not Settings.CamlockEnabled then
        Locked = false
        TargetPlayer = nil
    end
end)

-- Wall Check Toggle
local WallCheckBtn = CreateToggleButton("WallCheckBtn", "Wall Check", UDim2.new(0, 10, 0, 40), Settings.WallCheck)
WallCheckBtn.MouseButton1Click:Connect(function()
    Settings.WallCheck = not Settings.WallCheck
    WallCheckBtn.Text = "Wall Check: " .. (Settings.WallCheck and "ON" or "OFF")
    WallCheckBtn.BackgroundColor3 = Settings.WallCheck and Color3.fromRGB(139, 0, 0) or Color3.fromRGB(60, 10, 10)
end)

-- Mode Button
local Modes = {"RightMouseClick", "Nearest"}
local ModeIndex = 1
local ModeBtn = CreateInfoButton("ModeBtn", "Mode: Right Mouse Click", UDim2.new(0, 10, 0, 80))
ModeBtn.MouseButton1Click:Connect(function()
    ModeIndex = ModeIndex % #Modes + 1
    Settings.Mode = Modes[ModeIndex]
    local displayName = Settings.Mode == "RightMouseClick" and "Right Mouse Click" or Settings.Mode
    ModeBtn.Text = "Mode: " .. displayName
end)

-- Smoothness Slider
CreateSlider("Smoothness", "Smoothness", UDim2.new(0, 10, 0, 125), 0, 1, Settings.Smoothness, function(val)
    Settings.Smoothness = val
end)

-- Prediction Slider
CreateSlider("Prediction", "Prediction", UDim2.new(0, 10, 0, 175), 0, 1, Settings.Prediction, function(val)
    Settings.Prediction = val
end)

-- Target Part Button
local TargetParts = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso"}
local PartIndex = 1
local TargetPartBtn = CreateInfoButton("TargetPartBtn", "Target Part: " .. Settings.TargetPart, UDim2.new(0, 10, 0, 220))
TargetPartBtn.MouseButton1Click:Connect(function()
    PartIndex = PartIndex % #TargetParts + 1
    Settings.TargetPart = TargetParts[PartIndex]
    TargetPartBtn.Text = "Target Part: " .. Settings.TargetPart
end)

-- ESP Toggle
local ESPBtn = CreateToggleButton("ESPBtn", "ESP", UDim2.new(0, 10, 0, 260), Settings.ESPEnabled)
ESPBtn.MouseButton1Click:Connect(function()
    Settings.ESPEnabled = not Settings.ESPEnabled
    ESPBtn.Text = "ESP: " .. (Settings.ESPEnabled and "ON" or "OFF")
    ESPBtn.BackgroundColor3 = Settings.ESPEnabled and Color3.fromRGB(139, 0, 0) or Color3.fromRGB(60, 10, 10)
    if not Settings.ESPEnabled then
        ClearAllHighlights()
    end
end)

-- FOV Slider (below ESP toggle)
CreateSlider("FOV", "FOV Radius", UDim2.new(0, 10, 0, 300), 50, 500, Settings.FOVRadius, function(val)
    Settings.FOVRadius = val
end)

-- ========================
-- FOV CIRCLE (Drawing API)
-- ========================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.FOVRadius
FOVCircle.Filled = false
FOVCircle.Visible = Settings.FOVVisible
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Transparency = 0.7

-- ========================
-- ESP SYSTEM (Highlight based)
-- ========================
-- Colors
local ESP_DEFAULT_FILL = Color3.fromRGB(0, 255, 255)      -- Cyan (like reference image)
local ESP_DEFAULT_OUTLINE = Color3.fromRGB(0, 200, 200)
local ESP_TARGET_FILL = Color3.fromRGB(120, 70, 20)        -- Hamam böceği (cockroach brown)
local ESP_TARGET_OUTLINE = Color3.fromRGB(160, 90, 30)

local function CreateHighlight(player)
    if player == LocalPlayer then return end
    local character = player.Character
    if not character then return end

    -- Remove existing highlight
    if Highlights[player] then
        pcall(function() Highlights[player]:Destroy() end)
        Highlights[player] = nil
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "DHL_ESP_" .. player.Name
    highlight.Adornee = character
    highlight.FillColor = ESP_DEFAULT_FILL
    highlight.OutlineColor = ESP_DEFAULT_OUTLINE
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = game:GetService("CoreGui")

    Highlights[player] = highlight
end

local function ClearHighlight(player)
    if Highlights[player] then
        pcall(function() Highlights[player]:Destroy() end)
        Highlights[player] = nil
    end
end

local function ClearAllHighlights()
    for player, hl in pairs(Highlights) do
        pcall(function() hl:Destroy() end)
    end
    Highlights = {}
end

local function UpdateHighlightColors()
    for player, hl in pairs(Highlights) do
        if hl and hl.Parent then
            if player == TargetPlayer then
                hl.FillColor = ESP_TARGET_FILL
                hl.OutlineColor = ESP_TARGET_OUTLINE
                hl.FillTransparency = 0.3
            else
                hl.FillColor = ESP_DEFAULT_FILL
                hl.OutlineColor = ESP_DEFAULT_OUTLINE
                hl.FillTransparency = 0.5
            end
        end
    end
end

local function RefreshESP()
    if not Settings.ESPEnabled then
        ClearAllHighlights()
        return
    end

    -- Only highlight the selected target
    for player, hl in pairs(Highlights) do
        if player ~= TargetPlayer or not player.Parent or not player.Character then
            pcall(function() hl:Destroy() end)
            Highlights[player] = nil
        end
    end

    -- Create highlight for target if needed
    if TargetPlayer and TargetPlayer ~= LocalPlayer and TargetPlayer.Character then
        if not Highlights[TargetPlayer] or not Highlights[TargetPlayer].Parent then
            CreateHighlight(TargetPlayer)
        else
            if Highlights[TargetPlayer].Adornee ~= TargetPlayer.Character then
                Highlights[TargetPlayer].Adornee = TargetPlayer.Character
            end
        end
        -- Apply cockroach color to target
        if Highlights[TargetPlayer] then
            Highlights[TargetPlayer].FillColor = ESP_TARGET_FILL
            Highlights[TargetPlayer].OutlineColor = ESP_TARGET_OUTLINE
            Highlights[TargetPlayer].FillTransparency = 0.3
        end
    end
end

-- ========================
-- PLAYER LIST POPULATION
-- ========================
local PlayerButtons = {}

local function CreatePlayerButton(player)
    if player == LocalPlayer then return end

    local btn = Instance.new("TextButton")
    btn.Name = "PLR_" .. player.Name
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(30, 8, 8)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = "  " .. player.DisplayName
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = PlayerList

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        -- Deselect if same player clicked again
        if TargetPlayer == player then
            TargetPlayer = nil
            Locked = false
            btn.BackgroundColor3 = Color3.fromRGB(30, 8, 8)
        else
            -- Reset previous selection
            if TargetPlayer and PlayerButtons[TargetPlayer] then
                PlayerButtons[TargetPlayer].BackgroundColor3 = Color3.fromRGB(30, 8, 8)
            end
            TargetPlayer = player
            btn.BackgroundColor3 = Color3.fromRGB(120, 70, 20) -- Cockroach color selection
        end
        UpdateHighlightColors()
    end)

    PlayerButtons[player] = btn
    -- Update canvas size
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        PlayerList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
    end)
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
end

local function RemovePlayerButton(player)
    if PlayerButtons[player] then
        PlayerButtons[player]:Destroy()
        PlayerButtons[player] = nil
    end
    if TargetPlayer == player then
        TargetPlayer = nil
        Locked = false
    end
end

local function RefreshPlayerList(filter)
    for _, btn in pairs(PlayerButtons) do
        local playerName = string.sub(btn.Name, 5) -- Remove "PLR_" prefix
        if filter and filter ~= "" then
            btn.Visible = string.find(string.lower(playerName), string.lower(filter)) ~= nil
        else
            btn.Visible = true
        end
    end
end

-- Initial population
for _, player in ipairs(Players:GetPlayers()) do
    CreatePlayerButton(player)
end

Players.PlayerAdded:Connect(function(player)
    CreatePlayerButton(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if Settings.ESPEnabled then
            CreateHighlight(player)
            UpdateHighlightColors()
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    RemovePlayerButton(player)
    ClearHighlight(player)
end)

-- Connect character spawns for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if Settings.ESPEnabled then
                CreateHighlight(player)
                UpdateHighlightColors()
            end
        end)
    end
end

-- Search filter
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    RefreshPlayerList(SearchBox.Text)
end)

-- ========================
-- WALL CHECK
-- ========================
local function IsVisible(targetPart)
    if not Settings.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = workspace:Raycast(origin, direction, rayParams)
    if result then
        local hitPart = result.Instance
        if hitPart:IsDescendantOf(targetPart.Parent) then
            return true
        end
        return false
    end
    return true
end

-- ========================
-- GET CLOSEST PLAYER TO MOUSE (within FOV)
-- ========================
local function GetClosestPlayer()
    local closest = nil
    local closestDist = Settings.FOVRadius

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetPart = player.Character:FindFirstChild(Settings.TargetPart)
            if targetPart then
                local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                if onScreen then
                    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                    local screenPt = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (mousePos - screenPt).Magnitude

                    if dist < closestDist then
                        if IsVisible(targetPart) then
                            closestDist = dist
                            closest = player
                        end
                    end
                end
            end
        end
    end

    return closest
end

-- ========================
-- AIMLOCK LOGIC
-- ========================
local function AimlockStep()
    if not Settings.CamlockEnabled then return end
    if not TargetPlayer then return end
    if not Locked then return end

    local character = TargetPlayer.Character
    if not character then
        Locked = false
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        Locked = false
        TargetPlayer = nil
        UpdateHighlightColors()
        return
    end

    local targetPart = character:FindFirstChild(Settings.TargetPart)
    if not targetPart then return end

    if not IsVisible(targetPart) then return end

    -- Prediction
    local velocity = character:FindFirstChild("HumanoidRootPart")
    local predictedPos = targetPart.Position
    if velocity and velocity:IsA("BasePart") then
        predictedPos = targetPart.Position + (velocity.AssemblyLinearVelocity * Settings.Prediction)
    end

    -- Smooth aim
    local currentCF = Camera.CFrame
    local targetCF = CFrame.new(currentCF.Position, predictedPos)
    Camera.CFrame = currentCF:Lerp(targetCF, 1 - Settings.Smoothness)
end

-- ========================
-- INPUT HANDLING
-- ========================
-- Right Click hold to lock
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if TargetPlayer then
            Locked = true
        else
            -- Auto-find closest if no target selected
            local closest = GetClosestPlayer()
            if closest then
                if PlayerButtons[TargetPlayer] then
                    PlayerButtons[TargetPlayer].BackgroundColor3 = Color3.fromRGB(30, 8, 8)
                end
                TargetPlayer = closest
                if PlayerButtons[TargetPlayer] then
                    PlayerButtons[TargetPlayer].BackgroundColor3 = Color3.fromRGB(120, 70, 20)
                end
                Locked = true
                UpdateHighlightColors()
            end
        end
    end

    -- Toggle UI visibility with RightShift
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Locked = false
    end
end)

-- ========================
-- MAIN LOOP
-- ========================
RunService.RenderStepped:Connect(function()
    -- Update FOV circle
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    FOVCircle.Radius = Settings.FOVRadius
    FOVCircle.Visible = Settings.FOVVisible and MainFrame.Visible

    -- Aimlock
    AimlockStep()

    -- Nearest mode auto-lock
    if Settings.Mode == "Nearest" and Settings.CamlockEnabled then
        local closest = GetClosestPlayer()
        if closest ~= TargetPlayer then
            if PlayerButtons[TargetPlayer] then
                PlayerButtons[TargetPlayer].BackgroundColor3 = Color3.fromRGB(30, 8, 8)
            end
            TargetPlayer = closest
            if TargetPlayer and PlayerButtons[TargetPlayer] then
                PlayerButtons[TargetPlayer].BackgroundColor3 = Color3.fromRGB(120, 70, 20)
            end
            UpdateHighlightColors()
        end
        Locked = TargetPlayer ~= nil
    end

    -- Refresh ESP
    RefreshESP()
end)

-- ========================
-- CLEANUP ON SCRIPT DESTROY
-- ========================
ScreenGui.Destroying:Connect(function()
    ClearAllHighlights()
    FOVCircle:Remove()
end)

print("[DHL V2] Loaded successfully — by babanız")
print("[DHL V2] RightShift = Toggle UI | Right Click = Aim")
