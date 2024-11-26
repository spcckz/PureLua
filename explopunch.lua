-- Player Options Additions
local playerOptions = {
    explosivePunch = { enabled = false }
}

-- Enable/Disable Explosive Punch
local function toggleExplosivePunch()
    playerOptions.explosivePunch.enabled = not playerOptions.explosivePunch.enabled
end

-- Add Player Options to the Menu
local function setupPlayerOptions()
    if not menu or not menu.menus then
        print("^1[ERROR] Menu table is not initialized. Cannot add Player Options.^7")
        return
    end

    -- Add Explosive Punch to the Player Options menu
    local playerOptionsMenu = menu.menus.playerOptions.items

    table.insert(playerOptionsMenu, { label = "Explosive Punch", toggle = false, action = function(item)
        toggleExplosivePunch()
        item.toggle = playerOptions.explosivePunch.enabled
    end })
end

-- Explosive Punch Logic
AddEventHandler('gameEventTriggered', function(eventName, data)
    if eventName == 'CEventNetworkEntityDamage' and playerOptions.explosivePunch.enabled then
        local victim = data[1]
        local attacker = data[2]

        if attacker == PlayerPedId() and DoesEntityExist(victim) then
            -- Get the coordinates of the entity punched
            local victimCoords = GetEntityCoords(victim)

            -- Trigger explosion at the entity's position
            AddExplosion(victimCoords.x, victimCoords.y, victimCoords.z, 1, 5.0, true, false, 1.0)

            -- Debugging: Log the explosion
            print(string.format("Explosion triggered at: %.2f, %.2f, %.2f", victimCoords.x, victimCoords.y, victimCoords.z))
        end
    end
end)

-- Initialize Player Options
Citizen.CreateThread(function()
    setupPlayerOptions()
end)

-- Notifications helper
function notify(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, true)
end
