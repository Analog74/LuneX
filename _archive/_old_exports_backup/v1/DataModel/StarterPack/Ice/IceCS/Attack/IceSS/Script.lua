local attackRemote = script.Parent

local RS = game:GetService("ReplicatedStorage")
local Modules = RS:WaitForChild("Modules")
local Remotes = RS:WaitForChild("Remotes")

local shakeRemote = Remotes:WaitForChild("Shake")

local Skills = game.ServerScriptService:WaitForChild("Skills")

local IceSkillsModule = require(Skills:WaitForChild("IceSkills"))
local Combat = require(Modules:WaitForChild("CombatModule"))

local TweenService = require(Modules:WaitForChild("TweenServicePlus"))

local ZDebounce = false
local ZCooldown = 1

local XDebounce = false
local XCooldown = .1

attackRemote.OnServerEvent:Connect(function(player, action, mouseHit)
	local Char = workspace:FindFirstChild(player.Name)
	if Char then
		if not Char:FindFirstChild("Disabled") then
			local pStats = player:WaitForChild("Stats")
			local pMagic = pStats:WaitForChild("Magic")

			local ZDamage = 10 + (pMagic.Value * 1.15)
			local XDamage = 10 + (pMagic.Value * 1.15)

			if action == "Z" then
				if not ZDebounce then
					ZDebounce = true
					delay(ZCooldown, function()
						ZDebounce = false
					end)

					local Character = player.Character
					local HumRP = Character:FindFirstChild("HumanoidRootPart")
					local Hum = Character:FindFirstChild("Humanoid")
					if HumRP and Hum then
						IceSkillsModule.ZSkill(HumRP, ZDamage)
						delay(0.55, function()
							shakeRemote:FireClient(player, "IceZ")
						end)
					end
				end
			elseif action == "X" then
				if not XDebounce then
					XDebounce = true
					delay(XCooldown, function()
						XDebounce = false
					end)

					local Character = player.Character
					local HumRP = Character:FindFirstChild("HumanoidRootPart")
					local Hum = Character:FindFirstChild("Humanoid")
					if HumRP and Hum then
						IceSkillsModule.XSkill(HumRP, XDamage, mouseHit)
						delay(0.55, function()
							shakeRemote:FireClient(player, "IceX")
						end)
					end
				end
			end
		end	
	end
end)

