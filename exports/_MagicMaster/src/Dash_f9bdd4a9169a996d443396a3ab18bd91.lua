

local remote = game.ReplicatedStorage.Remotes

remote.Dash.OnClientEvent:Connect(function(player,cop,dira,Parent)
	function CreateTween(p51, p52, p53, p54)
		local v65 = game:GetService("TweenService"):Create(p51, TweenInfo.new(unpack(p52)), p53);
		if p54 then
			v65:Play();
		end;
		return v65;
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
	local v3 = GetParts(Parent);
	local v4 = GetParticles(Parent);
	game:GetService("Debris"):AddItem(cop,dira)
	for v7, v8 in pairs(Parent.Part3:GetChildren()) do
	v8.Enabled = true;
end;
	for v9, v10 in pairs(Parent.Part3:GetChildren()) do
	changeSizeAndTransparency(v4, v10, 5);
end;
	local v11 = CreateTween(Parent.Base, { 1, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
	Size = v3[Parent.Part3].Size
}, true);
for v12, v13 in pairs(Parent:GetChildren()) do
	if string.match(v13.Name, "Mest") then
		local v14 = CreateTween(v13, { 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0 }, {
			Size = v3[v13].Size, 
			Transparency = v3[v13].Transparency
		}, true);
	end;
end;
wait(0.25);
for v15, v16 in pairs(Parent.Part3:GetChildren()) do
	v16.Enabled = false;
end;
spawn(function()
	local v17 = 1;
	for v18 = 0, 50, 0.1 do
		if v17 > 0.01 then
			v17 = v17 - 0.01;
		end;
		for v19, v20 in pairs(Parent:GetChildren()) do
			if string.match(v20.Name, "Mest") then
				v20.CFrame = v20.CFrame * CFrame.Angles(0, v17 / 4, 0);
			end;
		end;
		wait();
	end;
end);
for v21, v22 in pairs(Parent:GetChildren()) do
	if string.match(v22.Name, "Mest") then
		if v22.Name == "Mest7" or v22.Name == "Mest8" or v22.Name == "Mest9" then
			local v23 = CreateTween(v22, { 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0 }, {
				Size = v22.Size + Vector3.new(10, 30, 10), 
				Transparency = 1
			}, true);
		else
			local v24 = CreateTween(v22, { 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0 }, {
				Size = v22.Size + Vector3.new(10, 30, 10), 
				Transparency = 1
			}, true);
		end;
	end;
end;
wait(1.5);
wait(5);
Parent:Destroy();
end)