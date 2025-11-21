local Players = game:GetService("Players")

local PlayerProgressService = require(
game.ServerScriptService:WaitForChild("GameplayCore"):WaitForChild("Progress"):WaitForChild("PlayerProgressService")
)

local function onPlayerAdded(playerInstance)
	PlayerProgressService.loadPlayerProgress(playerInstance)
end

local function onPlayerRemoving(playerInstance)
	PlayerProgressService.savePlayerProgress(playerInstance)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

game:BindToClose(function()
	PlayerProgressService.saveAllPlayers()
end)
