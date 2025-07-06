local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local RS = game:GetService("ReplicatedStorage")
local Remotes = RS:WaitForChild("Remotes")
local Modules = RS:WaitForChild("Modules")

local Skills = RS:WaitForChild("Skills")

local ReplicateEvent = Remotes:WaitForChild("Replicate")

ReplicateEvent.OnClientEvent:Connect(function(humRP, skillName, mousePos, targetCFrame, RayInstanceY
)
	local humanRP = char:FindFirstChild("HumanoidRootPart")
	if humanRP then
		if (humanRP.Position - humRP.Position).Magnitude < 200 then
			if skillName == "HammerZ" then
				local skillMod = require(Skills:FindFirstChild("Test"))
				skillMod.ZSkill(humRP, mousePos)
			elseif skillName == "HammerX" then
				local skillMod = require(Skills:FindFirstChild("Test"))
				skillMod.XSkill(humRP, mousePos)
			elseif skillName == "TestTornadoC" then
				local skillMod = require(Skills:FindFirstChild("Test"))
				skillMod.CSkill(humRP, targetCFrame, RayInstanceY)
			end
		end
	end
end)