local performanceModule = {}

function performanceModule:DisableMaterials()

	for _, v in pairs(workspace:GetDescendants()) do

		if v:IsA("Part") or v:IsA("UnionOperation") then

			v.Material = Enum.Material.SmoothPlastic

		end

	end
	
end

function performanceModule:EnableShadows()
	
	game.Lighting.GlobalShadows = true
	
end

function performanceModule:DisableShadows()

	game.Lighting.GlobalShadows = false

end

function performanceModule:EnableFog()
	
	game.Lighting.FogStart = 150
	game.Lighting.FogEnd = 500
	
end

function performanceModule:DisableFog()

	game.Lighting.FogStart = 0
	game.Lighting.FogEnd = 100000

end

function performanceModule:DisableItemsFromList(list)
	
	for i,v in pairs(list) do
		
		if v:IsA("Part") or v:IsA("UnionOperation") then
			
			v.Transparency = 1
			
		end
		
	end
	
end

function performanceModule:EnableItemsFromList(list)

	for i,v in pairs(list) do

		if v:IsA("Part") or v:IsA("UnionOperation") then

			v.Transparency = 0

		end

	end

end

function performanceModule:GetCurrentFPS()
	
	return math.floor(1 / game["Run Service"].Heartbeat:Wait())
	
end

return performanceModule