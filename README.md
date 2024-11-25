# Adding a New Script (.lua) to the Menu

## 1. Adding a New Script (.lua) to the Menu
To add functionality to the menu via a new `.lua` file:

### Steps:

#### 1. Create a New `.lua` File:
- Example: `example.lua`

#### 2. Define Your Functionality:
In the new file, include any code for your desired functionality. For example:

```lua
-- example.lua
local function showExampleMessage()
    print("Example script is working!")
end

-- Add the option to the menu
local function setupExampleMenu()
    if not menu or not menu.menus then
        print("^1[ERROR] Menu table is not initialized. Cannot add Example Menu.^7")
        return
    end

    -- Add the Example option to the main menu
    table.insert(menu.menus.main.items, {
        label = "Example Option",
        action = function()
            showExampleMessage()
        end
    })
end

-- Initialize the Example Menu
Citizen.CreateThread(function()
    setupExampleMenu()
end)
```

#### 3. Load the Script in `fxmanifest.lua`:
Add the new script to the `client_scripts` section:

```lua
client_scripts {
    'client.lua',
    'paint.lua',
    'example.lua'
}
```

#### 4. Restart the Resource:
Use `refresh` and `ensure your_resource_name` in the server console.

#### Result:
A new option labeled **"Example Option"** will appear in the main menu.  
Selecting it will print **"Example script is working!"** to the console.

---

## 2. Moving a Subdirectory to Another Subdirectory
To move an existing submenu (e.g., **"Paint Options"**) into another submenu (e.g., **"Vehicle Options"**):

### Steps:

#### 1. Locate the Subdirectory:
Find the submenu you want to move in the `menu.menus` table.
- Example: `"paintOptions"`.

#### 2. Remove It from the Old Location:
If `"Paint Options"` is currently in the main menu:

```lua
for i, item in ipairs(menu.menus.main.items) do
    if item.label == "Paint Options" then
        table.remove(menu.menus.main.items, i)
        break
    end
end
```

#### 3. Add It to the New Location:
Add the `"Paint Options"` submenu to `"Vehicle Options"`:

```lua
table.insert(menu.menus.vehicleOptions.items, {
    label = "Paint Options",
    submenu = "paintOptions"
})
```

#### 4. Verify the Changes:
Restart the resource to ensure the submenu appears in its new location.

### Full Example: Move **"Paint Options"** Under **"Vehicle Options"**

```lua
-- Move Paint Options to Vehicle Options
Citizen.CreateThread(function()
    -- Remove Paint Options from Main Menu
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
```

---

## 3. Adding Options to a Subdirectory
To add new options to an existing submenu (e.g., **"Vehicle Options"**):

### Steps:

#### 1. Locate the Subdirectory:
Find the submenu in the `menu.menus` table.
- Example: `"vehicleOptions"`.

#### 2. Add a New Item:
Add a new option with a label and action.

Example:

```lua
table.insert(menu.menus.vehicleOptions.items, {
    label = "Toggle Engine",
    action = function()
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle ~= 0 then
            local engineOn = not GetIsVehicleEngineRunning(vehicle)
            SetVehicleEngineOn(vehicle, engineOn, true, true)
            print("Engine is now " .. (engineOn and "ON" or "OFF"))
        else
            print("You are not in a vehicle!")
        end
    end
})
```

#### 3. Restart the Resource:
Use `refresh` and `ensure your_resource_name` in the server console.

#### Result:
A new option labeled **"Toggle Engine"** will appear under **"Vehicle Options"**.  
Selecting it will toggle the engine of the vehicle you’re in.

---

## Summary
### To Add a New Script:
1. Create a `.lua` file.
2. Define your functionality and add it to the menu.
3. Add the file to `fxmanifest.lua`.
4. Restart the resource.

### To Move a Subdirectory:
1. Remove it from its current location.
2. Add it to the desired submenu.

### To Add Options to a Subdirectory:
1. Locate the submenu.
2. Use `table.insert` to add new options.
3. Restart the resource.
