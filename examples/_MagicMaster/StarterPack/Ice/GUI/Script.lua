Tool = script.Parent
function onEquippedLocal()
	local Character = Tool.Parent
	local Player = game.Players:GetPlayerFromCharacter(Character)
	Gui = script.Parent.Skill_list:clone()
	Gui.Parent = Player.PlayerGui
end

function onUnequippedLocal()
	Gui:Remove()
end

Tool.Equipped:connect(onEquippedLocal)
Tool.Unequipped:connect(onUnequippedLocal)
