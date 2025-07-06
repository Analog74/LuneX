local remote = game.ReplicatedStorage.Remotes
function CreateTween(val1, val2, val3, val4)
	local hmmm = game:GetService("TweenService"):Create(val1, TweenInfo.new(unpack(val2)), val3);
	if val4 then
		hmmm:Play();
	end;
	return hmmm;
end;
function GetParticles(p15)
	local v17 = {};
	for v18, v19 in pairs(p15:GetDescendants()) do
		if v19:IsA("ParticleEmitter") then
			v17[v19] = {
				Particle = v19, 
				Transparency = {}, 
				Size = {}
			};
			for v20 = 1, #v17[v19].Particle.Transparency.Keypoints do
				v17[v19].Transparency[v20] = {
					Value = v17[v19].Particle.Transparency.Keypoints[v20].Value, 
					Time = v17[v19].Particle.Transparency.Keypoints[v20].Time
				};
			end;
			for v21 = 1, #v17[v19].Particle.Size.Keypoints do
				v17[v19].Size[v21] = {
					Value = v17[v19].Particle.Size.Keypoints[v21].Value, 
					Time = v17[v19].Particle.Size.Keypoints[v21].Time
				};
			end;
			v19.Size = NumberSequence.new(0);
			v19.Transparency = NumberSequence.new(1);
		end;
	end;
	return v17;
end;
function changeSizeAndTransparency(p22, p23, p24, p25)
	local u2 = p24;
	spawn(function()
		local v38 = 1;
		local v39 = 1;
		if p25 then
			v38 = u2;
			u2 = 1;
			v39 = -1;
		end;
		for v40 = v38, u2, v39 do
			for v41 = 1, 2 do
				if "Size" == "Size" then
					local v42 = "Transparency";
				else
					v42 = "Size";
				end;
				local v43 = {};


			end;
			wait();
		end;
	end);
end;
function GetParts(p16)
	local v22 = {};
	local v23 = p16:GetDescendants();
	table.insert(v23, p16);
	for v24, v25 in pairs(v23) do
		if v25:IsA("BasePart") then
			v22[v25] = {
				Part = v25, 
				Transparency = v25.Transparency, 
				Size = v25.Size
			};
			v25.Size = Vector3.new(0, 0, 0);
			v25.Transparency = 1;
		end;
	end;
	return v22;
end;
remote.sharingan.OnClientEvent:Connect(function(player,cop,dira,Parent)
	game:GetService("Debris"):AddItem(cop,dira)

spawn(function()
	local v6 = CreateTween(Parent, { 1, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
		
			Size = Parent.Size + Vector3.new(10, 10, 10), 
		
		}, true);
		wait(1)
		local v6 = CreateTween(Parent, { 1, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {

			Size = Parent.Size - Vector3.new(50, 50, 50), 
Transparency = 1
		}, true);
	end)
wait(3);


	Parent:Destroy();
end)