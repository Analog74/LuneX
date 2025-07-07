-- Maid.lua
-- Resource management utility (stub)

local Maid = {}
Maid.__index = Maid

function Maid.new()
    local self = setmetatable({}, Maid)
    self.Tasks = {}
    return self
end

function Maid:GiveTask(task)
    table.insert(self.Tasks, task)
end

function Maid:DoCleaning()
    for _, task in ipairs(self.Tasks) do
        if typeof(task) == "RBXScriptConnection" then
            task:Disconnect()
        elseif typeof(task) == "Instance" then
            task:Destroy()
        end
    end
    self.Tasks = {}
end

return Maid
