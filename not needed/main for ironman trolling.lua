-- Serialized Load Center (No Parallel Breaking)
local base = "https://raw.githubusercontent.com/g00glesucksdude-oss/BackEnd/main/ironman%20trolling/"
local scripts = {
    "invis.lua",
    "aim%20assist.lua",
    "aim%20assit%20menu.lua", -- Now loads after logic is ready
    "infyy.lua",
    "iron%20balls%20meme.lua",
    "lobby%20logger.lua"
}

for _, file in ipairs(scripts) do
    local success, content = pcall(function() return game:HttpGet(base .. file) end)
    if success and content then
        local func = loadstring(content)
        if func then 
            pcall(func) 
        end
    end
    task.wait(0.3) -- Critical yield to prevent Solara race conditions
end

-- Wait for the UI to exist before adding the Toggle/Kill logic
repeat task.wait() until getgenv().ExunysDeveloperAimbot
local Aimbot = getgenv().ExunysDeveloperAimbot

-- Adding a Dynamic Toggle to your existing Menu Logic
local function MasterToggle()
    if Aimbot.Settings.Enabled then
        -- This is the "Toggle" (Just pauses it)
        Aimbot.Settings.Enabled = false
        Aimbot.FOVSettings.Visible = false
    else
        -- This turns it back on
        Aimbot.Settings.Enabled = true
        Aimbot.FOVSettings.Visible = true
    end
end

-- Adding the "Nuke" (The Unload logic we talked about)
local function NukeAimbot()
    if Aimbot.Unload then
        Aimbot:Unload() -- Completely removes it from memory
    end
end
