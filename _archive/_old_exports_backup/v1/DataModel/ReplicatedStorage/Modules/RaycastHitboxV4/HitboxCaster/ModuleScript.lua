-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
v1.__type = "RaycastHitbox";
v1.CastModes = {
	LinkAttachments = 1, 
	Attachment = 2, 
	Vector3 = 3, 
	Bone = 4
};
function v1.HitStart(p1, p2)
	if p1.HitboxActive then
		p1:HitStop();
	end;
	if p2 then
		p1.HitboxStopTime = os.clock() + math.max(0.016666666666666666, p2);
	end;
	p1.HitboxActive = true;
end;
function v1.HitStop(p3)
	p3.HitboxActive = false;
	p3.HitboxStopTime = 0;
	table.clear(p3.HitboxHitList);
end;
local l__CollectionService__1 = game:GetService("CollectionService");
function v1.Destroy(p4)
	p4.HitboxPendingRemoval = true;
	if p4.HitboxObject then
		l__CollectionService__1:RemoveTag(p4.HitboxObject, p4.Tag);
	end;
	p4:HitStop();
	p4.OnHit:Destroy();
	p4.OnUpdate:Destroy();
end;
function v1.Recalibrate(p5)
	local v2 = 0;
	for v3, v4 in ipairs((p5.HitboxObject:GetDescendants())) do
		if v4:IsA("Attachment") and v4.Name == "DmgPoint" then
			local v5 = p5:_CreatePoint(v4:GetAttribute("Group"), v1.CastModes.Attachment, v4.WorldPosition);
			table.insert(v5.Instances, v4);
			table.insert(p5.HitboxRaycastPoints, v5);
			v2 = v2 + 1;
		end;
	end;
	if p5.DebugLog then
		print(string.format("%s%s", "[ Raycast Hitbox V4 ]\n", v2 > 0 and string.format("%s attachments found in object: %s.", v2, p5.HitboxObject.Name) or string.format("No attachments found in object: %s. Can be safely ignored if using SetPoints.", p5.HitboxObject.Name)));
	end;
end;
function v1.LinkAttachments(p6, p7, p8)
	local v6 = p6:_CreatePoint(p7:GetAttribute("Group"), v1.CastModes.LinkAttachments);
	v6.Instances[1] = p7;
	v6.Instances[2] = p8;
	table.insert(p6.HitboxRaycastPoints, v6);
end;
function v1.UnlinkAttachments(p9, p10)
	for v7 = #p9.HitboxRaycastPoints, 1, -1 do
		if #p9.HitboxRaycastPoints[v7].Instances >= 2 and (p9.HitboxRaycastPoints[v7].Instances[1] == p10 or p9.HitboxRaycastPoints[v7].Instances[2] == p10) then
			table.remove(p9.HitboxRaycastPoints, v7);
		end;
	end;
end;
function v1.SetPoints(p11, p12, p13, p14)
	for v8, v9 in ipairs(p13) do
		if p12:IsA("Bone") then
			local v10 = "Bone";
		else
			v10 = "Vector3";
		end;
		local v11 = p11:_CreatePoint(p14, v1.CastModes[v10]);
		v11.Instances[1] = p12;
		v11.Instances[2] = v9;
		table.insert(p11.HitboxRaycastPoints, v11);
	end;
end;
function v1.RemovePoints(p15, p16, p17)
	for v12 = #p15.HitboxRaycastPoints, 1, -1 do
		if p15.HitboxRaycastPoints[v12].Instances[1] == p16 then
			local v13 = p15.HitboxRaycastPoints[v12].Instances[2];
			for v14, v15 in ipairs(p17) do
				if v15 == v13 then
					table.remove(p15.HitboxRaycastPoints, v12);
					break;
				end;
			end;
		end;
	end;
end;
function v1._CreatePoint(p18, p19, p20, p21)
	return {
		Group = p19, 
		CastMode = p20, 
		LastPosition = p21, 
		WorldSpace = nil, 
		Instances = {}
	};
end;
local u2 = {};
function v1._FindHitbox(p22, p23)
	for v16, v17 in ipairs(u2) do
		if v17.HitboxObject == p23 then
			return v17;
		end;
	end;
end;
function v1._Init(p24)
	if not p24.HitboxObject then
		return;
	end;
	local u3 = nil;
	p24:Recalibrate();
	table.insert(u2, p24);
	l__CollectionService__1:AddTag(p24.HitboxObject, p24.Tag);
	u3 = l__CollectionService__1:GetInstanceRemovedSignal(p24.Tag):Connect(function(p25)
		if p25 == p24.HitboxObject then
			u3:Disconnect();
			p24:Destroy();
		end;
	end);
end;
local l__Solvers__4 = script.Parent:WaitForChild("Solvers");
local l__Heartbeat__5 = game:GetService("RunService").Heartbeat;
local u6 = require(script.Parent.VisualizerCache);
(function()
	local u7 = table.create(#l__Solvers__4:GetChildren());
	l__Heartbeat__5:Connect(function(p26)
		for v18 = #u2, 1, -1 do
			if u2[v18].HitboxPendingRemoval then
				setmetatable(table.remove(u2, v18), nil);
			else
				for v19, v20 in ipairs(u2[v18].HitboxRaycastPoints) do
					if not u2[v18].HitboxActive then
						v20.LastPosition = nil;
					else
						local v21 = u7[v20.CastMode];
						local v22, v23 = v21:Solve(v20);
						local v24 = workspace:Raycast(v22, v23, u2[v18].RaycastParams);
						if u2[v18].Visualizer then
							local v25 = u6:GetAdornment();
							if v25 then
								v25.Adornment.Length = v23.Magnitude;
								v25.Adornment.CFrame = v21:Visualize(v20);
							end;
						end;
						v20.LastPosition = v21:UpdateToNextPosition(v20);
						if v24 then
							local v26 = nil;
							local v27 = nil;
							local v28 = nil;
							local v29 = nil;
							local v30 = nil;
							local v31 = nil;
							local v32 = nil;
							local v33 = nil;
							local v34 = nil;
							local v35 = nil;
							local v36 = nil;
							local v37 = nil;
							local v38 = nil;
							local v39 = nil;
							local v40 = nil;
							local v41 = nil;
							local v42 = nil;
							local v43 = nil;
							local v44 = nil;
							local v45 = nil;
							local v46 = nil;
							local v47 = nil;
							local l__Instance__48 = v24.Instance;
							local v49 = nil;
							if u2[v18].DetectionMode == 1 then
								local v50 = l__Instance__48:FindFirstAncestorOfClass("Model");
								if v50 then
									v49 = v50:FindFirstChildOfClass("Humanoid");
								end;
								local v51 = v49;
							else
								v51 = l__Instance__48;
							end;
							if v51 then
								local v52 = nil;
								local v53 = nil;
								local v54 = nil;
								local v55 = nil;
								local v56 = nil;
								local v57 = nil;
								local v58 = nil;
								local v59 = nil;
								local v60 = nil;
								local v61 = nil;
								local v62 = nil;
								local v63 = nil;
								local v64 = nil;
								local v65 = nil;
								local v66 = nil;
								local v67 = nil;
								local v68 = nil;
								local v69 = nil;
								local v70 = nil;
								local v71 = nil;
								local v72 = nil;
								local v73 = nil;
								local v74 = nil;
								local v75 = nil;
								local v76 = nil;
								if u2[v18].DetectionMode <= 2 then
									if not u2[v18].HitboxHitList[v51] then
										u2[v18].HitboxHitList[v51] = true;
										v52 = u2;
										v53 = v52;
										v54 = v18;
										v55 = v53[v54];
										v56 = "OnHit";
										v57 = v55;
										v58 = v56;
										v64 = v57[v58];
										v59 = l__Instance__48;
										local v77 = v59;
										v60 = v49;
										v68 = v60;
										v61 = v24;
										v69 = v61;
										local v78 = "Group";
										v62 = v20;
										v63 = v78;
										v70 = v62[v63];
										local v79 = "Fire";
										v65 = v64;
										local v80 = v65;
										v66 = v64;
										v67 = v79;
										local v81 = v66[v67];
										v71 = v81;
										v72 = v80;
										v73 = v77;
										v74 = v68;
										v75 = v69;
										v76 = v70;
										v71(v72, v73, v74, v75, v76);
										v26 = u2;
										v27 = v26;
										v28 = v18;
										v29 = v27[v28];
										v30 = "HitboxStopTime";
										v31 = v29;
										v32 = v30;
										v33 = v31[v32];
										local v82 = 0;
										v34 = v82;
										v35 = v33;
										if v34 < v35 and u2[v18].HitboxStopTime <= os.clock() then
											u2[v18].HitboxStopTime = 0;
											u2[v18]:HitStop();
										end;
										local v83 = u2;
										v36 = v83;
										v37 = v18;
										local v84 = v36[v37];
										local v85 = "OnUpdate";
										v38 = v84;
										v39 = v85;
										local v86 = v38[v39];
										local v87 = "LastPosition";
										v40 = v20;
										v41 = v87;
										local v88 = v40[v41];
										local v89 = "Fire";
										v42 = v86;
										local v90 = v42;
										v43 = v86;
										v44 = v89;
										local v91 = v43[v44];
										v45 = v91;
										v46 = v90;
										v47 = v88;
										v45(v46, v47);
									end;
								else
									v52 = u2;
									v53 = v52;
									v54 = v18;
									v55 = v53[v54];
									v56 = "OnHit";
									v57 = v55;
									v58 = v56;
									v64 = v57[v58];
									v59 = l__Instance__48;
									v77 = v59;
									v60 = v49;
									v68 = v60;
									v61 = v24;
									v69 = v61;
									v78 = "Group";
									v62 = v20;
									v63 = v78;
									v70 = v62[v63];
									v79 = "Fire";
									v65 = v64;
									v80 = v65;
									v66 = v64;
									v67 = v79;
									v81 = v66[v67];
									v71 = v81;
									v72 = v80;
									v73 = v77;
									v74 = v68;
									v75 = v69;
									v76 = v70;
									v71(v72, v73, v74, v75, v76);
									v26 = u2;
									v27 = v26;
									v28 = v18;
									v29 = v27[v28];
									v30 = "HitboxStopTime";
									v31 = v29;
									v32 = v30;
									v33 = v31[v32];
									v82 = 0;
									v34 = v82;
									v35 = v33;
									if v34 < v35 and u2[v18].HitboxStopTime <= os.clock() then
										u2[v18].HitboxStopTime = 0;
										u2[v18]:HitStop();
									end;
									v83 = u2;
									v36 = v83;
									v37 = v18;
									v84 = v36[v37];
									v85 = "OnUpdate";
									v38 = v84;
									v39 = v85;
									v86 = v38[v39];
									v87 = "LastPosition";
									v40 = v20;
									v41 = v87;
									v88 = v40[v41];
									v89 = "Fire";
									v42 = v86;
									v90 = v42;
									v43 = v86;
									v44 = v89;
									v91 = v43[v44];
									v45 = v91;
									v46 = v90;
									v47 = v88;
									v45(v46, v47);
								end;
							else
								v26 = u2;
								v27 = v26;
								v28 = v18;
								v29 = v27[v28];
								v30 = "HitboxStopTime";
								v31 = v29;
								v32 = v30;
								v33 = v31[v32];
								v82 = 0;
								v34 = v82;
								v35 = v33;
								if v34 < v35 and u2[v18].HitboxStopTime <= os.clock() then
									u2[v18].HitboxStopTime = 0;
									u2[v18]:HitStop();
								end;
								v83 = u2;
								v36 = v83;
								v37 = v18;
								v84 = v36[v37];
								v85 = "OnUpdate";
								v38 = v84;
								v39 = v85;
								v86 = v38[v39];
								v87 = "LastPosition";
								v40 = v20;
								v41 = v87;
								v88 = v40[v41];
								v89 = "Fire";
								v42 = v86;
								v90 = v42;
								v43 = v86;
								v44 = v89;
								v91 = v43[v44];
								v45 = v91;
								v46 = v90;
								v47 = v88;
								v45(v46, v47);
							end;
						else
							v26 = u2;
							v27 = v26;
							v28 = v18;
							v29 = v27[v28];
							v30 = "HitboxStopTime";
							v31 = v29;
							v32 = v30;
							v33 = v31[v32];
							v82 = 0;
							v34 = v82;
							v35 = v33;
							if v34 < v35 and u2[v18].HitboxStopTime <= os.clock() then
								u2[v18].HitboxStopTime = 0;
								u2[v18]:HitStop();
							end;
							v83 = u2;
							v36 = v83;
							v37 = v18;
							v84 = v36[v37];
							v85 = "OnUpdate";
							v38 = v84;
							v39 = v85;
							v86 = v38[v39];
							v87 = "LastPosition";
							v40 = v20;
							v41 = v87;
							v88 = v40[v41];
							v89 = "Fire";
							v42 = v86;
							v90 = v42;
							v43 = v86;
							v44 = v89;
							v91 = v43[v44];
							v45 = v91;
							v46 = v90;
							v47 = v88;
							v45(v46, v47);
						end;
					end;
				end;
			end;
		end;
		local v92 = #u6._AdornmentInUse;
		if v92 > 0 then
			for v93 = v92, 1, -1 do
				if os.clock() - u6._AdornmentInUse[v93].LastUse >= 0.25 then
					local v94 = table.remove(u6._AdornmentInUse, v93);
					if v94 then
						u6:ReturnAdornment(v94);
					end;
				end;
			end;
		end;
	end);
	for v95, v96 in pairs(v1.CastModes) do
		local v97 = l__Solvers__4:FindFirstChild(v95);
		if v97 then
			u7[v96] = require(v97);
		end;
	end;
end)();
return v1;
