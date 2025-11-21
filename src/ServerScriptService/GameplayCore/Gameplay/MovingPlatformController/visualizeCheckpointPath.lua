--[[
	visualizeCheckpointPath - A utility function to create beams in between the checkpoints for a moving platform.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local getOrCreateAttachment = require(ReplicatedStorage.GameplayCore.Utility.getOrCreateAttachment)

local gameplayFolder = ReplicatedStorage:WaitForChild("GameplayCore"):WaitForChild("Gameplay")
local objectsFolder = gameplayFolder:FindFirstChild("Objects")
if not objectsFolder or not objectsFolder:IsA("Folder") then
        if objectsFolder then
                objectsFolder:Destroy()
        end

        objectsFolder = Instance.new("Folder")
        objectsFolder.Name = "Objects"
        objectsFolder.Parent = gameplayFolder
end

local beamTemplate = objectsFolder:FindFirstChild("PlatformPathBeam")
if not beamTemplate or not beamTemplate:IsA("Beam") then
        if beamTemplate then
                beamTemplate:Destroy()
        end

        local defaultBeamTemplate = Instance.new("Beam")
        defaultBeamTemplate.Name = "PlatformPathBeam"
        defaultBeamTemplate.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        defaultBeamTemplate.LightEmission = 0.75
        defaultBeamTemplate.Width0 = 0.1
        defaultBeamTemplate.Width1 = 0.1
        defaultBeamTemplate.FaceCamera = true
        defaultBeamTemplate.Parent = objectsFolder
        beamTemplate = defaultBeamTemplate
end

local function visualizeCheckpointPath(checkpoints: { BasePart })
	for index, checkpoint in checkpoints do
		checkpoint.Transparency = 1

		if #checkpoints == 2 and index == 2 then
			-- If there are only two checkpoints, no need to create a second beam back from Checkpoint2 to Checkpoint1
			return
		end

		-- Create a beam between the two checkpoints
		local nextCheckpoint = checkpoints[index + 1] or checkpoints[1]
		local checkpointAttachment = getOrCreateAttachment(checkpoint, "PlatformPathAttachment")
		local nextCheckpointAttachment = getOrCreateAttachment(nextCheckpoint, "PlatformPathAttachment")

		local beam = beamTemplate:Clone()
		beam.Attachment0 = checkpointAttachment
		beam.Attachment1 = nextCheckpointAttachment
		beam.Parent = checkpoint
	end
end

return visualizeCheckpointPath
