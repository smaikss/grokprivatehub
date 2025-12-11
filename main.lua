-- Простий Fly скрипт з GUI меню
-- Автор: Grok (для тебе спеціально ;)
-- Бінди: RightShift - відкрити/закрити меню, F - toggle fly

local PLAYER = game.Players.LocalPlayer
local MOUSE = PLAYER:GetMouse()
local CAMERA = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RUNSERVICE = game:GetService("RunService")

-- Налаштування
local FLY_SPEED = 100
local FLYING = false
local VEHICLE = nil

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyMenu"
screenGui.Parent = game.CoreGui
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(100, 100, 255)
frame.Visible = false
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 80)
title.Text = "Fly Menu by Grok"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 40)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = "Fly: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSans
toggleBtn.TextSize = 16
toggleBtn.Parent = frame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0, 85)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: "..FLY_SPEED
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 16
speedLabel.Parent = frame

local slider = Instance.new("TextBox")
slider.Size = UDim2.new(0.9, 0, 0, 25)
slider.Position = UDim2.new(0.05, 0, 0, 110)
slider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
slider.Text = tostring(FLY_SPEED)
slider.TextColor3 = Color3.new(1, 1, 1)
slider.Font = Enum.Font.SourceSans
slider.TextSize = 16
slider.ClearTextOnFocus = false
slider.Parent = frame

local info = Instance.new("TextLabel")
info.Size = UDim2.new(0.9, 0, 0, 20)
info.Position = UDim2.new(0.05, 0, 0, 145)
info.BackgroundTransparency = 1
info.Text = "F - toggle | RightShift - menu"
info.TextColor3 = Color3.fromRGB(180, 180, 180)
info.Font = Enum.Font.SourceSans
info.TextSize = 14
info.Parent = frame

-- Функція польоту
local function startFly()
    if not PLAYER.Character or not PLAYER.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = PLAYER.Character.HumanoidRootPart
    
    VEHICLE = Instance.new("BodyVelocity")
    VEHICLE.Velocity = Vector3.new(0, 0, 0)
    VEHICLE.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    VEHICLE.Parent = hrp
    
    FLYING = true
    toggleBtn.Text = "Fly: ON"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    
    spawn(function()
        while FLYING and RUNSERVICE.Stepped:Wait() do
            if PLAYER.Character and PLAYER.Character:FindFirstChild("HumanoidRootPart") then
                local cam = CAMERA.CFrame
                local move = Vector3.new()
                
                if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
                
                VEHICLE.Velocity = move.Unit * FLY_SPEED
                if move Magnitude == 0 then VEHICLE.Velocity = Vector3.new(0,0,0) end
            end
        end
    end)
end

local function stopFly()
    FLYING = false
    if VEHICLE then VEHICLE:Destroy() VEHICLE = nil end
    toggleBtn.Text = "Fly: OFF"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end

local function toggleFly()
    if FLYING then stopFly() else startFly() end
end

-- Обробка кнопок
toggleBtn.MouseButton1Click:Connect(toggleFly)

slider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(slider.Text)
        if num and num >= 10 and num <= 500 then
            FLY_SPEED = num
            speedLabel.Text = "Speed: "..FLY_SPEED
        else
            slider.Text = tostring(FLY_SPEED)
        end
    end
end)

-- Бінди
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible
    elseif input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

-- Повідомлення
print("Fly скрипт завантажено!")
print("RightShift - відкрити/закрити меню")
print("F - ввімкнути/вимкнути політ")
