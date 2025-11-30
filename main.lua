-- Grok Hub v9.0 | ATGHub Base (БЕЗ КЛЮЧА, ВСІ ФУНКЦІЇ ON, ПОВНИЙ КОД)
-- Arise Shadow Hunt UPD 9.11+ (30.11.2025)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- === НАЛАШТУВАННЯ ===
local Config = {
    KillAura = true,
    AutoTP = true,
    AutoCollect = true,
    AutoSell = true,
    TPDelay = 2,
    SellDelay = 5,
    AuraRange = 45,
    CollectRange = 70
}

local lastTP = 0
local lastSell = 0
local debounce = {}

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrokHub_v9"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 500)
Main.Position = UDim2.new(0.5, -200, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
local mc = Instance.new("UICorner", Main)
mc.CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Title.Text = "GROK HUB v9.0 | ATG BASE (NO KEY)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = Main
local tc = Instance.new("UICorner", Title)
tc.CornerRadius = UDim.new(0, 16)

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -50, 0, 10)
Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.Font = Enum.Font.GothamBold
Close.Parent = Main
local cc = Instance.new("UICorner", Close)
cc.CornerRadius = UDim.new(0, 12)

local MiniG = Instance.new("TextButton")
MiniG.Size = UDim2.new(0, 70, 0, 70)
MiniG.Position = UDim2.new(1, -90, 1, -90)
MiniG.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
MiniG.Text = "G"
MiniG.TextColor3 = Color3.new(1, 1, 1)
MiniG.Font = Enum.Font.GothamBold
MiniG.TextSize = 40
MiniG.Parent = ScreenGui
local mgc = Instance.new("UICorner", MiniG)
mgc.CornerRadius = UDim.new(1, 0)
MiniG.Active = true
MiniG.Draggable = true

Close.MouseButton1Click:Connect(function() Main.Visible = false end)
MiniG.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Тумблери
local yPos = 80
local function addToggle(name, key)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.9, 0, 0, 50)
    Frame.Position = UDim2.new(0.05, 0, 0, yPos)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Main

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 19
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 75, 0, 38)
    Btn.Position = UDim2.new(1, -80, 0.5, -19)
    Btn.BackgroundColor3 = Config[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(90, 90, 100)
    Btn.Text = Config[key] and "ON" or "OFF"
    Btn.TextColor3 = Color3.new(0, 0, 0)
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = Frame
    local bc = Instance.new("UICorner", Btn)
    bc.CornerRadius = UDim.new(0, 20)

    Btn.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        Btn.BackgroundColor3 = Config[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(90, 90, 100)
        Btn.Text = Config[key] and "ON" or "OFF"
    end)

    yPos = yPos + 60
end

addToggle("Kill Aura", "KillAura")
addToggle("Auto TP to Mobs", "AutoTP")
addToggle("Auto Collect R/Gold", "AutoCollect")
addToggle("Auto Sell", "AutoSell")

print("GROK HUB v9.0 ЗАГРУЖЕНО! Всі функції ON, без ключа")

-- === ГОЛОВНИЙ ЦИКЛ ===
spawn(function()
    while task.wait(0.1) do
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not (hum and root) then continue end

        -- Kill Aura + Auto TP
        for _, mob in pairs(Workspace:GetChildren()) do
            if mob:IsA("Model") and mob ~= char and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                local dist = (root.Position - mob.HumanoidRootPart.Position).Magnitude

                if Config.AutoTP and tick() - lastTP >= Config.TPDelay then
                    hum:MoveTo(mob.HumanoidRootPart.Position + Vector3.new(0, 0, -3))
                    lastTP = tick()
                end

                if Config.KillAura and dist <= Config.AuraRange then
                    pcall(function()
                        local rem = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
                        if rem and rem:FindFirstChild("Damage") then
                            rem.Damage:FireServer(mob.HumanoidRootPart.Position)
                        end
                    end)

                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool.Parent = char
                        tool:Activate()
                    end
                end
            end
        end

        -- Auto Collect (без тряски)
        if Config.AutoCollect then
            local bestDrop, bestDist = nil, Config.CollectRange
            for _, drop in pairs(Workspace:GetChildren()) do
                if drop:IsA("Part") and not debounce[drop] and (drop.Name:find("Coin") or drop.Name:find("R") or drop.Name:find("Gold") or drop.Name:find("Drop")) then
                    local d = (root.Position - drop.Position).Magnitude
                    if d < bestDist then
                        bestDrop = drop
                        bestDist = d
                    end
                end
            end

            if bestDrop then
                debounce[bestDrop] = true
                hum:MoveTo(bestDrop.Position)
                if bestDist < 16 then
                    firetouchinterest(root, bestDrop, 0)
                    task.wait(0.1)
                    firetouchinterest(root, bestDrop, 1)
                end
                task.wait(0.4)
                debounce[bestDrop] = nil
            end
        end

        -- Auto Sell
        if Config.AutoSell and tick() - lastSell >= Config.SellDelay then
            lastSell = tick()
            pcall(function()
                local r = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
                if r then
                    if r:FindFirstChild("SellAll") then r.SellAll:FireServer("NormalEq") end
                    if r:FindFirstChild("Sell") then r.Sell:FireServer("NormalEq") end
                end
            end)
        end
    end
end)
