-- Services
local Camera = workspace.CurrentCamera
local Replicated = game:GetService('ReplicatedStorage')
local TweenService = game:GetService('TweenService')
local Debris = game:GetService('Debris')

-- Assets
local Assets = Replicated.Assets
local Particles = Assets.Particles
local Meshes = Assets.Meshes

local Modules = script.Parent.Parent.Parent
local CameraShaker = require(Modules.Auxiliary.CameraShaker)
local BoltModule = require(Modules.Auxiliary.LightningBolt)
local SparksModule = require(Modules.Auxiliary.LightningBolt.LightningSparks)
local RockModule = require(Modules.Auxiliary.RockModule)


require(Modules.Auxiliary.CameraShaker).new(Enum.RenderPriority.Camera.Value, function(p1)
	Camera.CFrame = Camera.CFrame * p1
end):Start()

return function(...)
	local v8 = Particles.Potion.GravityBall:Clone()
	v8.Size = Vector3.new(5, 5, 5)
	v8.Position = ({ ... })[1]
	v8.Parent = workspace.Effects
	TweenService:Create(v8, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(30, 30, 30)
	}):Play()
	v8.Attachment.Shockwave:Emit(5)
	task.wait(2.5)
	for v9, v10 in ipairs(v8:GetDescendants()) do
		if v10:IsA("ParticleEmitter") then
			v10.Enabled = false
		end
	end
	TweenService:Create(v8, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(0, 0, 0)
	}):Play()
	TweenService:Create(v8.PointLight, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Brightness = 0
	}):Play()
	Debris:AddItem(v8, 1.5)
end
