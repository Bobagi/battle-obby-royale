local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerHudDisplay = require(script.Parent.PlayerHudDisplay)
local CharacterSpeedDisplay = require(script.Parent.CharacterSpeedDisplay)
local DashActionDisplay = require(script.Parent.DashActionDisplay)

local function getOrCreateSharedHudRoot()
        local gameplayUiFolder = ReplicatedStorage:WaitForChild("GameplayCore"):WaitForChild("UI")
        local sharedHudTemplate = gameplayUiFolder:FindFirstChild("Hud")

        if sharedHudTemplate and sharedHudTemplate:IsA("ScreenGui") then
                local clonedHudTemplate = sharedHudTemplate:Clone()
                clonedHudTemplate.ResetOnSpawn = false
                clonedHudTemplate.IgnoreGuiInset = true
                clonedHudTemplate.Name = "PlayerHudGui"
                return clonedHudTemplate
        end

        return nil
end

local function initializeHud()
        local hudRootGui = PlayerHudDisplay.initializeHud(getOrCreateSharedHudRoot())

        CharacterSpeedDisplay.initializeHud(hudRootGui)
        DashActionDisplay.initializeHud(hudRootGui)
end

initializeHud()