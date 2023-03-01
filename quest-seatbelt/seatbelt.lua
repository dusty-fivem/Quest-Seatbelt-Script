local seatbeltOn = false
local seatbeltKey = Config.seatbeltKey or 75 -- Default is "F"

function toggleSeatbelt()
    if seatbeltOn then
        seatbeltOn = false
        SendNUIMessage({
            action = "hide"
        })
        TriggerEvent('chat:addMessage', { args = {"Seatbelt", "You have taken off your seatbelt."} })
    else
        seatbeltOn = true
        SendNUIMessage({
            action = "show"
        })
        TriggerEvent('chat:addMessage', { args = {"Seatbelt", "You have put on your seatbelt."} })
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        if IsPedInAnyVehicle(ped, false) then
            if seatbeltOn then
                DisableControlAction(0, 75, true) -- disable exit vehicle when seatbelt on
            else
                EnableControlAction(0, 75, true) -- enable exit vehicle when seatbelt off
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        if not seatbeltOn and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            SendNUIMessage({
                action = "flash"
            })
        end
    end
end)

RegisterCommand('seatbelt', function()
    toggleSeatbelt()
end, false)

RegisterKeyMapping('seatbelt', 'Toggle seatbelt', 'keyboard', seatbeltKey)
