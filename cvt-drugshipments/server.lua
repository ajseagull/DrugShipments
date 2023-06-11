local QBCore = exports['qb-core']:GetCoreObject()

local SoldDrugs = false

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
