-- MathUtil.luau
-- Math utilities (stub)

local MathUtil = {}

function MathUtil:Clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

return MathUtil
