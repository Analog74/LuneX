local remote = game.ReplicatedStorage.Remotes

remote.backeffect.OnClientEvent:Connect(function(player,cop,dira,Parent)

	game:GetService("Debris"):AddItem(cop,dira)
	function CreateTween(val1, val2, val3, val4)
	local hmmm = game:GetService("TweenService"):Create(val1, TweenInfo.new(unpack(val2)), val3);
	if val4 then
		hmmm:Play();
	end;
	return hmmm;
end;
for v2, v3 in pairs(Parent:GetChildren()) do
	if v3.Name == "CurveEffect" then
		local v4 = CreateTween(v3, { 2, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
			CFrame = v3.CFrame - v3.CFrame.upVector * 15
		}, true);
		spawn(function()
			for v5 = 1, 5 do
				v3:WaitForChild("Beam").Transparency = NumberSequence.new(v5 / 5);
				wait();
			end;
		end);
	elseif v3.Name == "SmallEffect" then
		local v6 = CreateTween(v3, { 3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
			CFrame = v3.CFrame + v3.CFrame.rightVector * 20, 
			Size = v3.Size + Vector3.new(math.random(10, 45), 0.02, 0.02), 
			Transparency = 1
		}, true);
	elseif v3.Name == "BallEffect" then
		local v7 = CreateTween(v3, { 2, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
			Size = v3.Size + Vector3.new(10, 10, 10), 
			Transparency = 1
		}, true);
	elseif v3.Name == "ParticleEffect" then
		v3.ParticleEmitter.Enabled = true
		spawn(function()
			wait(0.2);
			v3.ParticleEmitter.Enabled = false;
		end);
	end;
end;


wait(3);
Parent:Destroy();
end)