-- Decompiled with the Synapse X Luau decompiler.

local l__TweenService__1 = game:GetService("TweenService");
local l__Assets__2 = game:GetService("ReplicatedStorage").Assets;
local l__Meshes__3 = l__Assets__2.Meshes;
local l__Parent__4 = script.Parent.Parent.Parent;
local v5 = require(l__Parent__4.Auxiliary.CameraShaker);
local v6 = require(l__Parent__4.Auxiliary.LightningBolt);
local v7 = require(l__Parent__4.Auxiliary.LightningBolt.LightningSparks);
local v8 = require(l__Parent__4.Auxiliary.RockModule);
local l__CurrentCamera__1 = workspace.CurrentCamera;
local v9 = v5.new(Enum.RenderPriority.Camera.Value, function(p1)
	l__CurrentCamera__1.CFrame = l__CurrentCamera__1.CFrame * p1;
end);
local l__Debris__2 = game:GetService("Debris");
v9:Start();
local l__Particles__3 = l__Assets__2.Particles;
return function(...)
	local v10 = l__Particles__3.Electric.Hit:Clone();
	v10.Position = ({ ... })[1].Position;
	v10.Parent = workspace.Effects;
	v10.Attachment.Main:Emit(1);
	task.wait(0.055);
	v9:Shake(v5.Presets.LightningBlade);
	v10.Attachment.Outline:Emit(1);
	v10.Attachment.Gradient:Emit(1);
	v10.Attachment.Specs:Emit(25);
	v10.Attachment.Spark:Emit(1);
	v10.Attachment.Lightning:Emit(1);
	v10.Attachment.Lightning1:Emit(1);
	v10.Attachment.Lightning2:Emit(1);
	local u4 = { "rbxassetid://8189970113", "", "rbxassetid://8189983044", "rbxassetid://8189984421", "rbxassetid://8189985650", "rbxassetid://8189986587", "rbxassetid://8189989098", "rbxassetid://8189990246", "" };
	coroutine.wrap(function()
		task.wait(Random.new():NextNumber(0.35, 0.4));
		local v11 = Random.new():NextNumber(0.03, 0.035);
		for v12, v13 in ipairs(u4) do
			v10.Attachment.Lightning2.Texture = v13;
			task.wait(v11);
		end;
	end)();
	local u5 = { "rbxassetid://8189652665", "", "rbxassetid://8189653993", "rbxassetid://8189655563", "", "rbxassetid://8189656720", "rbxassetid://8189657822", "rbxassetid://8189659765", "rbxassetid://8189661518", "" };
	coroutine.wrap(function()
		task.wait(Random.new():NextNumber(0.5, 0.6));
		local v14 = Random.new():NextNumber(0.03, 0.04);
		v10.Attachment.Lightning3:Emit(1);
		for v15, v16 in ipairs(u5) do
			v10.Attachment.Lightning3.Texture = v16;
			task.wait(v14);
		end;
	end)();
	coroutine.wrap(function()
		for v17, v18 in ipairs(u5) do
			v10.Attachment.Lightning1.Texture = v18;
			task.wait(0.04);
		end;
	end)();
	for v19, v20 in ipairs(u5) do
		v10.Attachment.Lightning.Texture = v20;
		task.wait(0.03);
	end;
	task.wait(0.4);
	l__TweenService__1:Create(v10.Attachment.PointLight, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Brightness = 0
	}):Play();
	l__Debris__2:AddItem(v10, 1.5);
end;
