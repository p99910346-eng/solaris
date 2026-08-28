-- Solaris GUI v8.3 (Fixed Numpad + Full Scanner + Bug Fixes)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService") -- Добавил для защиты от спама

local Mouse = LocalPlayer:GetMouse()
local SpawnPoint = nil
local CustomPoints = {}
local GUIHidden = false
local Version = "8.3"

local FlyEnabled = false
local NoclipEnabled = false
local ESPEnabled = false
local FlySpeed = 50
local FlyConnection = nil
local NoclipConnection = nil
local ESPConnection = nil
local ScannerConnection = nil -- Добавил для отключения сканера

-- Флаг для предотвращения множественного срабатывания клавиш
local KeyCooldown = {}

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
    Fly = Enum.KeyCode.B,
    Noclip = Enum.KeyCode.N,
    TPMouse = Enum.KeyCode.V,
    CopyCoords = Enum.KeyCode.C,
    ESP = Enum.KeyCode.X
}

local Colors = {
    Frame = Color3.fromRGB(255, 255, 255),
    TitleBar = Color3.fromRGB(230, 230, 240),
    Button = Color3.fromRGB(240, 240, 245),
    ButtonHover = Color3.fromRGB(220, 220, 230),
    Text = Color3.fromRGB(30, 30, 40),
    Border = Color3.fromRGB(180, 180, 190),
    Input = Color3.fromRGB(235, 235, 240),
    ScrollBg = Color3.fromRGB(245, 245, 248)
}

-- Безопасное получение персонажа
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local character = getCharacter()

-- Создание GUI с защитой от дублирования
local function createGUI()
    -- Проверяем, не существует ли уже GUI
    if LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("SolarisGUI") then
        LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("SolarisGUI"):Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SolarisGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    return ScreenGui
end

local ScreenGui = createGUI()

-- Исправленное перетаскивание (проверка на nil)
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

local function CreateWindow(title, width, height, zIndex)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, width, 0, height)
    frame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    frame.BackgroundColor3 = Colors.Frame
    frame.BorderSizePixel = 0
    frame.ZIndex = zIndex
    frame.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.Border
    stroke.Thickness = 1.5
    stroke.Parent = frame
    
    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Colors.TitleBar
    titleBar.Text = title
    titleBar.TextColor3 = Colors.Text
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextSize = 12
    titleBar.ZIndex = zIndex + 1
    titleBar.Parent = frame
    
    MakeDraggable(frame, titleBar)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Colors.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.ZIndex = 999
    closeBtn.Parent = titleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        frame:Destroy()
    end)
    
    return frame
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Colors.Frame
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Colors.Border
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Colors.TitleBar
TitleBar.Text = "⚡ СОЛАРИС ХАБ v" .. Version .. " ⚡"
TitleBar.TextColor3 = Colors.Text
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 13
TitleBar.TextXAlignment = Enum.TextXAlignment.Center
TitleBar.Parent = MainFrame

MakeDraggable(MainFrame, TitleBar)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Colors.Text
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 12
CloseButton.ZIndex = 999
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    -- Очищаем все соединения перед уничтожением
    if FlyConnection then FlyConnection:Disconnect() end
    if NoclipConnection then NoclipConnection:Disconnect() end
    if ESPConnection then ESPConnection:Disconnect() end
    if ScannerConnection then ScannerConnection:Disconnect() end
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
            local direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.new(0, 1, 0) end
            
            if direction.Magnitude > 0 then
                direction = direction.Unit
                rootPart.Velocity = direction * FlySpeed
                rootPart.AssemblyLinearVelocity = direction * FlySpeed
            else
                rootPart.Velocity = Vector3.zero
                rootPart.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    else
        if FlyConnection then 
            FlyConnection:Disconnect() 
            FlyConnection = nil 
        end
        local char = getCharacter()
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
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
    else
        if NoclipConnection then 
            NoclipConnection:Disconnect() 
            NoclipConnection = nil 
        end
        -- Восстанавливаем коллизии
        local char = getCharacter()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then 
                    part.CanCollide = true 
                end
            end
        end
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
                    
                    -- Проверяем, что персонаж жив
                    if not humanoid or humanoid.Health <= 0 then
                        -- Удаляем ESP для мертвых
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                local highlight = part:FindFirstChild("ESP_" .. player.Name)
                                if highlight then highlight:Destroy() end
                            end
                        end
                        continue
                    end
                    
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
                                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
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
                            billboard.Size = UDim2.new(0, 50, 0, 25)
                            billboard.StudsOffset = Vector3.new(0, 1.5, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = head
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Font = Enum.Font.GothamBold
                            label.TextSize = 16
                            label.TextStrokeTransparency = 0
                            label.Parent = billboard
                        end
                        
                        local label = billboard:FindFirstChildOfClass("TextLabel")
                        if label and humanoid then
                            local hp = math.floor(humanoid.Health)
                            local maxHP = math.floor(humanoid.MaxHealth)
                            label.Text = "❤️ " .. hp
                            
                            if hp > maxHP * 0.5 then 
                                label.TextColor3 = Color3.fromRGB(0, 255, 0)
                            elseif hp > maxHP * 0.25 then 
                                label.TextColor3 = Color3.fromRGB(255, 255, 0)
                            else 
                                label.TextColor3 = Color3.fromRGB(255, 0, 0) 
                            end
                        end
                    end
                end
            end
        end)
    else
        if ESPConnection then 
            ESPConnection:Disconnect() 
            ESPConnection = nil 
        end
        
        -- Удаляем все ESP
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
    end
end

local yPos = 45

local function CreateButton(emoji, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 38)
    Button.Position = UDim2.new(0.05, 0, 0, yPos)
    Button.BackgroundColor3 = Colors.Button
    Button.Text = emoji .. " " .. text
    Button.TextColor3 = Colors.Text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    Button.Parent = MainFrame
    
    Button.MouseEnter:Connect(function() 
        Button.BackgroundColor3 = Colors.ButtonHover 
    end)
    
    Button.MouseLeave:Connect(function() 
        Button.BackgroundColor3 = Colors.Button 
    end)
    
    Button.MouseButton1Click:Connect(callback)
    
    yPos += 43
    return Button
end

CreateButton("💾", "СОХРАНИТЬ СПАВН", function()
    local char = getCharacter()
    if char and char:FindFirstChild("HumanoidRootPart") then
        SpawnPoint = char.HumanoidRootPart.CFrame
    end
end)

-- ПОЛНЫЙ СКАНЕР (исправлен)
CreateButton("🔍", "СКАНЕР ПАРТ", function()
    local ScannerFrame = Instance.new("Frame")
    ScannerFrame.Size = UDim2.new(0, 320, 0, 340)
    ScannerFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
    ScannerFrame.BackgroundColor3 = Colors.Frame
    ScannerFrame.BorderSizePixel = 0
    ScannerFrame.Active = true
    ScannerFrame.ZIndex = 300
    ScannerFrame.Parent = ScreenGui
    
    local ScannerCorner = Instance.new("UICorner")
    ScannerCorner.CornerRadius = UDim.new(0, 16)
    ScannerCorner.Parent = ScannerFrame
    
    local ScannerStroke = Instance.new("UIStroke")
    ScannerStroke.Color = Colors.Border
    ScannerStroke.Thickness = 2
    ScannerStroke.Parent = ScannerFrame
    
    -- Исправлено: заголовок для перетаскивания
    local ScannerTitle = Instance.new("TextLabel")
    ScannerTitle.Size = UDim2.new(1, 0, 0, 45)
    ScannerTitle.BackgroundColor3 = Colors.TitleBar
    ScannerTitle.Text = "🔍 СКАНЕР ОБЪЕКТОВ"
    ScannerTitle.TextColor3 = Colors.Text
    ScannerTitle.Font = Enum.Font.GothamBold
    ScannerTitle.TextSize = 15
    ScannerTitle.ZIndex = 301
    ScannerTitle.Parent = ScannerFrame
    
    -- Перетаскивание через заголовок
    MakeDraggable(ScannerFrame, ScannerTitle)
    
    local ScannerClose = Instance.new("TextButton")
    ScannerClose.Size = UDim2.new(0, 25, 0, 25)
    ScannerClose.Position = UDim2.new(1, -30, 0, 10)
    ScannerClose.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
    ScannerClose.Text = "✕"
    ScannerClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScannerClose.Font = Enum.Font.GothamBold
    ScannerClose.TextSize = 12
    ScannerClose.ZIndex = 999
    ScannerClose.Parent = ScannerFrame
    
    local isSelecting = false
    local currentHighlight = Instance.new("Highlight")
    currentHighlight.FillColor = Color3.fromRGB(150, 150, 170)
    currentHighlight.FillTransparency = 0.6
    currentHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    currentHighlight.OutlineTransparency = 0
    
    ScannerClose.MouseButton1Click:Connect(function()
        if ScannerConnection then ScannerConnection:Disconnect() end
        currentHighlight:Destroy()
        ScannerFrame:Destroy()
    end)
    
    local ToggleSelector = Instance.new("TextButton")
    ToggleSelector.Size = UDim2.new(0.9, 0, 0, 40)
    ToggleSelector.Position = UDim2.new(0.05, 0, 0, 55)
    ToggleSelector.BackgroundColor3 = Colors.Button
    ToggleSelector.Text = "СКАНЕР: ВЫКЛ (НАЖМИ)"
    ToggleSelector.TextColor3 = Color3.fromRGB(100, 100, 120)
    ToggleSelector.Font = Enum.Font.GothamBold
    ToggleSelector.TextSize = 12
    ToggleSelector.ZIndex = 301
    ToggleSelector.Parent = ScannerFrame
    
    local InfoContainer = Instance.new("Frame")
    InfoContainer.Size = UDim2.new(0.9, 0, 0, 215)
    InfoContainer.Position = UDim2.new(0.05, 0, 0, 105)
    InfoContainer.BackgroundColor3 = Colors.ScrollBg
    InfoContainer.ZIndex = 301
    InfoContainer.Parent = ScannerFrame
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(0.94, 0, 0, 25)
    NameLabel.Position = UDim2.new(0.03, 0, 0, 5)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = "Выбрано: Ничего"
    NameLabel.TextColor3 = Colors.Text
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 13
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.ZIndex = 302
    NameLabel.Parent = InfoContainer
    
    local PathLabel = Instance.new("TextBox")
    PathLabel.Size = UDim2.new(0.94, 0, 0, 45)
    PathLabel.Position = UDim2.new(0.03, 0, 0, 35)
    PathLabel.BackgroundColor3 = Colors.Input
    PathLabel.Text = "Путь появится здесь..."
    PathLabel.TextColor3 = Colors.Text
    PathLabel.Font = Enum.Font.Code
    PathLabel.TextSize = 11
    PathLabel.TextWrapped = true
    PathLabel.ClearTextOnFocus = false
    PathLabel.TextEditable = false
    PathLabel.ZIndex = 302
    PathLabel.Parent = InfoContainer
    
    local ChildrenScroll = Instance.new("ScrollingFrame")
    ChildrenScroll.Size = UDim2.new(0.94, 0, 0, 115)
    ChildrenScroll.Position = UDim2.new(0.03, 0, 0, 88)
    ChildrenScroll.BackgroundTransparency = 1
    ChildrenScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ChildrenScroll.ScrollBarThickness = 4
    ChildrenScroll.ZIndex = 302
    ChildrenScroll.Parent = InfoContainer
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.Parent = ChildrenScroll
    
    local function getCleanPath(obj)
        local path = obj.Name
        local parent = obj.Parent
        
        while parent and parent ~= game do
            local safeName = parent.Name
            
            -- Проверяем, нужны ли кавычки
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
        -- Очищаем список
        for _, child in pairs(ChildrenScroll:GetChildren()) do
            if child:IsA("TextLabel") then 
                child:Destroy() 
            end
        end
        
        local children = obj:GetChildren()
        ChildrenScroll.CanvasSize = UDim2.new(0, 0, 0, #children * 22)
        
        if #children == 0 then
            local emptyLabel = Instance.new("TextLabel")
            emptyLabel.Size = UDim2.new(1, 0, 0, 20)
            emptyLabel.BackgroundTransparency = 1
            emptyLabel.Font = Enum.Font.GothamItalic
            emptyLabel.Text = "[ Нет детей внутри ]"
            emptyLabel.TextColor3 = Color3.fromRGB(130, 130, 140)
            emptyLabel.TextSize = 12
            emptyLabel.Parent = ChildrenScroll
        else
            for i, child in ipairs(children) do
                local itemLabel = Instance.new("TextLabel")
                itemLabel.Size = UDim2.new(1, 0, 0, 18)
                itemLabel.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
                itemLabel.Font = Enum.Font.Gotham
                itemLabel.Text = " 📦 " .. child.Name .. " (" .. child.ClassName .. ")"
                itemLabel.TextColor3 = Colors.Text
                itemLabel.TextSize = 11
                itemLabel.TextXAlignment = Enum.TextXAlignment.Left
                itemLabel.Parent = ChildrenScroll
            end
        end
    end
    
    -- Исправлено: отдельное соединение для сканера
    if ScannerConnection then ScannerConnection:Disconnect() end
    ScannerConnection = RunService.RenderStepped:Connect(function()
        if isSelecting and Mouse.Target then
            currentHighlight.Parent = Mouse.Target
        else
            currentHighlight.Parent = nil
        end
    end)
    
    -- Исправлено: проверка на существование Target
    Mouse.Button1Down:Connect(function()
        if isSelecting and Mouse.Target then
            local target = Mouse.Target
            NameLabel.Text = "Имя: " .. target.Name .. " [" .. target.ClassName .. "]"
            PathLabel.Text = getCleanPath(target)
            updateChildrenList(target)
            
            -- Безопасное копирование в буфер
            pcall(function()
                setclipboard(getCleanPath(target))
            end)
            
            isSelecting = false
            ToggleSelector.Text = "СКАНЕР: ВЫКЛ (НАЖМИ)"
            ToggleSelector.BackgroundColor3 = Colors.Button
            ToggleSelector.TextColor3 = Color3.fromRGB(100, 100, 120)
        end
    end)
    
    ToggleSelector.MouseButton1Click:Connect(function()
        isSelecting = not isSelecting
        if isSelecting then
            ToggleSelector.Text = "НАВЕДИ И НАЖМИ НА ОБЪЕКТ"
            ToggleSelector.BackgroundColor3 = Colors.ButtonHover
            ToggleSelector.TextColor3 = Colors.Text
        else
            ToggleSelector.Text = "СКАНЕР: ВЫКЛ (НАЖМИ)"
            ToggleSelector.BackgroundColor3 = Colors.Button
            ToggleSelector.TextColor3 = Color3.fromRGB(100, 100, 120)
        end
    end)
end)

-- ТОЧКИ С НУМПАДОМ (исправлено)
CreateButton("📍", "ТОЧКИ ТЕЛЕПОРТА", function()
    local frame = CreateWindow("📍 ТОЧКИ (Numpad 1-9)", 300, 300, 100)
    
    local createBtn = Instance.new("TextButton")
    createBtn.Size = UDim2.new(0.9, 0, 0, 35)
    createBtn.Position = UDim2.new(0.05, 0, 0, 40)
    createBtn.BackgroundColor3 = Colors.Button
    createBtn.Text = "➕ СОЗДАТЬ ТОЧКУ"
    createBtn.TextColor3 = Colors.Text
    createBtn.Font = Enum.Font.GothamBold
    createBtn.TextSize = 12
    createBtn.Parent = frame
    
    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(0.9, 0, 0, 220)
    list.Position = UDim2.new(0.05, 0, 0, 80)
    list.BackgroundColor3 = Colors.ScrollBg
    list.ScrollBarThickness = 5
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.Parent = frame
    
    local function refresh()
        -- Очищаем список
        for _, child in ipairs(list:GetChildren()) do 
            if child:IsA("Frame") then
                child:Destroy() 
            end
        end
        
        local y = 5
        for i, point in ipairs(CustomPoints) do
            local idx = i
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -10, 0, 32)
            container.Position = UDim2.new(0, 5, 0, y)
            container.BackgroundColor3 = Colors.Button
            container.Parent = list
            
            local tpBtn = Instance.new("TextButton")
            tpBtn.Size = UDim2.new(0.7, 0, 1, 0)
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
            renameBtn.Size = UDim2.new(0.15, 0, 1, 0)
            renameBtn.Position = UDim2.new(0.7, 0, 0, 0)
            renameBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
            renameBtn.Text = "✏️"
            renameBtn.TextSize = 11
            renameBtn.Parent = container
            
            renameBtn.MouseButton1Click:Connect(function()
                local renameFrame = CreateWindow("✏️ ПЕРЕИМЕНОВАТЬ", 250, 100, 200)
                
                local textBox = Instance.new("TextBox")
                textBox.Size = UDim2.new(0.9, 0, 0, 30)
                textBox.Position = UDim2.new(0.05, 0, 0, 40)
                textBox.BackgroundColor3 = Colors.Input
                textBox.Text = point.Name
                textBox.TextColor3 = Colors.Text
                textBox.Font = Enum.Font.Gotham
                textBox.TextSize = 12
                textBox.ClearTextOnFocus = false
                textBox.Parent = renameFrame
                
                local okBtn = Instance.new("TextButton")
                okBtn.Size = UDim2.new(0.45, 0, 0, 25)
                okBtn.Position = UDim2.new(0.05, 0, 0, 75)
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
                cancelBtn.Position = UDim2.new(0.55, 0, 0, 75)
                cancelBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 200)
                cancelBtn.Text = "❌ Отмена"
                cancelBtn.TextColor3 = Colors.Text
                cancelBtn.Font = Enum.Font.GothamBold
                cancelBtn.TextSize = 10
                cancelBtn.Parent = renameFrame
                
                cancelBtn.MouseButton1Click:Connect(function()
                    renameFrame:Destroy()
                end)
            end)
            
            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0.15, 0, 1, 0)
            delBtn.Position = UDim2.new(0.85, 0, 0, 0)
            delBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
            delBtn.Text = "🗑️"
            delBtn.TextSize = 11
            delBtn.Parent = container
            delBtn.MouseButton1Click:Connect(function()
                table.remove(CustomPoints, idx)
                refresh()
            end)
            
            y += 37
        end
        
        list.CanvasSize = UDim2.new(0, 0, 0, math.max(y + 5, 220))
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
    local frame = CreateWindow("👤 ТП К ИГРОКУ", 250, 350, 100)
    
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
    tpBtn.Text = "🚀 ТЕЛЕПОРТИРОВАТЬСЯ"
    tpBtn.TextColor3 = Colors.Text
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 12
    tpBtn.Parent = frame
    tpBtn.MouseButton1Click:Connect(function() 
        local success = TeleportToPlayer(tb.Text)
        if not success then
            -- Показываем ошибку
            tpBtn.Text = "❌ ИГРОК НЕ НАЙДЕН"
            wait(1)
            tpBtn.Text = "🚀 ТЕЛЕПОРТИРОВАТЬСЯ"
        end
    end)
    
    local quickLabel = Instance.new("TextLabel")
    quickLabel.Size = UDim2.new(0.9, 0, 0, 20)
    quickLabel.Position = UDim2.new(0.05, 0, 0, 110)
    quickLabel.BackgroundColor3 = Colors.TitleBar
    quickLabel.Text = "⚡ БЫСТРЫЙ ТП:"
    quickLabel.TextColor3 = Colors.Text
    quickLabel.Font = Enum.Font.GothamBold
    quickLabel.TextSize = 10
    quickLabel.Parent = frame
    
    local quickList = Instance.new("ScrollingFrame")
    quickList.Size = UDim2.new(0.9, 0, 0, 100)
    quickList.Position = UDim2.new(0.05, 0, 0, 135)
    quickList.BackgroundColor3 = Colors.ScrollBg
    quickList.ScrollBarThickness = 5
    quickList.CanvasSize = UDim2.new(0, 0, 0, #QuickPlayers * 35)
    quickList.Parent = frame
    
    for i, pName in ipairs(QuickPlayers) do
        local qBtn = Instance.new("TextButton")
        qBtn.Size = UDim2.new(1, -10, 0, 30)
        qBtn.Position = UDim2.new(0, 5, 0, (i-1) * 35 + 5)
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
    serverLabel.Position = UDim2.new(0.05, 0, 0, 240)
    serverLabel.BackgroundColor3 = Colors.TitleBar
    serverLabel.Text = "👥 ИГРОКИ НА СЕРВЕРЕ:"
    serverLabel.TextColor3 = Colors.Text
    serverLabel.Font = Enum.Font.GothamBold
    serverLabel.TextSize = 10
    serverLabel.Parent = frame
    
    local serverList = Instance.new("ScrollingFrame")
    serverList.Size = UDim2.new(0.9, 0, 0, 90)
    serverList.Position = UDim2.new(0.05, 0, 0, 260)
    serverList.BackgroundColor3 = Colors.ScrollBg
    serverList.ScrollBarThickness = 5
    serverList.CanvasSize = UDim2.new(0, 0, 0, 0)
    serverList.Parent = frame
    
    local sy = 5
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local sBtn = Instance.new("TextButton")
            sBtn.Size = UDim2.new(1, -10, 0, 30)
            sBtn.Position = UDim2.new(0, 5, 0, sy)
            sBtn.BackgroundColor3 = Colors.Button
            sBtn.Text = "👤 " .. p.Name
            sBtn.TextColor3 = Colors.Text
            sBtn.Font = Enum.Font.Gotham
            sBtn.TextSize = 11
            sBtn.Parent = serverList
            sBtn.MouseButton1Click:Connect(function() 
                tb.Text = p.Name 
            end)
            sy += 35
        end
    end
    serverList.CanvasSize = UDim2.new(0, 0, 0, sy + 5)
end)

CreateButton("🎮", "ИГРЫ", function()
    local frame = CreateWindow("🎮 ИГРЫ", 250, 150, 100)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, 45)
    btn.BackgroundColor3 = Colors.Button
    btn.Text = "🏚️ ВЫЖИВАНИЕ НА ЗАДНИХ УЛИЦАХ"
    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = frame
end)

CreateButton("⚙️", "НАСТРОЙКИ", function()
    local frame = CreateWindow("⚙️ НАСТРОЙКИ КЛАВИШ", 300, 250, 100)
    
    local names = {
        HideGUI = "👁️ Скрыть", 
        Fly = "✈️ Полёт", 
        Noclip = "👻 Ноклип", 
        TPMouse = "🖱️ ТП мышь", 
        CopyCoords = "📋 Координаты", 
        ESP = "🔴 ESP"
    }
    
    local y = 40
    for key, display in pairs(names) do
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.5, 0, 0, 30)
        lbl.Position = UDim2.new(0.05, 0, 0, y)
        lbl.BackgroundColor3 = Colors.Button
        lbl.Text = display
        lbl.TextColor3 = Colors.Text
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.Parent = frame
        
        local keyBtn = Instance.new("TextButton")
        keyBtn.Size = UDim2.new(0.4, 0, 0, 30)
        keyBtn.Position = UDim2.new(0.55, 0, 0, y)
        keyBtn.BackgroundColor3 = Colors.Button
        keyBtn.Text = Keys[key].Name
        keyBtn.TextColor3 = Colors.Text
        keyBtn.Font = Enum.Font.GothamBold
        keyBtn.TextSize = 10
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
        
        y += 35
    end
end)

-- Обработка возрождения персонажа
LocalPlayer.CharacterAdded:Connect(function(char)
    if SpawnPoint then
        wait(0.5)
        local root = char:WaitForChild("HumanoidRootPart")
        if root then 
            root.CFrame = SpawnPoint 
        end
    end
    
    -- Обновляем ссылку на персонажа
    character = char
end)

-- Исправленные горячие клавиши с защитой от повторного срабатывания
UserInputService.InputBegan:Connect(function(input, gp)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    
    -- Защита от удержания клавиши
    if KeyCooldown[input.KeyCode] and tick() - KeyCooldown[input.KeyCode] < 0.5 then
        return
    end
    
    KeyCooldown[input.KeyCode] = tick()
    
    -- Скрытие GUI
    if input.KeyCode == Keys.HideGUI then
        GUIHidden = not GUIHidden
        for _, child in ipairs(ScreenGui:GetChildren()) do
            if child:IsA("Frame") then 
                child.Visible = not GUIHidden 
            end
        end
    end
    
    -- Не обрабатываем при вводе текста
    if gp then return end
    
    -- Функциональные клавиши
    if input.KeyCode == Keys.Fly then 
        ToggleFly() 
    end
    
    if input.KeyCode == Keys.Noclip then 
        ToggleNoclip() 
    end
    
    if input.KeyCode == Keys.ESP then 
        ToggleESP() 
    end
    
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
    
    -- НУМПАД (только нумпад, не цифры сверху)
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
    
    -- Быстрый ТП на F1-F6
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

-- Очистка при выходе
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
    if FlyConnection then FlyConnection:Disconnect() end
    if NoclipConnection then NoclipConnection:Disconnect() end
    if ESPConnection then ESPConnection:Disconnect() end
    if ScannerConnection then ScannerConnection:Disconnect() end
end)

print("Solaris GUI v" .. Version .. " готов!")
print("Нумпад 1-9 работает! Сканер полный! Баги исправлены!")
