return function(Part, IgnoreList)
	-- We use this for handling raycast parameters and ignore lists.
	local RaycastParameters = RaycastParams.new()
	RaycastParameters.FilterDescendantsInstances = IgnoreList or { Part, workspace.Effects }
	RaycastParameters.FilterType = Enum.RaycastFilterType.Blacklist
	local Hit = workspace:Raycast(Part.Position, Part.CFrame.UpVector * -10, RaycastParameters)
	return Hit.Position
end