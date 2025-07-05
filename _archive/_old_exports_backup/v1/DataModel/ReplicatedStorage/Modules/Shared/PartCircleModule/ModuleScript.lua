local module = {}
module.new = function (Humrp, ARG1, ARG2, distx,disty,distz, shapeinput, axis, raybool, time1)
	local axistable = {"Y", "y", "X", "x", "Z", "z"}
	local shapetable = {"Block", "Sphere", "Cylinder"}
	local function has_value (tab, val)
		for index, value in ipairs(tab) do
			if value == val then
				return true
			end
		end
		return false
	end
	local TS = game:GetService("TweenService")
	local rayparams = RaycastParams.new()
	rayparams.FilterType = Enum.RaycastFilterType.Blacklist
	local cfr = Humrp.CFrame * CFrame.new(Vector3.new(-distx, -disty, -distz))
	print(cfr)
	local shape
	if has_value(shapetable, shapeinput) then
		shape = shapeinput
		print("true")
	else 
		shape = "Block"
	end
	print(shape)
	local angle = 0
	local axis1 
	local raybool = raybool or true
	local time1 = time1 or 4
	if has_value(axistable, axis) then
		axis1 = axis
	else
		axis1 = "Y"
	end
	for i=0,15 do
		local size = math.random(ARG1, ARG2)
		local size2 = math.random(ARG1, ARG2)
		local size3 = math.random(ARG1, ARG2)
		local Rock
		if shapeinput ~= nil and type(shapeinput) ~= "string" then
			if shapeinput:IsA("BasePart") then
				Rock = shapeinput:Clone()
			end
		else 
			Rock = Instance.new("Part")
			Rock.Shape = Enum.PartType[shape]
		end
		Rock.Size = Vector3.new(size,size2,size3)
		Rock.Anchored = true
		if axis1 == "Z" or axis1 == "z" then
			Rock.CFrame = cfr * CFrame.fromEulerAnglesXYZ(math.rad(0),math.rad(0), math.rad(angle)) * CFrame.new(0,1,-5)
		elseif axis1 == "Y" or axis1 == "y" then
			Rock.CFrame = cfr * CFrame.fromEulerAnglesXYZ(math.rad(0),math.rad(angle), math.rad(0)) * CFrame.new(0,1,-5)
		elseif axis1 == "X" or axis1 == "x" then
			Rock.CFrame = cfr * CFrame.fromEulerAnglesXYZ(math.rad(angle),math.rad(0), math.rad(0)) * CFrame.new(0,1,-5)
		end
		
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
		
		local ray = workspace:Raycast(Rock.CFrame.p, Rock.CFrame.UpVector * -10000, rayparams)
		if ray then
			Rock.CFrame = Rock.CFrame * CFrame.new(0, -size + -1, 0)
			if raybool == false then
				Rock.Material = ray.Instance.Material
				Rock.Color = ray.Instance.Color
			end
			local rannum = math.random(-180,180)
			local rannum2 = math.random(-180,180)
			local rannum3 = math.random(-180,180)
			Rock.Orientation = Vector3.new(rannum,rannum2,rannum3)
			Rock.Parent = workspace
			task.delay(time1, function () 
				TS:Create(Rock, TweenInfo.new(0.5, Enum.EasingStyle.Elastic),{Size = Vector3.new(0,0,0)}):Play()
				neonFlash(Rock, Rock.Material, Rock.BrickColor)
				wait(0.5)
				Rock:Destroy()
			end)
		end
		angle += 24
	end
end
return module
