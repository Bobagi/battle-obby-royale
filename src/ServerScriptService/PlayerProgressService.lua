--!strict

local ServerScriptService = game:GetService("ServerScriptService")

local gameplayCoreFolder = ServerScriptService:WaitForChild("GameplayCore")
local progressFolder = gameplayCoreFolder:WaitForChild("Progress")
local playerProgressServiceModule = progressFolder:WaitForChild("PlayerProgressService")

local PlayerProgressService = require(playerProgressServiceModule)

return PlayerProgressService
