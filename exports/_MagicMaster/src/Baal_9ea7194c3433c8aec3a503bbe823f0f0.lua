-- Decompiled with the Synapse X Luau decompiler.

local l__TweenService__1 = game:GetService("TweenService");
local l__Debris__2 = game:GetService("Debris");
local l__Assets__3 = game:GetService("ReplicatedStorage").Assets;
local l__Meshes__4 = l__Assets__3.Meshes;
local v5 = require(script.Parent.Parent.Parent.Auxiliary.CameraShaker);
local v6 = require(script.Parent.Parent.Parent.Auxiliary.LightningBolt);
local v7 = require(script.Parent.Parent.Parent.Auxiliary.LightningBolt.LightningSparks);
local l__CurrentCamera__1 = workspace.CurrentCamera;
local v8 = v5.new(Enum.RenderPriority.Camera.Value, function(p1)
	l__CurrentCamera__1.CFrame = l__CurrentCamera__1.CFrame * p1;
end);
v8:Start();
local l__Particles__2 = l__Assets__3.Particles;
return function(...)
	local v9 = l__Particles__2.Baal.Baal:Clone();
	v9.CFrame = ({ ... })[1].CFrame * CFrame.new(0, 4.5, -7.5) * CFrame.Angles(0, math.rad(90), 0);
	v9.Parent = workspace.Effects;
	l__TweenService__1:Create(v9.PointLight, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Brightness = 3.25
	}):Play();
	v9.Attachment.Shards3:Emit(3);
	task.wait(0.25);
	v8:Shake(v5.Presets.Lightning1);
	v9.Attachment.Main:Emit(1);
	v9.Attachment.Center:Emit(1);
	v9.Attachment.Sparks:Emit(10);
	v9.Attachment.Gradient:Emit(1);
	v9.Attachment.Spark1:Emit(1);
	v9.Attachment.Shards1:Emit(20);
	v9.Attachment.Specs1:Emit(35);
	v9.Attachment.Smoke:Emit(30);
	task.wait(0.8);
	v8:Shake(v5.Presets.Lightning1);
	v9.Attachment.Shards2:Emit(15);
	v9.Attachment.Shards:Emit(30);
	v9.Attachment.Gradient1:Emit(1);
	v9.Attachment.Specs:Emit(25);
	l__TweenService__1:Create(v9.PointLight, TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Brightness = 0
	}):Play();
	l__Debris__2:AddItem(v9, 1);
end;
