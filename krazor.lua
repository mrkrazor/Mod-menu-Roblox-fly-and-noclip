local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lPlayer = Players.LocalPlayer

-- Стан
local flying = false
local noclip = false
local speed = 50

-- Створення GUI
local gui = Instance.new("ScreenGui", lPlayer:WaitForChild("PlayerGui"))
gui.Name = "KrazorControl"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 160, 0, 110)
frame.Position = UDim2.new(0.5, -80, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true

-- Кнопка Fly
local btnFly = Instance.new("TextButton", frame)
btnFly.Size = UDim2.new(1, 0, 0.5, 0)
btnFly.Text = "FLY: OFF"
btnFly.BackgroundColor3 = Color3.fromRGB(255, 100, 100)

-- Кнопка Noclip
local btnNoclip = Instance.new("TextButton", frame)
btnNoclip.Size = UDim2.new(1, 0, 0.5, 0)
btnNoclip.Position = UDim2.new(0, 0, 0.5, 0)
btnNoclip.Text = "NOCLIP: OFF"
btnNoclip.BackgroundColor3 = Color3.fromRGB(255, 100, 100)

-- Логіка Fly
local bodyVelocity = Instance.new("BodyVelocity")
local bodyGyro = Instance.new("BodyGyro")

btnFly.MouseButton1Click:Connect(function()
    flying = not flying
    btnFly.Text = flying and "FLY: ON" or "FLY: OFF"
    btnFly.BackgroundColor3 = flying and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    
    local char = lPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if flying then
        bodyVelocity.Parent = char.HumanoidRootPart
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyGyro.Parent = char.HumanoidRootPart
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    else
        bodyVelocity.Parent = nil
        bodyGyro.Parent = nil
    end
end)

-- Логіка Noclip
btnNoclip.MouseButton1Click:Connect(function()
    noclip = not noclip
    btnNoclip.Text = noclip and "NOCLIP: ON" or "NOCLIP: OFF"
    btnNoclip.BackgroundColor3 = noclip and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

-- Основний цикл (Fly + Noclip)
RunService.Stepped:Connect(function()
    if noclip and lPlayer.Character then
        for _, part in pairs(lPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    if flying and lPlayer.Character and lPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local cam = workspace.CurrentCamera
        bodyGyro.CFrame = cam.CFrame
        local dir = Vector3.new(0,0,0)
        local uis = game:GetService("UserInputService")
        if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        bodyVelocity.Velocity = dir * speed
    end
end)
