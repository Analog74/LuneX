-- Decompiled with the Synapse X Luau decompiler.

return {
	Solve = function(p1, p2)
		return p2.Instances[1].WorldPosition, p2.Instances[2].WorldPosition - p2.Instances[1].WorldPosition;
	end, 
	UpdateToNextPosition = function(p3, p4)
		return p4.Instances[1].WorldPosition;
	end, 
	Visualize = function(p5, p6)
		return CFrame.lookAt(p6.Instances[1].WorldPosition, p6.Instances[2].WorldPosition);
	end
};
