local remote = game.ReplicatedStorage.Remotes
local UIS = game:GetService("UserInputService")


local Animations = game.ReplicatedStorage.Animatons

remote.leftclick.OnClientEvent:Connect(function(player,c3)
	local iooooooooo = true

	UIS.InputBegan:Connect(function(input,istyping)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and iooooooooo==true then
			iooooooooo = false
			
	
			local clonea = player.Humanoid:LoadAnimation(Animations.rasenshurikenattack);
	clonea:Play()
		end
	end)





end)