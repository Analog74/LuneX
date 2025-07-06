-- Services
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Debris = game:GetService('Debris')

-- Assets
local Assets = ReplicatedStorage.Assets
local Particles = Assets.Particles.Spritesheet

return function( ... )
	local Parameters = { ... }
	
	-- Properties / Attributes
	local ParticlePreset = Parameters.ParticlePreset or Particles.Default	-- Path to the premade particle with preset properties.
	local EmitCount = Parameters.EmitCount or 10 -- How many times will the particle emit?
	local SpritesheetTextures = Parameters.SpritesheetTextures or warn('No textures passed!')	-- Spritesheet textures to loop.
	local SpritesheetFPS = Parameters.SpritesheetFPS or 0.03 -- Spritesheet frames per second.
	local Parent = Parameters.Parent or warn('No parent set!') -- Where will the particle be parented to?
	
	 -- We will manually clone the particle for every time we are going to make a spritesheet so it looks more natural.
	for _ = 1, EmitCount do -- We get rid of the index because we don't need it. It's nice to conserve memory.
		local Particle = ParticlePreset:Clone()
		Particle.Parent = Parent
		Particle:Emit(1)
		
		task.spawn(function() -- We loop through all the textures and change the particle texture accordingly.
			for _, v in ipairs(SpritesheetTextures) do -- We get rid of the index because we don't need it. It's nice to conserve memory.
				Particle.Texture = v
				task.wait(SpritesheetFPS)
			end
			Debris:AddItem(Particle, 1) -- Destroy the particle after one second of finishing the loop.
		end)
	end
end