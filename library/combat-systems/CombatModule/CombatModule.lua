--[[
	CombatModule v2.1.0
	
	Core combat mechanics system providing knockback, ragdoll, and damage utilities.
	
	Author: Analog74
	Category: Combat Systems
	Dependencies: CollectionService
	
	Usage:
		local Combat = require(ReplicatedStorage.Libraries.CombatModule)
		
		-- Apply strong knockback
		Combat.StrongKnockback(target, 50, 100, 1.5, originPart)
		
		-- Ragdoll a character
		Combat.Ragdoll(character, 3.0)
		
		-- Disable character temporarily
		Combat.InsertDisabled(character, 2.0)
]]

local cs = game:GetService("CollectionService")

local Combat = {}

--[[
	Apply strong directional knockback to a target
	
	@param target: BasePart - The part to apply knockback to
	@param strength1: number - Minimum knockback strength
	@param strength2: number - Maximum knockback strength
	@param duration: number - How long the knockback lasts
	@param Origin: BasePart - The part determining knockback direction
]]
Combat.StrongKnockback = function(target, strength1, strength2, duration, Origin)
	local EffectVelocity = Instance.new("BodyVelocity", target)
	EffectVelocity.MaxForce = Vector3.new(1, 1, 1) * 1000000;
	EffectVelocity.Velocity = Vector3.new(1, 1, 1) * Origin.CFrame.LookVector * math.random(strength1, strength2)

	game.Debris:AddItem(EffectVelocity, duration)
end

--[[
	Temporarily disable a character by adding a "Disabled" tag
	
	@param Target: Model - The character to disable
	@param Duration: number - How long to disable for
]]
Combat.InsertDisabled = function(Target, Duration)
	local disabled = Instance.new("BoolValue")
	disabled.Name = "Disabled"
	
	disabled.Parent = Target
	
	game.Debris:AddItem(disabled, Duration)
end

--[[
	Apply upward knockback to a target
	
	@param target: BasePart - The part to apply knockback to
	@param strength1: number - Minimum knockback strength
	@param strength2: number - Maximum knockback strength
	@param duration: number - How long the knockback lasts
	@param Origin: BasePart - The part determining knockback direction
]]
Combat.UpKnockback = function(target, strength1, strength2, duration, Origin)
	local EffectVelocity = Instance.new("BodyVelocity", target)
	EffectVelocity.MaxForce = Vector3.new(1, 1, 1) * 1000000;
	EffectVelocity.Velocity = Vector3.new(1, 1, 1) * Origin.CFrame.UpVector * math.random(strength1, strength2)

	game.Debris:AddItem(EffectVelocity, duration)
end

--[[
	Apply ragdoll effect to a character using CollectionService tags
	
	@param target: Model - The character to ragdoll
	@param duration: number - How long to ragdoll for
]]
Combat.Ragdoll = function(target, duration)
	cs:AddTag(target, "Ragdoll")
	Combat.InsertDisabled(target, duration)
	delay(duration, function()
		if cs:HasTag(target, "Ragdoll") then
			cs:RemoveTag(target, "Ragdoll")
		end
	end)
end

--[[
	Apply positional knockback to move target to specific location
	
	@param PlayerHRP: BasePart - The origin point for calculations
	@param Target: BasePart - The target to move
	@param ZDistance: number - Distance in Z direction
	@param YDistance: number - Distance in Y direction (unused in current implementation)
]]
Combat.Knockback = function(PlayerHRP, Target, ZDistance, YDistance)
	local Pos = PlayerHRP.CFrame * CFrame.new(0, 1, ZDistance)
	local BP = Instance.new("BodyPosition",Target)
	
	BP.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	BP.D = 100
	BP.P = 900
	BP.Position = Pos.p
	game.Debris:AddItem(BP,0.4)
end

return Combat
