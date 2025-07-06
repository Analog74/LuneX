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
remote.exp3.OnClientEvent:Connect(function(player,cop,dira,Parent)
	game:GetService("Debris"):AddItem(cop,dira)
	local l__Parent__1 = Parent;

local v3 =GetParts(l__Parent__1);
local v4 = GetParticles(l__Parent__1);
local l__Part1__5 = l__Parent__1.Part1;
local l__Part2__6 = l__Parent__1.Part2;
local iooo = true
for v8, v9 in pairs(l__Part1__5:GetChildren()) do
	v9.Enabled = true;
end;
for v10, v11 in pairs(l__Part2__6:GetChildren()) do
	v11.Enabled = true;
end;
for v12, v13 in pairs(l__Part1__5:GetChildren()) do
	changeSizeAndTransparency(v4, v13, 2);
end;
for v14, v15 in pairs(l__Part2__6:GetChildren()) do
	changeSizeAndTransparency(v4, v15, 2);
end;
local function StopPlayer(Hm,ShouldStop)
	if ShouldStop then
		Hm.WalkSpeed = 0
		Hm.JumpPower = 0
		
		Hm.AutoRotate = false
	else
		Hm.WalkSpeed = 16
		Hm.JumpPower = 50
	
		Hm.AutoRotate = true
	end
end
 local 	debond1 =true
for v20, v21 in pairs(l__Parent__1:GetChildren()) do
		if v21.Name == "Explosion" and not workspace:FindFirstChild("TimeStop")  then
			
			
		spawn(function()
				CreateTween(v21, { 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0 }, {
				Size = v3[v21].Size * 5, 
				Transparency = v3[v21].Transparency
				}, true).Completed:Wait();
				if v21.Name == "Explosion" and not workspace:FindFirstChild("TimeStop")  then
					local v22 = CreateTween(v21, { 5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0 }, {
				Size = v3[v21].Size * 10, 
				Transparency = 1
					}, true);
			 end
		end);
	end;
end;
local l__CFrame__23 = l__Parent__1.Explosion.CFrame;
for v24 = 0, 5, 0.5 do
	l__Part1__5.CFrame = l__Part1__5.CFrame * CFrame.Angles(0, 0.1, 0);
	l__Part2__6.CFrame = l__Part2__6.CFrame * CFrame.Angles(0, -0.1, 0);
	for v25, v26 in pairs(l__Parent__1:GetChildren()) do
			if v26.Name == "Explosion" and not workspace:FindFirstChild("TimeStop")  then
			v26.CFrame = l__CFrame__23 + Vector3.new(math.random(-10, 10) / 5, math.random(-10, 10) / 5, math.random(-10, 10) / 5);
		end;
	end;
	
	wait();
end;
for v29, v30 in pairs(l__Part1__5:GetChildren()) do
	v30.Enabled = false;
end;
for v31, v32 in pairs(l__Part2__6:GetChildren()) do
	v32.Enabled = false;
end;
spawn(function()
	local v33 = 1;
	for v34 = 0, 200, 0.1 do
		if v33 > 0.09 then
			v33 = v33 - 0.01;
		end;
	
		for v37, v38 in pairs(l__Parent__1:GetChildren()) do
			if v38.Name == "Explosion" and not workspace:FindFirstChild("TimeStop") then
				v38.CFrame = l__CFrame__23 + Vector3.new(math.random(-10, 10) / 5, math.random(-10, 10) / 5, math.random(-10, 10) / 5);
			end;
		end;
		wait();
	end;
end);

wait(3);


l__Parent__1:Destroy();
end)