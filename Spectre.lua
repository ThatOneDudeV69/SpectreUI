local Spectre = {}

function Spectre:CreateWindow(windowTitle)
    local window = {}
    local gui = Instance.new("ScreenGui")
    gui.Parent = game.CoreGui
    gui.ResetOnSpawn = false
    gui.Enabled = false
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.Parent = gui
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Text = windowTitle or "Window"
    titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Parent = mainFrame
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabContainer.Parent = mainFrame
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, 0, 1, -60)
    contentContainer.Position = UDim2.new(0, 0, 0, 60)
    contentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentContainer.Parent = mainFrame
    window.Gui = gui
    window.MainFrame = mainFrame
    window.TabContainer = tabContainer
    window.ContentContainer = contentContainer
    window.Tabs = {}
    function window:CreateTab(name)
        local tab = {}
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.Text = name or "Tab"
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
            btn.Text = text or "Button"
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Parent = tabContent
            btn.MouseButton1Click:Connect(function() callback() end)
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
        function tab:CreateDropdown(text, options, callback)
            local drop = Instance.new("TextButton")
            drop.Size = UDim2.new(1, -20, 0, 40)
            drop.Position = UDim2.new(0, 10, 0, #self.Elements * 45)
            drop.Text = text .. " : " .. (options[1] or "None")
            drop.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            drop.TextColor3 = Color3.fromRGB(255, 255, 255)
            drop.Parent = tabContent
            local open = false
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, -20, 0, 0)
            dropdownFrame.Position = UDim2.new(0, 10, 0, drop.Position.Y.Offset + 40)
            dropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdownFrame.Visible = false
            dropdownFrame.Parent = tabContent
            drop.MouseButton1Click:Connect(function()
                open = not open
                dropdownFrame.Visible = open
                if open then
                    dropdownFrame.Size = UDim2.new(1, -20, 0, #options * 40)
                else
                    dropdownFrame.Size = UDim2.new(1, -20, 0, 0)
                end
            end)
            for i, option in ipairs(options) do
                local opt = Instance.new("TextButton")
                opt.Size = UDim2.new(1, 0, 0, 40)
                opt.Position = UDim2.new(0, 0, 0, (i - 1) * 40)
                opt.Text = option
                opt.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                opt.TextColor3 = Color3.fromRGB(255, 255, 255)
                opt.Parent = dropdownFrame
                opt.MouseButton1Click:Connect(function()
                    drop.Text = text .. " : " .. option
                    callback(option)
                    open = false
                    dropdownFrame.Visible = false
                    dropdownFrame.Size = UDim2.new(1, -20, 0, 0)
                end)
            end
            table.insert(self.Elements, drop)
            return drop
        end
        function tab:CreateLabel(text)
            local lab = Instance.new("TextLabel")
            lab.Size = UDim2.new(1, -20, 0, 30)
            lab.Position = UDim2.new(0, 10, 0, #self.Elements * 35)
            lab.Text = text or "Label"
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
