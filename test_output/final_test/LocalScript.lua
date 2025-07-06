local uis = game:GetService("UserInputService")
local Backpack = script.Parent:WaitForChild("Backpack")

if uis.TouchEnabled then
	Backpack.Visible = true
end