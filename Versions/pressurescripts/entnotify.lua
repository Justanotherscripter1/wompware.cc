vals = false

function sv(asdfg:boolean)
    vals = asdfg
end

local NotificationLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Justanotherscripter1/wompware.cc/refs/heads/main/MiscStuff/notify.lua"))()

--[[
NotificationLib:Notify("Test", "This is a test", 15)
NotificationLib:Success("Success", "It worked!", 3)
NotificationLib:Error("Error", "Something went wrong", 4)
]]

workspace.ChildAdded:Connect(function(thing)
if tostring(thing) == "Angler" or tostring(thing) == "Froger" or tostring(thing) == "Pinkie" or tostring(thing) == "Blitz" or tostring(thing) == "Chainsmoker" and vals then
    NotificationLib:Notify(tostring(thing), tostring(thing).. " Spawned!", 5)
    elseif tostring(thing) == "Pandemonium" and vals then
    NotificationLib:Error(tostring(thing).." Spawned!", "your cooked buddy.", 5)
    end
end)

workspace.GameplayFolder.Monsters.ChildAdded:Connect(function(bjarg)
if tostring(bjarg) == "StatueRoot" and vals then
NotificationLib:Notify("Candle Brute spawned!", "drop your lights bro", 5)
end
end)

workspace.GameplayFolder.Rooms.ChildAdded:Connect(function(room)
    for i, v in ipairs(room:GetChildren()) do 
        if v.Name == "MonsterLocker" then
            NotificationLib:Notify("Void locker", "he WILL diddy your butthole.", 5)
        end
    end
end)







return {val = sv}