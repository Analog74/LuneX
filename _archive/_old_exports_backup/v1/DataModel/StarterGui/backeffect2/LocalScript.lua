local remote = game.ReplicatedStorage.Remotes

remote.backeffect2.OnClientEvent:Connect(function(player,cop,dira,Parent)

	game:GetService("Debris"):AddItem(cop,dira)
	function CreateTween(val1, val2, val3, val4)
	local hmmm = game:GetService("TweenService"):Create(val1, TweenInfo.new(unpack(val2)), val3);
	if val4 then
		hmmm:Play();
	end;
	return hmmm;
end;
for v2, v3 in pairs(Parent:GetChildren()) do


		if v3.Name == "ParticleEffect" then
			
			v3.ParticleEmitter.Enabled = true
			local v4 = CreateTween(v3, { 5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {

				Size =  Vector3.new(20, 20, 20)
			}, true);
		spawn(function()
			wait(5);
			v3.ParticleEmitter.Enabled = false;
		end);
	end;
end;


wait(5);
Parent:Destroy();
end)