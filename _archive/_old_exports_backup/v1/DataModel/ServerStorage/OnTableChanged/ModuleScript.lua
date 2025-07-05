-- Confused? Here's the documentation: https://devforum.roblox.com/t/ontablechanged-know-when-your-table-key-value-has-been-re-assigned/1435614

local OnTableChanged = {}
local dummies = {} 

function OnTableChanged:ActivateTable(t)
	local tableID = tostring(t)
	local dummy = dummies[tableID] or {}

	if (not getmetatable(dummy)) then
		dummy.callbacks = {}
		dummy.TID = tableID

		dummy.__index = function(_,i)
			return t[i]
		end

		dummy.__newindex = function(_,i,v)
			t[i] = v

			if (not dummy.callbacks[i]) or (dummy.callbacks[i] and #dummy.callbacks[i] < 1) then return end

			for _ , callback in ipairs(dummy.callbacks[i]) do
				task.spawn(function()
					callback(v)
				end)
			end

		end

		setmetatable(dummy,dummy)
		dummies[tableID] = dummy
	end

	return dummy
end

function OnTableChanged.__call(_,t,i,callback)
	local dummy = dummies[t.TID]
	if (not dummy) then
		warn("[OnTableChanged] Table needs to be activated with :ActivateTable first")
		return
	end
	
	if (not dummy.callbacks[i]) then
		dummy.callbacks[i] = {}
	end
	
	table.insert(dummy.callbacks[i],callback)

	local Connection = {}
	
	function Connection:Disconnect()
		table.remove(dummy.callbacks[i],table.find(dummy.callbacks[i],callback))
	end
		
	return Connection
end


return setmetatable(OnTableChanged , OnTableChanged)