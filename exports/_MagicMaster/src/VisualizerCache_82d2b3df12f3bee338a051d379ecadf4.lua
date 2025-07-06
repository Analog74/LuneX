-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
v1.__type = "RaycastHitboxVisualizerCache";
v1._AdornmentInUse = {};
v1._AdornmentInReserve = {};
local u1 = Color3.fromRGB(255, 0, 0);
local u2 = CFrame.new(0, math.huge, 0);
function v1._CreateAdornment(p1)
	local v2 = Instance.new("LineHandleAdornment");
	v2.Name = "_RaycastHitboxDebugLine";
	v2.Color3 = u1;
	v2.Thickness = 4;
	v2.Length = 0;
	v2.CFrame = u2;
	v2.Adornee = workspace.Terrain;
	v2.Parent = workspace.Terrain;
	return {
		Adornment = v2, 
		LastUse = 0
	};
end;
function v1.GetAdornment(p2)
	if #v1._AdornmentInReserve <= 0 then
		table.insert(v1._AdornmentInReserve, (v1:_CreateAdornment()));
	end;
	local v3 = table.remove(v1._AdornmentInReserve, 1);
	if v3 then
		v3.Adornment.Visible = true;
		v3.LastUse = os.clock();
		table.insert(v1._AdornmentInUse, v3);
	end;
	return v3;
end;
function v1.ReturnAdornment(p3, p4)
	p4.Adornment.Length = 0;
	p4.Adornment.Visible = false;
	p4.Adornment.CFrame = u2;
	table.insert(v1._AdornmentInReserve, p4);
end;
function v1.Clear(p5)
	for v4 = #v1._AdornmentInReserve, 1, -1 do
		if v1._AdornmentInReserve[v4].Adornment then
			v1._AdornmentInReserve[v4].Adornment:Destroy();
		end;
		table.remove(v1._AdornmentInReserve, v4);
	end;
end;
return v1;
