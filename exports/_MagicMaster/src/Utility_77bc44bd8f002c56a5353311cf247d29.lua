local Utility = {}

local RunService = game:GetService("RunService")

local ancestor = script:FindFirstAncestor("QuickNetwork")

local Settings = require(ancestor.Settings)
local Constants = require(ancestor.Constants)

local MAX_TRIES = Constants.MAX_TRIES
local WRITE_COOLDOWN_INTERVAL = Constants.WRITE_COOLDOWN_INTERVAL

local function DeepCopyTable(tabl)
	local copiedTable = {}

	for key, value in pairs(tabl) do
		copiedTable[key] = typeof(value) == "table" and DeepCopyTable(value) or value
	end

	return copiedTable
end

local function HeartbeatWait(yield)
	yield = yield or RunService.Heartbeat:Wait()
	local dtPassed = 0

	while true do
		if dtPassed >= yield then
			return dtPassed
		end
		
		dtPassed += RunService.Heartbeat:Wait()
	end	
end

local function Session_Locked(data)
	return data.MetaData and os.time() - data.MetaData.SessionJobTime < Settings.AssumeDeadSessionLock
end

local function SerializeData(data)
	for key, value in pairs(data) do
		if typeof(value) == "table" and value.Signal then
			data[key] = nil
			
		elseif typeof(value) == "table" then
			SerializeData(value)
			
		elseif typeof(value) == "Instance" then
			data[key] = nil
		end
	end
end

function Utility.Wipe(dataNetwork, data, wipeBackup)
	local dataStore = wipeBackup and dataNetwork.BackupDataStore or dataNetwork.DataStore
	local tries = 0
	
	while tries < MAX_TRIES do
		local success, response = pcall(dataStore.RemoveAsync, dataStore, data.MetaData.Key)

		if success then
			return "WIPED"
		else
			tries += 1

			if tries == MAX_TRIES then
				return response
			end
			
			HeartbeatWait(WRITE_COOLDOWN_INTERVAL)
		end
	end
end	

function Utility.Save(dataNetwork, data, saveBackup)
	local dataStore = saveBackup and dataNetwork.BackupDataStore or dataNetwork.DataStore
	local tries = 0

	while tries < MAX_TRIES do
		local success, response = pcall(dataStore.UpdateAsync, dataStore, data.MetaData.Key, function()
			local copiedData = DeepCopyTable(data)

			-- Remove any unsaveable keys to prevent errors:
			SerializeData(copiedData)
			
			if copiedData.MetaData.BoundToClear then
				copiedData.MetaData = nil
			else
				copiedData.MetaData.DataNetwork = nil
			end

			return copiedData
		end)

		if success then
			return "SAVED"
		else
			if not data.MetaData.BoundToClear then
				tries += 1
			end

			if tries == MAX_TRIES then
				return response
			end

			HeartbeatWait(WRITE_COOLDOWN_INTERVAL)
		end
	end
end

function Utility.Load(dataNetwork, key, loadMethod, loadBackup, readOnly)
	local dataStore = loadBackup and dataNetwork.BackupDataStore or dataNetwork.DataStore
	local tries = 0

	while tries < MAX_TRIES do
		local readOnlyResponse
		local sessionLocked = false

		local success, response = pcall(dataStore.UpdateAsync, dataStore, key, function(data)
			if readOnly then
				readOnlyResponse = data
				return
			else
				if data == nil then
					return
				end
			end 
			
			if data.MetaData == nil then
				if data._internal then
					if data._internal.sessionJobTime then
						data.MetaData = {
							SessionJobTime = data._internal.sessionJobTime
						}
					end
					
					data._internal = nil
				end
			end
			
			if Session_Locked(data) then 
				sessionLocked = true
				
				if loadMethod == "steal" then
					data.MetaData = {             
						SessionLockFree = false,
						SessionJobTime = data.MetaData.SessionJobTime
					}
					
					readOnlyResponse = data
					return
				else
					return
				end
			else  
				data.MetaData = {
					SessionJobTime = os.time(),
					SessionLockFree = true
				}
			end	

			return data
		end)

		if success then		
			return readOnlyResponse or response, sessionLocked
		else
			tries += 1

			if response:find("504") or response:find("501") then
				return "CORRUPTED"

			elseif tries == MAX_TRIES then
				return response
			end

			HeartbeatWait(WRITE_COOLDOWN_INTERVAL)
		end
	end
end

return Utility
