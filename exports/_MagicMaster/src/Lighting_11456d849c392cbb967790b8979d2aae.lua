local remote = game.ReplicatedStorage.Remotes

remote.Lighting.OnClientEvent:Connect(function(player,cop,dira,Parent)

	game:GetService("Debris"):AddItem(cop,dira)
	function CreateTween(val1, val2, val3, val4)
	local hmmm = game:GetService("TweenService"):Create(val1, TweenInfo.new(unpack(val2)), val3);
	if val4 then
		hmmm:Play();
	end;
	return hmmm;
end;
for v2, v3 in pairs(Parent:GetChildren()) do
	if v3.Name == "Light1" then
		local v4 = CreateTween(v3, { 3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
				CFrame = v3.CFrame + v3.CFrame.lookVector * 50,
				Size = v3.Size + Vector3.new(0.02, 0.02, math.random(10, 45)), 
				Transparency = 1
		}, true);
		
		elseif v3.Name == "Light2" then
		local v6 = CreateTween(v3, { 3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
			CFrame = v3.CFrame + v3.CFrame.lookVector * 50, 
				Size = v3.Size + Vector3.new(0.02, 0.02, math.random(10, 45)), 
			Transparency = 1
		}, true);

		
	end;
end;


wait(3);
Parent:Destroy();
end)