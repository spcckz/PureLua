-- Player Options Additions
local playerOptions = {
    superPunch = { enabled = false }
}

-- Enable/Disable Super Punch
local function toggleSuperPunch()
    playerOptions.superPunch.enabled = not playerOptions.superPunch.enabled
end

-- Add Player Options to the Menu
local function setupPlayerOptions()
    if not menu or not menu.menus then
        print("^1[ERROR] Menu table is not initialized. Cannot add Player Options.^7")
        return
    end

    -- Add Super Punch to the Player Options menu
    local playerOptionsMenu = menu.menus.playerOptions.items

    table.insert(playerOptionsMenu, { label = "Super Punch", toggle = false, action = function(item)
        toggleSuperPunch()
        item.toggle = playerOptions.superPunch.enabled
    end })
end

-- Super Punch Logic
AddEventHandler('gameEventTriggered', function(eventName, data)
    if eventName == 'CEventNetworkEntityDamage' and playerOptions.superPunch.enabled then
        local victim = data[1]
        local attacker = data[2]

        if attacker == PlayerPedId() and DoesEntityExist(victim) then
            -- Determine if the victim is an NPC or a vehicle
            local isNPC = IsEntityAPed(victim) and not IsPedAPlayer(victim)
            local isVehicle = IsEntityAVehicle(victim)

            -- Get the player's heading and calculate the forward vector
            local playerHeading = GetEntityHeading(attacker)
            local radians = math.rad(playerHeading)
            local forwardVector = vector3(-math.sin(radians), math.cos(radians), 0.0)

            -- Combine the forward vector with upward velocity
            local forwardForce = isVehicle and 40.0 or 15.0 -- Stronger forward force for vehicles
            local upwardForce = isVehicle and 10.0 or 8.0  -- Reduced upward force for vehicles
            local velocity = forwardVector * forwardForce + vector3(0.0, 0.0, upwardForce)

            if isNPC then
                -- Apply ragdoll effect
                SetPedToRagdoll(victim, 5000, 5000, 0, true, true, false)

                -- Set the NPC's velocity directly
                SetEntityVelocity(victim, velocity.x, velocity.y, velocity.z)

                -- Debugging: Log calculated velocity for NPCs
                print(string.format("NPC Velocity: %.2f, %.2f, %.2f", velocity.x, velocity.y, velocity.z))
            elseif isVehicle then
                -- Ensure the vehicle is dynamic and responds to physics
                SetEntityDynamic(victim)
                FreezeEntityPosition(victim, false)

                -- Apply force to the vehicle
                ApplyForceToEntity(
                    victim,
                    1, -- Force type
                    forwardVector.x * forwardForce,
                    forwardVector.y * forwardForce,
                    upwardForce * 5.0, -- Reduced upward force
                    0.0, 0.0, 0.0, -- No torque
                    0, -- Apply to the whole entity
                    false, -- Not relative
                    true, -- Ignore mass
                    true, -- Apply globally
                    false -- Do not disable collisions
                )

                -- Debugging: Log force applied to vehicles
                print(string.format("Vehicle Force: %.2f, %.2f, %.2f", forwardVector.x * forwardForce, forwardVector.y * forwardForce, upwardForce * 10.0))

                -- Create a thread to monitor the vehicle's landing
                Citizen.CreateThread(function()
                    while DoesEntityExist(victim) do
                        Citizen.Wait(50)

                        -- Check if the vehicle is on the ground and nearly stationary
                        local velocity = GetEntityVelocity(victim)
                        local speed = math.sqrt(velocity.x^2 + velocity.y^2 + velocity.z^2)
                        local isInAir = IsEntityInAir(victim)

                        if speed < 10.0 and not isInAir then
                            AddExplosion(GetEntityCoords(victim), 5, 5.0, true, false, 1.0)
                            print("Vehicle exploded on landing!")
                            break
                        end
                    end
                end)
            end
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
