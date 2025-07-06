local equipped = script.Parent.Parent.Parent.Handler.Equipped
local selected = script.Parent.Parent.Parent.Handler.Selected
local location = script.Parent.Parent.Parent.Handler.Location
local player = game.Players.LocalPlayer
local character = player.Character

script.Parent.MouseButton1Click:connect(function()
	if equipped.Value == nil or equipped.Value ~= selected.Value then 
		character.Humanoid:UnequipTools() 
		if location.Value == player.Backpack then
			character.Humanoid:EquipTool(selected.Value)
			equipped.Value = selected.Value
			script.Parent.Text = "Unequip"
		end
	else
		character.Humanoid:UnequipTools()
		equipped.Value = nil
		script.Parent.Text = "Equip"
	end
end)