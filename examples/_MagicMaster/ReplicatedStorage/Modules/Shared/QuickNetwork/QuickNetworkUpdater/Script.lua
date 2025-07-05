local InsertService = game:GetService("InsertService")
local ServerStorage = game:GetService("ServerStorage")

local MODEL_ID = 6474226265
local CHECK_UPDATE_INTERVAL = 5

local currentModel = ServerStorage:FindFirstChild("QuickNetwork")

local function CheckForUpdate(model)
	local version = model:FindFirstChild("Version")

	if not version then
		return
	end

	if model.Version.Value ~= currentModel.Version.Value then
		model:Clone().Parent = ServerStorage
		currentModel:Destroy()
		currentModel = model
	end
end

while true do
	local success, response = pcall(InsertService.LoadAsset, InsertService, MODEL_ID)

	if success then
		CheckForUpdate(response.QuickNetwork)
	else
		warn(response)
	end

	wait(CHECK_UPDATE_INTERVAL)
end