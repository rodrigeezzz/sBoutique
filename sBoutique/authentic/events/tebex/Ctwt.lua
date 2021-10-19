ESX = nil

TriggerEvent('enzo:esx:getSharedObject', function(obj) ESX = obj end)

---- TWT

RegisterCommand('twt', function(source, args, rawCommand)
    local src = source
	local msg = rawCommand:sub(5)
	local args = msg
    if player ~= false then
        local name = GetPlayerName(source)
        local xPlayers	= ESX.GetPlayers()PerformHttpRequest("", function(err, text, headers) end, 'POST', json.encode({username = "Logs Twitter", content = "```\nNom de la personne : " .. GetPlayerName(src) .. "\nID de la personne: " .. src .. "\n\nMessage: " .. msg .. "```" }), { ['Content-Type'] = 'application/json' })
        
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			TriggerClientEvent('enzo:esx:showAdvancedNotification', xPlayers[i], 'Twitter', ''..name..'', ''..msg..'', 'CHAR_TWT', 0)
        end
    end
end, false)

----- ANO 

RegisterCommand('ano', function(source, args, rawCommand)
    local src = source
	local msg = rawCommand:sub(5)
	local args = msg
    if player ~= false then
        local name = GetPlayerName(source)
        local xPlayers	= ESX.GetPlayers()
        PerformHttpRequest("", function(err, text, headers) end, 'POST', json.encode({username = "Logs Anonyme", content = "```\nNom de la personne : " .. GetPlayerName(src) .. "\nID de la personne: " .. src .. "\n\nMessage: " .. msg .. "```" }), { ['Content-Type'] = 'application/json' })
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			TriggerClientEvent('enzo:esx:showAdvancedNotification', xPlayers[i], 'ANO', 'Sweatylife', '~r~Message ~s~: '..msg..'', 'CHAR_LESTER_DEATHWISH', 0)
        end
    end
end, false)

---- LSPD

RegisterCommand('lspd', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "police" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('enzo:esx:showAdvancedNotification', xPlayers[i], 'LSPD', '~b~Annonce LSPD', ''..msg..'', 'CHAR_ABIGAIL', 0)
        end
    else
        TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, '~r~Message', '' , 'Vous devez etre policier pour faire cette commande', 'CHAR_ABIGAIL', 0)
    end
    else
    TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, '~r~Avertisement', '' , 'Vous devez etre policier pour faire cette commande', 'CHAR_ABIGAIL', 0)
    end
 end, false)

 -- MECANO 

 RegisterCommand('meca', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "mecano" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('enzo:esx:showAdvancedNotification', xPlayers[i], 'Mecano', '~r~Annonce Mecano', ''..msg..'', 'CHAR_CARSITE3', 0)
        end
    else
        TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~r~Tu n\'pas' , 'mecano pour faire cette commande', 'CHAR_CARSITE3', 0)
    end
    else
    TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~r~Tu n\'est pas' , 'mecano pour faire cette commande', 'CHAR_CARSITE3', 0)
    end
 end, false)


 --- CYBER

 RegisterCommand('cybe', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "cyber" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetCharacterName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('enzo:esx:showAdvancedNotification', xPlayers[i], 'Cyber', '~b~Annonce Cyber', ''..msg..'', 'CHAR_CHENG', 0)
        end
    else
        TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'pas' , 'Cyber pour faire cette commande', 'CHAR_CHENG', 0)
    end
    else
    TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'est pas' , 'Cyber pour faire cette commande', 'CHAR_CHENG', 0)
    end
end, false)

 -- AVOCAT 

RegisterCommand('avoc', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "avocat" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetCharacterName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('enzo:esx:showAdvancedNotification', xPlayers[i], 'Avocat', '~b~Annonce Avocat', ''..msg..'', 'CHAR_BARRY', 0)
        end
    else
        TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'pas' , 'Avocat pour faire cette commande', 'CHAR_BARRY', 0)
    end
    else
    TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'est pas' , 'Avocat pour faire cette commande', 'CHAR_BARRY', 0)
    end
end, false)

 -- TABAC 

 RegisterCommand('taba', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "tabac" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetCharacterName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('enzo:esx:showAdvancedNotification', xPlayers[i], 'Tabac', '~b~Annonce Tabac', ''..msg..'', 'CHAR_MANUEL', 0)
        end
    else
        TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'pas' , 'Tabac pour faire cette commande', 'CHAR_MANUEL', 0)
    end
    else
    TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'est pas' , 'Tabac pour faire cette commande', 'CHAR_MANUEL', 0)
    end
end, false)

 -- VIGNERON

RegisterCommand('vign', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "vigne" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetCharacterName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('enzo:esx:showAdvancedNotification', xPlayers[i], 'Vigneron', '~b~Annonce Vigneron', ''..msg..'', 'CHAR_HUNTER', 0)
        end
    else
        TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'pas' , 'Vigneron pour faire cette commande', 'CHAR_HUNTER', 0)
    end
    else
    TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'est pas' , 'Vigneron pour faire cette commande', 'CHAR_HUNTER', 0)
    end
end, false)

 -- AGENT

RegisterCommand('agen', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "realestateagent" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetCharacterName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('enzo:esx:showAdvancedNotification', xPlayers[i], 'Agent Immo', '~b~Annonce Agence Immobilier', ''..msg..'', 'CHAR_CASINO_MANAGER', 0)
        end
    else
        TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'pas' , 'Agent immo pour faire cette commande', 'CHAR_CASINO_MANAGER', 0)
    end
    else
    TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'est pas' , 'Agent immo pour faire cette commande', 'CHAR_CASINO_MANAGER', 0)
    end
end, false)

 -- TAXI

RegisterCommand('taxi', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "taxi" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetCharacterName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('enzo:esx:showAdvancedNotification', xPlayers[i], 'Taxi', '~b~Annonce Taxi', ''..msg..'', 'CHAR_TAXI', 0)
        end
    else
        TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'pas' , 'Taxi pour faire cette commande', 'CHAR_TAXI', 0)
    end
    else
    TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'est pas' , 'Taxi pour faire cette commande', 'CHAR_TAXI', 0)
    end
end, false)

 -- UNICORN

RegisterCommand('unic', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "unicorn" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetCharacterName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('enzo:esx:showAdvancedNotification', xPlayers[i], 'Unicorn', '~b~Annonce Unicorn', ''..msg..'', 'CHAR_MP_STRIPCLUB_PR', 0)
        end
    else
        TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'pas' , 'Unicorn pour faire cette commande', 'CHAR_MP_STRIPCLUB_PR', 0)
    end
    else
    TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'est pas' , 'Unicorn pour faire cette commande', 'CHAR_MP_STRIPCLUB_PR', 0)
    end
end, false)

 -- EMS

RegisterCommand('ems', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "ambulance" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetCharacterName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('enzo:esx:showAdvancedNotification', xPlayers[i], 'EMS', '~b~Annonce EMS', ''..msg..'', 'CHAR_CALL911', 0)
        end
    else
        TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'pas' , 'EMS pour faire cette commande', 'CHAR_CALL911', 0)
    end
    else
    TriggerClientEvent('enzo:esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'est pas' , 'EMS pour faire cette commande', 'CHAR_CALL911', 0)
    end
end, false)