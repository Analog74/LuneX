--Revamped by TakeoHonorable

--Yet, another inspiration from some anime

--Totally like 6 risky bugs fixed by EunhaFlower
--Hotfix by EunhaFlower below:

--[[
	1. Permament Blind / Permament Color Correction
	2. Permament Magic Circle
	3. WalkSpeed, JumpPower after successfully summoned explosion
	4. Unlimited range screenshakes
	5. Permament ScreenGui (stuck in PlayerGui forever) 
	6. TagHumanoid 
--]]

--Takeo stop your buggy gears right there! - EunhaFlower

local Properties = {
	Max_Distance = 400, -- How far can you cast the ability
	Explosion_Radius = 75, -- The radius of the explosion being casted
	Casting_Time = 2, --How long until the ability comes out (in seconds)
	Reload = 2, --How long until the ability is ready (in seconds)
	DangerZone_Multiplier = 2 -- The multiplier of the size of the radius (used for secondary effects)
}

local WaitForChild, FindFirstChild, FindFirstChildOfClass = script.WaitForChild, script.FindFirstChild, script.FindFirstChildOfClass

local Clone, Destroy = script.Clone, script.Destroy

local Vec3, Reg3 = Vector3.new, Region3.new

local FindPartsInRegion3 = workspace.FindPartsInRegion3WithIgnoreList

local FindFirstAncestorWhichIsA = script.FindFirstAncestorWhichIsA

local IsA = script.IsA

local Services = {
	Players = (game:FindService("Players") or game:GetService("Players")),
	RunService = (game:FindService("RunService") or game:GetService("RunService")),
	Debris = (game:FindService("Debris") or game:GetService("Debris")),
	ServerScriptService = (game:FindService("ServerScriptService") or game:GetService("ServerScriptService"))
}

local Tool = script.Parent
Tool.Enabled = true

local Handle = WaitForChild(Tool,"Handle")

local IsGrounded = Handle.IsGrounded

local Instant = Instance.new
function Create(ty)
	return function(data)
		local obj = Instant(ty)
		for k, v in pairs(data) do
			if type(k) == 'number' then
				v.Parent = obj
			else
				obj[k] = v
			end
		end
		return obj
	end
end

function IsInTable(Table,Value)	
	for i=1,#Table,1 do
		if Table[i] == Value then
			return true
		end
	end
	return false
end

function IsTeamMate(Player1, Player2)
	return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and Player1.TeamColor == Player2.TeamColor)
end

function TagHumanoid(humanoid, player)
	local Creator_Tag = Instance.new("ObjectValue")
	Creator_Tag.Name = "creator"
	Creator_Tag.Value = player
	Services.Debris:AddItem(Creator_Tag, 2)
	Creator_Tag.Parent = humanoid
end

function UntagHumanoid(humanoid)
	for i, v in pairs(humanoid:GetChildren()) do
		if IsA(v,"ObjectValue") and v.Name == "creator" then
			Destroy(v)
		end
	end
end

local ScriptQueue = {}
function CastToPlayer(player,CurrentScript)
	
	if not player or not CurrentScript then return end
	
	pcall(function()
		local GUI = Instant("ScreenGui")
		GUI.ResetOnSpawn = false
		GUI.Name = "CrimsonChaosStaff_Client"
		GUI.Parent = FindFirstChildOfClass(player,"PlayerGui")
		CurrentScript = Clone(CurrentScript)
		ScriptQueue[#ScriptQueue+1] = CurrentScript
		CurrentScript.Parent = GUI
		CurrentScript.Disabled = false
		Services.Debris:AddItem(GUI, 90)
	end)
	
	return CurrentScript
end

local MousePos = (FindFirstChildOfClass(Tool,"RemoteFunction") or Create("RemoteFunction"){
		Name = "MousePos",
		Parent = Tool
	}
)

local Events, Deletables, Animations = {}, {}, {}

local Player, Character, Humanoid, Root

local Canceled = false

function Unequipped()
	
	Canceled = true
	for i=1,#Events,1 do
		if Events[i] then
			Events[i]:Disconnect()
		end
	end
	Events = {}
	
	for i=1,#Deletables,1 do
		if Deletables[i] then
			Destroy(Deletables[i])
		end
	end
	Deletables = {}
	
	for _,v in pairs(Animations) do
		if v then
			v:Stop()
		end
	end
	Animations = {}	
	
	coroutine.wrap(function()
		for i=1, #ScriptQueue,1 do
			if ScriptQueue[i] then
				pcall(function()
					ScriptQueue[i].Finish.Value = true
				end)
				Services.Debris:AddItem(ScriptQueue[i].Parent,3)
			end
		end
	end)()
	
	if Humanoid then
		Humanoid.WalkSpeed = 16
		Humanoid.JumpPower = 50
	end
	
end

local function IsCharacterFrozen(Character) -- Quick check to see if they're not frozen
	-- TakeoHonorable's Freeze function
	for Storage, Thing in pairs(Services.ServerScriptService:GetChildren()) do
		if Thing:IsA("Script") and Thing.Name == "Freeze" and Thing:FindFirstChild("Target") and Thing:FindFirstChild("Target").Value == Character then
			return true
		end
	end
	return false
end

local ImmobileUI
Tool.Equipped:Connect(function()
	
	Character = Tool.Parent
	
	if not Character then return end
	
	Humanoid = FindFirstChildOfClass(Character,"Humanoid")
	
	Root = FindFirstChild(Character,"HumanoidRootPart")
	
	if not Humanoid or Humanoid.Health <= 0 or not Root then return end
	
	Animations = {
		Cast = Humanoid:LoadAnimation(Tool:WaitForChild("Cast"..Humanoid.RigType.Name))
	}
	
	Player = Services.Players:GetPlayerFromCharacter(Character)
	
	local RightLimb = (FindFirstChild(Character,"Right Arm") or FindFirstChild(Character,"RightHand"))
	
	if RightLimb then
		Services.RunService.Heartbeat:Wait()
		if not Tool:IsDescendantOf(Character) then return end
		local RightGrip = FindFirstChild(RightLimb,"RightGrip")
		coroutine.wrap(function()
			--if not Tool:IsDescendantOf(Character) then return end
			local SwordMotor = Create("Motor6D"){
				Name = "RightGrip_Motor",
				Part0 = RightLimb,
				Part1 = Handle,
				C0 = RightGrip.C0,
				C1 = Tool.Grip
			}
			Deletables[#Deletables+1] = SwordMotor
			SwordMotor.Parent = RightLimb
		end)()
	
		coroutine.wrap(function()
			--Services.RunService.Heartbeat:Wait()
			local RightGrip = FindFirstChild(RightLimb,"RightGrip")
			if RightGrip then
				--Motor.C0 = RightGrip.C0
				--Motor.C1 = RightGrip.C1
				RightGrip.Part0 = nil
				RightGrip.Part1 = nil
			end
					
		end)()
	end
	
	if Player then
		Events[#Events+1] = Player.CharacterRemoving:Connect(Unequipped)
	end
	
	Events[#Events+1] = Humanoid.Died:Connect(Unequipped)
	
	Events[#Events+1] = Tool.Activated:Connect(function()
		
		if not Humanoid or Humanoid.Health <= 0 or Humanoid.Health == math.huge or not Tool.Enabled then return end
		
		Tool.Enabled = false
		
		Canceled = false
		
		local sucess,MousePosition = pcall(function() return MousePos:InvokeClient(Player) end)
		MousePosition = (sucess and MousePosition) or Vec3(0,0,0)
		
		local ray = Ray.new(Root.Position, ( MousePosition - Root.Position ).Unit * Properties.Max_Distance )
			
		local hit, pos, nor = workspace:FindPartOnRay(ray,Character)
			
		if not hit or not hit.CanCollide then Tool.Enabled = true return end
		
		
		Humanoid.WalkSpeed = 0
		
		local PreventSpeed = Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			Humanoid.WalkSpeed = 0
		end)
		
		Humanoid.JumpPower = 0
		
		local PreventJump = Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			Humanoid.JumpPower = 0
		end)
		
		local MovementEvents = {PreventSpeed, PreventJump} -- Added by EunhaFlower to fix walkspeed, jumppower problems
	
		Events[#Events+1] = PreventSpeed
		Events[#Events+1] = PreventJump
		
		spawn(function()
			
				
			
			local EffectScript = Clone(WaitForChild(script,"CastEffects"))
			
			--[[local Val = Instant("CFrameValue")
			Val.Name = "Character_Circle_Position"
			--Val.Value = 
			Val.Parent = EffectScript]]
			
			local Val = Instant("Vector3Value")
			Val.Name = "Character_Circle_Size"
			Val.Value = Vec3(1,0,1) * 20
			Val.Parent = EffectScript
			
			Val = Instant("ObjectValue")
			Val.Name = "ToolRef"
			Val.Value = Tool
			Val.Parent = EffectScript
			
			Val = Instant("ObjectValue")
			Val.Name = "Character_Center"
			Val.Value = Root
			Val.Parent = EffectScript
			
			Val = Instant("CFrameValue")
			Val.Name = "Cast_Circle_Position"
			Val.Value = CFrame.new(pos,pos+nor) * CFrame.Angles(-math.pi * .5,0,0)
			Val.Parent = EffectScript
			
			Val = Instant("Vector3Value")
			Val.Name = "Cast_Circle_Size"
			Val.Value = Vec3(1,0,1) * Properties.Explosion_Radius * 2
			Val.Parent = EffectScript
			
			Val = Instant("NumberValue")
			Val.Name = "Speed"
			Val.Value = Animations.Cast.Length/Properties.Casting_Time
			Val.Parent = EffectScript
			
			Val = Instant("BoolValue")
			Val.Name = "Finish"
			Val.Value = false
			Val.Parent = EffectScript
			
			--print(Animations.Cast.Length, Animations.Cast.Length/Properties.Casting_Time)
			Animations.Cast:Play(nil,nil,Animations.Cast.Length/Properties.Casting_Time)
			
			
			local Queue = {}
			for _,v in pairs(Services.Players:GetPlayers()) do
				-- I kinda disagree about it having limit range :/
				-- So I make it limit range 
				if v:IsA("Player") then
					Queue[#Queue+1] = CastToPlayer(v,EffectScript)
				end
							
			end
			
			
			coroutine.wrap(function()
				wait(Properties.Casting_Time)
				for i=1, #Queue,1 do
					if Queue[i] then
						pcall(function()
							Queue[i].Finish.Value = true
						end)
						Services.Debris:AddItem(Queue[i].Parent,3);
						Queue[i] = nil;
					end
				end
				Queue = nil
			end)()
			local C_T = 0
			while Animations.Cast and C_T < 5.5 / (Animations.Cast.Length/Properties.Casting_Time) and not Canceled do
				C_T = C_T + 0.15
				Services.RunService.Heartbeat:Wait()
			end
			if not Animations.Cast or C_T < 5.5/(Animations.Cast.Length/Properties.Casting_Time) then		
				delay(3, function()
					Tool.Enabled = true
					if PreventSpeed then
						PreventSpeed:Disconnect();PreventSpeed = nil
					end
					if PreventJump then
						PreventJump:Disconnect();PreventJump = nil
					end
					if Humanoid then
						Humanoid.WalkSpeed = 16
					end
					if Humanoid then
						Humanoid.JumpPower = 50 -- Bro takeo, What did you miss
					end
					if ImmobileUI then
						Destroy(ImmobileUI)
					end
				end)
				return 
			end
			delay(Properties.Reload, function()
				Tool.Enabled = true
				if PreventSpeed then
					PreventSpeed:Disconnect();PreventSpeed = nil
				end
				if Humanoid then
					Humanoid.WalkSpeed = 16
				end
				if Humanoid then
					Humanoid.JumpPower = 50
				end
				if ImmobileUI then
					Destroy(ImmobileUI)
				end
			end)
			--warn("EXPLOSION!!!")
			
			--[[Keeping the user immobilized until the staff is ready or until your unequip it
			To whoever is reading this.. Yes .. This is another nod to a character in a certain anime...]]
			
			--Put UI over the user's head to let them know they're immobilized
			
			if Humanoid and Tool:IsDescendantOf(Character) then -- Takeo you need to fix your buggy gears
				-- Walkspeed, JumpPower fixed after summoning explosion
				-- Added by EunhaFlower
				
				if #MovementEvents > 0 then
					for i=1,#MovementEvents do
						if MovementEvents[i] then
							MovementEvents[i]:Disconnect();
							MovementEvents[i] = nil
						end
					end
					MovementEvents = nil
				end 
				Humanoid.WalkSpeed = 16
				Humanoid.JumpPower = 50
			end
			
			pcall(function()
				ImmobileUI = Clone(script:WaitForChild("ImmobileUI"))
				Deletables[#Deletables+1] = ImmobileUI
				ImmobileUI.Adornee = Character.Head
				ImmobileUI.Parent = script
				ImmobileUI.Enabled = true
				Services.Debris:AddItem(ImmobileUI, 120)
			end)
			
			EffectScript = Clone(WaitForChild(script,"ExplosionEffect"))
			
			Val = Instant("Vector3Value")
			Val.Name = "Explosion_Position"
			Val.Value = pos
			Val.Parent = EffectScript
			
			Val = Instant("NumberValue")
			Val.Name = "Explosion_Size"
			Val.Value = Properties.Explosion_Radius * 2
			Val.Parent = EffectScript
			--local ExplosionQueue = {}
			
			local Ignore = {}
			for _,v in pairs(Services.Players:GetPlayers()) do
				Services.Debris:AddItem(CastToPlayer(v,EffectScript),8)
				if v and v.Character and (v == Player or IsTeamMate(Player,v)) then
					Ignore[#Ignore+1] = v.Character
				end
			end
			
			local Neg, Pos = pos - Vec3(1,1,1) * Properties.Explosion_Radius * Properties.DangerZone_Multiplier, pos + Vec3(1,1,1) * Properties.Explosion_Radius * Properties.DangerZone_Multiplier
			
			local Parts = FindPartsInRegion3(workspace,Reg3(Neg,Pos),Ignore,math.huge)
			
			local Hums = {}
			
			local Velo = Instant("BodyVelocity")
			Velo.MaxForce = Vec3(1,1,1) * math.huge
			
			for i=1,#Parts,1 do
				
				if Parts[i] and Parts[i].Parent and (Parts[i].Position-pos).Magnitude <= Properties.Explosion_Radius * Properties.DangerZone_Multiplier then
					
					local Hum, FF = FindFirstChildOfClass(Parts[i].Parent,"Humanoid"), FindFirstChildOfClass(Parts[i].Parent,"ForceField")
					
					local Proximity = (Parts[i].Position-pos).Magnitude/(Properties.Explosion_Radius * Properties.DangerZone_Multiplier)
					
					if Hum and not FF and not IsInTable(Hums,Hum) and not IsTeamMate(Player,Services.Players:GetPlayerFromCharacter(Hum.Parent)) then
						Hums[#Hums+1] = Hum
						
						--print(math.floor((Parts[i].Position-pos).Magnitude))
						
						
						if Proximity <= .5 then
							--//Pretty much death right here
							--warn("Death for " .. Hum.Parent.Name)
							UntagHumanoid(Hum)
							-- Takeo forgot to put Player into TagHumanoid() :/
							local tag = TagHumanoid(Hum, Player) -- Fixed by EunhaFlower
							
							local Freeze = Clone(script:WaitForChild("Freeze"))
							
							if Hum and Hum.Parent and not IsCharacterFrozen(Hum.Parent) then
								Freeze:WaitForChild("Creator",10).Value = Player
								Freeze:WaitForChild("Target",10).Value = Hum.Parent
								Freeze.Parent = Services.ServerScriptService
								Freeze.Disabled = false
							end
							
							Freeze = nil
							
							Hum:TakeDamage(100)
							Services.Debris:AddItem(tag, 2)
						else
							--//Induce moderate damage + temporary yet, lengthy burn damage
							--warn("Moderate Burn Damage + Knockback for " .. Hum.Parent.Name)
							--local BurnScript = Clone(script:WaitForChild("Burn"))
							
							--[[local Creator = Instant("ObjectValue")
							Creator.Name = "Creator"
							Creator.Value = Player
							Creator.Parent = BurnScript
							
							BurnScript.Parent = Hum.Parent
							BurnScript.Disabled = false
							UntagHumanoid(Hum)]]
							
							local Freeze = Clone(script:WaitForChild("Freeze"))
							
							if Hum and Hum.Parent and not IsCharacterFrozen(Hum.Parent) and Random.new(tick()):NextInteger(0, 100) <= 30 then
								Freeze:WaitForChild("Creator",10).Value = Player
								Freeze:WaitForChild("Target",10).Value = Hum.Parent
								Freeze.Parent = Services.ServerScriptService
								Freeze.Disabled = false
							end
							
							Freeze = nil
							
							
							
							
							-- I can't imagine you forgot to put Player into taghumanoid
							local tag = TagHumanoid(Hum, Player) -- Fixed by EunhaFlower
							Hum:TakeDamage(50)
							Services.Debris:AddItem(tag, 2)
							--Put burn damage here
						end
						

						
						--[[Hums[#Hums+1] = Hum
						UntagHumanoid(Hum)
						TagHumanoid(Hum)
						Hum:TakeDamage(Hum.MaxHealth)]]
						
					end
					
					
				end
				
			end
			
		end)
		
	end)
	
end)

Tool.Unequipped:Connect(Unequipped)
