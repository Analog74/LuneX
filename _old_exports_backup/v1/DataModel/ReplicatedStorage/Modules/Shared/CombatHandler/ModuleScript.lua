local Combat = {}

local Weapons = {
	["Yoru"] = {
		Cooldown = {
			[1] = 0;
			[2] = 0;
			[3] = 0;
			[4] = 0
		};
		HitDelay = {
			[1] = 0;
			[2] = 0;
			[3] = 0;
			[4] = 0;
		};
		HitDuration = {
			[1] = 0;
			[2] = 0;
			[3] = 0;
			[4] = 0;
		};
	};
	
	["Basic Sword"] = {
		Cooldown = {
			[1] = 0;
			[2] = 0;
			[3] = 0;
			[4] = 0
		};
		HitDelay = {
			[1] = 0;
			[2] = 0;
			[3] = 0;
			[4] = 0;
		};
		HitDuration = {
			[1] = 0;
			[2] = 0;
			[3] = 0;
			[4] = 0;
		};
	};
	
	["Black Leg"] = {
		Cooldown = {
			[1] = 0;
			[2] = 0;
			[3] = 0;
			[4] = 0
		};
		HitDelay = {
			[1] = 0;
			[2] = 0;
			[3] = 0;
			[4] = 0;
		};
		HitDuration = {
			[1] = 0;
			[2] = 0;
			[3] = 0;
			[4] = 0;
		};
	};
	
	["Standard"] = {
		Cooldown = {
			[1] = 0.38,
			[2] = 0.33,
			[3] = 0.38,
			[4] = 1.5
		};
		HitDelay = {
			[1] = 0.17,
			[2] = 0.17,
			[3] = 0.17,
			[4] = 0.17
		};
		HitDuration = {
			[1] = 0.18,
			[2] = 0.13,
			[3] = 0.18,
			[4] = 0.13
		};
		HitboxTime = {
			[1] = 0.38,
			[2] = 0.33,
			[3] = 0.38,
			[4] = 0.33
		};
		
		Animations = {
			["Idle"] = "rbxassetid://7626417700",
			[1] = "rbxassetid://7626363689",
			[2] = "rbxassetid://7626375829",
			[4] = "rbxassetid://7299760346",
			[3] = "rbxassetid://7299779803"
		};
		
		Limbs = {
			[1] = "RightLowerArm";
			[2] = "LeftLowerArm";
			[3] = "RightLowerArm";
			[4] = "LeftLowerArm";
		}
	};
}

local RS = game:GetService("ReplicatedStorage")

local originalHitbox = script:WaitForChild("CombatHitbox")

local DoingCombo = 0
local Combo = 1

local M1Debounce = false

local Remotes = RS:WaitForChild("Remotes")
local Modules = RS:WaitForChild("Modules")

local runRemote = Remotes:WaitForChild("Run")

local RaycastHitbox = require(Modules:WaitForChild("RaycastHitboxV4"))

local hitRemote = script:WaitForChild("Hit")

local function InsertHitbox(char, weaponEquipped)
	
	local HumRP = char:WaitForChild("HumanoidRootPart")
	
	local hb = originalHitbox:Clone()
	hb.Transparency = 1
	hb.Parent = char:WaitForChild(Weapons[weaponEquipped].Limbs[DoingCombo])

	local weld = Instance.new("Weld", char:WaitForChild(Weapons[weaponEquipped].Limbs[DoingCombo]))
	weld.Part0 = char:WaitForChild(Weapons[weaponEquipped].Limbs[DoingCombo])
	weld.Part1 = hb

	hitbox = RaycastHitbox.new(hb)

	local Params = RaycastParams.new()
	Params.FilterDescendantsInstances = {char} --- remember to define our character!
	Params.FilterType = Enum.RaycastFilterType.Blacklist

	hitbox.RaycastParams = Params

	hitbox.OnHit:Connect(function(hit, humanoid)
		if humanoid then
			if not humanoid.Parent:FindFirstChild("Immune") then
				hitRemote:FireServer(HumRP, humanoid, "Hit", DoingCombo)
			end
		end
	end)

	delay(Weapons[weaponEquipped].HitboxTime[DoingCombo], function()
		if hb then
			hb:Destroy()
		end
		if hitbox then
			hitbox:Destroy()
		end
	end)	
end

function Combat.Attack(player, char, weaponEquipped)
	if not M1Debounce and not player:FindFirstChild("isBlocking").Value and not char:FindFirstChild("Disabled") then
		runRemote:FireServer("Walking")
		
		local HumRP = char:WaitForChild("HumanoidRootPart")
		local Hum = char:WaitForChild("Humanoid")
		
		local createAnim = function()
			local animFile = Instance.new("Animation")
			animFile.AnimationId = Weapons[weaponEquipped].Animations[DoingCombo]
			
			return animFile
		end
		
		if Combo == 1 then
			Combo = 2
			DoingCombo = 1
			delay(1, function()
				if Combo == 2 then
					Combo = 1
				end
			end)
			M1Debounce = true
			delay(Weapons[weaponEquipped].Cooldown[DoingCombo], function()
				M1Debounce = false
			end)
			local anim = createAnim()
			Hum:LoadAnimation(anim):Play()
		elseif Combo == 2 then
			Combo = 3
			DoingCombo = 2
			delay(1, function()
				if Combo == 3 then
					Combo = 1
				end
			end)
			M1Debounce = true
			delay(Weapons[weaponEquipped].Cooldown[DoingCombo], function()
				M1Debounce = false
			end)
			local anim = createAnim()
			Hum:LoadAnimation(anim):Play()
		elseif Combo == 3 then
			Combo = 4
			DoingCombo = 3
			delay(1, function()
				if Combo == 4 then
					Combo = 1
				end
			end)
			M1Debounce = true
			delay(Weapons[weaponEquipped].Cooldown[DoingCombo], function()
				M1Debounce = false
			end)
			local anim = createAnim()
			Hum:LoadAnimation(anim):Play()
		elseif Combo == 4 then
			Combo = 1
			DoingCombo = 4
			M1Debounce = true
			delay(Weapons[weaponEquipped].Cooldown[DoingCombo], function()
				M1Debounce = false
			end)
			local anim = createAnim()
			Hum:LoadAnimation(anim):Play()
		end

		InsertHitbox(char, weaponEquipped)

		delay(Weapons[weaponEquipped].HitDelay[DoingCombo], function()
			if hitbox then
				hitbox:HitStart(Weapons[weaponEquipped].HitDuration[DoingCombo])
				hitRemote:FireServer(HumRP, Hum, "Trail", DoingCombo)
			end
		end)
	end
end


return Combat
