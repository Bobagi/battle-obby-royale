local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

local CharacterSpeedDisplay = {}

local function getOrCreateSpeedTextLabel(hudRootGui: ScreenGui?)
        local playerGui = localPlayer:WaitForChild("PlayerGui")
        local speedHudRoot = hudRootGui

        if not speedHudRoot then
                speedHudRoot = playerGui:FindFirstChild("CharacterSpeedGui")
        end

        if not speedHudRoot then
                speedHudRoot = Instance.new("ScreenGui")
                speedHudRoot.Name = "CharacterSpeedGui"
                speedHudRoot.ResetOnSpawn = false
                speedHudRoot.IgnoreGuiInset = true
                speedHudRoot.Parent = playerGui
        end

        local speedTextLabel = speedHudRoot:FindFirstChild("SpeedLabel")

        if not speedTextLabel then
                speedTextLabel = Instance.new("TextLabel")
                speedTextLabel.Name = "SpeedLabel"
                speedTextLabel.Size = UDim2.new(0, 160, 0, 40)
                speedTextLabel.Position = UDim2.new(0, 10, 1, -50)
                speedTextLabel.BackgroundTransparency = 0.3
                speedTextLabel.TextScaled = true
                speedTextLabel.Font = Enum.Font.GothamBold
                speedTextLabel.TextColor3 = Color3.new(1, 1, 1)
                speedTextLabel.Parent = speedHudRoot
        end

        return speedTextLabel
end

function CharacterSpeedDisplay.initializeHud(sharedHudRoot: ScreenGui?)
        local speedTextLabel = getOrCreateSpeedTextLabel(sharedHudRoot)
        local currentRootPart

        localPlayer.CharacterAdded:Connect(function(character)
                currentRootPart = character:WaitForChild("HumanoidRootPart")
        end)

        if localPlayer.Character then
                currentRootPart = localPlayer.Character:WaitForChild("HumanoidRootPart")
        end

        RunService.RenderStepped:Connect(function()
                if currentRootPart then
                        local speed = math.floor(currentRootPart.Velocity.Magnitude + 0.5)
                        speedTextLabel.Text = "Speed: " .. tostring(speed)
                end
        end)
end

return CharacterSpeedDisplay
