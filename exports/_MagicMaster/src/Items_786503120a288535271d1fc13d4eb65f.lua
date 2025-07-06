local Items = {}

Items.Info = {
	["Katana"] = {
		Damage = 15,
		Price = 10000,
		Rarity = "Uncommon",
		Sellable = true,
		EquipCF = CFrame.new(0.000339508057, 0.295974255, -0.0298342705, 1, 0, 0, 0, 0, -1, 0, 1, 0),
		SheathedCF = CFrame.new( 0.026550293, 1.78260803, 0.106880188, -0.999904335, -5.23826493e-08, 0.0138342781, 0.0137816379, -0.0871569887, 0.996099234, 0.00120570196, 0.996194601, 0.087148644),
		Icon = 7220670131,
	},
	
	["Iron Sword"] = {
		Damage = 5,
		Price = 100,
		Rarity = "Uncommon",
		Sellable = true,
		Icon = 7220669983,
		Strength = 0,
		Defense = 0,
		Agility = 0,
		Magic = 0,
		Health = 10,
	},
}

return Items
