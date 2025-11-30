print("=== GROK HUB v4 START ===")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
print("=== GROK HUB v4: Players OK ===")

local Settings = {
    KillAura = true, KillAuraRange = 45,
    AutoCollect = true, CollectRange = 30,
    AutoSell = true, SellInterval = 6,
    FastAttack = true
}
print("=== GROK HUB v4: Settings OK ===")

-- CoreGui Fallback to PlayerGui (exploit magic)
local coregui = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or nil
local playerGui = player:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrokHubV4"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = coregui or playerGui
print("=== GROK HUB v4: GUI Parent =", ScreenGui.Parent.Name, "===")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 450)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
print("=== GROK HUB v4: Frame OK ===")

-- Title (basic font)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
Title.Text = "🕷️ GROK HUB v4 | Arise Shadow Hunt"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame
print("=== GROK HUB v4: Title OK ===")

-- Hide Btn
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 35, 0, 35)
HideBtn.Position = UDim2.new(1, -45, 0, 7.5)
HideBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
HideBtn.Text = "X"
HideBtn.TextColor3 = Color3.new(1,1,1)
HideBtn.Font = Enum.Font.SourceSansBold
HideBtn.Parent = MainFrame
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0, 8)
local hidden = false
HideBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    MainFrame.Visible = not hidden
    HideBtn.Text = hidden and "+" or "X"
end)
print("=== GROK HUB v4: GUI FULLY LOADED! ===")

-- Toggles (simple)
local y = 65
local function addToggle(name, def)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 45)
    frame.Position = UDim2.new(0.05, 0, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = MainFrame

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 55, 0, 28)
    btn.Position = UDim2.new(1, -65, 0.5, -14)
    btn.BackgroundColor3 = def and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
    btn.Text = def and "ON" or "OFF"
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)

    local key = name:gsub("%s+", "")
    Settings[key] = def
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
        btn.Text = Settings[key] and "ON" or "OFF"
    end)
    y = y + 55
end

addToggle("Kill Aura", true)
addToggle("Auto Collect", true)
addToggle("Auto Sell", true)
addToggle("Fast Attack", true)

print("=== GROK HUB v4: TOGGLES OK ===")

-- Farm Loop
local char, hum, root = nil, nil, nil
local lastSell = 0

local function updateChar()
    char = player.Character
    if char then
        hum = char:FindFirstChild("Humanoid")
        root = char:FindFirstChild("HumanoidRootPart")
    end
end
updateChar()
player.CharacterAdded:Connect(updateChar)

local function farmLoop()
    if not root then return end
    -- Kill Aura
    if Settings.KillAura then
        for _, m in pairs(Workspace:GetDescendants()) do
            if m:IsA("Model") and m ~= char and m:FindFirstChild("Humanoid") and m:FindFirstChild("HumanoidRootPart") and m.Humanoid.Health > 0 then
                local d = (root.Position - m.HumanoidRootPart.Position).Magnitude
                if d <= Settings.KillAuraRange then
                    pcall(function()
                        local rem = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
                        if rem then
                            pcall(function() rem.Attack:FireServer(m) end)
                            pcall(function() rem.Damage:FireServer(m) end)
                        end
                    end)
                end
            end
        end
    end
    -- Collect
    if Settings.AutoCollect then
        for _, d in pairs(Workspace:GetDescendants()) do
            if d:IsA("BasePart") and (d.Name:lower():find("coin") or d.Name:lower():find("r") or d.Name:lower():find("drop")) then
                local dist = (root.Position - d.Position).Magnitude
                if dist <= Settings.CollectRange then
                    firetouchinterest(root, d, 0)
                    task.wait()
                    firetouchinterest(root, d, 1)
                end
            end
        end
    end
    -- Sell
    if Settings.AutoSell and tick() - lastSell > Settings.SellInterval then
        lastSell = tick()
        pcall(function()
            local rem = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
            if rem then
                pcall(function() rem.SellAll:FireServer() end)
                pcall(function() rem.Sell:FireServer() end)
            end
        end)
        print("🪙 SELL!")
    end
end

spawn(function()
    while task.wait(0.12) do pcall(farmLoop) end
end)

print("🚀 GROK HUB v4: ФАРМ 100% АКТИВЕН! GUI в центре!")
