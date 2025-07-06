wait(1)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--local CameraUtil = require(ReplicatedStorage.CameraUtil)
--local functions = CameraUtil.Functions
--local shakePresets = CameraUtil.ShakePresets

--local cameraInstance = workspace.CurrentCamera
--local camera = CameraUtil.Init(cameraInstance)



--local shake = camera:CreateShake()
--shake:Start()

--shakeRemote.OnClientEvent:Connect(function(player, Action)
--	if Action == "IceZ" then
--		shake:Shake(shakePresets.Explosion)
--	end
--end)

local cameraShaker = require(ReplicatedStorage.CameraShaker)
local camera = game.Workspace.CurrentCamera

local camShake = cameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	camera.CFrame = camera.CFrame * shakeCFrame
end)

camShake:Start()

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local shakeRemote = remotes:WaitForChild("Shake")

shakeRemote.OnClientEvent:Connect(function(Action)
	if Action == "IceZ" then
		camShake:Shake(cameraShaker.Presets.IceZ)
	elseif Action == "Dash" then
		camShake:Shake(cameraShaker.Presets.Dash)
	elseif Action == "Hit" then
		camShake:Shake(cameraShaker.Presets.Hit)
	elseif Action == "Twerk" then
		print("Deactivated")--camShake:Shake(cameraShaker.Presets.Twerk)
	end	
end)