-- CharacterController.luau
-- Modular character controller for Game74 (Roblox)
-- Integrates physics, input, and state management

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Replica = require(game.ReplicatedStorage.ThirdParty.ReplicaService)
local Maid = require(game.ReplicatedStorage.ThirdParty.Maid)
local ZonePlus = require(game.ReplicatedStorage.ThirdParty.ZonePlus)
local LookAt = require(script.Parent.LookAt)
local RaycastUtil = require(script.Parent.RaycastUtil)
local MathUtil = require(script.Parent.MathUtil)

local CharacterController = {}
CharacterController.__index = CharacterController

function CharacterController.new(player)
    local self = setmetatable({}, CharacterController)
    self.Player = player
    self.Maid = Maid.new()
    self:Init()
    return self
end

function CharacterController:Init()
    local character = self.Player.Character
    if not character then return end
    self.Humanoid = character:WaitForChild("Humanoid")
    self.RootPart = character:WaitForChild("HumanoidRootPart")
    self.JumpCount = 0
    self.State = "Grounded"
    self.Replica = Replica.CreateReplica({
        Class = "PlayerState_" .. self.Player.UserId,
        Data = { JumpCount = 0, State = "Grounded", Orientation = Vector3.new() },
        Tags = { "All" }
    })
    self.Maid:GiveTask(UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Space then
                self:HandleJump()
            elseif input.KeyCode == Enum.KeyCode.E then
                self:ActivateSpell("NanoSphere")
            end
        end
    end))
    self.Maid:GiveTask(self.Humanoid.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Landed then
            self.JumpCount = 0
            self.State = "Grounded"
            self.Replica:SetValue({"State"}, "Grounded")
        end
    end))
    self.Maid:GiveTask(RunService.Heartbeat:Connect(function(dt)
        self:UpdateOrientation(dt)
    end))
end

function CharacterController:HandleJump()
    if self.JumpCount < 2 then
        self.Humanoid.Jump = true
        self.JumpCount = self.JumpCount + 1
        self.Replica:SetValue({"JumpCount"}, self.JumpCount)
    end
end

function CharacterController:ActivateSpell(spellName)
    -- Integrate with SpellCombatSystem
end

function CharacterController:UpdateOrientation(dt)
    -- Integrate with LookAt and update orientation
end

function CharacterController:Destroy()
    self.Maid:DoCleaning()
end

return CharacterController
