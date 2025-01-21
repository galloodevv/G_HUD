local framework = nil
local hunger, thirst = 0, 0

-- Detectar el framework al inicio
Citizen.CreateThread(function()
    while framework == nil do
        if GetResourceState('es_extended') == 'started' then
            framework = 'ESX'
            ESX = exports['es_extended']:getSharedObject()
        elseif GetResourceState('qb-core') == 'started' then
            framework = 'QB'
            QBCore = exports['qb-core']:GetCoreObject()
        end
        Citizen.Wait(100)
    end
end)

-- Función principal de actualización del HUD
local function UpdateHUD()
    local ped = PlayerPedId()
    local isDead = IsEntityDead(ped)
    
    -- Actualizar hambre y sed según el framework y estado del jugador
    if isDead then
        hunger, thirst = 0, 0
    else
        if framework == 'ESX' then
            TriggerEvent('esx_status:getStatus', 'hunger', function(status)
                hunger = status.val / 10000
            end)
            TriggerEvent('esx_status:getStatus', 'thirst', function(status)
                thirst = status.val / 10000
            end)
        elseif framework == 'QB' then
            local Player = QBCore.Functions.GetPlayerData()
            if Player.metadata then
                hunger = Player.metadata.hunger
                thirst = Player.metadata.thirst
            end
        end
    end

    SendNUIMessage({
        type = 'updateHUD',
        health = GetEntityHealth(ped) - 100,
        shield = GetPedArmour(ped),
        hunger = hunger,
        thirst = thirst,
        stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
    })
end

Citizen.CreateThread(function()
    while true do
        UpdateHUD()
        Citizen.Wait(400)
    end
end)

AddEventHandler('playerSpawned', function()
    UpdateHUD()
end)
