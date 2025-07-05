local SSS = game:GetService("ServerScriptService")
local PSManager = require(SSS:WaitForChild("PSManager"))

local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(plr)

	-------------------------------- STATS -------------------------------- 
	local pStats = Instance.new("Folder")
	pStats.Name = "Stats"
	pStats.Parent = plr

	local Gold = Instance.new("NumberValue")
	Gold.Name = "Gold"
	Gold.Parent = pStats

	local Gems = Instance.new("NumberValue")
	Gems.Name = "Gems"
	Gems.Parent = pStats

	local EXP = Instance.new("NumberValue")
	EXP.Name = "EXP"
	EXP.Parent = pStats

	local maxEXP = Instance.new("NumberValue")
	maxEXP.Name = "MaxEXP"
	maxEXP.Parent = pStats

	local Level = Instance.new("IntValue")
	Level.Name = "Level"
	Level.Parent = pStats

	local StatPoints = Instance.new("IntValue")
	StatPoints.Name = "StatPoints"
	StatPoints.Parent = pStats

	local Strength = Instance.new("IntValue")
	Strength.Name = "Strength"
	Strength.Parent = pStats

	local Defense = Instance.new("IntValue")
	Defense.Name = "Defense"
	Defense.Parent = pStats

	local Magic = Instance.new("IntValue")
	Magic.Name = "Magic"
	Magic.Parent = pStats

	local Agility = Instance.new("IntValue")
	Agility.Name = "Agility"
	Agility.Parent = pStats

	local MaxStamina = Instance.new("IntValue")
	MaxStamina.Name = "MaxStamina"
	MaxStamina.Parent = pStats

	local Banned = Instance.new("BoolValue")
	Banned.Name = "Banned"
	Banned.Parent = pStats

	-------------------------------- Inventory --------------------------------
	local Inventory = Instance.new("Folder")
	Inventory.Name = "Inventory"
	Inventory.Parent = plr

	local Party = Instance.new("Folder")
	Party.Name = "Party"
	Party.Parent = plr

	-------------------------------- APPEARANCE --------------------------------
	local Appearance = Instance.new("Folder")
	Appearance.Name = "Appearance"
	Appearance.Parent = plr

	local Hair1 = Instance.new("IntValue")
	Hair1.Name = "Hair1"
	Hair1.Parent = Appearance

	local Hair2 = Instance.new("IntValue")
	Hair2.Name = "Hair2"
	Hair2.Parent = Appearance

	local Eyes = Instance.new("IntValue")
	Eyes.Name = "Eyes"
	Eyes.Parent = Appearance

	local Eyebrows = Instance.new("IntValue")
	Eyebrows.Name = "Eyebrows"
	Eyebrows.Parent = Appearance

	local Nose = Instance.new("IntValue")
	Nose.Name = "Nose"
	Nose.Parent = Appearance

	local Mouth = Instance.new("IntValue")
	Mouth.Name = "Mouth"
	Mouth.Parent = Appearance

	local Shirt = Instance.new("IntValue")
	Shirt.Name = "Shirt"
	Shirt.Parent = Appearance

	local Pants = Instance.new("IntValue")
	Pants.Name = "Pants"
	Pants.Parent = Appearance

	--------------------- ASSIGNING VALUES ---------------------

	local plrDataProfile = PSManager:FetchProfile("Data1",plr) -- storeName, plr as index

	----------- STATS -----------
	Gold.Value = plrDataProfile.Data.Gold
	Gems.Value = plrDataProfile.Data.Gems
	EXP.Value = plrDataProfile.Data.EXP
	maxEXP.Value = plrDataProfile.Data.MaxEXP
	Level.Value = plrDataProfile.Data.Level
	StatPoints.Value = plrDataProfile.Data.StatPoints
	MaxStamina.Value = plrDataProfile.Data.MaxStamina
	Strength.Value = plrDataProfile.Data.Strength
	Defense.Value = plrDataProfile.Data.Defense
	Agility.Value = plrDataProfile.Data.Agility
	Magic.Value = plrDataProfile.Data.Magic
	Banned.Value = plrDataProfile.Data.Banned

	----------- APPEARANCE -----------
	Hair1.Value = plrDataProfile.Data.Hair1
	Hair2.Value = plrDataProfile.Data.Hair2
	Eyes.Value = plrDataProfile.Data.Eyes
	Eyebrows.Value = plrDataProfile.Data.Eyebrows
	Nose.Value = plrDataProfile.Data.Nose
	Mouth.Value = plrDataProfile.Data.Mouth
	Shirt.Value = plrDataProfile.Data.Shirt
	Pants.Value = plrDataProfile.Data.Pants

	----------- INVENTORY -----------

	local function updateInv()
		for inv, item in pairs(plrDataProfile.Data.Inventory) do
			if not Inventory:FindFirstChild(item) then
				local itemVal = Instance.new("BoolValue")
				itemVal.Name = tostring(item)
				itemVal.Parent = Inventory
			end
		end
	end

	updateInv()

	local function updateParty()
		for party, member in pairs(plrDataProfile.Data.Party) do
			if not Party:FindFirstChild(member) then
				local itemVal = Instance.new("BoolValue")
				itemVal.Name = tostring(member)
				itemVal.Parent = Party
			end
		end
	end
	
	updateParty()
	
	---------------------------------

	--------------------------------- ASSIGNING DATA ---------------------------------

	--------------- STATS ---------------
	plrDataProfile:OnDataValueChanged("Gold",function(updatedValue)
		Gold.Value = updatedValue
	end)
	
	plrDataProfile:OnDataValueChanged("Inventory",function(updatedValue)
		updateInv()
	end)
	
	plrDataProfile:OnDataValueChanged("Party",function(updatedValue)
		updateParty()
	end)
	
	plrDataProfile:OnDataValueChanged("Gems",function(updatedValue)
		Gems.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("EXP",function(updatedValue)
		EXP.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("MaxEXP",function(updatedValue)
		maxEXP.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("Level",function(updatedValue)
		Level.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("StatPoints",function(updatedValue)
		StatPoints.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("Strength",function(updatedValue)
		Strength.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("Defense",function(updatedValue)
		Defense.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("Agility",function(updatedValue)
		Agility.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("Magic",function(updatedValue)
		Magic.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("Banned",function(updatedValue)
		Banned.Value = updatedValue
	end)

	------ APPEARANCE ------
	plrDataProfile:OnDataValueChanged("Hair1",function(updatedValue)
		Hair1.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("Hair2",function(updatedValue)
		Hair2.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("Eyes",function(updatedValue)
		Eyes.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("Eyebrows",function(updatedValue)
		Eyebrows.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("Nose",function(updatedValue)
		Nose.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("Mouth",function(updatedValue)
		Mouth.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("Shirt",function(updatedValue)
		Shirt.Value = updatedValue
	end)

	plrDataProfile:OnDataValueChanged("Pants",function(updatedValue)
		Pants.Value = updatedValue
	end)

end)