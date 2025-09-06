local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local targetPartName = "HumanoidRootPart"
local targetParts = {}

local size = {
    x = 10,
    y = 10,
    z = 10,
}

local Enabled = false

local function extendPart(part)
    if Enabled then
        part.Size = Vector3.new(size.x, size.y, size.z)
        part.Transparency = 0.5
        part.CanCollide = false
        part.Anchored = false
         part.Transparency = 0.5
        part.Material = Enum.Material.Neon
        part:SetAttribute("Extended", true)

        part:GetPropertyChangedSignal("Size"):Connect(function()
            if Enabled then
                part.Size = Vector3.new(size.x, size.y, size.z)
                part.Transparency = 0.5
                part.Material = Enum.Material.Neon
                part.CanCollide = false
                part.Anchored = false
            end
        end)
    else
        -- reset
        part.Size = Vector3.new(2,1,1)
        part.Transparency = 0.8
        part.CanCollide = true
        part.Anchored = false
        part:SetAttribute("Extended", nil)
    end
end

local function updateTarget(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            local part = char:WaitForChild(targetPartName, 5)
            if part then
                targetParts[player] = part
                extendPart(part)
            end
        end)
        if player.Character then
            local part = player.Character:FindFirstChild(targetPartName)
            if part then
                targetParts[player] = part
                extendPart(part)
            end
        end
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    updateTarget(plr)
end

Players.PlayerAdded:Connect(updateTarget)
Players.PlayerRemoving:Connect(function(plr)
    targetParts[plr] = nil
end)

-- toggle all hitboxes
local function SetEnabled(value)
    Enabled = value
    for _, part in pairs(targetParts) do
        if part and part.Parent then
            extendPart(part)
        end
    end
end

-- update size dynamically
local function SetSize(axis, newValue)
    if size[axis] then
        size[axis] = newValue
        if Enabled then
            for _, part in pairs(targetParts) do
                if part and part.Parent then
                    extendPart(part)
                end
            end
        end
    end
end

return {
    Sizes = size,
    TargetPart = targetPartName,
    SetEnabled = SetEnabled,
    SetSize = SetSize
}
