-- Decompiled with the Synapse X Luau decompiler.

local l__TweenService__1 = game:GetService("TweenService");
local l__Debris__2 = game:GetService("Debris");
local l__RunService__3 = game:GetService("RunService");
local l__Assets__4 = game:GetService("ReplicatedStorage").Assets;
local l__Meshes__5 = l__Assets__4.Meshes;
local v6 = require(script.Parent.Parent.Parent.Auxiliary.LightningBolt);
local v7 = require(script.Parent.Parent.Parent.Auxiliary.LightningBolt.LightningSparks);
local l__CurrentCamera__1 = workspace.CurrentCamera;
require(script.Parent.Parent.Parent.Auxiliary.CameraShaker).new(Enum.RenderPriority.Camera.Value, function(p1)
	l__CurrentCamera__1.CFrame = l__CurrentCamera__1.CFrame * p1;
end):Start();
local l__Particles__2 = l__Assets__4.Particles;
return function(...)
	local v8 = l__Particles__2.Gates.SwordHit:Clone();
	v8.CFrame = CFrame.new(({ ... })[1]) * CFrame.Angles(0, math.rad(90), 0);
	v8.Parent = workspace;
	v8.Attachment.Main:Emit(1);
	v8.Attachment.Gradient:Emit(1);
	v8.Attachment.Spark:Emit(1);
	v8.Attachment.Outline:Emit(1);
	v8.Attachment.Specs:Emit(25);
	v8.Attachment.Shards:Emit(25);
	v8.Attachment.Shards:Emit(35);
	v8.Attachment.Smoke:Emit(30);
	l__TweenService__1:Create(v8.Attachment.PointLight, TweenInfo.new(1.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Brightness = 0
	}):Play();
	l__Debris__2:AddItem(v8, 1.35);
end;
