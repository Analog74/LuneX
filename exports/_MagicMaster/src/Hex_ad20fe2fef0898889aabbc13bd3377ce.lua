-- Decompiled with the Synapse X Luau decompiler.

local l__TweenService__1 = game:GetService("TweenService")
local l__Assets__2 = game:GetService("ReplicatedStorage").Assets
local l__Particles__3 = l__Assets__2.Particles
local l__Parent__4 = script.Parent.Parent.Parent
local v5 = require(l__Parent__4.Auxiliary.LightningBolt)
local v6 = require(l__Parent__4.Auxiliary.LightningBolt.LightningSparks)
local v7 = require(l__Parent__4.Auxiliary.RockModule)
local l__CurrentCamera__1 = workspace.CurrentCamera
local l__Debris__2 = game:GetService("Debris")
require(l__Parent__4.Auxiliary.CameraShaker).new(Enum.RenderPriority.Camera.Value, function(p1)
	l__CurrentCamera__1.CFrame = l__CurrentCamera__1.CFrame * p1
end):Start()
local l__Meshes__3 = l__Assets__2.Meshes
local function u4(p2, p3, p4, p5)
	local v8 = Instance.new("Sound")
	v8.SoundId = p2
	v8.Volume = p3
	v8.Parent = p4
	v8:Play()
	l__Debris__2:AddItem(v8, p5 and 1)
	return v8
end
return function(...)
	local v9 = { ... }
	local v10 = l__Meshes__3.Hex.Circle:Clone()
	v10.Size = Vector3.new(5, 0.001, 5)
	v10.Position = Vector3.new(v9[1].Position.X, 0, v9[1].Position.Z)
	v10.PointLight.Brightness = 0
	v10.Parent = workspace.Effects
	l__TweenService__1:Create(v10, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(35, 0.001, 35)
	}):Play()
	l__TweenService__1:Create(v10, TweenInfo.new(10, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {
		Orientation = v10.Orientation + Vector3.new(0, 360, 0)
	}):Play()
	l__TweenService__1:Create(v10.PointLight, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Brightness = 2
	}):Play()
	u4("rbxassetid://7414645842", 1.5, v10, 2)
	coroutine.wrap(function()
		task.wait(0.35)
		l__TweenService__1:Create(v10, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true), {
			Size = Vector3.new(40, 0.001, 40)
		}):Play()
	end)()
	for v11, v12 in ipairs({ "rbxassetid://8155916673", "rbxassetid://8155911123", "rbxassetid://8155912633", "rbxassetid://8155914131", "rbxassetid://8155919657" }) do
		v10.Decal.Texture = v12
		task.wait(0.035)
	end
	local u5 = { "rbxassetid://7931982421", "rbxassetid://7931960318", "http://www.roblox.com/asset/?id=7931965002" }
	coroutine.wrap(function()
		for v13 = 1, 10 do
			local v14 = l__Meshes__3.Hex.Runes:Clone()
			v14.Position = v10.Position + Vector3.new(math.random(-v10.Size.X, v10.Size.X) / 3, 0, math.random(-v10.Size.Z, v10.Size.Z) / 3)
			v14.Parent = workspace.Effects
			v14.A1.Rune.Texture = u5[math.random(#u5)]
			print(u5[math.random(#u5)])
			v14.A1.Rune:Emit(1)
			l__TweenService__1:Create(v14, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				CFrame = v14.CFrame * CFrame.new(0, 20, 0)
			}):Play()
			coroutine.wrap(function()
				task.wait(3.75)
				v14.A1.Specs.Enabled = false
				v14.Trail.Enabled = false
			end)()
			task.wait(0.85)
		end
	end)()
	task.wait(10)
	v10.Attachment.Gradient.Enabled = false
	l__TweenService__1:Create(v10.PointLight, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Brightness = 0
	}):Play()
	for v15, v16 in ipairs({ "rbxassetid://8155914131", "rbxassetid://8155912633", "rbxassetid://8155911123", "rbxassetid://8155916673", "" }) do
		v10.Decal.Texture = v16
		task.wait(0.035)
	end
	l__Debris__2:AddItem(v10, 1)
end
