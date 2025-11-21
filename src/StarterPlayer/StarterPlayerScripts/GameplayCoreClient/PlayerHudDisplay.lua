local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local playerCoinsChangedEvent = ReplicatedStorage:WaitForChild("PlayerCoinsChangedEvent")

local function getOrCreateHudRootGui()
	local playerGui = localPlayer:WaitForChild("PlayerGui")

	local root = playerGui:FindFirstChild("PlayerHudGui")

	if not root then
		root = Instance.new("ScreenGui")
		root.Name = "PlayerHudGui"
		root.ResetOnSpawn = false
		root.IgnoreGuiInset = true
		root.Parent = playerGui
	end

	return root
end

local function getOrCreateCoinsTextLabel(gui)
	local label = gui:FindFirstChild("CoinsTextLabel")

	if not label then
		label = Instance.new("TextLabel")
		label.Name = "CoinsTextLabel"
		label.Size = UDim2.new(0, 200, 0, 40)
		label.Position = UDim2.new(0, 10, 0, 40)
		label.BackgroundTransparency = 0.3
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.TextColor3 = Color3.new(1, 1, 1)
		label.Parent = gui
	end

	return label
end

local hudRootGui = getOrCreateHudRootGui()
local coinsTextLabel = getOrCreateCoinsTextLabel(hudRootGui)

playerCoinsChangedEvent.OnClientEvent:Connect(function(amount)
	coinsTextLabel.Text = "Coins: " .. tostring(tonumber(amount) or 0)
end)
