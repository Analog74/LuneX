--Used for the Explosion itself on the client

local FindFirstChild, FindFirstChildOfClass, WaitForChild = script.FindFirstChild, script.FindFirstChildOfClass, script.WaitForChild

local Clone, Destroy = script.Clone, script.Destroy

local Cframe, Angles = CFrame.new, CFrame.Angles

local Instant = Instance.new

local Explosion_Position = WaitForChild(script,"Explosion_Position").Value

local Explosion_Size = WaitForChild(script,"Explosion_Size").Value

local Camera = workspace.CurrentCamera

local Services = {
	Players = (game:FindService("Players") or game:GetService("Players")),
	RunService = (game:FindService("RunService") or game:GetService("RunService")),
	Debris = (game:FindService("Debris") or game:GetService("Debris")),
	TweenService = (game:FindService("TweenService") or game:GetService("TweenService")),
	SoundService = (game:FindService("SoundService") or game:GetService("SoundService"))
}

function PlaySound(Sound,SpecifiedLocation, Pitch, EmitterSize)
	pcall(function()
		local SoundClone = Clone(Sound)
		SoundClone.Pitch = Pitch or SoundClone.Pitch
		SoundClone.EmitterSize = EmitterSize or SoundClone.EmitterSize
		Services.Debris:AddItem(SoundClone, SoundClone.TimeLength)
		SoundClone.Parent = SpecifiedLocation
		Services.SoundService:PlayLocalSound(SoundClone)
	end)
end

local Player = Services.Players.LocalPlayer

local Character = Player.Character or Player.CharacterAdded:Wait()

--local Root = WaitForChild(Character,"HumanoidRootPart")
local Root = Character:FindFirstChild("HumanoidRootPart") -- I prefer this :/

if not Root then -- Yeah just
	script:Destroy();
	return
end

local Explosion_Sphere = Instant("Part")
Services.Debris:AddItem(Explosion_Sphere,6)
--Deletables[#Deletables+1] = Explosion_Sphere
Explosion_Sphere.Locked = true
Explosion_Sphere.Anchored = true
Explosion_Sphere.CanCollide = false
Explosion_Sphere.CastShadow = false
Explosion_Sphere.Material = Enum.Material.Neon
Explosion_Sphere.Shape = Enum.PartType.Ball
Explosion_Sphere.Size = Vector3.new(1,1,1)
Explosion_Sphere.CFrame = Cframe(Explosion_Position)
Explosion_Sphere.Name = "Explosion_Sphere"
Explosion_Sphere.Massless = true
Explosion_Sphere.Color = Color3.fromRGB(128, 187, 219)
Explosion_Sphere.Transparency = 0

local Explosion_Mesh = Instance.new("SpecialMesh")
Explosion_Mesh.MeshType = Enum.MeshType.Sphere
--Explosion_Mesh.MeshId = "rbxassetid://168892432"
--Explosion_Mesh.TextureId = "rbxassetid://967852042"
Explosion_Mesh.Scale = Vector3.new(1,1,1) * Explosion_Size
Explosion_Mesh.VertexColor = Vector3.new(1,1,1)
Explosion_Mesh.Offset = Vector3.new(0,0,0)
Explosion_Mesh.Name = "Explosion_Mesh"
Explosion_Mesh.Parent = Explosion_Sphere

local CenterAttachment = Instant("Attachment")
CenterAttachment.Name = "Center"
CenterAttachment.Position = Vector3.new(0,0,0)
CenterAttachment.Parent = Explosion_Sphere


local Explosion_Beam = Instant("Part")
Services.Debris:AddItem(Explosion_Beam,6)
--Deletables[#Deletables+1] = Explosion_Beam
Explosion_Beam.Locked = true
Explosion_Beam.Anchored = true
Explosion_Beam.CanCollide = false
Explosion_Beam.CastShadow = false
Explosion_Beam.Material = Enum.Material.Neon
Explosion_Beam.Shape = Enum.PartType.Cylinder
Explosion_Beam.CFrame = Cframe(Explosion_Position) * Angles(0,0,math.pi * .5) * Cframe(1000 * .5,0,0)
Explosion_Beam.Name = "Explosion_Beam"
Explosion_Beam.Massless = true
Explosion_Beam.Color = Color3.fromRGB(128, 187, 219)
Explosion_Beam.Transparency = 0

local CenterBeamAttachment = Instant("Attachment")
CenterBeamAttachment.Name = "Center"
CenterBeamAttachment.Orientation = Vector3.new(0,0,90)
CenterBeamAttachment.Parent = Explosion_Beam

local Explosion_Wind = Instant("Part")
Services.Debris:AddItem(Explosion_Wind,6)
--Deletables[#Deletables+1] = Explosion_Wind
Explosion_Wind.Locked = true
Explosion_Wind.Anchored = true
Explosion_Wind.CanCollide = false
Explosion_Wind.CastShadow = false
Explosion_Wind.Material = Enum.Material.Neon
Explosion_Wind.Shape = Enum.PartType.Ball
Explosion_Wind.Size = Vector3.new(0,0,0)
Explosion_Wind.CFrame = Cframe(Explosion_Position)
Explosion_Wind.Name = "Explosion_Wind"
Explosion_Wind.Massless = true
Explosion_Wind.Color = Color3.fromRGB(255, 255, 255)
Explosion_Wind.Transparency = 0

local Wind_Mesh = Instance.new("SpecialMesh")
Wind_Mesh.MeshType = Enum.MeshType.FileMesh
Wind_Mesh.MeshId = "rbxassetid://168892432"
Wind_Mesh.TextureId = "rbxassetid://967852042"
Wind_Mesh.Scale = Vector3.new(0.267, 0.133, 0.267) * Explosion_Size
Wind_Mesh.VertexColor = Vector3.new(1,1,1) * 10
Wind_Mesh.Offset = Vector3.new(0,0,0)
Wind_Mesh.Name = "Wind_Mesh"
Wind_Mesh.Parent = Explosion_Wind


local info = TweenInfo.new(4, Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0)

local Explosion_Tween = {Transparency = 1, Color = Color3.fromRGB(128, 187, 219)}

local Explosion_Beam_Tween = {Size = Vector3.new(1000,0,0), Transparency = 1}

local WindMesh_Tween = {Scale = Vector3.new(0.267, 0.133, 0.267) * Explosion_Size * 2}

local ExplosionMesh_Tween = {Scale = Vector3.new(1,1,1) * Explosion_Size * 2}

coroutine.wrap(function()
	
	local Tint = Instance.new("ColorCorrectionEffect")
	Tint.Brightness = 1
	Tint.Contrast = 1
	Tint.Enabled = true
	Tint.Saturation = -1
	Tint.TintColor = Color3.new(1,1,1)
	
	Services.Debris:AddItem(Tint, 10) -- Takeo please use debris more :/
	-- My friend literally said he got perm blind :/
	
	
	local Explosion_Smoke = Clone(script.Explosion_Smoke)
	Explosion_Smoke.Parent = CenterAttachment
	
	
	local Ember = Clone(script.Ember)
	Ember.Parent = Explosion_Sphere
	
	Explosion_Mesh.Scale = Vector3.new(1,1,1) * 0
	Explosion_Sphere.Size = Vector3.new(1,1,1) * Explosion_Size

	
	Explosion_Sphere.Parent = workspace
	
	Ember:Emit(Ember.Rate)
	
	coroutine.wrap(function()
		wait(.2)
		if Explosion_Sphere and Explosion_Mesh then
			Explosion_Sphere.Size = Vector3.new(1,1,1) * 1
			Explosion_Mesh.Scale = Vector3.new(1,1,1) * Explosion_Size
		end
	end)()
	
	
	coroutine.wrap(function()
		if Root and Root.Parent and (Root.Position-Explosion_Position).Magnitude <= (Explosion_Size * 4) then
			Tint.Parent = Camera
			wait(.1)
			if Tint and Tint.Parent then
				Destroy(Tint)
			end
		end
	end)()
	
	coroutine.wrap(function()
		pcall(function()
			local Tween = Services.TweenService:Create(Explosion_Mesh,info,ExplosionMesh_Tween);Tween:Play()
			Tween = Services.TweenService:Create(Explosion_Sphere,info,Explosion_Tween);Tween:Play()
		end)
	end)()
	
	Explosion_Wind.Parent = workspace
	coroutine.wrap(function()
		pcall(function()
			local Tween = Services.TweenService:Create(Wind_Mesh,info,WindMesh_Tween);Tween:Play()
			Tween = nil
			Tween = Services.TweenService:Create(Explosion_Wind,info,Explosion_Tween);Tween:Play()
			Tween = nil
			while Explosion_Wind and Explosion_Wind.Parent do
				Explosion_Wind.CFrame = Explosion_Wind.CFrame * Angles(0,math.rad(90) * Services.RunService.RenderStepped:Wait(),0)
			end
		end)
	end)()
	
	pcall(function()
		Explosion_Smoke:Emit(Explosion_Smoke.Rate)
		Explosion_Smoke = Clone(script.Explosion_Smoke)
		Explosion_Smoke.Parent = CenterBeamAttachment
		Explosion_Smoke:Emit(Explosion_Smoke.Rate)
		Explosion_Beam.Size = Vector3.new(1000,50,50)
		CenterBeamAttachment.Position = Vector3.new((-Explosion_Beam.Size.X*.5)*.75,0,0)
		Explosion_Beam.Parent = workspace
		Services.TweenService:Create(Explosion_Beam,info,Explosion_Beam_Tween):Play()
		PlaySound(script.Explosion, CenterAttachment, 1, Explosion_Size)
	end)
	
	
end)()

coroutine.wrap(function()
	local Block_Debris = Instance.new("Part")
	Block_Debris.Locked = true
	Block_Debris.CanCollide = false
	Block_Debris.Anchored = false
	Block_Debris.Massless = true
	Block_Debris.CastShadow = true
	Block_Debris.TopSurface = Enum.SurfaceType.Smooth
	Block_Debris.BottomSurface = Enum.SurfaceType.Smooth
	Block_Debris.Name = "Rising_Debris"
	
	local Seed = Random.new(tick())
	
	local FindPartOnRay = workspace.FindPartOnRayWithIgnoreList
	
	--[[local BodyForce = Instance.new("BodyForce")
	BodyForce.Name = "Debris_Float"
	BodyForce.Parent = Block_Debris]]
	
	--workspace:FindPartOnRayWithIgnoreList(,Deletables,false,false)
	
	local Down = Vector3.new(0,-1,0)
	local Ignore = {Character}
	for i=1, 25, 1 do
		local Floating_Debris = Clone(Block_Debris)
		Floating_Debris.Size = Vector3.new(Seed:NextNumber(5,25),Seed:NextNumber(5,25),Seed:NextNumber(5,25))
		Floating_Debris.RotVelocity = Vector3.new(Seed:NextNumber(-5,5),Seed:NextNumber(-5,5),Seed:NextNumber(-5,5))
		Services.Debris:AddItem(Floating_Debris,5)
		
		local cframe = (Cframe(Explosion_Position) * Angles(0,math.rad(Seed:NextNumber(1,360)),0)) * CFrame.new(0,0, Seed:NextNumber(0,Explosion_Size*2) )
		
		local hit = FindPartOnRay(workspace,Ray.new(cframe.Position + Vector3.new(0,5,0), Cframe(Explosion_Position).UpVector*-10),Ignore,false,false)
		--print(hit)
		Floating_Debris.Color = (hit and hit.Color) or Color3.fromRGB(255,170,0)
		Floating_Debris.Material = (hit and hit.Material) or Enum.Material.Granite
		
		Floating_Debris.CFrame = cframe + Vector3.new(0,math.max(Floating_Debris.Size.X,Floating_Debris.Size.Y,Floating_Debris.Size.Z) + 1,0)
		--Floating_Debris.Debris_Float.Force = Vector3.new(0,Floating_Debris:GetMass() * workspace.Gravity,0)
		Floating_Debris.Velocity = Vector3.new(Seed:NextNumber(-50,50),Seed:NextNumber(150,200),Seed:NextNumber(-50,50))
		Floating_Debris.Parent = workspace
		--wait(.25)
	end
end)()

coroutine.wrap(function()
	local Duration = 3
	local Shake_Strength = .65
	local C_T = 0
	local Seed = Random.new()
	local Total_Strength = 1--(Camera.CFrame.Position-Explosion_Position).Magnitude/Explosion_Size * 5
	while Root and C_T < Duration and (Root.Position - Explosion_Sphere.Position).Magnitude <= 400 do
		local Decay = 1-(C_T/Duration)
		Total_Strength = Shake_Strength * Decay * (1-(Root.Position-Explosion_Position).Magnitude/(Explosion_Size * 4))
		--Seed:NextNumber(-ShakeStrength * Decay , ShakeStrength * Decay)
		Camera.CFrame = Camera.CFrame * CFrame.new(Seed:NextNumber(-Total_Strength * Decay , Total_Strength * Decay),Seed:NextNumber(-Total_Strength * Decay , Total_Strength * Decay),Seed:NextNumber(-Total_Strength * Decay , Total_Strength * Decay))
		C_T = C_T + Services.RunService.RenderStepped:Wait()
	end
end)()
