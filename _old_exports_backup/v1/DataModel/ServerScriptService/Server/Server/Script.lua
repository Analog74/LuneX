-- Services
local Replicated = game:GetService('ReplicatedStorage')

game:GetService('Players').PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Character)
		local Handle = Replicated.Assets.Meshes.Handle:Clone()
		Handle.Parent = Character
		
		local Motor6D = Instance.new('Motor6D')
		Motor6D.Part0 = Character:WaitForChild('RightHand')
		Motor6D.Part1 = Handle
		Motor6D.C0 = CFrame.new(0, -0.85, -2) * CFrame.Angles(0, 0, math.rad(90))
		Motor6D.Parent = Character:WaitForChild('RightHand')
	end)
end)