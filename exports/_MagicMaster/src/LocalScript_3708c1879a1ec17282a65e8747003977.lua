-- Open and Close Menu

local UIS = game:GetService("UserInputService")
local frame = script.Parent
local frame = script.Parent
local Menu_Key = Enum.KeyCode.ButtonR2

frame.Visible = false

--While Key Pressed
UIS.InputBegan:Connect(function(Key)
	
		if Key.KeyCode == Menu_Key then
		frame.Visible = true
		else frame.Visible = false

		end
	end)




