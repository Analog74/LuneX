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
function CreateTween(p51, p52, p53, p54)
	local v65 = game:GetService("TweenService"):Create(p51, TweenInfo.new(unpack(p52)), p53);
	if p54 then
		v65:Play();
	end;
	return v65;
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
local remote = game.ReplicatedStorage.Remotes

remote.Smoke.OnClientEvent:Connect(function(player,cop,dira,Parent)
game:GetService("Debris"):AddItem(cop,dira)
local v3 = GetParts(Parent);
	local v4 = GetParticles(Parent);
	local l__Part1__5 = Parent.Part1;

	local l__Base__7 = Parent.Base;
for v8, v9 in pairs(l__Part1__5:GetChildren()) do
	v9.Enabled = true;
end;

for v12, v13 in pairs(l__Part1__5:GetChildren()) do
	changeSizeAndTransparency(v4, v13, 5);
end;

local v16 = CreateTween(l__Base__7, { 1, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
	Size = v3[l__Base__7].Size
}, true);
	for v17, v18 in pairs(Parent:GetChildren()) do
		if v18:IsA("MeshPart") and not workspace:FindFirstChild("TimeStop") then
		local v19 = CreateTween(v18, { 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0 }, {
			Size = v3[v18].Size, 
			Transparency = v3[v18].Transparency
		}, true);
	end;
end;
for v20 = 0, 5, 0.5 do
	l__Part1__5.CFrame = l__Part1__5.CFrame * CFrame.Angles(0, 0.1, 0);

		for v21, v22 in pairs(Parent:GetChildren()) do
			if v22:IsA("MeshPart")  and not workspace:FindFirstChild("TimeStop")  then
			v22.CFrame = v22.CFrame * CFrame.Angles(0, 0.5, 0) * CFrame.new(1, 0, 0);
		end;
	end;
	wait();
end;
for v23, v24 in pairs(l__Part1__5:GetChildren()) do
	v24.Enabled = false;
end;

spawn(function()
	local v27 = 1;
	for v28 = 0, 50, 0.1 do
		if v27 > 0.01 then
			v27 = v27 - 0.01;
		end;
			for v29, v30 in pairs(Parent:GetChildren()) do
				if v30:IsA("MeshPart")  and not workspace:FindFirstChild("TimeStop") then
				v30.CFrame = v30.CFrame * CFrame.Angles(0, v27 / 4, 0) * CFrame.new(v27, 0, 0);
			end;
		end;
		wait();
	end;
end);
	for v31, v32 in pairs(Parent:GetChildren()) do
		if v32:IsA("MeshPart")  and not workspace:FindFirstChild("TimeStop") then
		local v33 = CreateTween(v32, { 3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0 }, {
			Size = v32.Size + Vector3.new(20, 20, 20), 
			Transparency = 1
		}, true);
	end;
end;
	wait(1.5);
	if  not workspace:FindFirstChild("TimeStop") then
local v34 = CreateTween(l__Base__7.Decal, { 1, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
	Transparency = 1
		}, true);
		end
wait(5);
	Parent:Destroy();
	end)