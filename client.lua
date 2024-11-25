menu = { -- Changed from local to global
    isVisible = false,
    currentMenu = "main", -- Tracks the current menu context
    selectedIndex = 1, -- Tracks selected item index
    menus = { -- Define menu structure here
        main = {
            title = "Main Menu",
            items = {
                { label = "Player Options", submenu = "playerOptions" },
                { label = "Vehicle Options", submenu = "vehicleOptions" }
            }
        },
        playerOptions = {
            title = "Player Options",
            items = {
                { label = "God Mode", toggle = false, action = function(item)
                    item.toggle = not item.toggle
                    SetEntityInvincible(PlayerPedId(), item.toggle)
                    notify("God Mode: " .. (item.toggle and "Enabled" or "Disabled"))
                end },
                { label = "Back", submenu = "main" }
            }
        },
        vehicleOptions = {
            title = "Vehicle Options",
            items = {
                { label = "Repair Vehicle", action = function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    if vehicle ~= 0 then
                        SetVehicleFixed(vehicle)
                        notify("Vehicle Repaired!")
                    else
                        notify("You are not in a vehicle!")
                    end
                end },
                { label = "Back", submenu = "main" }
            }
        }
    }
}

-- Draw the menu
function drawMenu()
    if not menu.isVisible then return end

    -- Get current menu
    local currentMenu = menu.menus[menu.currentMenu]
    if not currentMenu then return end

    -- Calculate box dimensions
    local entryHeight = 0.035 -- Height per entry
    local totalEntries = #currentMenu.items
    local boxHeight = (totalEntries * entryHeight) + 0.06 -- Add padding
    local boxY = 0.15 + (boxHeight / 2) - 0.0175 -- Center the box vertically

    -- Draw background box
    DrawRect(0.5, boxY, 0.3, boxHeight, 0, 0, 0, 150) -- Transparent black box

    -- Draw menu title
    DrawRect(0.5, 0.1, 0.3, 0.05, 0, 0, 0, 200) -- Black background for title
    drawText(currentMenu.title, 0.5, 0.075, 0.7)

    -- Draw menu options
    for i, item in ipairs(currentMenu.items) do
        local yPos = 0.15 + (i * entryHeight)

        -- Only draw highlighted rectangle for the selected option
        if i == menu.selectedIndex then
            DrawRect(0.5, yPos, 0.3, entryHeight, 255, 255, 255, 200) -- Highlighted rectangle
        end

        -- Draw the text for the menu option
        local textColor = (i == menu.selectedIndex) and {0, 0, 0, 255} or {255, 255, 255, 255}
        drawText(item.label .. (item.toggle ~= nil and (" [" .. (item.toggle and "ON" or "OFF") .. "]") or ""),
                 0.5, yPos - 0.016, 0.5, textColor)
    end
end

-- Handle menu controls
function handleMenuControls()
    if not menu.isVisible then return end

    -- Navigate Up
    if IsControlJustPressed(1, 172) then -- Arrow Up
        menu.selectedIndex = menu.selectedIndex > 1 and menu.selectedIndex - 1 or #menu.menus[menu.currentMenu].items
    end

    -- Navigate Down
    if IsControlJustPressed(1, 173) then -- Arrow Down
        menu.selectedIndex = menu.selectedIndex < #menu.menus[menu.currentMenu].items and menu.selectedIndex + 1 or 1
    end

    -- Select Item
    if IsControlJustPressed(1, 201) then -- Enter
        local currentMenu = menu.menus[menu.currentMenu]
        local selectedItem = currentMenu.items[menu.selectedIndex]

        if selectedItem then
            if selectedItem.submenu then
                menu.currentMenu = selectedItem.submenu
                menu.selectedIndex = 1
            elseif selectedItem.action then
                selectedItem.action(selectedItem)
            end
        end
    end

    -- Back
    if IsControlJustPressed(1, 202) then -- Backspace
        if menu.currentMenu ~= "main" then
            menu.currentMenu = "main"
            menu.selectedIndex = 1
        else
            menu.isVisible = false
        end
    end
end

-- Draw text helper
function drawText(text, x, y, scale, color)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(table.unpack(color or {255, 255, 255, 255}))
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Notifications helper
function notify(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, true)
end

-- Keybind to open/close the menu
Citizen.CreateThread(function()
    RegisterCommand('openMenu', function()
        menu.isVisible = not menu.isVisible
        menu.selectedIndex = 1
        menu.currentMenu = "main"
    end, false)

    RegisterKeyMapping('openMenu', 'Open Custom Menu', 'keyboard', 'K')

    while true do
        Citizen.Wait(0)
        drawMenu()
        handleMenuControls()
    end
end)
