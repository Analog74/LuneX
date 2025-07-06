-- Localization
local workspace = workspace

return function(CF)
	local P = Instance.new('Part')
	P.Name = 'MockPart'
	P.CFrame = CF
	P.Size = Vector3.new(1, 1, 1)
	P.Transparency = 1
	P.Anchored = true
	P.CanCollide = false
	P.CanTouch = false
	P.CastShadow = false
	P.Parent = workspace.Effects
	return P
end
