-- Arise Shadow Hunt | Grok Hub v7.0 (NS/Star Logic: Damage Position + MoveTo + No Shake)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Settings = {
    KillAura = true, AuraRange = 40,
    AutoTP = true, TPDelay = 2.5,
    AutoCollect = true, CollectRange = 60,
    AutoSell = true, SellInterval = 5.0,
    SearchRange = 250
}

local lastTP = 0
local lastSell = 0
local collectDebounce = {}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrokHub_v7"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 440, 0, 520)
Main.Position = UDim2.new(0.5, -220, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Title.Text = "🕷️ GROK HUB v7.0 | NS/Star ФІКС (Position Damage)"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 16)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 10)

local MiniG = Instance.new("TextButton")
MiniG.Size = UDim2.new(0, 65, 0, 65)
MiniG.Position = UDim2.new(1, -85, 1, -85)
MiniG.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
MiniG.Text = "G"
MiniG.TextColor3 = Color3.new(1,1,1)
MiniG.Font = Enum.Font.GothamBold
MiniG.TextSize = 35
MiniG.Parent = ScreenGui
Instance.new("UICorner", MiniG).CornerRadius = UDim.new(1, 0)
MiniG.Active = true
MiniG.Draggable = true

Main.Visible = true
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)
MiniG.MouseButton1Click:Connect(function() Main.Visible = true end)

-- ScrollingFrame
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -80)
Scroll.Position = UDim2.new(0, 10, 0, 70)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6
Scroll.Parent = Main
local Layout = Instance.new("UIListLayout")
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 5)
Layout.Parent = Scroll

-- Toggles (DEFAULT ON)
local function CreateToggle(name, key)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Scroll

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.new(1,1,1)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 18
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 70, 0, 35)
    Toggle.Position = UDim2.new(1, -75, 0.5, -17.5)
    Toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    Toggle.Text = "ON"
    Toggle.TextColor3 = Color3.new(0,0,0)
    Toggle.Font = Enum.Font.GothamBold
    Toggle.Parent = Frame
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 18)

    Settings[key] = true
    Toggle.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        Toggle.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(80, 80, 90)
        Toggle.Text = Settings[key] and "ON" or "OFF"
    end)
end

CreateToggle("Kill Aura", "KillAura")
CreateToggle("Auto TP to Mobs", "AutoTP")
CreateToggle("Auto Collect R", "AutoCollect")
CreateToggle("Auto Sell", "AutoSell")

-- TextBox
local function CreateBox(name, key)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 55)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Scroll

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.55, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ":"
    Label.TextColor3 = Color3.new(1,1,1)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 17
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0.4, 0, 0.6, 0)
    Box.Position = UDim2.new(0.58, 0, 0.2, 0)
    Box.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Box.Text = tostring(Settings[key])
    Box.TextColor3 = Color3.fromRGB(0, 255, 200)
    Box.Font = Enum.Font.GothamBold
    Box.TextSize = 18
    Box.Parent = Frame
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 10)

    Box.FocusLost:Connect(function()
        local num = tonumber(Box.Text)
        if num then Settings[key] = num end
        Box.Text = tostring(Settings[key])
    end)
end

CreateBox("TP Delay (сек)", "TPDelay")
CreateBox("Sell Interval (сек)", "SellInterval")
CreateBox("Aura Range", "AuraRange")
CreateBox("Collect Range", "CollectRange")
CreateBox("Search Range", "SearchRange")

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end)

print("🕷️ GROK HUB v7.0 LOADED! Toggles ON, G button visible")

-- ФАРМ (з референсу)
spawn(function()
    while task.wait(0.12) do
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root or not hum then continue end

        -- Знаходимо моби
        for _, mob in pairs(Workspace:GetChildren()) do
            if mob:IsA("Model") and mob ~= char and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                local dist = (root.Position - mob.HumanoidRootPart.Position).Magnitude
                if dist <= Settings.SearchRange then
                    -- Auto TP
                    if Settings.AutoTP and tick() - lastTP >= Settings.TPDelay then
                        hum:MoveTo(mob.HumanoidRootPart.Position)
                        lastTP = tick()
                    end

                    -- Kill Aura (position FireServer)
                    if Settings.KillAura and dist <= Settings.AuraRange then
                        pcall(function()
                            local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
                            if remotes and remotes:FindFirstChild("Damage") then
                                remotes.Damage:FireServer(mob.HumanoidRootPart.Position)
                            end
                            -- Tool fallback
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then
                                tool.Parent = char
                                tool:Activate()
                            end
                        end)
                    end
                end
            end
        end

        -- Auto Collect (1 drop)
        if Settings.AutoCollect then
            local closestDrop = nil
            local closestDist = Settings.CollectRange
            for _, drop in pairs(Workspace:GetChildren()) do
                if drop:IsA("Part") and not collectDebounce[drop] and (drop.Name:lower():find("coin") or drop.Name:lower():find("r") or drop.Name:lower():find("gold") or drop.Name:lower():find("drop")) then
                    local dist = (root.Position - drop.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestDrop = drop
                    end
                end
            end
            if closestDrop then
                collectDebounce[closestDrop] = true
                hum:MoveTo(closestDrop.Position)
                if closestDist < 15 then
                    firetouchinterest(root, closestDrop, 0)
                    task.wait(0.1)
                    firetouchinterest(root, closestDrop, 1)
                end
                task.wait(0.5)
                collectDebounce[closestDrop] = nil
            end
        end

        -- Auto Sell
        if Settings.AutoSell and tick() - lastSell >= Settings.SellInterval then
            lastSell = tick()
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
                if remotes then
                    remotes:FindFirstChild("SellAll"):FireServer("NormalEq")
                    remotes:FindFirstChild("Sell"):FireServer("NormalEq")
                end
            end)
        end
    end
end)
