local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

local screenGui = Instance.new("ScreenGui", lPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "FlyNoclipCore_" .. math.random(1000, 9999)
screenGui.ResetOnSpawn = false

local function roundCorners(instance, radius)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, radius)
    uiCorner.Parent = instance
end

---------------------------------------------------------
-- ІНТЕРФЕЙС (Fly and noclip)
---------------------------------------------------------
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 275)
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
roundCorners(mainFrame, 12)

local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
topBar.BorderSizePixel = 0
roundCorners(topBar, 12)

local topBarMask = Instance.new("Frame", topBar)
topBarMask.Size = UDim2.new(1, 0, 0, 10)
topBarMask.Position = UDim2.new(0, 0, 1, -10)
topBarMask.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
topBarMask.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -10, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Fly and noclip"
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.Code
title.TextSize = 13
title.BackgroundTransparency = 1

---------------------------------------------------------
-- КНОПКИ КЕРУВАННЯ
---------------------------------------------------------
local flying = false
local noclip = false
local flySpeed = 50

local upPressed = false
local downPressed = false

local flyBtn = Instance.new("TextButton", mainFrame)
flyBtn.Size = UDim2.new(0.9, 0, 0, 35)
flyBtn.Position = UDim2.new(0.05, 0, 0.14, 0)
flyBtn.Text = "FLY: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
flyBtn.TextColor3 = Color3.fromRGB(180, 50, 50)
flyBtn.Font = Enum.Font.Code
flyBtn.TextSize = 13
roundCorners(flyBtn, 6)

local noclipBtn = Instance.new("TextButton", mainFrame)
noclipBtn.Size = UDim2.new(0.9, 0, 0, 35)
noclipBtn.Position = UDim2.new(0.05, 0, 0.29, 0)
noclipBtn.Text = "NOCLIP: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
noclipBtn.TextColor3 = Color3.fromRGB(180, 50, 50)
noclipBtn.Font = Enum.Font.Code
noclipBtn.TextSize = 13
roundCorners(noclipBtn, 6)

local speedLabel = Instance.new("TextLabel", mainFrame)
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0.43, 0)
speedLabel.Text = "SPEED: " .. flySpeed
speedLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
speedLabel.Font = Enum.Font.Code
speedLabel.TextSize = 13
speedLabel.BackgroundTransparency = 1

local speedDown = Instance.new("TextButton", mainFrame)
speedDown.Size = UDim2.new(0.42, 0, 0, 30)
speedDown.Position = UDim2.new(0.05, 0, 0.52, 0)
speedDown.Text = "[ - ] SPEED"
speedDown.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
speedDown.TextColor3 = Color3.fromRGB(200, 200, 200)
speedDown.Font = Enum.Font.Code
speedDown.TextSize = 12
roundCorners(speedDown, 6)

local speedUp = Instance.new("TextButton", mainFrame)
speedUp.Size = UDim2.new(0.42, 0, 0, 30)
speedUp.Position = UDim2.new(0.53, 0, 0.52, 0)
speedUp.Text = "[ + ] SPEED"
speedUp.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
speedUp.TextColor3 = Color3.fromRGB(200, 200, 200)
speedUp.Font = Enum.Font.Code
speedUp.TextSize = 12
roundCorners(speedUp, 6)

local mobileUp = Instance.new("TextButton", mainFrame)
mobileUp.Size = UDim2.new(0.42, 0, 0, 38)
mobileUp.Position = UDim2.new(0.05, 0, 0.67, 0)
mobileUp.Text = "▲ UP"
mobileUp.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
mobileUp.TextColor3 = Color3.fromRGB(220, 220, 220)
mobileUp.Font = Enum.Font.Code
mobileUp.TextSize = 13
roundCorners(mobileUp, 6)

local mobileDown = Instance.new("TextButton", mainFrame)
mobileDown.Size = UDim2.new(0.42, 0, 0, 38)
mobileDown.Position = UDim2.new(0.53, 0, 0.67, 0)
mobileDown.Text = "▼ DOWN"
mobileDown.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
mobileDown.TextColor3 = Color3.fromRGB(220, 220, 220)
mobileDown.Font = Enum.Font.Code
mobileDown.TextSize = 13
roundCorners(mobileDown, 6)

---------------------------------------------------------
-- ОНОВЛЕНА ФІЗИКА (ЗАСТИГАННЯ В ПОВІТРІ ЯК НА ВІДЕО)
---------------------------------------------------------
local bVelocity, bGyro

speedUp.MouseButton1Click:Connect(function()
    flySpeed = math.min(flySpeed + 10, 500)
    speedLabel.Text = "SPEED: " .. flySpeed
end)

speedDown.MouseButton1Click:Connect(function()
    flySpeed = math.max(flySpeed - 10, 10)
    speedLabel.Text = "SPEED: " .. flySpeed
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then upPressed = true end
    if input.KeyCode == Enum.KeyCode.Q then downPressed = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then upPressed = false end
    if input.KeyCode == Enum.KeyCode.Q then downPressed = false end
end)

mobileUp.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then upPressed = true end
end)
mobileUp.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then upPressed = false end
end)
mobileDown.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then downPressed = true end
end)
mobileDown.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then downPressed = false end
end)

-- Ноукліп логіка
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

-- Рендер польоту через примусову стабілізацію векторів
RunService.RenderStepped:Connect(function()
    if flying and lPlayer.Character and lPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lPlayer.Character.HumanoidRootPart
        local humanoid = lPlayer.Character:FindFirstChildOfClass("Humanoid")
        local camera = workspace.CurrentCamera
        
        if humanoid and camera then
            -- Створюємо об'єкти підтримки, які блокують падіння гравітації
            if not bVelocity then
                bVelocity = Instance.new("BodyVelocity")
                bVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9) -- Потужна сила утримання
                bVelocity.Velocity = Vector3.new(0, 0, 0)
                bVelocity.Parent = hrp
            end
            if not bGyro then
                bGyro = Instance.new("BodyGyro")
                bGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bGyro.CFrame = hrp.CFrame
                bGyro.Parent = hrp
            end
            
            -- Примусово ставимо персонажа у стоячу стійку
            humanoid.PlatformStand = true 
            
            local moveDirection = humanoid.MoveDirection
            local finalVelocity = Vector3.new(0, 0, 0)
            
            -- Рух тільки якщо тиснеш WASD чи смикаєш джойстик
            if moveDirection.Magnitude > 0 then
                local cameraCFrame = camera.CFrame
                local localMove = cameraCFrame:VectorToObjectSpace(moveDirection)
                
                -- Рахуємо напрямок руху чітко за нахилом камери
                finalVelocity = (cameraCFrame.LookVector * -localMove.Z + cameraCFrame.RightVector * localMove.X).Unit * flySpeed
            end
            
            -- Вертикальне зміщення
            if upPressed then finalVelocity = finalVelocity + Vector3.new(0, flySpeed, 0) end
            if downPressed then finalVelocity = finalVelocity + Vector3.new(0, -flySpeed, 0) end
            
            -- Оновлюємо фізичні параметри
            bVelocity.Velocity = finalVelocity
            bGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + camera.CFrame.LookVector)
        end
    else
        -- Повертаємо звичайний стан при відключенні
        if bVelocity then bVelocity:Destroy() bVelocity = nil end
        if bGyro then bGyro:Destroy() bGyro = nil end
        if lPlayer.Character and lPlayer.Character:FindFirstChildOfClass("Humanoid") then
            lPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
        end
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyBtn.Text = "FLY: ACTIVE"; flyBtn.TextColor3 = Color3.fromRGB(50, 180, 50)
    else
        flyBtn.Text = "FLY: OFF"; flyBtn.TextColor3 = Color3.fromRGB(180, 50, 50)
    end
end)
