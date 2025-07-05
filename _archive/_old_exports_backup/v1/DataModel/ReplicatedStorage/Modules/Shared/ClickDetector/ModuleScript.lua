--[=[
	
	Example usage:
	
local ClickDetector = require(script.ClickDetector)

local Part = ClickDetector.new(workspace:WaitForChild("Part"))
	Part.MaxActivationDistance = 15
	Part.CursorIcon = "http://www.roblox.com/asset/?id=4317746479"

	Part.MouseEnter:Connect(function()
		print("Entered part")
	end)
	Part.MouseLeave:Connect(function()
		print("Left part")
	end)
	
	Part.MouseButton1Down:Connect(function()
		print("Clicked part")
	end)
	
	
--]=]


local ClickDetector = {}


local UIS = game:GetService("UserInputService")

local BINDABLE = Instance.new("BindableEvent")

local Cam = workspace.CurrentCamera
local Plr = game.Players.LocalPlayer
local Mouse = Plr:GetMouse()
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")



local ActiveDetectors,CurrentHover,last_t,last_i = {},nil,nil,Mouse.Icon

Cam:GetPropertyChangedSignal("CFrame"):Connect(function()

	local h = ActiveDetectors[last_t]

	if h then
		if (HRP.Position - h._Internal.Adornee.Position).Magnitude <=h.MaxActivationDistance and h.Enabled then
			--Within distance
			if not h.Hovering then
				-- not yet set to hover, do it
				rawset(h, "Hovering", true)
				h._Internal.EnterEvent:Fire()

				Mouse.Icon = h.CursorIcon or ""

				CurrentHover = h
			end
		else
			-- Far away
			if h.Hovering then
				-- set to hover, undo
				rawset(h, "Hovering", false)
				h._Internal.LeaveEvent:Fire()

				Mouse.Icon = ""

				if CurrentHover == h then
					CurrentHover = nil
				end
			end
		end
	end

end)

UIS.InputChanged:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseMovement then

		-- Handle hover detection
		local t = Mouse.Target

		if t ~= last_t then last_t = t
			local h = ActiveDetectors[t]

			-- Leave old
			if CurrentHover and CurrentHover._Internal.Adornee ~= t then
				rawset(CurrentHover, "Hovering", false)
				CurrentHover._Internal.LeaveEvent:Fire()

				Mouse.Icon = ""
			end

			-- Enter new
			if h and (HRP.Position - h._Internal.Adornee.Position).Magnitude <=h.MaxActivationDistance and h.Enabled then
				rawset(h, "Hovering", true)
				h._Internal.EnterEvent:Fire()

				Mouse.Icon = h.CursorIcon or ""

				CurrentHover = h
			else
				CurrentHover =  nil
			end
		end

	end
end)
UIS.InputBegan:Connect(function(Input,GP)

	if not CurrentHover then return end

	if Input.UserInputType == Enum.UserInputType.MouseButton1 then

		CurrentHover._Internal.Button1DownEvent:Fire()

	elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then

		CurrentHover._Internal.Button2DownEvent:Fire()

	end
end)
UIS.InputEnded:Connect(function(Input,GP)

	if not CurrentHover then return end

	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		CurrentHover._Internal.Button1UpEvent:Fire()
	elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
		CurrentHover._Internal.Button2UpEvent:Fire()
	end
end)


function ClickDetector.new(BasePart)

	--Type check
	if typeof(BasePart)~="Instance" or not BasePart:IsA("BasePart") then
		error("Invalid BasePart for click detection "..BasePart,2)
	end

	local EnterEvent = BINDABLE:Clone()
	local LeaveEvent = BINDABLE:Clone()

	local Button1DownEvent = BINDABLE:Clone()
	local Button2DownEvent = BINDABLE:Clone()

	local Button1UpEvent = BINDABLE:Clone()
	local Button2UpEvent = BINDABLE:Clone()

	local Detector = {

		Enabled		= true;
		MaxActivationDistance = 32;
		CursorIcon	= "";

		Hovering	= false;


		MouseEnter	= EnterEvent.Event;
		MouseLeave	= LeaveEvent.Event;

		MouseButton1Down	= Button1DownEvent.Event;
		MouseButton2Down	= Button2DownEvent.Event;

		MouseButton1Up	= Button1UpEvent.Event;
		MouseButton2Up	= Button2UpEvent.Event;



		_Internal	= {
			EnterEvent = EnterEvent;
			LeaveEvent = LeaveEvent;

			Button1DownEvent	= Button1DownEvent;
			Button2DownEvent	= Button2DownEvent;

			Button1UpEvent	= Button1UpEvent;
			Button2UpEvent	= Button2UpEvent;

			Adornee		= BasePart;
		};

	}

	function Detector:Destroy()

		ActiveDetectors[self._Internal.Adornee] = nil

		EnterEvent:Destroy()
		LeaveEvent:Destroy()

		Button1UpEvent:Destroy()
		Button2UpEvent:Destroy()

		if self.Hovering then
			Mouse.Icon = ""
		end

		self._Internal.Adornee = nil
	end

	-- Catch inputs
	ActiveDetectors[BasePart] = Detector

	return Detector
end

return ClickDetector