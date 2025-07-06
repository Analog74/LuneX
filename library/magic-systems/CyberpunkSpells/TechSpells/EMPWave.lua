--[[
	EMPWave Spell - Tech Category
	
	Disables enemy abilities and cybernetic enhancements in an area.
	Perfect for crowd control in PvP scenarios.
	
	Inspiration: Cyberpunk 2077 tech abilities
]]

local SpellCombatSystem = require(script.Parent.Parent.Parent.SpellCombatSystem)

-- Create spell using template system
local EMPWave = SpellCombatSystem:CreateSpellFromTemplate("StatusEffect", {
	name = "EMPWave",
	description = "Electromagnetic pulse that disables enemy tech",
	category = "Tech",
	manaCost = 125,
	cooldown = 20,
	range = 80,
	broadcastRange = 150,
	
	effects = {
		{
			type = "Disable",
			targeting = "AOE",
			duration = 8,
			data = {
				radius = 25,
				disableTypes = {"abilities", "cybernetics", "gadgets"},
				includeCaster = false
			}
		},
		{
			type = "Damage",
			targeting = "AOE", 
			data = {
				amount = 30,
				radius = 25,
				damageType = "Electromagnetic"
			}
		}
	},
	
	visualEffect = "EMPExplosion",
	soundEffect = "TechDischarge",
	
	customValidation = function(caster, castData)
		-- Require tech skill level
		local playerLevel = caster:GetAttribute("TechLevel") or 1
		if playerLevel < 3 then
			return false, "Requires Tech Level 3"
		end
		return true
	end
})

return EMPWave
