local NotificationLibrary = {}
local TweenService = game:GetService("TweenService")

-- Configuration
local NOTIFICATION_HEIGHT = 70
local NOTIFICATION_WIDTH = 350
local NOTIFICATION_GAP = 10
local EDGE_OFFSET = 20

-- Create main GUI
local AbyssGUI = Instance.new("ScreenGui")
AbyssGUI.Name = "AbyssNotifications"
AbyssGUI.Parent = game:GetService("CoreGui")
AbyssGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AbyssGUI.ResetOnSpawn = false

-- Active notifications tracking
local activeNotifications = {}

function NotificationLibrary:UpdatePositions()
    for i, data in ipairs(activeNotifications) do
        local targetY = -EDGE_OFFSET - (i * (NOTIFICATION_HEIGHT + NOTIFICATION_GAP))
        TweenService:Create(
            data.Frame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Position = UDim2.new(1, -NOTIFICATION_WIDTH - EDGE_OFFSET, 1, targetY)}
        ):Play()
    end
end

function NotificationLibrary:CreateNotification(config)
    local TitleText = config.Title or "Notification"
    local Description = config.Description or ""
    local Duration = config.Duration or 3
    local Icon = config.Icon or "rbxassetid://3944668821"
    local IconColor = config.IconColor or Color3.fromRGB(255, 200, 50)
    local AccentColor = config.AccentColor or Color3.fromRGB(255, 200, 50)
    
    -- Make the accent color lighter for the progress bar
    local LighterAccent = Color3.fromRGB(
        math.min(255, AccentColor.R * 255 + 30),
        math.min(255, AccentColor.G * 255 + 30),
        math.min(255, AccentColor.B * 255 + 30)
    )
    
    -- Create notification frame
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Parent = AbyssGUI
    Notification.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    Notification.BorderSizePixel = 0
    Notification.Size = UDim2.new(0, NOTIFICATION_WIDTH, 0, NOTIFICATION_HEIGHT)
    Notification.ClipsDescendants = true
    
    -- Start position (off-screen to the right)
    local startY = -EDGE_OFFSET - ((#activeNotifications + 1) * (NOTIFICATION_HEIGHT + NOTIFICATION_GAP))
    Notification.Position = UDim2.new(1, EDGE_OFFSET, 1, startY)
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Notification
    
    -- Add subtle border
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(35, 35, 38)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.5
    UIStroke.Parent = Notification
    
    -- Progress bar container
    local ProgressContainer = Instance.new("Frame")
    ProgressContainer.Name = "ProgressContainer"
    ProgressContainer.Parent = Notification
    ProgressContainer.BackgroundTransparency = 1
    ProgressContainer.Position = UDim2.new(0, 0, 1, -8)
    ProgressContainer.Size = UDim2.new(1, 0, 0, 8)
    ProgressContainer.ClipsDescendants = true
    
    -- Progress bar background
    local ProgressBarBG = Instance.new("Frame")
    ProgressBarBG.Name = "ProgressBarBG"
    ProgressBarBG.Parent = ProgressContainer
    ProgressBarBG.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
    ProgressBarBG.BorderSizePixel = 0
    ProgressBarBG.Position = UDim2.new(0, 0, 0, 5)
    ProgressBarBG.Size = UDim2.new(1, 0, 0, 3)
    
    -- Progress bar (starts full, empties over time)
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Parent = ProgressBarBG
    ProgressBar.BackgroundColor3 = LighterAccent
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Size = UDim2.new(1, 0, 1, 0)
    ProgressBar.Position = UDim2.new(0, 0, 0, 0)
    
    -- Add gradient for subtle shine effect
    local ProgressGradient = Instance.new("UIGradient")
    ProgressGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 240, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 220))
    }
    ProgressGradient.Rotation = 90
    ProgressGradient.Parent = ProgressBar
    
    -- Create glow effect frame
    local GlowFrame = Instance.new("Frame")
    GlowFrame.Name = "Glow"
    GlowFrame.Parent = ProgressContainer
    GlowFrame.BackgroundColor3 = LighterAccent
    GlowFrame.BorderSizePixel = 0
    GlowFrame.Position = UDim2.new(0, -2, 0, 3)
    GlowFrame.Size = UDim2.new(1, 4, 0, 7)
    GlowFrame.ZIndex = 0
    
    -- Add blur/glow gradient
    local GlowGradient = Instance.new("UIGradient")
    GlowGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.7),
        NumberSequenceKeypoint.new(1, 1)
    }
    GlowGradient.Rotation = 90
    GlowGradient.Parent = GlowFrame
    
    -- Make glow pulse slightly
    task.spawn(function()
        while GlowFrame and GlowFrame.Parent do
            TweenService:Create(
                GlowGradient,
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.5, 0.6),
                    NumberSequenceKeypoint.new(1, 1)
                }}
            ):Play()
            task.wait(1.5)
            TweenService:Create(
                GlowGradient,
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.5, 0.8),
                    NumberSequenceKeypoint.new(1, 1)
                }}
            ):Play()
            task.wait(1.5)
        end
    end)
    
    -- Icon
    local IconImage = Instance.new("ImageLabel")
    IconImage.Name = "Icon"
    IconImage.Parent = Notification
    IconImage.BackgroundTransparency = 1
    IconImage.Position = UDim2.new(0, 15, 0.5, -15)
    IconImage.Size = UDim2.new(0, 30, 0, 30)
    IconImage.Image = Icon
    IconImage.ImageColor3 = IconColor
    IconImage.ScaleType = Enum.ScaleType.Fit
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = Notification
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 55, 0, 10)
    TitleLabel.Size = UDim2.new(1, -110, 0, 20)
    TitleLabel.Font = Enum.Font.SourceSansSemibold
    TitleLabel.Text = TitleText
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Description
    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Name = "Description"
    DescriptionLabel.Parent = Notification
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Position = UDim2.new(0, 55, 0, 30)
    DescriptionLabel.Size = UDim2.new(1, -110, 0, 25)
    DescriptionLabel.Font = Enum.Font.SourceSans
    DescriptionLabel.Text = Description
    DescriptionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    DescriptionLabel.TextSize = 12
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.TextWrapped = true
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Notification
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Font = Enum.Font.SourceSans
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(120, 120, 120)
    CloseButton.TextSize = 18
    
    -- Store notification data
    local notificationData = {
        Frame = Notification,
        ProgressBar = ProgressBar,
        GlowFrame = GlowFrame
    }
    table.insert(activeNotifications, notificationData)
    
    -- Slide in animation
    local slideIn = TweenService:Create(
        Notification,
        TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -NOTIFICATION_WIDTH - EDGE_OFFSET, 1, startY)}
    )
    
    -- Progress bar animation (empty over time)
    local progressEmpty = TweenService:Create(
        ProgressBar,
        TweenInfo.new(Duration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 0, 1, 0)}
    )
    
    -- Glow shrink animation (synced with progress bar)
    local glowShrink = TweenService:Create(
        GlowFrame,
        TweenInfo.new(Duration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 4, 0, 7)}
    )
    
    local function removeNotification()
        -- Slide out animation
        local slideOut = TweenService:Create(
            Notification,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {Position = UDim2.new(1, EDGE_OFFSET, 1, Notification.Position.Y.Offset)}
        )
        
        slideOut:Play()
        slideOut.Completed:Connect(function()
            -- Remove from active notifications
            for i, data in ipairs(activeNotifications) do
                if data.Frame == Notification then
                    table.remove(activeNotifications, i)
                    break
                end
            end
            Notification:Destroy()
            -- Update positions of remaining notifications
            self:UpdatePositions()
        end)
    end
    
    -- Close button hover effect
    CloseButton.MouseEnter:Connect(function()
        CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CloseButton.TextColor3 = Color3.fromRGB(120, 120, 120)
    end)
    
    CloseButton.MouseButton1Click:Connect(removeNotification)
    
    -- Play animations
    slideIn:Play()
    task.wait(0.4)
    progressEmpty:Play()
    glowShrink:Play()
    
    -- Auto remove after duration
    task.spawn(function()
        task.wait(Duration)
        removeNotification()
    end)
end

-- Simple notify function
function NotificationLibrary:Notify(title, description, duration)
    self:CreateNotification({
        Title = title,
        Description = description,
        Duration = duration or 3
    })
end

-- Preset notification types
function NotificationLibrary:Success(title, description, duration)
    self:CreateNotification({
        Title = title,
        Description = description,
        Duration = duration or 3,
        Icon = "rbxassetid://3944680095",
        IconColor = Color3.fromRGB(50, 255, 100),
        AccentColor = Color3.fromRGB(50, 255, 100)
    })
end

function NotificationLibrary:Error(title, description, duration)
    self:CreateNotification({
        Title = title,
        Description = description,
        Duration = duration or 3,
        Icon = "rbxassetid://3944703587",
        IconColor = Color3.fromRGB(255, 50, 50),
        AccentColor = Color3.fromRGB(255, 50, 50)
    })
end

function NotificationLibrary:Warning(title, description, duration)
    self:CreateNotification({
        Title = title,
        Description = description,
        Duration = duration or 3,
        Icon = "rbxassetid://3944668821",
        IconColor = Color3.fromRGB(255, 200, 50),
        AccentColor = Color3.fromRGB(255, 200, 50)
    })
end

function NotificationLibrary:Info(title, description, duration)
    self:CreateNotification({
        Title = title,
        Description = description,
        Duration = duration or 3,
        Icon = "rbxassetid://3944669912",
        IconColor = Color3.fromRGB(50, 150, 255),
        AccentColor = Color3.fromRGB(50, 150, 255)
    })
end

return NotificationLibrary