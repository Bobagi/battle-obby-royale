local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local teleportFeedbackEvent = ReplicatedStorage:WaitForChild("TeleportFeedbackEvent")
local localPlayer = Players.LocalPlayer

local function freezePlayer(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		humanoid.AutoRotate = false
	end
end

local function showLoading()
	local playerGui = localPlayer:WaitForChild("PlayerGui")

	if playerGui:FindFirstChild("TeleportLoadingGui") then
		return
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "TeleportLoadingGui"
	gui.ResetOnSpawn = true
	gui.IgnoreGuiInset = true
	gui.Parent = playerGui

	local label = Instance.new("TextLabel")
	label.Name = "LoadingLabel"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "Teleporting..."
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Parent = gui
end

teleportFeedbackEvent.OnClientEvent:Connect(function()
	local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	freezePlayer(character)
	showLoading()
end)
