local QBCore = exports['qb-core']:GetCoreObject()

local cooldown = false
local cooldownTime = 2000     -- 5 seconds in milliseconds
local display = false
local spawnInProgress = false -- Add this flag to prevent multiple spawns

function spawnVehicle(vehicleName)
    if spawnInProgress then return end -- Prevent multiple spawns
    spawnInProgress = true

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
    spawnInProgress = false -- Reset the flag after spawn is complete
end

function startCooldown()
    cooldown = true
    QBCore.Functions.Notify("2 saniye içinde tekrar araç çıkaramazsın!", "error")
    Citizen.SetTimeout(cooldownTime, function()
        cooldown = false
        QBCore.Functions.Notify("Artık araç çıkarabilirsin!", "success")
    end)
end

local function canSpawnVehicle()
    local playerPed = PlayerPedId()
    return not IsPedInAnyVehicle(playerPed, false) and -- Oyuncu araçta değilse
        -- not exports["PX-FFa"]:InZone() and             -- Belirtilen bölgede değilse
        -- not exports["viber-aimlab"]:InZone() and       -- Belirtilen bölgede değilse
        not exports["PX-warzone"]:inZone() -- Belirtilen bölgede değilse
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
    if spawnInProgress then
        cb('ok')
        return
    end

    if cooldown then
        QBCore.Functions.Notify("Lütfen 2 saniye bekleyin!", "error")
        cb('ok')
        return
    end

    local vehicleType = data.vehicle
    local vehicleModel = nil

    if vehicleType == 'vehicle1' then
        vehicleModel = Config.vehicle1
    elseif vehicleType == 'vehicle2' then
        vehicleModel = Config.vehicle2
    end

    if vehicleModel then
        if canSpawnVehicle() then
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
