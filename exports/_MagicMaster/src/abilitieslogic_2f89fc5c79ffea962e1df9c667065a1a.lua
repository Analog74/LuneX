wait(0.1)
-----------------------------find player and othen needs things--------------------ee that few fe)------------
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local pl = script.Parent
local remotes = pl:WaitForChild("Remotes")
local Animation = pl:WaitForChild("Animation")
local normchar = script.Parent.Parent
local Attack_1=false
local S = setmetatable({},{__index = function(s,i) return game:service(i) end})
local Plrs = S.Players
local Plr = Plrs.LocalPlayer
local Char = Plr.Character
local Head = Char:WaitForChild'Head'
local hum = Char.Humanoid
---------------------------------your keyboard settings---------------------
local pro = true
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.ButtonX and Attack_1==false then
			spawn(function()
			
					local Debouncee = true
					Attack_1 = true
				
					Attack_1 = remotes:WaitForChild("spell1"):InvokeServer(pl,Animation,Mouse.Hit.p)
					local Debouncee = false

		end)
	end
	
	if input.KeyCode == Enum.KeyCode.Q and Attack_1==false then
		spawn(function()

			local Debouncee = true
			Attack_1 = true

			Attack_1 = remotes:WaitForChild("spell2"):InvokeServer(pl,Mouse.Hit.p,Mouse.Hit.X, Mouse.Hit.Y, Mouse.Hit.Z)
			local Debouncee = false

		end)
	end
	
	if input.KeyCode == Enum.KeyCode.ButtonY and Attack_1==false then
		spawn(function()

			local Debouncee = true
			Attack_1 = true

			Attack_1 = remotes:WaitForChild("spell3"):InvokeServer(pl,Animation,Mouse.Hit.p)
			local Debouncee = false

		end)
	end
	
	if input.KeyCode == Enum.KeyCode.Four and Attack_1==false then
		spawn(function()

			local Debouncee = true
			Attack_1 = true

			Attack_1 = remotes:WaitForChild("spell4"):InvokeServer(pl,Animation,Mouse.Hit.p)
			local Debouncee = false

		end)
	end
	
	if input.KeyCode == Enum.KeyCode.Five and Attack_1==false then
		spawn(function()

			local Debouncee = true
			Attack_1 = true

			Attack_1 = remotes:WaitForChild("spell5"):InvokeServer(pl,Animation,Mouse.Hit.p)
			local Debouncee = false

		end)
	end

	if input.KeyCode == Enum.KeyCode.Six and Attack_1==false then
		spawn(function()

			local Debouncee = true
			Attack_1 = true

			Attack_1 = remotes:WaitForChild("spell6"):InvokeServer(pl,Animation,Mouse.Hit.p)
			local Debouncee = false

		end)
	end
	
	if input.KeyCode == Enum.KeyCode.Four and Attack_1==false then
		spawn(function()

			local Debouncee = true
			Attack_1 = true

			Attack_1 = remotes:WaitForChild("spell7"):InvokeServer(pl,Animation,Mouse.Hit.p)
			local Debouncee = false

		end)
	end
	
end)

