-- ExampleAbility.lua
-- Example modular ability for SpellCombatSystem

local ExampleAbility = {
    Name = "Fireball",
    Cooldown = 5,
    ManaCost = 20
}

function ExampleAbility:CanCast(character, target)
    return character.Mana >= self.ManaCost
end

function ExampleAbility:Cast(character, target)
    character.Mana = character.Mana - self.ManaCost
    -- Insert spell effect logic here
    return true, "Fireball cast!"
end

return ExampleAbility
