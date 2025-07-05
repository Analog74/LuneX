local remote = game.ReplicatedStorage.Remotes


remote.Wind.OnClientEvent:Connect(function(player,cop,dira,Parent)

	
	local l__Twirl__1 = Parent:WaitForChild("Twirl");
spawn(function()
		for v2 = 1, 50 do
			if not workspace:FindFirstChild("TimeStop") then
		l__Twirl__1.CFrame = l__Twirl__1.CFrame * CFrame.Angles(0, 0, 0.5);
		l__Twirl__1.Size = l__Twirl__1.Size + Vector3.new(1, 1, 2);
		l__Twirl__1.Transparency = l__Twirl__1.Transparency + 0.02;
				wait();
				end
	end;
end);
for v3 = 1, 4 do
	local u2 = Parent["WindBeamEffect" .. v3];
	spawn(function()
		for v4 = 1, 20 do
			u2.Attachment1.Position = Vector3.new(0, 0, v4 / 1.5);
			u2.Attachment2.Position = Vector3.new(0, 0, -v4 / 1.5);
			u2.Beams.Beam1.CurveSize0 = v4;
			u2.Beams.Beam1.CurveSize1 = -v4;
			u2.Beams.Beam2.CurveSize0 = -v4;
			u2.Beams.Beam2.CurveSize1 = v4;
			u2.Beams.Beam1.Transparency = NumberSequence.new(v4 / 20);
			u2.Beams.Beam2.Transparency = NumberSequence.new(v4 / 20);
			wait();
		end;
	end);
	wait(0.1);
end;
wait(1);
Parent:Destroy();
end)