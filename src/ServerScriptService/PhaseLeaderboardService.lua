local DataStoreService = game:GetService("DataStoreService")

local PhaseLeaderboardService = {}

local function getPhaseOrderedDataStore(phaseIndex)
	local orderedStoreName = "PhaseBestTimes_" .. tostring(phaseIndex)
	local orderedDataStore = DataStoreService:GetOrderedDataStore(orderedStoreName)
	return orderedDataStore
end

function PhaseLeaderboardService.submitPhaseTime(playerInstance, phaseIndex, timeInSeconds)
	local orderedDataStore = getPhaseOrderedDataStore(phaseIndex)
	local success, _ = pcall(function()
		orderedDataStore:SetAsync(tostring(playerInstance.UserId), timeInSeconds)
	end)
	return success
end

return PhaseLeaderboardService
