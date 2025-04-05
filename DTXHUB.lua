local Config = {
    Key = Enum.KeyCode.F,
    Time = 0.5
}
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TradingCmds = require(ReplicatedStorage.Library.Client.TradingCmds)
local Freezer = {}
local originalGetState = TradingCmds.GetState
TradingCmds.GetState = hookfunction(originalGetState, function(...)
    local state = originalGetState(...)
    for userId, data in pairs(state._items) do
        if Freezer[userId] then
            data["2"] = Freezer[userId]
        end
    end
    return state
end)
local function FreezeTargetItems()
    local state = originalGetState()._items
    for userId, data in pairs(state) do
        if data["2"] then
            Freezer[userId] = data["2"]
        end
    end
end
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Config.Key and not gpe then
        if next(Freezer) then
            Freezer = {}
            print("❄️")
        else
            task.wait(Config.Time)
            FreezeTargetItems()
            print("🧊")
        end
    end
end)
local cmds = TradingCmds.GetState()._items
for i, v in pairs(cmds) do
    for j, k in pairs(v) do
        for a, o in pairs(k) do
            print(a, o)
        end
    end
end
