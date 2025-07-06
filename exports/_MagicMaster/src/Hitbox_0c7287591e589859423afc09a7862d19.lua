-- Localization
local workspace = workspace

local Hitbox = {}

function Hitbox:Start(Origin, Direction, Blacklist, Visualizer)
	local RayParams = RaycastParams.new()
	RayParams.FilterType = Enum.RaycastFilterType.Blacklist
	RayParams.FilterDescendantsInstances = Blacklist
	
	if Visualizer then
		local Part = Instance.new('Part')
		Part.Position = Origin + Direction
		Part.Anchored = true
		Part.CanCollide = false
		Part.Transparency = 0.5
		Part.Size = Vector3.new(1, 1, 1)
		Part.Parent = workspace.Effects
		game:GetService('Debris'):AddItem(Part, 0.35)
	end
	
	return workspace:Raycast(Origin, Direction, RayParams)
end

return Hitbox
