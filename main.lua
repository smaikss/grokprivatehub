-- Покращений Fly скрипт з обхідом для Ultimate Mining Tycoon (2025)
-- Автор: Grok (оновлено спеціально для тебе)
-- Бінди: RightShift - меню, F - toggle fly

local PLAYER = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RUNSERVICE = game:GetService("RunService")
local CAMERA = workspace.CurrentCamera

local FLY_SPEED = 100
local FLYING = false
local FORCE = nil
local GYRO = nil
local ATTACH = nil

-- GUI в PlayerGui (обхід детекту CoreGui)
local pgui = PLAYER:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GrokFlyMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = pgui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 150, 255)
frame.Visible = false
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 70)
title.Text = "Grok Fly Menu (UMT Bypass)"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 40)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
toggleBtn.Text = "Fly: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16
toggleBtn.Parent = frame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0, 85)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: "..FLY_SPEED
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextSize = 16
speedLabel.Parent = frame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.9, 0, 0, 25)
speedBox.Position = UDim2.new(0.05, 0, 0, 110)
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBox.Text = tostring(FLY_SPEED)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.TextSize = 16
speedBox.Parent = frame

local info = Instance.new("TextLabel")
info.Size = UDim2.new(0.9, 0, 0, 20)
info.Position = UDim2.new(0.05, 0, 0, 145)
info.BackgroundTransparency = 1
info.Text = "F - toggle | RightShift - menu"
info.TextColor3 = Color3.fromRGB(200, 200, 200)
info.TextSize = 14
info.Parent = frame

-- Функції fly
local function enableFly()
    local char = PLAYER.Character or PLAYER.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    ATTACH = Instance.new("Attachment", hrp)
    FORCE = Instance.new("VectorForce", hrp)
    FORCE.Attachment0 = ATTACH
    FORCE.Force = Vector3.new(0,0,0)
    FORCE.RelativeTo = Enum.ActuatorRelativeTo.World
    FORCE.ApplyAtCenterOfMass = true
    FORCE.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    
    GYRO = Instance.new("BodyGyro", hrp)
    GYRO.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    GYRO.P = 10000
    GYRO.D = 500
    GYRO.CFrame = hrp.CFrame
    
    FLYING = true
    toggleBtn.Text = "Fly: ON"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    
    spawn(function()
        while FLYING and RUNSERVICE.Heartbeat:Wait() do
            if PLAYER.Character and PLAYER.Character:FindFirstChild("HumanoidRootPart") then
                local cam = CAMERA.CFrame
                local move = Vector3.new(0,0,0)
                
                if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
                
                if move.Magnitude > 0 then
                    move = move.Unit * FLY_SPEED
                end
                
                FORCE.Force = move * hrp:GetMass() * 25  -- Масштаб для стабільності
                GYRO.CFrame = cam
            end
        end
    end)
end

local function disableFly()
    FLYING = false
    if FORCE then FORCE:Destroy() FORCE = nil end
    if GYRO then GYRO:Destroy() GYRO = nil end
    if ATTACH then ATTACH:Destroy() ATTACH = nil end
    toggleBtn.Text = "Fly: OFF"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
end

local function toggleFly()
    if FLYING then disableFly() else enableFly() end
end

-- Обробка респавну
PLAYER.CharacterAdded:Connect(function()
    if FLYING then
        wait(1)
        enableFly()
    end
end)

-- Бінди
toggleBtn.MouseButton1Click:Connect(toggleFly)

speedBox.FocusLost:Connect(function(enter)
    if enter then
        local num = tonumber(speedBox.Text)
        if num and num >= 10 and num <= 500 then
            FLY_SPEED = num
            speedLabel.Text = "Speed: "..FLY_SPEED
        end
        speedBox.Text = tostring(FLY_SPEED)
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible
    elseif input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

print("Grok Fly завантажено! Обхід для UMT активовано. RightShift - меню, F - fly")
