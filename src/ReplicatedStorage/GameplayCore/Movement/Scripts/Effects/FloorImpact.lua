--[[
	FloorImpact - An effect that creates a puff of smoke below the character, used when they land after being stunned.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local simpleParticleBurst = require(ReplicatedStorage.GameplayCore.Utility.simpleParticleBurst)

local floorImpactParticlesTemplate = ReplicatedStorage.GameplayCore.Movement.Effects.FloorImpactParticles

local function effect(character: Model)
	local root = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not (root and humanoid) then
		return
	end

	local cframe = root.CFrame * CFrame.new(0, -humanoid.HipHeight, 0)
	simpleParticleBurst(floorImpactParticlesTemplate, cframe)
end

return effect
