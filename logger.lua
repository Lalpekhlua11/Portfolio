-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

-- Configuration
local API_URL = "http://77.90.25.242:3000/send"
local GROUP_ID = "120363390819557854@g.us"

-- Create Logger GUI
local function createLoggerGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LoggerGUI"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 250, 0, 50)
    Frame.Position = UDim2.new(0.5, -125, 0, 20)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.3
    Frame.Parent = ScreenGui

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextScaled = true
    Label.Text = "Logger Running..."
    Label.Font = Enum.Font.SourceSansBold
    Label.Parent = Frame
end

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
        print("Log sent:", message)
    else
        warn("Failed to send log:", response)
    end
end

-- Logging player join/leave
Players.PlayerAdded:Connect(function(player)
    sendLog("JOIN", player.Name .. " has joined the game.")
end)

Players.PlayerRemoving:Connect(function(player)
    sendLog("LEAVE", player.Name .. " has left the game.")
end)

-- Logging player chat messages
local function onChat(player, message)
    sendLog("CHAT", player.Name .. ": " .. message)
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onChat(player, message)
    end)
end)

-- Logging player deaths
local function onCharacterAdded(character, player)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            sendLog("DEATH", player.Name .. " has died.")
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(character, player)
    end)
end)

-- Logging errors
local function onError(message)
    sendLog("ERROR", "Game Error: " .. message)
end

game:GetService("LogService").MessageOut:Connect(function(message, messageType)
    if messageType == Enum.MessageType.ErrorMessage then
        onError(message)
    end
end)

-- Run GUI
createLoggerGUI()

-- Example test log
sendLog("INFO", "Logger has started successfully.")
