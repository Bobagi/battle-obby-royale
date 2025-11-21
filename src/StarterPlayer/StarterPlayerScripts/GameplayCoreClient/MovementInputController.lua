local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function initializeMovementControllers()
        local movementScriptsRoot = ReplicatedStorage.GameplayCore.Movement.Scripts

        require(movementScriptsRoot.ControlScript)
        require(movementScriptsRoot.SmoothCameraScript)
        require(movementScriptsRoot.FXScript)
end

local function initializeGameplayControllers()
        local gameplayScriptsRoot = ReplicatedStorage.GameplayCore.Gameplay.Scripts

        require(gameplayScriptsRoot.CoinsScript)
end

local function initializeClientControllers()
        initializeMovementControllers()
        initializeGameplayControllers()
end

initializeClientControllers()