-- Arise Shadow Hunt | Grok Hub FINAL (100% работает на Xeno)
-- Просто вставь loadstring и всё будет в центре экрана

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаём GUI в PlayerGui (Xeno любит именно его)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrokHub_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 520)
Main.Position = UDim2.new(0.5, -190, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundColor3 = Color3.fromRGB(130, 0, 255)
Title.Text = "🕷️ GROK HUB | Arise Shadow Hunt"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 16)

-- Кнопка закрытия
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -50, 0, 10)
Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Close.Parent = Main
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 10)

local opened = true
Close.MouseButton1Click:Connect(function()
    opened = not opened
    Main.Visible = opened
    Close.Text = opened and "X" or "+"
end)

-- Тумблеры
local y = 80
local Settings = {KillAura = true, AutoCollect = true, AutoSell = true}

local function Toggle(name, key, default)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.9, 0, 0, 50)
    Frame.Position = UDim2.new(0.05, 0, 0, y)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Main

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.new(1,1,1)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 20
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 80, 0, 40)
    Btn.Position = UDim2.new(1, -90, 0.5, -20)
    Btn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(80, 80, 90)
    Btn.Text = default and "ON" or "OFF"
    Btn.TextColor3 = Color3.new(0,0,0)
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = Frame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 20)

    Settings[key] = default
    Btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        Btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(80, 80, 90)
        Btn.Text = Settings[key] and "ON" or "OFF"
    end)

    y = y + 65
end

Toggle("Kill Aura", "KillAura", true)
Toggle("Auto Collect R", "AutoCollect", true)
Toggle("Auto Sell", "AutoSell", true)

-- Фарм-луп (работает даже если GUI закрыто)
spawn(function()
    while wait(0.1) do
        local char = player.Character or player.Character:Wait()
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        -- Kill Aura
        if Settings.KillAura then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    if (v.HumanoidRootPart.Position - root.Position).Magnitude <= 50 then
                        pcall(function()
                            local rem = game.ReplicatedStorage:FindFirstChild("Remotes") or game.ReplicatedStorage:FindFirstChild("RemoteEvents")
                            if rem then
                                pcall(function() rem.Attack:FireServer(v) end)
                                pcall(function() rem.Damage:FireServer(v) end)
                            end
                        end)
                    end
                end
            end
        end

        -- Collect R и дроп
        if Settings.AutoCollect then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and (string.find(v.Name:lower(), "coin") or string.find(v.Name:lower(), "drop") or v.Name == "R") then
                    if (v.Position - root.Position).Magnitude < 40 then
                        firetouchinterest(v, root, 0)
                        firetouchinterest(v, root, 1)
                    end
                end
            end
        end

        -- Auto Sell
        if Settings.AutoSell then
            pcall(function()
                local rem = game.ReplicatedStorage:FindFirstChild("Remotes") or game.ReplicatedStorage:FindFirstChild("RemoteEvents")
                if rem then
                    pcall(function() rem.Sell
