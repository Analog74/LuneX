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
	local v8 = { ... };
	local v9 = l__Particles__2.Gates.Sword:Clone();
	v9.Size = Vector3.new(0.5, 0.5, 0.375);
	v9.CFrame = v8[1].CFrame * CFrame.Angles(0, math.rad(90), math.rad(180));
	v9.Parent = workspace;
	l__TweenService__1:Create(v9, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(1.714, 6.745, 0.0377)
	}):Play();
	local u3 = nil;
	u3 = l__RunService__3.Heartbeat:Connect(function()
		if not v8[1].Parent then
			coroutine.wrap(function()
				v9.CFrame = v9.CFrame * CFrame.new(-3.5, 0, 0);
				task.wait(1);
				l__TweenService__1:Create(v9, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = Vector3.new(1.714, 0, 0.0377), 
					CFrame = v9.CFrame * CFrame.new(-1, -3.5, 0)
				}):Play();
				l__TweenService__1:Create(v9.PointLight, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Brightness = 0
				}):Play();
				coroutine.wrap(function()
					task.wait(0.75);
					v9.Transparency = 1;
				end)();
				task.wait(0.2);
				v9.Specs.Enabled = false;
				l__Debris__2:AddItem(v9, 1.35);
			end)();
			u3:Disconnect();
			return;
		end;
		if not v8[1]:GetAttribute("Active") then
			return;
		end;
		l__TweenService__1:Create(v9, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = v8[1].Position
		}):Play();
	end);
end;
