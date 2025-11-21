--[[
	DoubleJump - Jump a second time in the air by setting the character's vertical velocity.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.GameplayCore.Movement.Constants)
local calculateVelocityForHeight = require(ReplicatedStorage.GameplayCore.Utility.calculateVelocityForHeight)
local setVerticalVelocity = require(ReplicatedStorage.GameplayCore.Utility.setVerticalVelocity)

local Action = {
        clearOnGrounded = true,
        animation = "DoubleJump",
        effect = "Jump",
        sound = "DoubleJump",
}

-- Double jump!
function Action.perform(characterController)
        print("[Movement][DoubleJump] Entered double jump execution")
        -- Make sure the character is currently allowed to double jump
        local canDoubleJump = characterController.character:GetAttribute(Constants.CAN_DOUBLE_JUMP_ATTRIBUTE)
        if not canDoubleJump then
                print("[Movement][DoubleJump] Blocked because CAN_DOUBLE_JUMP_ATTRIBUTE is false")
                return
        end

        -- Don't let the character double jump during an air dash, since that will cut it short
        local timeSinceLastDash = characterController:getTimeSinceAction("Dash")
        if timeSinceLastDash < Constants.DASH_TIME then
                print("[Movement][DoubleJump] Blocked because Dash is still active")
                return
        end

        characterController.character:SetAttribute(Constants.CAN_DOUBLE_JUMP_ATTRIBUTE, false)
        print("[Movement][DoubleJump] Attribute gate cleared; setting DoubleJump action")
        characterController:setAction("DoubleJump")

        -- Set the character's vertical velocity to make them double jump
        local jumpVelocity = calculateVelocityForHeight(Constants.DOUBLE_JUMP_HEIGHT)
        print("[Movement][DoubleJump] Applying vertical velocity for double jump")
        setVerticalVelocity(characterController.root, jumpVelocity)
end

return Action
