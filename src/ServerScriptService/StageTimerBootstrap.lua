local Players = game:GetService("Players")
local StageTimerService = require(game.ServerScriptService:WaitForChild("StageTimerService"))

local function onCharacterAdded(playerCharacter)
	local playerInstance = Players:GetPlayerFromCharacter(playerCharacter)
	if not playerInstance then
		return
	end

	StageTimerService.startStageTimerForPlayer(playerInstance)
end

local function onPlayerAdded(playerInstance)
	if playerInstance.Character then
		onCharacterAdded(playerInstance.Character)
	end

	playerInstance.CharacterAdded:Connect(onCharacterAdded)
end

for _, playerInstance in ipairs(Players:GetPlayers()) do
	onPlayerAdded(playerInstance)
end

Players.PlayerAdded:Connect(onPlayerAdded)
