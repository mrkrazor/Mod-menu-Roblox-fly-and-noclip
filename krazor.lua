local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lPlayer = Players.LocalPlayer

-- Рандомна назва GUI для обходу перевірок античиту
local screenGui = Instance.new("ScreenGui", lPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "KrazorCore_" .. math.random(1000, 9999)
screenGui.ResetOnSpawn = false

---------------------------------------------------------
-- СТИЛЬНИЙ ІНТЕРФЕЙС (DEDSEC MINIMALISM)
---------------------------------------------------------
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 275)
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.Active = true
mainFrame.Draggable = true -- Можна перетягувати мишкою або пальцем

-- Топ-бар
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -10, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "KRAZOR // ALL-IN-ONE v3.5"
title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.Code
title.TextSize = 13
title.BackgroundTransparency = 1

---------------------------------------------------------
-- КОНТРОЛІ ТА КНОПКИ
---------------------------------------------------------
local flying = false
local noclip = false
local flySpeed = 50

local upPressed = false
local downPressed = false

-- КНОПКА: FLY
local flyBtn = Instance.new("TextButton", mainFrame)
flyBtn.Size = UDim2.new(0.9, 0, 0, 35)
flyBtn.Position = UDim2.new(0.05, 0, 0.14, 0)
flyBtn.Text = "FLY: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
flyBtn.TextColor3 = Color3.fromRGB(180, 50, 50)
flyBtn.Font = Enum.Font.Code
flyBtn.TextSize = 13
flyBtn.BorderColor3 = Color3.fromRGB(35, 35, 35)

-- КНОПКА: NOCLIP
local noclipBtn = Instance.new("TextButton", mainFrame)
noclipBtn.Size = UDim2.new(0.9, 0, 0, 35)
noclipBtn.Position = UDim2.new(0.05, 0, 0.29, 0)
noclipBtn.Text = "NOCLIP: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
noclipBtn.TextColor3 = Color3.fromRGB(180, 50, 50)
noclipBtn.Font = Enum.Font.Code
noclipBtn.TextSize = 13
noclipBtn.BorderColor3 = Color3.fromRGB(35, 35, 35)

-- ИНДИКАТОР ШВИДКОСТІ
local speedLabel = Instance.new("TextLabel", mainFrame)
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0.43, 0)
speedLabel.Text = "SPEED: " .. flySpeed
speedLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
speedLabel.Font = Enum.Font.Code
speedLabel.TextSize = 13
speedLabel.BackgroundTransparency = 1

-- КНОПКИ ЗМІНИ ШВИДКОСТІ
local speedDown = Instance.new("TextButton", mainFrame)
speedDown.Size = UDim2.new(0.42, 0, 0, 30)
speedDown.Position = UDim2.new(0.05, 0, 0.52, 0)
speedDown.Text = "[ - ] SPEED"
speedDown.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
speedDown.TextColor3 = Color3.fromRGB(200, 200, 200)
speedDown.Font = Enum.Font.Code
speedDown.TextSize = 12

local speedUp = Instance.new("TextButton", mainFrame)
speedUp.Size = UDim2.new(0.42, 0, 0, 30)
speedUp.Position = UDim2.new(0.53, 0, 0.52, 0)
speedUp.Text = "[ + ] SPEED"
speedUp.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
speedUp.TextColor3 = Color3.fromRGB(200, 200, 200)
speedUp.Font = Enum.Font.Code
speedUp.TextSize = 12

-- УНІВЕРСАЛЬНІ КНОПКИ ВИСОТИ UP/DOWN (Для тачу та кліків)
local mobileUp = Instance.new("TextButton", mainFrame)
mobileUp.Size = UDim2.new(0.42, 0, 0, 38)
mobileUp.Position = UDim2.new(0.05, 0, 0.67, 0)
mobileUp.Text = "▲ UP"
mobileUp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mobileUp.TextColor3 = Color3.fromRGB(220, 220, 220)
mobileUp.Font = Enum.Font.Code
mobileUp.TextSize = 13
mobileUp.BorderColor3 = Color3.fromRGB(45, 45, 45)

local mobileDown = Instance.new("TextButton", mainFrame)
mobileDown.Size = UDim2.new(0.42, 0, 0, 38)
mobileDown.Position = UDim2.new(0.53, 0, 0.67, 0)
mobileDown.Text = "▼ DOWN"
mobileDown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mobileDown.TextColor3 = Color3.fromRGB(220, 220, 220)
mobileDown.Font = Enum.Font.Code
mobileDown.TextSize = 13
mobileDown.BorderColor3 = Color3.fromRGB(45, 45, 45)

-- ПІДКАЗКА ДЛЯ ПК ТА НОУТБУКІВ
local infoLabel = Instance.new("TextLabel", mainFrame)
infoLabel.Size = UDim2.new(1, 0, 0, 20)
infoLabel.Position = UDim2.new(0, 0, 0.84, 0)
infoLabel.Text = "PC KEYBINDS: [E] UP / [Q] DOWN"
infoLabel.TextColor3 = Color3.fromRGB(90, 90, 90)
infoLabel.Font = Enum.Font.Code
infoLabel.TextSize = 10
infoLabel.BackgroundTransparency = 1

---------------------------------------------------------
-- ХАКЕРСЬКА ЛОГІКА ТА ОБХІД ЗАХИСТУ (BYPASS)
---------------------------------------------------------

-- Регулювання швидкості
speedUp.MouseButton1Click:Connect(function()
    flySpeed = math.min(flySpeed + 10, 150)
    speedLabel.Text = "SPEED: " .. flySpeed
end)

speedDown.MouseButton1Click:Connect(function()
    flySpeed = math.max(flySpeed - 10, 10)
    speedLabel.Text = "SPEED: " .. flySpeed
end)

-- 💻 ЗЧИТУВАННЯ КЛАВІАТУРИ (Для ПК та Ноутбуків)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then upPressed = true end
    if input.KeyCode == Enum.KeyCode.Q then downPressed = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then upPressed = false end
    if input.KeyCode == Enum.KeyCode.Q then downPressed = false end
end)

-- 📱 ЗЧИТУВАННЯ ЕКРАННИХ КНОПОК (Для телефонів та кліків мишкою)
mobileUp.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        upPressed = true
    end
end)
mobileUp.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        upPressed = false
    end
end)

mobileDown.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        downPressed = true
    end
end)
mobileDown.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        downPressed = false
    end
end)

-- СИСТЕМА NOCLIP (Щокадру вимикає колізію тіла)
RunService.Stepped:Connect(function()
    if noclip and lPlayer.Character then
        for _, part in pairs(lPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    if noclip then
        noclipBtn.Text = "NOCLIP: ACTIVE"; noclipBtn.TextColor3 = Color3.fromRGB(50, 180, 50)
    else
        noclipBtn.Text = "NOCLIP: OFF"; noclipBtn.TextColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

-- СИСТЕМА СТЕЛС-ПОЛЬОТУ (Робота з координатами CFrame)
RunService.RenderStepped:Connect(function(dt)
    if flying and lPlayer.Character and lPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lPlayer.Character.HumanoidRootPart
        local humanoid = lPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            hrp.Velocity = Vector3.new(0, 0, 0) -- Обнуляємо фізичну швидкість для сервера
            
            local moveDirection = humanoid.MoveDirection
            local displacement = Vector3.new(0, 0, 0)
            
            -- Рух по горизонталі (Працює і від W,A,S,D, і від мобільного джойстика)
            if moveDirection.Magnitude > 0 then
                displacement = displacement + (moveDirection * flySpeed * dt)
            end
            
            -- Зміна висоти (Об'єднує і клавіатуру ПК, і кнопки на екрані)
            if upPressed then displacement = displacement + Vector3.new(0, flySpeed * dt, 0) end
            if downPressed then displacement = displacement + Vector3.new(0, -flySpeed * dt, 0) end
            
            hrp.CFrame = hrp.CFrame + displacement
        end
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyBtn.Text = "FLY: ACTIVE"; flyBtn.TextColor3 = Color3.fromRGB(50, 180, 50)
    else
        flyBtn.Text = "FLY: OFF"; flyBtn.TextColor3 = Color3.fromRGB(180, 50, 50)
        if lPlayer.Character and lPlayer.Character:FindFirstChild("HumanoidRootPart") then
            lPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)
