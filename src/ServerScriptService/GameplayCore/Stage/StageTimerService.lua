local Players = game:GetService("Players")

local StageTimerService = {}

local activeStageTimersByUserId = {}

function StageTimerService.startStageTimerForPlayer(playerInstance)
	if not playerInstance then
		return
	end

	activeStageTimersByUserId[playerInstance.UserId] = tick()
end

function StageTimerService.finishStageTimerForPlayer(playerInstance)
	if not playerInstance then
		return nil
	end

	local playerUserId = playerInstance.UserId
	local startTimestampSeconds = activeStageTimersByUserId[playerUserId]
	if not startTimestampSeconds then
		return nil
	end

	activeStageTimersByUserId[playerUserId] = nil

	local elapsedSeconds = tick() - startTimestampSeconds
	if elapsedSeconds < 0 then
		elapsedSeconds = 0
	end

	return elapsedSeconds
end

function StageTimerService.resetStageTimerForPlayer(playerInstance)
	if not playerInstance then
		return
	end

	activeStageTimersByUserId[playerInstance.UserId] = nil
end

function StageTimerService.resetAllStageTimers()
	for playerUserId, _ in pairs(activeStageTimersByUserId) do
		activeStageTimersByUserId[playerUserId] = nil
	end
end

Players.PlayerRemoving:Connect(function(playerInstance)
	StageTimerService.resetStageTimerForPlayer(playerInstance)
end)

return StageTimerService
