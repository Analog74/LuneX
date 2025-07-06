-- Ayaka Spell
--
-- Description: A camera shake effect for the Ayaka spell.
--
-- @module Ayaka
-- @author LuneX
-- @license MIT
-- @version 1.0.0
--

local CameraShaker = require(game.ReplicatedStorage.Modules.Auxiliary.CameraShaker)

local Ayaka = {}
Ayaka.__index = Ayaka

---
-- Creates a new Ayaka spell effect.
--
function Ayaka.new()
    local self = setmetatable({}, Ayaka)
    
    if not CameraShaker then
        warn("Ayaka.new: CameraShaker module not found.")
        return
    end

    self.CamShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(CF)
        workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CF
    end)
    
    self.CamShake:Start()
    
    return self
end

---
-- Triggers the camera shake effect.
--
function Ayaka:Execute()
    if self.CamShake then
        self.CamShake:Shake(CameraShaker.Presets.Ayaka)
    end
end

return Ayaka
