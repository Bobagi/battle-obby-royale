local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer

local DashActionDisplay = {}

local function getOrCreateHudRoot(existingHudRootGui: ScreenGui?)
        if existingHudRootGui then
                existingHudRootGui.Parent = localPlayer:WaitForChild("PlayerGui")
                return existingHudRootGui
        end

        local playerGui = localPlayer:WaitForChild("PlayerGui")
        local hudRootGui = playerGui:FindFirstChild("PlayerHudGui")

        if not hudRootGui then
                hudRootGui = Instance.new("ScreenGui")
                hudRootGui.Name = "PlayerHudGui"
                hudRootGui.ResetOnSpawn = false
                hudRootGui.IgnoreGuiInset = true
                hudRootGui.Parent = playerGui
        end

        return hudRootGui
end

local function getOrCreateDashHintFrame(hudRootGui: ScreenGui)
        local dashHintFrame = hudRootGui:FindFirstChild("DashHintFrame")

        if not dashHintFrame then
                dashHintFrame = Instance.new("TextLabel")
                dashHintFrame.Name = "DashHintFrame"
                dashHintFrame.Size = UDim2.new(0, 220, 0, 40)
                dashHintFrame.Position = UDim2.new(0, 10, 0, 90)
                dashHintFrame.BackgroundTransparency = 0.3
                dashHintFrame.TextScaled = true
                dashHintFrame.Font = Enum.Font.GothamBold
                dashHintFrame.TextColor3 = Color3.new(1, 1, 1)
                dashHintFrame.Text = "Dash: Shift ou Botão de Toque"
                dashHintFrame.Parent = hudRootGui
        end

        return dashHintFrame
end

function DashActionDisplay.initializeHud(existingHudRootGui: ScreenGui?)
        local hudRootGui = getOrCreateHudRoot(existingHudRootGui)
        getOrCreateDashHintFrame(hudRootGui)
end

return DashActionDisplay
