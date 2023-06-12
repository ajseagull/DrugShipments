local QBCore = exports['qb-core']:GetCoreObject()

local SoldDrugs = false

local DroppedOffTruck = false

RegisterNetEvent("cvt-drugs:selldrugs", function()
    if not SoldDrugs then
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.RemoveItem("weed_white-widow", 5)
        Player.Functions.AddMoney('cash', Config.NormalDropPay)
        SoldDrugs = true

        SetTimeout(2, function()
            SoldDrugs = false
        end)
    end
end)

RegisterNetEvent("cvt-drugs:ConfirmDropOff", function()
    if not DroppedOffTruck then
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.RemoveItem("weed_brick", 1) then
            Player.Functions.AddMoney('cash', Config.TruckDropPay)
            DroppedOffTruck = true
        end

        SetTimeout(25000, function()
            DroppedOffTruck = false
        end)
    end
end)