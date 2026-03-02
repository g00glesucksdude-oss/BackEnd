local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local FILE_NAME = "LobbyDatabase.json"
local player = Players.LocalPlayer

-- [[ DATA PERSISTENCE LOGIC ]] --
local function loadData()
    local success, content = pcall(function()
        if isfile(FILE_NAME) then
            return HttpService:JSONDecode(readfile(FILE_NAME))
        end
    end)
    return (success and content) or {}
end

local function saveData(data)
    writefile(FILE_NAME, HttpService:JSONEncode(data))
end

local nameCache = {}
local function getPlaceName(id)
    if nameCache[id] then return nameCache[id] end
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(tonumber(id))
    end)
    if success and info then
        nameCache[id] = info.Name
        return info.Name
    end
    return "Game: " .. id
end

-- [[ GUI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true

local SearchBar = Instance.new("TextBox", MainFrame)
SearchBar.Size = UDim2.new(1, -20, 0, 30)
SearchBar.Position = UDim2.new(0, 10, 0, 10)
SearchBar.PlaceholderText = "Search Game or Server ID..."
SearchBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SearchBar.TextColor3 = Color3.new(1, 1, 1)

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -100)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 5)

-- [[ REFRESH UI WITH SEARCH LOGIC ]] --
local function refreshUI()
    local filter = SearchBar.Text:lower()
    for _, child in ipairs(Scroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
    end
    
    local data = loadData()
    for pId, lobbies in pairs(data) do
        local gameName = getPlaceName(pId)
        if gameName:lower():find(filter) or pId:find(filter) then
            -- Category Header
            local Header = Instance.new("TextLabel", Scroll)
            Header.Size = UDim2.new(1, 0, 0, 25)
            Header.Text = "  " .. gameName:upper()
            Header.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            Header.TextColor3 = Color3.fromRGB(200, 200, 255)
            Header.TextXAlignment = Enum.TextXAlignment.Left

            for i, jobId in ipairs(lobbies) do
                local Row = Instance.new("Frame", Scroll)
                Row.Size = UDim2.new(1, 0, 0, 30)
                Row.BackgroundTransparency = 1

                local JoinBtn = Instance.new("TextButton", Row)
                JoinBtn.Size = UDim2.new(0.8, -5, 1, 0)
                JoinBtn.Text = "Server #" .. i .. " [" .. jobId:sub(1,8) .. "]"
                JoinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                JoinBtn.TextColor3 = Color3.new(1, 1, 1)

                local DelBtn = Instance.new("TextButton", Row)
                DelBtn.Size = UDim2.new(0.2, 0, 1, 0)
                DelBtn.Position = UDim2.new(0.8, 0, 0, 0)
                DelBtn.Text = "DELETE"
                DelBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                DelBtn.TextColor3 = Color3.new(1, 1, 1)
                DelBtn.TextScaled = true

                JoinBtn.MouseButton1Click:Connect(function()
                    TeleportService:TeleportToPlaceInstance(tonumber(pId), jobId, player)
                end)

                DelBtn.MouseButton1Click:Connect(function()
                    local currentData = loadData()
                    table.remove(currentData[pId], i)
                    if #currentData[pId] == 0 then currentData[pId] = nil end
                    saveData(currentData)
                    refreshUI()
                end)
            end
        end
    end
end

-- [[ SAVE LOGIC WITH DUPLICATE CHECK ]] --
local SaveBtn = Instance.new("TextButton", MainFrame)
SaveBtn.Size = UDim2.new(1, -20, 0, 35)
SaveBtn.Position = UDim2.new(0, 10, 1, -40)
SaveBtn.Text = "SAVE CURRENT LOBBY"
SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
SaveBtn.TextColor3 = Color3.new(1, 1, 1)

SaveBtn.MouseButton1Click:Connect(function()
    local data = loadData()
    local pId = tostring(game.PlaceId)
    local jId = game.JobId
    
    if jId == "" or not jId then 
        warn("Cannot save in Studio or invalid JobId") 
        return 
    end

    if not data[pId] then data[pId] = {} end
    
    -- Check if JobId is already saved
    local isDuplicate = false
    for _, existingId in ipairs(data[pId]) do
        if existingId == jId then
            isDuplicate = true
            break
        end
    end
    
    if not isDuplicate then
        table.insert(data[pId], jId)
        saveData(data)
        refreshUI()
    else
        SaveBtn.Text = "ALREADY SAVED!"
        task.wait(1)
        SaveBtn.Text = "SAVE CURRENT LOBBY"
    end
end)

SearchBar:GetPropertyChangedSignal("Text"):Connect(refreshUI)
refreshUI()
