local remote = game.ReplicatedStorage.Remotes

remote.Blast.OnClientEvent:Connect(function(player,cop,dira,Parent)

	game:GetService("Debris"):AddItem(cop,dira)
	function CreateTween(val1, val2, val3, val4)
	local hmmm = game:GetService("TweenService"):Create(val1, TweenInfo.new(unpack(val2)), val3);
	if val4 then
		hmmm:Play();
	end;
	return hmmm;
end;
for v2, v3 in pairs(Parent:GetChildren()) do
	if v3.Name == "Part1" then
		local v4 = CreateTween(v3, { 3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
				CFrame = v3.CFrame + v3.CFrame.rightVector * 50,
				Size = v3.Size + Vector3.new(90,20,20),
				
			}, true);
			spawn(function()
				wait(3)
			local v4 = CreateTween(v3, { 3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
				Transparency = 1
			}, true);
		end)
		elseif v3.Name == "Part2" then
		local v6 = CreateTween(v3, { 3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
			CFrame = v3.CFrame + v3.CFrame.rightVector * 50, 
				Size = v3.Size + Vector3.new(90,20,20),
			
			}, true);
			
			spawn(function()
			wait(3)
			local v4 = CreateTween(v3, { 3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
				Transparency = 1
				}, true);
			end)
		elseif v3.Name == "Particle" then
			local v6 = CreateTween(v3, { 3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
				CFrame = v3.CFrame + v3.CFrame.rightVector * 50, 
		

			}, true);
		
		
	end;
end;


wait(3);
Parent:Destroy();
end)