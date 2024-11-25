# PureLua Mod Menu

---

### About PureLua

PureLua is a modular mod menu for FiveM servers, letting you easily add custom scripts, subcategories, and options. Create features like explosive ammo, super punch, and more! With PureLua, the possibilities are endless—your imagination is the limit!

---

### Tutorial: How to Extend PureLua

This tutorial explains how to:
1. **Add New Scripts**
2. **Move Subdirectories**
3. **Add Options to Subdirectories**

---

### 1. Adding New Scripts

You can create new `.lua` files to hook into the PureLua menu.

#### Steps:
1. **Create a New Script**:
   - Example: `example.lua`.

2. **Add Functionality**:
   ```lua
   -- example.lua
   local function showExampleMessage()
       print("Example script is working!")
   end

   local function setupExampleMenu()
       if not menu or not menu.menus then
           print("^1[ERROR] Menu not initialized.^7")
           return
       end

       table.insert(menu.menus.main.items, {
           label = "Example Option",
           action = function() showExampleMessage() end
       })
   end

   Citizen.CreateThread(setupExampleMenu)

### Include It in fxmanifest.lua:

Add your script:
```lua
client_scripts {
    'client.lua',
    'example.lua'
}

### Restart the Resource:

Use the following commands in the server console:
refresh
ensure your_resource_name
