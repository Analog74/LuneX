local cs = game:GetService("CollectionService")

local Combat = {}

Combat.StrongKnockback = function(target, strength1, strength2, duration, Origin)
	local EffectVelocity = Instance.new("BodyVelocity", target)
	EffectVelocity.MaxForce = Vector3.new(1, 1, 1) * 1000000;
	EffectVelocity.Velocity = Vector3.new(1, 1, 1) * Origin.CFrame.LookVector * math.random(strength1, strength2)

	game.Debris:AddItem(EffectVelocity, duration)
end

Combat.InsertDisabled = function(Target, Duration)
	local disabled = Instance.new("BoolValue")
	disabled.Name = "Disabled"
	
	disabled.Parent = Target
	
	game.Debris:AddItem(disabled, Duration)
end

Combat.UpKnockback = function(target, strength1, strength2, duration, Origin)
	local EffectVelocity = Instance.new("BodyVelocity", target)
	EffectVelocity.MaxForce = Vector3.new(1, 1, 1) * 1000000;
	EffectVelocity.Velocity = Vector3.new(1, 1, 1) * Origin.CFrame.UpVector * math.random(strength1, strength2)

	game.Debris:AddItem(EffectVelocity, duration)
end

Combat.Ragdoll = function(target, duration)
	cs:AddTag(target, "Ragdoll")
	Combat.InsertDisabled(target, duration)
	delay(duration, function()
		if cs:HasTag(target, "Ragdoll") then
			cs:RemoveTag(target, "Ragdoll")
		end
	end)
end

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
