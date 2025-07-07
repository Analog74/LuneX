-- SpellCombatSystem.lua
-- Modular, extensible combat system for Game74
-- Inspired by SpellCombatSystem-Template

local SpellCombatSystem = {}

SpellCombatSystem.Abilities = {}

function SpellCombatSystem:RegisterAbility(ability)
    self.Abilities[ability.Name] = ability
end

function SpellCombatSystem:CastAbility(character, abilityName, target)
    local ability = self.Abilities[abilityName]
    if ability and ability.CanCast(character, target) then
        return ability:Cast(character, target)
    end
    return false, "Cannot cast ability."
end

return SpellCombatSystem
