local QBCore = exports['qb-core']:GetCoreObject()

local cooldown = false  
local cooldownTime = Config.Time  
local display = false

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

-- UI Functions
function ToggleUI()
    display = not display
    SetNuiFocus(display, display)
    SendNUIMessage({
        type = "toggle",
        status = display
    })
end

RegisterNUICallback('spawnVehicle', function(data, cb)
    local vehicleType = data.vehicle
    local vehicleModel = nil
    
    if vehicleType == 'vehicle1' then
        vehicleModel = Config.vehicle1
    elseif vehicleType == 'vehicle2' then
        vehicleModel = Config.vehicle2
    elseif vehicleType == 'vehicle3' then
        vehicleModel = Config.vehicle3
    end

    if vehicleModel then
        if canSpawnVehicle() and not cooldown then
            spawnVehicle(vehicleModel)
            startCooldown()
            ToggleUI()
        else
            QBCore.Functions.Notify("Araç çıkartmak için araçta olmamalısın veya izinli bölgede olmamalısın!", "error")
        end
    end
    cb('ok')
end)

RegisterNUICallback('closeUI', function(data, cb)
    ToggleUI()
    cb('ok')
end)

-- Key binding for UI
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 288) then -- F1 key
            ToggleUI()
        end
    end
end)