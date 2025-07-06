-- Services
local RunService = game:GetService('RunService')

local Module = { }
Module.Connections = { }

Module.Init = function( PrimaryPart, Mouse )
	if #Module.Connections >= 1 then return end

	local BodyGyro = Instance.new('BodyGyro')
	BodyGyro.Name = 'FaceMouse'
	BodyGyro.MaxTorque = Vector3.new(1e008, 1e008, 1e008)
	BodyGyro.P = 10000
	BodyGyro.D = 325
	BodyGyro.Parent = PrimaryPart

	-- We update the CFrame of the constraints every frame.
	Module.Connections[#Module.Connections + 1] = RunService.RenderStepped:Connect(function()
		BodyGyro.CFrame = CFrame.lookAt( PrimaryPart.CFrame.Position, Mouse.Hit.Position )
	end)
end

Module.Deinit = function(PrimaryPart)
	PrimaryPart:FindFirstChild('FaceMouse'):Destroy()
	for _, v in ipairs( Module.Connections )  do
		v:Disconnect()
	end
	Module.Connections = { }
end

return Module