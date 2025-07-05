local cs = game:GetService("CollectionService")
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local SOURCE_LOCALE = "en"
local translator = nil


local Misc = {}

Misc.StrongKnockback = function(target, strength1, strength2, duration, Origin)
	local EffectVelocity = Instance.new("BodyVelocity", target)
	EffectVelocity.MaxForce = Vector3.new(1, 1, 1) * 1000000;
	EffectVelocity.Velocity = Vector3.new(1, 1, 1) * Origin.CFrame.LookVector * math.random(strength1, strength2)

	game.Debris:AddItem(EffectVelocity, duration)
end

Misc.TweenNumber = function(TextInstance, NumberVal, Duration, DesiredValue, BeforeText, AfterText)
	local part = NumberVal

	local tweenInfo = TweenInfo.new(
		1,
		Enum.EasingStyle.Linear, 
		Enum.EasingDirection.Out, 
		1, 
		false, 
		0 
	)

	local tween = game.TweenService:Create(part, tweenInfo, {Value = DesiredValue})

	tween:Play()

	part.Changed:Connect(function(val)
		if not BeforeText and not AfterText then
			TextInstance.Text = tonumber(math.round(val))
		elseif BeforeText and not AfterText then
			TextInstance.Text = BeforeText..tonumber(math.round(val))
		elseif not BeforeText and AfterText then
			TextInstance.Text = tonumber(math.round(val))..AfterText
		elseif BeforeText and AfterText then
			TextInstance.Text = BeforeText..tonumber(math.round(val))..AfterText
		end
	end)
end

Misc.InsertDisabled = function(Target, Duration)
	local disabled = Instance.new("BoolValue")
	disabled.Name = "Disabled"
	
	disabled.Parent = Target
	
	game.Debris:AddItem(disabled, Duration)
end

Misc.UpKnockback = function(target, strength1, strength2, duration, Origin)
	local EffectVelocity = Instance.new("BodyVelocity", target)
	EffectVelocity.MaxForce = Vector3.new(1, 1, 1) * 1000000;
	EffectVelocity.Velocity = Vector3.new(1, 1, 1) * Origin.CFrame.UpVector * math.random(strength1, strength2)

	game.Debris:AddItem(EffectVelocity, duration)
end

Misc.Ragdoll = function(Target, Duration)
	local ragVal = Instance.new("BoolValue")
	ragVal.Name = "Ragdoll"
	
	Misc.InsertDisabled(Target, Duration)
	
	ragVal.Parent = Target

	game.Debris:AddItem(ragVal, Duration)
end

Misc.SetOnFire = function(Target, Duration)
	local onFireVal = Instance.new("BoolValue")
	onFireVal.Name = "onFire"

	onFireVal.Parent = Target

	game.Debris:AddItem(onFireVal, Duration)
end

Misc.GetFruitToSpawn = function()
	local chances = {
		["Mythical"] = 0.5,
		["Legendary"] = 1,
		["Epic"] = 5,
		["Rare"] = 18.5,
		["Common"] = 75,
	}
	
	local fredfazber = {
		["Common"] = {
			"Suke",
			"Spin",
		},
		
		["Rare"] = {
			"Bomb",
			"Bari",
			"Supa"
		},
		
		["Epic"] = {
			"Gravity",
			"Hie",
		},
		
		["Legendary"] = {
			"Mera",
			"Light",
		},
		
		["Mythical"] = {
		--"FredFazber",
		},
	}
	
	local random = Random.new(math.random(-100, 100))
	local rarity
	
	local number = random:NextNumber(0, 100)
	if number <= chances["Mythical"] then
		rarity = "Legendary"--"Mythical" -- Pôr Mythical quando ter
	elseif number > chances["Mythical"] and number <= chances["Legendary"] then
		rarity = "Legendary"
	elseif number > chances["Legendary"] and number <= chances["Epic"] then
		rarity = "Epic"
	elseif number > chances["Epic"] and number <= chances["Rare"] then
		rarity = "Rare"
	elseif number > chances["Rare"] then
		rarity = "Common"
	end
	
	local fruitToSpawn = fredfazber[rarity][math.random(1, #fredfazber[rarity])]
	return fruitToSpawn
end

return Misc
