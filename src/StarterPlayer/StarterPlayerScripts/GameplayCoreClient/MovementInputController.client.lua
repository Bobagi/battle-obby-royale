--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function initializeMovementController()
        require(ReplicatedStorage.GameplayCore.Movement.Scripts.ControlScript)
        require(ReplicatedStorage.GameplayCore.Movement.Scripts.SmoothCameraScript)
end

initializeMovementController()
