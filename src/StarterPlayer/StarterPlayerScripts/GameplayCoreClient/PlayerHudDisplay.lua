local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local playerCoinsChangedEvent = ReplicatedStorage:WaitForChild("PlayerCoinsChangedEvent")

local PlayerHudDisplay = {}

local function getOrCreateHudRootGui(providedHudRootGui: ScreenGui?)
        if providedHudRootGui then
                providedHudRootGui.Parent = localPlayer:WaitForChild("PlayerGui")
                return providedHudRootGui
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

local function getOrCreateCoinsTextLabel(hudRootGui: ScreenGui)
        local coinsTextLabel = hudRootGui:FindFirstChild("CoinsTextLabel")

        if not coinsTextLabel then
                coinsTextLabel = Instance.new("TextLabel")
                coinsTextLabel.Name = "CoinsTextLabel"
                coinsTextLabel.Size = UDim2.new(0, 200, 0, 40)
                coinsTextLabel.Position = UDim2.new(0, 10, 0, 40)
                coinsTextLabel.BackgroundTransparency = 0.3
                coinsTextLabel.TextScaled = true
                coinsTextLabel.Font = Enum.Font.GothamBold
                coinsTextLabel.TextColor3 = Color3.new(1, 1, 1)
                coinsTextLabel.Parent = hudRootGui
        end

        return coinsTextLabel
end

function PlayerHudDisplay.initializeHud(providedHudRootGui: ScreenGui?)
        local hudRootGui = getOrCreateHudRootGui(providedHudRootGui)
        local coinsTextLabel = getOrCreateCoinsTextLabel(hudRootGui)

        playerCoinsChangedEvent.OnClientEvent:Connect(function(amount)
                coinsTextLabel.Text = "Coins: " .. tostring(tonumber(amount) or 0)
        end)

        return hudRootGui
end

return PlayerHudDisplay
