local Debounce = false
while wait() do
	if script.Parent.Visible == true and Debounce == false and script.Enable.Value == true then
		script.Parent.Size = UDim2.new(1, 1,1, 1)
		script.Parent:TweenSize(UDim2.new(0, 1,1, 1),"Out","Linear",script.Cooldown.Value,true)
		Debounce = true
		wait(script.Cooldown.Value)
		script.Parent.Size = UDim2.new(1, 1,1, 1)
		script.Parent.Visible = false
		Debounce = false
		script.Enable.Value = false
	end
end