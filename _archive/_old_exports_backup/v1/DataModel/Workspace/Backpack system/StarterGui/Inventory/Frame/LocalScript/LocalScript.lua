local uis = game:GetService("UserInputService")
local frame = script.Parent

function onKeyPress(inputObject, gameProcessedEvent)
	if not gameProcessedEvent then
		if inputObject.KeyCode == Enum.KeyCode.G then
			if script.Parent.Visible == false then
				frame.Visible = true
			else
				frame.Visible = false
			end
		end
	end
end

uis.InputBegan:Connect(onKeyPress)