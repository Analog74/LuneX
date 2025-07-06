-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = Vector3.new();
function v1.Solve(p1, p2)
	local v2 = p2.Instances[1];
	local v3 = v2.Position + v2.CFrame:VectorToWorldSpace(p2.Instances[2]);
	if not p2.LastPosition then
		p2.LastPosition = v3;
	end;
	p2.WorldSpace = v3;
	return p2.LastPosition, v3 - (p2.LastPosition or u1);
end;
function v1.UpdateToNextPosition(p3, p4)
	return p4.WorldSpace;
end;
function v1.Visualize(p5, p6)
	return CFrame.lookAt(p6.WorldSpace, p6.LastPosition);
end;
return v1;
