-- Services
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local TweenService = game:GetService('TweenService')
local Debris = game:GetService('Debris')

-- Assets
local Modules = ReplicatedStorage.Modules
local Assets = ReplicatedStorage.Assets
local Particles = Assets.Particles
local Meshes = Assets.Meshes

-- Modules
local CameraShaker = require(Modules.Auxiliary.CameraShaker)
local CraterModule = require(Modules.Auxiliary.RockModule)

-- Functions
local CamShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(CF)
	Camera.CFrame = Camera.CFrame * CF
end)

CamShake:Start()

local function PlaySound(Id, Volume, Parent, Duration)
	local s = Instance.new('Sound')
	s.SoundId = Id
	s.Volume = Volume
	s.Parent = Parent
	s:Play()
	Debris:AddItem(s, Duration or 1)
	return s
end

return function( ... )
	
	local Parameters = { ... }
	
	-- Particles
	local Hit = Particles.Meteors.MeteorHit:Clone()
	Hit.Name = 'FireHit'
	Hit.Position = Parameters[1]
	Hit.Parent = workspace.Effects
	
	for _, v in ipairs(Hit.Attachment:GetChildren()) do
		if v:IsA('ParticleEmitter') then
			v:Emit( v:GetAttribute('EmitCount') )
		end
	end
	
	TweenService:Create(Hit.Attachment.PointLight, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Brightness = 0}):Play()
	Debris:AddItem(Hit, 2)
	
	CraterModule({ Origin = Hit.CFrame, Radius = 7, Amount = 9, Lifetime = 1.35 })
	
	-- Mesh
	local Ring = Meshes["Ice Meteors"].Ring:Clone()
	Ring.Position = Parameters[1]
	Ring.Size = Vector3.new(0, 0, 0)
	Ring.Parent = workspace.Effects
	
	TweenService:Create(Ring, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(10, 0.65, 10)}):Play()
	task.wait(0.1)
	TweenService:Create(Ring, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(11, 0, 11), Transparency = 1}):Play()
	Debris:AddItem(Ring, 0.35)
	
	-- Crack
	local Ground = Particles.Meteors.Ground:Clone()
	Ground.Position = Parameters[1]
	Ground.Size = Vector3.new(0, 0.1, 0)
	Ground.Orientation = Vector3.new(0, math.random(-180, 180), 0)
	Ground.Parent = workspace.Effects
	TweenService:Create(Ground, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(10, 0.1, 10)}):Play()
	
	local Ground1 = Particles.Meteors.Ground:Clone()
	Ground1.Position = Parameters[1]
	Ground1.Size = Vector3.new(0, 0.1, 0)
	Ground1.Orientation = Ground.Orientation
	Ground1.Parent = workspace.Effects
	TweenService:Create(Ground1, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(10, 0.1, 10)}):Play()

	
	task.wait(0.585)
	
	TweenService:Create(Ground, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(9, 0.1, 9)}):Play()
	TweenService:Create(Ground.SurfaceGui.ImageLabel, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
	Debris:AddItem(Ground, 1)
	
	TweenService:Create(Ground1, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(9, 0.1, 9)}):Play()
	TweenService:Create(Ground1.SurfaceGui.ImageLabel, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
	Debris:AddItem(Ground1, 1)
end
