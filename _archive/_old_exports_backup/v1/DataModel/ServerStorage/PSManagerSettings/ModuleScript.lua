--[[
	Confused? Here's the documentation on how to setup: https://devforum.roblox.com/t/1435596
]]

local PROFILE_STORE_DEFAULTS = {
	["Data1"] = {
		_playerProfileKey = "Data-<userid>",
		EXP = 0,
		MaxEXP = 100,
		MaxStamina = 100,
		Level = 1,
		Defense = 0,
		Strength = 0,
		Agility = 0,
		Magic = 0,
		StatPoints = 3,
		Gold = 10,
		Gems = 0,
		Inventory = {"Iron Sword"; },
		Banned = false,
		
		-- APPEARANCE --
		
		Hair1 = 1,
		Hair2 = 1,
		Eyes = 1,
		Eyebrows = 1,
		Nose = 1,
		Mouth = 1,
		Shirt = 1,
		Pants = 1,
		
		-- YES --
		
		Party = {}
	}
}

local DEFAULT_NRH = "ForceLoad"

local function PROCESS_PROFILE_KEY_DICTIONARY(plr)
	local dictionary = {
		["<userid>"] = plr.UserId,
		["<username>"] = plr.Name,
	}
	return dictionary
end

























local data = {
	DEFAULT_NRH = DEFAULT_NRH,
	PROFILE_STORE_DEFAULTS = PROFILE_STORE_DEFAULTS,
	PROCESS_PROFILE_KEY_DICTIONARY = PROCESS_PROFILE_KEY_DICTIONARY,
}
return data