local HttpService = game:GetService("HttpService")

local games = {
    ["4991214437"] = "https://raw.githubusercontent.com/Justanotherscripter1/wompware.cc/refs/heads/main/Versions/town.lua",
    ["6652350934"] = "https://raw.githubusercontent.com/Justanotherscripter1/wompware.cc/refs/heads/main/Versions/town.lua",
    ["Universal"]  = "https://raw.githubusercontent.com/Justanotherscripter1/wompware.cc/refs/heads/main/Versions/Universal.lua"
}

local function getScriptUrlForGame(placeId)
    return games[tostring(placeId)] or games["Universal"]
end

local url = getScriptUrlForGame(game.PlaceId)
local scriptContent = game:HttpGet(url)
loadstring(scriptContent)()
