local camera = workspace.CurrentCamera

local vr = script.e
local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
local function ShakeCamera(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end
local renderPriority = Enum.RenderPriority.Camera.Value + 1
local camShake = CameraShaker.new(renderPriority, ShakeCamera)
camShake:Start()
while (true) do
	local ef = math.random(1,3)
	vr.Value=ef
	if vr.Value == 1 then
	camShake:Shake(CameraShaker.Presets.Earthquake)
	end
	if vr.Value == 2 then
		camShake:Shake(CameraShaker.Presets.Explosion)
	end
	if vr.Value == 3 then
		camShake:Shake(CameraShaker.Presets.Vibration)
	end
	if vr.Value == 4 then
		camShake:Shake(CameraShaker.Presets.Bump)
	end
	if vr.Value == 5 then
		camShake:Shake(CameraShaker.Presets.HandheldCamera)
	end
		wait(1)
	
	end 