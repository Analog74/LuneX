
local ReplicatedStorage = game:GetService('ReplicatedStorage')
require(ReplicatedStorage:WaitForChild('Modules'):WaitForChild('ReplicatedData'))

local ServerStorage = game:GetService('ServerStorage')
local SystemsFolder = ServerStorage:WaitForChild('Systems')

local DataService = require(SystemsFolder:WaitForChild('DataService'))
DataService:Init()
require(SystemsFolder:WaitForChild('QuestsService'))
require(SystemsFolder:WaitForChild('CollectablesService'))
require(SystemsFolder:WaitForChild('CraftingService'))
