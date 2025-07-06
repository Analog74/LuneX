-- Baal Spell
--
-- Description: A powerful lightning-based spell with visual effects and camera shake.
--
-- @module Baal
-- @author LuneX
-- @license MIT
-- @version 1.0.0
--

local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Assets = ReplicatedStorage:WaitForChild("Assets")
local Particles = Assets:WaitForChild("Particles")

local CameraShaker = require(ReplicatedStorage.Modules.Auxiliary.CameraShaker)

local Baal = {}
Baal.__index = Baal

-- Configuration for the Baal spell
Baal.Config = {
    EffectName = "Baal",
    EffectParent = workspace.Effects,
    LightTweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    LightEndTweenInfo = TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    DebrisLifetime = 1,
}

---
-- Creates a new Baal spell effect.
-- @param target The target part for the spell effect.
--
function Baal.new(target)
    local self = setmetatable({}, Baal)

    if not target or not target:IsA("BasePart") then
        warn("Baal.new: Invalid target provided.")
        return
    end

    self.Target = target
    self.CamShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(CF)
        workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CF
    end)
    self.CamShake:Start()

    self:_execute()

    return self
end

---
-- Executes the Baal spell effect.
-- @private
--
function Baal:_execute()
    local baalEffect = Particles.Baal[self.Config.EffectName]:Clone()
    baalEffect.CFrame = self.Target.CFrame * CFrame.new(0, 4.5, -7.5) * CFrame.Angles(0, math.rad(90), 0)
    baalEffect.Parent = self.Config.EffectParent

    TweenService:Create(baalEffect.PointLight, self.Config.LightTweenInfo, { Brightness = 3.25 }):Play()

    local attachment = baalEffect.Attachment
    attachment.Shards3:Emit(3)

    task.wait(0.25)
    self.CamShake:Shake(CameraShaker.Presets.Lightning1)
    attachment.Main:Emit(1)
    attachment.Center:Emit(1)
    attachment.Sparks:Emit(10)
    attachment.Gradient:Emit(1)
    attachment.Spark1:Emit(1)
    attachment.Shards1:Emit(20)
    attachment.Specs1:Emit(35)
    attachment.Smoke:Emit(30)

    task.wait(0.8)
    self.CamShake:Shake(CameraShaker.Presets.Lightning1)
    attachment.Shards2:Emit(15)
    attachment.Shards:Emit(30)
    attachment.Gradient1:Emit(1)
    attachment.Specs:Emit(25)

    TweenService:Create(baalEffect.PointLight, self.Config.LightEndTweenInfo, { Brightness = 0 }):Play()

    Debris:AddItem(baalEffect, self.Config.DebrisLifetime)
end

return Baal
