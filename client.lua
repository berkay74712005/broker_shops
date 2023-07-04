local CurrentShop = nil
local ShopNUIopen = false

CreateThread(function()
    for shopn,shopd in pairs(ShopsCfg.Shops) do
        local blipdata = shopd.Blip
        for i = 1, #shopd.Pos, 1 do
            local blipos = shopd.Pos[i]
            local blip = AddBlipForCoord(tonumber(blipos.x), tonumber(blipos.y), 1.0)
            SetBlipSprite(blip, tonumber(blipdata.Sprite))
            SetBlipDisplay(blip, tonumber(blipdata.Display))
            SetBlipScale(blip, tonumber(blipdata.Scale) + 0.0)
            SetBlipColour(blip, tonumber(blipdata.Color))
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(blipdata.Name)
            EndTextCommandSetBlipName(blip)
        end
    end
    while true do
        local sleep = 500
        local playerxcoords = GetEntityCoords(PlayerPedId())
        for shopn,shopd in pairs(ShopsCfg.Shops) do
            local shopx = shopd
            for i = 1, #shopx.Pos, 1 do
                local shopCoords = vector3(shopx.Pos[i].x, shopx.Pos[i].y, shopx.Pos[i].z)
                local DistancexShop = #(playerxcoords - shopCoords)
                if DistancexShop <= shopx.Marker.DrawDistance then
                    if ShopNUIopen == false then
                        sleep = 0
                        if CurrentShop == nil then
                            DrawMarker(shopx.Marker.Type, shopx.Pos[i].x, shopx.Pos[i].y, shopx.Pos[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, shopx.Marker.Size.x, shopx.Marker.Size.y, shopx.Marker.Size.z, shopx.Marker.Color.r, shopx.Marker.Color.g, shopx.Marker.Color.b, 255, false, true, 2, nil, nil, false)
                        end
                        if DistancexShop <= 1.5 then
                            ShopsCfg.pressE(ShopsCfg.Locales['pressE'])
                            if IsControlPressed(0, 38) then
                                openbrokerShop(shopn)
                            end
                        end
                    else
                        sleep = 0
                        DisableControlAction(0, 1, true)     
                        DisableControlAction(0, 2, true)
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

function openbrokerShop(shopn)
    if ShopsCfg.useCheezaInventory then
        local items = {}
        for i=1, #ShopsCfg.Shops[shopn].Items, 1 do
            local item = ShopsCfg.Shops[shopn].Items[i]
            table.insert(items, {
                type = item.type,
                name = item.item,
                price = item.price
            })
        end
        TriggerEvent('inventory:openShop', tostring(shopn), 'Laden', items)
    else
        if ShopsCfg.Shops[shopn].JobLock then
            if ESX.GetPlayerData().job.name ~= ShopsCfg.Shops[shopn].job then
                TriggerEvent('broker_shops:showNotification', ShopsCfg.Locales['noAccess'])
                return false
            end
        end
        CurrentShop = shopn
        ShopNUIopen = true
        SendNUIMessage({
            value = 'openShop_broker',
            items = json.encode(ShopsCfg.Shops[CurrentShop].Items),
            categories = json.encode(ShopsCfg.Shops[CurrentShop].Categories)
        }) 
        SetNuiFocus(true, true)
    end
end

RegisterNUICallback("close_brokerShops", function(data)
    SetNuiFocus(false, false)
    ShopNUIopen = false
    CurrentShop = nil
end)

RegisterNUICallback("buyItems_brokerShops", function(data)
    TriggerServerEvent('broker_shops:BuyItems', data.items, data.paytype)
end)
