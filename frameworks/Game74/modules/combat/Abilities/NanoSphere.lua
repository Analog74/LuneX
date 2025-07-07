-- NanoSphere.lua
-- Example advanced ability for Game74

local NanoSphere = {
    Name = "NanoSphere",
    Cooldown = 10,
    ManaCost = 40
}

function NanoSphere:CanCast(character, target)
    return character.Mana >= self.ManaCost
end

function NanoSphere:Cast(character, target)
    character.Mana = character.Mana - self.ManaCost
    -- Spawn a physics-driven sphere at the character's position
    -- (Stub: integrate with PhysicsSystem and NetworkManager)
    return true, "NanoSphere cast!"
end

return NanoSphere
