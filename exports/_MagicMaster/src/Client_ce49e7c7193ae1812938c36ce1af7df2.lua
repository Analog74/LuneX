-- Services
local Camera = workspace.CurrentCamera

local Players = game:GetService('Players')
local Replicated = game:GetService('ReplicatedStorage')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')

local UIS = game:GetService('UserInputService')

-- Character
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild('Humanoid')
local Animator = Humanoid:WaitForChild('Animator')
local RootPart = Character:WaitForChild('HumanoidRootPart')

local Mouse = Player:GetMouse()

-- Assets
local Assets = Replicated.Assets
local Remote = Assets.Remotes.Ability

-- Variables
local Pressed = true
local CreateVel = require(Replicated.Modules.Shared.Velocity)

UIS.InputBegan:Connect(function(Input)
	if UIS:GetFocusedTextBox() then return end

	if Input.KeyCode == Enum.KeyCode.ButtonX then
		Remote:FireServer('Lightning', Mouse.Hit)
	end
end)


UIS.InputBegan:Connect(function(Input)
	if UIS:GetFocusedTextBox() then return end

	if Input.KeyCode == Enum.KeyCode.ButtonY then
		Remote:FireServer('Amber', Mouse.Hit)
	end
end)
workspace.Effects.ChildAdded:Connect(function(Child)
	if Child.Name == 'AmberServer' then
		local Connection

		local Start = Assets.Particles.Amber.AmberStart:Clone()
		Start.Position = Child.Position
		Start.Parent = workspace.Effects
		Start.Attachment.Gradient:Emit(1)
		game:GetService('Debris'):AddItem(Start, 0.65)

		local Arrow = Assets.Meshes.Amber.Arrow:Clone()
		Arrow.Size = Vector3.new(0.85, 0.85, 1)
		Arrow.CFrame = Child.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
		Arrow.Parent = workspace.Effects
		TweenService:Create(Arrow, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(0.75, 0.75, 5)}):Play()

		Connection = RunService.Heartbeat:Connect(function()
			if Child.Parent then
				TweenService:Create(Arrow, TweenInfo.new(0.005, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Position = Child.Position}):Play()
			else
				TweenService:Create(Arrow, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = Arrow.CFrame * CFrame.new(0, 0, -10)}):Play()

				Arrow.Specs.Enabled = false

				game:GetService('Debris'):AddItem(Arrow, 1)
				Connection:Disconnect()
				return
			end
		end)
	end
end)



----------Spell

UIS.InputBegan:Connect(function(Input)
	if UIS:GetFocusedTextBox() then return end

	if Input.KeyCode == Enum.KeyCode.ButtonR2 then
		Remote:FireServer('Ice', Mouse.Hit)
	end
end)

workspace.Effects.ChildAdded:Connect(function(Child)
	if Child.Name == 'IceServer' then
		local Connection

		local Ice = Assets.Particles.Ice.Ice:Clone()
		Ice.CFrame = Child.CFrame
		Ice.Parent = workspace.Effects

		Connection = RunService.RenderStepped:Connect(function()
			if Child.Parent then
				TweenService:Create(Ice, TweenInfo.new(0.0055, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = Child.CFrame}):Play()
			else
				Ice:Destroy()
				Connection:Disconnect()
				return
			end
		end)
	end
end)



------------------Spell
UIS.InputBegan:Connect(function(Input)
	if UIS:GetFocusedTextBox() then return end

	if Input.KeyCode == Enum.KeyCode.ButtonB then
		Remote:FireServer('Xinyan')
	end
end)

------------------Spell
UIS.InputBegan:Connect(function(Input)
	if UIS:GetFocusedTextBox() then return end

	if Input.KeyCode == Enum.KeyCode.One then
		-- if you wanna make this work on your map, just do simple raycasting and replace 0 with 
		-- raycast y position.
		local Position = Vector3.new(Mouse.Hit.Position.X, 0, Mouse.Hit.Position.Z)
		Remote:FireServer('Birdcage', Position)
	end
end)


------------------Spell

UIS.InputBegan:Connect(function(Input)
	if UIS:GetFocusedTextBox() then return end

	if Input.KeyCode == Enum.KeyCode.ButtonL2 then
		Remote:FireServer('Ayaka')
	end
end)



local function TweenValue(Start, Time, End, Object)
	local NumValue = Instance.new('NumberValue')
	NumValue.Value = Start
	TweenService:Create(NumValue, TweenInfo.new(Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Value = End}):Play()
	game:GetService('Debris'):AddItem(NumValue, Time)

	if Object then
		NumValue.Changed:Connect(function(New)
			Object.Size = NumberSequence.new(New)
		end)
	end

	return NumValue
end

workspace.Effects.ChildAdded:Connect(function(Child)
	if Child.Name == 'AyakaServer' then
		local Connection

		local Ayaka = Assets.Particles.Ayaka.Ayaka:Clone()
		Ayaka.CFrame = Child.CFrame
		Ayaka.Parent = workspace.Effects

		task.spawn(function()
			while Child.Parent do
				Ayaka.Rot.Orientation = Vector3.new(0, 0, math.random(-360, 360))
				Ayaka.Rot.Shards:Emit(35)
				task.wait(Random.new():NextNumber(0.125, 0.15))
			end
		end)

		Connection = RunService.Heartbeat:Connect(function()
			if Child.Parent then
				TweenService:Create(Ayaka, TweenInfo.new(0.005, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {CFrame = Child.CFrame}):Play()
			else
				Connection:Disconnect()

				local Val = TweenValue(3, 0.135, 20)
				TweenService:Create(Ayaka.Attachment.PointLight, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Range = 35}):Play()

				Ayaka.Attachment.Smoke.Enabled = false
				Ayaka.Attachment.Specs.Enabled = false
				Ayaka.Attachment.Main.Enabled = false
				Ayaka.Attachment.Wind.Enabled = false
				Ayaka.Attachment.Vortex.Enabled = false

				Ayaka.Hit.Spark:Emit(1)
				Ayaka.Hit.Gradient:Emit(1)
				Ayaka.Hit.Snowflake:Emit(7)
				Ayaka.Hit.Shards:Emit(20)
				Ayaka.Hit.Specs:Emit(25)
				Ayaka.Hit.Smoke:Emit(80)

				Val.Changed:Connect(function(New)
					Ayaka.Attachment.Main.Size = NumberSequence.new({Ayaka.Attachment.Main.Size.Keypoints[1], NumberSequenceKeypoint.new(1, New)})
					Ayaka.Attachment.Wind.Size = NumberSequence.new({Ayaka.Attachment.Main.Size.Keypoints[1], NumberSequenceKeypoint.new(1, (New * 1.35))})
				end)

				task.wait(0.35)
				TweenService:Create(Ayaka.Attachment.PointLight, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Brightness = 0}):Play()
				game:GetService('Debris'):AddItem(Ayaka, 2)
				return
			end
		end)
	end
end)
