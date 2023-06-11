local QBCore = exports['qb-core']:GetCoreObject()

local SellDrugs = false

local blip = nil

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
                        heading = 12.0, -- The heading of the boxzone, this has to be a float value
                        debugPoly = true, -- This is for enabling/disabling the drawing of the box, it accepts only a boolean value (true or false), when true it will draw the polyzone in green
                        minZ = NormalDropOff.z-2, -- This is the bottom of the boxzone, this can be different from the Z value in the coords, this has to be a float value
                        maxZ = NormalDropOff.z+2, -- This is the top of the boxzone, this can be different from the Z value in the coords, this has to be a float value
                        }, {
                        options = { -- This is your options table, in this table all the options will be specified for the target to accept
                            { -- This is the first table with options, you can make as many options inside the options table as you want
                            num = 1, -- This is the position number of your option in the list of options in the qb-target context menu (OPTIONAL)
                            type = "client", -- This specifies the type of event the target has to trigger on click, this can be "client", "server", "command" or "qbcommand", this is OPTIONAL and will only work if the event is also specified
                            event = "cvt-drugs:selldrugscl", -- This is the event it will trigger on click, this can be a client event, server event, command or qbcore registered command, NOTICE: Normal command can't have arguments passed through, QBCore registered ones can have arguments passed through
                            icon = 'fas fa-example', -- This is the icon that will display next to this trigger option
                            label = 'Deliver Package', -- This is the label of this option which you would be able to click on to trigger everything, this has to be a string
                            }
                        },
                        distance = 3.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
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

