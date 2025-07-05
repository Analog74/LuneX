-- This module creates BodyVelocities for certain actions such as pushing and knockback.

return 
	function(Strength, Duration, Parent)
	
	local Velocity = Instance.new('BodyVelocity')
	Velocity.Name = 'Velocity'
	Velocity.MaxForce = Vector3.new(1, 1, 1) * math.huge
	Velocity.Velocity = Strength
	Velocity.Parent = Parent
	game:GetService('Debris'):AddItem(Velocity, Duration)
end
