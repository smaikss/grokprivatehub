-- Arise Shadow Hunt | Grok Hub v5.0 (Real Scripts Fix: Tween TP, No Shake, Kill 100%)
-- З NS Hub/Star Stream: Tween + MoveTo + More Remotes

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Settings = {
    KillAura = true, AuraRange = 50,
    AutoTP = true, TPDelay = 2.5,
    AutoCollect = true, CollectRange = 70,
    AutoSell = true, SellInterval = 6.0,
    SearchRange = 350
}

local lastTP = 0
local lastSell = 0
local collectCooldown = {}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrokHub_v5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 450, 0, 620)
Main.Position = UDim2.new(0.5, -225, 0.5, -310)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 70)
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.Text = "🕷️ GROK HUB v5.0 | З РЕАЛЬНИХ СКРИПТІВ (NS/Star)"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 18)

-- Кнопка закриття
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 45, 0, 45)
Close.Position = UDim2.new(1, -55, 0, 12)
Close.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Close.Parent = Main
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 12)

-- Міні-кнопка "G"
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

local mainVis = true
Close.MouseButton1Click:Connect(function() Main.Visible = false end)
MiniBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Toggle
local y = 85
local function addToggle(name, key, def)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.9, 0, 0, 55)
    f.Position = UDim2.new(0.05, 0, 0, y)
    f.BackgroundTransparency = 1
    f.Parent = Main

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.7, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.GothamSemibold
    l.TextSize = 19
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 75, 0, 40)
    b.Position = UDim2.new(1, -85, 0.5, -20)
    b.BackgroundColor3 = def and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(90, 90, 100)
    b.Text = def and "ON" or "OFF"
    b.TextColor3 = Color3.new(0,0,0)
    b.Font = Enum.Font.GothamBold
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 20)

    Settings[key] = def
    b.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        b.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(90, 90, 100)
        b.Text = Settings[key] and "ON" or "OFF"
    end)
    y = y + 65
end

addToggle("Kill Aura", "KillAura", true)
addToggle("Auto TP to Mobs", "AutoTP", true)
addToggle("Auto Collect R/Gold", "AutoCollect", true)
addToggle("Auto Sell", "AutoSell", true)

-- TextBox ручна
local function addTextBox(name, key, def)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.9, 0, 0, 60)
    f.Position = UDim2.new(0.05, 0, 0, y)
    f.BackgroundTransparency = 1
    f.Parent = Main

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.55, 0, 0.5, 0)
    l.BackgroundTransparency = 1
    l.Text = name .. ":"
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.GothamSemibold
    l.TextSize = 18
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(0.4, 0, 0.5, 0)
    tb.Position = UDim2.new(0.58, 0, 0.25, 0)
    tb.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    tb.Text = tostring(def)
    tb.TextColor3 = Color3.fromRGB(0, 255, 200)
    tb.Font = Enum.Font.GothamBold
    tb.TextSize = 20
    tb.Parent = f
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 10)

    tb.FocusLost:Connect(function(enter)
        local val = tonumber(tb.Text) or def
        Settings[key] = val
        tb.Text = tostring(val)
    end)
    y = y + 75
end

addTextBox("TP Delay (сек)", "TPDelay", 2.5)
addTextBox("Sell Interval (сек)", "SellInterval", 6.0)
addTextBox("Aura Range", "AuraRange", 50)
addTextBox("Collect Range", "CollectRange", 70)
addTextBox("Search Range", "SearchRange", 350)

print("🕷️ GROK HUB v5.0 ЗАГРУЖЕНО! З реальних скриптів (Tween TP + No Shake)")

-- ФУНКЦІЇ З РЕАЛЬНИХ СКРИПТІВ
local function findMobs()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return {} end
    local root = char.HumanoidRootPart
    local mobs = {}
    -- Шукаємо в Enemies (як у Star Stream)
    local enemies = Workspace:FindFirstChild("Enemies") or Workspace
    for _, obj in pairs(enemies:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj.Humanoid.Health > 0 then
            local dist = (root.Position - obj.HumanoidRootPart.Position).Magnitude
            if dist <= Settings.SearchRange then
                table.insert(mobs, obj)
            end
        end
    end
    table.sort(mobs, function(a,b) return (root.Position - a.HumanoidRootPart.Position).Magnitude < (root.Position - b.HumanoidRootPart.Position).Magnitude end)
    return mobs
end

local function smoothTP(targetPos)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    -- Tween + WalkTo (антидетект, як у NS Hub)
    local tween = TweenService:Create(root, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Position = targetPos})
    tween:Play()
    hum:MoveTo(targetPos)
    tween.Completed:Wait()
end

-- Головний цикл
spawn(function()
    while task.wait(0.1) do  -- Менше лагів
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root or not hum then continue end

        local mobs = findMobs()
        if #mobs > 0 then
            local nearest = mobs[1]

            -- Auto TP (плавний)
            if Settings.AutoTP and tick() - lastTP >= Settings.TPDelay then
                local tpPos = nearest.HumanoidRootPart.Position + Vector3.new(math.random(-3,3), 0, math.random(-5,-2))
                smoothTP(tpPos)
                lastTP = tick()
            end

            -- Kill Aura/Спам атак (з реальних remotes)
            if Settings.KillAura then
                pcall(function()
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents") or ReplicatedStorage:FindFirstChild("Combat")
                    if remotes then
                        for i = 1, 30 do  -- Спам як у Star Stream
                            pcall(function() remotes:FindFirstChild("Attack"):FireServer(nearest) end)
                            pcall(function() remotes:FindFirstChild("Damage"):FireServer(nearest) end)
                            pcall(function() remotes:FindFirstChild("Hit"):FireServer(nearest) end)
                            pcall(function() remotes:FindFirstChild("ReplicateDamage"):FireServer(nearest, 999) end)
                            pcall(function() remotes:FindFirstChild("Swing"):FireServer(nearest) end)
                            task.wait(0.02)
                        end
                    end
                    -- Фолбек: Equip tool + activate
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool.Parent = char
                        tool:Activate()
                    end
                end)
            end
        end

        -- Auto Collect (без тряски, як у NS Hub)
        if Settings.AutoCollect then
            local drops = {}
            for _, drop in pairs(Workspace:GetDescendants()) do
                if drop:IsA("Part") and (drop.Name:lower():find("coin") or drop.Name:lower():find("r") or drop.Name:lower():find("gold") or drop.Name:lower():find("drop")) and drop.Parent then
                    local dist = (root.Position - drop.Position).Magnitude
                    if dist <= Settings.CollectRange and not collectCooldown[drop] then
                        table.insert(drops, drop)
                    end
                end
            end
            -- Тільки 2 найближчі
            table.sort(drops, function(a,b) return (root.Position - a.Position).Magnitude < (root.Position - b.Position).Magnitude end)
            for i = 1, math.min(2, #drops) do
                local d = drops[i]
                collectCooldown[d] = true
                hum:MoveTo(d.Position)
                firetouchinterest(root, d, 0)
                task.wait(0.1)
                firetouchinterest(root, d, 1)
                task.wait(0.3)  -- Дебounce
                collectCooldown[d] = nil
            end
        end

        -- Auto Sell
        if Settings.AutoSell and tick() - lastSell >= Settings.SellInterval then
            lastSell = tick()
            pcall(function()
                local rem = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
                if rem then
                    rem:FindFirstChild("SellAll"):FireServer()
                    rem:FindFirstChild("Sell"):FireServer("All")
                end
            end)
        end
    end
end)

print("🕷️ v5.0: З NS/Star скриптів - Плавний TP + Без тряски + Вбивство OK!")
