-- Solaris GUI v16.2 (Key + Links)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local KEY = "SIGMA-PASHA"
local isActivated = false
local isEnabled = true

-- Окно ключа
local KeyScreenGui = Instance.new("ScreenGui")
KeyScreenGui.Name = "KeyGUI"
KeyScreenGui.ResetOnSpawn = false
KeyScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 250, 0, 120)
KeyFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
KeyFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = KeyScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 10)
KeyCorner.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 30)
KeyTitle.BackgroundColor3 = Color3.fromRGB(230, 230, 240)
KeyTitle.Text = "🔑 ВВЕДИТЕ КЛЮЧ"
KeyTitle.TextColor3 = Color3.fromRGB(30, 30, 40)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 12
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.9, 0, 0, 30)
KeyInput.Position = UDim2.new(0.05, 0, 0, 35)
KeyInput.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
KeyInput.PlaceholderText = "Введите ключ..."
KeyInput.TextColor3 = Color3.fromRGB(30, 30, 40)
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 11
KeyInput.Parent = KeyFrame

local KeyButton = Instance.new("TextButton")
KeyButton.Size = UDim2.new(0.9, 0, 0, 35)
KeyButton.Position = UDim2.new(0.05, 0, 0, 70)
KeyButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
KeyButton.Text = "✅ АКТИВИРОВАТЬ"
KeyButton.TextColor3 = Color3.fromRGB(30, 30, 40)
KeyButton.Font = Enum.Font.GothamBold
KeyButton.TextSize = 11
KeyButton.Parent = KeyFrame

KeyButton.MouseButton1Click:Connect(function()
    if KeyInput.Text == KEY then
        isActivated = true
        KeyScreenGui:Destroy()
        print("✅ Ключ активирован!")
        loadGUI()
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "❌ НЕВЕРНЫЙ КЛЮЧ!"
    end
end)

function loadGUI()
    local Mouse = LocalPlayer:GetMouse()
    local SpawnPoint = nil
    local CustomPoints = {}
    local GUIHidden = false
    local Version = "16.2"

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
    local FlySettings = {Speed = 50, MinSpeed = 10, MaxSpeed = 500}
    local AutoClickerSettings = {Speed = 10, MinSpeed = 1, MaxSpeed = 50}
    local QuickPlayers = {"Dfgvmg456", "minti", "pro_GREEN001", "Wr_White", "pasha999938", "Dfgvmg2"}

    local Keys = {
        HideGUI = Enum.KeyCode.RightShift,
        Fly = Enum.KeyCode.KeypadZero,
        Noclip = Enum.KeyCode.N,
        TPMouse = Enum.KeyCode.V,
        CopyCoords = Enum.KeyCode.C,
        ESP = Enum.KeyCode.X,
        AutoClicker = Enum.KeyCode.LeftBracket,
        AutoClickerSpeed = Enum.KeyCode.Equals,
        ToggleAll = Enum.KeyCode.LeftAlt,
        Aim = Enum.KeyCode.B,
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

    local function isMouseOverGUI()
        local mousePos = UserInputService:GetMouseLocation()
        for _, child in ipairs(ScreenGui:GetChildren()) do
            if child:IsA("Frame") and child.Visible then
                local guiPos = child.AbsolutePosition
                local guiSize = child.AbsoluteSize
                if mousePos.X >= guiPos.X and mousePos.X <= guiPos.X + guiSize.X and
                   mousePos.Y >= guiPos.Y and mousePos.Y <= guiPos.Y + guiSize.Y then return true end
            end
        end
        return false
    end

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
                frame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
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
    MainFrame.Size = UDim2.new(0, 260, 0, 290)
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
        if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil FlyEnabled = false end
        if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil NoclipEnabled = false end
        if ESPConnection then ESPConnection:Disconnect() ESPConnection = nil ESPEnabled = false end
        if ScannerConnection then ScannerConnection:Disconnect() ScannerConnection = nil end
        if AutoClickerConnection then AutoClickerConnection:Disconnect() AutoClickerConnection = nil AutoClickerEnabled = false end
        MainFrame.Visible = false
        GUIHidden = true
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
        if not isEnabled then return end
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
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection -= camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection -= camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection -= Vector3.new(0, 1, 0) end
                if moveDirection.Magnitude > 0 then
                    moveDirection = moveDirection.Unit
                    rootPart.Velocity = moveDirection * FlySettings.Speed
                else
                    rootPart.Velocity = Vector3.zero
                end
            end)
        else
            if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
            local char = getCharacter()
            if char and char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
        end
    end

    local function ToggleNoclip()
        if not isEnabled then return end
        NoclipEnabled = not NoclipEnabled
        if NoclipEnabled then
            if NoclipConnection then NoclipConnection:Disconnect() end
            NoclipConnection = RunService.Stepped:Connect(function()
                local char = getCharacter()
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil end
            local char = getCharacter()
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end

    local function ToggleESP()
        if not isEnabled then return end
        ESPEnabled = not ESPEnabled
        if ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local function setupHighlight(character)
                        if not character then return end
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "DeltaESP"
                        highlight.FillTransparency = 0.4
                        highlight.OutlineTransparency = 0.1
                        highlight.FillColor = Color3.fromRGB(0, 255, 150)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.Parent = character
                    end
                    setupHighlight(player.Character)
                    player.CharacterAdded:Connect(function(char)
                        task.wait(0.2)
                        setupHighlight(char)
                    end)
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild("DeltaESP")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end

    local function ToggleAutoClicker()
        if not isEnabled then return end
        AutoClickerEnabled = not AutoClickerEnabled
        if AutoClickerEnabled then
            if AutoClickerConnection then AutoClickerConnection:Disconnect() end
            local lastClick = 0
            AutoClickerConnection = RunService.RenderStepped:Connect(function(deltaTime)
                lastClick += deltaTime
                local delay = 1 / AutoClickerSettings.Speed
                if lastClick >= delay then
                    if not isMouseOverGUI() then
                        lastClick = 0
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
                    end
                end
            end)
        else
            if AutoClickerConnection then AutoClickerConnection:Disconnect() AutoClickerConnection = nil end
        end
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
        Button.MouseEnter:Connect(function() Button.BackgroundColor3 = Colors.ButtonHover end)
        Button.MouseLeave:Connect(function() Button.BackgroundColor3 = Colors.Button end)
        Button.MouseButton1Click:Connect(callback)
        yPos += 40
        return Button
    end

    CreateButton("💾", "СОХРАНИТЬ СПАВН", function()
        if not isEnabled then return end
        local char = getCharacter()
        if char and char:FindFirstChild("HumanoidRootPart") then
            SpawnPoint = char.HumanoidRootPart.CFrame
        end
    end)

    CreateButton("🔍", "СКАНЕР ПАРТ", function()
        if not isEnabled then return end
        local ScannerFrame = CreateWindow("ScannerWindow", "🔍 СКАНЕР", 320, 340)
        local isSelecting = false
        local currentHighlight = Instance.new("Highlight")
        local ToggleSelector = Instance.new("TextButton")
        ToggleSelector.Size = UDim2.new(0.9, 0, 0, 35)
        ToggleSelector.Position = UDim2.new(0.05, 0, 0, 40)
        ToggleSelector.BackgroundColor3 = Colors.Button
        ToggleSelector.Text = "СКАНЕР: ВЫКЛ (НАЖМИ)"
        ToggleSelector.TextColor3 = Colors.Text
        ToggleSelector.Font = Enum.Font.GothamBold
        ToggleSelector.TextSize = 11
        ToggleSelector.Parent = ScannerFrame
        if ScannerConnection then ScannerConnection:Disconnect() end
        ScannerConnection = RunService.RenderStepped:Connect(function()
            if isSelecting and Mouse.Target then currentHighlight.Parent = Mouse.Target else currentHighlight.Parent = nil end
        end)
        Mouse.Button1Down:Connect(function()
            if isSelecting and Mouse.Target then
                pcall(function() setclipboard(tostring(Mouse.Target)) end)
                isSelecting = false
                ToggleSelector.Text = "СКАНЕР: ВЫКЛ (НАЖМИ)"
            end
        end)
        ToggleSelector.MouseButton1Click:Connect(function()
            isSelecting = not isSelecting
            if isSelecting then ToggleSelector.Text = "НАВЕДИ И НАЖМИ" else ToggleSelector.Text = "СКАНЕР: ВЫКЛ (НАЖМИ)" end
        end)
    end)

    CreateButton("📍", "ТОЧКИ ТЕЛЕПОРТА", function()
        if not isEnabled then return end
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
        list.Parent = frame
        local function refresh()
            for _, child in ipairs(list:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
            local y = 3
            for i, point in ipairs(CustomPoints) do
                local idx = i
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, -8, 0, 30)
                container.Position = UDim2.new(0, 4, 0, y)
                container.BackgroundColor3 = Colors.Button
                container.Parent = list
                local tpBtn = Instance.new("TextButton")
                tpBtn.Size = UDim2.new(0.55, 0, 1, 0)
                tpBtn.BackgroundColor3 = Colors.Button
                tpBtn.Text = idx .. ". " .. point.Name
                tpBtn.TextColor3 = Colors.Text
                tpBtn.Font = Enum.Font.GothamBold
                tpBtn.TextSize = 9
                tpBtn.Parent = container
                tpBtn.MouseButton1Click:Connect(function() SmoothTP(point.CFrame) end)
                local renameBtn = Instance.new("TextButton")
                renameBtn.Size = UDim2.new(0.2, 0, 1, 0)
                renameBtn.Position = UDim2.new(0.55, 0, 0, 0)
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
                    cancelBtn.MouseButton1Click:Connect(function() renameFrame:Destroy() end)
                end)
                local delBtn = Instance.new("TextButton")
                delBtn.Size = UDim2.new(0.25, 0, 1, 0)
                delBtn.Position = UDim2.new(0.75, 0, 0, 0)
                delBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
                delBtn.Text = "🗑️"
                delBtn.TextSize = 10
                delBtn.Parent = container
                delBtn.MouseButton1Click:Connect(function() table.remove(CustomPoints, idx) refresh() end)
                y += 33
            end
            list.CanvasSize = UDim2.new(0, 0, 0, math.max(y + 3, 225))
        end
        createBtn.MouseButton1Click:Connect(function()
            local char = getCharacter()
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                local newPoint = {Name = string.format("%d,%d,%d", math.round(pos.X), math.round(pos.Y), math.round(pos.Z)), CFrame = char.HumanoidRootPart.CFrame}
                table.insert(CustomPoints, newPoint)
                refresh()
            end
        end)
        refresh()
    end)

    CreateButton("👤", "ТП К ИГРОКУ", function()
        if not isEnabled then return end
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
        tpBtn.MouseButton1Click:Connect(function() TeleportToPlayer(tb.Text) end)
        local serverList = Instance.new("ScrollingFrame")
        serverList.Size = UDim2.new(0.9, 0, 0, 240)
        serverList.Position = UDim2.new(0.05, 0, 0, 115)
        serverList.BackgroundColor3 = Colors.ScrollBg
        serverList.ScrollBarThickness = 4
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
                sBtn.MouseButton1Click:Connect(function() tb.Text = p.Name end)
                sy += 33
            end
        end
        serverList.CanvasSize = UDim2.new(0, 0, 0, sy + 3)
    end)

    CreateButton("🎮", "ИГРЫ", function()
        local frame = CreateWindow("GamesWindow", "🎮 ИГРЫ", 300, 200)
        
        local shipBtn = Instance.new("TextButton")
        shipBtn.Size = UDim2.new(0.9, 0, 0, 40)
        shipBtn.Position = UDim2.new(0.05, 0, 0, 45)
        shipBtn.BackgroundColor3 = Colors.Button
        shipBtn.Text = "🚢 ПОСТРОЙ КОРАБЛЬ"
        shipBtn.TextColor3 = Colors.Text
        shipBtn.Font = Enum.Font.GothamBold
        shipBtn.TextSize = 10
        shipBtn.Parent = frame
        
        local survivalBtn = Instance.new("TextButton")
        survivalBtn.Size = UDim2.new(0.9, 0, 0, 40)
        survivalBtn.Position = UDim2.new(0.05, 0, 0, 95)
        survivalBtn.BackgroundColor3 = Colors.Button
        survivalBtn.Text = "🏚️ ВЫЖИВАНИЕ НА ЗАДНИХ УЛИЦАХ"
        survivalBtn.TextColor3 = Colors.Text
        survivalBtn.Font = Enum.Font.GothamBold
        survivalBtn.TextSize = 10
        survivalBtn.Parent = frame
        
        local shipLoading = false
        shipBtn.MouseButton1Click:Connect(function()
            if shipLoading then return end
            shipLoading = true
            shipBtn.Text = "⏳ ЗАГРУЗКА..."
            task.spawn(function()
                local success, err = pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/p99910346-eng/solaris/refs/heads/main/How%20to%20Build%20a%20Ship%20in%20Roblox"))()
                end)
                if not success then print("Ошибка: " .. tostring(err)) end
                shipBtn.Text = "🚢 ПОСТРОЙ КОРАБЛЬ"
                shipLoading = false
            end)
        end)
        
        local survivalLoading = false
        survivalBtn.MouseButton1Click:Connect(function()
            if survivalLoading then return end
            survivalLoading = true
            survivalBtn.Text = "⏳ ЗАГРУЗКА..."
            task.spawn(function()
                local success, err = pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/p99910346-eng/solaris/refs/heads/main/Backstreet%20Survival"))()
                end)
                if not success then print("Ошибка: " .. tostring(err)) end
                survivalBtn.Text = "🏚️ ВЫЖИВАНИЕ НА ЗАДНИХ УЛИЦАХ"
                survivalLoading = false
            end)
        end)
    end)

    CreateButton("⚙️", "НАСТРОЙКИ", function()
        local frame = CreateWindow("SettingsWindow", "⚙️ НАСТРОЙКИ", 300, 340)
        local names = {
            HideGUI = "👁️ Скрыть", Fly = "✈️ Полёт", Noclip = "👻 Ноклип",
            TPMouse = "🖱️ ТП мышь", CopyCoords = "📋 Координаты", ESP = "🔴 ESP",
            AutoClicker = "🖱️ Кликер", AutoClickerSpeed = "⚡ Скорость кликера",
            ToggleAll = "🔘 ALT вкл/выкл", Aim = "🎯 B аим"
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

    UserInputService.InputBegan:Connect(function(input, gp)
        if not isActivated then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if KeyCooldown[input.KeyCode] and tick() - KeyCooldown[input.KeyCode] < 0.3 then return end
        KeyCooldown[input.KeyCode] = tick()
        
        if input.KeyCode == Keys.ToggleAll then
            isEnabled = not isEnabled
            if isEnabled then
                print("✅ Скрипт включён")
            else
                print("❌ Скрипт выключен")
                if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil FlyEnabled = false end
                if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil NoclipEnabled = false end
                if ESPConnection then ESPConnection:Disconnect() ESPConnection = nil ESPEnabled = false end
                if AutoClickerConnection then AutoClickerConnection:Disconnect() AutoClickerConnection = nil AutoClickerEnabled = false end
            end
            return
        end
        
        if not isEnabled then return end
        
        if input.KeyCode == Keys.Aim then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/p99910346-eng/solaris/refs/heads/main/aim"))()
            return
        end
        
        if input.KeyCode == Keys.HideGUI then
            GUIHidden = not GUIHidden
            MainFrame.Visible = not GUIHidden
            for _, child in ipairs(ScreenGui:GetChildren()) do
                if child:IsA("Frame") and child ~= MainFrame then child.Visible = not GUIHidden end
            end
        end
        if gp then return end
        if input.KeyCode == Keys.Fly then ToggleFly() end
        if input.KeyCode == Keys.Noclip then ToggleNoclip() end
        if input.KeyCode == Keys.ESP then ToggleESP() end
        if input.KeyCode == Keys.AutoClicker then ToggleAutoClicker() end
        if input.KeyCode == Keys.AutoClickerSpeed then
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
                end
            end)
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
                pcall(function() setclipboard(string.format("Vector3.new(%d,%d,%d)", math.round(p.X), math.round(p.Y), math.round(p.Z))) end)
            end
        end
        local numpadPoints = {
            [Enum.KeyCode.KeypadOne] = 1, [Enum.KeyCode.KeypadTwo] = 2,
            [Enum.KeyCode.KeypadThree] = 3, [Enum.KeyCode.KeypadFour] = 4,
            [Enum.KeyCode.KeypadFive] = 5, [Enum.KeyCode.KeypadSix] = 6,
            [Enum.KeyCode.KeypadSeven] = 7, [Enum.KeyCode.KeypadEight] = 8,
            [Enum.KeyCode.KeypadNine] = 9,
        }
        if numpadPoints[input.KeyCode] then
            local pointIndex = numpadPoints[input.KeyCode]
            if CustomPoints[pointIndex] then SmoothTP(CustomPoints[pointIndex].CFrame) end
        end
        local quickTP = {
            [Enum.KeyCode.F1] = "Dfgvmg456", [Enum.KeyCode.F2] = "minti",
            [Enum.KeyCode.F3] = "pro_GREEN001", [Enum.KeyCode.F4] = "Wr_White",
            [Enum.KeyCode.F5] = "pasha999938", [Enum.KeyCode.F6] = "Dfgvmg2"
        }
        if quickTP[input.KeyCode] then TeleportToPlayer(quickTP[input.KeyCode]) end
    end)

    LocalPlayer.CharacterAdded:Connect(function(char)
        if SpawnPoint then
            wait(0.5)
            local root = char:WaitForChild("HumanoidRootPart")
            if root then root.CFrame = SpawnPoint end
        end
    end)

    print("Solaris GUI v" .. Version .. " загружен!")
    print("Ключ: SIGMA-PASHA")
    print("ALT - вкл/выкл | B - аим")
end
