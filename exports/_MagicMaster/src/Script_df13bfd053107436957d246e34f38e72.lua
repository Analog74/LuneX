local tool = script.Parent
local handle = script.Parent.Handle

if tool.Parent == workspace then
	local proxprompt = Instance.new("ProximityPrompt")
	proxprompt.Parent = handle
	proxprompt.ActionText = "Pick up"
	proxprompt.HoldDuration = .5

	proxprompt.Triggered:Connect(function(Plr)
		local backpack = Plr:WaitForChild("Backpack")
		game.ServerStorage.ToolPickup:Clone().Parent = backpack
		proxprompt:Destroy()
	end)
end