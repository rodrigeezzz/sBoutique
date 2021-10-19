ESX = {}

local giveway = {
    isEnabled = false,
    points = 500
}

---@class STebex
STebex = STebex or {};

---@class STebex.Cache
STebex.Cache = STebex.Cache or {}

---@class STebex.Cache.Case
STebex.Cache.Case = STebex.Cache.Case or {}

function STebex:HasValue(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            return true
        end
    end
    return false
end

TriggerEvent('enzo:esx:getSharedObject', function(obj)
    ESX = obj
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('enzo:esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)


local characters = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }

Server = {};

function Server:GetIdentifiers(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers[_]
        end
        return identifiers
    else
        error("source is nil")
    end
end

function Server:DiscordHook(message)
    local embeds = {
        {
            ['title'] = message,
            ['type'] = 'rich',
            ['color'] = '56108',
            ['footer'] = {
                ['text'] = 'Achats sur la boutique en jeux'
            }
        }
    }
    PerformHttpRequest("", function()
    end, 'POST', json.encode({ username = 'Le banquier', embeds = embeds }), { ['Content-Type'] = 'application/json' })
end

function Server:CreateRandomPlateText()
    local plate = ""
    math.randomseed(GetGameTimer())
    for i = 1, 4 do
        plate = plate .. characters[math.random(1, #characters)]
    end
    plate = plate .. ""
    for i = 1, 3 do
        plate = plate .. math.random(1, 9)
    end
    return plate
end

RegisterServerEvent("tebex:on-process-checkout-fullcustom")
AddEventHandler("tebex:on-process-checkout-fullcustom", function()
    Server:OnProcessCheckout(source, 1000, "Full Custom vehicule", function()
    end)
end)

function Server:OnProcessCheckout(source, price, transaction, onAccepted, onRefused)
    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
        MySQL.Async.fetchAll("SELECT SUM(points) FROM tebex_players_wallet WHERE identifiers = @identifiers", {
            ['@identifiers'] = after
        }, function(result)
            local current = tonumber(result[1]["SUM(points)"]);
            if (current ~= nil) then
                if (current >= price) then
                    LiteMySQL:Insert('tebex_players_wallet', {
                        identifiers = after,
                        transaction = transaction,
                        price = '0',
                        currency = 'Points',
                        points = -price,
                    });
                    Server:DiscordHook(transaction)
                    onAccepted();
                else
                    onRefused();
                    xPlayer.showNotification('Vous ne procédez pas les points nécessaires pour votre achat visité notre boutique.')
                end
            else
                onRefused();
            end
        end);
    else
        onRefused();
        --print('[Exeception] Failed to retrieve fivem identifier')
    end
end

function Server:Giving(xPlayer, identifier, item)
    local content = json.decode(item.action);

    if (content.vehicles) then
        for key, value in pairs(content.vehicles) do
            local plate = Server:CreateRandomPlateText()
            LiteMySQL:Insert('owned_vehicles', {
                owner = identifier['license'],
                plate = plate,
                vehicle = json.encode({ model = value.name, plate = plate }),
                type = value.type,
                state = 1,
            })
            LiteMySQL:Insert('open_car', {
                owner = identifier['license'],
                plate = plate
            });

        end
    end

    if (content.weapons) then
        for key, value in pairs(content.weapons) do
            if (value.name ~= "weapon_custom") then
                print(value.name)
                xPlayer.addWeapon(value.name, value.ammo)
            end
        end
    end

    if (content.items) then
        for key, value in pairs(content.items) do
            xPlayer.addInventoryItem(value.name, value.count)
        end
    end

    if (content.items) then
        for key, value in pairs(content.items) do
            xPlayer.addInventoryItem(value.name, value.count)
        end
    end

    if (content.bank) then
        for key, value in pairs(content.bank) do
            xPlayer.addAccountMoney('bank', value.count)
        end
    end
end

ESX.AddGroupCommand("litemysql:addpulsion", "_dev", function(source, args)
    local fivem = nil
    for _, foundID in ipairs(GetPlayerIdentifiers(tonumber(args[1]))) do
        if string.match(foundID, "fivem:") then
            fivem = foundID
            break
        end
    end
    if fivem ~= nil and args[3] ~= nil then
        TriggerClientEvent("enzo:esx:showAdvancedNotification", args[1], "Andreas", "~y~Boutique", string.format("\nVoici le reçus de votre achat(s) :\n- %d Storycoins\n- Envoyé par %s\n\nBon jeux sur Sweatylife", args[2], GetPlayerName(source)), 'CHAR_TREVOR', 9, 2)
        LiteMySQL:Insert('tebex_players_wallet', {
            identifiers = string.gsub(fivem, "fivem:", ""),
            transaction = string.format("Achat Storycoins(non tebex)%s", GetPlayerName(source)),
            price = '0',
            currency = 'Points',
            points = tonumber(args[2]),
        });
        local staffinfo = {}    
        local joueurinfo = {}
        local command = {}
        for _, foundID in ipairs(GetPlayerIdentifiers(source)) do
            table.insert(staffinfo,foundID)
        end
        for _, foundID in ipairs(GetPlayerIdentifiers(args[1])) do
            table.insert(joueurinfo,foundID)
        end
        for k,v in pairs (args) do
            table.insert(command,"args"..k..":"..v)
        end
        addpulsion = "**-Player ID**: "..source.."\n**- Staff Name**: "..GetPlayerName(source).."\n**- Joueurs ID**: "..args[1].."\n**- Envoyé Name**: "..GetPlayerName(args[1]).."\n**- Storycoins**: "..args[2].."\n**- Raison**: "..args[3].."\n**- Heure**: "..os.date("%d/%m/%y - %X").."\n**- Info du staff**\n```"..json.encode(staffinfo).."```\n**- Info du Joueurs**\n```"..json.encode(joueurinfo).."```"
        local embeds = {
            {
                ["title"] = json.encode(command),
                ["type"] = "rich",
                ["color"] = 15844367,
                ["description"] = addpulsion,
            }
        }
    
        PerformHttpRequest("", function(err, text, headers) end, "POST", json.encode({username = "LiteMysql / AddPulsion by Authentic", embeds = embeds}), {["Content-Type"] = "application/json"})
    elseif fivem == nil then
        TriggerClientEvent("enzo:esx:showAdvancedNotification", source, GetPlayerName(source), "~r~Erreur Boutique", "L'utilisateur visée n'a pas connectée son compte à FiveM", "CHAR_MP_ROBERTO", 2, 2)
        TriggerClientEvent("enzo:esx:showAdvancedNotification", args[1], GetPlayerName(args[1]), "~r~Erreur Boutique", "Excusez moi, mais il semblerait que vous n'ayez pas de compte lier a votre FiveM, vous n'avez donc pas pus récuperer ce que vous aviez reçus.", "CHAR_MP_ROBERTO", 2, 2)
    end
end)

ESX.AddGroupCommand("litemysql:delpulsion", "_dev", function(source, args)
    local fivem = nil
    for _, foundID in ipairs(GetPlayerIdentifiers(tonumber(args[1]))) do
        if string.match(foundID, "fivem:") then
            fivem = foundID
            break
        end
    end
    if fivem ~= nil and args[3] ~= nil then
        TriggerClientEvent("enzo:esx:showAdvancedNotification", args[1], "Andreas", "~y~Boutique", string.format("Bonjour, il semblerait que l'Administrateur (~r~%s~w~) vous ai supprimé ~r~%d~w~ Storycoins de votre compte, assurez-vous que ce n'est pas une erreur", GetPlayerName(source), args[2]), 'CHAR_TREVOR', 9, 2)
        LiteMySQL:Insert('tebex_players_wallet', {
            identifiers = string.gsub(fivem, "fivem:", ""),
            transaction = string.format("Retrait Storycoins(non tebex)%s", GetPlayerName(source)),
            price = '0',
            currency = 'Points',
            points = -tonumber(args[2]),
        });
        local staffinfo = {}  
        local joueurinfo = {}  
        local command = {}
        for _, foundID in ipairs(GetPlayerIdentifiers(source)) do
            table.insert(staffinfo,foundID)
        end
        for _, foundID in ipairs(GetPlayerIdentifiers(args[1])) do
            table.insert(joueurinfo,foundID)
        end
        for k,v in pairs (args) do
            table.insert(command,"args"..k..":"..v)
        end
        addpulsion = "**-Player ID**: "..source.."\n**-Admin Name**: "..GetPlayerName(source).."\n**-Envoyé ID**: "..args[1].."\n**-Envoyé Name**: "..GetPlayerName(args[1]).."\n**-Storycoins**: -"..args[2].."\n**-Raison**: "..args[3].."\n**-Date Time**: "..os.date("%d/%m/%y - %X").."\n**Staff Info**\n```"..json.encode(staffinfo).."```"
        local embeds = {
            {
                ["title"] = json.encode(command),
                ["type"] = "rich",
                ["color"] = 15844367,
                ["description"] = addpulsion,
            }
        }
    
        PerformHttpRequest("", function(err, text, headers) end, "POST", json.encode({username = "LiteMysql / AddPulsion by Authentic", embeds = embeds}), {["Content-Type"] = "application/json"})
    else
        TriggerClientEvent("enzo:esx:showAdvancedNotification", source, GetPlayerName(source), "~r~Erreur Boutique", "L'utilisateur visée n'a pas connectée son compte à FiveM", "CHAR_MP_ROBERTO", 2, 2)
        TriggerClientEvent("enzo:esx:showAdvancedNotification", args[1], GetPlayerName(args[1]), "~r~Erreur Boutique", "Excusez moi, mais il semblerait que vous n'ayez pas de compte lier a votre FiveM, vous n'avez donc pas pus récuperer ce que vous aviez reçus.", "CHAR_MP_ROBERTO", 2, 2)
    end
end)

function Server:onGiveaway(source)
    if (giveway.isEnabled) then
        local identifier = Server:GetIdentifiers(source);
        if (identifier['fivem']) then
            local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
            local count, value = LiteMySQL:Select('tebex_players_wallet_gift'):Where('identifiers', '=', after):Get()
            if (count == 0) then
                LiteMySQL:Insert('tebex_players_wallet_gift', {
                    identifiers = after,
                    have_receive = true,
                    points = giveway.points
                })
                LiteMySQL:Insert('tebex_players_wallet', {
                    identifiers = after,
                    transaction = 'Automatics Gift',
                    price = 0,
                    currency = 'EUR',
                    points = giveway.points
                })
                TriggerClientEvent('enzo:esx:showNotification', source, "~g~Pour vous excuser de ce désagrément, nous vous avons donné " .. giveway.points .. " points boutique (F1).")
            else
                TriggerClientEvent('enzo:esx:showNotification', source, "~g~Vous avez déjà reçu votre récompense.")
            end
        else
            TriggerClientEvent('enzo:esx:showNotification', source, "~b~Vous ne pouvez pas bénéficier des " .. giveway.points .. " points gratuits car votre compte de FiveM n'est pas lié.")
        end
    end
end

RegisterServerEvent('tebex:on-process-checkout')
AddEventHandler('tebex:on-process-checkout', function(itemId)
    local source = source;
    if (source) then
        local identifier = Server:GetIdentifiers(source);
        local xPlayer = ESX.GetPlayerFromId(source)
        if (xPlayer) then
            local count, content = LiteMySQL:Select('tebex_boutique'):Where('id', '=', itemId):Get();
            local item = content[1];
            if (item) then
                Server:OnProcessCheckout(source, item.price, string.format("Achat object %s", item.name), function()
                    Server:Giving(xPlayer, identifier, item);
                end, function()
                    xPlayer.showNotification("~r~Vous ne procédé pas les point nécessaire")
                end)
            else
                print('[[Exeception] Failed to retrieve boutique item')
            end
        else
            print('[Exeception] Failed to retrieve ESX player')
        end
    else
        print('[Exeception] Failed to retrieve source')
    end
end)

local function random(x, y)
    local u = 0;
    u = u + 1
    if x ~= nil and y ~= nil then
        return math.floor(x + (math.random(math.randomseed(os.time() + u)) * 999999 % y))
    else
        return math.floor((math.random(math.randomseed(os.time() + u)) * 100))
    end
end

local function GenerateLootbox(source, box, list)
    local chance = random(1, 100)
    local gift = { category = 1, item = 1 }
    local minimalChance = 4

    local identifier = Server:GetIdentifiers(source);
    minimalChance = 3
    if (STebex.Cache.Case[source] == nil) then
        STebex.Cache.Case[source] = {};
        if (STebex.Cache.Case[source][box] == nil) then
            STebex.Cache.Case[source][box] = {};
        end
    end
    if chance <= minimalChance then
        local rand = random(1, #list[3])
        STebex.Cache.Case[source][box][3] = list[3][rand]
        gift.category = 3
        gift.item = list[3][rand]
    elseif (chance > minimalChance and chance <= 30) or (chance > 80 and chance <= 100) then
        local rand = random(1, #list[2])
        STebex.Cache.Case[source][box][2] = list[2][rand]
        gift.category = 2
        gift.item = list[2][rand]
    else
        local rand = random(1, #list[1])
        STebex.Cache.Case[source][box][1] = list[1][rand]
        gift.category = 1
        gift.item = list[1][rand]
    end
    local finalList = {}
    for _, category in pairs(list) do
        for _, item in pairs(category) do
            local result = { name = item, time = 150 }
            table.insert(finalList, result)
        end
    end
    table.insert(finalList, { name = gift.item, time = 5000 })
    return finalList, gift.item
end

local reward = {
    ["765lt"] = { type = "vehicle", message = "Félicitation, vous avez gagner une 765lt !" },
    ["cbr600"] = { type = "vehicle", message = "Félicitation, vous avez gagner un cbr600 !" },

    ["weapon_compactrifle"] = { type = "weapon", message = "Félicitation, vous avez gagner une AK!" },
    ["weapon_microsmg"] = { type = "weapon", message = "Félicitation, vous avez gagner un uzi !" },
    ["weapon_pistol"] = { type = "weapon", message = "Félicitation, vous avez gagner un sabre laser !" },
    ["weapon_snspistol"] = { type = "weapon", message = "Félicitation, vous avez gagner un katana !" },
    ["velociraptor"] = { type = "vehicle", message = "Félicitation, vous avez gagner un velociraptor !" },

    ["weapon_pistol50"] = { type = "weapon", message = "Félicitation, vous avez gagner un pistolet calibre50 !" },
}

local box = {
    [1] = {
        [3] = {

            "weapon_compactrifle",
            "weapon_microsmg",
        },
        [2] = {
            "rs318",
            "765lt",
            "cbr600",
            "velociraptor",
        },
        [1] = {
            "weapon_snspistol",
            "weapon_pistol",
            "weapon_pistol50",
        },
    }
}

RegisterServerEvent('tebex:on-process-checkout-case')
AddEventHandler('tebex:on-process-checkout-case', function()
    local source = source;
    if (source) then
        local identifier = Server:GetIdentifiers(source);
        local xPlayer = ESX.GetPlayerFromId(source)
        if (xPlayer) then
            Server:OnProcessCheckout(source, 1000, "Achat d'une caisse (Vacances - Limited).", function()

                local boxId = 1;
                local lists, result = GenerateLootbox(source, boxId, box[boxId])
                local giveReward = {
                    ["vehicle"] = function(_s, license, player)
                        local plate = Server:CreateRandomPlateText()

                        LiteMySQL:Insert('owned_vehicles', {
                            owner = license,
                            plate = plate,
                            vehicle = json.encode({ model = result, plate = plate }),
                            type = 'car',
                            state = 1,
                        })
                        LiteMySQL:Insert('open_car', {
                            owner = license,
                            plate = plate
                        });
                    end,
                    ["plane"] = function(_s, license, player)
                        local plate = Server:CreateRandomPlateText()

                        LiteMySQL:Insert('owned_vehicles', {
                            owner = license,
                            plate = plate,
                            vehicle = json.encode({ model = result, plate = plate }),
                            type = 'aircraft',
                            state = 1,
                        })
                        LiteMySQL:Insert('open_car', {
                            owner = license,
                            plate = plate
                        });
                    end,
                    ["pulsion"] = function(_s, license, player)
                        local before, after = result:match("([^_]+)_([^_]+)")
                        local quantity = tonumber(after)
                        if (identifier['fivem']) then
                            local _, fivemid = identifier['fivem']:match("([^:]+):([^:]+)")
                            LiteMySQL:Insert('tebex_players_wallet', {
                                identifiers = fivemid,
                                transaction = "Gain dans la boîte vacances.",
                                price = '0',
                                currency = 'Points',
                                points = quantity,
                            });
                        end
                    end,
                    ["weapon"] = function(_s, license, player)
                        xPlayer.addWeapon(result, 500)
                    end,
                    ["money"] = function(_s, license, player)
                        local before, after = result:match("([^_]+)_([^_]+)")
                        local quantity = tonumber(after)
                        player.addAccountMoney('bank', quantity)
                    end,
                }

                local r = reward[result];

                if (r ~= nil) then
                    if (giveReward[r.type]) then
                        giveReward[r.type](source, identifier['license'], xPlayer);
                    else
                        -- FATAL ERROR
                    end
                else
                    -- FATAL ERROR
                end

                if (identifier['fivem']) then
                    local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                    LiteMySQL:Insert('tebex_players_wallet', {
                        identifiers = after,
                        transaction = r.message,
                        price = '0',
                        currency = 'Box',
                        points = 0,
                    });
                end

                TriggerClientEvent('tebex:on-open-case', source, lists, result, r.message)

            end, function()
                xPlayer.showNotification("~r~Vous n'avez pas assez de Storycoins pour acheter cet article.")
            end)
        else
            print('[Exeception] Failed to retrieve ESX player')
        end
    else
        print('[Exeception] Failed to retrieve source')
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-category', function(source, callback)
    --EventRateLimit('tebex:retrieve-category', source, 5, function()
    local count, result = LiteMySQL:Select('tebex_boutique_category'):Where('is_enabled', '=', true):Get();
    if (result ~= nil) then
        callback(result)
    else
        print('[Exceptions] retrieve category is nil')
        callback({ })
    end
    --end)
end)

ESX.RegisterServerCallback('tebex:retrieve-items', function(source, callback, category)
    --EventRateLimit('tebex:retrieve-items', source, 5, function()
    local count, result = LiteMySQL:Select('tebex_boutique'):Wheres({
        { column = 'is_enabled', operator = '=', value = true },
        { column = 'category', operator = '=', value = category },
    })                             :Get();
    if (result ~= nil) then
        callback(result)
    else
        print('[Exceptions] retrieve category is nil')
        callback({ })
    end
    --end)
end)

ESX.RegisterServerCallback('tebex:retrieve-history', function(source, callback)
    -- EventRateLimit('tebex:retrieve-history', source, 5, function()
    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
        local count, result = LiteMySQL:Select('tebex_players_wallet'):Where('identifiers', '=', after):Get();
        if (result ~= nil) then
            callback(result)
        else
            print('[Exceptions] retrieve category is nil')
            callback({ })
        end
    end
    --  end)
end)

ESX.RegisterServerCallback('tebex:retrieve-points', function(source, callback)

    -- EventRateLimit('tebex:retrieve-points', source, 5, function()
    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")

        MySQL.Async.fetchAll("SELECT SUM(points) FROM tebex_players_wallet WHERE identifiers = @identifiers", {
            ['@identifiers'] = after
        }, function(result)
            if (result[1]["SUM(points)"] ~= nil) then
                callback(result[1]["SUM(points)"])
            else
                callback(0)
            end
        end);
    else
        callback(0)
    end
    -- end)

end)

AddEventHandler('playerSpawned', function()
    local source = source;
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local fivem = Server:GetIdentifiers(source)['fivem'];
        if (fivem) then
            local license = Server:GetIdentifiers(source)['license'];
            if (license) then
                local before, after = fivem:match("([^:]+):([^:]+)")
                LiteMySQL:Update('users', 'identifier', '=', license, {
                    fivem_id = after,
                })
                xPlayer.showNotification('~g~Vous pouvez faire des achats dans notre boutique pour nous soutenir. Votre compte FiveM attaché à votre jeux a été mis à jour.')
            else
                print('[Exeception] User don\'t have license identif0ier.')
            end
        else
            xPlayer.showNotification('~r~Vous n\'avez pas d\'identifiant FiveM associé à votre compte, reliez votre profil à partir de votre jeux pour recevoir vos achats potentiel sur notre boutique.')
            print('[Exeception] FiveM ID not found, send warning message to customer.')
        end
    else
        print('[Exeception] ESX Get players form ID not found.')
    end 
end)

RegisterCommand("idboutique", function(source, callback)

    local source = source;

    local identifier = Server:GetIdentifiers(source);

    local before, after = identifier['fivem']:match("([^:]+):([^:]+)")

    if identifier ~= nil then

    TriggerClientEvent('enzo:esx:showAdvancedNotification', source, 'Sweatylife', '~y~Code Boutique', string.format('Votre Code est le suivant : %d', after), 'CHAR_MP_ROBERTO', 2, 2)
    else

    TriggerClientEvent('enzo:esx:showAdvancedNotification', source, 'Sweatylife', '~r~Paiement Refusé', 'Oupss, on dirait bien que nous n\'arrivont pas a trouver votre code, merci de vous connectez', 'CHAR_MP_ROBERTO', 2, 2)
    end
end, false)
