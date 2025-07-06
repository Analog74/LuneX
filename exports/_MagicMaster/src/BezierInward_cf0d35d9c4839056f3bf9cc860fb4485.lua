-- Localization
local Random = Random.new()

-- Services
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService('ServerScriptService')

local RunService = game:GetService('RunService')

-- Modules
local ServerModules = ServerScriptService:WaitForChild('Modules')
local Bezier = require(ServerModules.Bezier)
local MockPart = require(ServerModules.MockPart)

-- Auxiliary functons
local DisconnectConnections = function( Connections )
	for _, v in ipairs( Connections ) do
		v:Disconnect()
	end
end

local InwardBezierModule = { }
InwardBezierModule.Connections = { }

InwardBezierModule.Init = function( Part, Properties )
	table.insert( InwardBezierModule.Connections, Part )
	
	-- Attributes / Properties
	local Speed = Properties.Speed or 2		-- How fast the charging parts go in the main part.
	local Radius = Properties.Radius or 10	    -- How wide the spawning area of the curving parts are.
	local Interval = Properties.Interval or 0.1	-- Interval per part spawn in seconds
	local Index = Properties.Index or math.huge -- How many parts will spawn?
	local SpeedMultiplier = Properties.SpeedMultiplier or 1	-- The speed is multiplied by the SpeedMultiplier, can be random.
	local Curveffset = Properties.CurveOffset or 5 -- The offset of the curvature.
	
	-- Start the charging effect.
	for _ = 1, Index do
		if not table.find( InwardBezierModule.Connections, Part ) then break end
		
		-- Default values for curve offset
		local DefaultCurveOffset = Vector3.new(Random:NextNumber(-Curveffset, Curveffset), Random:NextNumber(-Curveffset,Curveffset), Random:NextNumber(-Curveffset, Curveffset)) or Vector3.new(Random:NextNumber(-15, 15), Random:NextNumber(-5, 10), Random:NextNumber(-15, 15))	-- Default values to be input in curve offset if property CurveOffset is not passed.
		
		local Offset = CFrame.new(Random:NextNumber(-Radius, Radius), Random:NextNumber(-Radius, Radius), Random:NextNumber(-Radius, Radius))	-- Offset of the parts from center determined by the radius.
		local CurveOffset = DefaultCurveOffset -- Determines the path of the bezier curve.
		
		local MockPart = MockPart(Part.CFrame * Offset) -- Create an invisible part server-side
		MockPart.Name = 'ClientInward'
		
		-- Map the start, end and midpoint positions for the motion.
		local Start = MockPart.CFrame
		local End = Part.CFrame
		local Midpoint = Start.Position:Lerp(End.Position, 0.5) + CurveOffset
		
		local Connection
		local Elapsed = 0
		
		Connection = RunService.Heartbeat:Connect(function(Delta)
			Elapsed += Delta * ( Speed * SpeedMultiplier )
			
			local Curve = Bezier.QuadBezier(Elapsed, Start.Position, Midpoint, End.Position)
			
			if ( Elapsed >= 1 ) then
				MockPart.Position = End.Position
				MockPart:Destroy()
				Connection:Disconnect()
				return
			else
				MockPart.Position = Curve
			end
		end)
		
		task.wait(Interval)
	end
end

InwardBezierModule.Deinit = function( Part )
	for Index, Key in ipairs( InwardBezierModule.Connections ) do
		if Key == Part then
			print('Removed connection.')
			table.remove(InwardBezierModule.Connections, Index)
		end
	end
end

return InwardBezierModule