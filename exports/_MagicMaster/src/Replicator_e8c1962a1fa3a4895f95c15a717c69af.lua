-- Services
local Replicated = game:GetService('ReplicatedStorage')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')
local Debris = game:GetService('Debris')
local Players = game:GetService('Players')

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Assets
local Assets = Replicated.Assets
local Remote = Assets.Remotes.FX
local Modules = Replicated.Modules

-- Modules
local WindLines = require(Modules.WindLines)
local CameraModule = require(Modules.OTS)

WindLines:Init({})
--CameraModule:Enable()
--CameraModule:SetCharacterAlignment(true)

-- Datatypes
local ChargeInfo = TweenInfo.new(0.055, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

-- Auxiliary
local FindModule = function(ModuleName)
	local Module
	for _, v in ipairs(Replicated.Modules.Templates.Abilities:GetDescendants()) do
		if v:IsA('ModuleScript') and v.Name == ModuleName then
			Module = require(v)
		end
	end
	return Module
end

-- Remote event handler (FindModule version)
Remote.OnClientEvent:Connect(function(Module, ...)
	local FXModule = FindModule(Module)
	if FXModule then
		FXModule(...)
	else
		warn('Module does not exist in folder Templates!')
	end
end)

-- Remote event handler (FindFirstChild version, for compatibility)
Remote.OnClientEvent:Connect(function(Module, ...)
	local ModuleF = require(Replicated.Modules.Templates.Abilities:FindFirstChild(Module)) or warn('Module does not exist in folder Templates!')
	if ModuleF then
		ModuleF(...)
	end
end)

-- Effects: TemperProjectile
workspace.Effects.ChildAdded:Connect(function(Child)
	if Child.Name == 'TemperProjectile' then
		local Connection
		local Main = Assets.Particles["Temper Paper"].Charge:Clone()
		Main.Anchored = true
		Main.CFrame = Child.CFrame
		Main.Parent = workspace.Effects

		Connection = RunService.RenderStepped:Connect(function()
			if Child.Parent then
				TweenService:Create(Main, ChargeInfo, {CFrame = Child.CFrame}):Play()
			else
				Main:Destroy()
				Connection:Disconnect()
				return
			end
		end)
	end
end)

-- Effects: ClientInward
workspace.Effects.ChildAdded:Connect(function(Child)
	if Child.Name == 'ClientInward' then
		print('hey')
		local SizeMultiplier = 0.1
		local Connection

		local Part = Assets.Meshes.Charge.Client:Clone()
		Part.CFrame = Child.CFrame
		Part.Att0.Position = Vector3.new(0, SizeMultiplier, 0)
		Part.Att1.Position = Vector3.new(0, -SizeMultiplier, 0)
		Part.Parent = workspace.Effects

		Connection = RunService.RenderStepped:Connect(function()
			if Child.Parent then
				TweenService:Create(Part, ChargeInfo, {CFrame = Child.CFrame}):Play()
			else
				TweenService:Create(Part.Attachment.PointLight, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Brightness = 0}):Play()
				Debris:AddItem(Part, 1)
				Connection:Disconnect()
			end
		end)
	end
end)