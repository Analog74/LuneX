-- LookAt.luau
-- Utility for character orientation (stub)

local LookAt = {}

function LookAt.new(character)
    local self = setmetatable({}, {__index = LookAt})
    self.Character = character
    self._spring = { position = Vector3.new() }
    return self
end

function LookAt:calcGoal(goal)
    -- Calculate orientation goal
end

function LookAt:update(dt)
    -- Update orientation
end

return LookAt
