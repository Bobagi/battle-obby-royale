local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

local function getOrCreateSpeedTextLabel()
	local playerGui = localPlayer:WaitForChild("PlayerGui")

	local screenGui = playerGui:FindFirstChild("CharacterSpeedGui")

	if not screenGui then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "CharacterSpeedGui"
		screenGui.ResetOnSpawn = false
		screenGui.IgnoreGuiInset = true
		screenGui.Parent = playerGui
	end

	local label = screenGui:FindFirstChild("SpeedLabel")

	if not label then
		label = Instance.new("TextLabel")
		label.Name = "SpeedLabel"
		label.Size = UDim2.new(0, 160, 0, 40)
		label.Position = UDim2.new(0, 10, 1, -50)
		label.BackgroundTransparency = 0.3
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.TextColor3 = Color3.new(1, 1, 1)
		label.Parent = screenGui
	end

	return label
end

local speedTextLabel = getOrCreateSpeedTextLabel()

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
