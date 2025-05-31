local QBCore = exports['qb-core']:GetCoreObject()

local cooldown = false  
local cooldownTime = Config.Time  

function spawnVehicle(vehicleName)
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)

    RequestModel(vehicleName)
    while not HasModelLoaded(vehicleName) do
        Citizen.Wait(500)
    end

    local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

    -- Araç anahtarını ver
    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))



    SetModelAsNoLongerNeeded(vehicleName)
end

local menuItems = {
    {
        header = Config.text1,
        txt = "Araç çıkart",
        params = {
            event = "spawn:vehicle2"
        }
    },
    {
        header = Config.text2,
        txt = "Araç çıkart",
        params = {
            event = "spawn:vehicle1"
        }
    },
    {
        header = Config.text3,
        txt = "Araç çıkart",
        params = {
            event = "spawn:vehicle3"
        }
    },
    {
        header = "KAPAT",
        txt = "Menüyü kapat",
        params = {
            event = "qb-menu:close"
        }
    }
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 288) then
            exports['qb-menu']:openMenu(menuItems)
        end
    end
end)

function startCooldown()
    cooldown = true
    Citizen.SetTimeout(cooldownTime, function()
        cooldown = false  
    end)
end

local function canSpawnVehicle()
    local playerPed = PlayerPedId()
    return not IsPedInAnyVehicle(playerPed, false) and  -- Oyuncu araçta değilse
           not exports["f4st-ffa"]:InZone() and            -- Belirtilen bölgede değilse
           not exports["viber-aimlab"]:InZone() and           -- Belirtilen bölgede değilse
           not exports["PX-warzone"]:inZone()            -- Belirtilen bölgede değilse
end

RegisterNetEvent('spawn:vehicle3', function()
    if canSpawnVehicle() and not cooldown then  
        spawnVehicle(Config.vehicle3)
        startCooldown()  
    else
        QBCore.Functions.Notify("Araç çıkartmak için araçta olmamalısın veya izinli bölgede olmamalısın!", "error")  
    end
end)

RegisterNetEvent('spawn:vehicle2', function()
    if canSpawnVehicle() and not cooldown then  
        spawnVehicle(Config.vehicle1)
        startCooldown()  
    else
        QBCore.Functions.Notify("Araç çıkartmak için araçta olmamalısın veya izinli bölgede olmamalısın!", "error")  
    end
end)

RegisterNetEvent('spawn:vehicle1', function()
    if canSpawnVehicle() and not cooldown then
        spawnVehicle(Config.vehicle2)
        startCooldown()
    else
        QBCore.Functions.Notify("Araç çıkartmak için araçta olmamalısın veya izinli bölgede olmamalısın!", "error")
    end
end)

RegisterNetEvent('qb-menu:close', function()
    exports['qb-menu']:closeMenu()
end)