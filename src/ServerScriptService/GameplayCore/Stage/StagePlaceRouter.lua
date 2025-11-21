local StagePlaceRouter = {}

local stagePlaceIdByStageIndex = {
	[1] = game.PlaceId,
	[2] = 108431109097128,
	[3] = 108431109097128,
	[4] = 3333333333,
}

function StagePlaceRouter.getPlaceIdForStageIndex(stageIndex)
	return stagePlaceIdByStageIndex[stageIndex]
end

function StagePlaceRouter.getHighestValidStagePlaceIdForPlayer(playerInstance, maxUnlockedStageIndex)
	local targetStageIndex = maxUnlockedStageIndex
	while targetStageIndex >= 1 do
		local placeIdForStage = StagePlaceRouter.getPlaceIdForStageIndex(targetStageIndex)
		if placeIdForStage ~= nil then
			return placeIdForStage, targetStageIndex
		end
		targetStageIndex -= 1
	end
	return stagePlaceIdByStageIndex[1], 1
end

return StagePlaceRouter
