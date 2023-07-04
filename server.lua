RegisterServerEvent('broker_shops:BuyItems')
AddEventHandler('broker_shops:BuyItems', function(buyingitems, paytype)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer ~= nil then
        local priceOverall = 0
        local itemToGive = {}
        for index,value in pairs(buyingitems) do
            local singleItemPrice = value.price / value.count
            priceOverall = priceOverall + value.price
            for i = 1, value.count, 1 do
                table.insert(itemToGive, {item = index, type = value.type})
            end
        end
        if xPlayer.getMoney() >= priceOverall then
            for i = 1, #itemToGive, 1 do
                local item = itemToGive[i]
                if item.type == 'weapon' then
                    xPlayer.addWeapon(item.item, 30)
                else
                    xPlayer.addInventoryItem(item.item, 1)
                end
            end
            xPlayer.removeMoney(priceOverall)
            xPlayer.showNotification(ShopsCfg.Locales['paidCart'])
        else
            xPlayer.showNotification(ShopsCfg.Locales['notEnoughMoney'])
        end
    end
end)