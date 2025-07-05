-- Localization
local Random = Random.new()

-- Services
local Replicated = game:GetService('ReplicatedStorage')
local Debris = game:GetService('Debris')

-- Assets
local Assets = Replicated.Assets
local Remote = Assets.Remotes.Ability
local FXRemote = Assets.Remotes.FX

-- Modules
local ServerModules = script.Parent.Modules
local Hitbox = require(ServerModules.Hitbox)
local MockPart = require(ServerModules.MockPart)
local Bezier = require(ServerModules.Bezier)
local CreateWeld = require(Replicated.Modules.Shared.CreateWeld)
local FindGroundPos = require(Replicated.Modules.Shared.FindGroundPos)

Remote.OnServerEvent:Connect(function( Player, Input, ... )
	local Character = Player.Character
	local PrimaryPart = Character.PrimaryPart
	local Humanoid = Character.Humanoid
	
	local Parameters = { ... }
	
	if Input == 'Meteors' then
		
		-- Properties
		local Type = Parameters[1].Type or 'Ice Meteors'
		local MeteorCount = 20
		local Interval = 0.225
		
		for _ = 1, MeteorCount do
			local Speed = Random:NextNumber(0.12, 0.17)
			
			local RandomCF = CFrame.new(math.random(-25, 25), math.random(20, 40), math.random(10, 30))
			local CF = PrimaryPart.CFrame * RandomCF * CFrame.Angles(math.rad(-27.5), math.rad(math.random(260, 280)), 0)
				
			local Part = MockPart(CF)
			Part.Name = Type
			
			-- Interpolation
			local StartCF = Part.CFrame
			local EndCF = Part.CFrame * CFrame.new(-95, 0, 0)
			local Distance = (StartCF.Position - EndCF.Position).Magnitude
			
			task.spawn(function()
				for i = 0, Distance, Speed do
					local Progress = i / Distance
					Part.CFrame = Part.CFrame:Lerp(EndCF, Progress)
					
					local Hit = Hitbox:Start(Part.Position, (Part.CFrame * CFrame.new(-5, 0, 0)).Position, {Part, Character, workspace.Effects})
					
					if Hit then
						FXRemote:FireAllClients(Type..' Hit', Part.Position)
						Part:Destroy()
						break
					end
					
					task.wait()
				end
			end)
			
			task.wait(Interval)
		end
	end
end)