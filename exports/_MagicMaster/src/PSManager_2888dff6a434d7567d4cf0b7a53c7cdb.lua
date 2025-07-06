
--[[
	Made by EmeraldLimes, April 6th, 2021
	Updated August 24th, 2021
	DevForum post: https://devforum.roblox.com/t/1435596
	
	Enjoy!
]]

























local PSManagerSettings = script._PSManagerSettings.Value













local PROFILE_STORE_DEFAULTS
local DEFAULT_NRH
local PROCESS_PROFILE_KEY_DICTIONARY

if (PSManagerSettings) then
	PSManagerSettings = require(PSManagerSettings)
	PROFILE_STORE_DEFAULTS = PSManagerSettings.PROFILE_STORE_DEFAULTS
	DEFAULT_NRH = PSManagerSettings.DEFAULT_NRH
	PROCESS_PROFILE_KEY_DICTIONARY = PSManagerSettings.PROCESS_PROFILE_KEY_DICTIONARY
else
	warn("[PSManager] Missing PSManagerSettings, did you set the object value of _PSManagerSettings to your PSManagerSettings?")
	script:Destroy()
end

local PLRS = game:GetService("Players")
local PS = require(script:WaitForChild("ProfileService"))
local PSManager = {}

local ProfileStores = {}
local loadedPlayers = {}
local fullyLoadedPlayers = {}

local tfind = table.find
local tinsert = table.insert
local tremove = table.remove

local noPlrMsg = "[PSManager] expected Instance Player, got %s %s"

local function processProfileKey(plr,key)
	local dictionary = PROCESS_PROFILE_KEY_DICTIONARY(plr)
	
	for keyWord,replacement in pairs(dictionary) do
		local start,ending = string.find(key,keyWord)
		if (not start) or (not ending) then continue end
		
		start = start - 1
		ending = ending + 1
		
		math.clamp(start,0,#key)
		math.clamp(ending,0,#key)
		
		local before = string.sub(key,0,start)
		local after = string.sub(key,ending,#key)
		local processed = before..replacement..after
		
		key = processed
	end
	
	return key
end

local function loadStore(storeName)
	ProfileStores[storeName] = PS.GetProfileStore(
		storeName,
		PROFILE_STORE_DEFAULTS[storeName]
	)
	return ProfileStores[storeName]
end

local function loadPlayer(plr)
	if (tfind(loadedPlayers,plr)) then return end
	tinsert(loadedPlayers,plr)
	
	for storeName,storeDefaults in pairs(PROFILE_STORE_DEFAULTS) do
		local store = ProfileStores[storeName]
		if (not store) then
			store = loadStore(storeName)
		end
		
		if (not storeDefaults._playerProfileKey) then
			warn(
				"[PSManager] Could not load store "
				..storeName..
				" profile for ["
				..plr.Name..
				"("
				..plr.UserId..
				")] due to missing _playerProfileKey"
			)
			continue
		end
		local profileKey = processProfileKey(plr,storeDefaults._playerProfileKey)
		local profile = store:LoadProfileAsync(
			profileKey,
			DEFAULT_NRH
		)

		if profile ~= nil then
			profile:Reconcile()
			profile:ListenToRelease(function()
				store[plr] = nil
				plr:Kick("profile released")
			end)
			if plr:IsDescendantOf(PLRS) == true then
				
				local dummy = {
					Data = {},
					Callbacks = {}
				}
				
				
				dummy.Data.__index = function(t,i)
					return profile.Data[i]
				end
				dummy.Data.__newindex = function(t,i,v)
					profile.Data[i] = v
					
					if (not dummy.Callbacks) or (dummy.Callbacks[i] and #dummy.Callbacks[i] < 1) then return end
					for _ , callback in ipairs(dummy.Callbacks[i]) do
						spawn(function()
							callback(v)
						end)
					end
				end
				
				dummy.__index = function(t,i)
					if (i ~= "Data") then
						return profile[i]
					end
				end
				dummy.__newindex = function(t,i,v)
					profile[i] = v
				end
				
				setmetatable(dummy.Data,dummy.Data)
				setmetatable(dummy,dummy)
				
				function dummy:OnDataValueChanged(ValueName,callback)
					if (not dummy.Callbacks[ValueName]) then
						dummy.Callbacks[ValueName] = {}
					end
					table.insert(dummy.Callbacks[ValueName],callback)
					
					local Connection = {}
					function Connection:Disconnect()
						table.remove(dummy.Callbacks[ValueName],table.find(dummy.Callbacks[ValueName],callback))
					end
					return Connection
				end
				
				function dummy:LinkDataToValue(ValueName, Value)
					if (not Value) or (Value and not Value:IsA("ValueBase")) then
						warn("[PSManager] ValueBase object expected, got "..Value.ClassName.." "..Value.Name)
						return
					end
					
					Value.Changed:Connect(function(newValue)
						dummy.Data[ValueName] = newValue
					end)
					
					dummy.Data[ValueName] = Value.Value
				end
				
				store[plr] = dummy
			else
				profile:Release()
			end
		else
			plr:Kick("[PSManager] Could not reteieve player data, please rejoin.") 
		end
	end
	
	
	
	tinsert(fullyLoadedPlayers,plr)
end
PLRS.PlayerAdded:Connect(loadPlayer)

for _,plr in pairs(PLRS:GetPlayers()) do
	coroutine.wrap(loadPlayer)(plr)
end

PLRS.PlayerRemoving:Connect(function(plr)
	if (not tfind(loadedPlayers,plr)) then return end
	tremove(loadedPlayers,tfind(loadedPlayers,plr))

	if (tfind(fullyLoadedPlayers,plr)) then
		tremove(fullyLoadedPlayers,tfind(fullyLoadedPlayers,plr))
	end
	
	for storeName,store in pairs(ProfileStores) do
		if (typeof(store) ~= "table") or (typeof(store) == "table" and not store[plr]) then continue end
		
		store[plr]:Release()
		store[plr] = nil
		tremove(store,tfind(store,plr))
	end
end)

function ProfileStores:WaitForPlayerLoaded(plr)
	assert(
		plr and typeof(plr) == "Instance" and (plr and plr:IsA("Player")),
		(noPlrMsg)
		:format(
			typeof(plr),
			(plr and plr.ClassName or "nil")
		)
	)
	
	if (tfind(fullyLoadedPlayers,plr)) then return end
	repeat task.wait() until tfind(fullyLoadedPlayers,plr) or not plr
end

function ProfileStores:FetchProfile(storeName,plr)
	assert(
		plr and typeof(plr) == "Instance" and (plr and plr:IsA("Player")),
		(noPlrMsg)
		:format(
			typeof(plr),
			(plr and plr.ClassName or "nil")
		)
	)
	
	self:WaitForPlayerLoaded(plr)
	return self[storeName][plr]
end

function ProfileStores:FetchProfileStore(storeName)
	if (not self[storeName]) then loadStore(storeName) end
	return self[storeName]
end

return ProfileStores
