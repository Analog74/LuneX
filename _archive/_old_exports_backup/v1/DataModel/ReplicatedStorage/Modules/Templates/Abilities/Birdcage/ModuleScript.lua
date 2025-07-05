-- Localization
local Random = Random.new()

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
local RockModule = require(Modules.Auxiliary.RockModule)

-- Functions
local CamShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(CF)
	Camera.CFrame = Camera.CFrame * CF
end)
CamShake:Start()

-- Tween DataTypes
local function GetXAndZPositions(Angle, Radius)
	local X = math.cos(Angle) * Radius 
	local Z = math.sin(Angle) * Radius
	return X, Z
end

local function CreateCircle(Part, Number, Radius, Type)
	local Attachments = { }
	local FullCircle = 2 * math.pi

	for i = 1, Number do
		local Attachment = Instance.new(Type)
		if Attachment:IsA('Part') then
			Attachment.Transparency = 1
			Attachment.Anchored = true
			Attachment.CanCollide = false
			Attachment.Size = Vector3.new(1, 1, 1)
		end
		Attachment.Parent = Part

		local Angle = i * (FullCircle / Number)
		local X, Z = GetXAndZPositions(Angle, Radius)

		local Position = ( Part.CFrame * CFrame.new(X, 0, Z) ).Position
		local LookAt = Part.Position
		
		if Attachment:IsA('Attachment') then
			Attachment.WorldCFrame = CFrame.lookAt(Position, LookAt) * CFrame.fromEulerAnglesXYZ(0, -math.pi / Random:NextNumber(1.85, 2), 0)
		else
			Attachment.CFrame = CFrame.lookAt(Position, LookAt) * CFrame.fromEulerAnglesXYZ(0, -math.pi / Random:NextNumber(1.85, 2), 0)
		end
		
		table.insert(Attachments, Attachment)
	end
	return Attachments
end

local function PlaySound(Id, Volume, TimePosition, Parent, Duration)
	local s = Instance.new('Sound')
	s.SoundId = Id
	s.Volume = Volume
	s.TimePosition = TimePosition
	s.Parent = Parent
	s:Play()
	Debris:AddItem(s, Duration or 1)
	return s
end

return function( ... )
	local Parameters = { ... }
	local CFrames = { }
	
	local Played = false
	
	local Part = Instance.new('Part')
	Part.Anchored = true
	Part.CanCollide = false
	Part.Transparency = 1
	Part.CFrame = CFrame.new(Parameters[1]) * CFrame.new(0, 30, 0)
	Part.Size = Vector3.new(1, 1, 1)
	Part.Parent = workspace
	
	local GroundPart = Part:Clone()
	GroundPart.CFrame = CFrame.new(Parameters[1])
	GroundPart.Parent = workspace
	
	local Attachment0 = Instance.new('Attachment')
	Attachment0.Parent = Part
	
	local Attachments = CreateCircle(GroundPart, 35, 30, 'Part')
	local Attachments1 = CreateCircle(Part, 35, 0.001, 'Attachment')
	
	PlaySound('rbxassetid://8642743061', 3, 0, Part, 2)
	
	for Index, v in ipairs( Attachments ) do
		local AttIndex = Attachments1[Index]
		local Info = TweenInfo.new(Random:NextNumber(0.35, 0.55), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		CFrames[v] = v.CFrame
		
		v.CFrame = Part.CFrame
		TweenService:Create(v, Info, {CFrame = CFrames[v]}):Play()
		
		local Attachment0 = Instance.new('Attachment')
		Attachment0.Parent = v
		
		local Attachment1 = Instance.new('Attachment')
		Attachment1.Position = Vector3.new(0.225, 0, 0)
		Attachment1.Parent = v
		
		local Trail = Particles.Birdcage.Trail:Clone()
		Trail.Attachment0 = Attachment0
		Trail.Attachment1 = Attachment1
		Trail.Parent = Attachment0
		
		local Smoke = Particles.Birdcage.Smoke.Attachment.Smoke:Clone()
		Smoke.Enabled = false
		Smoke.Parent = Attachment0
		
		local Beam = Instance.new('Beam')
		Beam.Attachment0 = AttIndex
		Beam.Attachment1 = Attachment0
		Beam.Width0 = 0.1
		Beam.Width1 = 0.1
		Beam.LightInfluence = 0
		Beam.Brightness = 2
		Beam.FaceCamera = true
		Beam.Segments = 300
		Beam.Parent = Attachment0
		TweenService:Create(Beam, TweenInfo.new(Random:NextNumber(0.35, 0.925), Enum.EasingStyle.Back, Enum.EasingDirection.Out), {CurveSize0 = ( (30 * 4) / 3) }):Play()
		
		task.spawn(function()
			task.wait(0.425)
			TweenService:Create(AttIndex, TweenInfo.new(0.885, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Orientation = AttIndex.Orientation + Vector3.new(0, 175, 0)} ):Play()
			
			if not Played then
				Played = true
				PlaySound('rbxassetid://8634774193', 1, 0.1, Part, 2)
				PlaySound('rbxassetid://7056816387', 0.75, 0.1, Part, 2)
			end
			
			task.wait(0.09)
			Smoke.Enabled = true
			Trail.Enabled = true
			TweenService:Create(v, TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = v.CFrame * CFrame.new(-17.5, 0, 0)}):Play()
			TweenService:Create(Beam, TweenInfo.new(1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {CurveSize0 = ( (4 * 4 / 3) )}):Play()
			TweenService:Create(Part, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = Part.CFrame * CFrame.new(0, -10, 0)}):Play()
			
			task.wait(0.2)
			TweenService:Create(Part, TweenInfo.new(1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {CFrame = Part.CFrame * CFrame.new(0, 10, 0)}):Play()
			TweenService:Create(Beam, TweenInfo.new(0.85, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {CurveSize0 = ( (1 * 4 / 3) )}):Play()
			
			task.wait(0.45)
			TweenService:Create(Part, TweenInfo.new(0.75, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {CFrame = Part.CFrame * CFrame.new(0, -40, 0) }):Play()
			AttIndex.Orientation = Vector3.new(0, -250, 0)
			
			Debris:AddItem(Beam, 0.6)
			Debris:AddItem(AttIndex, 0.75)
			Debris:AddItem(v, 3)
			
			task.wait(0.25)
			Smoke.Enabled = false
		end)
	end
	
	task.wait(1.35)
	CamShake:Shake(CameraShaker.Presets.Birdcage)
	RockModule.new('Crater', GroundPart.CFrame * CFrame.new(0, 1, 0), 
		{
		AnimationSpeed = 0.25,
		PartCount = 13,
		Radius = 12,
		Angle = 45,
		Range = 5,
		BlockSize = {2, 3},
		HoldTime = 3
		})
	
	PlaySound('rbxassetid://7128851174', 1, 0.15, GroundPart, 2)
	
	local Hit = Particles.Birdcage.Hit:Clone()
	Hit.Position = Parameters[1]
	Hit.Parent = workspace.Effects
	
	for _, v in ipairs( Hit.Attachment:GetChildren() ) do
		if v:IsA('ParticleEmitter') then
			v:Emit( v:GetAttribute('EmitCount') )
		end
	end
	
	TweenService:Create(Hit.Attachment.PointLight, TweenInfo.new(1.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Brightness = 0}):Play()
	Debris:AddItem(Hit, 2)
end
