local Spectre = {}

-- Services
local UserInputService = game:GetService("UserInputService")

-- Create UI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

-- Main UI Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 450, 0, 300)
main.Position = UDim2.new(0.5, -225, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Parent = gui

-- UI Corner (Rounded)
local UICorner = Instance.new("UICorner", main)
UICorner.CornerRadius = UDim.new(0, 10)

-- UI Visibility Toggle
local isOpen = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        isOpen = not isOpen
        gui.Enabled = isOpen
    end
end)

-- Function to create buttons
function Spectre.CreateButton(name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 400, 0, 40)
    button.Position = UDim2.new(0.5, -200, 0, #main:GetChildren() * 45)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.Text = name
    button.Parent = main

    -- Smooth click animation
    button.MouseButton1Click:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        task.wait(0.1)
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        callback()
    end)

    return button
end

return Spectre
