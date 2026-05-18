local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lPlayer = Players.LocalPlayer

-- Генерація випадкового імені для захисту інтерфейсу
local screenGui = Instance.new("ScreenGui", lPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "KrazorCore_" .. math.random(1000, 9999)
screenGui.ResetOnSpawn = false

-- Головне меню (Темний мінімалізм)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 240)
mainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Active = true
mainFrame.Draggable = true

-- Верхня панель меню
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -10, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "KRAZOR // ADMIN_CORE"
title.TextColor3 = Color3.fromRGB(180, 180, 180)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.Code
title.TextSize = 13
title.BackgroundTransparency = 1

---------------------------------------------------------
-- НАЛАШТУВАННЯ ТА ЗМІННІ
---------------------------------------------------------
local flying = false
local noclip = false
local flySpeed = 40

local upPressed = false
local downPressed = false

-- КНОПКА: FLY
local flyBtn = Instance.new("TextButton", mainFrame)
flyBtn.Size = UDim2.new(0.9, 0, 0, 35)
flyBtn.Position = UDim2.new(0.05, 0, 0.16, 0)
flyBtn.Text = "FLY: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
flyBtn.TextColor3 = Color3.fromRGB(180, 50, 50)
flyBtn.Font = Enum.Font.Code
flyBtn.TextSize = 13
flyBtn.BorderColor3 = Color3.fromRGB(35, 35, 35)

-- КНОПКА: NOCLIP
local noclipBtn = Instance.new("TextButton", mainFrame)
noclipBtn.Size = UDim2.new(0.9, 0, 0, 35)
noclipBtn.Position = UDim2.new(0.05, 0, 0.34, 0)
noclipBtn.Text = "NOCLIP: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
noclipBtn.TextColor3 = Color3.fromRGB(180, 50, 50)
noclipBtn.Font = Enum.Font.Code
noclipBtn.TextSize = 13
noclipBtn.BorderColor3 = Color3.fromRGB(35, 35, 35)

-- ТЕКСТ ШВИДКОСТІ
local speedLabel = Instance.new("TextLabel", mainFrame)
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0.52, 0)
speedLabel.Text = "FLY SPEED: " .. flySpeed
speedLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
speedLabel.Font = Enum.Font.Code
speedLabel.TextSize = 12
speedLabel.BackgroundTransparency = 1

-- КНОПКИ ЗМІНИ ШВИДКОСТІ
local speedUp = Instance.new("TextButton", mainFrame)
speedUp.Size = UDim2.new(0.42, 0, 0, 30)
speedUp.Position = UDim2.new(0.05, 0, 0.63, 0)
speedUp.Text = "[ + ] SPEED"
speedUp.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
speedUp.TextColor3 = Color3.fromRGB(180, 180, 180)
speedUp.Font = Enum.Font.Code
speedUp.TextSize = 12

local speedDown = Instance.new("TextButton", mainFrame)
speedDown.Size = UDim2.new(0.42, 0, 0, 30)
speedDown.Position = UDim2.new(0.53, 0, 0.63, 0)
speedDown.Text = "[ - ] SPEED"
speedDown.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
speedDown.TextColor3 = Color3.fromRGB(180, 180, 180)
speedDown.Font = Enum.Font.Code
speedDown.TextSize = 12

-- ІНСТРУКЦІЯ ЗАСТОСУВАННЯ ВЕРТИКАЛЕЙ
local infoLabel = Instance.new("TextLabel", mainFrame)
infoLabel.Size = UDim2.new(0.9, 0, 0, 25)
infoLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
infoLabel.Text = "[E] - ЛЕТІТИ ВГОРУ || [Q] - ВНИЗ"
infoLabel.TextColor3 = Color3.fromRGB(90, 90, 90)
infoLabel.Font = Enum.Font.Code
infoLabel.TextSize = 11
infoLabel.BackgroundTransparency = 1

---------------------------------------------------------
-- ЛОГІКА РОБОТИ СКРИПТУ
---------------------------------------------------------

-- Регулювання швидкості
speedUp.MouseButton1Click:Connect(function()
    flySpeed = math.min(flySpeed + 10, 150)
    speedLabel.Text = "FLY SPEED: " .. flySpeed
end)

speedDown.MouseButton1Click:Connect(function()
    flySpeed = math.max(flySpeed - 10, 10)
    speedLabel.Text = "FLY SPEED: " .. flySpeed
end)

-- Зчитування клавіш висоти
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then upPressed = true end
    if input.KeyCode == Enum.KeyCode.Q then downPressed = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then upPressed = false end
    if input.KeyCode == Enum.KeyCode.Q then downPressed = false end
end)

-- Робота NOCLIP (Щокадру вимикаємо колізію)
RunService.Stepped:Connect(function()
    if noclip and lPlayer.Character then
        for _, part in pairs(lPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    if noclip then
        noclipBtn.Text = "NOCLIP: ACTIVE"
        noclipBtn.TextColor3 = Color3.fromRGB(50, 180, 50)
    else
        noclipBtn.Text = "NOCLIP: OFF"
        noclipBtn.TextColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

-- Робота СТЕЛС-ПОЛЬОТУ через CFrame зміщення
RunService.RenderStepped:Connect(function(dt)
    if flying and lPlayer.Character and lPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lPlayer.Character.HumanoidRootPart
        local humanoid = lPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            hrp.Velocity = Vector3.new(0, 0, 0) -- Ховаємо фізичну швидкість від сервера
            
            local moveDirection = humanoid.MoveDirection
            local displacement = Vector3.new(0, 0, 0)
            
            -- Рух по площині (W, A, S, D)
            if moveDirection.Magnitude > 0 then
                displacement = displacement + (moveDirection * flySpeed * dt)
            end
            
            -- Підйом та спуск (E / Q)
            if upPressed then
                displacement = displacement + Vector3.new(0, flySpeed * dt, 0)
            end
            if downPressed then
                displacement = displacement + Vector3.new(0, -flySpeed * dt, 0)
            end
            
            -- Оновлюємо позицію
            hrp.CFrame = hrp.CFrame + displacement
        end
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyBtn.Text = "FLY: ACTIVE"
        flyBtn.TextColor3 = Color3.fromRGB(50, 180, 50)
    else
        flyBtn.Text = "FLY: OFF"
        flyBtn.TextColor3 = Color3.fromRGB(180, 50, 50)
        if lPlayer.Character and lPlayer.Character:FindFirstChild("HumanoidRootPart") then
            lPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)