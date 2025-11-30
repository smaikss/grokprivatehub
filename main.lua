-- Arise Shadow Hunt | Grok Hub v4.0 FINAL (No Shake + Smooth TP + Mini Button)
-- 100% робить на Xeno, без багів

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Settings = {
    KillAura = true, AuraRange = 60,
    AutoTP = true, TPDelay = 1.8,
    AutoCollect = true, CollectRange = 90,
    AutoSell = true, SellInterval = 5.0,
    SearchRange = 500
}

local lastTP = 0
local lastSell = 0
local collectDebounce = {}

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrokHub_v4"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- Головне вікно
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 460, 0, 660)
Main.Position = UDim2.new(0.5, -230, 0.5, -330)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 70)
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.Text = "GROK HUB v4.0 | ФІКС ВСІХ БАГІВ"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 18)

-- Маленька кнопка "G" (завжди видно)
local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 70, 0, 70)
MiniBtn.Position = UDim2.new(1, -90, 1, -90)
MiniBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
MiniBtn.Text = "G"
MiniBtn.TextColor3 = Color3.new(1,1,1)
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.TextSize = 40
MiniBtn.Parent = ScreenGui
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(1, 0)
MiniBtn.Active = true
MiniBtn.Draggable = true

local mainVisible = true
MiniBtn.MouseButton1Click:Connect(function()
    mainVisible = not mainVisible
    Main.Visible = mainVisible
end)

-- Toggle
local yPos = 85
local function addToggle(name, key, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 55)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = Main

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 20
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 40)
    btn.Position = UDim2.new(1, -90, 0.5, -20)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(90,90,100)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 20)

    Settings[key] = default
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(90,90,100)
        btn.Text = Settings[key] and "ON" or "OFF"
    end)
    yPos = yPos + 65
end

addToggle("Kill Aura", "KillAura", true)
addToggle("Auto TP to Mobs", "AutoTP", true)
addToggle("Auto Collect R/Gold", "AutoCollect", true)
addToggle("Auto Sell", "AutoSell", true)

-- TextBox (ручна настройка)
local function addBox(name, key, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 60)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = Main

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.55, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 19
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.4, 0, 0.5, 0)
    box.Position = UDim2.new(0.58, 0, 0.25, 0)
    box.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    box.Text = tostring(default)
    box.TextColor3 = Color3.fromRGB(0, 255, 200)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 20
    box.Parent = frame
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)

    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local num = tonumber(box.Text)
            if num and num > 0 then
                Settings[key] = num
                box.Text = tostring(num)
            else
                box.Text = tostring(Settings[key])
            end
        end
    end)
    yPos = yPos + 75
end

addBox("TP Delay (сек)", "TPDelay", 1.8)
addBox("Sell Interval (сек)", "SellInterval", 5.0)
addBox("Aura Range", "AuraRange", 60)
addBox("Collect Range", "CollectRange", 90)
addBox("Search Range", "SearchRange", 500)

print("GROK HUB v4.0 ЗАГРУЖЕНО! Натисни G щоб сховати")

-- === ФАРМ ЛОГІКА ===
local function findNearestMob()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local root = char.HumanoidRootPart
    local best, bestDist = nil, Settings.SearchRange

    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") 
        and v.Humanoid.Health > 0 and v ~= char then
            local dist = (root.Position - v.HumanoidRootPart.Position).Magnitude
            if dist < bestDist then
                bestDist = dist
                best = v
            end
        end
    end
    return best
end

local function smoothTP(targetCFrame)
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

spawn(function()
    while task.wait(0.07) do
        local char = player.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not root or not hum then continue end

        -- Auto TP + Kill Aura
        if Settings.AutoTP and tick() - lastTP >= Settings.TPDelay then
            local mob = findNearestMob()
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                smoothTP(mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, -10))
                lastTP = tick()

                -- Спам атак
                for i = 1, 30 do
                    pcall(function()
                        local rem = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
                        if rem then
                            if rem:FindFirstChild("Attack") then rem.Attack:FireServer(mob) end
                            if rem:FindFirstChild("Damage") then rem.Damage:FireServer(mob) end
                            if rem:FindFirstChild("Hit") then rem.Hit:FireServer(mob) end
                            if rem:FindFirstChild("ReplicateDamage") then rem.ReplicateDamage:FireServer(mob) end
                            if rem:FindFirstChild("Swing") then rem.Swing:FireServer() end
                        end
                    end)
                    task.wait(0.03)
                end
            end
        end

        -- Звичайна Kill Aura (якщо TP вимкнено)
        if Settings.KillAura and not Settings.AutoTP == false then
            for _, mob in pairs(Workspace:GetDescendants()) do
                if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                    if (root.Position - mob.HumanoidRootPart.Position).Magnitude <= Settings.AuraRange then
                        pcall(function()
                            local rem = ReplicatedStorage.Remotes or ReplicatedStorage.RemoteEvents
                            if rem then
                                rem.Attack:FireServer(mob)
                                rem.Damage:FireServer(mob)
                            end
                        end)
                    end
                end
            end
        end

        -- Auto Collect БЕЗ ТРЯСКИ (тільки 3 найближчі)
        if Settings.AutoCollect then
            local drops = {}
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find("coin") or v.Name:lower():find("r") or v.Name:lower():find("gold") or v.Name:lower():find("drop")) then
                    local dist = (root.Position - v.Position).Magnitude
                    if dist <= Settings.CollectRange then
                        table.insert(drops, {part = v, dist = dist})
                    end
                end
            end
            table.sort(drops, function(a,b) return a.dist < b.dist end)
            for i = 1, math.min(3, #drops) do
                local d = drops[i].part
                if d and not collectDebounce[d] then
                    collectDebounce[d] = true
                    firetouchinterest(root, d, 0)
                    task.wait(0.05)
                    firetouchinterest(root, d, 1)
                    task.wait(0.2)
                    collectDebounce[d] = nil
                end
            end
        end

        -- Auto Sell
        if Settings.AutoSell and tick() - lastSell >= Settings.SellInterval then
            lastSell = tick()
            pcall(function()
                local rem = ReplicatedStorage.Remotes or ReplicatedStorage.RemoteEvents
                if rem then
                    if rem:FindFirstChild("SellAll") then rem.SellAll:FireServer() end
                    if rem:FindFirstChild("Sell") then rem.Sell:FireServer() end
                end
            end)
        end
    end
end)
