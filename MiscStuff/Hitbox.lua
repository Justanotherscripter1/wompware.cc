local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TargetPartName = "Head"

local trackedHeads = {}
local size = {x = 10, y = 10, z = 10}

-- Function to apply hitbox changes
local function applyHitbox(part)
    if not part:GetAttribute("Extended") then
        part.Size = Vector3.new(size.x, size.y, size.z)
        part.Transparency = 0.5
        part.CanCollide = false
        part.Anchored = false -- important to let the physics move the head
        part:SetAttribute("Extended", true)
        
        -- Listen for accidental changes to size
        part:GetPropertyChangedSignal("Size"):Connect(function()
            part.Size = Vector3.new(size.x, size.y, size.z)
        end)
    end
end

-- Track a player
local function trackPlayer(player)
    if player ~= LocalPlayer then
        -- When character spawns
        player.CharacterAdded:Connect(function(char)
            local head = char:WaitForChild(TargetPartName, 5)
            if head then
                trackedHeads[player] = head
                applyHitbox(head)
            end
        end)

        -- Already spawned
        if player.Character then
            local head = player.Character:FindFirstChild(TargetPartName)
            if head then
                trackedHeads[player] = head
                applyHitbox(head)
            end
        end
    end
end

-- Track all current players
for _, plr in ipairs(Players:GetPlayers()) do
    trackPlayer(plr)
end

-- Track new players
Players.PlayerAdded:Connect(trackPlayer)
Players.PlayerRemoving:Connect(function(plr)
    trackedHeads[plr] = nil
end)

-- Optional: update all hitboxes when size changes (like sliders)
local function updateAllHitboxes(newSize)
    size = newSize
    for _, head in pairs(trackedHeads) do
        if head and head.Parent then
            applyHitbox(head)
        end
    end
end

-- Return API
return {
    Sizes = size,
    TargetPart = TargetPartName,
    UpdateAllHitboxes = updateAllHitboxes
}
