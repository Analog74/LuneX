-- CharacterSheet.lua
-- Centralized character attribute system

local CharacterSheet = {}

function CharacterSheet.new(data)
    local self = setmetatable({}, {__index = CharacterSheet})
    self.Name = data.Name or "Unnamed"
    self.Level = data.Level or 1
    self.Health = data.Health or 100
    self.Mana = data.Mana or 50
    self.Attributes = data.Attributes or {}
    return self
end

return CharacterSheet
