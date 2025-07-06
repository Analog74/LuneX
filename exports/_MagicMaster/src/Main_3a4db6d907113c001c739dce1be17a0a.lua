-- Services
local Replicated = game:GetService('ReplicatedStorage')

-- Assets
local Assets = Replicated.Assets
local Remote = Assets.Remotes.Ability
local FXRemote = Assets.Remotes.FX

-- Modules
local Hitbox = require(script.Hitbox)
local MockPart = require(Replicated.Modules.Shared.MockPart)
local Bezier = require(Replicated.Modules.Shared.Bezier)

Remote.OnServerEvent:Connect(function(Player, Input, ...)
	local Character = Player.Character
	local RootPart = Character.HumanoidRootPart
	local Humanoid = Character.Humanoid
	
	local Parameters = {...}
		
	if Input == 'Lightning' then
		FXRemote:FireAllClients('Lightning', Parameters[1])
	end
	
	
	--------Next Ability		
	
	
	
	if Input == 'Amber' then
		local Circle = Assets.Meshes.Amber.AmberCircle:Clone()
		Circle.CFrame = CFrame.new(Parameters[1].X, 0, Parameters[1].Z)
		Circle.Size = Vector3.new(75, 0.001, 75)
		Circle.Decal.Transparency = 1
		Circle.Parent = workspace.Effects
		Circle.Attachment.Gradient:Emit(1)

		task.wait(0.5)

		game:GetService('TweenService'):Create(Circle.Decal, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0}):Play()
		game:GetService('TweenService'):Create(Circle, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {Orientation = Circle.Orientation + Vector3.new(0, 360, 0)}):Play()

		task.wait(0.75)

		for _ = 1, 15 do
			coroutine.wrap(function()
				local Part = MockPart.new(CFrame.new(Parameters[1].X, 38.5, Parameters[1].Z) * CFrame.new(math.random(-13.5, 13.5), 0, math.random(-13.5, 13.5)))
				Part.Name = 'AmberServer'

				for k = 0, 1, 0.00275 do
					Part.CFrame = Part.CFrame:Lerp(Part.CFrame * CFrame.new(0, -40, 0), k)

					local Hit = Hitbox:Start(Part.Position, Part.CFrame.UpVector * 1.5, {Character, Part})

					if Hit then
						FXRemote:FireAllClients('AmberHit', Hit.Position)
						Part:Destroy()
						break
					end

					task.wait(0.01)
				end
			end)()

			task.wait(0.185)
		end

		task.wait(0.5)
		game:GetService('TweenService'):Create(Circle.Decal, TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1}):Play()
		game:GetService('TweenService'):Create(Circle.PointLight, TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Brightness = 0}):Play()
		game:GetService('Debris'):AddItem(Circle, 1)
	end
	
	
--------Next Ability	
	
	
	if Input == 'Ayaka' then
		local Offset = {
			-35,
			0,
			35
		}

		local Charge = Assets.Particles.Ayaka.AyakaCharge.Attachment:Clone()
		Charge.Parent = RootPart

		Charge.Outline:Emit(3)
		Charge.Gradient:Emit(1)
		Charge.Snowflakes:Emit(10)
		game:GetService('Debris'):AddItem(Charge, 1)

		for _, v in ipairs(Offset) do
			task.spawn(function()
				local Part = MockPart.new(RootPart.CFrame * CFrame.new(v / 3, 0, 0))
				Part.Name = 'AyakaServer'

				local StartPos = Part.CFrame
				local EndPos = Part.CFrame * CFrame.new(v, 3.5, -32.5)
				local Distance = (StartPos.Position - EndPos.Position).Magnitude

				task.spawn(function()
					for i = 0, Distance, 0.125 do
						local Progress = i / Distance
						EndPos = EndPos * CFrame.new(0, 0, -0.225)

						Part.CFrame = Part.CFrame:Lerp(EndPos, Progress)

						if i >= 12 then
							break
						end

						task.wait()
					end

					FXRemote:FireAllClients('Ayaka', Part)
					Part:Destroy()
				end)
			end)
		end
	end
	
	-------------------Next Ability
	
	if Input == 'Ice' then
		for k = 1, 3 do
			task.spawn(function()
				local Connection
				local Elapsed = 0

				local Angles = {
					CFrame.new(math.random(20, 30), 0, 0),
					CFrame.new(math.random(-30, -20), 0, 0),
					CFrame.new(0, math.random(20, 30), 0)
				}

				local Part = MockPart.new(RootPart.CFrame)
				Part.Name = 'IceServer'

				local Start = Part.CFrame
				local End = Parameters[1]
				local Distance = (Start.Position - End.Position).Magnitude
				local Midpoint = (Start:Lerp(End, 0.5) * Angles[k]).Position

				Connection = game:GetService('RunService').Heartbeat:Connect(function(Delta)
					Elapsed += Delta

					local Time = Elapsed / 2.5
					local Curve = Bezier.QuadBezier(Elapsed, Start.Position, Midpoint, End.Position)

					local Hit = Hitbox:Start(Part.Position, Part.CFrame.LookVector * 5, {Character, Part, workspace.Effects})

					if Hit then
						FXRemote:FireAllClients('IceHit', Part.Position)
						Part:Destroy()
						Connection:Disconnect()
					end

					if (Elapsed >= 1) then
						Part.Position = End.Position
						FXRemote:FireAllClients('IceHit', Part.Position)
						Part:Destroy()
						Connection:Disconnect()
					else
						Part.Position = Curve
					end
				end)
			end)

			task.wait(0.1)
		end
	end

	
-----------------Next Ability

if Input == 'Xinyan' then
	FXRemote:FireAllClients('Xinyan', RootPart)
	end
	
	
	
	
	
	
	
	--End of Module
end)
