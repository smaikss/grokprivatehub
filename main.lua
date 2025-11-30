-- Arise Shadow Hunt | Grok Hub v6.0 FINAL (MoveTo TP + Tool Activate + No Shake!)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Settings = {
    KillAura = true, AuraRange = 25,
    AutoTP = true, TPDelay = 3.0,
    AutoCollect = true, CollectRange = 50,
    AutoSell = true, SellInterval = 5.0,
    SearchRange = 200
}

local lastTP = 0
local lastSell = 0
local collectDebounce = {}

-- GUI з ScrollingFrame (не виходить за рамку)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrokHub_v6"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 440, 0, 550)
Main.Position = UDim2.new(0.5, -220, 0.5, -275)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
local mc = Instance.new("UICorner", Main)
mc.CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Title.Text = "🕷️ GROK HUB v6.0 | ФІНАЛЬНИЙ (Tool Activate + MoveTo)"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = Main
local tc = Instance.new("UICorner", Title)
tc.CornerRadius = UDim.new(0, 16)

-- Кнопка X ВСЕРЕДИНІ
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main
local cbc = Instance.new("UICorner", CloseBtn)
cbc.CornerRadius = UDim.new(0, 10)

-- ScrollingFrame для налаштувань
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -90)
Scroll.Position = UDim2.new(0, 10, 0, 70)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 8
Scroll.Parent = Main
local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Padding = UDim.new(0, 8)
ScrollLayout.Parent = Scroll

-- Міні-кнопка G (завжди видно)
local MiniG = Instance.new("TextButton")
MiniG.Size = UDim2.new(0, 65, 0, 65)
MiniG.Position = UDim2.new(1, -85, 1, -85)
MiniG.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
MiniG.Text = "G"
MiniG.TextColor3 = Color3.new(1,1,1)
MiniG.Font = Enum.Font.GothamBold
MiniG.TextSize = 35
MiniG.Parent = ScreenGui
local mbc = Instance.new("UICorner", MiniG)
mbc.CornerRadius = UDim.new(1, 0)
MiniG.Active = true
MiniG.Draggable = true

local mainVisible = true
CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)
MiniG.MouseButton1Click:Connect(function()
    Main.Visible = true
end)

-- Toggle функція (в Scroll)
local function addToggle(name, key, def)
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
    l.TextSize = 18
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 70, 0, 35)
    b.Position = UDim2.new(1, -75, 0.5, -17.5)
    b.BackgroundColor3 = def and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(80, 80, 90)
    b.Text = def and "ON" or "OFF"
    b.TextColor3 = Color3.new(0,0,0)
    b.Font = Enum.Font.GothamBold
    b.Parent = f
    local bc = Instance.new("UICorner", b)
    bc.CornerRadius = UDim.new(0, 18)

    Settings[key] = def
    b.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        b.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(80, 80, 90)
        b.Text = Settings[key] and "ON" or "OFF"
    end)
end

addToggle("Kill Aura", "KillAura", true)
addToggle("Auto TP to Mobs", "AutoTP", true)
addToggle("Auto Collect R", "AutoCollect", true)
addToggle("Auto Sell", "AutoSell", true)

-- TextBox в Scroll (ручний ввід)
local function addTextBox(name, key, def)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 55)
    f.BackgroundTransparency = 1
    f.Parent = Scroll

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.55, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = name .. ":"
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.GothamSemibold
    l.TextSize = 17
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(0.4, 0, 0.6, 0)
    tb.Position = UDim2.new(0.58, 0, 0.2, 0)
    tb.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    tb.Text = tostring(def)
    tb.TextColor3 = Color3.fromRGB(0, 255, 200)
    tb.Font = Enum.Font.GothamBold
    tb.TextSize = 18
    tb.Parent = f
    local tbc = Instance.new("UICorner", tb)
    tbc.CornerRadius = UDim.new(0, 10)

    tb.FocusLost:Connect(function(enter)
        local val = tonumber(tb.Text)
        if val then
            Settings[key] = val
            tb.Text = tostring(val)
        else
            tb.Text = tostring(Settings[key])
        end
    end)
end

addTextBox("TP Delay (сек)", "TPDelay", 3.0)
addTextBox("Sell Interval (сек)", "SellInterval", 5.0)
addTextBox("Aura Range", "AuraRange", 25)
addTextBox("Collect Range", "CollectRange", 50)
addTextBox("Search Range", "SearchRange", 200)

Scroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 20)

ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 20)
end)

print("🕷️ GROK HUB v6.0 LOADED! X/G кнопки + Scroll + DEFAULT ON")

-- === ФАРМ ===
local function getMobs()
    local mobs = {}
    local char = player.Character
    if not char then return mobs end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return mobs end
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= char and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj.Humanoid.Health > 0 then
            local dist = (root.Position - obj.HumanoidRootPart.Position).Magnitude
            if dist <= Settings.SearchRange then
                table.insert(mobs, obj)
            end
        end
    end
    table.sort(mobs, function(a, b)
        return (root.Position - a.HumanoidRootPart.Position).Magnitude < (root.Position - b.HumanoidRootPart.Position).Magnitude
    end)
    return mobs
end

spawn(function()
    while task.wait(0.15) do
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root or not hum then continue end

        local mobs = getMobs()
        if #mobs > 0 then
            local target = mobs[1]

            -- Auto TP (MoveTo, без детекту)
            if Settings.AutoTP and tick() - lastTP >= Settings.TPDelay then
                hum:MoveTo(target.HumanoidRootPart.Position)
                lastTP = tick()
            end

            -- Kill Aura (tool activate, спам)
            if Settings.KillAura then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    tool.Parent = char
                    for i = 1, 15 do
                        tool:Activate()
                        task.wait(0.05)
                    end
                end
            end
        end

        -- Auto Collect (1 drop, MoveTo + touch коли близько)
        if Settings.AutoCollect then
            local drops = {}
            for _, drop in pairs(Workspace:GetChildren()) do
                if drop:IsA("Part") and drop.Name:lower():find("coin") or drop.Name:lower():find("r") or drop.Name:lower():find("gold") or drop.Name:lower():find("drop") then
                    local dist = (root.Position - drop.Position).Magnitude
                    if dist <= Settings.CollectRange and not collectDebounce[drop] then
