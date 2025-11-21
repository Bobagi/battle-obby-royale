--[[
	CoinController - This module script implements the class for a coin pickup. Touch events are
	connected to on the client in order to minimize visual latency when picking up coins.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Constants = require(ReplicatedStorage.GameplayCore.Gameplay.Constants)
local disconnectAndClear = require(ReplicatedStorage.GameplayCore.Utility.disconnectAndClear)
local playSoundFromSource = require(ReplicatedStorage.GameplayCore.Utility.playSoundFromSource)
local simpleParticleBurst = require(ReplicatedStorage.GameplayCore.Utility.simpleParticleBurst)

local player = Players.LocalPlayer
local function getOrCreateFolder(parent: Instance, folderName: string): Folder
        local existingChild = parent:FindFirstChild(folderName)
        if existingChild and existingChild:IsA("Folder") then
                return existingChild
        end

        if existingChild then
                existingChild:Destroy()
        end

        local createdFolder = Instance.new("Folder")
        createdFolder.Name = folderName
        createdFolder.Parent = parent
        return createdFolder
end

local function getOrCreateCoinTemplate(objectsFolder: Folder): Model
        local existingTemplate = objectsFolder:FindFirstChild("Coin")
        if existingTemplate and existingTemplate:IsA("Model") then
                return existingTemplate
        end

        if existingTemplate then
                existingTemplate:Destroy()
        end

        local coinModel = Instance.new("Model")
        coinModel.Name = "Coin"

        local coinPart = Instance.new("Part")
        coinPart.Name = "CoinPart"
        coinPart.Shape = Enum.PartType.Cylinder
        coinPart.Size = Vector3.new(1.5, 0.35, 1.5)
        coinPart.Material = Enum.Material.Metal
        coinPart.Color = Color3.fromRGB(255, 215, 0)
        coinPart.TopSurface = Enum.SurfaceType.Smooth
        coinPart.BottomSurface = Enum.SurfaceType.Smooth
        coinPart.Anchored = true
        coinPart.CanCollide = false
        coinPart.Parent = coinModel

        coinModel.PrimaryPart = coinPart
        coinModel.Parent = objectsFolder

        return coinModel
end

local function getOrCreateSoundTemplate(soundsFolder: Folder): Sound
        local existingTemplate = soundsFolder:FindFirstChild("PickupCoin")
        if existingTemplate and existingTemplate:IsA("Sound") then
                return existingTemplate
        end

        if existingTemplate then
                existingTemplate:Destroy()
        end

        local pickupSound = Instance.new("Sound")
        pickupSound.Name = "PickupCoin"
        pickupSound.SoundId = "rbxassetid://0"
        pickupSound.Volume = 0.6
        pickupSound.PlayOnRemove = false
        pickupSound.Parent = soundsFolder

        return pickupSound
end

local function getOrCreatePickupParticles(effectsFolder: Folder): ParticleEmitter
        local existingTemplate = effectsFolder:FindFirstChild("PickupParticles")
        if existingTemplate and existingTemplate:IsA("ParticleEmitter") then
                return existingTemplate
        end

        if existingTemplate then
                existingTemplate:Destroy()
        end

        local particleEmitter = Instance.new("ParticleEmitter")
        particleEmitter.Name = "PickupParticles"
        particleEmitter.Texture = "rbxassetid://243660364"
        particleEmitter.Speed = NumberRange.new(2, 4)
        particleEmitter.Rate = 0
        particleEmitter.Lifetime = NumberRange.new(0.35, 0.5)
        particleEmitter.SpreadAngle = Vector2.new(360, 360)
        particleEmitter.Parent = effectsFolder

        return particleEmitter
end

local gameplayFolder = ReplicatedStorage:WaitForChild("GameplayCore"):WaitForChild("Gameplay")
local objectsFolder = getOrCreateFolder(gameplayFolder, "Objects")
local soundsFolder = getOrCreateFolder(gameplayFolder, "Sounds")
local effectsFolder = getOrCreateFolder(gameplayFolder, "Effects")
local remotesFolder = getOrCreateFolder(gameplayFolder, "Remotes")

local visualTemplate = getOrCreateCoinTemplate(objectsFolder)
local pickupSoundTemplate = getOrCreateSoundTemplate(soundsFolder)
local pickupParticlesTemplate = getOrCreatePickupParticles(effectsFolder)
local pickupCoinRemote = remotesFolder:FindFirstChild("PickupCoin")
if not pickupCoinRemote or not pickupCoinRemote:IsA("RemoteFunction") then
        if pickupCoinRemote then
                pickupCoinRemote:Destroy()
        end

        local createdRemoteFunction = Instance.new("RemoteFunction")
        createdRemoteFunction.Name = "PickupCoin"
        createdRemoteFunction.Parent = remotesFolder
        pickupCoinRemote = createdRemoteFunction
end

local coinHapticTemplate = script.CoinHaptic
local audioEmitterTemplate = script.CoinAudioEmitter

local pickupSoundPitch = 1
local lastPickup = 0
-- We'll use a table to store which coins have been picked up, since locally set attributes will not persist if a coin is streamed out and back in
local pickedUpCoins = {}

local CoinController = {}
CoinController.__index = CoinController

function CoinController.new(coin: BasePart)
	local visual = visualTemplate:Clone()
	visual:PivotTo(coin.CFrame)
	visual.Parent = Workspace

	-- Add an audio emitter
	local audioEmitter = audioEmitterTemplate:Clone()
	audioEmitter.Parent = coin

	local hapticEffect = coinHapticTemplate:Clone()
	hapticEffect.Parent = coin

	local self = {
		coin = coin,
		visual = visual,
		audioEmitter = audioEmitter,
		hapticEffect = hapticEffect,
		connections = {},
	}
	setmetatable(self, CoinController)

	self:initialize()

	return self
end

function CoinController:initialize()
	-- When the coin is touched by our character we'll try to pick it up.
	-- Touches are being detected locally so that picking up feels super responsive.
	table.insert(
		self.connections,
		self.coin.Touched:Connect(function(hit: BasePart)
			if hit.Parent == player.Character then
				self:tryPickup()
			end
		end)
	)

	self:updateVisibility()
end

function CoinController:tryPickup()
	-- Make sure we haven't already picked up this coin
	local isPickedUp = pickedUpCoins[self.coin]
	if isPickedUp then
		return
	end

	-- Pitch up the pickup sound as we pick up coins, reseting it back to 1 if it's been too long between pickups
	local timeSinceLastPickup = os.clock() - lastPickup
	lastPickup = os.clock()

	if timeSinceLastPickup > Constants.COIN_PICKUP_SOUND_PITCH_RESET_TIME then
		pickupSoundPitch = 1
	else
		pickupSoundPitch += Constants.COIN_PICKUP_SOUND_PITCH_INCREASE
	end

	-- Play the pickup sound and a particle effect
	playSoundFromSource(pickupSoundTemplate, self.audioEmitter, pickupSoundPitch)
	simpleParticleBurst(pickupParticlesTemplate, self.coin.CFrame)
	self.hapticEffect:Play()

	-- Immediately mark the coin as picked up so we don't try to pick it up multiple times
	pickedUpCoins[self.coin] = true
	self:updateVisibility()
	-- Tell the server that we're trying to pick up a coin
	local success = pickupCoinRemote:InvokeServer(self.coin)

	-- If the server rejects our request, mark the coin as no longer picked up
	if not success then
		pickedUpCoins[self.coin] = false
		self:updateVisibility()
	end
end

function CoinController:updateVisibility()
	local isPickedUp = pickedUpCoins[self.coin]

	-- If the coin has been picked up, make it transparent
	for _, descendant in self.visual:GetDescendants() do
		if descendant:IsA("BasePart") or descendant:IsA("Decal") then
			descendant.LocalTransparencyModifier = if isPickedUp then Constants.COIN_PICKUP_TRANSPARENCY else 0
		elseif descendant:IsA("Light") then
			descendant.Enabled = not isPickedUp
		end
	end
end

function CoinController:destroy()
	disconnectAndClear(self.connections)
	self.visual:Destroy()
	self.audioEmitter:Destroy()
	self.hapticEffect:Destroy()
end

return CoinController
