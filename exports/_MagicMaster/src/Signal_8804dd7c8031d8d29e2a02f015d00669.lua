-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.Create(p1)
	return setmetatable({}, v1);
end;
function v1.Connect(p2, p3)
	p2[1] = p3;
end;
function v1.Fire(p4, ...)
	if not p4[1] then
		return;
	end;
	coroutine.resume(coroutine.create(p4[1]), ...);
end;
function v1.Destroy(p5)
	p5[1] = nil;
end;
return v1;
