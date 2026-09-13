-- Solaris Minesweeper - HARD 16x16 (GUI VERITY + MINIMIZE FIXED)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local ROWS = 16
local COLS = 16
local MINES = 50

local Colors = {
    Frame = Color3.fromRGB(255, 255, 255),
    TitleBar = Color3.fromRGB(230, 230, 240),
    Button = Color3.fromRGB(240, 240, 245),
    ButtonHover = Color3.fromRGB(220, 220, 230),
    Text = Color3.fromRGB(30, 30, 40),
    Closed = Color3.fromRGB(180, 180, 200),
    ClosedHover = Color3.fromRGB(160, 160, 185),
    Open = Color3.fromRGB(235, 235, 240),
    Mine = Color3.fromRGB(255, 100, 100),
    Flag = Color3.fromRGB(255, 200, 80),
    Numbers = {
        Color3.fromRGB(100, 100, 120),
        Color3.fromRGB(50, 100, 255),
        Color3.fromRGB(50, 160, 50),
        Color3.fromRGB(220, 50, 50),
        Color3.fromRGB(120, 50, 180),
        Color3.fromRGB(150, 80, 30),
        Color3.fromRGB(30, 160, 160),
        Color3.fromRGB(30, 30, 30),
        Color3.fromRGB(120, 120, 120),
    }
}

local old = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("SolarisMinesweeper")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolarisMinesweeper"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ================= ОКНО =================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 460, 0, 560)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -280)
MainFrame.BackgroundColor3 = Colors.Frame
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true   -- ← обрезает всё, что выходит за границы
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Colors.TitleBar
TitleBar.Text = "💣 СОЛАРИС САПЁР — СЛОЖНО 16×16"
TitleBar.TextColor3 = Colors.Text
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 13
TitleBar.Parent = MainFrame

Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

-- Кнопка "Свернуть" (—)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 22, 0, 22)
MinimizeButton.Position = UDim2.new(1, -55, 0, 6)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Colors.Text
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 12
MinimizeButton.Parent = TitleBar

Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 6)

-- Кнопка закрытия (✕)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 22, 0, 22)
CloseButton.Position = UDim2.new(1, -27, 0, 6)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Colors.Text
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 10
CloseButton.Parent = TitleBar

Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Перетаскивание
local isDragging = false
local dragStart = nil
local frameStart = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        frameStart = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement and dragStart and frameStart then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            frameStart.X.Scale, frameStart.X.Offset + delta.X,
            frameStart.Y.Scale, frameStart.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- ================= ИНФО =================
local InfoBar = Instance.new("Frame")
InfoBar.Size = UDim2.new(1, -20, 0, 40)
InfoBar.Position = UDim2.new(0, 10, 0, 45)
InfoBar.BackgroundColor3 = Colors.Button
InfoBar.BorderSizePixel = 0
InfoBar.Parent = MainFrame

Instance.new("UICorner", InfoBar).CornerRadius = UDim.new(0, 8)

local MinesLabel = Instance.new("TextLabel")
MinesLabel.Size = UDim2.new(0.33, 0, 1, 0)
MinesLabel.BackgroundTransparency = 1
MinesLabel.Text = "💣 " .. MINES
MinesLabel.TextColor3 = Colors.Text
MinesLabel.Font = Enum.Font.GothamBold
MinesLabel.TextSize = 13
MinesLabel.Parent = InfoBar

local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(0.33, 0, 0.8, 0)
ResetBtn.Position = UDim2.new(0.335, 0, 0.1, 0)
ResetBtn.BackgroundColor3 = Colors.ButtonHover
ResetBtn.Text = "🔄 ЗАНОВО"
ResetBtn.TextColor3 = Colors.Text
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.TextSize = 11
ResetBtn.Parent = InfoBar

Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(0.33, 0, 1, 0)
TimeLabel.Position = UDim2.new(0.67, 0, 0, 0)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "⏱️ 0"
TimeLabel.TextColor3 = Colors.Text
TimeLabel.Font = Enum.Font.GothamBold
TimeLabel.TextSize = 13
TimeLabel.Parent = InfoBar

-- ================= ПОЛЕ =================
local BoardFrame = Instance.new("Frame")
BoardFrame.Size = UDim2.new(1, -20, 0, 420)
BoardFrame.Position = UDim2.new(0, 10, 0, 95)
BoardFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 248)
BoardFrame.BorderSizePixel = 0
BoardFrame.Parent = MainFrame

Instance.new("UICorner", BoardFrame).CornerRadius = UDim.new(0, 8)

local CELL = 24
local PAD = 2
local gridW = COLS * CELL + (COLS - 1) * PAD
local gridH = ROWS * CELL + (ROWS - 1) * PAD

local GridHolder = Instance.new("Frame")
GridHolder.Size = UDim2.new(0, gridW, 0, gridH)
GridHolder.Position = UDim2.new(0.5, -gridW/2, 0.5, -gridH/2)
GridHolder.BackgroundTransparency = 1
GridHolder.Parent = BoardFrame

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, CELL, 0, CELL)
Grid.CellPadding = UDim2.new(0, PAD, 0, PAD)
Grid.SortOrder = Enum.SortOrder.LayoutOrder
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Left
Grid.VerticalAlignment = Enum.VerticalAlignment.Top
Grid.Parent = GridHolder

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 1, -40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "ЛКМ - открыть, ПКМ - флаг"
StatusLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.Parent = MainFrame

-- ================= КНОПКА "СВЕРНУТЬ" (после всех элементов) =================
local isMinimized = false
local savedSize = UDim2.new(0, 460, 0, 560)
local savedPosition = nil

local hideWhenMinimized = { InfoBar, BoardFrame, StatusLabel }

MinimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        -- РАЗВЕРНУТЬ
        MainFrame:TweenSizeAndPosition(
            savedSize,
            savedPosition or UDim2.new(0.5, -230, 0.5, -280),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
        isMinimized = false
        MinimizeButton.Text = "—"

        for _, el in ipairs(hideWhenMinimized) do
            if el then el.Visible = true end
        end
    else
        -- СВЕРНУТЬ
        for _, el in ipairs(hideWhenMinimized) do
            if el then el.Visible = false end
        end

        savedSize = MainFrame.Size
        savedPosition = MainFrame.Position

        MainFrame:TweenSizeAndPosition(
            UDim2.new(0, 460, 0, 35),
            MainFrame.Position,
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
        isMinimized = true
        MinimizeButton.Text = "▢"
    end
end)

-- ================= СОСТОЯНИЕ =================
local board = {}
local cellButtons = {}
local firstClick = true
local gameOver = false
local flagsPlaced = 0
local cellsOpened = 0
local timerValue = 0
local timerRunning = false
local timerConnection = nil

-- ================= УТИЛИТЫ =================
local function stopTimer()
    if timerConnection then
        timerConnection:Disconnect()
        timerConnection = nil
    end
    timerRunning = false
end

local function startTimer()
    if timerRunning then return end
    timerRunning = true
    timerValue = 0
    TimeLabel.Text = "⏱️ 0"
    timerConnection = RunService.Heartbeat:Connect(function(dt)
        if not timerRunning then return end
        timerValue += dt
        TimeLabel.Text = "⏱️ " .. math.floor(timerValue)
    end)
end

local function getNeighbors(r, c)
    local n = {}
    for dr = -1, 1 do
        for dc = -1, 1 do
            if not (dr == 0 and dc == 0) then
                local nr, nc = r + dr, c + dc
                if nr >= 1 and nr <= ROWS and nc >= 1 and nc <= COLS then
                    n[#n + 1] = {nr, nc}
                end
            end
        end
    end
    return n
end

local function updateMinesLabel()
    local rem = MINES - flagsPlaced
    if rem < 0 then rem = 0 end
    MinesLabel.Text = "💣 " .. rem
end

local function countNeighbors(r, c)
    local cnt = 0
    for _, n in ipairs(getNeighbors(r, c)) do
        if board[n[1]][n[2]].mine then cnt = cnt + 1 end
    end
    return cnt
end

local function revealAllMines()
    for r = 1, ROWS do
        for c = 1, COLS do
            local cell = board[r][c]
            if cell.mine and not cell.flagged then
                local btn = cellButtons[r][c]
                btn.Text = "💣"
                btn.BackgroundColor3 = Colors.Mine
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end

-- ================= ВЕРИТИ (GUI-РИСУНОК ПРИ ПРОИГРЫШЕ) =================
local function showVerityScreen()
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 10
    overlay.Parent = ScreenGui

    TweenService:Create(overlay, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    task.wait(0.9)

    -- Контейнер для Верити
    local verity = Instance.new("Frame")
    verity.Size = UDim2.new(0, 0, 0, 0)
    verity.Position = UDim2.new(0.5, 0, 0.5, 0)
    verity.BackgroundColor3 = Color3.fromRGB(255, 210, 0)
    verity.BorderSizePixel = 0
    verity.ZIndex = 11
    verity.Parent = overlay

    Instance.new("UICorner", verity).CornerRadius = UDim.new(1, 0)

    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(120, 90, 0)
    outline.Thickness = 3
    outline.Transparency = 0.5
    outline.Parent = verity

    -- Левый глаз
    local leftEye = Instance.new("Frame")
    leftEye.Size = UDim2.new(0.14, 0, 0.20, 0)
    leftEye.Position = UDim2.new(0.30, 0, 0.30, 0)
    leftEye.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    leftEye.BorderSizePixel = 0
    leftEye.ZIndex = 12
    leftEye.Parent = verity

    Instance.new("UICorner", leftEye).CornerRadius = UDim.new(1, 0)

    -- Правый глаз
    local rightEye = Instance.new("Frame")
    rightEye.Size = UDim2.new(0.14, 0, 0.20, 0)
    rightEye.Position = UDim2.new(0.56, 0, 0.30, 0)
    rightEye.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    rightEye.BorderSizePixel = 0
    rightEye.ZIndex = 12
    rightEye.Parent = verity

    Instance.new("UICorner", rightEye).CornerRadius = UDim.new(1, 0)

    -- Улыбка
    local smileDots = {
        {x = 0.13, y = 0.56, s = 0.075},
        {x = 0.17, y = 0.62, s = 0.070},
        {x = 0.22, y = 0.67, s = 0.068},
        {x = 0.28, y = 0.71, s = 0.066},
        {x = 0.35, y = 0.74, s = 0.065},
        {x = 0.42, y = 0.755, s = 0.064},
        {x = 0.50, y = 0.76, s = 0.064},
        {x = 0.58, y = 0.755, s = 0.064},
        {x = 0.65, y = 0.74, s = 0.065},
        {x = 0.72, y = 0.71, s = 0.066},
        {x = 0.78, y = 0.67, s = 0.068},
        {x = 0.83, y = 0.62, s = 0.070},
        {x = 0.87, y = 0.56, s = 0.075},
    }

    for _, dot in ipairs(smileDots) do
        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(dot.s, 0, dot.s, 0)
        circle.Position = UDim2.new(dot.x, 0, dot.y, 0)
        circle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        circle.BorderSizePixel = 0
        circle.ZIndex = 13
        circle.Parent = verity

        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    end

    -- Появление
    TweenService:Create(verity, TweenInfo.new(1.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 400, 0, 400),
        Position = UDim2.new(0.5, -200, 0.5, -240)
    }):Play()

    task.wait(1.4)

    -- Текст "Ты... проиграл?.."
    local whisper = Instance.new("TextLabel")
    whisper.Size = UDim2.new(1, 0, 0, 40)
    whisper.Position = UDim2.new(0, 0, 0.75, 0)
    whisper.BackgroundTransparency = 1
    whisper.Text = "Ты... проиграл?.."
    whisper.TextColor3 = Color3.fromRGB(180, 30, 30)
    whisper.Font = Enum.Font.GothamBold
    whisper.TextSize = 26
    whisper.ZIndex = 15
    whisper.Parent = overlay

    whisper.TextTransparency = 1
    TweenService:Create(whisper, TweenInfo.new(1), {TextTransparency = 0}):Play()

    -- Тряска
    task.spawn(function()
        while verity.Parent do
            task.wait(0.05)
            verity.Rotation = math.random(-5, 5)
        end
    end)

    -- Моргание
    task.spawn(function()
        while verity.Parent do
            task.wait(math.random(2, 5))
            leftEye.Visible = false
            rightEye.Visible = false
            task.wait(0.08)
            leftEye.Visible = true
            rightEye.Visible = true
        end
    end)

    -- Приближение
    task.spawn(function()
        for i = 1, 5 do
            task.wait(0.7)
            if not verity.Parent then break end
            local newSize = 400 + i * 50
            TweenService:Create(verity, TweenInfo.new(0.3), {
                Size = UDim2.new(0, newSize, 0, newSize),
                Position = UDim2.new(0.5, -newSize/2, 0.5, -newSize/2 - 30)
            }):Play()
        end
    end)

    task.wait(2)

    -- Кнопка
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 260, 0, 50)
    closeBtn.Position = UDim2.new(0.5, -130, 0.87, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    closeBtn.Text = "💀 ПОПРОБОВАТЬ СНОВА"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 15
    closeBtn.ZIndex = 16
    closeBtn.Parent = overlay

    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

    closeBtn.MouseButton1Click:Connect(function()
        overlay:Destroy()
        buildBoard()
    end)

    -- Кнопка "Свернуть" Верити
    local minVerityBtn = Instance.new("TextButton")
    minVerityBtn.Size = UDim2.new(0, 40, 0, 40)
    minVerityBtn.Position = UDim2.new(0, 20, 0, 20)
    minVerityBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    minVerityBtn.Text = "—"
    minVerityBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minVerityBtn.Font = Enum.Font.GothamBold
    minVerityBtn.TextSize = 18
    minVerityBtn.ZIndex = 20
    minVerityBtn.Parent = overlay

    Instance.new("UICorner", minVerityBtn).CornerRadius = UDim.new(0, 8)

    -- Кнопка "Показать" (появляется когда свёрнуто)
    local showBtn = Instance.new("TextButton")
    showBtn.Size = UDim2.new(0, 60, 0, 60)
    showBtn.Position = UDim2.new(0, 20, 0, 20)
    showBtn.BackgroundColor3 = Color3.fromRGB(255, 210, 0)
    showBtn.Text = "👁️"
    showBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    showBtn.Font = Enum.Font.GothamBold
    showBtn.TextSize = 22
    showBtn.ZIndex = 20
    showBtn.Visible = false
    showBtn.Parent = ScreenGui

    Instance.new("UICorner", showBtn).CornerRadius = UDim.new(1, 0)

    minVerityBtn.MouseButton1Click:Connect(function()
        overlay.Visible = false
        showBtn.Visible = true
    end)

    showBtn.MouseButton1Click:Connect(function()
        overlay.Visible = true
        showBtn.Visible = false
    end)
end

-- ================= ЭКРАН ПОБЕДЫ =================
local function showWinScreen()
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 10
    overlay.Parent = ScreenGui

    TweenService:Create(overlay, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()

    task.wait(0.5)

    local winCard = Instance.new("Frame")
    winCard.Size = UDim2.new(0, 0, 0, 0)
    winCard.Position = UDim2.new(0.5, 0, 0.5, 0)
    winCard.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    winCard.BorderSizePixel = 0
    winCard.ZIndex = 11
    winCard.Parent = overlay

    Instance.new("UICorner", winCard).CornerRadius = UDim.new(0, 16)

    TweenService:Create(winCard, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 320, 0, 260),
        Position = UDim2.new(0.5, -160, 0.5, -130)
    }):Play()

    local emoji = Instance.new("TextLabel")
    emoji.Size = UDim2.new(1, 0, 0, 80)
    emoji.Position = UDim2.new(0, 0, 0, 10)
    emoji.BackgroundTransparency = 1
    emoji.Text = "🎉"
    emoji.TextSize = 60
    emoji.Font = Enum.Font.GothamBold
    emoji.ZIndex = 12
    emoji.Parent = winCard

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 90)
    title.BackgroundTransparency = 1
    title.Text = "ПОБЕДА!"
    title.TextColor3 = Color3.fromRGB(50, 180, 50)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 26
    title.ZIndex = 12
    title.Parent = winCard

    local timeText = Instance.new("TextLabel")
    timeText.Size = UDim2.new(1, 0, 0, 30)
    timeText.Position = UDim2.new(0, 0, 0, 130)
    timeText.BackgroundTransparency = 1
    timeText.Text = "⏱️ Время: " .. math.floor(timerValue) .. " сек"
    timeText.TextColor3 = Colors.Text
    timeText.Font = Enum.Font.GothamBold
    timeText.TextSize = 15
    timeText.ZIndex = 12
    timeText.Parent = winCard

    local playAgainBtn = Instance.new("TextButton")
    playAgainBtn.Size = UDim2.new(0.85, 0, 0, 40)
    playAgainBtn.Position = UDim2.new(0.075, 0, 0, 190)
    playAgainBtn.BackgroundColor3 = Color3.fromRGB(100, 220, 100)
    playAgainBtn.Text = "🔄 ИГРАТЬ ЕЩЁ"
    playAgainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    playAgainBtn.Font = Enum.Font.GothamBold
    playAgainBtn.TextSize = 14
    playAgainBtn.ZIndex = 12
    playAgainBtn.Parent = winCard

    Instance.new("UICorner", playAgainBtn).CornerRadius = UDim.new(0, 8)

    playAgainBtn.MouseButton1Click:Connect(function()
        overlay:Destroy()
        buildBoard()
    end)

    -- Конфетти
    task.spawn(function()
        local emojis = {"🎉", "✨", "🎊", "⭐", "💫", "🌟"}
        for i = 1, 30 do
            if not overlay.Parent then break end
            local confetti = Instance.new("TextLabel")
            confetti.Size = UDim2.new(0, 30, 0, 30)
            confetti.BackgroundTransparency = 1
            confetti.Text = emojis[math.random(1, #emojis)]
            confetti.TextSize = math.random(20, 35)
            confetti.Font = Enum.Font.GothamBold
            confetti.Position = UDim2.new(math.random(), 0, -0.1, 0)
            confetti.ZIndex = 15
            confetti.Parent = overlay

            local targetY = UDim2.new(confetti.Position.X.Scale, 0, 1.1, 0)
            local duration = math.random(20, 40) / 10

            TweenService:Create(confetti, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                Position = targetY,
                Rotation = math.random(-720, 720)
            }):Play()

            task.delay(duration + 0.1, function()
                if confetti and confetti.Parent then
                    confetti:Destroy()
                end
            end)
            task.wait(0.05)
        end
    end)
end

local function checkWin()
    if gameOver then return end
    local totalSafe = ROWS * COLS - MINES
    if cellsOpened >= totalSafe then
        gameOver = true
        stopTimer()
        StatusLabel.Text = "🎉 ПОБЕДА! Время: " .. math.floor(timerValue) .. "с"
        StatusLabel.TextColor3 = Color3.fromRGB(50, 180, 50)

        for r = 1, ROWS do
            for c = 1, COLS do
                local cell = board[r][c]
                if cell.mine and not cell.flagged then
                    cell.flagged = true
                    local btn = cellButtons[r][c]
                    btn.Text = "🚩"
                    btn.BackgroundColor3 = Colors.Flag
                end
            end
        end
        flagsPlaced = MINES
        updateMinesLabel()

        task.wait(0.5)
        showWinScreen()
    end
end

local function generateMines()
    for r = 1, ROWS do
        for c = 1, COLS do
            board[r][c].mine = false
            board[r][c].count = 0
        end
    end

    local cells = {}
    for r = 1, ROWS do
        for c = 1, COLS do
            cells[#cells + 1] = {r, c}
        end
    end

    for i = #cells, 2, -1 do
        local j = math.random(i)
        cells[i], cells[j] = cells[j], cells[i]
    end

    for i = 1, MINES do
        local p = cells[i]
        board[p[1]][p[2]].mine = true
    end

    for r = 1, ROWS do
        for c = 1, COLS do
            if not board[r][c].mine then
                board[r][c].count = countNeighbors(r, c)
            end
        end
    end
end

local function relocateMine(r, c)
    local safe = {}
    for rr = 1, ROWS do
        for cc = 1, COLS do
            if not board[rr][cc].mine then
                safe[#safe + 1] = {rr, cc}
            end
        end
    end
    if #safe == 0 then return end
    local pick = safe[math.random(1, #safe)]
    board[r][c].mine = false
    board[pick[1]][pick[2]].mine = true
end

local function makeSafeZone(sr, sc)
    if board[sr][sc].mine then
        relocateMine(sr, sc)
    end
    for _, n in ipairs(getNeighbors(sr, sc)) do
        if board[n[1]][n[2]].mine then
            relocateMine(n[1], n[2])
        end
    end
    for r = 1, ROWS do
        for c = 1, COLS do
            if not board[r][c].mine then
                board[r][c].count = countNeighbors(r, c)
            end
        end
    end
end

-- ================= ЛОГИКА =================
local function revealCell(r, c)
    if gameOver then return end
    local cell = board[r][c]
    if not cell or cell.opened or cell.flagged then return end

    if firstClick then
        firstClick = false
        makeSafeZone(r, c)
        startTimer()
    end

    local stack = {{r, c}}
    local visited = {}

    while #stack > 0 do
        local pos = table.remove(stack)
        local cr, cc = pos[1], pos[2]
        local key = cr .. "," .. cc
        if not visited[key] then
            visited[key] = true

            local cur = board[cr][cc]
            if cur and not cur.opened and not cur.flagged then
                cur.opened = true
                cellsOpened = cellsOpened + 1

                local btn = cellButtons[cr][cc]
                if btn then
                    if cur.mine then
                        btn.Text = "💣"
                        btn.BackgroundColor3 = Colors.Mine
                        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        gameOver = true
                        stopTimer()
                        StatusLabel.Text = "💥 БУМ! Игра окончена"
                        StatusLabel.TextColor3 = Color3.fromRGB(220, 50, 50)
                        revealAllMines()

                        task.wait(0.5)
                        showVerityScreen()
                        return
                    elseif cur.count > 0 then
                        btn.Text = tostring(cur.count)
                        btn.TextColor3 = Colors.Numbers[cur.count + 1] or Colors.Text
                        btn.BackgroundColor3 = Colors.Open
                    else
                        btn.Text = ""
                        btn.BackgroundColor3 = Colors.Open
                        for _, n in ipairs(getNeighbors(cr, cc)) do
                            local nb = board[n[1]][n[2]]
                            if nb and not nb.opened and not nb.flagged then
                                stack[#stack + 1] = n
                            end
                        end
                    end
                end
            end
        end
    end

    checkWin()
end

local function toggleFlag(r, c)
    if gameOver then return end
    local cell = board[r][c]
    if not cell or cell.opened then return end

    cell.flagged = not cell.flagged
    local btn = cellButtons[r][c]

    if cell.flagged then
        btn.Text = "🚩"
        btn.BackgroundColor3 = Colors.Flag
        flagsPlaced = flagsPlaced + 1
    else
        btn.Text = ""
        btn.BackgroundColor3 = Colors.Closed
        flagsPlaced = flagsPlaced - 1
    end

    updateMinesLabel()
end

-- ================= ПОСТРОЕНИЕ =================
function buildBoard()
    for _, child in ipairs(GridHolder:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    board = {}
    cellButtons = {}

    firstClick = true
    gameOver = false
    flagsPlaced = 0
    cellsOpened = 0
    timerValue = 0
    stopTimer()
    TimeLabel.Text = "⏱️ 0"
    updateMinesLabel()
    StatusLabel.Text = "ЛКМ - открыть, ПКМ - флаг"
    StatusLabel.TextColor3 = Color3.fromRGB(120, 120, 140)

    for r = 1, ROWS do
        board[r] = {}
        cellButtons[r] = {}
        for c = 1, COLS do
            board[r][c] = {mine = false, opened = false, flagged = false, count = 0}
        end
    end

    generateMines()

    for r = 1, ROWS do
        for c = 1, COLS do
            local btn = Instance.new("TextButton")
            btn.BackgroundColor3 = Colors.Closed
            btn.Text = ""
            btn.TextColor3 = Colors.Text
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            btn.AutoButtonColor = false
            btn.BorderSizePixel = 0
            btn.LayoutOrder = (r - 1) * COLS + c
            btn.Parent = GridHolder

            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

            local rr, cc = r, c

            btn.MouseButton1Click:Connect(function()
                revealCell(rr, cc)
            end)

            btn.MouseButton2Click:Connect(function()
                toggleFlag(rr, cc)
            end)

            btn.MouseEnter:Connect(function()
                local cell = board[rr][cc]
                if cell and not cell.opened and not gameOver then
                    if cell.flagged then
                        btn.BackgroundColor3 = Color3.fromRGB(255, 220, 120)
                    else
                        btn.BackgroundColor3 = Colors.ClosedHover
                    end
                end
            end)

            btn.MouseLeave:Connect(function()
                local cell = board[rr][cc]
                if cell and not cell.opened then
                    if cell.flagged then
                        btn.BackgroundColor3 = Colors.Flag
                    else
                        btn.BackgroundColor3 = Colors.Closed
                    end
                end
            end)

            cellButtons[r][c] = btn
        end
    end
end

ResetBtn.MouseButton1Click:Connect(function()
    buildBoard()
end)

buildBoard()

print("💣 Solaris Minesweeper (HARD 16×16) загружен!")
print("ЛКМ - открыть, ПКМ - флаг")
print("Кнопка [—] сворачивает окно. Проиграешь — придёт ВЕРИТИ 👁️")
