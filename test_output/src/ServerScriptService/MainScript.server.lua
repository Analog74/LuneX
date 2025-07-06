-- Main Server Script
print("Server starting up!")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestModule = require(ReplicatedStorage.TestModule)

TestModule.test()