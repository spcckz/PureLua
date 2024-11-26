-- Paint Data
local paints = {
    {id = 161, name = "Anodized Red"}, {id = 162, name = "Anodized Wine"}, {id = 163, name = "Anodized Purple"},
    {id = 164, name = "Anodized Blue"}, {id = 165, name = "Anodized Green"}, {id = 166, name = "Anodized Lime"},
    {id = 167, name = "Anodized Copper"}, {id = 168, name = "Anodized Bronze"}, {id = 169, name = "Anodized Champagne"},
    {id = 170, name = "Anodized Gold"}, {id = 171, name = "Green Blue Flip"}, {id = 172, name = "Green Red Flip"},
    {id = 173, name = "Green Brown Flip"}, {id = 174, name = "Green Turquoise Flip"}, {id = 175, name = "Green Purple Flip"},
    {id = 176, name = "Teal Purple Flip"}, {id = 177, name = "Turquoise Red Flip"}, {id = 178, name = "Turquoise Purple Flip"},
    {id = 179, name = "Cyan Purple Flip"}, {id = 180, name = "Blue Pink Flip"}, {id = 181, name = "Blue Green Flip"},
    {id = 182, name = "Purple Red Flip"}, {id = 183, name = "Purple Green Flip"}, {id = 184, name = "Magenta Green Flip"},
    {id = 185, name = "Magenta Yellow Flip"}, {id = 186, name = "Burgundy Green Flip"}, {id = 187, name = "Magenta Cyan Flip"},
    {id = 188, name = "Copper Purple Flip"}, {id = 189, name = "Magenta Orange Flip"}, {id = 190, name = "Red Orange Flip"},
    {id = 191, name = "Orange Purple Flip"}, {id = 192, name = "Orange Blue Flip"}, {id = 193, name = "White Purple Flip"},
    {id = 194, name = "Red Rainbow Flip"}, {id = 195, name = "Blue Rainbow Flip"}, {id = 196, name = "Dark Green Pearl"},
    {id = 197, name = "Dark Teal Pearl"}, {id = 198, name = "Dark Blue Pearl"}, {id = 199, name = "Dark Purple Pearl"},
    {id = 200, name = "Oil Slick Pearl"}, {id = 201, name = "Light Green Pearl"}, {id = 202, name = "Light Blue Pearl"},
    {id = 203, name = "Light Purple Pearl"}, {id = 204, name = "Light Pink Pearl"}, {id = 205, name = "Off White Pearl"},
    {id = 206, name = "Pink Pearl"}, {id = 207, name = "Yellow Pearl"}, {id = 208, name = "Green Pearl"},
    {id = 209, name = "Blue Pearl"}, {id = 210, name = "Cream Pearl"}, {id = 211, name = "White Prismatic"},
    {id = 212, name = "Graphite Prismatic"}, {id = 213, name = "Dark Blue Prismatic"}, {id = 214, name = "Dark Purple Prismatic"},
    {id = 215, name = "Hot Pink Prismatic"}, {id = 216, name = "Dark Red Prismatic"}, {id = 217, name = "Dark Green Prismatic"},
    {id = 218, name = "Black Prismatic"}, {id = 219, name = "Black Oil Spill"}, {id = 220, name = "Black Rainbow"},
    {id = 221, name = "Black Holographic"}, {id = 222, name = "White Holographic"}, {id = 223, name = "Anodized Monochrome"},
    {id = 224, name = "Day Night Flip"}, {id = 225, name = "Verlierer Flip"}, {id = 226, name = "Anodized Sprunk"},
    {id = 227, name = "Vice City Flip"}, {id = 228, name = "Synthwave Pearl"}, {id = 229, name = "Seasons Flip"},
    {id = 230, name = "TBOGT Pearl"}, {id = 231, name = "Bubblegum Pearl"}, {id = 232, name = "Rainbow Prismatic"},
    {id = 233, name = "Sunset Flip"}, {id = 234, name = "Visions Prismatic"}, {id = 235, name = "Maziora Prismatic"},
    {id = 236, name = "3DGlasses Flip"}, {id = 237, name = "Christmas Flip"}, {id = 238, name = "Temperature Prismatic"},
    {id = 239, name = "HSW Flip"}, {id = 240, name = "Anodized Electro"}, {id = 241, name = "Monika Prismatic"},
    {id = 242, name = "Anodized Fubuki"}
}

-- Get Paint Name By ID
local function getPaintNameById(id)
    for _, paint in ipairs(paints) do
        if paint.id == id then
            return paint.name
        end
    end
    return "Unknown Paint"
end

-- Current Paint Indices
local primaryPaintIndex = 161
local secondaryPaintIndex = 161
local rimPaintIndex = 161

-- Update Paints
local function updatePaints(vehicle, type)
    local primaryColor, secondaryColor = GetVehicleColours(vehicle) -- Retrieve current colors

    if type == "primary" then
        -- Update only the primary paint
        SetVehicleColours(vehicle, primaryPaintIndex, secondaryColor)
    elseif type == "secondary" then
        -- Update only the secondary paint
        SetVehicleColours(vehicle, primaryColor, secondaryPaintIndex)
    elseif type == "rim" then
        -- Update only the rim paint
        SetVehicleExtraColours(vehicle, 0, rimPaintIndex)
    end
end

-- Create Paint Menu
local function setupPaintMenu()
    if not menu or not menu.menus then
        print("^1[ERROR] Menu table is not initialized. Cannot add Paint Options.^7")
        return
    end

    menu.menus.paintOptions = {
        title = "Paint Options",
        items = {
            { label = "Primary Paint: " .. getPaintNameById(primaryPaintIndex), action = function(isIncrement)
                primaryPaintIndex = isIncrement and (primaryPaintIndex + 1) or (primaryPaintIndex - 1)
                if primaryPaintIndex > 242 then primaryPaintIndex = 161 elseif primaryPaintIndex < 161 then primaryPaintIndex = 242 end
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle ~= 0 then updatePaints(vehicle, "primary") end
            end },
            { label = "Secondary Paint: " .. getPaintNameById(secondaryPaintIndex), action = function(isIncrement)
                secondaryPaintIndex = isIncrement and (secondaryPaintIndex + 1) or (secondaryPaintIndex - 1)
                if secondaryPaintIndex > 242 then secondaryPaintIndex = 161 elseif secondaryPaintIndex < 161 then secondaryPaintIndex = 242 end
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle ~= 0 then updatePaints(vehicle, "secondary") end
            end },
            { label = "Rim Paint: " .. getPaintNameById(rimPaintIndex), action = function(isIncrement)
                rimPaintIndex = isIncrement and (rimPaintIndex + 1) or (rimPaintIndex - 1)
                if rimPaintIndex > 242 then rimPaintIndex = 161 elseif rimPaintIndex < 161 then rimPaintIndex = 242 end
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle ~= 0 then updatePaints(vehicle, "rim") end
            end },
            { label = "Back", submenu = "vehicleOptions" } -- Updated to return to Vehicle Options
        }
    }

    -- Dynamically add Paint Options under Vehicle Options
    Citizen.CreateThread(function()
        -- Ensure Paint Options is not already in main menu
        for i, item in ipairs(menu.menus.main.items) do
            if item.label == "Paint Options" then
                table.remove(menu.menus.main.items, i)
                break
            end
        end

        -- Add Paint Options to Vehicle Options
        table.insert(menu.menus.vehicleOptions.items, {
            label = "Paint Options",
            submenu = "paintOptions"
        })
    end)
end

-- Update Paint Names Dynamically
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if menu.isVisible and menu.currentMenu == "paintOptions" then
            local currentMenu = menu.menus.paintOptions.items
            currentMenu[1].label = "Primary Paint: " .. getPaintNameById(primaryPaintIndex)
            currentMenu[2].label = "Secondary Paint: " .. getPaintNameById(secondaryPaintIndex)
            currentMenu[3].label = "Rim Paint: " .. getPaintNameById(rimPaintIndex)

            -- Listen for Left/Right Arrow Keys or D-Pad Left/Right
            local selectedItem = currentMenu[menu.selectedIndex]
            if selectedItem and selectedItem.action then
                if IsControlJustPressed(1, 174) then -- Left Arrow / D-Pad Left
                    selectedItem.action(false) -- Cycle backward
                elseif IsControlJustPressed(1, 175) then -- Right Arrow / D-Pad Right
                    selectedItem.action(true) -- Cycle forward
                end
            end
        end
    end
end)

-- Initialize Paint Menu
Citizen.CreateThread(function()
    setupPaintMenu()
end)
