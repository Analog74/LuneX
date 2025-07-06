-- Decompiled with the Synapse X Luau decompiler.

local l__Assets__1 = game:GetService("ReplicatedStorage").Assets;
local l__Meshes__2 = l__Assets__1.Meshes;
local l__Parent__3 = script.Parent.Parent.Parent;
local v4 = require(l__Parent__3.Auxiliary.CameraShaker);
local v5 = require(l__Parent__3.Auxiliary.LightningBolt);
local v6 = require(l__Parent__3.Auxiliary.LightningBolt.LightningSparks);
local v7 = require(l__Parent__3.Auxiliary.RockModule);
local l__CurrentCamera__1 = workspace.CurrentCamera;
local v8 = v4.new(Enum.RenderPriority.Camera.Value, function(p1)
	l__CurrentCamera__1.CFrame = l__CurrentCamera__1.CFrame * p1;
end);
local l__Debris__2 = game:GetService("Debris");
local l__TweenService__3 = game:GetService("TweenService");
v8:Start();
local l__Particles__4 = l__Assets__1.Particles;
local function u5(p2, p3, p4, p5)
	local v9 = Instance.new("NumberValue");
	v9.Value = p2;
	l__TweenService__3:Create(v9, TweenInfo.new(p3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Value = p4
	}):Play();
	l__Debris__2:AddItem(v9, p3);
	if p5 then
		v9.Changed:Connect(function(p6)
			p5.Size = NumberSequence.new(p6);
		end);
	end;
	return v9;
end;
return function(...)
	local v10 = l__Particles__4.Orb.Orb:Clone();
	v10.CFrame = ({ ... })[1].CFrame * CFrame.new(0, 22.5, -35);
	v10.Size = Vector3.new(1, 1, 1);
	v10.Implosion.CFrame = v10.CFrame;
	v10.Lightning.CFrame = v10.CFrame;
	v10.Ground.Position = Vector3.new(v10.Position.X, 0, v10.Position.Z);
	v10.Parent = workspace.Effects;
	local l__Attachment__11 = v10.Attachment;
	local l__Implosion__12 = v10.Implosion;
	l__Attachment__11.Sphere:Emit(75);
	l__TweenService__3:Create(v10, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(8.5, 8.5, 8.5)
	}):Play();
	l__TweenService__3:Create(v10.Attachment.PointLight, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
		Range = 25
	}):Play();
	local u6 = true;
	local u7 = { { "rbxassetid://8189652665", "", "rbxassetid://8189653993", "rbxassetid://8189655563", "", "rbxassetid://8189656720", "rbxassetid://8189657822", "rbxassetid://8189659765", "rbxassetid://8189661518", "" }, { "rbxassetid://8189970113", "", "rbxassetid://8189983044", "rbxassetid://8189984421", "rbxassetid://8189985650", "rbxassetid://8189986587", "rbxassetid://8189989098", "rbxassetid://8189990246", "" } };
	task.spawn(function()
		while u6 do
			local v13 = v10.Lightning.Lightning:Clone();
			v13.Parent = v10.Lightning;
			v13:Emit(1);
			task.spawn(function()
				local v14 = Random.new():NextNumber(0.03, 0.045);
				for v15, v16 in ipairs(u7[math.random(#u7)]) do
					v13.Texture = v16;
					task.wait(v14);
				end;
			end);
			task.wait(0.0385);		
		end;
	end);
	task.wait(0.5);
	l__Attachment__11.GradientIn.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 20), l__Attachment__11.GradientIn.Size.Keypoints[2] });
	l__Attachment__11.GradientIn:Emit(1);
	task.wait(0.225);
	l__TweenService__3:Create(v10, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(17.5, 17.5, 17.5)
	}):Play();
	l__TweenService__3:Create(v10.Implosion, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(50, 50, 50)
	}):Play();
	l__TweenService__3:Create(v10.Lightning, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(30, 30, 30)
	}):Play();
	l__TweenService__3:Create(v10.Attachment.PointLight, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Range = 35
	}):Play();
	v10.Implosion.Imploding.Rate = 100;
	v10.Attachment.Specs.Rate = 75;
	v10.Attachment.Specs.Speed = NumberRange.new(25, 40);
	v10.Implosion.Imploding.Speed = NumberRange.new(75, 75);
	local l__Attachment__8 = v10.Ground.Attachment;
	u5(13.5, 0.35, 32.5).Changed:Connect(function(p7)
		l__Attachment__8.Imploding.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, p7), l__Attachment__8.Imploding.Size.Keypoints[2] });
	end);
	l__Attachment__8.Vortex.Enabled = true;
	l__Attachment__11.Sphere.Size = NumberSequence.new({ l__Attachment__11.Sphere.Size.Keypoints[1], NumberSequenceKeypoint.new(0.439, 6), l__Attachment__11.Sphere.Size.Keypoints[3] });
	l__Attachment__11.Gradient.Size = NumberSequence.new({ l__Attachment__11.Gradient.Size.Keypoints[1], NumberSequenceKeypoint.new(1, 15) });
	l__Attachment__11.Sphere.Speed = NumberRange.new(82.5, 82.5);
	u5(5, 0.55, 15, l__Attachment__11.Outline);
	u5(3, 0.55, 7.5, l__Attachment__11.Middle);
	l__Attachment__11.Sphere:Emit(75);
	task.wait(0.5);
	l__Attachment__11.GradientIn.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 35), l__Attachment__11.GradientIn.Size.Keypoints[2] });
	l__Attachment__11.GradientIn:Emit(1);
	task.wait(0.225);
	l__TweenService__3:Create(v10, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(25, 25, 25)
	}):Play();
	l__TweenService__3:Create(v10.Implosion, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(75, 75, 75)
	}):Play();
	l__TweenService__3:Create(v10.Lightning, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(45, 45, 45)
	}):Play();
	l__TweenService__3:Create(v10.Attachment.PointLight, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Range = 50
	}):Play();
	v10.Implosion.Imploding.Rate = 150;
	v10.Attachment.Specs.Rate = 85;
	v10.Attachment.Crescents.Enabled = true;
	v10.Attachment.Specs.Speed = NumberRange.new(35, 50);
	v10.Implosion.Imploding.Speed = NumberRange.new(90, 90);
	local v17 = u5(10, 0.35, 25);
	u5(30, 0.35, 50).Changed:Connect(function(p8)
		l__Attachment__8.Imploding.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, p8), l__Attachment__8.Imploding.Size.Keypoints[2] });
	end);
	v17.Changed:Connect(function(p9)
		l__Attachment__8.Vortex.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, p9), l__Attachment__8.Imploding.Size.Keypoints[2] });
	end);
	l__Attachment__11.Sphere.Size = NumberSequence.new({ l__Attachment__11.Sphere.Size.Keypoints[1], NumberSequenceKeypoint.new(0.439, 8.5), l__Attachment__11.Sphere.Size.Keypoints[3] });
	l__Attachment__11.Gradient.Size = NumberSequence.new({ l__Attachment__11.Gradient.Size.Keypoints[1], NumberSequenceKeypoint.new(1, 22.5) });
	l__Implosion__12.Imploding.Size = NumberSequence.new({ l__Implosion__12.Imploding.Size.Keypoints[1], NumberSequenceKeypoint.new(0.181, 4), l__Implosion__12.Imploding.Size.Keypoints[3] });
	l__Implosion__12.Imploding.Squash = NumberSequence.new(0.3);
	l__Attachment__11.Sphere.Speed = NumberRange.new(125, 125);
	u5(11.5, 0.55, 22.5, l__Attachment__11.Outline);
	u5(7.5, 0.55, 13.5, l__Attachment__11.Middle);
	l__Attachment__11.Sphere:Emit(75);
	task.wait(0.5);
	task.wait(0.225);
	local v18 = l__Particles__4.Orb.Distort:Clone();
	v18.CFrame = v10.CFrame;
	v18.Parent = workspace.Effects;
	l__TweenService__3:Create(v18, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(0, 0, 0)
	}):Play();
	l__TweenService__3:Create(v10, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(0, 0, 0)
	}):Play();
	l__TweenService__3:Create(v10.Implosion, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(0, 0, 0)
	}):Play();
	l__TweenService__3:Create(v10.Lightning, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(0, 0, 0)
	}):Play();
	l__TweenService__3:Create(v10.Attachment.PointLight, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Range = 0
	}):Play();
	u6 = false;
	l__Attachment__11.Vortex:Emit(35);
	l__Attachment__11.Shards:Emit(55);
	local v19 = u5(50, 0.35, 0);
	local v20 = u5(25, 0.35, 0);
	local v21 = u5(14, 0.35, 0);
	v19.Changed:Connect(function(p10)
		l__Attachment__11.Crescents.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, p10), l__Attachment__11.Crescents.Size.Keypoints[2] });
	end);
	v19.Changed:Connect(function(p11)
		l__Attachment__8.Imploding.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, p11), l__Attachment__8.Imploding.Size.Keypoints[2] });
	end);
	v20.Changed:Connect(function(p12)
		l__Attachment__8.Vortex.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, p12), l__Attachment__8.Imploding.Size.Keypoints[2] });
	end);
	l__Attachment__8.Imploding.Enabled = false;
	l__Attachment__8.Vortex.Enabled = false;
	l__Implosion__12.Imploding.Enabled = false;
	l__Attachment__11.Specs.Enabled = false;
	l__Attachment__11.Outline.Enabled = false;
	l__Attachment__11.Middle.Enabled = false;
	l__Attachment__11.Gradient.Enabled = false;
	l__Attachment__11.Crescents.Enabled = false;
	l__Attachment__11.Gradient.Size = NumberSequence.new({ l__Attachment__11.Gradient.Size.Keypoints[1], NumberSequenceKeypoint.new(1, 0) });
	l__Attachment__11.Sphere.Speed = NumberRange.new(0, 0);
	u5(22.5, 0.3, 0, l__Attachment__11.Outline);
	u5(13.5, 0.3, 0, l__Attachment__11.Middle);
	task.wait(0.3);
	local v22 = l__Particles__4.Orb.GroundVFX:Clone();
	v22.Position = Vector3.new(v10.Position.X, 0, v10.Position.Z);
	v22.Parent = workspace.Effects;
	v22.Attachment.GradientExplosion:Emit(1);
	v22.Attachment.RedExplosion:Emit(1);
	l__Debris__2:AddItem(v22, 1);
	l__TweenService__3:Create(v10, TweenInfo.new(6.75, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
		Orientation = v10.Orientation + Vector3.new(0, 360, 0)
	}):Play();
	l__TweenService__3:Create(v10.Attachment.PointLight, TweenInfo.new(0.425, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Brightness = 5, 
		Range = 60
	}):Play();
	v8:Shake(v4.Presets.Orb);
	l__Attachment__11.GradientExplosion:Emit(1);
	l__Attachment__11.Spark:Emit(1);
	l__Attachment__11.ShardsExplosion:Emit(30);
	l__Attachment__11.SpecsExplosion:Emit(85);
	l__Attachment__11.SphereExplosion:Emit(100);
	task.wait(0.65);
	l__TweenService__3:Create(l__Attachment__11.PointLight, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Brightness = 0
	}):Play();
	l__Debris__2:AddItem(v10, 1);
end;
