local Ice = {}

local RS = game:GetService("ReplicatedStorage")
local Modules = RS:WaitForChild("Modules")
local Remotes = RS:WaitForChild("Remotes")

local TweenService = game:GetService("TweenService")
local combatMod = require(Modules:WaitForChild("CombatModule"))
local BezierTween = require(Modules:WaitForChild("BezierTweens"))
local Waypoints = BezierTween.Waypoints

local cs = game:GetService("CollectionService")
local PS = game:GetService("PhysicsService")

local Cache = RS:WaitForChild("Cache")

local treeRespawnTime = 10

local ZStunDuration = 3

local raycastHitbox = require(Modules:WaitForChild("RaycastHitboxV4"))

function lerp(p0, p1, t)
	return p0 * (1-t) + p1*t
end

function quad(p0, p1, p2, t)
	local l1 = lerp(p0, p1, t)
	local l2 = lerp(p1, p2, t)
	local quad = lerp(l1, l2, t)
	return quad
end

function quadBezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2
end

Ice.XSkill = function(humRP, damage, mouseHit)

	local xTag = humRP.Parent.Name.." IceXTag"

	local projectilesSpawnCF = {
		["1"] = humRP.CFrame * CFrame.new(4, 1, 0);
		["2"] = humRP.CFrame * CFrame.new(-4, 1, 0);
		["3"] = humRP.CFrame * CFrame.new(2, 3, 0);
		["4"] = humRP.CFrame * CFrame.new(-2, 3, 0);
		["5"] = humRP.CFrame * CFrame.new(0, 5, 0);
	}

	local fxFolder = script:WaitForChild("FX")
	local sounds = script:WaitForChild("Sounds")

	local startSound = sounds:WaitForChild("Ice")
	local gainSound = sounds:WaitForChild("Gain")

	local folder = Instance.new("Folder")
	folder.Name = humRP.Parent.Name.." IceProjectilesFX"

	local char = humRP.Parent
	local humanoid = char:FindFirstChild("Humanoid")

	local iceCube = fxFolder:FindFirstChild("IceCube")

	local current = 0

	local function GetTouchingParts(part)
		local connection = part.Touched:Connect(function() end)
		local results = part:GetTouchingParts()
		connection:Disconnect()
		return results
	end

	folder.Parent = workspace

	for i, v in pairs(script:FindFirstChild("XHits"):GetChildren()) do

		local hitbox = v:Clone()
		hitbox.CFrame = projectilesSpawnCF[tostring(hitbox.Name)]
		hitbox.CFrame = CFrame.lookAt(hitbox.Position, mouseHit.Position)
		hitbox.Size = Vector3.new(0, 0, 1)

		local iceProj = hitbox:FindFirstChild("Ice")
		local neonProj = hitbox:FindFirstChild("Neon")

		iceProj.Size = Vector3.new(0,0,0)
		neonProj.Size = Vector3.new(0,0,0)

		local iceSize = Vector3.new(0.602, 4.439, 0.665)
		local neonSize = Vector3.new(0.618, 4.629, 0.683)

		local iceArgs = {Size = iceSize}
		local neonArgs = {Size = neonSize}

		hitbox.Parent = folder

		local sizeInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad)

		local otherInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad)

		local sizeArgs = {Size = Vector3.new(1.5, 1.5, 4)}
		local t = TweenService:Create(hitbox, sizeInfo, sizeArgs)
		local t2 = TweenService:Create(neonProj, otherInfo, neonArgs)
		local t3 = TweenService:Create(iceProj, otherInfo, iceArgs)

		t:Play()
		t2:Play()
		t3:Play()

		current += 1
		print(current)

		task.delay(.002, function()
			local p0 = hitbox.Position
			local p2 = mouseHit.Position
			local p1 = Vector3.new(hitbox.Position.X + math.random(-2, 2), hitbox.Position.Y + math.random(-2, 2), 0)--(hitbox.Position.Z - p2.Z)) --(hitbox.CFrame * CFrame.new(3, 5, -10)).p

			local Speed = 200
			local Duration = (p0 - p2).Magnitude / Speed

			local projTween = TweenService:Create(hitbox, TweenInfo.new(Duration), {Position = p2}) --CFrame = CFrame.lookAt(hitbox.Position, p2)
			projTween:Play()
			
			hitbox.Shot.Ring:Emit(25)
			hitbox.Wind.Transparency = 0.3

			local HB = raycastHitbox.new(hitbox)

			HB.RaycastParams = RaycastParams.new()
			HB.RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
			HB.RaycastParams.FilterDescendantsInstances = {char, folder}

			HB.DetectionMode = raycastHitbox.DetectionMode.PartMode

			local alrHit = false

			HB.OnHit:Connect(function(hit)
				local ehum = hit.Parent:FindFirstChild("Humanoid")
				alrHit = true
				if not ehum then

					local fx = RS:FindFirstChild("FX")
					if fx then

						local tempPart = Instance.new("Part")
						tempPart.Transparency = 1
						tempPart.Anchored = true
						tempPart.CanCollide = false
						tempPart.CFrame = hitbox.CFrame
						tempPart.Parent = folder

						local hitFX = fx.IceArrowHit.Hit:Clone()
						hitFX.Parent = tempPart

						local hitSFX = sounds:FindFirstChild("IceHit"):Clone()
						hitSFX.Parent = hitFX
						hitSFX:Play()

						for hitEffects, effect in pairs(hitFX:GetChildren()) do
							if effect:IsA("ParticleEmitter") then
								effect:Emit(math.random(15, 25))
							end
						end

						game.Debris:AddItem(tempPart, 3)

					end

					if hitbox then
						hitbox:Destroy()
					end
				else

					local fx = RS:FindFirstChild("FX")
					if fx then

						local hitFX = fx.IceArrowHit.Hit:Clone()
						hitFX.Parent = ehum.Parent.HumanoidRootPart

						local hitSFX = sounds:FindFirstChild("IceHit"):Clone()
						hitSFX.Parent = hitFX
						hitSFX:Play()

						for hitEffects, effect in pairs(hitFX:GetChildren()) do
							for hitEffects, effect in pairs(hitFX:GetChildren()) do
								if effect:IsA("ParticleEmitter") then
									effect:Emit(math.random(15, 25))
								end
							end
						end

						game.Debris:AddItem(hitFX, 3)

					end

					ehum:TakeDamage(damage)

					combatMod.StrongKnockback(ehum.Parent.HumanoidRootPart, 5, 15, 0.2, hitbox)
					combatMod.UpKnockback(ehum.Parent.HumanoidRootPart, 20, 45, 0.2, hitbox)

					if hitbox then
						hitbox:Destroy()
					end
				end
			end)

			HB:HitStart(3)

			task.delay(3, function()
				if hitbox then
					hitbox:Destroy()
				end
			end)


			while not alrHit do
				if hitbox.Position == p2 or (hitbox.Position - p2).Magnitude < 2 then
					local overlapParams = OverlapParams.new()
					overlapParams.FilterType = Enum.RaycastFilterType.Blacklist
					overlapParams.FilterDescendantsInstances = {char, folder}

					local region = workspace:GetPartBoundsInBox(hitbox.CFrame, hitbox.Size * 3, overlapParams)
					for a, b in pairs(region) do
						local ehum = b.Parent:FindFirstChild("Humanoid")
						if ehum then
							ehum:TakeDamage(damage)
						end
					end

					local fx = RS:FindFirstChild("FX")
					if fx then

						local tempPart = Instance.new("Part")
						tempPart.Transparency = 1
						tempPart.Anchored = true
						tempPart.CanCollide = false
						tempPart.CFrame = hitbox.CFrame
						tempPart.Parent = folder


						local hitFX = fx.IceArrowHit.Hit:Clone()
						hitFX.Parent = tempPart

						local hitSFX = sounds:FindFirstChild("IceHit"):Clone()
						hitSFX.Parent = hitFX
						hitSFX:Play()

						for hitEffects, effect in pairs(hitFX:GetChildren()) do
							for hitEffects, effect in pairs(hitFX:GetChildren()) do
								if effect:IsA("ParticleEmitter") then
									effect:Emit(math.random(15, 25))
								end
							end
						end

						game.Debris:AddItem(tempPart, 3)

					end

					if hitbox then
						hitbox:Destroy()
					end
					alrHit = true
				end
				task.wait(0.01)
			end	
		end)

		task.wait(0.15)
	end	
end

Ice.ZSkill = function(humRP, damage)	

	local zTag = humRP.Parent.Name.." IceZTag"

	humRP.Anchored = true
	local icePositions = {
		["Floor"] = humRP.CFrame * CFrame.new(0, -2.7, -18) * CFrame.Angles(0, math.rad(-180), 0);
		["1"] = humRP.CFrame * CFrame.new(0, -2, -8) * CFrame.Angles(0, math.rad(-180), 0);
		["2"] = humRP.CFrame * CFrame.new(5, -1.5, -10) * CFrame.Angles(0, math.rad(-180), 0);
		["3"] = humRP.CFrame * CFrame.new(-4.5, -1.5, -12) * CFrame.Angles(0, math.rad(-180), 0);
		["4"] = humRP.CFrame * CFrame.new(-6, -1, -17) * CFrame.Angles(0, math.rad(-180), 0);
		["5"] = humRP.CFrame * CFrame.new(1, -1, -16) * CFrame.Angles(0, math.rad(-180), 0);
		["6"] = humRP.CFrame * CFrame.new(7, -1, -16) * CFrame.Angles(0, math.rad(-180), 0);
		["7"] = humRP.CFrame * CFrame.new(1, 1.5, -29) * CFrame.Angles(0, math.rad(-180), 0);
		["8"] = humRP.CFrame * CFrame.new(-4, 0, -26) * CFrame.Angles(0, math.rad(-180), 0);
		["9"] = humRP.CFrame * CFrame.new(6.5, -0.50, -24) * CFrame.Angles(0, math.rad(-180), 0);
	}

	local iceSizes = {
		["Floor"] = Vector3.new(26.182, 0.649, 37.233);
		["1"] = Vector3.new(6.724, 16.858, 17.402);
		["2"] = Vector3.new(12.212, 13.472, 17.385);
		["3"] = Vector3.new(9.328, 13.508, 18.59);
		["4"] = Vector3.new(10.04, 14.54, 20.01);
		["5"] = Vector3.new(9.072, 22.747, 23.481);
		["6"] = Vector3.new(13.145, 14.501, 18.713);
		["7"] = Vector3.new(7.237, 18.146, 18.731);
		["8"] = Vector3.new(11.578, 16.767, 23.074);
		["9"] = Vector3.new(15.158, 16.722, 21.579);
	}

	local fxFolder = script:WaitForChild("FX")
	local sounds = script:WaitForChild("Sounds")

	local startSound = sounds:WaitForChild("Ice")
	local gainSound = sounds:WaitForChild("Gain")

	local folder = Instance.new("Folder")
	folder.Name = humRP.Parent.Name.." IceSpikesFX"

	local char = humRP.Parent
	local humanoid = char:FindFirstChild("Humanoid")

	local iceFloor = fxFolder:FindFirstChild("Floor")
	local spikes = fxFolder.Spikes:GetChildren()
	local iceCube = fxFolder:FindFirstChild("IceCube")

	for i, y in pairs(spikes) do
		local x = y:Clone()
		x.Parent = folder
	end

	local function removalFX(Target)
		local bigCircle = fxFolder:FindFirstChild("BigCircle"):Clone()
		local Balls = fxFolder:FindFirstChild("Balls"):Clone()
		local Lines = fxFolder:FindFirstChild("Lines"):Clone()

		local attachment = Instance.new("Attachment")

		bigCircle.Parent = attachment
		Balls.Parent = Target
		Lines.Parent = Target

		attachment.Parent = Target

		Balls:Emit(30)
		Lines:Emit(20)

		delay(1.5, function()
			attachment:Destroy()
			Balls:Destroy()
			Lines:Destroy()
		end)
	end

	local function neonFlash(Target, originalMaterial, OriginalBrickColor)

		delay(0.05, function()
			local sfxStart = sounds:FindFirstChild("DebrisStart"):Clone()
			sfxStart.Parent = Target
			sfxStart:Play()

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

	local zHitbox = script:WaitForChild("ZHitbox"):Clone()
	zHitbox.Transparency = 1
	zHitbox.CFrame = humRP.CFrame * CFrame.new(0.5, -0.50, -21)

	local icefloorClone = iceFloor:Clone()
	icefloorClone.Size = Vector3.new(0.05,0.05,0.05)
	icefloorClone.Parent = folder

	local Animations = script:WaitForChild("Animations")
	local stompAnimation = humanoid:LoadAnimation(Animations:FindFirstChild("Spikes"))
	stompAnimation:AdjustSpeed(1.5)
	stompAnimation:Play()


	delay(1, function()
		humRP.Anchored = false
	end)

	delay(0.5, function()
		local sound = startSound:Clone()
		sound.Parent = icefloorClone
		sound:Play()

		delay(0.1, function()
			local sound2 = gainSound:Clone()
			sound2.Parent = icefloorClone
			sound2:Play()

			local min = zHitbox.Position - (0.5 * zHitbox.Size)
			local max = zHitbox.Position + (0.5 * zHitbox.Size)
			local region = Region3.new(min, max)
			local ignoreList = workspace:FindPartsInRegion3(region, zHitbox) --  ignore part

			for i, hit in pairs(game.Workspace:FindPartsInRegion3(region, nil, math.huge)) do
				local ehum = hit.Parent:FindFirstChildOfClass("Humanoid")
				if not ehum and not cs:HasTag(hit.Parent, zTag) then
					--print("Hit something with no humanoid")
					if cs:HasTag(hit.Parent, "Tree") or cs:HasTag(hit.Parent, "Bush") then
						local tag

						local target = hit.Parent
						if cs:HasTag(target, "Tree") then
							tag = "Tree"
							cs:RemoveTag(target, tag)
						elseif cs:HasTag(target, "Bush") then
							tag = "Bush"
							cs:RemoveTag(target, tag)
						end

						local Clone = target:Clone()
						Clone.Parent = Cache

						delay(treeRespawnTime, function()
							local function neonFlashSpawning(Target, originalMaterial, OriginalBrickColor)

								delay(0.05, function()
									local sfxStart = sounds:FindFirstChild("DebrisStart"):Clone()
									sfxStart.Volume = 0.07
									sfxStart.Parent = Target
									sfxStart:Play()

									Target.Material = Enum.Material.Neon
									Target.BrickColor = BrickColor.new("Shamrock")
									wait(0.05)
									Target.Material = originalMaterial
									Target.BrickColor = OriginalBrickColor

									delay(0.1, function()
										Target.Material = Enum.Material.Neon
										Target.BrickColor = BrickColor.new("Shamrock")
										wait(0.05)
										Target.Material = originalMaterial
										Target.BrickColor = OriginalBrickColor

										delay(0.1, function()
											Target.Material = Enum.Material.Neon
											Target.BrickColor = BrickColor.new("Shamrock")
											wait(0.05)
											Target.Material = originalMaterial
											Target.BrickColor = OriginalBrickColor
											delay(0.1, function()
												Target.Material = Enum.Material.Neon
												Target.BrickColor = BrickColor.new("Shamrock")
												wait(0.05)
												Target.Material = originalMaterial
												Target.BrickColor = OriginalBrickColor
											end)
										end)
									end)
								end)
							end

							for i, v in pairs(Clone:GetChildren()) do
								local originalSize = Instance.new("Vector3Value")
								originalSize.Value = v.Size
								originalSize.Parent = v

								game.Debris:AddItem(originalSize, 1)

								local args = {
									Size = originalSize.Value;
									Transparency = 0
								}

								local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.In)

								v.Size = Vector3.new(0.05, 0.05, 0.05)
								v.Transparency = 1

								if Clone.Parent ~= workspace then
									Clone.Parent = workspace
									cs:AddTag(Clone, tag)
								end

								local tween = TweenService:Create(v, tweenInfo, args):Play()

								neonFlashSpawning(v, v.Material, v.BrickColor)

								delay(0.45, function()
									local endSfx = sounds:FindFirstChild("Pop"):Clone()
									endSfx.Parent = v
									endSfx:Play()
								end)
							end
						end)

						cs:AddTag(target, zTag)

						if hit.Name == "Log" then
							local sfx = sounds:FindFirstChild("FallingTree"):Clone()
							sfx.Parent = hit
							sfx:Play()
						end

						local args = {
							Size = Vector3.new(0.005, 0.005, 0.005);
							Transparency = 1
						}

						local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.In)

						game.Debris:AddItem(target, 8)

						for i, v in pairs(target:GetChildren()) do
							PS:SetPartCollisionGroup(v, "Debris")

							if v:FindFirstChildWhichIsA("Weld") then
								v:FindFirstChildWhichIsA("Weld"):Destroy()
							end

							combatMod.StrongKnockback(v, 40, 65, 0.2, zHitbox)
							combatMod.UpKnockback(v, 40, 65, 0.1, zHitbox)

							v.Anchored = false
							v.CanCollide = true

							local breakFX = fxFolder:FindFirstChild("Break"):Clone()
							breakFX.Color = ColorSequence.new(v.Color)
							breakFX.Parent = v
							breakFX:Emit(40)

							delay(5, function()
								v.Anchored = true
								local tween = TweenService:Create(v, tweenInfo, args)
								tween:Play()
								delay(0.45, function()
									removalFX(v)
									local endSfx = sounds:FindFirstChild("Pop"):Clone()
									endSfx.Parent = v
									endSfx:Play()
								end)
								neonFlash(v, v.Material, v.BrickColor)
							end)
						end
					end

				elseif ehum and not cs:HasTag(hit.Parent, zTag) and hit.Parent ~= char then

					cs:AddTag(hit.Parent, zTag)

					delay(5, function()
						if cs:HasTag(hit.Parent, zTag) then
							cs:RemoveTag(hit.Parent, zTag)
						end
					end)

					local humanoid = hit.Parent:FindFirstChild("Humanoid")
					local ehumrp = hit.Parent:FindFirstChild("HumanoidRootPart")

					humanoid:TakeDamage(damage)

					local ice = iceCube:Clone()
					ice.BrickColor = BrickColor.new("Institutional white")
					ice.Transparency = 1
					ice.Parent = ehumrp

					local weld = Instance.new("Weld")
					weld.Parent = ehumrp
					weld.Part0 = ehumrp
					weld.Part1 = ice

					combatMod.Ragdoll(hit.Parent, ZStunDuration)

					game.Debris:AddItem(ice, ZStunDuration + 0.2)
					delay(ZStunDuration + 0.2, function()
						local iceBreakSFX = sounds:FindFirstChild("End"):Clone()
						iceBreakSFX.Parent = ehumrp
						iceBreakSFX:Play()

						game.Debris:AddItem(iceBreakSFX, 2.6)
					end)

					local iceCubeTween = TweenService:Create(ice, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 0.1})

					delay(0.25, function()
						ice.Material = Enum.Material.Glass
						ice.BrickColor = BrickColor.new("Pastel Blue")

						for i, v in pairs(ice:GetChildren()) do
							if v:IsA("Decal") then
								v.Transparency = 0
							end
						end
					end)

					iceCubeTween:Play()	

					delay(ZStunDuration - 0.3, function()
						for i, v in pairs(ice:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								v.Enabled = false
							end
						end
					end)

					delay(ZStunDuration - 0.3, function()
						ice.Material = Enum.Material.Neon

						ice.BrickColor = BrickColor.new("Institutional white")
						for i, v in pairs(ice:GetChildren()) do
							if v:IsA("Decal") then
								v.Transparency = 1
							end
						end
						local iceEndTween = TweenService:Create(ice, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
						iceEndTween:Play()
					end)

					combatMod.StrongKnockback(ehumrp, 50, 100, 0.3, zHitbox)
					combatMod.UpKnockback(ehumrp, 50, 150, 0.3, zHitbox)
				end
			end
		end)	

		folder.Parent = workspace

		icefloorClone.CFrame = icePositions[tostring(icefloorClone.Name)]

		local args = {
			Size = iceSizes["Floor"];
			CFrame = icePositions["Floor"];
		}

		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)
		local tween = TweenService:Create(icefloorClone, tweenInfo, args)
		tween:Play()

		local boom = icefloorClone.Boom
		boom:Emit(25)

		delay(0.3, function()
			icefloorClone.Material = Enum.Material.Ice
			icefloorClone.BrickColor = BrickColor.new("Baby blue")
			for i, x in pairs(icefloorClone:GetDescendants()) do
				if x:IsA("ParticleEmitter") and x.name ~= "Rings"  and x.Name ~= "Boom" then
					x.Enabled = true
				end
			end
		end)
		wait(0.05)
		for i, v in pairs(folder:GetDescendants()) do
			if v:IsA("MeshPart") and v.Name ~= "Floor" then
				if v.Name == "1" or v.Name == "2" or v.Name == "3" then

					wait(0.03)

					v.CFrame = icePositions[tostring(v.Name)]
					v.Position = v.Position - Vector3.new(0, 10, 0)

					local args = {
						CFrame = icePositions[v.Name];
						Transparency = 0;
					}

					local boom = v.Boom
					boom:Emit(25)

					local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					local tween = TweenService:Create(v, tweenInfo, args)
					tween:Play()	

					delay(0.12, function()
						v.BrickColor = BrickColor.new("Baby blue")
						v.Material = Enum.Material.Ice
						for i, x in pairs(v:GetDescendants()) do
							if x:IsA("ParticleEmitter") and x.name ~= "Rings" and x.Name ~= "Boom"  then
								x.Enabled = true
							end
						end
					end)
				end
			end
		end

		-----------------
		wait(0.025)
		-- SECOND LINE --

		for i, v in pairs(folder:GetDescendants()) do
			if v:IsA("MeshPart") and v.Name ~= "Floor" then
				if v.Name == "4" or v.Name == "5" or v.Name == "6" then

					wait(0.03)
					v.CFrame = icePositions[tostring(v.Name)]
					v.Position = v.Position - Vector3.new(0, 10, 0)

					local args = {
						CFrame = icePositions[v.Name];
						Transparency = 0;
					}



					local boom = v.Boom
					boom:Emit(25)

					local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)
					local tween = TweenService:Create(v, tweenInfo, args)
					tween:Play()

					delay(0.12, function()
						v.Material = Enum.Material.Ice
						v.BrickColor = BrickColor.new("Baby blue")
						for i, x in pairs(v:GetDescendants()) do
							if x:IsA("ParticleEmitter") and x.name ~= "Rings" and x.Name ~= "Boom" then
								x.Enabled = true
							end
						end
					end)
				end
			end
		end

		----------------
		wait(0.025)
		-- THIRD LINE --

		for i, v in pairs(folder:GetDescendants()) do
			if v:IsA("MeshPart") and v.Name ~= "Floor" then
				if v.Name == "7" or v.Name == "8" or v.Name == "9" then

					wait(0.03)
					v.CFrame = icePositions[tostring(v.Name)]
					v.Position = v.Position - Vector3.new(0, 10, 0)

					local args = {
						CFrame = icePositions[v.Name];
						Transparency = 0;
					}



					local boom = v.Boom
					boom:Emit(25)

					local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)
					local tween = TweenService:Create(v, tweenInfo, args)
					tween:Play()



					delay(0.12, function()
						v.Material = Enum.Material.Ice
						v.BrickColor = BrickColor.new("Baby blue")
						for i, x in pairs(v:GetDescendants()) do
							if x:IsA("ParticleEmitter") and x.Name ~= "Rings" and x.Name ~= "Boom" then
								x.Enabled = true
							end
						end
					end)
				end
			end
		end
	end)

	delay(1.25, function()
		zHitbox:Destroy()
		print("Hitbox destroyed!")
	end)

	delay(5, function()
		delay(0.15, function()
			local args = {
				Size = Vector3.new(0.05,0.05,0.05);
				Transparency = 1
			}

			local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local tween = TweenService:Create(icefloorClone, tweenInfo, args)
			tween:Play()

			local endSound = sounds:FindFirstChild("End"):Clone()
			endSound.Parent = icefloorClone
			endSound:Play()			

			icefloorClone.Material = Enum.Material.Neon
			icefloorClone.BrickColor = BrickColor.new("Institutional white")

			delay(0.5, function()
				for i, x in pairs(icefloorClone:GetDescendants()) do
					if x:IsA("ParticleEmitter") then
						x.Enabled = false
					end
				end
			end)
		end)

		for i, v in pairs(folder:GetDescendants()) do
			if v:IsA("MeshPart") and v.Name ~= "Floor" then

				local args = {
					Transparency = 1
				}

				local endSound = sounds:FindFirstChild("End"):Clone()
				endSound.Parent = v
				endSound:Play()

				local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				local tween = TweenService:Create(v, tweenInfo, args)
				tween:Play()

				v.Material = Enum.Material.Neon
				v.BrickColor = BrickColor.new("Institutional white")

				delay(0.15, function()
					for i, x in pairs(v:GetDescendants()) do
						if x:IsA("ParticleEmitter") then
							x.Enabled = false
						end
					end
				end)
			end
		end
	end)

	game.Debris:AddItem(folder, 10)
end

return Ice