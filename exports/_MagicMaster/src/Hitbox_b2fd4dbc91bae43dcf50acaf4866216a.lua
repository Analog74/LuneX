local Hitbox = {}

function Hitbox:Start(Origin, Direction, Blacklist, Visualizer)
	local RayParams = RaycastParams.new()
	RayParams.FilterType = Enum.RaycastFilterType.Blacklist
	RayParams.FilterDescendantsInstances = Blacklist
	
	return workspace:Raycast(Origin, Direction, RayParams)
end

return Hitbox
