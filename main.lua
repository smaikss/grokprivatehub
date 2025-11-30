-- Arise Shadow Hunt | Grok Hub v8.0 FINAL (NS/Star Logic + OFF Default + No Errors)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Settings = {
    KillAura = false,
    AutoTP = false,
    AutoCollect = false,
    AutoSell = false,
    TPDelay = 2.5,
    SellInterval = 5,
    AuraRange = 40,
    CollectRange = 60,
    SearchRange = 250
}

local lastTP = 0
local lastSell = 0
local collectDebounce = {}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrokHub_v8"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 440, 0, 540)
Main.Position = UDim2.new(0.5, -220, 0.5, -270)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
Title.Text = "GROK HUB v8.0 | NS/Star Fixed"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 16)

-- Кнопка X
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 12)

-- Міні-кнопка G (завжди видно)
local MiniG = Instance.new("TextButton")
MiniG.Size = UDim2.new(0, 70, 0, 70)
MiniG.Position = UDim2.new(1, -90, 1, -90)
MiniG.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
MiniG.Text = "G"
MiniG.TextColor3 = Color3.new(1,1,1)
MiniG.Font = Enum.Font.GothamBold
MiniG.TextSize = 40
MiniG.Parent = ScreenGui
Instance.new("UICorner", MiniG).CornerRadius = UDim.new(1, 0)
MiniG.Active = true
MiniG.Draggable = true

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)
MiniG.MouseButton1Click:Connect(function() Main.Visible = true end)

-- Scrolling
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -80)
Scroll.Position = UDim2.new(0, 10, 0, 70)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.Parent = Main
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Scroll

-- Toggle
local function addToggle(name, key)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 50)
    f.BackgroundTransparency = 1
    f.Parent = Scroll

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.65, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.Gotham
    l.TextSize = 19
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 75, 0, 38)
    b.Position = UDim2.new(1, -80, 0.5, -19)
    b.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(90, 90, 100)
    b.Text = Settings[key] and "ON" or "OFF"
    b.TextColor3 = Color3.new(0,0,0)
    b.Font = Enum.Font.GothamBold
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 20)

    b.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        b.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(90, 90, 100)
        b.Text = Settings[key] and "ON" or "OFF"
    end)
end

addToggle("Kill Aura", "KillAura")
addToggle("Auto TP to Mobs", "AutoTP")
addToggle("Auto Collect R/Gold", "AutoCollect")
addToggle("Auto Sell", "AutoSell")

-- TextBox
local function addBox(name, key)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 55)
    f.BackgroundTransparency = 1
    f.Parent = Scroll

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.55, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.GothamSemibold
    l.TextSize = 18
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(0.4, 0, 0.6, 0)
    tb.Position = UDim2.new(0.58, 0, 0.2, 0)
    tb.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    tb.Text = tostring(Settings[key])
    tb.TextColor3 = Color3.fromRGB(0, 255, 200)
    tb.Font = Enum.Font.GothamBold
    tb.TextSize = 18
    tb.Parent = f
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 10)

    tb.FocusLost:Connect(function(enter)
        if enter then
            local n = tonumber(tb.Text)
            if n and n > 0 then Settings[key] = n end
            tb.Text = tostring(Settings[key])
        end
    end)
end

addBox("TP Delay (сек)", "TPDelay")
addBox("Sell Interval (сек)", "SellInterval")
addBox("Aura Range", "AuraRange")
addBox("Collect Range", "CollectRange")
addBox("Search Range", "SearchRange")

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
end)

print("GROK HUB v8.0 LOADED! Всі тумблери OFF, кнопка G працює")

-- ФАРМ (робоча логіка з NS Hub)
spawn(function()
    while task.wait(0.1) do
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not (hum and root) then continue end

        -- Пошук моба
        for _, mob in pairs(Workspace:GetChildren()) do
            if mob:IsA("Model") and mob ~= char and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                local dist = (root.Position - mob.HumanoidRootPart.Position).Magnitude

                if dist <= Settings.SearchRange then
                    -- Auto TP
                    if Settings.AutoTP and tick() - lastTP >= Settings.TPDelay then
                        hum:MoveTo(mob.HumanoidRootPart.Position + Vector3.new(0, 0, -3))
                        lastTP = tick()
                    end

                    -- Kill Aura (Damage Position + Tool)
                    if Settings.KillAura and dist <= Settings.AuraRange then
                        pcall(function()
                            local rem = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
                            if rem and rem:FindFirstChild("Damage") then
                                rem.Damage:FireServer(mob.HumanoidRootPart.Position)
                            end
                        end)

                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            tool.Parent = char
                            for i = 1, 8 do
                                tool:Activate()
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end
        end

        -- Auto Collect (1 дроп, без тряски)
        if Settings.AutoCollect then
            local closest = nil
            local minDist = Settings.CollectRange
            for _, drop in pairs(Workspace:GetChildren()) do
                if drop:IsA("Part") and not collectDebounce[drop] and (drop.Name:find("Coin") or drop.Name:find("R") or drop.Name:find("Gold") or drop.Name:find("Drop")) then
                    local d = (root.Position - drop.Position).Magnitude
                    if d < minDist then
                        minDist = d
                        closest = drop
                    end
                end
            end
            if closest then
                collectDebounce[closest] = true
                hum:MoveTo(closest.Position)
                if minDist < 15 then
                    firetouchinterest(root, closest, 0)
                    task.wait(0.1)
                    firetouchinterest(root, closest, 1)
                end
                task.wait(0.5)
                collectDebounce[closest] = nil
            end
        end

        -- Auto Sell
        if Settings.AutoSell and tick() - lastSell >= Settings.SellInterval then
            lastSell = tick()
            pcall(function()
                local rem = ReplicatedStorage.Remotes or ReplicatedStorage.RemoteEvents
                if rem then
                    if rem:FindFirstChild("SellAll") then rem.SellAll:FireServer("NormalEq") end
                    if rem:FindFirstChild("Sell") then rem.Sell:FireServer("NormalEq") end
                end
            end)
        end
    end
end)
