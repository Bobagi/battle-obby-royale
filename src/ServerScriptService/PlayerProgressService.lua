local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local playerProgressDataStore = DataStoreService:GetDataStore("PlayerProgress")
local cachedPlayerProgressByUserId = {}

local playerCoinsChangedEvent = ReplicatedStorage:FindFirstChild("PlayerCoinsChangedEvent")

local PlayerProgressService = {}

local function createDefaultPlayerProgress()
	local defaultPlayerProgress = {
		maxUnlockedStageIndex = 1,
		ownedCosmeticIds = {},
		bestPhaseTimes = {},
		coins = 0,
	}
	return defaultPlayerProgress
end

local function mergeLoadedPlayerProgress(loadedPlayerProgress)
	local mergedPlayerProgress = createDefaultPlayerProgress()
	for loadedKey, loadedValue in pairs(loadedPlayerProgress) do
		mergedPlayerProgress[loadedKey] = loadedValue
	end
	return mergedPlayerProgress
end

local function notifyPlayerCoinsChanged(playerInstance, newCoinsAmount)
	if not playerInstance then
		return
	end

	if not playerCoinsChangedEvent then
		playerCoinsChangedEvent = ReplicatedStorage:FindFirstChild("PlayerCoinsChangedEvent")
	end

	if playerCoinsChangedEvent then
		playerCoinsChangedEvent:FireClient(playerInstance, newCoinsAmount)
	end
end

function PlayerProgressService.loadPlayerProgress(playerInstance)
	local playerUserId = playerInstance.UserId
	local cachedProgress = cachedPlayerProgressByUserId[playerUserId]
	if cachedProgress then
		notifyPlayerCoinsChanged(playerInstance, cachedProgress.coins or 0)
		return cachedProgress
	end

	local success, loadedData = pcall(function()
		return playerProgressDataStore:GetAsync(tostring(playerUserId))
	end)

	if not success or loadedData == nil then
		local defaultPlayerProgress = createDefaultPlayerProgress()
		cachedPlayerProgressByUserId[playerUserId] = defaultPlayerProgress
		notifyPlayerCoinsChanged(playerInstance, defaultPlayerProgress.coins)
		return defaultPlayerProgress
	end

	local mergedPlayerProgress = mergeLoadedPlayerProgress(loadedData)
	cachedPlayerProgressByUserId[playerUserId] = mergedPlayerProgress
	notifyPlayerCoinsChanged(playerInstance, mergedPlayerProgress.coins or 0)
	return mergedPlayerProgress
end

function PlayerProgressService.getPlayerProgress(playerInstance)
	local playerUserId = playerInstance.UserId
	local cachedProgress = cachedPlayerProgressByUserId[playerUserId]
	if not cachedProgress then
		return PlayerProgressService.loadPlayerProgress(playerInstance)
	end
	return cachedProgress
end

function PlayerProgressService.updateMaxUnlockedStageIndex(playerInstance, newStageIndex)
	local playerProgress = PlayerProgressService.getPlayerProgress(playerInstance)
	if newStageIndex > playerProgress.maxUnlockedStageIndex then
		playerProgress.maxUnlockedStageIndex = newStageIndex
	end
end

function PlayerProgressService.updateOwnedCosmeticIds(playerInstance, newOwnedCosmeticIds)
	local playerProgress = PlayerProgressService.getPlayerProgress(playerInstance)
	playerProgress.ownedCosmeticIds = newOwnedCosmeticIds
end

function PlayerProgressService.updateBestPhaseTime(playerInstance, phaseIndex, newBestTimeSeconds)
	local playerProgress = PlayerProgressService.getPlayerProgress(playerInstance)
	local currentBestTimesByPhaseIndex = playerProgress.bestPhaseTimes or {}
	local currentBestTimeForPhase = currentBestTimesByPhaseIndex[phaseIndex]

	if currentBestTimeForPhase == nil or newBestTimeSeconds < currentBestTimeForPhase then
		currentBestTimesByPhaseIndex[phaseIndex] = newBestTimeSeconds
		playerProgress.bestPhaseTimes = currentBestTimesByPhaseIndex
		return true
	end

	return false
end

function PlayerProgressService.addCoins(playerInstance, coinsDelta)
	local playerProgress = PlayerProgressService.getPlayerProgress(playerInstance)
	playerProgress.coins = (playerProgress.coins or 0) + coinsDelta
	if playerProgress.coins < 0 then
		playerProgress.coins = 0
	end
	notifyPlayerCoinsChanged(playerInstance, playerProgress.coins)
end

function PlayerProgressService.getCoins(playerInstance)
	local playerProgress = PlayerProgressService.getPlayerProgress(playerInstance)
	return playerProgress.coins or 0
end

function PlayerProgressService.savePlayerProgress(playerInstance)
	local playerUserId = playerInstance.UserId
	local playerProgress = cachedPlayerProgressByUserId[playerUserId]
	if not playerProgress then
		return
	end

	local success, _ = pcall(function()
		playerProgressDataStore:SetAsync(tostring(playerUserId), playerProgress)
	end)

	return success
end

function PlayerProgressService.saveAllPlayers()
	for playerUserId, _ in pairs(cachedPlayerProgressByUserId) do
		local playerInstance = game.Players:GetPlayerByUserId(playerUserId)
		if playerInstance then
			PlayerProgressService.savePlayerProgress(playerInstance)
		end
	end
end

return PlayerProgressService
