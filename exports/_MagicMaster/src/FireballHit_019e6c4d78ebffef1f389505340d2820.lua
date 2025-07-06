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
	local v10 = l__Particles__3.Fireball.FireHit:Clone();
	v10.CFrame = ({ ... })[1].CFrame;
	v10.Parent = workspace.Effects;
	v9:Shake(v5.Presets.Fireball);
	v10.Attachment.Spark:Emit(1);
	v10.Attachment.Gradient:Emit(1);
	v10.Attachment.Shards:Emit(12);
	v10.Attachment.Specs:Emit(20);
	v10.Attachment.Rocks:Emit(20);
	v10.Attachment.Smoke:Emit(85);
	l__TweenService__1:Create(v10.Attachment.PointLight, TweenInfo.new(1.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Brightness = 0
	}):Play();
	l__Debris__2:AddItem(v10, 1.25);
end;
