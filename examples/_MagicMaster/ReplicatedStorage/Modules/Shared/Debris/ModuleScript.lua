local DebrisModule = {}

local ts = game:GetService("TweenService")
local cs = game:GetService("CollectionService")
local rs = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local fx = rs:WaitForChild("FX")

local function neonFlash(Target, originalMaterial, OriginalBrickColor)
	delay(0.05, function()
		Target.Material = Enum.Material.Neon
		Target.BrickColor = BrickColor.new("Persimmon")
		wait(0.05)
		Target.Material = originalMaterial
		Target.BrickColor = OriginalBrickColor

		delay(0.1, function()
			Target.Material = Enum.Material.Neon
			Target.BrickColor = BrickColor.new("Persimmon")
			wait(0.05)
			Target.Material = originalMaterial
			Target.BrickColor = OriginalBrickColor

			delay(0.1, function()
				Target.Material = Enum.Material.Neon
				Target.BrickColor = BrickColor.new("Persimmon")
				wait(0.05)
				Target.Material = originalMaterial
				Target.BrickColor = OriginalBrickColor
				delay(0.1, function()
					Target.Material = Enum.Material.Neon
					Target.BrickColor = BrickColor.new("Persimmon")
				end)
			end)
		end)
	end)
end

function DebrisModule.Blocks(TargetCFrame, skillName)
	local folder = Instance.new("Folder")
	folder.Name = "Debris"
	folder.Parent = workspace
	
	local floor = cs:GetTagged("Floor")
	
	if skillName == "Hammer" then

		local Blocks = script:WaitForChild("Hammer"):Clone()
		Blocks:SetPrimaryPartCFrame(TargetCFrame * CFrame.new(10, 0, 0) * CFrame.Angles(0,math.rad(0), math.rad(-90)))
		Blocks.Parent = folder

		local fullSize = Vector3.new(8, 3, 3)

		for i, v in pairs(Blocks:GetChildren()) do		
			if v.Name == "Block" then
				local rayparams = RaycastParams.new()
				rayparams.FilterType = Enum.RaycastFilterType.Whitelist
				rayparams.FilterDescendantsInstances = {floor}
				
				local ray = workspace:Raycast(v.CFrame.p, v.CFrame.UpVector * -10000, rayparams)
				if ray then
					v.Material = ray.Instance.Material
					v.Color = ray.Instance.Color
					v.Position = Vector3.new(v.Position.X, ray.Instance.Size.Y, v.Position.Z)
				end

				local args = {Size = fullSize}
				local info = TweenInfo.new(0.1, Enum.EasingStyle.Elastic)
				local t = ts:Create(v, info, args)
				t:Play()

				delay(0.05, function()
					delay(4, function()
						local a = {Size = Vector3.new(0.005,0.005,0.005)}
						local i = TweenInfo.new(0.7, Enum.EasingStyle.Back)
						local tw = ts:Create(v, i, a)

						tw:Play()
						--neonFlash(v, v.Material, v.BrickColor)

						delay(1, function()
							v:Destroy()
						end)
					end)
				end)
			end
		end
		game.Debris:AddItem(folder, 7)
	elseif skillName == "Thunder" then
		local folder = Instance.new("Folder")
		folder.Name = "Debris"
		folder.Parent = workspace

		local Blocks = script:WaitForChild("Thunder"):Clone()
		Blocks:SetPrimaryPartCFrame(TargetCFrame * CFrame.new(-35.5,0, 0) * CFrame.Angles(0,math.rad(0), math.rad(-90)))
		Blocks.Parent = folder

		local fullSize = Vector3.new(14, 3, 6)

		local cs = game:GetService("CollectionService")

		local floor = cs:GetTagged("Floor")

		for i, v in pairs(Blocks:GetChildren()) do		
			if v.Name == "Block" then

				local rayparams = RaycastParams.new()
				rayparams.FilterType = Enum.RaycastFilterType.Whitelist
				rayparams.FilterDescendantsInstances = {floor}

				local ray = workspace:Raycast(v.CFrame.p, v.CFrame.UpVector * -10000, rayparams)
				if ray then
					v.Material = ray.Instance.Material
					v.Color = ray.Instance.Color
					v.Position = Vector3.new(v.Position.X, ray.Instance.Size.Y, v.Position.Z)
				end

				local args = {Size = fullSize}
				local info = TweenInfo.new(0.1, Enum.EasingStyle.Elastic)
				local t = ts:Create(v, info, args)
				t:Play()

				delay(0.05, function()
					delay(4, function()
						local a = {Size = Vector3.new(0.005,0.005,0.005)}
						local i = TweenInfo.new(0.7, Enum.EasingStyle.Back)
						local tw = ts:Create(v, i, a)

						tw:Play()
						--neonFlash(v, v.Material, v.BrickColor)

						delay(1, function()
							v:Destroy()
						end)
					end)
				end)
			end
		end
		game.Debris:AddItem(folder, 7)
	end
end

function DebrisModule.BlocksAround(Target, amount, radius, size)
	local yOffset = 0 --How far you want your parts to go down below the HMRP
	
	local folder = Instance.new("Folder")
	folder.Name = "PartCache"
	folder.Parent = workspace
	
	local function Part() -- Function to instantiate your part for each limb
		local prt =  Instance.new("Part")
		prt.Size = Vector3.new(0,0,0)
		prt.Anchored = true
		prt.CanCollide = false
		return prt
	end
	
	local floor = cs:GetTagged("Floor")
	
	local total = amount -->> Such as there are 8 limbs in this post
	local standardRadius = 10
	
	local startInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad)
	local endInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back)
	
	local startAgrs = { Size = size}
	local endArgs = { Size = Vector3.new(0,0,0) }
	
	for i=1,total do
		local angle = (math.pi*2/total) * i  -- There are 360 degrees in a circle or pi*2 radians
		local x = radius * math.cos(angle) 
		local y = radius * math.sin(angle)

		local part = Part()
		part.CFrame = Target.CFrame * CFrame.new(x, yOffset, y)
		
		part.Parent = folder
		
		local rayparams = RaycastParams.new()
		rayparams.FilterType = Enum.RaycastFilterType.Whitelist
		rayparams.FilterDescendantsInstances = {floor}
		
		local startTween = ts:Create(part, startInfo, startAgrs):Play()
		task.delay(4, function()
			local endTween = ts:Create(part, endInfo, endArgs):Play()
		end)
		
		local ray = workspace:Raycast(part.CFrame.p, part.CFrame.UpVector * -10000, rayparams)
		if ray then
			part.Material = ray.Instance.Material
			part.Color = ray.Instance.Color
			part.CFrame = CFrame.new(part.CFrame.X, ray.Instance.Size.Y, part.CFrame.Z)
			part.CFrame = CFrame.lookAt(part.CFrame.p, Target.CFrame.p)
			--part.Orientation = Vector3.new(part.Orientation.X, part.Orientation.Y, part.Orientation.Z)
		end
	end
	
	game.Debris:AddItem(folder, 7)
	
end

function DebrisModule.BlockExplosion(Target, TargetPosition, TargetCFrame)
	for partAdd = 1, math.random(5, 10) do
		local Effect = script:WaitForChild("Block"):Clone()
		Effect.Transparency = 0
		Effect.Parent = workspace
		
		local size = math.random(4, 6)

		local origin = TargetPosition
		local direction = Vector3.new(0,-100,0)
		
		local floor = cs:GetTagged("Floor")
		
		local Params = RaycastParams.new()
		Params.FilterDescendantsInstances = floor
		Params.FilterType = Enum.RaycastFilterType.Whitelist
		
		local raycastResult = workspace:Raycast(origin, direction, Params)
		
		local hitPart = raycastResult.Instance

		Effect.Material = hitPart.Material
		Effect.Color = hitPart.Color
		Effect.Size = Vector3.new(size,size,size)

		Effect.CFrame = TargetCFrame * CFrame.Angles(math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)))
		
		
		local db = false
		delay(0.5, function()
			Effect.Touched:Connect(function(hit)
				if cs:HasTag(hit, "Floor") or cs:HasTag(hit.Parent, "Floor") and not db then
					local expFX = fx:FindFirstChild("Break"):Clone()
					expFX.Color = ColorSequence.new(Effect.Color)
					expFX.Parent = Effect
					expFX:Emit(70)
					
					local sfx = script:FindFirstChild("Break"):Clone()
					sfx.Parent = Effect
					sfx:Play()

					Effect.Anchored = true
					Effect.Transparency = 1
				end
			end)
		end)
		
		--Effect.Splatter:Play()

		local EffectVelocity = Instance.new("BodyVelocity", Effect)
		EffectVelocity.MaxForce = Vector3.new(0.5, 2, 0.5) * 1000000;
		EffectVelocity.Velocity = Vector3.new(0.5, 2, 0.5) * Effect.CFrame.LookVector * math.random(50, 70)

		game.Debris:AddItem(EffectVelocity, 0.3)
		game.Debris:AddItem(Effect, 7)
	end
end

--[[ -- NOT WORKING, TOO LAZY TO FIX!! DNC!!!

DebrisModule.Parts = function(target)
	local Tween1 = TweenInfo.new(.45,Enum.EasingStyle.Back,Enum.EasingDirection.In)
	
	local taggedFloor = cs:GetTagged("Floor")
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {taggedFloor}
	raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
	
	local Amount,Max = 20, 2.5  ---Amount of rocks and max length upwards
	local FirstDuration, RocksLength = .5, 3--- How long it takes to tween and when it goes away
	local Cframe,Iteration = target.CFrame, 10 --- Where the part spawns and how much it expands outwards
	
	local Angeled360 = 360 / Amount
	
	local RockModel = Instance.new("Model", workspace)
	Debris:AddItem(RockModel, RocksLength + .25)
	for Index = 1, Amount do
		--// Calculations
		local SizeCalc = math.sin(math.pi / Amount) * Iteration * 2 * 1.01
		local PositionCalc = Cframe * CFrame.Angles(0, math.rad(Index * Angeled360), 0) * CFrame.new(0, 0, Iteration) * CFrame.Angles(math.rad(45), 0, 0)
		local YAndZ = Max * math.random(50, 120) / 100
		local RandomizedForCalc = 5 + Max * 2
		local RaycastToSet = CFrame.new(PositionCalc.Position) * CFrame.new(0, RandomizedForCalc, 0)
		local Target, Position, Surface = workspace:FindPartOnRayWithWhitelist(Ray.new(RaycastToSet.p, RaycastToSet.upVector * (-RandomizedForCalc * 2)), { workspace.World.Map,})

		local InstancedPart = script.Part:Clone()
		InstancedPart.CanCollide = false
		InstancedPart.Size = Vector3.new(SizeCalc, YAndZ, YAndZ)

		if Target then
			InstancedPart.Color = Target.Color
			InstancedPart.Material = Target.Material
			local Mult = 1
			if Position.Y < PositionCalc.Position.Y then
				Mult = -1
			end
			local MagZX = PositionCalc * CFrame.new(0, (PositionCalc.Position - Position).Magnitude * Mult, 0)
			local ToReturn = CFrame.new(Position, Position + Surface) * CFrame.Angles(math.rad(90), 0, 0)

			InstancedPart.CFrame = Cframe * CFrame.Angles(0, math.rad(Index * Angeled360), 0) * CFrame.new(0, 0, Iteration / 2)
			InstancedPart.Parent = RockModel
			local X, Y, Z = Cframe:components()

			local Ax, Ay, Az, A1, A2, A3, A4, A5, A6, A7, A8, A9 = ToReturn:components()

			local Tween = ts:Create(InstancedPart,TweenInfo.new(FirstDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out,0,false,0), {CFrame = CFrame.new(ToReturn.Position, CFrame.new(X, Y, Z, A1, A2, A3, A4, A5, A6, A7, A8, A9).Position) * CFrame.Angles(math.rad(math.random(20, 50)), 0, 0)})
			Tween:Play()
			Tween:Destroy()

			coroutine.resume(coroutine.create(function()
				wait(RocksLength)
				if InstancedPart then
					local Tween = ts:Create(InstancedPart.Mesh,TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out,0,false,0), {["Scale"] = Vector3.new(1, 0, 0)})
					Tween:Play()
					Tween:Destroy()

					local Tween = ts:Create(InstancedPart,TweenInfo.new(.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out,0,false,0), {CFrame = InstancedPart.CFrame * CFrame.new(0, -Max * 1.25, 0)})
					Tween:Play()
					Tween:Destroy()
				end
			end))
		else
			InstancedPart:Destroy()
		end
	end
	
end

--]]

return DebrisModule
