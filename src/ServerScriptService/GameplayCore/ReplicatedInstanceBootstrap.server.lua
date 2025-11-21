--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function ensureFolder(parent: Instance, name: string): Folder
        local existingChild = parent:FindFirstChild(name)
        if existingChild and existingChild:IsA("Folder") then
                return existingChild
        end

        if existingChild then
                existingChild:Destroy()
        end

        local createdFolder = Instance.new("Folder")
        createdFolder.Name = name
        createdFolder.Parent = parent
        return createdFolder
end

local function ensureRemoteEvent(parent: Instance, name: string): RemoteEvent
        local existingChild = parent:FindFirstChild(name)
        if existingChild and existingChild:IsA("RemoteEvent") then
                return existingChild
        end

        if existingChild then
                existingChild:Destroy()
        end

        local remoteEvent = Instance.new("RemoteEvent")
        remoteEvent.Name = name
        remoteEvent.Parent = parent
        return remoteEvent
end

local function ensureRemoteFunction(parent: Instance, name: string): RemoteFunction
        local existingChild = parent:FindFirstChild(name)
        if existingChild and existingChild:IsA("RemoteFunction") then
                return existingChild
        end

        if existingChild then
                existingChild:Destroy()
        end

        local remoteFunction = Instance.new("RemoteFunction")
        remoteFunction.Name = name
        remoteFunction.Parent = parent
        return remoteFunction
end

local function ensureGameplayCoreFolder(): Folder
        local gameplayCore = ReplicatedStorage:FindFirstChild("GameplayCore")
        if gameplayCore and gameplayCore:IsA("Folder") then
                return gameplayCore
        end

        local createdFolder = Instance.new("Folder")
        createdFolder.Name = "GameplayCore"
        createdFolder.Parent = ReplicatedStorage
        return createdFolder
end

local function initializeMovementRemotes(gameplayCoreFolder: Folder)
        local movementFolder = ensureFolder(gameplayCoreFolder, "Movement")
        local remotesFolder = ensureFolder(movementFolder, "Remotes")
        ensureRemoteEvent(remotesFolder, "SetAction")
end

local function initializeGameplayRemotes(gameplayCoreFolder: Folder)
        local gameplayFolder = ensureFolder(gameplayCoreFolder, "Gameplay")
        local remotesFolder = ensureFolder(gameplayFolder, "Remotes")
        ensureRemoteFunction(remotesFolder, "PickupCoin")
end

local function initializeRootRemotes()
        ensureRemoteEvent(ReplicatedStorage, "PlayerCoinsChangedEvent")
        ensureRemoteEvent(ReplicatedStorage, "TeleportFeedbackEvent")
end

local function bootstrapReplicatedInstances()
        local gameplayCoreFolder = ensureGameplayCoreFolder()
        initializeMovementRemotes(gameplayCoreFolder)
        initializeGameplayRemotes(gameplayCoreFolder)
        initializeRootRemotes()
end

bootstrapReplicatedInstances()
