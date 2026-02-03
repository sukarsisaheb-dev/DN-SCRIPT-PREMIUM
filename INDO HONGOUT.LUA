-- =====================================================
-- INDO HANGOUT ULTRA HUB
-- UI LIBRARY : RAYFIELD
-- =====================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- =====================================================
-- UI LOAD
-- =====================================================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "🇮🇩 Indo Hangout Ultra Hub",
    LoadingTitle = "Indo Hangout",
    LoadingSubtitle = "Ultimate Utility Hub",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "IndoHangout",
        FileName = "UltraConfig"
    }
})

-- =====================================================
-- TABS
-- =====================================================
local PlayerTab = Window:CreateTab("👤 Player")
local ESPTab    = Window:CreateTab("👁 ESP")
local TeleTab   = Window:CreateTab("📍 Teleport")
local MiscTab   = Window:CreateTab("🛠 Misc")
local SetTab    = Window:CreateTab("⚙ Settings")

-- =====================================================
-- VARIABLES
-- =====================================================
local WS, JP = 16, 50
local InfJump, Noclip, GodMode = false,false,false
local SavedPos = {}

-- =====================================================
-- PLAYER TAB
-- =====================================================
PlayerTab:CreateSlider({
    Name="WalkSpeed",
    Range={0,200},
    Increment=1,
    CurrentValue=16,
    Callback=function(v) WS=v end
})

PlayerTab:CreateSlider({
    Name="JumpPower",
    Range={0,200},
    Increment=5,
    CurrentValue=50,
    Callback=function(v) JP=v end
})

PlayerTab:CreateToggle({
    Name="Infinite Jump",
    CurrentValue=false,
    Callback=function(v) InfJump=v end
})

PlayerTab:CreateToggle({
    Name="Noclip",
    CurrentValue=false,
    Callback=function(v) Noclip=v end
})

PlayerTab:CreateToggle({
    Name="God Mode (Game Dependent)",
    CurrentValue=false,
    Callback=function(v)
        GodMode=v
        -- placeholder (game specific)
    end
})

PlayerTab:CreateButton({
    Name="Reset Avatar",
    Callback=function()
        LP.Character:BreakJoints()
    end
})

PlayerTab:CreateButton({
    Name="Copy Avatar (Appearance)",
    Callback=function()
        setclipboard(LP.Character.HumanoidDescription:ToString())
    end
})

PlayerTab:CreateToggle({
    Name="Infinite Zoom",
    CurrentValue=false,
    Callback=function(v)
        LP.CameraMaxZoomDistance = v and math.huge or 128
    end
})

PlayerTab:CreateSlider({
    Name="FOV",
    Range={40,120},
    Increment=1,
    CurrentValue=70,
    Callback=function(v) Camera.FieldOfView=v end
})

-- =====================================================
-- ESP TAB (STRUCTURE)
-- =====================================================
ESPTab:CreateToggle({
    Name="ESP All Players",
    CurrentValue=false,
    Callback=function(v)
        -- ESP logic placeholder
    end
})

ESPTab:CreateToggle({Name="ESP Box",CurrentValue=false,Callback=function()end})
ESPTab:CreateToggle({Name="ESP Name",CurrentValue=false,Callback=function()end})
ESPTab:CreateToggle({Name="ESP Distance",CurrentValue=false,Callback=function()end})
ESPTab:CreateToggle({Name="ESP Tracer",CurrentValue=false,Callback=function()end})

ESPTab:CreateButton({
    Name="Clear ESP",
    Callback=function()
        -- clear drawings
    end
})

-- =====================================================
-- TELEPORT TAB
-- =====================================================
TeleTab:CreateButton({
    Name="Save Position",
    Callback=function()
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then table.insert(SavedPos, hrp.CFrame) end
    end
})

TeleTab:CreateButton({
    Name="Teleport to Saved Position",
    Callback=function()
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp and SavedPos[#SavedPos] then
            hrp.CFrame = SavedPos[#SavedPos]
        end
    end
})

TeleTab:CreateButton({
    Name="Delete Saved Position",
    Callback=function()
        table.remove(SavedPos,#SavedPos)
    end
})

-- =====================================================
-- MISC TAB
-- =====================================================
MiscTab:CreateToggle({
    Name="Anti AFK",
    CurrentValue=true,
    Callback=function(v)
        if v then
            local vu = game:GetService("VirtualUser")
            LP.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0),Camera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0),Camera.CFrame)
            end)
        end
    end
})

MiscTab:CreateToggle({
    Name="Fullbright",
    CurrentValue=false,
    Callback=function(v)
        Lighting.Brightness = v and 5 or 1
        Lighting.ClockTime = v and 14 or 12
    end
})

MiscTab:CreateToggle({
    Name="X-Ray",
    CurrentValue=false,
    Callback=function(v)
        for _,p in pairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") then
                p.LocalTransparencyModifier = v and 0.6 or 0
            end
        end
    end
})

MiscTab:CreateButton({
    Name="Reduce Lag",
    Callback=function()
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material=Enum.Material.SmoothPlastic
                v.Reflectance=0
            end
        end
    end
})

-- =====================================================
-- SETTINGS TAB
-- =====================================================
SetTab:CreateButton({
    Name="Unlock FPS",
    Callback=function()
        setfpscap(999)
    end
})

SetTab:CreateToggle({
    Name="Hide Delta Line",
    CurrentValue=false,
    Callback=function() end
})

-- =====================================================
-- LOOP
-- =====================================================
RunService.RenderStepped:Connect(function()
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = WS
        hum.JumpPower = JP
    end
end)

UIS.JumpRequest:Connect(function()
    if InfJump then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

print("✅ Indo Hangout Ultra Hub Loaded")
