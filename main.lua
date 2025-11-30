-- Arise Shadow Hunt | Grok Hub v2.0 (TP Mobs + Sliders + Fix Collect/Sell)
-- Автор: Grok | 30.11.2025 | 100% Xeno OK

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Settings = {
    KillAura = true,
    AutoTP = true,
    AutoCollect = true,
    AutoSell = false,
    TPDelay = 1.5,  -- Секунды между TP
    SearchRange = 300  -- Радиус поиска мобов
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrokHub_v2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 420, 0, 580)
Main.Position = UDim2.new(0.5, -210, 0.5, -290)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
local mc = Instance.new("UICorner", Main); mc.CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Title.Text = "🕷️ GROK HUB v2.0 | Arise Shadow Hunt (TP FIX)"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = Main
local tc = Instance.new("UICorner", Title); tc.CornerRadius = UDim.new(0, 16)

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -50, 0, 10)
Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Close.Parent = Main
local cc = Instance.new("UICorner", Close); cc.CornerRadius = UDim.new(0, 10)

local vis = true
Close.MouseButton1Click:Connect(function()
    vis = not vis
    Main.Visible = vis
    Close.Text = vis and "X" or "+"
end)

-- Toggle функция
local y = 75
local function addToggle(name, key, def)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.9, 0, 0, 50)
    f.Position = UDim2.new(0.05, 0, 0, y)
    f.BackgroundTransparency = 1
    f.Parent = Main

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.65, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.Gotham
    l.TextSize = 18
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 70, 0, 35)
    b.Position = UDim2.new(1, -80, 0.5, -17.5)
    b.BackgroundColor3 = def and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
    b.Text = def and "ON" or "OFF"
    b.TextColor3 = Color3.new(0,0,0)
    b.Font = Enum.Font.GothamBold
    b.Parent = f
    local bc = Instance.new("UICorner", b); bc.CornerRadius = UDim.new(0, 18)

    Settings[key] = def
    b.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        b.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
        b.Text = Settings[key] and "ON" or "OFF"
    end)
    y = y + 60
end

addToggle("Kill Aura", "KillAura", true)
addToggle("Auto TP to Mobs", "AutoTP", true)
addToggle("Auto Collect R", "AutoCollect", true)
addToggle("Auto Sell", "AutoSell", false)

-- Slider для TP Delay
y = y + 10
local function addSlider(name, min, max, def, key)
    local sf = Instance.new("Frame")
    sf.Size = UDim2.new(0.9, 0, 0, 70)
    sf.Position = UDim2.new(0.05, 0, 0, y)
    sf.BackgroundTransparency = 1
    sf.Parent = Main

    local sl = Instance.new("TextLabel")
    sl.Size = UDim2.new(0.6, 0, 0.4, 0)
    sl.BackgroundTransparency = 1
    sl.Text = name
    sl.TextColor3 = Color3.new(1,1,1)
    sl.Font = Enum.Font.Gotham
    sl.TextSize = 17
    sl.TextXAlignment = Enum.TextXAlignment.Left
    sl.Parent = sf

    local vl = Instance.new("TextLabel")
    vl.Size = UDim2.new(0.3, 0, 0.4, 0)
    vl.Position = UDim2.new(0.7, 0, 0, 0)
    vl.BackgroundTransparency = 1
    vl.Text = tostring(def)
    vl.TextColor3 = Color3.fromRGB(0, 255, 200)
    vl.Font = Enum.Font.GothamBold
    vl.TextSize = 20
    vl.Parent = sf

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 8)
    bar.Position = UDim2.new(0, 0, 0.6, 0)
    bar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    bar.Parent = sf
    local bc = Instance.new("UICorner", bar); bc.CornerRadius = UDim.new(0, 4)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 24, 0, 24)
    local perc = (def - min) / (max - min)
    knob.Position = UDim2.new(perc, -12, 0.5, -12)
    knob.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    knob.Parent = bar
    local kc = Instance.new("UICorner", knob); kc.CornerRadius = UDim.new(1, 0)

    local drag = false
    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
    knob.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
    RunService.RenderStepped:Connect(function()
        if drag then
            local mouse = player:GetMouse()
            local rel = math.clamp((mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            knob.Position = UDim2.new(rel, -12, 0.5, -12)
            local val = math.floor(min + (max - min) * rel * 10) / 10
            Settings[key] = val
            vl.Text = tostring(val) .. "s"
        end
    end)
    y = y + 85
end

addSlider("TP Delay (sec)", 0.5, 5, 1.5, "TPDelay")
addSlider("Mob Search Range", 100, 500, 300, "SearchRange")

print("🕷️ GROK HUB v2.0 LOADED! TP + FIX")

-- ФУНКЦИИ
local lastTP = 0
local lastSell = 0

local function findNearestMob()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local root = char.HumanoidRootPart
    local nearest = nil
    local minDist = Settings.SearchRange
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= char and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj.Humanoid.Health > 0 then
            local dist = (root.Position - obj.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = obj
            end
        end
    end
    return nearest
end

-- Главный цикл
spawn(function()
    while task.wait(0.08) do
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root or not hum then continue end

        -- Auto TP + Kill Aura
        if Settings.AutoTP and tick() - lastTP >= Settings.TPDelay then
            local mob = findNearestMob()
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                -- TP за спину моба
                root.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 3, -8)
                lastTP = tick()
                -- Спам атаки
                for i = 1, 10 do  -- 10 атак подряд
                    pcall(function()
                        local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
                        if remotes then
                            pcall(function() remotes.Attack:FireServer(mob) end)
                            pcall(function() remotes.Damage:FireServer(mob) end)
                            pcall(function() remotes.Hit:FireServer(mob) end)
                        end
                    end)
                    task.wait(0.05)
                end
            end
        elseif Settings.KillAura then
            -- Обычная аура без TP
            for _, mob in pairs(Workspace:GetDescendants()) do
                if mob:IsA("Model") and mob ~= char and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                    local dist = (root.Position - mob.HumanoidRootPart.Position).Magnitude
                    if dist <= 50 then
                        pcall(function()
                            local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
                            if remotes then
                                pcall(function() remotes.Attack:FireServer(mob) end)
                                pcall(function() remotes.Damage:FireServer(mob) end)
                            end
                        end)
                    end
                end
            end
        end

        -- Auto Collect (улучшено)
        if Settings.AutoCollect then
            for _, drop in pairs(Workspace:GetDescendants()) do
                if drop:IsA("BasePart") and (drop.Name:lower():find("coin") or drop.Name:lower():find("r") or drop.Name:lower():find("drop") or drop.Name:lower():find("gold")) then
                    local dist = (root.Position - drop.Position).Magnitude
                    if dist <= 60 then
                        firetouchinterest(root, drop, 0)
                        task.wait(0.05)
                        firetouchinterest(root, drop, 1)
                    end
                end
            end
        end

        -- Auto Sell
        if Settings.AutoSell and tick() - lastSell >= 5 then
            lastSell = tick()
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
                if remotes then
                    pcall(function() remotes.SellAll:FireServer() end)
                    pcall(function() remotes.Sell:FireServer("All") end)
                    pcall(function() remotes.AutoSell:FireServer() end)
                end
            end)
            print("🪙 AUTO SELL!")
        end
    end
end)

print("🚀 v2.0: TP Farm + Collect FIX! Настраивай слайдеры")
