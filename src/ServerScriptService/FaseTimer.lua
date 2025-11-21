local Players = game:GetService("Players")
local playerTimers = {}

local FaseTimer = {}

function FaseTimer.start(player)
	playerTimers[player.UserId] = tick()
end

function FaseTimer.finish(player)
	local startTime = playerTimers[player.UserId]
	if not startTime then
		return 9999
	end

	local total = tick() - startTime
	playerTimers[player.UserId] = nil
	return total
end

return FaseTimer
