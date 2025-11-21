--!strict

local Players = game:GetService("Players")

local function createActionGui()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ActionGui"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.DisplayOrder = 10

        local listFrame = Instance.new("Frame")
        listFrame.Name = "ListFrame"
        listFrame.BackgroundTransparency = 1
        listFrame.Size = UDim2.new(1, 0, 1, 0)
        listFrame.Parent = screenGui

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = listFrame

        return screenGui
end

local function createActionFrame()
        local frame = Instance.new("Frame")
        frame.Name = "ActionFrame"
        frame.Size = UDim2.new(0, 220, 0, 60)
        frame.BackgroundTransparency = 0.35
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BorderSizePixel = 0

        local contentFrame = Instance.new("Frame")
        contentFrame.Name = "ContentFrame"
        contentFrame.BackgroundTransparency = 1
        contentFrame.Size = UDim2.new(1, -12, 1, -12)
        contentFrame.Position = UDim2.new(0, 6, 0, 6)
        contentFrame.Parent = frame

        local actionLabel = Instance.new("TextLabel")
        actionLabel.Name = "ActionLabel"
        actionLabel.Size = UDim2.new(0.4, 0, 1, 0)
        actionLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        actionLabel.BackgroundTransparency = 0.35
        actionLabel.TextScaled = true
        actionLabel.Font = Enum.Font.GothamBold
        actionLabel.TextColor3 = Color3.new(1, 1, 1)
        actionLabel.Parent = contentFrame

        local inputFrame = Instance.new("Frame")
        inputFrame.Name = "InputFrame"
        inputFrame.BackgroundTransparency = 1
        inputFrame.Size = UDim2.new(0.6, 0, 1, 0)
        inputFrame.Position = UDim2.new(0.4, 0, 0, 0)
        inputFrame.Parent = contentFrame

        local touchButton = Instance.new("TextButton")
        touchButton.Name = "TouchButton"
        touchButton.BackgroundTransparency = 1
        touchButton.Size = UDim2.new(1, 0, 1, 0)
        touchButton.Text = ""
        touchButton.Parent = frame

        return frame
end

local function createButtonDisplayFrame()
        local buttonDisplayFrame = Instance.new("Frame")
        buttonDisplayFrame.Name = "ButtonDisplayFrame"
        buttonDisplayFrame.BackgroundTransparency = 1
        buttonDisplayFrame.Size = UDim2.new(1, 0, 1, 0)

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 6)
        layout.Parent = buttonDisplayFrame

        return buttonDisplayFrame
end

local function createKeyboardBorderImage()
        local border = Instance.new("ImageLabel")
        border.Name = "KeyboardBorderImage"
        border.Image = "rbxassetid://0"
        border.BackgroundTransparency = 1
        border.Size = UDim2.new(0, 32, 0, 32)
        border.ScaleType = Enum.ScaleType.Fit
        return border
end

local function createKeyboardImageLabel()
        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Name = "KeyboardImageLabel"
        imageLabel.BackgroundTransparency = 1
        imageLabel.Size = UDim2.new(0, 32, 0, 32)
        imageLabel.ScaleType = Enum.ScaleType.Fit
        return imageLabel
end

local function createKeyboardTextLabel()
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "KeyboardTextLabel"
        textLabel.BackgroundTransparency = 1
        textLabel.Size = UDim2.new(0, 32, 0, 32)
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        return textLabel
end

local function createMouseImageLabel()
        local mouseImageLabel = Instance.new("ImageLabel")
        mouseImageLabel.Name = "MouseImageLabel"
        mouseImageLabel.BackgroundTransparency = 1
        mouseImageLabel.Size = UDim2.new(0, 32, 0, 32)
        mouseImageLabel.ScaleType = Enum.ScaleType.Fit
        return mouseImageLabel
end

local function createGamepadImageLabel()
        local gamepadImageLabel = Instance.new("ImageLabel")
        gamepadImageLabel.Name = "GamepadImageLabel"
        gamepadImageLabel.BackgroundTransparency = 1
        gamepadImageLabel.Size = UDim2.new(0, 32, 0, 32)
        gamepadImageLabel.ScaleType = Enum.ScaleType.Fit
        return gamepadImageLabel
end

local function createTouchImageLabel()
        local touchImageLabel = Instance.new("ImageLabel")
        touchImageLabel.Name = "TouchImageLabel"
        touchImageLabel.BackgroundTransparency = 1
        touchImageLabel.Size = UDim2.new(0, 32, 0, 32)
        touchImageLabel.ScaleType = Enum.ScaleType.Fit
        touchImageLabel.Image = "rbxasset://textures/ui/Controls/TouchLight.png"
        return touchImageLabel
end

local instances = {
        ActionGui = createActionGui(),
        ActionFrame = createActionFrame(),
        ButtonDisplayFrame = createButtonDisplayFrame(),
        KeyboardBorderImage = createKeyboardBorderImage(),
        KeyboardImageLabel = createKeyboardImageLabel(),
        KeyboardTextLabel = createKeyboardTextLabel(),
        MouseImageLabel = createMouseImageLabel(),
        GamepadImageLabel = createGamepadImageLabel(),
        TouchImageLabel = createTouchImageLabel(),
}

instances.ActionGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

return instances
