-- Wait for the global table
repeat task.wait() until getgenv().ExunysDeveloperAimbot
local AimbotData = getgenv().ExunysDeveloperAimbot

-- 1. RAINBOW LOOP LOGIC (Handles the visual cycle)
task.spawn(function()
    while task.wait() do
        if AimbotData.FOVSettings.RainbowColor then
            local Hue = tick() % 5 / 5
            AimbotData.FOVSettings.Color = Color3.fromHSV(Hue, 1, 1)
        end
    end
end)

-- 2. GUI Root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Exunys_V3_Ultimate_Panel"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- 3. Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 450)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

-- 4. Header & Minimize
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "AIMBOT V3 CONFIG"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -30, 0, 0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Parent = Header

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 4
ContentFrame.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = ContentFrame
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 5. Builder Logic
local function CreateLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Text = "--- " .. text .. " ---"
    lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    lbl.Font = Enum.Font.SourceSansBold
    lbl.Parent = ContentFrame
end

local function CreateToggle(name, tableRef, key)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 220, 0, 30)
    Btn.BackgroundColor3 = tableRef[key] and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(80, 40, 40)
    Btn.Text = name .. ": " .. (tableRef[key] and "ON" or "OFF")
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Parent = ContentFrame
    
    Btn.MouseButton1Click:Connect(function()
        tableRef[key] = not tableRef[key]
        Btn.Text = name .. ": " .. (tableRef[key] and "ON" or "OFF")
        Btn.BackgroundColor3 = tableRef[key] and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(80, 40, 40)
    end)
end

local function CreateAdjuster(name, tableRef, key, step, min)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 220, 0, 45)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ContentFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = name .. ": " .. tostring(tableRef[key])
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Add = Instance.new("TextButton")
    Add.Text = "+"
    Add.Size = UDim2.new(0.5, -5, 0, 25)
    Add.Position = UDim2.new(0.5, 2, 0, 20)
    Add.Parent = Frame

    local Sub = Instance.new("TextButton")
    Sub.Text = "-"
    Sub.Size = UDim2.new(0.5, -5, 0, 25)
    Sub.Position = UDim2.new(0, 2, 0, 20)
    Sub.Parent = Frame

    Add.MouseButton1Click:Connect(function()
        tableRef[key] = tableRef[key] + step
        Label.Text = name .. ": " .. tostring(tableRef[key])
    end)
    Sub.MouseButton1Click:Connect(function()
        tableRef[key] = math.max(min or 0, tableRef[key] - step)
        Label.Text = name .. ": " .. tostring(tableRef[key])
    end)
end

-- 6. Config Sections
CreateLabel("MAIN")
CreateToggle("Master Enabled", AimbotData.Settings, "Enabled")

CreateLabel("CHECKS")
CreateToggle("Wall Check", AimbotData.Settings, "WallCheck")
CreateToggle("Team Check", AimbotData.Settings, "TeamCheck")
CreateToggle("Alive Check", AimbotData.Settings, "AliveCheck")

CreateLabel("LOCK SETTINGS")
CreateAdjuster("Smoothness", AimbotData.Settings, "Sensitivity", 0.1, 0)
CreateAdjuster("Prediction Offset", AimbotData.Settings, "OffsetIncrement", 1, 1)
CreateToggle("Lock Toggle Mode", AimbotData.Settings, "Toggle")

CreateLabel("FOV SETTINGS")
CreateToggle("Show FOV", AimbotData.FOVSettings, "Visible")
CreateToggle("Filled FOV", AimbotData.FOVSettings, "Filled")
CreateAdjuster("FOV Radius", AimbotData.FOVSettings, "Radius", 5, 0)
CreateAdjuster("FOV Transparency", AimbotData.FOVSettings, "Transparency", 0.1, 0)
CreateAdjuster("FOV Sides", AimbotData.FOVSettings, "NumSides", 1, 3)
CreateToggle("Rainbow FOV", AimbotData.FOVSettings, "RainbowColor")

CreateLabel("DANGER ZONE")
local OffBtn = Instance.new("TextButton")
OffBtn.Size = UDim2.new(0, 220, 0, 40)
OffBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
OffBtn.Text = "OFF AIMBOT (UNLOAD)"
OffBtn.TextColor3 = Color3.new(1, 1, 1)
OffBtn.Font = Enum.Font.SourceSansBold
OffBtn.Parent = ContentFrame

OffBtn.MouseButton1Click:Connect(function()
    if AimbotData.Unload then
        AimbotData:Unload() 
    else
        AimbotData.Settings.Enabled = false
        AimbotData.FOVSettings.Visible = false
    end
    ScreenGui:Destroy()
end)

-- 7. Minimize/Toggle Logic
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ContentFrame.Visible = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 250, 0, 30) or UDim2.new(0, 250, 0, 450)
    MinBtn.Text = isMinimized and "+" or "-"
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.P then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
