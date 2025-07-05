local frame = script.Parent.Parent:WaitForChild("Frame")
local open = script.Parent.Parent.Open

script.Parent.MouseButton1Click:Connect(function()
	if open.Value == false then
		frame.Visible = true -- Position of your frame when its opened
		open.Value = true
	elseif open.Value == true then
		frame.Visible = false -- Position of your frame when its closed
		open.Value = false
	end
end)

