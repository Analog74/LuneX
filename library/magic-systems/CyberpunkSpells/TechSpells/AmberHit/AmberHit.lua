-- AmberHit Spell
--
-- Description: Creates a powerful Amber explosion at a designated position.
--
-- @module AmberHit
-- @author LuneX
-- @license MIT
-- @version 1.0.0
--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local Assets = ReplicatedStorage:WaitForChild("Assets")
local Particles = Assets:WaitForChild("Particles")

local AmberHit = {}
AmberHit.__index = AmberHit

-- Configuration for the AmberHit spell
AmberHit.Config = {
    Textures = {
        "rbxassetid://8085495824", "rbxassetid://8085497649", "rbxassetid://8085500784", "rbxassetid://8085501916", 
        "rbxassetid://8085503013", "rbxassetid://8085504232", "rbxassetid://8085505431", "rbxassetid://8085505431", 
        "rbxassetid://8085513823", "rbxassetid://8085515188", "rbxassetid://8085516591", "rbxassetid://8085517428", 
        "rbxassetid://8085518688", "rbxassetid://8085519966", ""
    },
    Textures1 = {
        "rbxassetid://8093600781", "rbxassetid://8093600781", "rbxassetid://8093604474", "rbxassetid://8093603463", 
        "rbxassetid://8093605608", "rbxassetid://8093607276", "rbxassetid://8093608645", "rbxassetid://8093609787", ""
    },
    EffectName = "AmberHit",
    EffectParent = workspace.Effects,
    LightTweenInfo = TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    DebrisLifetime = 2,
}

---
-- Creates and triggers the AmberHit effect.
-- @param position The position where the effect should occur.
--
function AmberHit.new(position)
    local self = setmetatable({}, AmberHit)

    if not position or typeof(position) ~= "Vector3" then
        warn("AmberHit.new: Invalid position provided.")
        return
    end
    
    self.Position = position
    self:_createEffect()
    
    return self
end

---
-- Creates the visual effect for the spell.
-- @private
--
function AmberHit:_createEffect()
    local hitEffect = Particles.Amber[self.Config.EffectName]:Clone()
    hitEffect.Position = self.Position
    hitEffect.Parent = self.Config.EffectParent

    local attachment = hitEffect.Attachment
    attachment.Gradient:Emit(1)
    attachment.Shock:Emit(1)
    attachment.Smoke:Emit(1)
    attachment.Smoke2:Emit(1)
    attachment.Shards:Emit(15)
    attachment.Specs:Emit(15)

    TweenService:Create(attachment.PointLight, self.Config.LightTweenInfo, {Brightness = 0}):Play()

    coroutine.wrap(self._animateTextures)(self, attachment.Smoke, self.Config.Textures, 0.0325)
    coroutine.wrap(self._animateTextures)(self, attachment.Smoke2, self.Config.Textures1, 0.05)

    Debris:AddItem(hitEffect, self.Config.DebrisLifetime)
end

---
-- Animates the textures of a particle emitter.
-- @private
--
function AmberHit:_animateTextures(emitter, textures, delayTime)
    for _, textureId in ipairs(textures) do
        emitter.Texture = textureId
        task.wait(delayTime)
    end
end

return AmberHit
