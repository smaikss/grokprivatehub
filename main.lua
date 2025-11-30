-- Arise Shadow Hunt | Удобная мод-панель + автофарм
-- Автор: Grok (написано с нуля специально для тебя)
-- Дата: 30 ноября 2025

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- === НАСТРОЙКИ (меняются через GUI) ===
local Settings = {
    KillAura = true,
    KillAuraRange = 45,
    
    AutoCollect = true,
    CollectRange = 30,
    
    AutoSell = true,
    SellInterval = 6,
    
    FastAttack = true, -- ускоряет анимацию атаки (если игра позволяет)
}

-- === СОЗДАНИЕ GUI ===
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local HideBtn = Instance.new("TextButton")
local Corner = Instance.new("UICorner")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "AriseShadowHunt_GrokHub"

-- Основная рамка
MainFrame.Size = UDim2.new(0, 350, 0, 480)
MainFrame.Position = UDim2.new(0, 50, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Заголовок
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "Arise Shadow Hunt — Grok Hub"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Кнопка скрытия
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Position = UDim2.new(1, -40, 0, 10)
HideBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
HideBtn.Text = "X"
HideBtn.TextColor3 = Color3.new(1,1,1)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.Parent = MainFrame
local HideCorner = Instance.new("UICorner", HideBtn)
HideCorner.CornerRadius = UDim.new(0, 8)

-- Функция создания тумблера
local function createToggle(name, posY, default)
    local ToggleFrame = Instance.new("Frame")
    local Label = Instance.new("TextLabel")
    local ToggleBtn = Instance.new("TextButton")
    local ToggleCorner = Instance.new("UICorner")

    ToggleFrame.Size = UDim2.new(0.9, 0, 0, 50)
    ToggleFrame.Position = UDim2.new(0.05, 0, 0, posY)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = MainFrame

    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.new(1,1,1)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 18
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    ToggleBtn.Size = UDim2.new(0, 60, 0, 30)
    ToggleBtn.Position = UDim2.new(1, -70, 0.5, -15)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(70, 70, 80)
    ToggleBtn.Text = default and "ON" or "OFF"
    ToggleBtn.TextColor3 = Color3.new(0,0,0)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.Parent = ToggleFrame
    ToggleCorner.CornerRadius = UDim.new(0, 15)
    ToggleCorner.Parent = ToggleBtn

    ToggleBtn.MouseButton1Click:Connect(function()
        Settings[name:gsub(" ", "")] = not Settings[name:gsub(" ", "")]
        ToggleBtn.BackgroundColor3 = Settings[name:gsub(" ", "")] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(70, 70, 80)
        ToggleBtn.Text = Settings[name:gsub(" ", "")] and "ON" or "OFF"
    end)
end

-- Функция создания слайдера
local function createSlider(name, posY, min, max, default, callbackKey)
    local SliderFrame = Instance.new("Frame")
    local Label = Instance.new("TextLabel")
    local ValueLabel = Instance.new("TextLabel")
    local SliderBar = Instance.new("Frame")
    local SliderKnob = Instance.new("Frame")

    SliderFrame.Size = UDim2.new(0.9, 0, 0, 70)
    SliderFrame.Position = UDim2.new(0.05, 0, 0, posY)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = MainFrame

    Label.Size = UDim2.new(1, 0, 0.4, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.new(1,1,1)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 17
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    ValueLabel.Size = UDim2.new(0.2, 0, 0.4, 0)
    ValueLabel.Position = UDim2.new(0.8, 0, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Parent = SliderFrame

    SliderBar.Size = UDim2.new(1, 0, 0, 10)
    SliderBar.Position = UDim2.new(0, 0, 0.7, 0)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SliderBar.Parent = SliderFrame
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(0, 5)

    SliderKnob.Size = UDim2.new(0, 20, 0, 20)
    SliderKnob.Position = UDim2.new((default - min)/(max - min), -10, 0.5, -10)
    SliderKnob.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    SliderKnob.Parent = SliderBar
    Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    SliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    SliderKnob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = player:GetMouse()
            local relX = math.clamp((mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            SliderKnob.Position = UDim2.new(relX, -10, 0.5, -10)
            local value = math.floor(min + (max - min) * relX + 0.5)
            Settings[callbackKey] = value
            ValueLabel.Text = tostring(value)
        end
    end)
end

-- Создаём тумблеры и слайдеры
createToggle("Kill Aura", 70, true)
createToggle("Auto Collect", 130, true)
createToggle("Auto Sell", 190, true)
createToggle("Fast Attack", 250, true)

createSlider("Kill Aura Range", 310, 20, 80, 45, "KillAuraRange")
createSlider("Collect Range", 390, 10, 60, 30, "CollectRange")
createSlider("Sell Interval (sec)", 470, 3, 15, 6, "SellInterval")

-- Кнопка скрытия/показа
local hidden = false
HideBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    MainFrame.Visible = not hidden
    HideBtn.Text = hidden and "☰" or "X"
end)

-- === ОСНОВНЫЕ ФУНКЦИИ ===
local lastSell = 0

local function killAura()
    if not Settings.KillAura then return end
    for _, mob in pairs(Workspace:GetDescendants()) do
        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") 
        and mob.Humanoid.Health > 0 and mob ~= character then
            local dist = (rootPart.Position - mob.HumanoidRootPart.Position).Magnitude
            if dist <= Settings.KillAuraRange then
                -- Попробуем разные возможные ремоты
                local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
                if remotes then
                    local attack = remotes:FindFirstChild("Attack") or remotes:FindFirstChild("Damage") or remotes:FindFirstChild("Hit")
                    if attack then attack:FireServer(mob.Humanoid or mob) end
                end
                if Settings.FastAttack then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end
    end
end

local function autoCollect()
    if not Settings.AutoCollect then return end
    for _, drop in pairs(Workspace:GetDescendants()) do
        if drop:IsA("Part") and drop.Name:lower():find("coin") or drop.Name:lower():find("drop") or drop.Name == "R" then
            if (rootPart.Position - drop.Position).Magnitude <= Settings.CollectRange then
                firetouchinterest(drop, rootPart, 0)
                wait()
                firetouchinterest(drop, rootPart, 1)
            end
        end
    end
end

local function autoSell()
    if not Settings.AutoSell then return end
    if tick() - lastSell >= Settings.SellInterval then
        lastSell = tick()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
        if remotes then
            local sell = remotes:FindFirstChild("SellAll") or remotes:FindFirstChild("Sell") or remotes:FindFirstChild("AutoSell")
            if sell then sell:FireServer() end
        end
    end
end

-- === ГЛАВНЫЙ ЦИКЛ ===
spawn(function()
    while wait(0.15) do
        pcall(function()
            character = player.Character or player.CharacterAdded:Wait()
            humanoid = character:WaitForChild("Humanoid")
            rootPart = character:WaitForChild("HumanoidRootPart")
            
            killAura()
            autoCollect()
            autoSell()
        end)
    end
end)

print("Arise Shadow Hunt — Grok Hub успешно загружен!")
print("Панель открыта — настраивай как хочешь :)")
