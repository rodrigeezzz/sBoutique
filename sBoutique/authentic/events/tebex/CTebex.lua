---@class Client
local Client = {} or {};

---@type table Content category menu
local category = {} or {};

---@type table All items
local items = {} or {};

---@type table History activity
local history = {} or {};

---@type table Selected items
local selected = {} or {};

---@type number Current players points
local points = 0;

---@type table Shared object
ESX = {};

TriggerEvent('enzo:esx:getSharedObject', function(obj)
    ESX = obj
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('enzo:esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(10)
    end
end)

local mainMenu = RageUI.CreateMenu("Boutique", "Achetez des objets")
mainMenu:DisplayGlare(false)
mainMenu.Closed = function()
    items = {} or {};
end

local caseMenu = RageUI.CreateMenu("Caisse Vacances", "Caisse")
caseMenu:DisplayGlare(false)
caseMenu.Closed = function()

end

local historyMenu = RageUI.CreateSubMenu(mainMenu, "Historique", "Historique de vos achat")
historyMenu:DisplayGlare(false)
historyMenu.Closed = function()
    Client:onRetrievePoints();
end

RMenu.Add('tebex', 'weapon', RageUI.CreateSubMenu(mainMenu, "Personnalisation", "Personnalisation d'arme"))
RMenu:Get('tebex', 'weapon'):DisplayGlare(false)
RMenu:Get('tebex', 'weapon').Closed = function()

end

local itemMenu = RageUI.CreateSubMenu(mainMenu, "Boutique", "")
itemMenu:DisplayGlare(false)
itemMenu.Closed = function()
    Client:onRetrievePoints();
    selected = {};
end
itemMenu.onIndexChange = function(Index)
    selected = items[Index] or {};
end

---onRetrieveItem
---@public
function Client:onRetrieveItem(categoryId)
    ESX.TriggerServerCallback('tebex:retrieve-items', function(result)
        items = result;
    end, categoryId)
end

---onRetrieveCategory
---@public
function Client:onRetrieveCategory()
    ESX.TriggerServerCallback('tebex:retrieve-category', function(result)
        category = result;
    end)
end

---onRetrievePoints
---@public
function Client:onRetrievePoints()
    ESX.TriggerServerCallback('tebex:retrieve-points', function(result)
        points = result
    end)
end

---onRetrieveHistory
---@public
function Client:onRetrieveHistory()
    ESX.TriggerServerCallback('tebex:retrieve-history', function(result)
        history = result;
    end)
end

function Client:RequestPtfx(assetName)
    RequestNamedPtfxAsset(assetName)
    if not (HasNamedPtfxAssetLoaded(assetName)) then
        while not HasNamedPtfxAssetLoaded(assetName) do
            Citizen.Wait(1.0)
        end
        return assetName;
    else
        return assetName;
    end
end

Citizen.CreateThread(function()
while (true) do
        Citizen.Wait(1.0)

        if (IsControlJustPressed(1, 288)) then
            Client:onRetrieveCategory();
            Client:onRetrievePoints();
            RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
        end

        RageUI.IsVisible(mainMenu, function()


            RageUI.Button('Vos Storycoins boutique', "Les achats sur la boutique vous permet de soutenir le serveur est bien plus encore.", { RightLabel = points }, true, {
            });
            RageUI.Button('Historique', "~r~AUCUN REMBOURSEMENT NE PEUT ETRE FAIT", { }, true, {
                onSelected = function()
                    Client:onRetrieveHistory()
                end
            }, historyMenu);

            RageUI.Separator("Catalogue");

            if (#category > 0) then
                for i, v in pairs(category) do
                    RageUI.Button(v.name, v.description, {  }, true, {
                        onSelected = function()
                            Client:onRetrieveItem(v.id)
                            itemMenu:SetSubtitle(v.name)
                        end,
                    }, itemMenu);
                end
            else
                RageUI.Separator("Aucune category disponible.");
            end

            RageUI.Button("Caisse Vacances", "Les boîtes vacances sont des boîtes à mystère qui vous permettent d'obtenir un objet parmi une liste d'objets présents dans la boîte.", { RightLabel = "~y~Nouveauté" }, true, {
                onSelected = function()

                end,
            }, caseMenu);

            RageUI.Button("Full custom vehicule", "~r~1.000 Storycoins ~w~| Cette option customise à 100% les performances de votre vehicule, attention, celui-ci s'applique dans le véhicule dans le quelle vous vous trouvez", { }, true, {
                onSelected = function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false);
                    if (vehicle ~= 0) then
                        if (points >= 1000) then
                            TriggerServerEvent('tebex:on-process-checkout-fullcustom')
                            Client:VehicleCustom(NetworkGetNetworkIdFromEntity(vehicle))
                        end
                    end
                    if (vehicle == 0) then
                        ESX.ShowNotification('~r~Action Impossible~s~ : Vous n\'êtes pas dans un véhicule')
                    end
                        if not (points >= 1000) then
    
                            ESX.ShowNotification('~r~Vous ne procédé pas les points nécessaire.')
    
                        end
                end,
            });

        end)

        RageUI.IsVisible(caseMenu, function()
            RageUI.Button("Caisse Vacances - Limited", "Dans cette case, vous pouvez obtenir différents objet ou autre les voici ci-dessous avec leur niveau de rareté, Diamond, gold, etc.", { RightLabel = string.format("%s", 1000) }, true, {
                onSelected = function()
                    RageUI.CloseAll()
                    if not HasStreamedTextureDictLoaded("case") then
                        RequestStreamedTextureDict("case", true)
                    end
                    TriggerServerEvent('tebex:on-process-checkout-case')
                end
            })
        end, function()
            RageUI.RenderSprite("case", "global")
        end)

        RageUI.IsVisible(itemMenu, function()
            if (#items > 0) then
                for i, v in pairs(items) do

                    RageUI.Button(v.name, v.descriptions, { RightLabel = string.format("%s", v.price), RightBadge = RageUI.BadgeStyle.Coins }, true, {
                        onSelected = function()
                            if not (points >= v.price) then
                                Visual.Subtitle("~r~Vous ne procédez pas les points nécessaire", 5000)
                            end
                            if (points >= v.price) then
                                TriggerServerEvent('tebex:on-process-checkout', v.id)
                                local coords = GetEntityCoords(GetPlayerPed(-1))
                                ESX.ShowNotification(string.format("~g~Felicitation vous avez acheté %s", v.name))
                                Client:RequestPtfx('scr_rcbarry1')
                                UseParticleFxAsset('scr_rcbarry1')
                                StartNetworkedParticleFxNonLoopedAtCoord('scr_alien_teleport', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false)
                            end
                        end,
                    });

                end
            else
                RageUI.Separator("Aucune contenue disponible.");
            end
        end, function()
            if (selected ~= nil) and (selected.category == 1) or (selected.category == 2) and (selected.action ~= nil) then
                local action = json.decode(selected.action)
                if (action.vehicles ~= nil) then
                    for i, v in pairs(action.vehicles) do
                        RageUI.RenderSprite("vehicles", v.name)
                    end
                end
                if (action.weapons ~= nil) and (#action.weapons == 1) then
                    for i, v in pairs(action.weapons) do
                        RageUI.RenderSprite("vehicles", v.name)
                    end
                end
            end
        end)

        RageUI.IsVisible(historyMenu, function()
            if (#history > 0) then
                for i, v in pairs(history) do
                    local label;
                    if (tonumber(v.price) == 0) then
                        label = string.format("%s", v.points)
                    else
                        label = string.format("%s (%s%s)", v.points, v.price, v.currency);
                    end
                    RageUI.Button(v.transaction, nil, { RightLabel = label }, true, {
                        onSelected = function()

                        end,
                    });

                end
            else
                RageUI.Separator("Aucune transactions effectues.");
            end
        end)


    end
end)

function Client:VehicleCustom(vehNetId)
    local vehicle = NetworkGetEntityFromNetworkId(vehNetId)
    if GetVehicleModKit(vehicle) ~= 0 then
        SetVehicleModKit(vehicle, 0)
    end
    SetVehicleNumberPlateTextIndex(vehicle, 1)
    SetVehicleWindowTint(vehicle, 1)
    ToggleVehicleMod(vehicle, 18, true)
    ToggleVehicleMod(vehicle, 20, true)
    ToggleVehicleMod(vehicle, 22, true)
    local max11 = GetNumVehicleMods(vehicle, 11)
    SetVehicleMod(vehicle, 11, (max11 > 0 and max11 - 1 or 0), false)
    local max12 = GetNumVehicleMods(vehicle, 12)
    SetVehicleMod(vehicle, 12, (max12 > 0 and max12 - 1 or 0), false)
    local max13 = GetNumVehicleMods(vehicle, 13)
    SetVehicleMod(vehicle, 13, (max13 > 0 and max13 - 1 or 0), false)
    local max15 = GetNumVehicleMods(vehicle, 15)
    SetVehicleMod(vehicle, 15, (max15 > 0 and max15 - 1 or 0), false)
    local max16 = GetNumVehicleMods(vehicle, 16)
    SetVehicleMod(vehicle, 16, (max16 > 0 and max16 - 1 or 0), false)
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    TriggerServerEvent('enzo:esx_lscustom:refreshOwnedVehicle', vehicleProps)
    ESX.ShowNotification("~g~Nous avons appliqué une personnalisation complète des performances de votre véhicule.")
end
