local picture;

RMenu.Add('tebex', 'case', RageUI.CreateMenu("Caisse Vacances", "Caisse"))
RMenu:Get('tebex', 'case'):DisplayGlare(false)
RMenu:Get('tebex', 'case').Closed = function()
    picture = nil
end

RegisterNetEvent('tebex:on-open-case')
AddEventHandler('tebex:on-open-case', function(animations, name, message)
    RageUI.Visible(RMenu:Get('tebex', 'case'), true)
    Citizen.CreateThread(function()
        Citizen.Wait(500)
        for k, v in pairs(animations) do
            picture = v.name
            RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
            if v.time == 10000 then
                RageUI.PlaySound("HUD_AWARDS", "FLIGHT_SCHOOL_LESSON_PASSED")
                ESX.ShowAdvancedNotification('Boutique', 'Informations', message, 'CHAR_CALIFORNIA', 6, 2)
            end
            Citizen.Wait(v.time)
        end
    end)
end)

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(1.0)

        RageUI.IsVisible(RMenu:Get('tebex', 'case'), function()

        end, function()
            if (picture) then
                RageUI.RenderSprite("case", picture)
            end
        end)


    end
end)
