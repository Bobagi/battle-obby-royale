--[[
	BaseSpecial - One of the two main 'entry point' actions. Selects the special move to perform
	based on the character's current state.
--]]

local Action = {}

function Action.perform(characterController)
        print("[Movement][BaseSpecial] Special action pipeline entered")
        -- The character can't do anything while stunned or recovering
        local action = characterController:getAction()
        if action == "Stun" or action == "Recover" then
                print("[Movement][BaseSpecial] Blocked because character is stunned or recovering")
                return
        end

        -- The character can't roll/dash while swimming or climbing
        if characterController:isSwimming() or characterController:isClimbing() then
                print("[Movement][BaseSpecial] Blocked because character is swimming or climbing")
                return
        end

        if characterController:isGrounded() then
                print("[Movement][BaseSpecial] Character grounded; delegating to Roll")
                characterController:performAction("Roll")
        else
                print("[Movement][BaseSpecial] Character airborne; delegating to Dash")
                characterController:performAction("Dash")
        end
end

return Action
