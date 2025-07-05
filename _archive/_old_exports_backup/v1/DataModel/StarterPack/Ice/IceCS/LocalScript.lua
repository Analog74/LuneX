local tool = script.Parent
local attackRemote = script:WaitForChild("Attack")

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local HumRP = char:WaitForChild("HumanoidRootPart")

local RS = game:GetService("ReplicatedStorage")
local Modules = RS:WaitForChild("Modules")

local TSPlus = require(Modules:WaitForChild("TweenServicePlus"))

local UIS = game:GetService("UserInputService")
local isEquipped = false

local mouse = player:GetMouse()

UIS.InputBegan:Connect(function(input, isTyping)
	if isTyping then return end
	if not isEquipped then return end
	if input.KeyCode == Enum.KeyCode.ButtonX then
		attackRemote:FireServer("Z")
	elseif input.KeyCode == Enum.KeyCode.ButtonY then
		attackRemote:FireServer("X", mouse.Hit)
	end
end)

tool.Equipped:Connect(function()
	isEquipped = true
end)

tool.Unequipped:Connect(function()
	isEquipped = false
end)


