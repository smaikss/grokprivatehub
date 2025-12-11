-- Оновлений Fly для UMT (без heartbeat запитів)
local PLAYER = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RUNSERVICE = game:GetService("RunService")
local CAMERA = workspace.CurrentCamera

local FLY_SPEED = 50
local FLYING = false
local BODY_VEL = nil

-- GUI (простий, без CoreGui конфліктів)
local SG = Instance.new("ScreenGui", game.CoreGui)
local FR = Instance.new("Frame", SG)
FR.Size, FR.Position, FR.BackgroundColor3, FR.Visible = UDim2.new(0,200,0,150), UDim2.new(0,10,0,10), Color3.new(0.2,0.2,0.2), false

local TGL = Instance.new("TextButton", FR)
TGL.Size, TGL.Position, TGL.Text = UDim2.new(1,0,0,30), UDim2.new(0,0,0,0), "Fly: OFF"

local SPD = Instance.new("TextBox", FR)
SPD.Size, SPD.Position, SPD.Text = UDim2.new(1,0,0,30), UDim2.new(0,0,0,40), "50"

-- Fly функції
local function FLY()
    if not PLAYER.Character or not PLAYER.Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = PLAYER.Character.HumanoidRootPart
    BODY_VEL = Instance.new("BodyVelocity", HRP)
    BODY_VEL.MaxForce = Vector3.new(4000,4000,4000)
    BODY_VEL.Velocity = Vector3.new(0,0,0)
    FLYING = true
    TGL.Text = "Fly: ON"
    spawn(function()
        repeat RUNSERVICE.Heartbeat:Wait() until not FLYING
        if BODY_VEL then BODY_VEL:Destroy() end
    end)
    RUNSERVICE.Heartbeat:Connect(function()
        if FLYING and HRP.Parent then
            local MOVE = Vector3.new()
            local CAM = CAMERA.CFrame
            if UIS:IsKeyDown(Enum.KeyCode.W) then MOVE = MOVE + CAM.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then MOVE = MOVE - CAM.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then MOVE = MOVE - CAM.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then MOVE = MOVE + CAM.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then MOVE = MOVE + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then MOVE = MOVE + Vector3.new(0,-1,0) end
            BODY_VEL.Velocity = MOVE.Unit * FLY_SPEED
        end
    end)
end

local function STOP() FLYING = false TGL.Text = "Fly: OFF" end
local function TOGGLE() if FLYING then STOP() else FLY() end end

TGL.MouseButton1Click:Connect(TOGGLE)
SPD.FocusLost:Connect(function() local N = tonumber(SPD.Text); if N and N>0 then FLY_SPEED = N end SPD.Text = tostring(FLY_SPEED) end)

UIS.InputBegan:Connect(function(I) if I.KeyCode == Enum.KeyCode.RightShift then FR.Visible = not FR.Visible elseif I.KeyCode == Enum.KeyCode.F then TOGGLE() end end)

print("Nfly GUI завантажено для UMT! RightShift - меню, F - toggle")
