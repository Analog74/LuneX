--[[
	
	Press Key to Open a GUI Script V2
	Script By: Theevilem
	
	This script works so that when you press a key on your keyboard, it opens a Gui.
	
	Put it accordingly into the StarterGui (More info on line 17
	
--]]
wait()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Mouse = Player:GetMouse()
local Gui = script.Parent -- Set path to whatever Gui you want to open. For Example: script.Parent.Parent.GuiOrFrameName
local Open = false

function PressQ(key) -- Chnage Q to whatever key you desire. Capitals matter. For Example: PressH
	if (key == "g") then -- Change "q" to whatever letter you use in the line above. Lowercase matters. For Example: "h"
		if (Open == false) then
			Gui.Visible = true
			Open = true
		elseif (Open == true) then
			Gui.Visible = false
			Open = false
		end
	end
end
	
Mouse.KeyDown:Connect(PressQ) -- Make sure (PressQ) matches what you have for line 20. For Example: (PressH)