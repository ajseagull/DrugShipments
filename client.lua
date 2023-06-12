local QBCore = exports['qb-core']:GetCoreObject()

local SellDrugs = false

local blip, truckblip = nil, nil

local veh = nil

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        CreateThread(function()
            local model = `a_m_m_indian_01`
            RequestModel(model)
            while not HasModelLoaded(model) do
              Wait(0)
            end
            local entity = CreatePed(0, model, vector3(Config.TruckDrop.x, Config.TruckDrop.y, Config.TruckDrop.z), Config.TruckDrop.w, true, false)
            exports['qb-target']:AddTargetEntity(entity, {
              options = {
                {
                  num = 1,
                  type = "client",
                  event = "cvt-drugs:TruckDelivery",
                  icon = 'fas fa-example',
                  label = 'Start Delivery',
                }
              },
              distance = 2.5,
            })
          end)
    end
end)

RegisterNetEvent('cvt-drugs:TruckDelivery', function()

    local ModelHash = Config.TruckModel
    if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do
        Wait(0)
    end
    local MyPed = PlayerPedId()
    local veh = CreateVehicle(ModelHash, vector3(Config.TruckSpawn.x, Config.TruckSpawn.y, Config.TruckSpawn.z), Config.TruckSpawn.w, true, false)
    TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
    SetModelAsNoLongerNeeded(ModelHash)

    
        blip = AddBlipForCoord(Config.DropOffLoc.x, Config.DropOffLoc.y, Config.DropOffLoc.z)
        SetBlipSprite(truckblip, 501)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Drop Off")
        EndTextCommandSetBlipName(truckblip)
        
        SetNewWaypoint(Config.DropOffLoc.x, Config.DropOffLoc.y)

        CreateThread(function()
            DropOffZone = CircleZone:Create(vector3(Config.DropOffLoc.x, Config.DropOffLoc.y, Config.DropOffLoc.z), 7.5, {
                name = "InsideDropArea",
                debugPoly = true,
            })
            DropOffZone:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    if DoesEntityExist(veh) then
                        if IsPedInVehicle(PlayerPedId(), veh, false) then
                            TriggerServerEvent("cvt-drugs:ConfirmDropOff")
                            RemoveBlip(truckblip)
                            DropOffZone:destroy()
                            QBCore.Functions.DeleteVehicle(veh)
                        end
                    end
                end
            end)
        end)
end)


RegisterNetEvent("cvt-drugs:selldrugscl", function()
    
    SellDrugs = false
end)

RegisterNetEvent('cvt-drugs:setlocation', function()

    if QBCore.Functions.HasItem("weed_white-widow", 5) then

        local NormalDropOffIndex = math.random(1, #Config.NormalDrop)
        local NormalDropOff = Config.NormalDrop[NormalDropOffIndex]

        print(NormalDropOffIndex)

        Citizen.Wait(100)

        blip = AddBlipForCoord(NormalDropOff.x, NormalDropOff.y, NormalDropOff.z)
        SetBlipSprite(blip, 501)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Drop Off")
        EndTextCommandSetBlipName(blip)
        
        SetNewWaypoint(NormalDropOff.x, NormalDropOff.y)

        CreateThread(function()
            LoopZone = CircleZone:Create(vector3(NormalDropOff.x, NormalDropOff.y, NormalDropOff.z), 3.5, {
                name = "InsideSaleArea",
                debugPoly = true,
            })
            LoopZone:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    exports['qb-target']:AddBoxZone("SellDrugsArea", vector3(NormalDropOff.x, NormalDropOff.y, NormalDropOff.z+1), 1.5, 1.6, {
                        name = "SellDrugsArea",
                        heading = 12.0,
                        debugPoly = false,
                        minZ = NormalDropOff.z-2,
                        maxZ = NormalDropOff.z+2,
                        }, {
                        options = {
                            {
                            num = 1,
                            type = "client",
                            event = "cvt-drugs:selldrugscl",
                            icon = 'fas fa-example',
                            label = 'Deliver Package',
                            }
                        },
                        distance = 3.5,
                        })
                else
                    SellDrugs = false
                end
            end)
        end)

    end

end)

RegisterNetEvent("cvt-drugs:selldrugscl", function()
    TriggerServerEvent('cvt-drugs:selldrugs')
    RemoveBlip(blip)
    LoopZone:destroy()
    exports['qb-target']:RemoveZone("SellDrugsArea")
    SellDrugs = false
end)

RegisterCommand("DrugLocation", function(source, args, rawCommand)
    TriggerEvent("cvt-drugs:setlocation")
end, false)

