-- Decompiled with the Synapse X Luau decompiler.

local l__TweenService__1 = game:GetService("TweenService");
local l__Assets__2 = game:GetService("ReplicatedStorage").Assets;
local l__Meshes__3 = l__Assets__2.Meshes;
local l__Parent__4 = script.Parent.Parent.Parent;
local v5 = require(l__Parent__4.Auxiliary.LightningBolt);
local v6 = require(l__Parent__4.Auxiliary.LightningBolt.LightningSparks);
local v7 = require(l__Parent__4.Auxiliary.RockModule);
local l__CurrentCamera__1 = workspace.CurrentCamera;
local l__Debris__2 = game:GetService("Debris");
require(l__Parent__4.Auxiliary.CameraShaker).new(Enum.RenderPriority.Camera.Value, function(p1)
	l__CurrentCamera__1.CFrame = l__CurrentCamera__1.CFrame * p1;
end):Start();
local l__Particles__3 = l__Assets__2.Particles;
local function u4(p2, p3, p4, p5)
	local v8 = Instance.new("Sound");
	v8.SoundId = p2;
	v8.Volume = p3;
	v8.Parent = p4;
	v8:Play();
	l__Debris__2:AddItem(v8, p5 and 1);
	return v8;
end;
return function(...)
	local v9 = { ... };
	local v10 = { { "rbxassetid://8085495824", "rbxassetid://8085497649", "rbxassetid://8085500784", "rbxassetid://8085501916", "rbxassetid://8085503013", "rbxassetid://8085504232", "rbxassetid://8085505431", "rbxassetid://8085505431", "rbxassetid://8085513823", "rbxassetid://8085515188", "rbxassetid://8085516591", "rbxassetid://8085517428", "rbxassetid://8085518688", "rbxassetid://8085519966", "" }, { "rbxassetid://8093600781", "rbxassetid://8093600781", "rbxassetid://8093604474", "rbxassetid://8093603463", "rbxassetid://8093605608", "rbxassetid://8093607276", "rbxassetid://8093608645", "rbxassetid://8093609787", "" } };
	task.wait(0.1);
	local v11 = l__Particles__3.Xiangling.Charge.Attachment:Clone();
	v11.Parent = v9[1];
	v11.Wind:Emit(10);
	l__Debris__2:AddItem(v11, 1);
	task.wait(0.55);
	u4("rbxassetid://8486083330", 0.85, v9[1], 2);
	local v12 = l__Particles__3.Xiangling.FlameCharge.Attachment:Clone();
	v12.Parent = v9[1];
	v12.Flames:Emit(50);
	v12.Flames1:Emit(50);
	l__TweenService__1:Create(v12.PointLight, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Brightness = 0
	}):Play();
	l__Debris__2:AddItem(v12, 1);
	local v13 = l__Particles__3.Xiangling.Pyronado:Clone();
	v13:SetPrimaryPartCFrame(CFrame.new(v9[1].CFrame.Position) * CFrame.new(0, 1.5, 0));
	v13.Parent = workspace.Effects;
	l__TweenService__1:Create(v13.Blade, TweenInfo.new(0.165, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {
		Orientation = v13.Blade.Orientation + Vector3.new(0, -360, 0)
	}):Play();
	local u5 = nil;
	task.spawn(function()
		u5 = game:GetService("RunService").RenderStepped:Connect(function()
			v13:SetPrimaryPartCFrame(v13:GetPrimaryPartCFrame() * CFrame.Angles(0, math.rad(-4), 0));
		end);
	end);
end;
