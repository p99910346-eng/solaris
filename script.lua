-- Solaris GUI v10.9 (No Games)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Mouse = LocalPlayer:GetMouse()
local SpawnPoint = nil
local CustomPoints = {}
local GUIHidden = false
local Version = "10.9"

local FlyEnabled = false
local NoclipEnabled = false
local ESPEnabled = false
local AutoClickerEnabled = false
local FlyConnection = nil
local NoclipConnection = nil
local ESPConnection = nil
local ScannerConnection = nil
local AutoClickerConnection = nil

local KeyCooldown = {}

local FlySettings = {
    Speed = 50,
    MinSpeed = 10,
    MaxSpeed = 500,
}

local AutoClickerSettings = {
    Speed = 10,
    MinSpeed = 1,
    MaxSpeed = 50,
}

local QuickPlayers = {
    "Dfgvmg456",
    "minti",
    "pro_GREEN001",
    "Wr_White",
    "pasha999938",
    "Dfgvmg2"
}

local Keys = {
    HideGUI = Enum.KeyCode.RightShift,
    Fly = Enum.KeyCode.KeypadZero,
    Noclip = Enum.KeyCode.N,
    TPMouse = Enum.KeyCode.V,
    CopyCoords = Enum.KeyCode.C,
    ESP = Enum.KeyCode.X,
    AutoClicker = Enum.KeyCode.LeftBracket,
    AutoClickerSpeed = Enum.KeyCode.Equals,
    FlySpeedWindow = Enum.KeyCode.KeypadPeriod,
}

local Colors = {
    Frame = Color3.fromRGB(255, 255, 255),
    TitleBar = Color3.fromRGB(230, 230, 240),
    Button = Color3.fromRGB(240, 240, 245),
    ButtonHover = Color3.fromRGB(220, 220, 230),
    Text = Color3.fromRGB(30, 30, 40),
    Input = Color3.fromRGB(235, 235, 240),
    ScrollBg = Color3.fromRGB(245, 245, 248)
}

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolarisGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local OpenWindows = {}

local function MakeDraggable(frame, titleBar)
    local isDragging = false
    local dragStart = nil
    local frameStart = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            frameStart = frame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement and dragStart and frameStart then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                frameStart.X.Scale, 
                frameStart.X.Offset + delta.X, 
                frameStart.Y.Scale, 
                frameStart.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
end

local function CreateWindow(windowName, title, width, height)
    if OpenWindows[windowName] then
        OpenWindows[windowName]:Destroy()
        OpenWindows[windowName] = nil
    end
    
    local frame = Instance.new("Frame")
    frame.Name = windowName
    frame.Size = UDim2.new(0, width, 0, height)
    frame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    frame.BackgroundColor3 = Colors.Frame
    frame.BorderSizePixel = 0
    frame.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Colors.TitleBar
    titleBar.Text = title
    titleBar.TextColor3 = Colors.Text
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextSize = 11
    titleBar.Parent = frame
    
    MakeDraggable(frame, titleBar)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -27, 0, 4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Colors.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 10
    closeBtn.Parent = titleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        OpenWindows[windowName] = nil
        frame:Destroy()
    end)
    
    OpenWindows[windowName] = frame
    return frame
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 250)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Colors.Frame
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Colors.TitleBar
TitleBar.Text = "⚡ СОЛАРИС ХАБ v" .. Version .. " ⚡"
TitleBar.TextColor3 = Colors.Text
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 12
TitleBar.TextXAlignment = Enum.TextXAlignment.Center
TitleBar.Parent = MainFrame

MakeDraggable(MainFrame, TitleBar)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 22, 0, 22)
CloseButton.Position = UDim2.new(1, -27, 0, 6)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Colors.Text
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 10
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    if FlyConnection then FlyConnection:Disconnect() end
    if NoclipConnection then NoclipConnection:Disconnect() end
    if ESPConnection then ESPConnection:Disconnect() end
    if ScannerConnection then ScannerConnection:Disconnect() end
    if AutoClickerConnection then AutoClickerConnection:Disconnect() end
    ScreenGui:Destroy()
end)

local function SmoothTP(targetCFrame)
    local char = getCharacter()
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = targetCFrame
    end
end

local function TeleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        SmoothTP(targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
        return true
    end
    return false
end

local function ToggleFly()
    FlyEnabled = not FlyEnabled
    
    if FlyEnabled then
        if FlyConnection then FlyConnection:Disconnect() end
        
        FlyConnection = RunService.RenderStepped:Connect(function()
            local char = getCharacter()
            local humanoid = char and char:FindFirstChild("Humanoid")
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            
            if not humanoid or not rootPart then return end
            
            humanoid.PlatformStand = true
            
            local camera = workspace.CurrentCamera
            local moveDirection = Vector3.zero
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then 
                moveDirection += camera.CFrame.LookVector 
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then 
                moveDirection -= camera.CFrame.LookVector 
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then 
                moveDirection -= camera.CFrame.RightVector 
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then 
                moveDirection += camera.CFrame.RightVector 
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then 
                moveDirection += Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then 
                moveDirection -= Vector3.new(0, 1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
                rootPart.Velocity = moveDirection * FlySettings.Speed
            else
                rootPart.Velocity = Vector3.zero
            end
        end)
        
        print("Полёт включён! Скорость: " .. FlySettings.Speed)
    else
        if FlyConnection then 
            FlyConnection:Disconnect() 
            FlyConnection = nil 
        end
        
        local char = getCharacter()
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
        
        print("Полёт выключен!")
    end
end

local function ToggleNoclip()
    NoclipEnabled = not NoclipEnabled
    if NoclipEnabled then
        if NoclipConnection then NoclipConnection:Disconnect() end
        NoclipConnection = RunService.Stepped:Connect(function()
            local char = getCharacter()
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then 
                        part.CanCollide = false 
                    end
                end
            end
        end)
        print("Ноклип включён!")
    else
        if NoclipConnection then 
            NoclipConnection:Disconnect() 
            NoclipConnection = nil 
        end
        local char = getCharacter()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then 
                    part.CanCollide = true 
                end
            end
        end
        print("Ноклип выключен!")
    end
end

local function ToggleESP()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        if ESPConnection then ESPConnection:Disconnect() end
        ESPConnection = RunService.RenderStepped:Connect(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local char = player.Character
                    local humanoid = char:FindFirstChild("Humanoid")
                    
                    if not humanoid or humanoid.Health <= 0 then continue end
                    
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.Transparency < 0.5 and part.Name ~= "HumanoidRootPart" then
                            local highlight = part:FindFirstChild("ESP_" .. player.Name)
                            if not highlight then
                                highlight = Instance.new("Highlight")
                                highlight.Name = "ESP_" .. player.Name
                                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                                highlight.FillTransparency = 0.4
                                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                                highlight.OutlineTransparency = 0
                                highlight.Parent = part
                            end
                        end
                    end
                    
                    local head = char:FindFirstChild("Head")
                    if head then
                        local billboard = head:FindFirstChild("BB_" .. player.Name)
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "BB_" .. player.Name
                            billboard.Size = UDim2.new(0, 100, 0, 30)
                            billboard.StudsOffset = Vector3.new(0, 2, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = head
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Font = Enum.Font.GothamBold
                            label.TextSize = 18
                            label.TextStrokeTransparency = 0
                            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            label.Parent = billboard
                        end
                        
                        local label = billboard:FindFirstChildOfClass("TextLabel")
                        if label and humanoid then
                            local hp = math.floor(humanoid.Health)
                            local maxHP = math.floor(humanoid.MaxHealth)
                            local hpPercent = hp / maxHP
                            
                            label.Text = "❤️ " .. hp
                            
                            if hpPercent > 0.5 then
                                label.TextColor3 = Color3.fromRGB(0, 255, 0)
                            elseif hpPercent > 0.25 then
                                label.TextColor3 = Color3.fromRGB(255, 255, 0)
                            else
                                label.TextColor3 = Color3.fromRGB(255, 0, 0)
                            end
                        end
                    end
                end
            end
        end)
        print("ESP включён!")
    else
        if ESPConnection then 
            ESPConnection:Disconnect() 
            ESPConnection = nil 
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local highlight = part:FindFirstChild("ESP_" .. player.Name)
                        if highlight then highlight:Destroy() end
                        
                        local billboard = part:FindFirstChild("BB_" .. player.Name)
                        if billboard then billboard:Destroy() end
                    end
                end
            end
        end
        print("ESP выключен!")
    end
end

local function ToggleAutoClicker()
    AutoClickerEnabled = not AutoClickerEnabled
    
    if AutoClickerEnabled then
        if AutoClickerConnection then AutoClickerConnection:Disconnect() end
        
        local lastClick = 0
        AutoClickerConnection = RunService.RenderStepped:Connect(function(deltaTime)
            lastClick += deltaTime
            local delay = 1 / AutoClickerSettings.Speed
            
            if lastClick >= delay then
                lastClick = 0
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
            end
        end)
        
        print("Автокликер включён! Скорость: " .. AutoClickerSettings.Speed .. " кликов/сек")
    else
        if AutoClickerConnection then 
            AutoClickerConnection:Disconnect() 
            AutoClickerConnection = nil 
        end
        print("Автокликер выключен!")
    end
end

local function OpenFlySpeedWindow()
    local frame = CreateWindow("FlySpeedWindow", "✈️ СКОРОСТЬ ПОЛЁТА", 280, 250)
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.9, 0, 0, 35)
    speedLabel.Position = UDim2.new(0.05, 0, 0, 40)
    speedLabel.BackgroundColor3 = Colors.Button
    speedLabel.Text = "Скорость: " .. FlySettings.Speed
    speedLabel.TextColor3 = Colors.Text
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 12
    speedLabel.Parent = frame
    
    local speedInput = Instance.new("TextBox")
    speedInput.Size = UDim2.new(0.9, 0, 0, 30)
    speedInput.Position = UDim2.new(0.05, 0, 0, 80)
    speedInput.BackgroundColor3 = Colors.Input
    speedInput.PlaceholderText = "10-500"
    speedInput.Text = tostring(FlySettings.Speed)
    speedInput.TextColor3 = Colors.Text
    speedInput.Font = Enum.Font.Gotham
    speedInput.TextSize = 11
    speedInput.Parent = frame
    
    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0.9, 0, 0, 30)
    applyBtn.Position = UDim2.new(0.05, 0, 0, 115)
    applyBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    applyBtn.Text = "✅ ПРИМЕНИТЬ"
    applyBtn.TextColor3 = Colors.Text
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 11
    applyBtn.Parent = frame
    
    applyBtn.MouseButton1Click:Connect(function()
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed then
            FlySettings.Speed = math.clamp(newSpeed, FlySettings.MinSpeed, FlySettings.MaxSpeed)
            speedLabel.Text = "Скорость: " .. FlySettings.Speed
            speedInput.Text = tostring(FlySettings.Speed)
            print("Скорость полёта: " .. FlySettings.Speed)
        end
    end)
    
    local presetsLabel = Instance.new("TextLabel")
    presetsLabel.Size = UDim2.new(0.9, 0, 0, 20)
    presetsLabel.Position = UDim2.new(0.05, 0, 0, 150)
    presetsLabel.BackgroundColor3 = Colors.TitleBar
    presetsLabel.Text = "ПРЕСЕТЫ:"
    presetsLabel.TextColor3 = Colors.Text
    presetsLabel.Font = Enum.Font.GothamBold
    presetsLabel.TextSize = 9
    presetsLabel.Parent = frame
    
    local presets = {
        {name = "25", speed = 25},
        {name = "50", speed = 50},
        {name = "100", speed = 100},
        {name = "200", speed = 200},
        {name = "500", speed = 500}
    }
    
    for i, preset in ipairs(presets) do
        local presetBtn = Instance.new("TextButton")
        presetBtn.Size = UDim2.new(0.17, 0, 0, 25)
        presetBtn.Position = UDim2.new(0.05 + ((i - 1) % 5) * 0.18, 0, 0, 175)
        presetBtn.BackgroundColor3 = Colors.Button
        presetBtn.Text = preset.name
        presetBtn.TextColor3 = Colors.Text
        presetBtn.Font = Enum.Font.GothamBold
        presetBtn.TextSize = 9
        presetBtn.Parent = frame
        
        presetBtn.MouseButton1Click:Connect(function()
            FlySettings.Speed = preset.speed
            speedLabel.Text = "Скорость: " .. FlySettings.Speed
            speedInput.Text = tostring(FlySettings.Speed)
            print("Скорость полёта: " .. FlySettings.Speed)
        end)
    end
end

local function OpenAutoClickerSpeedWindow()
    local frame = CreateWindow("AutoClickerSpeedWindow", "⚡ СКОРОСТЬ КЛИКЕРА", 280, 200)
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.9, 0, 0, 35)
    speedLabel.Position = UDim2.new(0.05, 0, 0, 40)
    speedLabel.BackgroundColor3 = Colors.Button
    speedLabel.Text = "Скорость: " .. AutoClickerSettings.Speed .. "/сек"
    speedLabel.TextColor3 = Colors.Text
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 12
    speedLabel.Parent = frame
    
    local speedInput = Instance.new("TextBox")
    speedInput.Size = UDim2.new(0.9, 0, 0, 30)
    speedInput.Position = UDim2.new(0.05, 0, 0, 80)
    speedInput.BackgroundColor3 = Colors.Input
    speedInput.PlaceholderText = "1-50"
    speedInput.Text = tostring(AutoClickerSettings.Speed)
    speedInput.TextColor3 = Colors.Text
    speedInput.Font = Enum.Font.Gotham
    speedInput.TextSize = 11
    speedInput.Parent = frame
    
    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0.9, 0, 0, 30)
    applyBtn.Position = UDim2.new(0.05, 0, 0, 115)
    applyBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    applyBtn.Text = "✅ ПРИМЕНИТЬ"
    applyBtn.TextColor3 = Colors.Text
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 11
    applyBtn.Parent = frame
    
    applyBtn.MouseButton1Click:Connect(function()
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed then
            AutoClickerSettings.Speed = math.clamp(newSpeed, AutoClickerSettings.MinSpeed, AutoClickerSettings.MaxSpeed)
            speedLabel.Text = "Скорость: " .. AutoClickerSettings.Speed .. "/сек"
            speedInput.Text = tostring(AutoClickerSettings.Speed)
            print("Скорость автокликера: " .. AutoClickerSettings.Speed)
        end
    end)
end

local yPos = 40

local function CreateButton(emoji, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 35)
    Button.Position = UDim2.new(0.05, 0, 0, yPos)
    Button.BackgroundColor3 = Colors.Button
    Button.Text = emoji .. " " .. text
    Button.TextColor3 = Colors.Text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 11
    Button.Parent = MainFrame
    
    Button.MouseEnter:Connect(function() 
        Button.BackgroundColor3 = Colors.ButtonHover 
    end)
    
    Button.MouseLeave:Connect(function() 
        Button.BackgroundColor3 = Colors.Button 
    end)
    
    Button.MouseButton1Click:Connect(callback)
    
    yPos += 40
    return Button
end

CreateButton("💾", "СОХРАНИТЬ СПАВН", function()
    local char = getCharacter()
    if char and char:FindFirstChild("HumanoidRootPart") then
        SpawnPoint = char.HumanoidRootPart.CFrame
        print("Спавн сохранён!")
    end
end)

CreateButton("🔍", "СКАНЕР ПАРТ", function()
    local ScannerFrame = CreateWindow("ScannerWindow", "🔍 СКАНЕР", 320, 340)
    
    local isSelecting = false
    local currentHighlight = Instance.new("Highlight")
    
    local ToggleSelector = Instance.new("TextButton")
    ToggleSelector.Size = UDim2.new(0.9, 0, 0, 35)
    ToggleSelector.Position = UDim2.new(0.05, 0, 0, 40)
    ToggleSelector.BackgroundColor3 = Colors.Button
    ToggleSelector.Text = "СКАНЕР: ВЫКЛ (НАЖМИ)"
    ToggleSelector.TextColor3 = Color3.fromRGB(100, 100, 120)
    ToggleSelector.Font = Enum.Font.GothamBold
    ToggleSelector.TextSize = 11
    ToggleSelector.Parent = ScannerFrame
    
    local InfoContainer = Instance.new("Frame")
    InfoContainer.Size = UDim2.new(0.9, 0, 0, 230)
    InfoContainer.Position = UDim2.new(0.05, 0, 0, 85)
    InfoContainer.BackgroundColor3 = Colors.ScrollBg
    InfoContainer.Parent = ScannerFrame
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(0.94, 0, 0, 22)
    NameLabel.Position = UDim2.new(0.03, 0, 0, 5)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = "Выбрано: Ничего"
    NameLabel.TextColor3 = Colors.Text
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 12
    NameLabel.Parent = InfoContainer
    
    local PathLabel = Instance.new("TextBox")
    PathLabel.Size = UDim2.new(0.94, 0, 0, 40)
    PathLabel.Position = UDim2.new(0.03, 0, 0, 30)
    PathLabel.BackgroundColor3 = Colors.Input
    PathLabel.Text = "Путь появится здесь..."
    PathLabel.TextColor3 = Colors.Text
    PathLabel.Font = Enum.Font.Code
    PathLabel.TextSize = 10
    PathLabel.TextWrapped = true
    PathLabel.ClearTextOnFocus = false
    PathLabel.TextEditable = false
    PathLabel.Parent = InfoContainer
    
    local ChildrenScroll = Instance.new("ScrollingFrame")
    ChildrenScroll.Size = UDim2.new(0.94, 0, 0, 150)
    ChildrenScroll.Position = UDim2.new(0.03, 0, 0, 75)
    ChildrenScroll.BackgroundTransparency = 1
    ChildrenScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ChildrenScroll.ScrollBarThickness = 4
    ChildrenScroll.Parent = InfoContainer
    
    local function getCleanPath(obj)
        local path = obj.Name
        local parent = obj.Parent
        
        while parent and parent ~= game do
            local safeName = parent.Name
            local needsQuotes = string.find(safeName, " ") or string.find(safeName, "[%p]") or string.match(safeName, "^%d")
            
            if needsQuotes then
                path = '["' .. safeName .. '"]' .. "." .. path
            else
                path = safeName .. "." .. path
            end
            
            parent = parent.Parent
        end
        
        return 'game:GetService("Workspace").' .. path
    end
    
    local function updateChildrenList(obj)
        for _, child in pairs(ChildrenScroll:GetChildren()) do
            if child:IsA("TextLabel") then child:Destroy() end
        end
        
        local children = obj:GetChildren()
        ChildrenScroll.CanvasSize = UDim2.new(0, 0, 0, #children * 20)
        
        for i, child in ipairs(children) do
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Size = UDim2.new(1, 0, 0, 18)
            itemLabel.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
            itemLabel.Font = Enum.Font.Gotham
            itemLabel.Text = " 📦 " .. child.Name
            itemLabel.TextColor3 = Colors.Text
            itemLabel.TextSize = 10
            itemLabel.Parent = ChildrenScroll
        end
    end
    
    if ScannerConnection then ScannerConnection:Disconnect() end
    ScannerConnection = RunService.RenderStepped:Connect(function()
        if isSelecting and Mouse.Target then
            currentHighlight.Parent = Mouse.Target
        else
            currentHighlight.Parent = nil
        end
    end)
    
    Mouse.Button1Down:Connect(function()
        if isSelecting and Mouse.Target then
            local target = Mouse.Target
            NameLabel.Text = "Имя: " .. target.Name
            PathLabel.Text = getCleanPath(target)
            updateChildrenList(target)
            
            pcall(function()
                setclipboard(getCleanPath(target))
            end)
            
            isSelecting = false
            ToggleSelector.Text = "СКАНЕР: ВЫКЛ (НАЖМИ)"
        end
    end)
    
    ToggleSelector.MouseButton1Click:Connect(function()
        isSelecting = not isSelecting
        if isSelecting then
            ToggleSelector.Text = "НАВЕДИ И НАЖМИ"
        else
            ToggleSelector.Text = "СКАНЕР: ВЫКЛ (НАЖМИ)"
        end
    end)
end)

CreateButton("📍", "ТОЧКИ ТЕЛЕПОРТА", function()
    local frame = CreateWindow("PointsWindow", "📍 ТОЧКИ", 300, 300)
    
    local createBtn = Instance.new("TextButton")
    createBtn.Size = UDim2.new(0.9, 0, 0, 32)
    createBtn.Position = UDim2.new(0.05, 0, 0, 40)
    createBtn.BackgroundColor3 = Colors.Button
    createBtn.Text = "➕ СОЗДАТЬ ТОЧКУ"
    createBtn.TextColor3 = Colors.Text
    createBtn.Font = Enum.Font.GothamBold
    createBtn.TextSize = 11
    createBtn.Parent = frame
    
    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(0.9, 0, 0, 225)
    list.Position = UDim2.new(0.05, 0, 0, 77)
    list.BackgroundColor3 = Colors.ScrollBg
    list.ScrollBarThickness = 4
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.Parent = frame
    
    local function refresh()
        for _, child in ipairs(list:GetChildren()) do 
            if child:IsA("Frame") then child:Destroy() end
        end
        
        local y = 3
        for i, point in ipairs(CustomPoints) do
            local idx = i
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -8, 0, 30)
            container.Position = UDim2.new(0, 4, 0, y)
            container.BackgroundColor3 = Colors.Button
            container.Parent = list
            
            local tpBtn = Instance.new("TextButton")
            tpBtn.Size = UDim2.new(0.6, 0, 1, 0)
            tpBtn.BackgroundColor3 = Colors.Button
            tpBtn.Text = idx .. ". " .. point.Name
            tpBtn.TextColor3 = Colors.Text
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.TextSize = 9
            tpBtn.Parent = container
            tpBtn.MouseButton1Click:Connect(function() 
                SmoothTP(point.CFrame) 
            end)
            
            local renameBtn = Instance.new("TextButton")
            renameBtn.Size = UDim2.new(0.2, 0, 1, 0)
            renameBtn.Position = UDim2.new(0.6, 0, 0, 0)
            renameBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
            renameBtn.Text = "✏️"
            renameBtn.TextSize = 10
            renameBtn.Parent = container
            
            renameBtn.MouseButton1Click:Connect(function()
                local renameFrame = CreateWindow("RenameWindow", "✏️ ПЕРЕИМЕНОВАТЬ", 250, 100)
                
                local textBox = Instance.new("TextBox")
                textBox.Size = UDim2.new(0.9, 0, 0, 30)
                textBox.Position = UDim2.new(0.05, 0, 0, 35)
                textBox.BackgroundColor3 = Colors.Input
                textBox.Text = point.Name
                textBox.TextColor3 = Colors.Text
                textBox.Font = Enum.Font.Gotham
                textBox.TextSize = 11
                textBox.ClearTextOnFocus = false
                textBox.Parent = renameFrame
                
                local okBtn = Instance.new("TextButton")
                okBtn.Size = UDim2.new(0.45, 0, 0, 25)
                okBtn.Position = UDim2.new(0.05, 0, 0, 70)
                okBtn.BackgroundColor3 = Colors.Button
                okBtn.Text = "✅ OK"
                okBtn.TextColor3 = Colors.Text
                okBtn.Font = Enum.Font.GothamBold
                okBtn.TextSize = 10
                okBtn.Parent = renameFrame
                
                okBtn.MouseButton1Click:Connect(function()
                    if textBox.Text ~= "" then
                        CustomPoints[idx].Name = textBox.Text
                        renameFrame:Destroy()
                        refresh()
                    end
                end)
                
                local cancelBtn = Instance.new("TextButton")
                cancelBtn.Size = UDim2.new(0.45, 0, 0, 25)
                cancelBtn.Position = UDim2.new(0.55, 0, 0, 70)
                cancelBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 200)
                cancelBtn.Text = "❌"
                cancelBtn.TextColor3 = Colors.Text
                cancelBtn.Font = Enum.Font.GothamBold
                cancelBtn.TextSize = 10
                cancelBtn.Parent = renameFrame
                
                cancelBtn.MouseButton1Click:Connect(function()
                    renameFrame:Destroy()
                end)
            end)
            
            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0.2, 0, 1, 0)
            delBtn.Position = UDim2.new(0.8, 0, 0, 0)
            delBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
            delBtn.Text = "🗑️"
            delBtn.TextSize = 10
            delBtn.Parent = container
            delBtn.MouseButton1Click:Connect(function()
                table.remove(CustomPoints, idx)
                refresh()
            end)
            
            y += 33
        end
        
        list.CanvasSize = UDim2.new(0, 0, 0, math.max(y + 3, 225))
    end
    
    createBtn.MouseButton1Click:Connect(function()
        local char = getCharacter()
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            local newPoint = {
                Name = string.format("%d,%d,%d", math.round(pos.X), math.round(pos.Y), math.round(pos.Z)), 
                CFrame = char.HumanoidRootPart.CFrame
            }
            table.insert(CustomPoints, newPoint)
            refresh()
        end
    end)
    
    refresh()
end)

CreateButton("👤", "ТП К ИГРОКУ", function()
    local frame = CreateWindow("TeleportWindow", "👤 ТП К ИГРОКУ", 280, 380)
    
    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(0.9, 0, 0, 30)
    tb.Position = UDim2.new(0.05, 0, 0, 40)
    tb.BackgroundColor3 = Colors.Input
    tb.PlaceholderText = "🔍 Имя игрока..."
    tb.TextColor3 = Colors.Text
    tb.Parent = frame
    
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0.9, 0, 0, 30)
    tpBtn.Position = UDim2.new(0.05, 0, 0, 75)
    tpBtn.BackgroundColor3 = Colors.Button
    tpBtn.Text = "🚀 ТЕЛЕПОРТ"
    tpBtn.TextColor3 = Colors.Text
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 11
    tpBtn.Parent = frame
    tpBtn.MouseButton1Click:Connect(function() 
        TeleportToPlayer(tb.Text)
    end)
    
    local quickLabel = Instance.new("TextLabel")
    quickLabel.Size = UDim2.new(0.9, 0, 0, 20)
    quickLabel.Position = UDim2.new(0.05, 0, 0, 110)
    quickLabel.BackgroundColor3 = Colors.TitleBar
    quickLabel.Text = "⚡ БЫСТРЫЙ ТП:"
    quickLabel.TextColor3 = Colors.Text
    quickLabel.Font = Enum.Font.GothamBold
    quickLabel.TextSize = 9
    quickLabel.Parent = frame
    
    local quickList = Instance.new("ScrollingFrame")
    quickList.Size = UDim2.new(0.9, 0, 0, 120)
    quickList.Position = UDim2.new(0.05, 0, 0, 135)
    quickList.BackgroundColor3 = Colors.ScrollBg
    quickList.ScrollBarThickness = 4
    quickList.CanvasSize = UDim2.new(0, 0, 0, #QuickPlayers * 33)
    quickList.Parent = frame
    
    for i, pName in ipairs(QuickPlayers) do
        local qBtn = Instance.new("TextButton")
        qBtn.Size = UDim2.new(1, -8, 0, 28)
        qBtn.Position = UDim2.new(0, 4, 0, (i-1) * 33 + 3)
        qBtn.BackgroundColor3 = Colors.Button
        qBtn.Text = "⚡ " .. pName
        qBtn.TextColor3 = Colors.Text
        qBtn.Font = Enum.Font.GothamBold
        qBtn.TextSize = 10
        qBtn.Parent = quickList
        qBtn.MouseButton1Click:Connect(function() 
            TeleportToPlayer(pName) 
        end)
    end
    
    local serverLabel = Instance.new("TextLabel")
    serverLabel.Size = UDim2.new(0.9, 0, 0, 20)
    serverLabel.Position = UDim2.new(0.05, 0, 0, 260)
    serverLabel.BackgroundColor3 = Colors.TitleBar
    serverLabel.Text = "👥 ИГРОКИ:"
    serverLabel.TextColor3 = Colors.Text
    serverLabel.Font = Enum.Font.GothamBold
    serverLabel.TextSize = 9
    serverLabel.Parent = frame
    
    local serverList = Instance.new("ScrollingFrame")
    serverList.Size = UDim2.new(0.9, 0, 0, 100)
    serverList.Position = UDim2.new(0.05, 0, 0, 285)
    serverList.BackgroundColor3 = Colors.ScrollBg
    serverList.ScrollBarThickness = 4
    serverList.CanvasSize = UDim2.new(0, 0, 0, 0)
    serverList.Parent = frame
    
    local sy = 3
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local sBtn = Instance.new("TextButton")
            sBtn.Size = UDim2.new(1, -8, 0, 28)
            sBtn.Position = UDim2.new(0, 4, 0, sy)
            sBtn.BackgroundColor3 = Colors.Button
            sBtn.Text = "👤 " .. p.Name
            sBtn.TextColor3 = Colors.Text
            sBtn.Font = Enum.Font.Gotham
            sBtn.TextSize = 10
            sBtn.Parent = serverList
            sBtn.MouseButton1Click:Connect(function() 
                tb.Text = p.Name 
            end)
            sy += 33
        end
    end
    serverList.CanvasSize = UDim2.new(0, 0, 0, sy + 3)
end)

CreateButton("⚙️", "НАСТРОЙКИ", function()
    local frame = CreateWindow("SettingsWindow", "⚙️ НАСТРОЙКИ", 300, 340)
    
    local names = {
        HideGUI = "👁️ Скрыть", 
        Fly = "✈️ Полёт", 
        Noclip = "👻 Ноклип", 
        TPMouse = "🖱️ ТП мышь", 
        CopyCoords = "📋 Координаты", 
        ESP = "🔴 ESP",
        AutoClicker = "🖱️ Кликер",
        AutoClickerSpeed = "⚡ Скорость кликера",
        FlySpeedWindow = "✈️ Скорость полёта"
    }
    
    local y = 40
    for key, display in pairs(names) do
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.5, 0, 0, 28)
        lbl.Position = UDim2.new(0.05, 0, 0, y)
        lbl.BackgroundColor3 = Colors.Button
        lbl.Text = display
        lbl.TextColor3 = Colors.Text
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 10
        lbl.Parent = frame
        
        local keyBtn = Instance.new("TextButton")
        keyBtn.Size = UDim2.new(0.4, 0, 0, 28)
        keyBtn.Position = UDim2.new(0.55, 0, 0, y)
        keyBtn.BackgroundColor3 = Colors.Button
        keyBtn.Text = Keys[key].Name
        keyBtn.TextColor3 = Colors.Text
        keyBtn.Font = Enum.Font.GothamBold
        keyBtn.TextSize = 9
        keyBtn.Parent = frame
        
        keyBtn.MouseButton1Click:Connect(function()
            keyBtn.Text = "⌨️..."
            local conn
            
            conn = UserInputService.InputBegan:Connect(function(input, gp)
                if not gp and input.UserInputType == Enum.UserInputType.Keyboard then
                    Keys[key] = input.KeyCode
                    keyBtn.Text = input.KeyCode.Name
                    conn:Disconnect()
                end
            end)
        end)
        
        y += 33
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    if SpawnPoint then
        wait(0.5)
        local root = char:WaitForChild("HumanoidRootPart")
        if root then 
            root.CFrame = SpawnPoint 
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    
    if KeyCooldown[input.KeyCode] and tick() - KeyCooldown[input.KeyCode] < 0.3 then
        return
    end
    
    KeyCooldown[input.KeyCode] = tick()
    
    if input.KeyCode == Keys.HideGUI then
        GUIHidden = not GUIHidden
        for _, child in ipairs(ScreenGui:GetChildren()) do
            if child:IsA("Frame") then 
                child.Visible = not GUIHidden 
            end
        end
    end
    
    if gp then return end
    
    if input.KeyCode == Keys.Fly then ToggleFly() end
    if input.KeyCode == Keys.Noclip then ToggleNoclip() end
    if input.KeyCode == Keys.ESP then ToggleESP() end
    if input.KeyCode == Keys.AutoClicker then ToggleAutoClicker() end
    if input.KeyCode == Keys.AutoClickerSpeed then OpenAutoClickerSpeedWindow() end
    if input.KeyCode == Keys.FlySpeedWindow then OpenFlySpeedWindow() end
    
    if input.KeyCode == Keys.TPMouse then
        local char = getCharacter()
        if char and char:FindFirstChild("HumanoidRootPart") then
            SmoothTP(CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)))
        end
    end
    
    if input.KeyCode == Keys.CopyCoords then
        local char = getCharacter()
        if char and char:FindFirstChild("HumanoidRootPart") then
            local p = char.HumanoidRootPart.Position
            pcall(function()
                setclipboard(string.format("Vector3.new(%d,%d,%d)", 
                    math.round(p.X), math.round(p.Y), math.round(p.Z)))
            end)
        end
    end
    
    local numpadPoints = {
        [Enum.KeyCode.KeypadOne] = 1,
        [Enum.KeyCode.KeypadTwo] = 2,
        [Enum.KeyCode.KeypadThree] = 3,
        [Enum.KeyCode.KeypadFour] = 4,
        [Enum.KeyCode.KeypadFive] = 5,
        [Enum.KeyCode.KeypadSix] = 6,
        [Enum.KeyCode.KeypadSeven] = 7,
        [Enum.KeyCode.KeypadEight] = 8,
        [Enum.KeyCode.KeypadNine] = 9,
    }
    
    if numpadPoints[input.KeyCode] then
        local pointIndex = numpadPoints[input.KeyCode]
        if CustomPoints[pointIndex] then
            SmoothTP(CustomPoints[pointIndex].CFrame)
        end
    end
    
    local quickTP = {
        [Enum.KeyCode.F1] = "Dfgvmg456",
        [Enum.KeyCode.F2] = "minti",
        [Enum.KeyCode.F3] = "pro_GREEN001",
        [Enum.KeyCode.F4] = "Wr_White",
        [Enum.KeyCode.F5] = "pasha999938",
        [Enum.KeyCode.F6] = "Dfgvmg2"
    }
    
    if quickTP[input.KeyCode] then
        TeleportToPlayer(quickTP[input.KeyCode])
    end
end)

print("Solaris GUI v" .. Version .. " загружен!")
