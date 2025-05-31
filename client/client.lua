local QBCore = exports['qb-core']:GetCoreObject()

-- F5 tuşuna basıldığında menüyü açan komut
RegisterKeyMapping('openCarMenu', 'Açılacak Araç Menüsü', 'keyboard', 'F5')

RegisterCommand('openCarMenu', function()
    OpenCarMenu()
end, false)

-- Menü işlevini tanımlıyoruz
function OpenCarMenu()
    local vehicleMenu = {
        {
            header = "Araç Seçim Menüsü",
            isMenuHeader = false
        },
        {
            header = "Sultan",
            txt = "Seçmek için tıkla",
            params = {
                event = "aresf5car:spawnCar",
                args = { model = "sultan" }
            }
        },
        {
            header = "Banshee",
            txt = "Seçmek için tıkla",
            params = {
                event = "aresf5car:spawnCar",
                args = { model = "banshee" }
            }
        },
        {
            header = "Araç 3: Elegy",
            txt = "Seçmek için tıkla",
            params = {
                event = "aresf5car:spawnCar",
                args = { model = "elegy" }
            }
        },
        {
            header = "Araç 4: Zentorno",
            txt = "Seçmek için tıkla",
            params = {
                event = "aresf5car:spawnCar",
                args = { model = "zentorno" }
            }
        },
        {
            header = "Araç 5: Turismo R",
            txt = "Seçmek için tıkla",
            params = {
                event = "aresf5car:spawnCar",
                args = { model = "turismor" }
            }
        },
        {
            header = "Menüyü Kapat",
            txt = "Kapatmak için tıkla",
            params = {
                event = "qb-menu:closeMenu"
            }
        }
    }

    -- Menüyü açıyoruz
    exports['qb-menu']:openMenu(vehicleMenu)
end

-- Aracı spawn etme işlevi
RegisterNetEvent('aresf5car:spawnCar')
AddEventHandler('aresf5car:spawnCar', function(data)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    -- Modeli yükle
    local model = GetHashKey(data.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(500)
    end

    -- Aracı spawn et
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)
end)
