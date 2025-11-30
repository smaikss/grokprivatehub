-- Arise Shadow Hunt | Grok Hub FINAL (100% Xeno OK)
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrokHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,380,0,500)
Main.Position = UDim2.new(0.5,-190,0.5,-250)
Main.BackgroundColor3 = Color3.fromRGB(25,25,35)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
local mc = Instance.new("UICorner",Main); mc.CornerRadius = UDim.new(0,15)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,55)
Title.BackgroundColor3 = Color3.fromRGB(0,170,255)
Title.Text = "🕷️ GROK HUB | Arise Shadow Hunt"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = Main
local tc = Instance.new("UICorner",Title); tc.CornerRadius = UDim.new(0,15)

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0,35,0,35)
Close.Position = UDim2.new(1,-45,0,10)
Close.BackgroundColor3 = Color3.fromRGB(255,60,60)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Close.Parent = Main
local cc = Instance.new("UICorner",Close); cc.CornerRadius = UDim.new(0,8)

local vis = true
Close.MouseButton1Click:Connect(function()
    vis = not vis
    Main.Visible = vis
    Close.Text = vis and "X" or "+"
end)

local y = 70
local Settings = {KillAura=true, Collect=true, Sell=true}

local function tog(name, key)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.9,0,0,50)
    f.Position = UDim2.new(0.05,0,0,y)
    f.BackgroundTransparency = 1
    f.Parent = Main

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.65,0,1,0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.Gotham
    l.TextSize = 18
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,70,0,35)
    b.Position = UDim2.new(1,-80,0.5,-17.5)
    b.BackgroundColor3 = Settings[key] and Color3.fromRGB(0,255,0) or Color3.fromRGB(100,100,100)
    b.Text = Settings[key] and "ON" or "OFF"
    b.TextColor3 = Color3.new(0,0,0)
    b.Font = Enum.Font.GothamBold
    b.Parent = f
    local bc = Instance.new("UICorner",b); bc.CornerRadius = UDim.new(0,18)

    b.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        b.BackgroundColor3 = Settings[key] and Color3.fromRGB(0,255,0) or Color3.fromRGB(100,100,100)
        b.Text = Settings[key] and "ON" or "OFF"
    end)
    y = y + 60
end

tog("Kill Aura", "KillAura")
tog("Auto Collect R", "Collect")
tog("Auto Sell", "Sell")

spawn(function()
    while wait(0.1) do
        local char = player.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        if Settings.KillAura then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
                    if (root.Position - v.HumanoidRootPart.Position).Magnitude <= 60 then
                        pcall(function()
                            local r = game.ReplicatedStorage:FindFirstChild("Remotes") or game.ReplicatedStorage:FindFirstChild("RemoteEvents")
                            if r then
                                pcall(function() r.Attack:FireServer(v) end)
                                pcall(function() r.Damage:FireServer(v) end)
                                pcall(function() r.Hit:FireServer(v) end)
                            end
                        end)
                    end
                end
            end
        end

        if Settings.Collect then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") and (v.Name:lower():find("coin") or v.Name:lower():find("r") or v.Name:lower():find("drop")) then
                    if (root.Position - v.Position).Magnitude < 50 then
                        firetouchinterest(root, v, 0)
                        wait()
                        firetouchinterest(root, v, 1)
                    end
                end
            end
        end

        if Settings.Sell then
            pcall(function()
                local r = game.ReplicatedStorage:FindFirstChild("Remotes") or game.ReplicatedStorage:FindFirstChild("RemoteEvents")
                if r then
                    pcall(function() r.SellAll:FireServer() end)
                    pcall(function() r.Sell:FireServer() end)
                end
            end)
        end
    end
end)

print("🕷️ GROK HUB LOADED! Синяя панель в центре")
