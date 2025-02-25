local UserInputService = game:GetService("UserInputService")

local Spectre = {}

function Spectre:CreateWindow(windowTitle)
    local window = {}

    -- Create Blur Effect
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 0
    blurEffect.Parent = game.Lighting

    -- Create GUI
    local gui = Instance.new("ScreenGui")
    gui.Parent = game.CoreGui
    gui.ResetOnSpawn = false
    gui.Enabled = false  -- UI starts hidden

    -- Main Window
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 2
    mainFrame.Parent = gui

    -- Draggable
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    -- Title Bar
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Text = windowTitle or "Spectre UI"
    titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Parent = mainFrame

    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabContainer.Parent = mainFrame

    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, 0, 1, -60)
    contentContainer.Position = UDim2.new(0, 0, 0, 60)
    contentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentContainer.Parent = mainFrame

    -- Functions
    window.Gui = gui
    window.MainFrame = mainFrame
    window.TabContainer = tabContainer
    window.ContentContainer = contentContainer
    window.Tabs = {}

    -- UI Visibility Toggle
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightShift then
            gui.Enabled = not gui.Enabled
            blurEffect.Size = gui.Enabled and 10 or 0
        end
    end)

    function window:CreateTab(name)
        local tab = {}
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.Text = name
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Parent = tabContainer

        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contentContainer

        tab.Elements = {}

        function tab:CreateButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 40)
            btn.Position = UDim2.new(0, 10, 0, #self.Elements * 45)
            btn.Text = text
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Parent = tabContent
            btn.MouseButton1Click:Connect(callback)
            table.insert(self.Elements, btn)
            return btn
        end

        function tab:CreateToggle(text, default, callback)
            local tog = Instance.new("TextButton")
            tog.Size = UDim2.new(1, -20, 0, 40)
            tog.Position = UDim2.new(0, 10, 0, #self.Elements * 45)
            local state = default or false
            tog.Text = text .. " [" .. (state and "ON" or "OFF") .. "]"
            tog.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            tog.TextColor3 = Color3.fromRGB(255, 255, 255)
            tog.Parent = tabContent
            tog.MouseButton1Click:Connect(function()
                state = not state
                tog.Text = text .. " [" .. (state and "ON" or "OFF") .. "]"
                tog.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
                callback(state)
            end)
            table.insert(self.Elements, tog)
            return tog
        end

        function tab:CreateLabel(text)
            local lab = Instance.new("TextLabel")
            lab.Size = UDim2.new(1, -20, 0, 30)
            lab.Position = UDim2.new(0, 10, 0, #self.Elements * 35)
            lab.Text = text
            lab.BackgroundTransparency = 1
            lab.TextColor3 = Color3.fromRGB(255, 255, 255)
            lab.Parent = tabContent
            table.insert(self.Elements, lab)
            return lab
        end

        tabButton.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(window.Tabs) do
                if otherTab.Content then otherTab.Content.Visible = false end
            end
            tabContent.Visible = true
        end)

        tab.Content = tabContent
        table.insert(window.Tabs, tab)
        return tab
    end

    return window
end

return Spectre
