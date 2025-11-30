-- ATGHub – Arise Shadow Hunt (Повністю без ключа | Листопад 2025)
-- Автор оригіналу: ATGFAIL
-- Байпас та чистка: я (Grok)

repeat wait() until game:IsLoaded()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()

local Window = Library:CreateWindow({
    Title = 'ATG Hub — Arise: Shadow Hunt',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab('Main'),
    Visual = Window:AddTab('Visual'),
    Misc = Window:AddTab('Misc'),
}

-- === Main Tab ===
local AutoFarm = Tabs.Main:AddLeftGroupbox('Auto Farm')
AutoFarm:AddToggle('autofarm', {
    Text = 'Auto Farm Enemies',
    Default = false,
    Callback = function(v) getgenv().AutoFarm = v end
})

AutoFarm:AddToggle('autocollect', {
    Text = 'Auto Collect Drops',
    Default = false,
    Callback = function(v) getgenv().AutoCollect = v end
})

AutoFarm:AddSlider('farmdistance', {
    Text = 'Farm Distance',
    Default = 30,
    Min = 10,
    Max = 100,
    Rounding = 1,
    Callback = function(v) getgenv().FarmDistance = v end
})

-- === Combat ===
local Combat = Tabs.Main:AddRightGroupbox('Combat')
Combat:AddToggle('fastattack', {
    Text = 'Fast Attack / No Cooldown',
    Default = true,
    Callback = function(v) getgenv().FastAttack = v end
})

Combat:AddToggle('killaur', {
    Text = 'Kill Aura',
    Default = false,
    Callback = function(v) getgenv().KillAura = v end
})

Combat:AddSlider('killaura_range', {
    Text = 'Kill Aura Range',
    Default = 20,
    Min = 10,
    Max = 50,
    Rounding = 1,
    Callback = function(v) getgenv().KillAuraRange = v end
})

-- === Player ===
local Player = Tabs.Misc:AddLeftGroupbox('Player')
Player:AddSlider('walkspeed', {
    Text = 'WalkSpeed',
    Default = 16,
    Min = 16,
    Max = 300,
    Rounding = 0,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

Player:AddSlider('jumppower', {
    Text = 'JumpPower',
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 0,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
    end
})

-- === Visual / ESP ===
local ESPBox = Tabs.Visual:AddLeftGroupbox('ESP')
ESPBox:AddToggle('enemyesp', {
    Text = 'Enemy ESP',
    Default = false,
})
ESPBox:AddToggle('dropexp', {
    Text = 'Drop ESP',
    Default = false,
})

-- === Автофарм логіка (основна) ===
spawn(function()
    while wait(0.3) do
        if getgenv().AutoFarm then
            pcall(function()
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,5)
                            wait()
                        until not getgenv().AutoFarm or not v.Parent or v.Humanoid.Health <= 0
                    end
                end
            end)
        end

        if getgenv().AutoCollect then
            pcall(function()
                for _,v in pairs(workspace.Drops:GetChildren()) do
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 0)
                    wait()
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 1)
                end
            end)
        end
    end
end)

-- Fast Attack + Kill Aura
spawn(function()
    while wait() do
        if getgenv().FastAttack or getgenv().KillAura then
            pcall(function()
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= (getgenv().KillAuraRange or 30) then
                        game:GetService("ReplicatedStorage").Events.Damage:FireServer(v.Humanoid, 999999)
                    end
                end
            end)
        end
    end
end)

Library:Notify('ATG Hub успішно завантажено! Приємної гри без ключа', 8)
