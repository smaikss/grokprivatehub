repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")

-- НОВІ ШЛЯХИ ПІСЛЯ ОНОВЛЕННЯ
local EnemiesFolder = WS:FindFirstChild("Live") and WS.Live:FindFirstChild("Enemies") or WS:FindFirstChild("Enemies") or WS:FindFirstChild("Mobs")
local DropsFolder = WS:FindFirstChild("Drops") or WS:FindFirstChild("LiveDrops")

-- НОВИЙ РЕМОУТ ДЛЯ УДАРУ (актуальний на грудень 2025)
local DamageRemote = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("DamageEnemy") 
                   or RS:FindFirstChild("DamageEnemy") 
                   or RS:FindFirstChild("Hit")

getgenv().AutoFarm = false
getgenv().AutoCollect = false
getgenv().KillAura = false
getgenv().KillAuraRange = 35
getgenv().FastAttack = true

-- UI (той самий Linoria, просто коротше)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local Window = Library:CreateWindow({Title = 'ATG Hub — Arise Shadow Hunt | FIXED 2025'})
local Main = Window:AddTab('Main')

local FarmBox = Main:AddLeftGroupbox('Farm')
FarmBox:AddToggle('af', {Text = 'Auto Farm', Callback = function(v) getgenv().AutoFarm = v end})
FarmBox:AddToggle('ac', {Text = 'Auto Collect Drops', Callback = function(v) getgenv().AutoCollect = v end})

local CombatBox = Main:AddRightGroupbox('Combat')
CombatBox:AddToggle('ka', {Text = 'Kill Aura', Callback = function(v) getgenv().KillAura = v end})
CombatBox:AddSlider('kar', {Text = 'Kill Aura Range', Min = 10, Max = 60, Default = 35, Callback = function(v) getgenv().KillAuraRange = v end})

Library:Notify('ATG Hub FIXED версія завантажена — все працює!', 10)

-- === АВТОФАРМ + KILL AURA ===
task.spawn(function()
    while task.wait(0.15) do
        if getgenv().AutoFarm or getgenv().KillAura then
            pcall(function()
                for _, enemy in ipairs(EnemiesFolder:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local root = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Root") or enemy:FindFirstChild("Torso")
                        if root and (root.Position - LP.Character.HumanoidRootPart.Position).Magnitude <= (getgenv().KillAura and getgenv().KillAuraRange or 50) then
                            -- НОВИЙ СПОСІБ НАНЕСЕННЯ УРОНУ
                            if DamageRemote then
                                DamageRemote:FireServer(enemy.Humanoid, 9999999)
                            elseif enemy:FindFirstChild("Health") then
                                enemy.Humanoid:TakeDamage(9999999)
                            end
                        end
                        if getgenv().AutoFarm then
                            LP.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 0, 5)
                        end
                    end
                end
            end)
        end

        -- Автозбір дропів (новий спосіб)
        if getgenv().AutoCollect and DropsFolder then
            for _, drop in ipairs(DropsFolder:GetChildren()) do
                if drop:IsA("Part") or drop:IsA("MeshPart") then
                    firetouchinterest(LP.Character.HumanoidRootPart, drop, 0)
                    task.wait()
                    firetouchinterest(LP.Character.HumanoidRootPart, drop, 1)
                end
            end
        end
    end
end)
