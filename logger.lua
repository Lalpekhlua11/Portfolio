local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local API_URL = "http://77.90.25.242:3000/send"
local GROUP_ID = "120363390819557854@g.us"

-- Function to send logs
local function sendLog(logType, message)
    local jsonData = HttpService:JSONEncode({
        groupId = GROUP_ID,
        message = "[" .. logType .. "] " .. message
    })

    -- Detect the correct HTTP request function
    local requestFunction = request or syn.request or http_request

    if requestFunction then
        local success, response = pcall(function()
            return requestFunction({
                Url = API_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        end)

        if success then
            print("✅ Log Sent: " .. message)
        else
            warn("⚠️ Failed to send log: " .. tostring(response))
        end
    else
        warn("⚠️ Your executor does not support HTTP requests.")
    end
end

-- 📌 Log Player Join & Leave
Players.PlayerAdded:Connect(function(player)
    sendLog("Player Join", player.Name .. " joined the game.")
end)

Players.PlayerRemoving:Connect(function(player)
    sendLog("Player Leave", player.Name .. " left the game.")
end)

-- 📌 Log Chat Messages
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        sendLog("Chat", player.Name .. ": " .. message)
    end)
end)

-- 📌 Log Fruit Pickups
ReplicatedStorage.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and string.find(child.Name, "Fruit") then
        sendLog("Fruit Pickup", Players.LocalPlayer.Name .. " picked up a " .. child.Name)
    end
end)

-- 📌 Log Boss Kills
ReplicatedStorage.ChildRemoved:Connect(function(child)
    if string.find(child.Name, "Boss") then
        sendLog("Boss Defeat", Players.LocalPlayer.Name .. " defeated " .. child.Name)
    end
end)

-- 📌 Log Sword & Gun Pickups
ReplicatedStorage.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and (string.find(child.Name, "Katana") or string.find(child.Name, "Gun")) then
        sendLog("Weapon Pickup", Players.LocalPlayer.Name .. " obtained " .. child.Name)
    end
end)

-- 📌 Log Damage Taken & Dealt
local function onDamageEvent(attacker, victim, damage)
    if attacker and victim then
        sendLog("Damage", attacker.Name .. " dealt " .. tostring(damage) .. " damage to " .. victim.Name)
    end
end

-- 📌 Log Purchases (NPC Shops)
local function onPurchase(player, item)
    sendLog("Purchase", player.Name .. " bought " .. item)
end

-- 📌 Log Ability Usage (Superhuman, Electric Claw, etc.)
local function onAbilityUsed(player, ability)
    sendLog("Ability", player.Name .. " used " .. ability)
end

print("🔥 Blox Fruits Advanced Logger Loaded! 🔥"
