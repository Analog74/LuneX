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

-- Variables
local SlashCombo = 0

local Debounce = false

local Angles = {
	Slash1 = {Vector3.new(0, 0, 180), 0.35, -7},
	Slash2 = {Vector3.new(0, 0, 25), 0.35, -7},
	Slash3 = {Vector3.new(0, 0, 0), 0.35, -7},
	Slash4 = {Vector3.new(90, 90, 0), 0.35, -8}
}

local Animations = {
	Animator:LoadAnimation(Replicated.Assets.Animations.Slash1),
	Animator:LoadAnimation(Replicated.Assets.Animations.Slash2),
	Animator:LoadAnimation(Replicated.Assets.Animations.Slash3)
}

UIS.InputBegan:Connect(function(Input)
	if UIS:GetFocusedTextBox() then return end
	
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		if not Debounce then Debounce = true
			SlashCombo += 1
			if SlashCombo > 3 then SlashCombo = 1 end
			Animations[SlashCombo]:Play()
			
			local Sound = Instance.new('Sound')
			Sound.SoundId = 'rbxassetid://8270985214'
			Sound.Volume = 1
			Sound.PlaybackSpeed = Random.new():NextNumber(1, 1.5)
			Sound.Parent = workspace
			Sound:Play()
			game:GetService('Debris'):AddItem(Sound, 0.75)
			
			local Slash = Replicated.Assets.Meshes.Slash:Clone()
			local Slash1 = Slash:Clone()
			Slash1.PointLight:Destroy()
			Slash1.Mesh.Scale = Vector3.new(6.5, 5, 6.5)
			Slash1.Decal.Color3 = Color3.fromRGB(191, 229, 255)
			Slash1.Decal.Transparency = 0.9875
			TweenService:Create(Slash.Mesh, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = Vector3.new(10, 3, 10)}):Play()
			TweenService:Create(Slash1.Mesh, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = Vector3.new(21.5, 5, 21.5)}):Play()

			if SlashCombo == 4 then
				Slash.CFrame = RootPart.CFrame * CFrame.new(0, 0, 2)
			else
				Slash1.CFrame = RootPart.CFrame * CFrame.new(0, 1, -3.5)
				Slash.CFrame = RootPart.CFrame * CFrame.new(0, 1, -3.5)
			end
			
			Slash1.Orientation = Angles['Slash'..SlashCombo][1]
			Slash1.Parent = workspace
			
			Slash.Orientation = Angles['Slash'..SlashCombo][1]
			Slash.Parent = workspace
			Slash.PointLight.Brightness = 0
			TweenService:Create(Slash.PointLight, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Range = 20}):Play()

			local Textures = {
				'rbxassetid://8270829583', 'rbxassetid://8270824395', 'rbxassetid://8270837716', 'rbxassetid://8270884060', 'rbxassetid://8269486363', 'rbxassetid://8270697808', 'rbxassetid://8270698617', 'rbxassetid://8270699922', 'rbxassetid://8270701120', 'rbxassetid://8270702789', 'rbxassetid://8270703923', 'rbxassetid://8270705225', 'rbxassetid://8270706162', 'rbxassetid://8270707062', 'rbxassetid://8270708145', 'rbxassetid://8270709580', '' 
			}
			
			coroutine.wrap(function()
				task.wait(0.1)
				Debounce = false
			end)()
			
			for i, v in ipairs(Textures) do
				Slash.CFrame = Slash.CFrame * CFrame.Angles(0, math.rad(Angles['Slash'..SlashCombo][3]), 0)
				Slash1.CFrame = Slash1.CFrame * CFrame.Angles(0, (math.rad(Angles['Slash'..SlashCombo][3]) * 1.2), 0)

				Slash.Decal.Texture = v
				Slash1.Decal.Texture = v
				task.wait(0.02375)
			end
			TweenService:Create(Slash.PointLight, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Brightness = 0}):Play()
			
			game:GetService('Debris'):AddItem(Slash, 0.35)
		end
	end
end)