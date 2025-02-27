-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

-- Configuration
local API_URL = "http://77.90.25.242:3000/send"
local GROUP_ID = "120363390819557854@g.us"

-- Function to send logs
local function sendLog(logType, message)
    local data = {
        groupId = GROUP_ID,
        message = "[" .. logType .. "] " .. message
    }
    
    local success, response = pcall(function()
        return HttpService:PostAsync(API_URL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("[LOGGER] Sent log:", message)
    else
        warn("[LOGGER ERROR] Failed to send log:", response)
    end
end

-- Create GUI Indicator
local function createLoggerGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LoggerGUI"
    ScreenGui.Parent = game.CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 400, 0, 100)  -- Increased Size
    Frame.Position = UDim2.new(0.5, -200, 0, 20)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.3
    Frame.BorderSizePixel = 2
    Frame.Parent = ScreenGui

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextScaled = true
    Label.Text = "⚡ Logger Running..."
    Label.Font = Enum.Font.SourceSansBold
    Label.Parent = Frame

    sendLog("INFO", "Logger GUI Loaded Successfully.") -- Log GUI Loaded
end

-- Player Join Logging
Players.PlayerAdded:Connect(function(player)
    sendLog("JOIN", player.Name .. " has joined the game.")
end)

-- Player Leave Logging
Players.PlayerRemoving:Connect(function(player)
    sendLog("LEAVE", player.Name .. " has left the game.")
end)

-- Chat Logging
local function onPlayerChatted(player, message)
    sendLog("CHAT", player.Name .. ": " .. message)
end

for _, player in pairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end)

-- Error Logging
local function logError(message)
    sendLog("ERROR", message)
end

-- Example Usage
sendLog("INFO", "Logger has started successfully.")

-- Run GUI
createLoggerGUI()
