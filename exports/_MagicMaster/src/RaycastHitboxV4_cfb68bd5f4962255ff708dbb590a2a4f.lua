-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
v1.__type = "RaycastHitboxModule";
v1.DetectionMode = {
	Default = 1, 
	PartMode = 2, 
	Bypass = 3
};
local l__CollectionService__1 = game:GetService("CollectionService");
local u2 = require(script.HitboxCaster);
local u3 = require(script.Signal);
function v1.new(p1)
	if p1 and l__CollectionService__1:HasTag(p1, "_RaycastHitboxV4Managed") then
		return u2:_FindHitbox(p1);
	end;
	local v2 = setmetatable({
		RaycastParams = nil, 
		DetectionMode = v1.DetectionMode.Default, 
		HitboxRaycastPoints = {}, 
		HitboxPendingRemoval = false, 
		HitboxStopTime = 0, 
		HitboxObject = p1, 
		HitboxHitList = {}, 
		HitboxActive = false, 
		Visualizer = true, 
		DebugLog = true, 
		OnUpdate = u3:Create(), 
		OnHit = u3:Create(), 
		Tag = "_RaycastHitboxV4Managed"
	}, u2);
	v2:_Init();
	return v2;
end;
function v1.GetHitbox(p2, p3)
	if not p3 then
		return;
	end;
	return u2:_FindHitbox(p3);
end;
return v1;
