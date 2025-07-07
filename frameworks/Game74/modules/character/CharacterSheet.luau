-- CharacterSheet.luau
-- Central data store for character attributes (Game74)
-- Integrates with MoveSet, SpellCombatSystem, Inventory, EnvironmentalEffects, HUD, etc.

local ProfileService = require(game.ReplicatedStorage.ThirdParty.ProfileService)

local CharacterSheet = {}
CharacterSheet.__index = CharacterSheet

function CharacterSheet.new(player)
    local self = setmetatable({}, CharacterSheet)
    self.Player = player
    self.Data = {
        health = 100,
        mana = 50,
        stamina = 100,
        energy = 100,
        jumpPower = 50,
        runSpeed = 16,
        critChance = 0.05,
        cyberwareLevel = 0,
        syndicateRank = 0,
        -- ...add more attributes as needed
    }
    self.Profile = ProfileService.GetProfile(player)
    return self
end

function CharacterSheet:GetAttribute(attr)
    return self.Data[attr]
end

function CharacterSheet:SetAttribute(attr, value)
    self.Data[attr] = value
    -- Optionally sync with ProfileService or fire events
end

return CharacterSheet
