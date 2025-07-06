--[[
    QuickNetwork.GetDataNetwork(name, defaultDataTemplate, mock)

	DataNetwork.DataErrorSignal
	DataNetwork.DataCorruptionSignal

	Data:Reset()
	Data:Set(key, value)
	Data:SetTable(table, key, value)
	Data:Save(forceSave)
	Data:Wipe(forceWipe)
	Data:Clear()
	Data:IsActive()
	Data:CombineDataStoresAsync(dataStores)
	Data:CombineKeysAsync(keys)
	Data:IsBackup()
	Data:ClearBackup()
	Data:Reconcile()
	Data.ListenToUpdate
	Data.ListenToSave
	Data.ListenToWipe
]]

local QuickNetwork = {
	BindToShutdown = false
}

local DataNetwork = {CachedNetworks = {}}
DataNetwork.__index = DataNetwork

local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Settings = require(script.Settings)
local Data = require(script.Classes.Data)
local Utility = require(script.AbstractionLayers.Utility)
local Signal = require(script.Classes.Signal)
local Queue = require(script.AbstractionLayers.Queue)
local Constants = require(script.Constants)
local MockDataStoreService = require(script.Classes.MockDataStoreService)

local MAX_DATA_CHARACTERS = Constants.MAX_DATA_CHARACTERS
local MAX_KEY_CHARACTERS = Constants.MAX_KEY_CHARACTERS
local MAX_DATASTORE_NAME_CHARACTERS = Constants.MAX_DATASTORE_NAME_CHARACTERS
local INVALID_ARGUMENT_TYPE = Constants.INVALID_ARGUMENT_TYPE
local BACKUP_DATASTORE_NAME = Constants.BACKUP_DATASTORE_NAME
local DATA_CORRUPTIONSIGNAL_RETURN_VALUES = Constants.DATA_CORRUPTIONSIGNAL_RETURN_VALUES
local DATA_ERRORSIGNAL_RETURN_VALUES = Constants.DATA_ERRORSIGNAL_RETURN_VALUES

local globalMock = false

local SessionLockedData = {}
QuickNetwork.DataStoreErrorHandleFinish = Signal.new()

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

local function HeartbeatWait(yield)
	if yield == 0 or typeof(yield) ~= "number" then
		return RunService.Heartbeat:Wait()
	end

	local dtPassed = 0 

	while true do
		if dtPassed >= yield then
			return dtPassed
		end 

		dtPassed += RunService.Heartbeat:Wait()
	end	
end 

local function Output(message)
	if not Settings.Logging then
		return
	end

	warn(message)
end

local function BindToClose()
	if RunService:IsStudio() and not Settings.SaveOnShutDownInStudio and Settings.SaveInStudio and #SessionLockedData > 0 then
		if #SessionLockedData == 1 and SessionLockedData[1].MetaData.BoundToClear then
			return
		end
		
		Output(("[QuickNetwork]: Data won't save on server shutdown in Studio as SaveOnShutDownInStudio is false"))
		return
	end

	local clearJobsFinished = Signal.new()
	local clearJobs = #SessionLockedData

	QuickNetwork.BindToShutdown = true

	for _, data in ipairs(SessionLockedData) do	
		coroutine.wrap(function()
			data:Clear()
			clearJobs -= 1
		end)()

		if clearJobs == 0 then
			clearJobsFinished:Fire()
		end
	end

	if clearJobs > 0 then
		clearJobsFinished:Wait() -- Yield until clear jobs have finished
	end
end

local function CheckTableSize(tabl)
	local tablCharacters = #HttpService:JSONEncode(tabl)
	return tablCharacters < Constants.MAX_DATA_CHARACTERS, tablCharacters
end

local function HandleDataSessionLock(dataNetwork, key, backup)
	while true do
		local data, sessionLocked = Queue.QueueAPICall({dataNetwork, key, _, backup}, Utility.Load)  

		if not sessionLocked and typeof(data) ~= "table" then
			-- Data couldn’t be loaded 
			break

		elseif not sessionLocked then
			data.MetaData.SessionLockFree = true
			return data
		end
	end
end

function DataNetwork:SaveCachedData(forceSave)
	for _, data in pairs(self.cachedData) do
		coroutine.wrap(data.Save)(data, forceSave)
	end
end

function DataNetwork:WipeCachedData(forceWipe)
	for _, data in pairs(self.cachedData) do
		coroutine.wrap(data.Wipe)(data, forceWipe)
	end
end

function DataNetwork:LoadDataAsync(key, loadMethod, readOnly) 
	assert(typeof(key) == "string" or typeof(key) == "number", INVALID_ARGUMENT_TYPE:format(1, "number or string", typeof(key)))
	assert(#tostring(key) < MAX_KEY_CHARACTERS, INVALID_ARGUMENT_TYPE:format(1, ("key characters <= %s"):format(MAX_KEY_CHARACTERS), ("%s characters"):format(#tostring(key))))
	assert(typeof(loadMethod) == "string" or loadMethod == nil, INVALID_ARGUMENT_TYPE:format(2, "load method [Cancel, Steal, nil]", tostring(loadMethod)))
	assert(typeof(readOnly) == "boolean" or readOnly == nil, INVALID_ARGUMENT_TYPE:format(3, "boolean or nil", typeof(readOnly)))

	loadMethod = loadMethod and loadMethod:lower() or loadMethod

	if self._LoadingQueue[key] then
		self._LoadingQueue[key]:Wait()
		return self.CachedData[key]
	else
		if self.CachedData[key] then 
			return self.CachedData[key]
		end
	end

	self._LoadingQueue[key] = Signal.new()

	local data, sessionLocked = Queue.QueueAPICall({self, key, loadMethod, false, readOnly}, Utility.Load)  
	local backup = false
	local loaded = false
	
	if typeof(data) ~= "table" and typeof(data) ~= "string" then
		if data == nil then
			-- Case #1: Data is nil

			if sessionLocked and loadMethod == "cancel" then
				return
			end 

			data = HandleDataSessionLock(self, key, false)
		else   
			-- Data wasn’t saved, load backup data:
			local backupData, sessionLocked = Queue.QueueAPICall({self, key, loadMethod, true, readOnly}, Utility.Load) 

			if sessionLocked then
				backupData = HandleDataSessionLock(self, key, true)
			end

			if typeof(backupData) == "table" then
				data = backupData
				loaded = true
			else
				loaded = false
			end
		end
	end

	if data == "CORRUPTED" then
		-- Case #2: Data was loaded but is corrupted
		Output(("[QuickNetwork]: [KEY: %s]: Data loaded was corrupted"):format(key))	
		local response = self.DataCorruptionSignal:Fire(key, "Data loaded was corrupted")

		response = typeof(response) == "string" and response:lower() or response
		assert(Constants.DATA_CORRUPTIONSIGNAL_RETURN_VALUES[response] or DATA_CORRUPTIONSIGNAL_RETURN_VALUES[typeof(response)], INVALID_ARGUMENT_TYPE:format(1, "return value [Cancel, LoadBackup, nil, Table]", tostring(response)))

		if response == "loadbackup" then
			local backupData, sessionLocked = Queue.QueueAPICall({self, key, loadMethod, true, readOnly}, Utility.Load) 
			if sessionLocked then
				backupData = HandleDataSessionLock(self, key, true)
			end

			if typeof(backupData) == "table" then
				data = backupData
			else
				data = nil
			end

		elseif response == "cancel" then
			return	

		elseif typeof(response) == "table" then
			local tableSizeUnderLimit, characters = CheckTableSize(response)
			assert(tableSizeUnderLimit, INVALID_ARGUMENT_TYPE:format(1, ("expected data characters lower than %s"):format(Constants.MAX_DATA_CHARACTERS), characters))

			data = response
		end

		loaded = true

	elseif typeof(data) == "string" then
		-- Case #3: Data couldn't be loaded
		Output(("[QuickNetwork]: [KEY: %s]: Data couldn't be loaded, error message: %s"):format(key, data))	
		local response = self.DataErrorLoadSignal:Fire(key, ("Error loading data, %s"):format(data))
		
		response = typeof(response) == "string" and response:lower() or response
		assert(DATA_ERRORSIGNAL_RETURN_VALUES[response] or DATA_ERRORSIGNAL_RETURN_VALUES[typeof(response)], INVALID_ARGUMENT_TYPE:format(1, "return value [Cancel, LoadBackup, nil, Table]", tostring(response)))

		if response == "loadbackup" then
			local backupData, sessionLocked = Queue.QueueAPICall({self, key, loadMethod, true, readOnly}, Utility.Load) 
			if sessionLocked then
				backupData = HandleDataSessionLock(self, key, true)
			end

			data = typeof(backupData) == "table" and backupData or nil

		elseif response == "cancel" then
			return

		elseif typeof(response) == "table" then
			local tableSizeUnderLimit, characters = CheckTableSize(response)
			assert(tableSizeUnderLimit, INVALID_ARGUMENT_TYPE:format(1, ("expected data characters lower than %s"):format(Constants.MAX_DATA_CHARACTERS), characters))

			data = response
		end

		loaded = typeof(data) == "table" 
		backup = loaded

		if typeof(data) == "table" then
			loaded = true
		end
	else
		loaded = true
	end
	
	if typeof(data) ~= "table" then
		data = DeepCopyTable(self.DefaultDataTemplate) 
	end

	data.MetaData = data.MetaData or {}
	data.MetaData.Key = key 
	data.MetaData.BoundToClear = false
	data.MetaData.Backup = backup
	data.MetaData.Updated = false	
	data.MetaData.Cleared = false
	data.MetaData.SessionLockFree = (data.MetaData.SessionLockFree == nil) and true or data.MetaData.SessionLockFree
	data.MetaData.Loaded = loaded
	data.MetaData.SessionJobTime = data.MetaData.SessionJobTime or os.time()
	data.MetaData.DataNetwork = setmetatable(DeepCopyTable(self), DataNetwork)

	data.ListenToUpdate = Signal.new()
	data.ListenToSave = Signal.new()
	data.ListenToWipe = Signal.new()
	data._ListenToClear = Signal.new() 

	setmetatable(data, {__index = function(_, key)
		local value = rawget(Data, key)
		assert(not (typeof(value) == "function" and readOnly), "Writing or calling any methods on data isn't possible as it is read only!")

		return value
	end})

	self.CachedData[key] = data
	self._LoadingQueue[key]:Fire()
	self._LoadingQueue[key] = nil

	local index = #SessionLockedData + 1
	table.insert(SessionLockedData, index, data)

	-- Auto saving 
	coroutine.wrap(function()
		while data.MetaData.Loaded and data.MetaData.SessionLockFree and not data.MetaData.Cleared do
			-- Make sure data is updated and autosaving is allowed:
			if data.MetaData.Updated and Settings.AutoSave and not data.MetaData.BoundToClear then
				data.MetaData.AutoSaving = true
				data:Save() 
			end

			HeartbeatWait(Settings.AutoSaveInterval)
		end
	end)()

	-- Clear up data when the data is about to be cleared:
	data._ListenToClear:Connect(function()
		SessionLockedData[index] = nil
		self.CachedData[key] = nil
		data.MetaData.Cleared = true

		for _, value in pairs(data) do
			local signal = typeof(value) == "table" and value.Signal 
			if signal then 
				value:Disconnect()
			end
		end
	end)

	return data
end

function DataNetwork:GetCachedData(key)
	local cachedData = self.CachedData[key]

	if not cachedData then
		warn(("%s's cached data was not found"):format(key))
		return
	end

	return cachedData
end

function QuickNetwork.GetDataNetwork(name, defaultDataTemplate, mock) 
	-- Return cached data network if found:
	if DataNetwork.CachedNetworks[name] then
		return DataNetwork.CachedNetworks[name]
	end

	assert(typeof(name) == "string", INVALID_ARGUMENT_TYPE:format(1, "string", typeof(name)))
	assert(typeof(defaultDataTemplate) == "table", INVALID_ARGUMENT_TYPE:format(2, "table", typeof(defaultDataTemplate)))
	assert(typeof(mock) == "boolean" or mock == nil, INVALID_ARGUMENT_TYPE:format(3, "boolean or nil", typeof(mock)))

	local _, characters = CheckTableSize(defaultDataTemplate)
	assert(CheckTableSize(defaultDataTemplate), INVALID_ARGUMENT_TYPE:format(2, ("data characters <= %s"):format(MAX_KEY_CHARACTERS), characters))

	if not QuickNetwork.DataStoreErrorHandleFinish.Fired then
		QuickNetwork.DataStoreErrorHandleFinish:Wait()
	end

	local dataNetwork = {
		DefaultDataTemplate = defaultDataTemplate,
		CachedData = {},
		_LoadingQueue = {},

		-- Signals
		DataCorruptionSignal = Signal.new(),
		DataErrorLoadSignal = Signal.new(),
	}

	mock = globalMock or mock

	if mock then
		dataNetwork.DataStore = MockDataStoreService:GetDataStore(name)
		dataNetwork.BackupDataStore = MockDataStoreService:GetDataStore(BACKUP_DATASTORE_NAME:format(name)) 
	else
		dataNetwork.DataStore = DataStoreService:GetDataStore(name)
		dataNetwork.BackupDataStore = DataStoreService:GetDataStore(BACKUP_DATASTORE_NAME:format(name)) 
	end

	DataNetwork.CachedNetworks[name] = dataNetwork 
	return setmetatable(dataNetwork, DataNetwork)
end

game:BindToClose(BindToClose)
Data._Init(QuickNetwork)

-- Handle any data store related errors in a new scope:

do
	local TestDataStore = DataStoreService:GetDataStore("_TestDataStore")

	if RunService:IsClient() then 
		-- Module is required by a local script
		return Output(("[QuickNetwork]: Is running on the client, won't function!"))
	end

	coroutine.wrap(function()
		local response = select(2, pcall(TestDataStore.GetAsync, TestDataStore, "_"))

		if response then
			if response:find("403") then
				-- API Services are disabled
				globalMock = Settings.UseMockDataStoreOffline
				warn(("[QuickNetwork]: API services are disabled, %s"):format(globalMock and "will use MockDataStoreService" or "won't function!"))

			elseif response:find("502") then
				-- No internet access
				globalMock = Settings.UseMockDataStoreOffline
				warn(("[QuickNetwork]: No internet access or error processing on Roblox servers, %s"):format(globalMock and "will use MockDataStoreService" or "won't function!"))	

			elseif response:find("402") then
				globalMock = Settings.UseMockDataStoreOffline
				-- Rare case: server is shutting down as soon as this module was required
				warn(("[QuickNetwork]: Server is shutting down, won't function!"))
			end
		end

		QuickNetwork.DataStoreErrorHandleFinish:Fire()
	end)()
end

return QuickNetwork 
