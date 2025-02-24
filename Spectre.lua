local Spectre = {}

-- Services
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Create UI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false
gui.Enabled = true -- Default state

-- Blur Effect
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 15
BlurEffect.Parent = Lighting
BlurEffect.Enabled = true

-- Main UI Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 450, 0, 300)
main.Position = UDim2.new(0.5, -225, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Parent = gui

-- UI Corner (Rounded Edges)
local UICorner = Instance.new("UICorner", main)
UICorner.CornerRadius = UDim.new(0, 10)

-- UI Visibility Toggle (RightShift Keybind)
local isOpen = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        isOpen = not isOpen
        gui.Enabled = isOpen
        BlurEffect.Enabled = isOpen
    end
end)

-- Make UI Draggable (PC & Mobile)
local dragging, dragInput, startPos, dragStart

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = main.Position

    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

local function updateDrag(input)
    if dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)

main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput then
        updateDrag(input)
    end
end)

-- Function to Create Buttons
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
