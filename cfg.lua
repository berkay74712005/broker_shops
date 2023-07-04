ESX = exports['es_extended']:getSharedObject()
ShopsCfg = {}

ShopsCfg.useCheezaInventory = true

ShopsCfg.Shops = {
    ['Ikea'] = {
        Blip = {
            Sprite  = 52,
            Display = 4,
            Scale   = 0.7,
            Name    = "Shop",
            Color  = 39,
        },
        Categories = {
            ['food'] = 'Food',
            ['materials'] = 'Materials',
        },
        Items = {
            {label = "Bread", item = "bread", price = 100, type= "item", category = 'food', img = './assets/items/bread.png'},
            {label = "Water", item = "water", price = 50, type= "item", category = 'food', img = './assets/items/bread.png'},
            {label = "Wood", item = "wood", price = 175, type= "weapon", category = 'materials', img = './assets/items/bread.png'},
            {label = "Scope", item = "scope", price = 50, type= "weapon", category = 'materials', img = './assets/items/bread.png'},
        },
        Pos = {
            {x = 1135.808,  y = -982.281,  z = 45.415},
            {x = -1222.915, y = -906.983,  z = 11.326},
            {x = -1487.553, y = -379.107,  z = 39.163},
            {x = -2968.243, y = 390.910,   z = 14.043},
            {x = 1166.024,  y = 2708.930,  z = 37.157},
            {x = 1392.562,  y = 3604.684,  z = 33.980},
            {x = 25.723,    y = -1346.966, z = 28.497}, 
            {x = -1393.409, y = -606.624,  z = 29.319},
        },
        Marker = {
            DrawDistance = 10,
            Type = 1,
            Color = {r = 0, g = 128, b = 255},
            Size  = {x = 1.5, y = 1.5, z = 1.5},
        },  
        JobLock = true,
        job = "taxi",
    },
}

ShopsCfg.pressE = function(text) 
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('broker_shops:showNotification')
AddEventHandler('broker_shops:showNotification', function(msg)
    ESX.ShowNotification(msg)
end)

ShopsCfg.ServerNotify = function(src, msg) 
    TriggerClientEvent('broker_shops:showNotification', src, msg)
end

ShopsCfg.Locales = {
    ['pressE'] = 'Press E to open Shop',
    ['paidCart'] = 'You paid for your shopping cart',
    ['noAccess'] = 'You dont have access to this shop',
    ['notEnoughMoney'] = 'You dont have enough money',
}