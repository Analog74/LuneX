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

-- Functions
local CamShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(CF)
	Camera.CFrame = Camera.CFrame * CF
end)

local function PlaySound(Id, Volume, Parent, Duration)
	local s = Instance.new('Sound')
	s.SoundId = Id
	s.Volume = Volume
	s.Parent = Parent
	s:Play()
	Debris:AddItem(s, Duration or 1)
	return s
end

CamShake:Start()

return 
	function(...)

	local Parameters = {...}
	
	local Hit = Particles.Ice.Hit:Clone()
	Hit.Position = Parameters[1]
	Hit.Parent = workspace.Effects
	
	Hit.Attachment.Spark:Emit(1)
	Hit.Attachment.Gradient:Emit(1)
	Hit.Attachment.Snowflakes:Emit(5)
	Hit.Attachment.Shards:Emit(20)
	Hit.Attachment.Smoke:Emit(25)
	Hit.Attachment.Specs:Emit(35)
	
	Debris:AddItem(Hit, 1.2)
	
	task.wait(0.35)
	TweenService:Create(Hit.Attachment.PointLight, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Brightness = 0}):Play()
end
