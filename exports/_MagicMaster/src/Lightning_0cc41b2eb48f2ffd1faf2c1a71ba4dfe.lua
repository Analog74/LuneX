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
	local Textures = {'rbxassetid://8313797644', 'rbxassetid://8313742436', 'rbxassetid://8313749259', 'rbxassetid://8313756846', 'rbxassetid://8313761878', 'rbxassetid://8313768156', 'rbxassetid://8313773106', 'rbxassetid://8313780127', 'rbxassetid://8314338712', 'rbxassetid://8314340888', 'rbxassetid://8314344719', 'rbxassetid://8314350294', ''} 
	
	local Lightning = Particles.Lightning.Lightning:Clone()
	Lightning.Position = Vector3.new(Parameters[1].Position.X, 15, Parameters[1].Position.Z)
	Lightning.Lightning.CFrame = CFrame.new(Lightning.Att0.WorldPosition) * CFrame.new(0, -8.5, 0)
	Lightning.Parent = workspace.Effects
	
	local Color = Lightning.Clouds.Color
	
	local Hit = Particles.Lightning.Hit:Clone()
	Hit.Position = Vector3.new(Lightning.Position.X, 0, Lightning.Position.Z)
	Hit.Parent = workspace.Effects
	
	task.wait(1.5)
	CamShake:Shake(CameraShaker.Presets.Lightning)
	
	local Wind = Assets.Meshes.Wind:Clone()
	Wind.Orientation = Vector3.new(Wind.Orientation.X, math.random(-180, 180), Wind.Orientation.Z)
	Wind.Position = Vector3.new(Hit.Position.X, 1.5, Hit.Position.Z)
	Wind.Mesh.Scale = Vector3.new(2.5, 2.5, 2.5)
	Wind.Parent = workspace.Effects
	Wind.Decal.Transparency = 0
	Wind.Decal.Texture = 'rbxassetid://8313725039'
	Wind.Decal.Color3 = Color3.fromRGB(0, 0, 0)
	TweenService:Create(Wind.Mesh, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = Vector3.new(25, 32.5, 25)}):Play()
	TweenService:Create(Wind, TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {Orientation = Wind.Orientation + Vector3.new(0, 360, 0)}):Play()

	task.spawn(function()
		task.wait(0.25)
		
		for _, v in ipairs(Textures) do
			Wind.Decal.Texture = v
			task.wait(0.0485)
		end
	end)

	game:GetService('Debris'):AddItem(Wind, 2)
	
	Lightning.Lightning.Lightning:Emit(20)
	Lightning.Lightning.Lightning1:Emit(20)
	Lightning.Att0.Specs:Emit(5)
	Lightning.Att0.Shards:Emit(20)
	
	TweenService:Create(Lightning.Att0.Beam, TweenInfo.new(0.135, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Width0 = 6, Width1 = 6}):Play()
	TweenService:Create(Lightning.Att0.Beam1, TweenInfo.new(0.135, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Width0 = 7.5, Width1 = 7.5}):Play()
	
	--[[local Circle = Particles.Lightning.Circle:Clone()
	Circle.Position = Hit.Position + Vector3.new(0.25, 0.5, -1)
	Circle.Parent = workspace.Effects

	task.spawn(function()
		task.wait(0.3)
		for _, v in ipairs(Circle.Att0:GetChildren()) do
			TweenService:Create(v, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
		end
	end)]]
	
	TweenService:Create(Hit, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {Orientation = Hit.Orientation + Vector3.new(0, 360, 0)}):Play()
	TweenService:Create(Hit.Attachment.PointLight, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Brightness = 3.5}):Play()
	
	task.spawn(function()
		Lightning.Clouds.Color = ColorSequence.new(Color3.fromRGB(83, 82, 108))
		
		task.wait(0.05)
		
		Lightning.Clouds.Color = Color
	end)
	
	Hit.Attachment.Gradient:Emit(1)
	Hit.Attachment.Crack:Emit(1)
	Hit.Attachment.Secondary:Emit(20)
	Hit.Attachment.Rocks:Emit(10)
	Hit.Attachment.Ground:Emit(20)
	Hit.Attachment.Shards:Emit(35)
	Hit.Attachment.Specs:Emit(35)
	Hit.Specs:Emit(75)
	Hit.Shards:Emit(75)
	Hit.Attachment.Smoke:Emit(85)
	
	task.wait(0.135)
	TweenService:Create(Lightning.Att0.Beam, TweenInfo.new(0.135, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
	TweenService:Create(Lightning.Att0.Beam1, TweenInfo.new(0.135, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
	
	task.wait(1)
	TweenService:Create(Hit.Attachment.PointLight, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Brightness = 0}):Play()
	Lightning.Clouds.Enabled = false
	
	Debris:AddItem(Hit, 1.5)
	Debris:AddItem(Lightning, 2.25)
end
