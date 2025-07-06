----------welcome in the cum zone----------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local remotes = script.Parent:WaitForChild("Remotes")

local Animations = ReplicatedStorage.Animatons
local Debris = game:GetService("Debris")local function RemoveEffect(Ep,Tbr,Len,GSize,GCFrame,GTrans)
	spawn(function()
		wait(Tbr)
		TweenService:Create(Ep,TweenInfo.new(Len,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut),{Transparency = GTrans,Size = GSize,CFrame = GCFrame}):Play()
		Debris:AddItem(Ep,Len+2)
	end)
end
function CreateTween(p51, p52, p53, p54)
	local v65 = game:GetService("TweenService"):Create(p51, TweenInfo.new(unpack(p52)), p53);
	if p54 then
		v65:Play();

		wait(0.1)

	end;
	return v65;
end;
local remote = game.ReplicatedStorage.Remotes
local function sizeandother(Ep,Tbr,Len,GSize,GTrans)
	spawn(function()
		wait(Tbr)
		TweenService:Create(Ep,TweenInfo.new(Len,Enum.EasingStyle.Linear),{Transparency = GTrans,Size = GSize}):Play()
	
	end)
end


--function bodymover(...)

--	local whwilladd, parenti, forsi, positi, timeti = unpack(...);
--	for vga1, vga2 in pairs(parenti:GetChildren()) do
--		if vga2:IsA(whwilladd) then
--			vga2:Destroy();
--		end;
--	end;
--	local part = Instance.new(whwilladd);
--	part.Name = "Client";
--	if whwilladd == "BodyPosition" then
--		part.MaxForce = forsi;
--		part.Position = positi;
--		part.Parent = parenti;
--	elseif whwilladd == "BodyGyro" then
--		part.MaxTorque = forsi;
--		part.CFrame = positi;
--		part.Parent = parenti;
--	elseif whwilladd == "BodyVelocity" then
--		part.MaxForce = forsi;
--		part.Velocity = positi;
--		part.Parent = parenti;
--	end;
--	if timeti then
--		game.Debris:AddItem(part, timeti);
--	end;
--	return part;
--end;
local function StopPlayer(Hm,ShouldStop)
	if ShouldStop then
		Hm.WalkSpeed = 0
		Hm.JumpPower = 0
		
		Hm.AutoRotate = true
	else
		Hm.WalkSpeed = 16
		Hm.JumpPower = 50
	
		Hm.AutoRotate = true
	end
end
------------------------------spell1---------
remotes:WaitForChild("spell1").OnServerInvoke = function(player,tool,SAnimation,MP)
	local char = player.Character
	local Hm = char:WaitForChild("Humanoid")
	local to = char:WaitForChild("UpperTorso")
	local rp = char:WaitForChild("HumanoidRootPart")
	local leftarm = char:WaitForChild("LeftHand")
	local ra = char:WaitForChild("RightHand")
	StopPlayer(Hm, true)
----------------------------------------//Settings//-----------------------------------------
local CoolDown = 0
local Length = .74
local Damage = 30
---------------------------------------------------------------------------------------------
	local clonea = Hm:LoadAnimation(Animations.FireBallcast);
	clonea:Play()
	local v4 = CreateTween(rp, { 0, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0}, {
		CFrame = CFrame.new(rp.Position ,MP) 
	}, true);
	local sound = ReplicatedStorage.Sounds.startfireball:Clone()
	sound.Parent = char.Head
	sound:Play()
	game.Debris:AddItem(sound,5)
	wait(.05)
	local sound = ReplicatedStorage.Sounds.ballfly:Clone()
	sound.Parent =char.Head
	sound:Play()
	game.Debris:AddItem(sound,5)
-------------------Thit HitBox NOT TOUCH----------------------------------
	local FireBall = game.ReplicatedStorage.Effects.FireBall:Clone()
	FireBall.Parent = workspace
	FireBall.CFrame = rp.CFrame * CFrame.new(0,4,0.5)                 --Origin of fireball
	FireBall.CFrame = CFrame.new(FireBall.Position,MP)
	local Bv = Instance.new("BodyVelocity")
	Bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	Bv.Velocity =CFrame.new(FireBall.Position,MP).LookVector * 200   --Speed of travel
	

	Bv.Parent = FireBall

	FireBall.Anchored = false


	local ThunderSwarm = game.ReplicatedStorage.Effects.Wind:Clone()

	ThunderSwarm:SetPrimaryPartCFrame(CFrame.new(FireBall.Position,MP))
	ThunderSwarm.Parent = workspace.XUETA
	ReplicatedStorage.Remotes.Wind:FireAllClients(char,ThunderSwarm,.1,ThunderSwarm)
	local attack_debounce = false
	
	
	
	
	
	
	FireBall.FireBall.Touched:Connect(function(hit)


		if hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= player.Name   and hit.Parent.Name ~= "TheWorld" then
			FireBall:Destroy()
			local sh = char.shaker
			local attackget = hit.Parent.Humanoid:LoadAnimation(Animations.hit2fromfire);
			local ThunderSwarm = game.ReplicatedStorage.Effects.exp3:Clone()
			local sound = ReplicatedStorage.Sounds.Explosion2fire2:Clone()
			sound.Parent =hit.Parent.Head
			sound:Play()
		--	game.Debris:AddItem(sound,2)
			
			--ThunderSwarm:SetPrimaryPartCFrame(hit.Parent.HumanoidRootPart.CFrame)
			--ThunderSwarm.Parent = workspace.XUETA
			  ReplicatedStorage.Remotes.exp3:FireAllClients(char,ThunderSwarm,2,ThunderSwarm)

			local rememb = FireBall.CFrame
			spawn(function()
			sh.e.Value = 2
				sh.Disabled = false
				wait(1)
				sh.e.Value = 2
				sh.Disabled = true
			end)
			hit.Parent.Humanoid:TakeDamage(Damage)
			FireBall.CFrame = rememb
			local weld = Instance.new("WeldConstraint",FireBall)
			weld.Part0 = hit.Parent.HumanoidRootPart
			weld.Part1 = FireBall

			
			spawn(function()
				for i = 1,5 do 
					wait(1)
					local sound = ReplicatedStorage.Effects.bomb:Clone()
					sound.Parent = hit.Parent.Humanoid 
				
					game.Debris:AddItem(sound,10)
				hit.Parent.Humanoid:TakeDamage(Damage/2)
			end
			end)
			local yio = true
			
			
	
			attackget:Play()


			
	
		end


		if hit.Parent:FindFirstChild("Terrain")  then
			local baseplate = hit.Parent:FindFirstChild("Terrain")
			if hit.Name == baseplate.Name then
			print(hit.Parent)
			local rememb = FireBall.CFrame
				FireBall:Destroy()
				spawn(function()
					local sh = char.shaker
					sh.e.Value = 2
					sh.Disabled = false
					wait(1)
					sh.e.Value = 2
					sh.Disabled = true
				end)
				local earthinfire = game.ReplicatedStorage.Effects.earthinfire:Clone()
				earthinfire.Parent = workspace
				local sound = ReplicatedStorage.Sounds.Explosion2fire:Clone()
				sound.Parent =earthinfire
				sound:Play()
				game.Debris:AddItem(sound,20)
				local xyinia = true
				earthinfire.Touched:Connect(function(hit)
					if hit.Parent:FindFirstChild("Humanoid")   and hit.Parent.Name ~= "TheWorld" and xyinia == true then
						xyinia = false
						spawn(function()
							for i = 1,5 do 
								wait(1)
										local sound = ReplicatedStorage.Effects.bomb:Clone()
					sound.Parent = hit.Parent.UpperTorso
				
					game.Debris:AddItem(sound,1)
								hit.Parent.Humanoid:TakeDamage(Damage)
							end
						
						end)
						xyinia = false
						wait(1)
						xyinia= true
				end
				end)
				earthinfire.CFrame = rememb * CFrame.new(0,0,0) * CFrame.Angles(0,0,math.rad(90))
				
				game.Debris:AddItem(earthinfire,4,1)	
				local ThunderSwarm = game.ReplicatedStorage.Effects.exp3:Clone()
			
			ThunderSwarm:SetPrimaryPartCFrame(rememb)
			ThunderSwarm.Parent = workspace.XUETA
			ReplicatedStorage.Remotes.exp3:FireAllClients(char,ThunderSwarm,2,ThunderSwarm)
		
			end
		print(hit.Parent)
				local rememb = FireBall.CFrame
				FireBall:Destroy()
			spawn(function()
				local sh = char.shaker
				sh.e.Value = 2
				sh.Disabled = false
				wait(.1)
				sh.e.Value = 20
				sh.Disabled = true
			end)

				local ThunderSwarm = game.ReplicatedStorage.Effects.exp3:Clone()

				ThunderSwarm:SetPrimaryPartCFrame(rememb)
				ThunderSwarm.Parent = workspace.XUETA
				ReplicatedStorage.Remotes.exp3:FireAllClients(char,ThunderSwarm,2,ThunderSwarm)
				
			local sound = ReplicatedStorage.Sounds.Explosion2fire:Clone()
			sound.Parent = ThunderSwarm
			sound:Play()
			game.Debris:AddItem(sound,2)
		



		end




	end)

	Debris:AddItem(FireBall,5)
------------------------------------------------------------------------------
	wait(Length)
	

	StopPlayer(Hm, false)
		


	
		wait(CoolDown)

	return false
end


-----------------------------------------------------------//Spell2--------------------------------------------------------------------

remotes:WaitForChild("spell2").OnServerInvoke = function(player,tool,SAnimation,MP)
	local char = player.Character
	local Hm = char:WaitForChild("Humanoid")
	local to = char:WaitForChild("UpperTorso")
	local rp = char:WaitForChild("HumanoidRootPart")
	local leftarm = char:WaitForChild("LeftHand")
	local ra = char:WaitForChild("RightHand")

	----------------------------------------//Settings//-----------------------------------------

	local CoolDown = 0
	local Leght = .5
	local Damage = .5
	---------------------------------------------------------------------------------------------




	-------------------Thit HitBox NOT TOUCH----------------------------------
	local hitpointpart = Instance.new("Part",workspace)
	hitpointpart.Parent  = workspace
	hitpointpart.Anchored = true
	hitpointpart.CanCollide = false
	hitpointpart.CFrame = rp.CFrame
	hitpointpart.Transparency = 1
	hitpointpart.Size = Vector3.new(30,30,30)
	game.Debris:AddItem(hitpointpart,3)
	local deb = true
	hitpointpart.Touched:Connect(function(hit)


		if hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= player.Name and deb == true and not hit.Parent.HumanoidRootPart:FindFirstChild("Fire")  then
			local PoisonCloud = game.ReplicatedStorage.Effects.BlackSmoke1:Clone()
			PoisonCloud.Parent = workspace
			PoisonCloud.CFrame = hit.Parent.HumanoidRootPart.CFrame
			local charan = char.Humanoid:LoadAnimation(Animations.hit);
			charan:Play()
			ReplicatedStorage.Remotes.PoisonCloud:FireAllClients(player,PoisonCloud,2,PoisonCloud)
			spawn(function()
				local fire = game.ReplicatedStorage.Effects.BlackSmoke1:Clone()
				fire.Parent = hit.Parent.HumanoidRootPart
				fire.Name = "Fire"
				game.Debris:AddItem(fire,1)

				deb = false
				
				 
				
			end)
		end





	end)
	------------------------------------------------------------------------------
	wait(Leght)







	wait(CoolDown)

	return false
end







-----------------------------------------------------------//Spell??--------------------------------------------------------------------


remotes:WaitForChild("spell3").OnServerInvoke = function(player,tool,SAnimation,MP)
	local char = player.Character
	local Hm = char:WaitForChild("Humanoid")
	local to = char:WaitForChild("UpperTorso")
	local rp = char:WaitForChild("HumanoidRootPart")
	local leftarm = char:WaitForChild("LeftHand")
	local ra = char:WaitForChild("RightHand")

	----------------------------------------//Settings//-----------------------------------------

	local CoolDown = 0
	local Leght = .1
	local Damage = 10
	---------------------------------------------------------------------------------------------




	-------------------Thit HitBox NOT TOUCH----------------------------------
	local hitpointpart = Instance.new("Part",workspace)
	hitpointpart.Parent  = workspace
	hitpointpart.Anchored = false
	hitpointpart.CanCollide = false
	hitpointpart.CFrame = rp.CFrame
	hitpointpart.Transparency = 1
	hitpointpart.Size = Vector3.new(300,10,10)
	game.Debris:AddItem(hitpointpart,3)
	local deb = true
	hitpointpart.Touched:Connect(function(hit)


		if hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= player.Name and deb == true and not hit.Parent.HumanoidRootPart:FindFirstChild("Fire")  then
			local sharingan = game.ReplicatedStorage.Effects.BlackSmoke1:Clone()
			sharingan.Parent = workspace
			sharingan.CFrame = hit.Parent.HumanoidRootPart.CFrame
			local charan = char.Humanoid:LoadAnimation(Animations.hit);
			charan:Play()
			ReplicatedStorage.Remotes.sharingan:FireAllClients(player,sharingan,2,sharingan)
			spawn(function()
				local fire = game.ReplicatedStorage.Effects.BlackSmoke1:Clone()
				fire.Parent = hit.Parent.HumanoidRootPart
				fire.Name = "Fire"
				game.Debris:AddItem(fire,5)

				deb = false
				for i = 1,3 do 
					wait(.11) 
					hit.Parent.Humanoid:TakeDamage(Damage)
					



				end
			end)
		end





	end)
	------------------------------------------------------------------------------
	wait(Leght)







	wait(CoolDown)

	return false
end



-----------------------------------------------------------//Spell??--------------------------------------------------------------------





-----------------------------------------------------------//Spell??--------------------------------------------------------------------





-----------------------------------------------------------//Spell??--------------------------------------------------------------------





-----------------------------------------------------------//Spell??--------------------------------------------------------------------





-----------------------------------------------------------//Spell??--------------------------------------------------------------------
