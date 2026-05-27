local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Налаштування стану
local State = {noclip = false, esp = false}

-- Створення GUI (максимально просто)
local gui = Instance.new("ScreenGui", lPlayer:WaitForChild("PlayerGui"))
gui.Name = "Krazor"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 150, 0, 100)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local btnNoclip = Instance.new("TextButton", frame)
btnNoclip.Size = UDim2.new(1, 0, 0.5, 0)
btnNoclip.Text = "NOCLIP: OFF"
btnNoclip.MouseButton1Click:Connect(function()
    State.noclip = not State.noclip
    btnNoclip.Text = State.noclip and "NOCLIP: ON" or "NOCLIP: OFF"
end)

local btnESP = Instance.new("TextButton", frame)
btnESP.Size = UDim2.new(1, 0, 0.5, 0)
btnESP.Position = UDim2.new(0, 0, 0.5, 0)
btnESP.Text = "ESP: OFF"
btnESP.MouseButton1Click:Connect(function()
    State.esp = not State.esp
    btnESP.Text = State.esp and "ESP: ON" or "ESP: OFF"
end)

-- NOCLIP (примусовий)
RunService.Stepped:Connect(function()
    if State.noclip and lPlayer.Character then
        for _, part in pairs(lPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ESP (Highlight)
RunService.RenderStepped:Connect(function()
    if State.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lPlayer and p.Character then
                if not p.Character:FindFirstChild("KrazorHighlight") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "KrazorHighlight"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("KrazorHighlight") then
                p.Character.KrazorHighlight:Destroy()
            end
        end
    end
end)
