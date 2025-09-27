local NotificationLibrary = {}
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Configuration
local NOTIFICATION_HEIGHT = 80
local NOTIFICATION_WIDTH = 380
local NOTIFICATION_GAP = 10
local SLIDE_TIME = 0.5
local FADE_TIME = 0.3

-- Create main GUI
local AbyssGUI = Instance.new("ScreenGui")
AbyssGUI.Name = "AbyssNotifications"
AbyssGUI.Parent = game:GetService("CoreGui")
AbyssGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AbyssGUI.ResetOnSpawn = false

-- Container for notifications
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.Parent = AbyssGUI
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Size = UDim2.new(0, NOTIFICATION_WIDTH, 1, 0)
NotificationContainer.Position = UDim2.new(1, -NOTIFICATION_WIDTH - 20, 0, 0)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = NotificationContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, NOTIFICATION_GAP)
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = NotificationContainer
UIPadding.PaddingBottom = UDim.new(0, 20)

-- Active notifications tracking
local activeNotifications = {}

function NotificationLibrary:CreateNotification(config)
    local TitleText = config.Title or "Notification"
    local Description = config.Description or ""
    local Duration = config.Duration or 3
    local Icon = config.Icon or "rbxassetid://3944668821"
    local IconColor = config.IconColor or Color3.fromRGB(255, 200, 50)
    local AccentColor = config.AccentColor or Color3.fromRGB(255, 200, 50)
    
    -- Create notification frame
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Parent = NotificationContainer
    Notification.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    Notification.BorderSizePixel = 0
    Notification.Size = UDim2.new(1, 0, 0, NOTIFICATION_HEIGHT)
    Notification.Position = UDim2.new(1.5, 0, 0, 0) -- Start off-screen
    Notification.ClipsDescendants = true
    Notification.LayoutOrder = #activeNotifications + 1
    
    -- Add gradient background
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    }
    UIGradient.Rotation = 45
    UIGradient.Parent = Notification
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Notification
    
    -- Add border stroke
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(40, 40, 45)
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.5
    UIStroke.Parent = Notification
    
    -- Progress bar container (to clip the bar properly)
    local ProgressContainer = Instance.new("Frame")
    ProgressContainer.Name = "ProgressContainer"
    ProgressContainer.Parent = Notification
    ProgressContainer.BackgroundTransparency = 1
    ProgressContainer.Position = UDim2.new(0, 0, 1, -12)
    ProgressContainer.Size = UDim2.new(1, 0, 0, 12)
    ProgressContainer.ClipsDescendants = true
    
    -- Progress bar (background)
    local ProgressBarBG = Instance.new("Frame")
    ProgressBarBG.Name = "ProgressBarBG"
    ProgressBarBG.Parent = ProgressContainer
    ProgressBarBG.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
    ProgressBarBG.BorderSizePixel = 0
    ProgressBarBG.Position = UDim2.new(0, 0, 0, 8)
    ProgressBarBG.Size = UDim2.new(1, 0, 0, 4)
    
    -- Progress bar (fill) - START FULL and shrink to empty
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Parent = ProgressBarBG
    ProgressBar.BackgroundColor3 = AccentColor
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Size = UDim2.new(1, 0, 1, 0) -- Start at full width
    ProgressBar.Position = UDim2.new(0, 0, 0, 0)
    
    -- Add glow to progress bar
    local ProgressGlow = Instance.new("UIGradient")
    ProgressGlow.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    }
    ProgressGlow.Parent = ProgressBar
    
    -- Icon container
    local IconContainer = Instance.new("Frame")
    IconContainer.Name = "IconContainer"
    IconContainer.Parent = Notification
    IconContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
    IconContainer.Position = UDim2.new(0, 15, 0.5, -20)
    IconContainer.Size = UDim2.new(0, 40, 0, 40)
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 10)
    IconCorner.Parent = IconContainer
    
    -- Icon
    local IconImage = Instance.new("ImageLabel")
    IconImage.Name = "Icon"
    IconImage.Parent = IconContainer
    IconImage.BackgroundTransparency = 1
    IconImage.Position = UDim2.new(0.5, -15, 0.5, -15)
    IconImage.Size = UDim2.new(0, 30, 0, 30)
    IconImage.Image = Icon
    IconImage.ImageColor3 = IconColor
    IconImage.ScaleType = Enum.ScaleType.Fit
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = Notification
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 70, 0, 12)
    TitleLabel.Size = UDim2.new(1, -80, 0, 20)
    TitleLabel.Font = Enum.Font.Gotham
    TitleLabel.Text = TitleText
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextStrokeTransparency = 0.8
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Description
    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Name = "Description"
    DescriptionLabel.Parent = Notification
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Position = UDim2.new(0, 70, 0, 35)
    DescriptionLabel.Size = UDim2.new(1, -80, 0, 30)
    DescriptionLabel.Font = Enum.Font.Gotham
    DescriptionLabel.Text = Description
    DescriptionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    DescriptionLabel.TextSize = 12
    DescriptionLabel.TextStrokeTransparency = 0.9
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.TextWrapped = true
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Notification
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -35, 0, 10)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Font = Enum.Font.Gotham
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    CloseButton.TextSize = 20
    
    -- Add to active notifications
    table.insert(activeNotifications, Notification)
    
    -- Animations
    local slideIn = TweenService:Create(
        Notification,
        TweenInfo.new(SLIDE_TIME, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 0, 0, 0)}
    )
    
    -- Progress bar EMPTIES over time (starts full, goes to 0)
    local progressEmpty = TweenService:Create(
        ProgressBar,
        TweenInfo.new(Duration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 0, 1, 0)} -- Shrink to 0 width
    )
    
    local function removeNotification()
        local fadeOut = TweenService:Create(
            Notification,
            TweenInfo.new(FADE_TIME, Enum.EasingStyle.Quart),
            {Position = UDim2.new(1.5, 0, 0, 0)}
        )
        
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            -- Remove from active notifications
            for i, v in ipairs(activeNotifications) do
                if v == Notification then
                    table.remove(activeNotifications, i)
                    break
                end
            end
            Notification:Destroy()
        end)
    end
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(removeNotification)
    
    -- Hover effects
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
    end)
    
    -- Play animations
    slideIn:Play()
    wait(SLIDE_TIME)
    progressEmpty:Play()
    
    -- Auto remove after duration
    task.wait(Duration)
    removeNotification()
end

-- Simplified notify function for backward compatibility
function NotificationLibrary:Notify(title, description, duration)
    self:CreateNotification({
        Title = title,
        Description = description,
        Duration = duration or 3
    })
end

-- Additional notification types
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