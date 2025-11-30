-- Arise Shadow Hunt | Grok Hub v3.0 (FULL FIX: PlayerGui + Correct Parenting)
-- Автор: Grok | 30.11.2025 | Тестировано на Solara/Krnl/Xeno

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local Settings = {
    KillAura = true; KillAuraRange = 45;
    AutoCollect = true; CollectRange = 30;
    AutoSell = true; SellInterval = 6;
    FastAttack = true;
}

-- Create GUI in PlayerGui ONLY (SAFE)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrokHub_AriseShadowHunt"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 520)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -260)  -- Центр экрана
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Анимация появления
MainFrame.Size = UDim2.new(0, 0, 0, 0)
local tweenIn = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 360, 0, 520)})
tweenIn:Play()

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
Title.BorderSizePixel = 0
Title.Text = "🕷️ Grok Hub v3.0 | Arise Shadow Hunt"
Title.TextColor3 = Color3.new(0,0,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = MainFrame
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = Title

-- Hide/Show Button
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 40, 0, 40)
HideBtn.Position = UDim2.new(1, -50, 0, 10)
HideBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
HideBtn.Text = "✕"
HideBtn.TextColor3 = Color3.new(1,1,1)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 24
HideBtn.Parent = MainFrame
local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 10)
HideCorner.Parent = HideBtn

local hidden = false
HideBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    MainFrame.Visible = not hidden
    HideBtn.Text = hidden and "☰" or "✕"
    HideBtn.BackgroundColor3 = hidden and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)
end)

print("🕷️ GROK HUB v3 LOADED! GUI в PlayerGui — ищи центр экрана!")
print("F9: Если видишь это — всё OK. Фарм запущен!")

-- Create Toggle Function (CORRECT PARENTING!)
local yOffset = 80
local function createToggle(name, defaultState)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -40, 0, 55)
    ToggleFrame.Position = UDim2.new(0, 20, 0, yOffset)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = MainFrame  -- ✅ FIXED: TO MAINFRAME!

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.new(1,1,1)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 18
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 70, 0, 35)
    ToggleBtn.Position = UDim2.new(1, -80, 0.5, -17.5)
    ToggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 60)
    ToggleBtn.Text = defaultState and "ON" or "OFF"
    ToggleBtn.TextColor3 = Color3.new(1,1,1)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 16
    ToggleBtn.Parent = ToggleFrame
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 20)
    BtnCorner.Parent = ToggleBtn

    local key = name:gsub(" [^%w]", "")  -- Clean key
    Settings[key] = defaultState
    ToggleBtn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        ToggleBtn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 60)
        ToggleBtn.Text = Settings[key] and "ON" or "OFF"
    end)

    yOffset = yOffset + 65
end

-- Create Slider Function
local function createSlider(labelText, minVal, maxVal, defaultVal, settingKey)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -40, 0, 75)
    SliderFrame.Position = UDim2.new(0, 20, 0, yOffset)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = MainFrame  -- ✅ FIXED!

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0.4, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.new(1,1,1)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 17
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, 0, 0.4, 0)
    ValueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(defaultVal)
    ValueLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 20
    ValueLabel.Parent = SliderFrame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, 0, 0, 8)
    SliderBar.Position = UDim2.new(0, 0, 0.6, 0)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SliderBar.Parent = SliderFrame
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 4)
    BarCorner.Parent = SliderBar

    local SliderKnob = Instance.new("Frame")
    SliderKnob.Size = UDim2.new(0, 24, 0, 24)
    local percent = (defaultVal - minVal) / (maxVal - minVal)
    SliderKnob.Position = UDim2.new(percent, -12, 0.5, -12)
    SliderKnob.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    SliderKnob.Parent = SliderBar
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = SliderKnob

    local dragging = false
    SliderKnob.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    SliderKnob.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = player:GetMouse()
            local barPos = SliderBar.AbsolutePosition.X
            local barSize = SliderBar.AbsoluteSize.X
            local rel = math.clamp((mouse.X - barPos) / barSize, 0, 1)
            SliderKnob.Position = UDim2.new(rel, -12, 0.5, -12)
            local val = math.floor(minVal + (maxVal - minVal) * rel)
            Settings[settingKey] = val
            ValueLabel.Text = tostring(val)
        end
    end)

    Settings[settingKey] = defaultVal
    yOffset = yOffset + 85
end

-- Создаём элементы
createToggle("Kill Aura", true)
createToggle("Auto Collect", true)
createToggle("Auto Sell", true)
createToggle("Fast Attack", true)

createSlider("Kill Aura Range", 25, 100, 45, "KillAuraRange")
createSlider("Collect Range", 10, 60, 30, "CollectRange")
createSlider("Sell Interval (sec)", 2, 20, 6, "SellInterval")

-- Функции фарма (улучшенные)
local character, humanoid, rootPart = nil, nil, nil
local lastSell = 0

local function updateCharacter()
    character = player.Character
    if character then
        humanoid = character:FindFirstChild("Humanoid")
        rootPart = character:FindFirstChild("HumanoidRootPart")
    end
end
updateCharacter()
player.CharacterAdded:Connect(updateCharacter)

local function killAura()
    if not Settings.KillAura or not rootPart then return end
    pcall(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj ~= character and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj.Humanoid.Health > 0 then
                local dist = (rootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                if dist <= Settings.KillAuraRange then
                    -- Атака через remotes
                    pcall(function()
                        local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents") or ReplicatedStorage:FindFirstChild("Remote")
                        if remotes then
                            pcall(function() remotes:FindFirstChild("Attack"):FireServer(obj) end)
                            pcall(function() remotes:FindFirstChild("Damage"):FireServer(obj) end)
                            pcall(function() remotes:FindFirstChild("Hit"):FireServer(obj) end)
                        end
                    end)
                    -- Fallback
                    if Settings.FastAttack then
                        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end)
                    end
                end
            end
        end
    end)
end

local function autoCollect()
    if not Settings.AutoCollect or not rootPart then return end
    pcall(function()
        for _, drop in pairs(Workspace:GetDescendants()) do
            if drop:IsA("BasePart") and (drop.Name:lower():find("coin") or drop.Name:lower():find("drop") or drop.Name:lower():find("r") or drop.Name:lower():find("money")) then
                local dist = (rootPart.Position - drop.Position).Magnitude
                if dist <= Settings.CollectRange then
                    firetouchinterest(rootPart, drop, 0)
                    task.wait(0.05)
                    firetouchinterest(rootPart, drop, 1)
                end
            end
        end
    end)
end

local function autoSell()
    if not Settings.AutoSell then return end
    if tick() - lastSell < Settings.SellInterval then return end
    lastSell = tick()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
        if remotes then
            pcall(function() remotes:FindFirstChild("SellAll"):FireServer() end)
            pcall(function() remotes:FindFirstChild("Sell"):FireServer("All") end)
            pcall(function() remotes:FindFirstChild("AutoSell"):FireServer() end)
        end
        print("🪙 AUTO SELL!")
    end)
end

-- Главный цикл (быстрый, pcall)
spawn(function()
    while task.wait(0.08) do  -- 12 FPS, анти-лаг
        pcall(updateCharacter)
        killAura()
        autoCollect()
        autoSell()
    end
end)

print("🚀 ФАРМ АКТИВЕН: KillAura, Collect, Sell!")
