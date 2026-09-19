-- ZENVOR SCRIPT v1.0

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local STATE = {
    IS_OPEN = true,
    ACTIVE_TAB = "Aim",
    
    AIM_ENABLED = false,
    AIM_FOV_SHOW = false,
    AIM_FOV = 300,
    AIM_SMOOTH = 0.15,
    AIM_RMB_HELD = false,
    AIM_TARGET_HEAD = true,
    AIM_TEAM_CHECK = true,
    
    ESP_ENABLED = false,
    ESP_DISTANCE = 5000,
    ESP_BOX = true,
    ESP_NICK = true,
    ESP_DIST = true,
    ESP_HEALTH = true,
    
    SPEED_ENABLED = false,
    SPEED_VALUE = 1.0,
    CLICK_TP_ENABLED = false,
}

local COLOR_BG = Color3.fromRGB(26, 10, 15)
local COLOR_LEFT = Color3.fromRGB(20, 6, 10)
local COLOR_PANEL = Color3.fromRGB(32, 14, 20)
local COLOR_ELEMENT = Color3.fromRGB(40, 18, 24)
local COLOR_ACCENT = Color3.fromRGB(200, 16, 46)
local COLOR_ACCENT_BRIGHT = Color3.fromRGB(230, 57, 70)
local COLOR_TEXT = Color3.fromRGB(255, 255, 255)
local COLOR_TEXT_DIM = Color3.fromRGB(160, 140, 145)
local COLOR_OFF = Color3.fromRGB(60, 30, 38)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenvorScript"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local FovCircle = Instance.new("Frame")
FovCircle.Name = "FovCircle"
FovCircle.Size = UDim2.new(0, STATE.AIM_FOV, 0, STATE.AIM_FOV)
FovCircle.Position = UDim2.new(0.5, -STATE.AIM_FOV/2, 0.5, -STATE.AIM_FOV/2)
FovCircle.BackgroundTransparency = 1
FovCircle.BorderSizePixel = 0
FovCircle.Visible = false
FovCircle.Parent = ScreenGui

local FovCorner = Instance.new("UICorner")
FovCorner.CornerRadius = UDim.new(1, 0)
FovCorner.Parent = FovCircle

local FovStroke = Instance.new("UIStroke")
FovStroke.Color = COLOR_ACCENT
FovStroke.Thickness = 1
FovStroke.Transparency = 0.5
FovStroke.Parent = FovCircle

local EspContainer = Instance.new("Frame")
EspContainer.Name = "EspContainer"
EspContainer.Size = UDim2.new(1, 0, 1, 0)
EspContainer.BackgroundTransparency = 1
EspContainer.Parent = ScreenGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 150, 0, 36)
ToggleButton.Position = UDim2.new(0.5, -75, 0, 10)
ToggleButton.BackgroundColor3 = COLOR_BG
ToggleButton.Text = "ZENVOR SCRIPT"
ToggleButton.TextColor3 = COLOR_ACCENT
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.BorderSizePixel = 0
ToggleButton.Visible = false
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = COLOR_ACCENT
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleButton

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 720, 0, 440)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -220)
MainFrame.BackgroundColor3 = COLOR_BG
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 25, 35)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0, 190, 1, 0)
LeftPanel.BackgroundColor3 = COLOR_LEFT
LeftPanel.BorderSizePixel = 0
LeftPanel.Parent = MainFrame

local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 14)
LeftCorner.Parent = LeftPanel

local Logo = Instance.new("TextLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(1, -20, 0, 40)
Logo.BackgroundTransparency = 1
Logo.Text = "ZENVOR"
Logo.TextColor3 = COLOR_TEXT
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 28
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Position = UDim2.new(0, 25, 0, 20)
Logo.Parent = LeftPanel

local LogoSub = Instance.new("TextLabel")
LogoSub.Name = "LogoSub"
LogoSub.Size = UDim2.new(1, -20, 0, 20)
LogoSub.BackgroundTransparency = 1
LogoSub.Text = "SCRIPT"
LogoSub.TextColor3 = COLOR_ACCENT
LogoSub.Font = Enum.Font.GothamBold
LogoSub.TextSize = 14
LogoSub.TextXAlignment = Enum.TextXAlignment.Left
LogoSub.Position = UDim2.new(0, 27, 0, 55)
LogoSub.Parent = LeftPanel

local tabList = Instance.new("Frame")
tabList.Name = "TabList"
tabList.Size = UDim2.new(1, -20, 1, -130)
tabList.Position = UDim2.new(0, 10, 0, 95)
tabList.BackgroundTransparency = 1
tabList.Parent = LeftPanel

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabList

local tabButtons = {}

local function createTabButton(name, order)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Tab"
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = COLOR_PANEL
    btn.Text = "  " .. name
    btn.TextColor3 = COLOR_TEXT_DIM
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 15
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = tabList
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 4, 0.5, 0)
    indicator.Position = UDim2.new(0, 0, 0.25, 0)
    indicator.BackgroundColor3 = COLOR_ACCENT
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.Parent = btn
    
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator
    
    tabButtons[name] = {btn = btn, indicator = indicator}
    return btn
end

createTabButton("Aim", 1)
createTabButton("Esp", 2)
createTabButton("Others", 3)

local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(1, -200, 1, -20)
RightPanel.Position = UDim2.new(0, 195, 0, 10)
RightPanel.BackgroundTransparency = 1
RightPanel.Parent = MainFrame

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Name = "ContentScroll"
ContentScroll.Size = UDim2.new(1, 0, 1, 0)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 3
ContentScroll.ScrollBarImageColor3 = COLOR_ACCENT
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentScroll.Parent = RightPanel

local function createSection(parent, title, yPos)
    local section = Instance.new("TextLabel")
    section.Name = "Section_" .. title
    section.Size = UDim2.new(1, -10, 0, 25)
    section.Position = UDim2.new(0, 5, 0, yPos)
    section.BackgroundTransparency = 1
    section.Text = title
    section.TextColor3 = COLOR_ACCENT
    section.Font = Enum.Font.GothamBold
    section.TextSize = 13
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.Parent = parent
    return section
end

local function createToggle(parent, text, yPos, defaultState, callback)
    local container = Instance.new("Frame")
    container.Name = text:gsub("%s", "") .. "Toggle"
    container.Size = UDim2.new(1, -10, 0, 42)
    container.Position = UDim2.new(0, 5, 0, yPos)
    container.BackgroundColor3 = COLOR_PANEL
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = COLOR_TEXT
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 46, 0, 24)
    toggleBg.Position = UDim2.new(1, -56, 0.5, -12)
    toggleBg.BackgroundColor3 = defaultState and COLOR_ACCENT or COLOR_OFF
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = container
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = toggleBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = defaultState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = toggleBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local state = defaultState
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = container
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        toggleBg.BackgroundColor3 = state and COLOR_ACCENT or COLOR_OFF
        TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        }):Play()
        if callback then callback(state) end
    end)
    
    return container
end

local function createSlider(parent, text, yPos, minVal, maxVal, defaultVal, isFloat, callback)
    local container = Instance.new("Frame")
    container.Name = text:gsub("%s", "") .. "Slider"
    container.Size = UDim2.new(1, -10, 0, 58)
    container.Position = UDim2.new(0, 5, 0, yPos)
    container.BackgroundColor3 = COLOR_PANEL
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 22)
    label.Position = UDim2.new(0.04, 0, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = COLOR_TEXT
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 22)
    valueLabel.Position = UDim2.new(0.65, 0, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = isFloat and string.format("%.2f", defaultVal) or tostring(defaultVal)
    valueLabel.TextColor3 = COLOR_ACCENT
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0.92, 0, 0, 6)
    track.Position = UDim2.new(0.04, 0, 0, 38)
    track.BackgroundColor3 = COLOR_OFF
    track.BorderSizePixel = 0
    track.Parent = container
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = COLOR_ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(fill.Size.X.Scale, -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = track
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local dragging = false
    
    local function updateSlider(input)
        local trackPos = track.AbsolutePosition.X
        local trackSize = track.AbsoluteSize.X
        local mouseX = input.Position.X
        local alpha = math.clamp((mouseX - trackPos) / trackSize, 0, 1)
        local value
        
        if isFloat then
            value = minVal + (maxVal - minVal) * alpha
            value = math.floor(value * 100) / 100
            valueLabel.Text = string.format("%.2f", value)
        else
            value = math.floor(minVal + (maxVal - minVal) * alpha)
            valueLabel.Text = tostring(value)
        end
        
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, -8, 0.5, -8)
        
        if callback then callback(value) end
    end
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return container
end

local function isSameTeam(player)
    if not STATE.AIM_TEAM_CHECK then return false end
    if not player.Team then return false end
    if not LocalPlayer.Team then return false end
    return player.Team == LocalPlayer.Team
end

local function getTargets()
    local targets = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if isSameTeam(player) then continue end
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                table.insert(targets, {
                    player = player,
                    hrp = hrp,
                    hum = hum,
                    head = player.Character:FindFirstChild("Head")
                })
            end
        end
    end
    return targets
end

local function isVisible(hrp)
    local origin = Camera.CFrame.Position
    local direction = (hrp.Position - origin)
    local ray = Ray.new(origin, direction)
    
    local ignoreList = {LocalPlayer.Character, hrp.Parent}
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    
    return hit == nil or hit:IsDescendantOf(hrp.Parent)
end

local function getClosestTarget()
    local closest = nil
    local shortestDist = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, target in pairs(getTargets()) do
        local part = STATE.AIM_TARGET_HEAD and target.head or target.hrp
        if not part then part = target.hrp end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
        
        if onScreen then
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
            
            if dist <= STATE.AIM_FOV / 2 then
                if isVisible(target.hrp) then
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = target
                    end
                end
            end
        end
    end
    
    return closest
end

local espObjects = {}

local function createEsp(player)
    if espObjects[player] then return end
    
    local nick = Instance.new("TextLabel")
    nick.Name = "Nick"
    nick.BackgroundTransparency = 1
    nick.TextColor3 = COLOR_ACCENT
    nick.Font = Enum.Font.GothamMedium
    nick.TextSize = 12
    nick.TextStrokeTransparency = 0.5
    nick.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nick.Visible = false
    nick.Parent = EspContainer
    
    local hpText = Instance.new("TextLabel")
    hpText.Name = "HpText"
    hpText.BackgroundTransparency = 1
    hpText.TextColor3 = COLOR_ACCENT
    hpText.Font = Enum.Font.GothamMedium
    hpText.TextSize = 11
    hpText.TextStrokeTransparency = 0.5
    hpText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    hpText.Visible = false
    hpText.Parent = EspContainer
    
    local box = Instance.new("Frame")
    box.Name = "Box"
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.Parent = EspContainer
    
    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = COLOR_ACCENT
    boxStroke.Thickness = 1.5
    boxStroke.Parent = box
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "Dist"
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = COLOR_ACCENT
    distLabel.Font = Enum.Font.GothamMedium
    distLabel.TextSize = 11
    distLabel.TextStrokeTransparency = 0.5
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.Visible = false
    distLabel.Parent = EspContainer
    
    local healthBg = Instance.new("Frame")
    healthBg.Name = "HealthBg"
    healthBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthBg.BorderSizePixel = 0
    healthBg.Visible = false
    healthBg.Parent = EspContainer
    
    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.BackgroundColor3 = COLOR_ACCENT
    healthFill.BorderSizePixel = 0
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.Parent = healthBg
    
    espObjects[player] = {
        nick = nick,
        hpText = hpText,
        box = box,
        dist = distLabel,
        healthBg = healthBg,
        healthFill = healthFill,
    }
end

local function removeEsp(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            obj:Destroy()
        end
        espObjects[player] = nil
    end
end

local function applySpeed()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if STATE.SPEED_ENABLED then
        hum.WalkSpeed = 16 * STATE.SPEED_VALUE
    else
        hum.WalkSpeed = 16
    end
end

local function clickTeleport()
    if not STATE.CLICK_TP_ENABLED then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local ray = Camera:ViewportPointToRay(screenCenter.X, screenCenter.Y)
    
    local rayCast = Ray.new(ray.Origin, ray.Direction * 1000)
    local hit, position = workspace:FindPartOnRayWithIgnoreList(rayCast, {char})
    
    if position then
        hrp.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
    end
end

RunService.RenderStepped:Connect(function()
    if STATE.AIM_FOV_SHOW then
        FovCircle.Visible = true
        FovCircle.Size = UDim2.new(0, STATE.AIM_FOV, 0, STATE.AIM_FOV)
        FovCircle.Position = UDim2.new(0.5, -STATE.AIM_FOV/2, 0.5, -STATE.AIM_FOV/2)
    else
        FovCircle.Visible = false
    end
    
    if STATE.AIM_ENABLED and STATE.AIM_RMB_HELD then
        local target = getClosestTarget()
        if target then
            local part = STATE.AIM_TARGET_HEAD and target.head or target.hrp
            if not part then part = target.hrp end
            
            local targetCFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            
            if STATE.AIM_SMOOTH > 0 then
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 - STATE.AIM_SMOOTH)
            else
                Camera.CFrame = targetCFrame
            end
        end
    end
    
    if not STATE.ESP_ENABLED then
        for _, objs in pairs(espObjects) do
            for _, obj in pairs(objs) do
                obj.Visible = false
            end
        end
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character then
            removeEsp(player)
            continue
        end
        
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        local head = player.Character:FindFirstChild("Head")
        
        if not hrp or not hum or hum.Health <= 0 then
            if espObjects[player] then
                for _, obj in pairs(espObjects[player]) do
                    obj.Visible = false
                end
            end
            continue
        end
        
        local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
        if distance > STATE.ESP_DISTANCE then
            if espObjects[player] then
                for _, obj in pairs(espObjects[player]) do
                    obj.Visible = false
                end
            end
            continue
        end
        
        if not espObjects[player] then
            createEsp(player)
        end
        
        local objs = espObjects[player]
        
        local headPos = Camera:WorldToViewportPoint(head.Position)
        local hrpPos = Camera:WorldToViewportPoint(hrp.Position)
        
        local onScreen = headPos.Z > 0 and hrpPos.Z > 0
        
        local boxTop, boxBottom, boxHeight, boxWidth
        if onScreen then
            local headY = headPos.Y
            local hrpY = hrpPos.Y
            local height = (hrpY - headY) * 2.2
            boxTop = headY - height * 0.15
            boxHeight = height
            boxBottom = boxTop + boxHeight
            boxWidth = boxHeight / 2
        end
        
        if STATE.ESP_BOX and onScreen then
            objs.box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
            objs.box.Position = UDim2.new(0, headPos.X - boxWidth/2, 0, boxTop)
            objs.box.Visible = true
        else
            objs.box.Visible = false
        end
        
        if STATE.ESP_NICK and onScreen then
            objs.nick.Text = player.Name
            objs.nick.Size = UDim2.new(0, 200, 0, 14)
            objs.nick.Position = UDim2.new(0, headPos.X - 100, 0, boxTop - 30)
            objs.nick.Visible = true
        else
            objs.nick.Visible = false
        end
        
        if STATE.ESP_HEALTH and onScreen then
            objs.hpText.Text = string.format("%d / %d", math.floor(hum.Health), math.floor(hum.MaxHealth))
            objs.hpText.Size = UDim2.new(0, 200, 0, 12)
            objs.hpText.Position = UDim2.new(0, headPos.X - 100, 0, boxTop - 16)
            objs.hpText.Visible = true
        else
            objs.hpText.Visible = false
        end
        
        if STATE.ESP_DIST and onScreen then
            objs.dist.Text = string.format("%d m", distance)
            objs.dist.Size = UDim2.new(0, 100, 0, 12)
            objs.dist.Position = UDim2.new(0, headPos.X - 50, 0, boxBottom + 2)
            objs.dist.Visible = true
        else
            objs.dist.Visible = false
        end
        
        if STATE.ESP_HEALTH and onScreen and STATE.ESP_BOX then
            local healthPercent = hum.Health / hum.MaxHealth
            
            objs.healthBg.Size = UDim2.new(0, 3, 0, boxHeight)
            objs.healthBg.Position = UDim2.new(0, headPos.X - (boxWidth/2) - 6, 0, boxTop)
            objs.healthBg.Visible = true
            
            objs.healthFill.Size = UDim2.new(1, 0, healthPercent, 0)
            objs.healthFill.Position = UDim2.new(0, 0, 1 - healthPercent, 0)
            
            if healthPercent > 0.6 then
                objs.healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
            elseif healthPercent > 0.3 then
                objs.healthFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            else
                objs.healthFill.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            end
        else
            objs.healthBg.Visible = false
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeEsp(player)
end)

local function clearContent()
    for _, child in pairs(ContentScroll:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end

local function loadAimTab()
    local y = 10
    
    createSection(ContentScroll, "AIM", y)
    y = y + 30
    
    createToggle(ContentScroll, "Enable Aim", y, STATE.AIM_ENABLED, function(state)
        STATE.AIM_ENABLED = state
    end)
    y = y + 50
    
    createToggle(ContentScroll, "FOV Show", y, STATE.AIM_FOV_SHOW, function(state)
        STATE.AIM_FOV_SHOW = state
    end)
    y = y + 50
    
    createSlider(ContentScroll, "Aim FOV", y, 10, 2000, STATE.AIM_FOV, false, function(value)
        STATE.AIM_FOV = value
    end)
    y = y + 65
    
    createSlider(ContentScroll, "Smooth Aim", y, 0, 0.95, STATE.AIM_SMOOTH, true, function(value)
        STATE.AIM_SMOOTH = value
    end)
    y = y + 65
    
    createToggle(ContentScroll, "Target Head", y, STATE.AIM_TARGET_HEAD, function(state)
        STATE.AIM_TARGET_HEAD = state
    end)
    y = y + 50
    
    createToggle(ContentScroll, "Team Check", y, STATE.AIM_TEAM_CHECK, function(state)
        STATE.AIM_TEAM_CHECK = state
    end)
    y = y + 50
end

local function loadEspTab()
    local y = 10
    
    createSection(ContentScroll, "ESP", y)
    y = y + 30
    
    createToggle(ContentScroll, "Enable ESP", y, STATE.ESP_ENABLED, function(state)
        STATE.ESP_ENABLED = state
    end)
    y = y + 50
    
    createSlider(ContentScroll, "ESP Distance", y, 50, 5000, STATE.ESP_DISTANCE, false, function(value)
        STATE.ESP_DISTANCE = value
    end)
    y = y + 65
    
    createToggle(ContentScroll, "Box", y, STATE.ESP_BOX, function(state)
        STATE.ESP_BOX = state
    end)
    y = y + 50
    
    createToggle(ContentScroll, "Nick", y, STATE.ESP_NICK, function(state)
        STATE.ESP_NICK = state
    end)
    y = y + 50
    
    createToggle(ContentScroll, "Distance", y, STATE.ESP_DIST, function(state)
        STATE.ESP_DIST = state
    end)
    y = y + 50
    
    createToggle(ContentScroll, "Health", y, STATE.ESP_HEALTH, function(state)
        STATE.ESP_HEALTH = state
    end)
    y = y + 50
end

local function loadOthersTab()
    local y = 10
    
    createSection(ContentScroll, "OTHERS", y)
    y = y + 30
    
    createToggle(ContentScroll, "Speed Hack", y, STATE.SPEED_ENABLED, function(state)
        STATE.SPEED_ENABLED = state
        applySpeed()
    end)
    y = y + 50
    
    createSlider(ContentScroll, "Speed Value", y, 1.0, 1.5, STATE.SPEED_VALUE, true, function(value)
        STATE.SPEED_VALUE = value
        applySpeed()
    end)
    y = y + 65
    
    createToggle(ContentScroll, "Click TP (F)", y, STATE.CLICK_TP_ENABLED, function(state)
        STATE.CLICK_TP_ENABLED = state
    end)
    y = y + 50
end

local function switchTab(name)
    STATE.ACTIVE_TAB = name
    
    for tabName, data in pairs(tabButtons) do
        if tabName == name then
            data.btn.BackgroundColor3 = COLOR_ELEMENT
            data.btn.TextColor3 = COLOR_TEXT
            data.indicator.Visible = true
        else
            data.btn.BackgroundColor3 = COLOR_PANEL
            data.btn.TextColor3 = COLOR_TEXT_DIM
            data.indicator.Visible = false
        end
    end
    
    clearContent()
    
    if name == "Aim" then
        loadAimTab()
    elseif name == "Esp" then
        loadEspTab()
    elseif name == "Others" then
        loadOthersTab()
    end
end

for name, data in pairs(tabButtons) do
    data.btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

switchTab("Aim")

local function toggleMenu()
    if STATE.