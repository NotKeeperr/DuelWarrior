local Event = workspace:WaitForChild("Event"):WaitForChild("Replication_RemoteEvent")

-- Steal and disable all existing connections (game's handler)
local connections = getconnections(Event.OnClientEvent)
local originalHandlers = {}

for _, conn in ipairs(connections) do
    if conn.Function then
        table.insert(originalHandlers, conn.Function)
        conn:Disable()
    end
end

-- Our replacement handler
Event.OnClientEvent:Connect(function(data)
    if typeof(data) == "table"
        and data.State == "Begin"
        and data.Type == "PivotToFun"
        and data.Direction == "Back"
        and data.Move_X == 20 then
        
        -- CANCEL original and replace with neutralized version
        firesignal(Event.OnClientEvent, {
            State = "Begin",
            Direction = "Back",
            Style = "OutQuad",
            FollowCamera = true,
            Time = 0.5,
            NoOrientation = true,
            Move_X = 0,
            Type = "PivotToFun"
        })
        return
    end
    
    -- Forward any other events normally
    for _, handler in ipairs(originalHandlers) do
        pcall(handler, data)
    end
end)

print("PivotToFun Move_X neutralization active (20 → 0)")
