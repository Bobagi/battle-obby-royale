--[[
	Dash - Performs a dash forward using a LinearVelocity to move the character.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.GameplayCore.Movement.Constants)
local getOrCreateAttachment = require(ReplicatedStorage.GameplayCore.Utility.getOrCreateAttachment)

local Action = {
        clearOnGrounded = true,
        movementAcceleration = 4,
        animation = "Dash",
        effect = "Dash",
        sound = "Dash",
}

-- Dash forward through the air for a short period of time
function Action.perform(characterController)
        print("[Movement][Dash] Entered dash execution")
        -- Make sure the character is currently allowed to dash
        local canDash = characterController.character:GetAttribute(Constants.CAN_DASH_ATTRIBUTE)
        if not canDash then
                print("[Movement][Dash] Blocked because CAN_DASH_ATTRIBUTE is false")
                return
        end

        characterController.character:SetAttribute(Constants.CAN_DASH_ATTRIBUTE, false)
        print("[Movement][Dash] Attribute gate cleared; setting Dash action")
        characterController:setAction("Dash")

	local attachment = getOrCreateAttachment(characterController.root, "DashAttachment")

        -- We'll use a LinearVelocity to control the character's movement during the dash
        local velocity = Instance.new("LinearVelocity")
        velocity.Name = "DashVelocity"
        velocity.Attachment0 = attachment :: Attachment
        velocity.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
	-- Dash force is multiplied by the character's total mass to ensure consistency across different size characters
        velocity.MaxForce = Constants.DASH_FORCE_FACTOR * characterController.root.AssemblyMass
        velocity.VectorVelocity = Vector3.new(0, 0, -Constants.DASH_SPEED)
        velocity.Parent = characterController.root

        print("[Movement][Dash] LinearVelocity applied; dash timer started")
        task.delay(Constants.DASH_TIME, velocity.Destroy, velocity)
end

return Action
