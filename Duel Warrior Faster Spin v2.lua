local Event = workspace:WaitForChild("Event"):WaitForChild("Replication_RemoteEvent")

-- Steal and disable all existing connections (game's handler)
local connections = getconnections(Event.OnClientEvent)
local originalHandlers = {}

for _, conn in ipairs(connections) do
    if conn.Function then
        table.insert(originalHandlers, conn.Function)
        conn:Disable() -- Blocks the original handler
    end
end

-- Our replacement handler
Event.OnClientEvent:Connect(function(data)
    if typeof(data) == "table"
        and data.State == "Begin"
        and data.Type == "AddWalkSpeed"
        and data.Uid == "Roll"
        and data.Speed == 30 then
        
        -- CANCEL original and replace with 60
        firesignal(Event.OnClientEvent, {
            State = "Begin",
            Type = "AddWalkSpeed",
            Uid = "Roll",
            Speed = 60
        })
        return
    end
    
    -- Forward any other events normally
    for _, handler in ipairs(originalHandlers) do
        pcall(handler, data)
    end
end)

print("Roll speed replacement active (30 → 60)")
