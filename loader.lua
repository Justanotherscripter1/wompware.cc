--this does NOT contain the key systewm, because if it did bypasses could be done, the key system is per script. This just loads the script for your game or the universal one.
local games = {
    ["4991214437"] = "https://raw.githubusercontent.com/Justanotherscripter1/wompware.cc/refs/heads/main/Versions/town.lua", --town and td are litteraly the exact same game
    ["6652350934"] = "https://raw.githubusercontent.com/Justanotherscripter1/wompware.cc/refs/heads/main/Versions/town.lua", --town and td are litteraly the exact same game
    ["Universal"]  = "https://raw.githubusercontent.com/Justanotherscripter1/wompware.cc/refs/heads/main/Versions/Universal.lua"
}

local function getScriptUrlForGame(placeId)
    return games[tostring(placeId)]
end
if table.string.find(games,tostring(game.PlaceId) , 1, false) then 
loadstring(getScriptUrlForGame(game.PlaceId))
else
loadstring(getScriptUrlForGame("Universal"))
end