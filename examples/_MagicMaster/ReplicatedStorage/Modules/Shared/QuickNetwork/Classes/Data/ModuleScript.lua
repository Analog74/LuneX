local Data = {}
Data.__index = Data 

local RunService = game:GetService("RunService")

local ancestor = script:FindFirstAncestor("QuickNetwork") 

local Settings = require(ancestor.Settings)
local Utility = require(ancestor.AbstractionLayers.Utility)
local Queue = require(ancestor.AbstractionLayers.Queue)
local Signal = require(script.Parent.Signal)

local INVALID_ARGUMENT_TYPE = "Bad argument to #%s: expected %s, got %s"

local QuickNetwork 

local function Output(message)
	if not Settings.Logging then
		return
	end

	warn(message)
end

local function DeepCopyTable(tabl)
	local copiedTable = {}

	setmetatable(copiedTable, getmetatable(tabl))

	for key, value in pairs(tabl) do
		if typeof(value) == "table" then
			copiedTable[key] = DeepCopyTable(value)
		else
			copiedTable[key] = value
		end
	end

	return copiedTable
end

local function ReconcileTable(tabl, reconcileTable)
	reconcileTable = DeepCopyTable(reconcileTable)
	
	for key, value in pairs(reconcileTable) do
		if typeof(reconcileTable[key]) == "table" then
			ReconcileTable(tabl[key], reconcileTable[key])
			
		elseif tabl[key] == nil then
			tabl[key] = value 
		end
	end
end

local function SerializeData(data)
	for key, value in pairs(data) do
		if typeof(value) == "table" and value.Signal then
			value:Disconnect()
			data[key] = nil

		elseif typeof(value) == "table" then
			SerializeData(value)

		elseif typeof(value) == "Instance" then
			data[key] = nil
		end
	end
end

local function Is_Default_Data(data, defaultDataTemplate)
	data = DeepCopyTable(data)

	for key, value in pairs(data) do
		if key == "MetaData" or typeof(value) == "table" and value.Signal then
			continue
		end

		if value ~= defaultDataTemplate[key] then
			return false
		end
	end

	return true
end

function Data._Init(module)
	QuickNetwork = module
end

function Data:CombineKeysAsync(...)
	assert(self:IsActive(), "Combining keys isn't possible since data was cleared")
	assert(next({...}), "Keys must not be nil")

	local dataNetwork = self.MetaData.DataNetwork	

	dataNetwork.DataCorruptionSignal:Connect(function()
		return "LoadBackup"
	end)

	dataNetwork.DataErrorLoadSignal:Connect(function()
		return "LoadBackup"
	end)

	for _, key in ipairs({...}) do
		local data = dataNetwork:LoadDataAsync(key, "Steal", true)

		-- Skip the current iteration if data is empty:
		if next(data) == nil then 
			continue
		end

		for key, value in pairs(data) do
			if typeof(value) == "table" and value.Signal or key == "MetaData" then
				continue
			end
			
			self:Set(key, value)
		end
	end
	
	dataNetwork.DataCorruptionSignal:Disconnect()
	dataNetwork.DataErrorLoadSignal:Disconnect()
end

function Data:CombineDataStoresAsync(...)
	assert(self:IsActive(), "Combining data stores isn't possible since data was cleared")
	assert(next({...}), "Data store names must not be nil")

	for _, name in ipairs({...}) do
		local dataNetwork = QuickNetwork.GetDataNetwork(name, {})

		dataNetwork.DataCorruptionSignal:Connect(function()
			return "LoadBackup"
		end)

		dataNetwork.DataErrorLoadSignal:Connect(function()
			return "LoadBackup"
		end)

		local data = dataNetwork:LoadDataAsync(self.MetaData.Key, "Steal", true)

		-- Skip the current iteration if data is empty:
		if next(data) == nil then 
			continue
		end

		for key, value in pairs(data) do
			if typeof(value) == "table" and value.Signal or key == "MetaData" then
				continue
			end
			
			self:Set(key, value)
		end
		
		dataNetwork.DataCorruptionSignal:Disconnect()
		dataNetwork.DataErrorLoadSignal:Disconnect()
	end
end

function Data:Set(key, value)
	-- Rare case which needs to be handled:
	if self.MetaData.Setting then
		self.MetaData.Setting:Wait()
	end
	
	-- Same value?
	if self[key] == value then
		return
	end
	
	self.MetaData.Setting = Signal.new()
	self[key] = value
	self.MetaData.Updated = true
	self.ListenToUpdate:Fire(key, value)
	
	self.MetaData.Setting:Fire()
	self.MetaData.Setting:Disconnect()
	self.MetaData.Setting = nil
end

function Data:SetTable(value, ...)	
	-- Rare case which needs to be handled:
	if self.MetaData.SettingTable then
		self.MetaData.SettingTable:Wait()
	end
	
	local arguments = {...}
	local data = self
	
	for i, v in ipairs(arguments) do
		-- Don't loop if we're at the last index since the value at the last index is the index
		if i ==  #arguments then 
			break 
		end

		self = self[v]
	end
	
	-- Same value?
	if self[arguments[#arguments]] == value then
		return
	end
	
	self.MetaData.SettingTable = Signal.new()
	self[arguments[#arguments]] = value
	self.Updated = true
	
	data.ListenToUpdate:Fire(arguments[#arguments], value, self)
	self.MetaData.SettingTable:Fire()
	self.MetaData.SettingTable:Disconnect()
	self.MetaData.SettingTable = nil
end

function Data:IsActive()
	return not self.MetaData.Cleared 
end

function Data:IsBackup()
	return self.MetaData.Backup
end

function Data:Save(forceSave) 
	assert(typeof(forceSave) == "boolean" or forceSave == nil, INVALID_ARGUMENT_TYPE:format(1, "boolean or nil", typeof(forceSave)))
	assert(self:IsActive(), "Saving data isn't possible since it was cleared")

	local key = self.MetaData.Key
	local dataNetwork = self.MetaData.DataNetwork 	
	
	-- Data is currently being saved?
	if self.MetaData.Saving then
		self.MetaData.Saving:Wait()
	end
	
	if (RunService:IsStudio()) and not Settings.SaveInStudio then
		Output(("[QuickNetwork]: [KEY: %s]: Cannot save data in Studio as SaveInStudio is false"):format(key))
		self.MetaData.BoundToClear = false
		return

	elseif not self.MetaData.Loaded then
		Output(("[QuickNetwork]: [KEY: %s]: Cannot save data as it wasn't loaded"):format(key))
		self.MetaData.BoundToClear = false
		return

	elseif (not self.MetaData.Updated) and (not forceSave) and not self.MetaData.BoundToClear then
		Output(("[QuickNetwork]: [KEY: %s]: Cannot save data as it wasn't updated"):format(key))
		self.MetaData.BoundToClear = false
		return

	elseif (not self.MetaData.SessionLockFree) and not forceSave then
		Output(("[QuickNetwork]: [KEY: %s]: Cannot save data as it was previously session locked"):format(key))
		self.MetaData.BoundToClear = false
		return
	end

	local backup = self:IsBackup()

	if (not Settings.SaveBackups) and backup then
		return
	end
	
	self.MetaData.Saving = Signal.new()
	
	if backup then
		local response = Queue.QueueAPICall({dataNetwork, self, backup}, Utility.Save)

		if response == "SAVED" then
			if self.MetaData.BoundToClear then
				self._ListenToClear:Fire()
				self.MetaData.Cleared = true
				self.MetaData.BoundToClear = false
			end
			
			self.MetaData.Updated = false
			self.ListenToSave:Fire(self.MetaData.AutoSaving)
			
			if self.MetaData.AutoSaving then
				Output(("[QuickNetwork]: [KEY: %s]: Auto saved backup data"):format(key))
				self.MetaData.AutoSaving = false
			else
				if self.MetaData.BoundToClear then
					self._ListenToClear:Fire()
					self.MetaData.Cleared = true
					self.MetaData.BoundToClear = false
					Output(("[QuickNetwork]: [KEY: %s]: Cleared backup data"):format(key))
				else
					Output(("[QuickNetwork]: [KEY: %s]: Saved backup data"):format(key))
				end
			end
		else
			if self.MetaData.BoundToClear then
				self.MetaData.BoundToClear = false
				Output(("[QuickNetwork]: [KEY: %s]: Error clearing backup data: %s"):format(key, response))
			else
				Output(("[QuickNetwork]: [KEY: %s]: Error saving  backup data: %s"):format(key, response))
			end
		end
	else
		local response = Queue.QueueAPICall({dataNetwork, self, backup}, Utility.Save)

		if response == "SAVED" then
			self.MetaData.Updated = false
			self.ListenToSave:Fire(self.MetaData.AutoSaving)
			
			if self.MetaData.AutoSaving then
				Output(("[QuickNetwork]: [KEY: %s]: Auto saved data"):format(key))
				self.MetaData.AutoSaving = false
			else
				if self.MetaData.BoundToClear then
					self._ListenToClear:Fire()
					self.MetaData.Cleared = true
					self.MetaData.BoundToClear = false
					Output(("[QuickNetwork]: [KEY: %s]: Cleared data"):format(key))
				else
					Output(("[QuickNetwork]: [KEY: %s]: Saved data"):format(key))
				end
			end
			
			if Settings.SaveBackups then
				coroutine.wrap(Queue.QueueAPICall)({dataNetwork, self, true}, Utility.Save)
			end
		else
			if self.MetaData.BoundToClear then
				self.MetaData.BoundToClear = false
				Output(("[QuickNetwork]: [KEY: %s]: Error clearing data: %s"):format(key, response))
			else
				Output(("[QuickNetwork]: [KEY: %s]: Error saving data: %s"):format(key, response))
			end
		end
	end
	
	self.MetaData.Saving:Fire()
	self.MetaData.Saving:Disconnect()
	self.MetaData.Saving = nil
end

function Data:ClearBackup()
	self.MetaData.Backup = false
end

function Data:Clear()
	assert(self:IsActive(), "Clearing data isn't possible since it was cleared")
	
	if self.MetaData.BoundToClear then
		return
	end
	
	self.MetaData.BoundToClear = true
	self:Save()
end	

function Data:Reconcile() 
	ReconcileTable(self, self.MetaData.DataNetwork.DefaultDataTemplate)
end

function Data:Reset()
	for key, value in pairs(DeepCopyTable(self.MetaData.DataNetwork.DefaultDataTemplate)) do
		self:Set(key, value)
	end
end

function Data:Wipe(forceWipe)
	assert(typeof(forceWipe) == "boolean" or forceWipe == nil, INVALID_ARGUMENT_TYPE:format(1, "boolean or nil", typeof(forceWipe)))
	assert(self:IsActive(), "Wiping data isn't possible since it was cleared")
	
	-- Data is currently being wiped?
	if self.MetaData.Wiping then
		self.MetaData.Wiping:Wait()
	end
	
	self.MetaData.Wiping = Signal.new()
	
	local key = self.MetaData.Key
	local dataNetwork = self.MetaData.DataNetwork
	
	if not self.MetaData.Loaded then
		Output(("[QuickNetwork]: [KEY: %s]: Cannot wipe data as it wasn't loaded"):format(key))
		return		

	elseif (Is_Default_Data(self, dataNetwork.DefaultDataTemplate)) and not forceWipe then
		Output(("[QuickNetwork]: [KEY: %s]: Cannot wipe data as it wasn't updated from the default data"):format(key))
		return

	elseif (self.MetaData.BoundToClear) and not forceWipe then
		Output(("[QuickNetwork]: [KEY: %s]: Wipe request cancelled as data is being cleared"))
		return
	end

	local backup = self:IsBackup()

	if backup then
		local response = Queue.QueueAPICall({dataNetwork, self, backup}, Utility.Wipe)

		if response == "WIPED" then
			Output(("[QuickNetwork]: [KEY: %s]: Wiped backup data"):format(key))
			self:Reset()
		else
			Output(("[QuickNetwork]: [KEY: %s]: Error wiping backup data: %s"):format(key, response))
		end

		self.ListenToWipe:Fire()
	else
		local response = Queue.QueueAPICall({dataNetwork, self, backup}, Utility.Wipe)

		if response == "WIPED" then
			Output(("[QuickNetwork]: [KEY: %s]: Wiped data"):format(key))
			self:Reset()
			coroutine.wrap(Queue.QueueAPICall)({dataNetwork, self, backup}, Utility.Wipe)
		else
			Output(("[QuickNetwork]: [KEY: %s]: Error wiping data: %s"):format(key, response))
		end
	end
	
	self.MetaData.Wiping:Fire()
	self.MetaData.Wiping:Disconnect()
	self.MetaData.Wiping = nil
end

return Data