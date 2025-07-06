--Used for casting effects to the client

--[['Character_Circle': the spell circle placed under the user

'Cast_Circle': the spell circle placed at the aimed location]]
local Casting = true

local FindFirstChild, FindFirstChildOfClass, WaitForChild = script.FindFirstChild, script.FindFirstChildOfClass, script.WaitForChild

local Clone, Destroy = script.Clone, script.Destroy

local Cframe, Angles = CFrame.new, CFrame.Angles

local Vec3 = Vector3.new

local Instant = Instance.new

local ToolRef = WaitForChild(script,"ToolRef").Value

local Character_Center, Cast_Circle_Position = WaitForChild(script,"Character_Center").Value, WaitForChild(script,"Cast_Circle_Position").Value

local Character_Circle_Size, Cast_Circle_Size = WaitForChild(script,"Character_Circle_Size").Value, WaitForChild(script,"Cast_Circle_Size").Value

local Speed = WaitForChild(script,"Speed").Value

local Deletables = {}

local Services = {
	--Players = (game:FindService("Players") or game:GetService("Players")),
	RunService = (game:FindService("RunService") or game:GetService("RunService")),
	Debris = (game:FindService("Debris") or game:GetService("Debris")),
	TweenService = (game:FindService("TweenService") or game:GetService("TweenService")),
	SoundService = (game:FindService("SoundService") or game:GetService("SoundService"))
}

function Weld(A,B)
	local Weld = Instance.new("ManualWeld")
		Weld.Part0 = A
		--Name = "StabilizerWeld",
		Weld.Part1 = B
		Weld.C0 = A.CFrame:Inverse() * B.CFrame
		Weld.Parent = A
	return Weld
end


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

-- Bug fix :/

if not ToolRef:FindFirstChild("Handle")  or not ToolRef:FindFirstChild("Handle").Parent then
	if script.Parent:IsA("ScreenGui") then
		script.Parent:Destroy()
	end
	script:Destroy()
	return
end

local HandleClone = ToolRef.Handle:Clone()
Services.Debris:AddItem(HandleClone,(7/Speed)+1)
HandleClone.CFrame = ToolRef.Handle.CFrame
HandleClone.Transparency = 0
HandleClone.Massless = true
HandleClone.Parent = workspace
Services.Debris:AddItem(HandleClone, 30)
	
Weld(HandleClone,ToolRef.Handle)
coroutine.wrap(function()
	
	pcall(function()
		pcall(function()
			PlaySound(HandleClone.Startup, HandleClone)
		end)
		local C_T = 0
		
		local FireAura = HandleClone.FireAura
		
		local Trail, Trail2 = HandleClone.Trail, HandleClone.Trail2
		
		local Tip = HandleClone.Tip
		
		local Fire, FireSplash = Tip.Fire, Tip.FireSplash
		
		local FlashCircle, StarFlash = Tip.FlashCircle, Tip.StarFlash
		
		wait(0.5)
		FireAura.Enabled = true
		wait(0.5)
		FireSplash:Emit(50)
		Fire.Enabled = true
		pcall(function()
			PlaySound(HandleClone.FireSpark, HandleClone)
		end)
		wait(0.5)
		Trail.Enabled = true
		Trail2.Enabled = true
		pcall(function()
			PlaySound(HandleClone.Twirl, HandleClone)
		end)
		
		wait(1.25)
		pcall(function()
			PlaySound(HandleClone.Glare, HandleClone)
		end)
		Trail.Enabled = false
		Trail2.Enabled = false
		FlashCircle:Emit(1)
		StarFlash:Emit(1)
		Fire.Enabled = false
		FireAura.Enabled = false
	end)
end)()

coroutine.wrap(function()
	ToolRef.Handle.Transparency = 1

	local C_T, Duration = 0, 7/Speed
	local Mesh = FindFirstChildOfClass(HandleClone,"SpecialMesh")
	while C_T < Duration and Mesh do
		Mesh.VertexColor = Vec3(1,1,1):Lerp(Vec3(10,10,1),C_T/4)
		C_T = C_T + Services.RunService.RenderStepped:Wait()
	end
	
end)()

local Spell_Circle_Part = Instant("Part")
Deletables[#Deletables+1] = Spell_Circle_Part
Spell_Circle_Part.Locked = true
Spell_Circle_Part.Anchored = true
Spell_Circle_Part.CanCollide = false
Spell_Circle_Part.CastShadow = false
Spell_Circle_Part.Name = "Spell_Circle"
Spell_Circle_Part.Massless = true
Spell_Circle_Part.Color = Color3.fromRGB(4, 175, 236)
Spell_Circle_Part.Transparency = 1

local Light = Instant("PointLight")
Light.Color = Color3.fromRGB(4, 175, 236)
Light.Range = 0
Light.Name = "Light"
Light.Brightness = 1.5
Light.Shadows = true
Light.Enabled = true
Light.Parent = Spell_Circle_Part


local Spell_Circle_UI = Clone(WaitForChild(script,"SpellCircle"))

Spell_Circle_UI.Name = "Top"
Spell_Circle_UI.Circle.ImageColor3 = Color3.fromRGB(255,255,255)
Spell_Circle_UI.Face = Enum.NormalId.Top
Spell_Circle_UI.Parent = Spell_Circle_Part

Spell_Circle_UI = Clone(Spell_Circle_UI)
Spell_Circle_UI.Name = "Bottom"
Spell_Circle_UI.Face = Enum.NormalId.Bottom
Spell_Circle_UI.Parent = Spell_Circle_Part

Services.Debris:AddItem(Spell_Circle_UI, 30)


local Character_Circle = Clone(Spell_Circle_Part)
Services.Debris:AddItem(Character_Circle, 30)
Deletables[#Deletables+1] = Character_Circle
Character_Circle.Size = Character_Circle_Size

local info, colorinfo = TweenInfo.new(.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0), TweenInfo.new(7/Speed,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0)

local FadeIn, FadeOut = {ImageTransparency = 0}, {ImageTransparency = 1}

local ColorFade, ColorLightFade = {ImageColor3 = Color3.fromRGB(4, 175, 236)},{Color = Color3.fromRGB(4, 175, 236)}

local SizeIn, SizeOut = {Size = Vector3.new(1,0,1) * Character_Circle_Size}, {Size = Vector3.new(0,0,0)}

local LightIn, LightOut = {Range = 0, Enabled = true}, {Range = 0, Enabled = false}


coroutine.wrap(function()
	Character_Circle.Size = Vector3.new(0,0,0)
	Character_Circle.Top.Circle.ImageTransparency = 1
	Character_Circle.Bottom.Circle.ImageTransparency = 1
	Character_Circle.CFrame = Character_Center.CFrame * CFrame.new(0,-Character_Center.Size.Y * 1.5,0)
	Services.TweenService:Create(Character_Circle.Top.Circle,colorinfo,ColorFade):Play()
	Services.TweenService:Create(Character_Circle.Bottom.Circle,colorinfo,ColorFade):Play()
	Services.TweenService:Create(Character_Circle.Light,colorinfo,ColorLightFade):Play()
	Services.TweenService:Create(Character_Circle.Top.Circle,info,FadeIn):Play()
	LightIn.Range = 20
	Services.TweenService:Create(Character_Circle.Light,info,LightIn):Play()
	Services.TweenService:Create(Character_Circle.Bottom.Circle,info,FadeIn):Play()
	Services.TweenService:Create(Character_Circle,info,SizeIn):Play()

	Character_Circle.Parent = workspace
	pcall(function()
		PlaySound(HandleClone.Circle_Cast, Character_Circle)
	end)
end)()

coroutine.wrap(function()
	local Angle = 0
	while Character_Circle and Character_Circle.Parent do
		local delta = Services.RunService.RenderStepped:Wait()
		Character_Circle.CFrame = Character_Center.CFrame * Cframe(0,-Character_Center.Size.Y * 1.5,0) * Angles(0,Angle,0)
		Angle = Angle + (math.rad(90) * delta)
		Angle = Angle > math.rad(360) and 0 or Angle + delta
	end
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
	
	local BodyForce = Instance.new("BodyForce")
	BodyForce.Name = "Debris_Float"
	BodyForce.Parent = Block_Debris
	
	--workspace:FindPartOnRayWithIgnoreList(,Deletables,false,false)
	
	local Down = Vector3.new(0,-1,0)
	
	local NewRay = Ray.new
	
	while Character_Circle and Character_Circle.Parent and Casting and Character_Center do
		local Floating_Debris = Clone(Block_Debris)
		Floating_Debris.Size = Vec3(Seed:NextNumber(.5,4),Seed:NextNumber(.5,4),Seed:NextNumber(.5,4))
		Floating_Debris.RotVelocity = Vec3(Seed:NextNumber(-5,5),Seed:NextNumber(-5,5),Seed:NextNumber(-5,5))
		Services.Debris:AddItem(Floating_Debris,5)
		
		local cframe = (Character_Circle.CFrame * Angles(0,math.rad(Seed:NextNumber(1,360)),0)) * Cframe(0,0, Seed:NextNumber(math.max(Character_Center.Size.X,Character_Center.Size.Y,Character_Center.Size.Z),Character_Circle.Size.Z*2) )
		
		local hit = FindPartOnRay(workspace,NewRay(cframe.Position + Vec3(0,5,0), Character_Center.CFrame.UpVector*-10),Deletables,false,false)
		--print(hit)
		Floating_Debris.Color = (hit and hit.Color) or Color3.fromRGB(255,170,0)
		Floating_Debris.Material = (hit and hit.Material) or Enum.Material.Granite
		
		Floating_Debris.CFrame = cframe
		Floating_Debris.Debris_Float.Force = Vec3(0,Floating_Debris:GetMass() * workspace.Gravity,0)
		Floating_Debris.Velocity = Vec3(0,Seed:NextNumber(10,25),0)
		Floating_Debris.Parent = workspace
		wait(.25)
	end
end)()


local Cast_Circle = Clone(Spell_Circle_Part)
Services.Debris:AddItem(Cast_Circle, 30)
Deletables[#Deletables+1] = Cast_Circle
Cast_Circle.Size = Cast_Circle_Size
Cast_Circle.CFrame = Cast_Circle_Position
Cast_Circle.Parent = workspace
coroutine.wrap(function()
	pcall(function()
		Cast_Circle.Size = Vector3.new(0,0,0)
		Cast_Circle.Top.Circle.ImageTransparency = 1
		Cast_Circle.Bottom.Circle.ImageTransparency = 1
		Cast_Circle.CFrame = Cast_Circle_Position
		Services.TweenService:Create(Cast_Circle.Top.Circle,colorinfo,ColorFade):Play()
		Services.TweenService:Create(Cast_Circle.Light,colorinfo,ColorLightFade):Play()
		Services.TweenService:Create(Cast_Circle.Bottom.Circle,colorinfo,ColorFade):Play()
		Services.TweenService:Create(Cast_Circle.Top.Circle,info,FadeIn):Play()
		LightIn.Range = 150
		Services.TweenService:Create(Cast_Circle.Light,info,LightIn):Play()
		Services.TweenService:Create(Cast_Circle.Bottom.Circle,info,FadeIn):Play()
		SizeIn.Size = Cast_Circle_Size
		Services.TweenService:Create(Cast_Circle,info,SizeIn):Play()
	
		Character_Circle.Parent = workspace
		
	end)
end)()

coroutine.wrap(function()
	while Cast_Circle and Cast_Circle.Parent do
		local delta = Services.RunService.RenderStepped:Wait()
		Cast_Circle.CFrame = Cast_Circle.CFrame * Angles(0,math.rad(90) * delta,0)
	end
end)()

local Circles = {}
local Size = Cast_Circle_Size.X
local Sizes = {Size,Size*.2,Size*.4,Size*.5,Size*.6,Size*.8,Size*.7,Size*.4,Size*.6}
coroutine.wrap(function() --Summon the large hovering spell circles
	pcall(function()	
		for i=0, #Sizes-1, 1 do
			if Casting then
				local CircleClone = Clone(Spell_Circle_Part)
				Services.Debris:AddItem(CircleClone, 30)
				Circles[#Circles+1] = CircleClone
				Deletables[#Deletables+1] = CircleClone
				CircleClone.CFrame = Cast_Circle_Position * Cframe(0,150 - (15 * i),0)
				--print((Sizes[i+1] or 100))
				--CircleClone.Size = Vector3.new(1,0,1) * (Sizes[i+1] or 100)
				local Sparks = Clone(script.Sparks)
				Sparks.Parent = CircleClone
				
				CircleClone.Top.Circle.ImageTransparency = 1
				CircleClone.Bottom.Circle.ImageTransparency = 1
				pcall(function()
					Services.TweenService:Create(CircleClone.Top.Circle,colorinfo,ColorFade):Play()
					Services.TweenService:Create(CircleClone.Light,colorinfo,ColorLightFade):Play()
					Services.TweenService:Create(CircleClone.Bottom.Circle,colorinfo,ColorFade):Play()
					Services.TweenService:Create(CircleClone.Top.Circle,info,FadeIn):Play()
					LightIn.Range = (Sizes[i+1] or 100)
					Services.TweenService:Create(CircleClone.Light,info,LightIn):Play()
					Services.TweenService:Create(CircleClone.Bottom.Circle,info,FadeIn):Play()
				end)
				SizeIn.Size = Vector3.new(1,0,1) * (Sizes[i+1] or 100)
				Services.TweenService:Create(CircleClone,info,SizeIn):Play()
				CircleClone.Parent = workspace
				pcall(function()
					PlaySound(HandleClone.Circle_Layer, CircleClone, 1 + (i * .025), (Sizes[i+1] or 100))
				end)
				--PlaySound(HandleClone.Circle_Layer, CircleClone)
				Sparks.Enabled = true
				coroutine.wrap(function()
					while CircleClone and CircleClone.Parent do
						local delta = Services.RunService.RenderStepped:Wait()
						CircleClone.CFrame = CircleClone.CFrame * Angles(0,math.rad(-90) * delta,0)
					end
				end)()
				wait(.15)
			end
		end
	end)
	
end)()


local Connections = {}
function Clean()
	Casting = false
			
	if #Deletables > 0 then
		for i=1,#Deletables,1 do
			if Deletables[i] and Deletables[i].Parent then
				Services.Debris:AddItem(Deletables[i],2);
				Deletables[i] = nil;
			end
		end
	end
	
	Deletables = nil
	
	if #Connections > 0 then
		for i=1,#Connections do
			if Connections[i] then
				Connections[i]:Disconnect();
				Connections[i] = nil
			end
		end
	end
	
	Connections = nil
				
	pcall(function()
		ToolRef.Handle.Transparency = 0
	end)
	if HandleClone and HandleClone.Parent then
		Destroy(HandleClone)
	end
	
	pcall(function()		
		Services.TweenService:Create(Character_Circle.Light,info,LightOut):Play()
		Services.TweenService:Create(Character_Circle.Top.Circle,info,FadeOut):Play()
		Services.TweenService:Create(Character_Circle.Bottom.Circle,info,FadeOut):Play()
		Services.TweenService:Create(Character_Circle,info,SizeOut):Play()
	end)
		
	if #Circles > 0 then
		for i=1,#Circles,1 do
			if Circles[i] then
				pcall(function()
					Circles[i].Sparks.Enabled = false
				end)
				pcall(function()
					Services.TweenService:Create(Circles[i].Light,info,LightOut):Play()
					Services.TweenService:Create(Circles[i].Top.Circle,info,FadeOut):Play()
					Services.TweenService:Create(Circles[i].Bottom.Circle,info,FadeOut):Play()
					Services.TweenService:Create(Circles[i],info,SizeOut):Play()
				end)
			end
		end
	end
	pcall(function()		
		Services.TweenService:Create(Cast_Circle.Light,info,LightOut):Play()
		Services.TweenService:Create(Cast_Circle.Top.Circle,info,FadeOut):Play()
		Services.TweenService:Create(Cast_Circle.Bottom.Circle,info,FadeOut):Play()
		Services.TweenService:Create(Cast_Circle,info,SizeOut):Play()
	end)
end


pcall(function()
	script:WaitForChild("Finish",10).Changed:Connect(function()
		if script.Finish.Value then
			Clean()
		end
	end)
end)
pcall(function()
	Connections[#Connections+1] = ToolRef.Unequipped:Connect(Clean)
end)
pcall(function()
	Connections[#Connections+1] = ToolRef.Changed:Connect(function(Property)
		-- Deeper check if tool is deleted/unequip or something.
		-- Added by EunhaFlower
		if Property == "Parent" then
			if not ToolRef or not ToolRef.Parent then
				Clean()
			end
		end
	end)
end)
