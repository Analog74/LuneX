return function(Part0, Part1, C0)
	local Weld = Instance.new('Weld')
	Weld.Part0 = Part0
	Weld.Part1 = Part1
	Weld.Parent = Part0
	Weld.C0 = C0 or CFrame.new(0, 0, 0)
	return Weld
end