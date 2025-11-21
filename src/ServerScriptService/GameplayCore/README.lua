--[[
	# Platformer Template

	## Overview

	This platformer template serves as a demonstration of basic platforming mechanics
	and coin collection mechanics. Players can jump and double jump, roll and dash
	(shift on keyboard, X/square on gamepad), and long jump by jumping right after
	initiating a roll.

	## Project Structure

	Client scripts and objects are stored in ReplicatedStorage, the scripts have their
	RunContext set to Client so they do not need to be parented to PlayerScripts.

	Server scripts and objects are stored in ServerScriptService.

	The same structure is used for both server and client - instances and scripts are
	broken up into three different categories:

	* Platformer
	* Gameplay
	* Utility

	### Platformer

	The Platformer folder contains instances and scripts specifically related to the
	platforming abilities. This includes the main control script, remote events for
	replication, effects and effect scripts, and more.

	A Constants module is included here to provide a central place to modify all
	Platformer-related constants.

	### Gameplay

	The Gameplay folder contains instances and scripts related to supplementary
	gameplay elements, such as moving platforms, coin pickups, etc.

	A second Constants module is included here to provide a central place to modify
	all Gameplay-related constants.

	### Utility

	The Utility folder contains utility functions and libraries that are used by
	various systems throughout the template.

	## Character Controller

	The Controller class (found in `ReplicatedStorage.GameplayCore.Movement.Scripts.Controller`)
	contains the main control code for the character. This includes movement, momentum,
	and initiating various actions.

	In order to easily support multiple input types without forking or re-implementing
	the default control scripts, movement and jump input is read from the local character's
	humanoid in a RenderStep loop and then written back to it by the Controller. This is
	done inside `ReplicatedStorage.GameplayCore.Movement.Scripts.ControlScript`.

	## Actions

	Actions are the various platforming moves that a character can make, such as rolling
	or double jumping. These are all stored as modules in `ReplicatedStorage.GameplayCore.Movement.Scripts.Actions`.

	Each action can specify animations, effects, and sounds to play when it is initiated,
	as well as the acceleration the character should have during the action and whether
	it should be automatically ended when the character lands on the ground.

	* minTimeInAction - Used when clearOnGrounded = true, prevents the action from being stopped
		immediately if initiated on the ground
	* clearOnGrounded - When set the true, the controller will automatically change the action back
		to "None" when grounded/climbing/swimming
	* movementAcceleration - The acceleration to use while this is the current action
	* animation - The animation to play when the action begins
	* effect - The effect to run when the action begins
	* sound - The sound to play when the action begins

	The code for each action is inside the `Action.perform()` function, which is called
	when the character attempts to initiate that action. The current character Controller
	object is passed into this function so that actions can read values from the controller
	and initiate other actions if necessary.

	## Coin Pickups

	Coin pickups are represented as a single part, which gets visually replaced on the
	clients by a nicer looking model. Multiple players can pick up the same coin, but only one time each.

	Touched events are listened to locally, which allows the client to immediately show
	a visual indicator that the coin has been picked up. The server does validation to
	make sure the client can't pick up any coin they want from anywhere on the map or pick
	up the same coin multiple times and then increments their leaderstats.
--]]
