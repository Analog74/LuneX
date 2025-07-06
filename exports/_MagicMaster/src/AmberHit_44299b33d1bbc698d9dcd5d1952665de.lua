-- Services
local Camera = workspace.CurrentCamera
local Replicated = game:GetService('ReplicatedStorage')
local TweenService = game:GetService('TweenService')
local Debris = game:GetService('Debris')
local RunService = game:GetService('RunService')

-- Assets
local Assets = Replicated.Assets
local Particles = Assets.Particles
local Meshes = Assets.Meshes

local CameraShaker = require(script.Parent.Parent.Parent.Auxiliary.CameraShaker)
local BoltModule = require(script.Parent.Parent.Parent.Auxiliary.LightningBolt)
local SparksModule = require(script.Parent.Parent.Parent.Auxiliary.LightningBolt.LightningSparks)

-- Functions
local CamShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(CF)
	Camera.CFrame = Camera.CFrame * CF
end)

CamShake:Start()

return 
	-- This module contains every effect associated with the ability.
	-- It controls the timing of effects and how the effects should work in general
	

	function(...)
	
	--Upper Effect	


	-- Transform the variadic function into a table for further use.
	local Parameters = {...}
	local Textures = {'rbxassetid://8085495824', 'rbxassetid://8085497649', 'rbxassetid://8085500784', 'rbxassetid://8085501916', 'rbxassetid://8085503013', 'rbxassetid://8085504232', 'rbxassetid://8085505431', 'rbxassetid://8085505431', 'rbxassetid://8085513823', 'rbxassetid://8085515188', 'rbxassetid://8085516591', 'rbxassetid://8085517428', 'rbxassetid://8085518688', 'rbxassetid://8085519966', ''} 
	local Textures1 = {'rbxassetid://8093600781', 'rbxassetid://8093600781', 'rbxassetid://8093604474', 'rbxassetid://8093603463', 'rbxassetid://8093605608', 'rbxassetid://8093607276', 'rbxassetid://8093608645', 'rbxassetid://8093609787', ''}
	
	local Hit = Particles.Amber.AmberHit:Clone()
	Hit.Position = Parameters[1]
	Hit.Parent = workspace.Effects
	
	Hit.Attachment.Gradient:Emit(1)
	Hit.Attachment.Shock:Emit(1)
	Hit.Attachment.Smoke:Emit(1)
	Hit.Attachment.Smoke2:Emit(1)
	Hit.Attachment.Shards:Emit(15)
	Hit.Attachment.Specs:Emit(15)
	TweenService:Create(Hit.Attachment.PointLight, TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Brightness = 0}):Play()
	
	coroutine.wrap(function()
		for _, v in ipairs(Textures) do
			Hit.Attachment.Smoke.Texture = v
			task.wait(0.0325)
		end
	end)()
	
	for _, v in ipairs(Textures1) do
		Hit.Attachment.Smoke2.Texture = v 
		task.wait(0.05)
	end
	
	Debris:AddItem(Hit, 2)
end

