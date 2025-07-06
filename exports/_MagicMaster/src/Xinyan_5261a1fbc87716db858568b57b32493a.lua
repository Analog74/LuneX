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

local function getXAndZPositions(angle, radius)
	local x = math.cos(angle) * radius
	local z = math.sin(angle) * radius
	return x, z
end

CamShake:Start()

return 
	function(...)

	local Parameters = {...}
	local Textures = {'rbxassetid://8313797644', 'rbxassetid://8313742436', 'rbxassetid://8313749259', 'rbxassetid://8313756846', 'rbxassetid://8313761878', 'rbxassetid://8313768156', 'rbxassetid://8313773106', 'rbxassetid://8313780127', 'rbxassetid://8314338712', 'rbxassetid://8314340888', 'rbxassetid://8314344719', 'rbxassetid://8314350294', ''} 
	local Parts = {}
	
	local Charge = Particles.Xinyan.Charge.Attachment:Clone()
	Charge.Parent = Parameters[1]
	Charge.Outline:Emit(1)
	Charge.Gradients:Emit(6)
	Charge.Remains:Emit(50)
	Debris:AddItem(Charge, 1)
	
	task.wait(0.5)
	CamShake:Shake(CameraShaker.Presets.Xinyan)
	
	local Circle = Particles.Xinyan.Circle:Clone()
	Circle.Position = Vector3.new(Parameters[1].Position.X, 0, Parameters[1].Position.Z)
	Circle.Parent = workspace.Effects
	
	Circle.Attachment.Smoke:Emit(35)
	Circle.Attachment.Flames:Emit(35)
	Circle.Attachment.Drops:Emit(20)
	
	local Wind = Assets.Meshes.Wind:Clone()
	Wind.Position = Vector3.new(Circle.Position.X, 1.5, Circle.Position.Z)
	Wind.Mesh.Scale = Vector3.new(5, 5, 5)
	Wind.Parent = workspace.Effects
	Wind.Decal.Transparency = 0.85
	Wind.Decal.Color3 = Color3.fromRGB(107, 81, 54)
	Wind.Decal.Texture = 'rbxassetid://8313725039'
	TweenService:Create(Wind.Mesh, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = Vector3.new(32.5, 32.5, 32.5)}):Play()
	TweenService:Create(Wind, TweenInfo.new(7.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {Orientation = Wind.Orientation + Vector3.new(0, 360, 0)}):Play()

	task.spawn(function()
		task.wait(0.275)
		for _, v in ipairs(Textures) do
			Wind.Decal.Texture = v
			task.wait(0.0515)
		end
	end)

	game:GetService('Debris'):AddItem(Wind, 2)
	
	for _ = 1, 6 do
		table.insert(Parts, Particles.Xinyan.Flames:Clone())
	end
	
	local Enabled = true
	
	local Radius = 22.5
	local FullCircle = 2 * math.pi
	
	for i, Flames in ipairs(Parts) do
		local Angle = i * (FullCircle / #Parts)
		local X, Z = getXAndZPositions(Angle, Radius)
		
		local Position = (Parameters[1].CFrame * CFrame.new(X, -Parameters[1].CFrame.Position.Y, Z)).Position
		local LookAt = Parameters[1].Position
		
		Flames.CFrame = CFrame.lookAt(Position, LookAt) * CFrame.Angles(math.rad(18.5), 0, 0)
		Flames.FlameGround.Position = Flames.Position
		Flames.Parent = workspace.Effects
		
		task.spawn(function()
			repeat
				local Time = math.random(1, 2)
				local PositionX = Random.new():NextNumber(-Circle.Size.X, Circle.Size.X) / 2
				local PositionZ = Random.new():NextNumber(-Circle.Size.Z, Circle.Size.Z) / 2

				local Rise = Particles.Xinyan.Rise:Clone()
				Rise.CFrame = Circle.CFrame * CFrame.new(PositionX, 1, PositionZ)
				Rise.Parent = workspace.Effects
				TweenService:Create(Rise, TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = Rise.CFrame * CFrame.new(0, 25, 0)}):Play()
				
				task.spawn(function()
					task.wait(Time / 1.5)
					Rise.Particle.Sparks.Enabled = false
					Rise.A0.Trail.Enabled = false
					Debris:AddItem(Rise, 1)
				end)
				
				task.wait(Random.new():NextNumber(0.5, 0.85))
			until not Enabled
		end)
		
		task.spawn(function()
			task.wait(2.5)
			Enabled = false
			
			Circle.Attachment.Gradient.Enabled = false
			Circle.Attachment.Outline.Enabled = false
			Circle.Attachment.Middle.Enabled = false
			Circle.Specs.Enabled = false
			TweenService:Create(Circle.PointLight, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Brightness = 0}):Play()
			
			for _, v in ipairs(Flames:GetDescendants()) do
				if v:IsA('ParticleEmitter') then
					v.Enabled = false
				end
			end
			
			Debris:AddItem(Circle, 0.85)
			Debris:AddItem(Flames, 1.5)
		end)
	end
end
