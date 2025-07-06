local player = game.Players.LocalPlayer
local character = player.Character
local items = {}
local buttons = {}
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,false)

function search(location)
	for i,v in pairs(location:GetChildren()) do 
		if v:isA("Tool") then 
			table.insert(items,v) 
		end
	end
end

function refresh()
	for i,v in pairs(buttons) do 
		v:Destroy() 
	end
	for i,v in pairs(items) do 
		local button = script.Sample:Clone() 
		button.Name = v.Name
		button.LayoutOrder = i
		button.Parent = script.Parent.Handler
		button.Image = v.TextureId
		table.insert(buttons,button)
		button.MouseButton1Click:connect(function()
			if script.Parent.Handler.Selected.Value == nil or script.Parent.Handler.Selected.Value ~= v then 
				script.Parent.Frame.ItemName.Text = v.Name
				script.Parent.Frame.ImageLabel.Image = v.TextureId
				script.Parent.Handler.Selected.Value = v
				if script.Parent.Handler.Selected.Value ~= script.Parent.Handler.Equipped.Value then
					script.Parent.Handler.Location.Value = v.Parent
					script.Parent.Frame.Equip.Text = "Equip" 
				elseif script.Parent.Handler.Selected.Value == script.Parent.Handler.Equipped.Value then 
					script.Parent.Handler.Location.Value = v.Parent
					script.Parent.Frame.Equip.Text = "Unequip"
				end
			end
		end)
	end
end

function backpackRefresh()
	items = {}
	search(character)
	search(player.Backpack)
	refresh()
end

backpackRefresh()

player.Backpack.ChildAdded:connect(backpackRefresh)
player.Backpack.ChildRemoved:connect(backpackRefresh)

character.ChildAdded:connect(backpackRefresh)
character.ChildRemoved:connect(backpackRefresh)