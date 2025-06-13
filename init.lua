local function addDeferral(err)
    err = err:gsub("%^%d", "")

    AddEventHandler('playerConnecting', function(_, _, deferrals)
        deferrals.defer()
        deferrals.done(err)
    end)
end

-- Puedes modificar los archivos config_shared.lua, config_server.lua y config_client.lua para cambiar la configuración base.
-- Los convars seguirán teniendo prioridad si existen.

local config_shared = require 'modules.config.config_shared'
shared = config_shared

shared.resource = GetCurrentResourceName()
shared.framework = GetConvar('inventory:framework', shared.framework)
shared.playerslots = GetConvarInt('inventory:slots', shared.playerslots)
shared.playerweight = GetConvarInt('inventory:weight', shared.playerweight)
shared.target = GetConvarInt('inventory:target', shared.target and 1 or 0) == 1
shared.police = json.decode(GetConvar('inventory:police', json.encode(shared.police)))
shared.networkdumpsters = GetConvarInt('inventory:networkdumpsters', shared.networkdumpsters and 1 or 0) == 1

shared.dropslots = GetConvarInt('inventory:dropslots', shared.playerslots)
shared.dropweight = GetConvarInt('inventory:dropweight', shared.playerweight)

do
    if type(shared.police) == 'string' then
        shared.police = { shared.police }
    end

    local police = table.create(0, shared.police and #shared.police or 0)

    for i = 1, #shared.police do
        police[shared.police[i]] = 0
    end

    shared.police = police
end

if IsDuplicityVersion() then
    local config_server = require 'modules.config.config_server'
    server = config_server

    server.bulkstashsave = GetConvarInt('inventory:bulkstashsave', server.bulkstashsave and 1 or 0) == 1
    server.loglevel = GetConvarInt('inventory:loglevel', server.loglevel)
    server.randomprices = GetConvarInt('inventory:randomprices', server.randomprices and 1 or 0) == 1
    server.randomloot = GetConvarInt('inventory:randomloot', server.randomloot and 1 or 0) == 1
    server.evidencegrade = GetConvarInt('inventory:evidencegrade', server.evidencegrade)
    server.trimplate = GetConvarInt('inventory:trimplate', server.trimplate and 1 or 0) == 1
    server.vehicleloot = json.decode(GetConvar('inventory:vehicleloot', json.encode(server.vehicleloot)))
    server.dumpsterloot = json.decode(GetConvar('inventory:dumpsterloot', json.encode(server.dumpsterloot)))

    local accounts = json.decode(GetConvar('inventory:accounts', json.encode(server.accounts)))
    server.accounts = table.create(0, #accounts)
    for i = 1, #accounts do
        server.accounts[accounts[i]] = 0
    end
else
    PlayerData = {}
    local config_client = require 'modules.config.config_client'
    client = config_client

    client.autoreload = GetConvarInt('inventory:autoreload', client.autoreload and 1 or 0) == 1
    client.screenblur = GetConvarInt('inventory:screenblur', client.screenblur and 1 or 0) == 1
    client.keys = json.decode(GetConvar('inventory:keys', json.encode(client.keys))) or { 'F2', 'K', 'TAB' }
    client.enablekeys = json.decode(GetConvar('inventory:enablekeys', json.encode(client.enablekeys)))
    client.aimedfiring = GetConvarInt('inventory:aimedfiring', client.aimedfiring and 1 or 0) == 1
    client.giveplayerlist = GetConvarInt('inventory:giveplayerlist', client.giveplayerlist and 1 or 0) == 1
    client.weaponanims = GetConvarInt('inventory:weaponanims', client.weaponanims and 1 or 0) == 1
    client.itemnotify = GetConvarInt('inventory:itemnotify', client.itemnotify and 1 or 0) == 1
    client.weaponnotify = GetConvarInt('inventory:weaponnotify', client.weaponnotify and 1 or 0) == 1
    client.imagepath = GetConvar('inventory:imagepath', client.imagepath)
    client.dropprops = GetConvarInt('inventory:dropprops', client.dropprops and 1 or 0) == 1
    client.dropmodel = joaat(GetConvar('inventory:dropmodel', client.dropmodel))
    client.weaponmismatch = GetConvarInt('inventory:weaponmismatch', client.weaponmismatch and 1 or 0) == 1
    client.ignoreweapons = json.decode(GetConvar('inventory:ignoreweapons', json.encode(client.ignoreweapons)))
    client.suppresspickups = GetConvarInt('inventory:suppresspickups', client.suppresspickups and 1 or 0) == 1
    client.disableweapons = GetConvarInt('inventory:disableweapons', client.disableweapons and 1 or 0) == 1
    client.disablesetupnotification = GetConvarInt('inventory:disablesetupnotification',
        client.disablesetupnotification and 1 or 0) == 1
    client.enablestealcommand = GetConvarInt('inventory:enablestealcommand', client.enablestealcommand and 1 or 0) == 1

    -- ignoreweapons table
    local ignoreweapons = table.create(0, (client.ignoreweapons and #client.ignoreweapons or 0) + 3)
    for i = 1, #client.ignoreweapons do
        local weapon = client.ignoreweapons[i]
        ignoreweapons[tonumber(weapon) or joaat(weapon)] = true
    end
    ignoreweapons[`WEAPON_UNARMED`] = true
    ignoreweapons[`WEAPON_HANDCUFFS`] = true
    ignoreweapons[`WEAPON_GARBAGEBAG`] = true
    ignoreweapons[`OBJECT`] = true
    ignoreweapons[`WEAPON_HOSE`] = true
    client.ignoreweapons = ignoreweapons

    -- fallback marker
    local fallbackmarker = {
        type = 0,
        colour = { 150, 150, 150 },
        scale = { 0.5, 0.5, 0.5 }
    }

    client.shopmarker = json.decode(GetConvar('inventory:shopmarker', json.encode(client.shopmarker or {
        type = 29,
        colour = { 30, 150, 30 },
        scale = { 0.5, 0.5, 0.5 }
    }))) or fallbackmarker

    client.evidencemarker = json.decode(GetConvar('inventory:evidencemarker', json.encode(client.evidencemarker or {
        type = 2,
        colour = { 30, 30, 150 },
        scale = { 0.3, 0.2, 0.15 }
    }))) or fallbackmarker

    client.craftingmarker = json.decode(GetConvar('inventory:craftingmarker', json.encode(client.craftingmarker or {
        type = 2,
        colour = { 150, 150, 30 },
        scale = { 0.3, 0.2, 0.15 }
    }))) or fallbackmarker

    client.dropmarker = json.decode(GetConvar('inventory:dropmarker', json.encode(client.dropmarker or {
        type = 2,
        colour = { 150, 30, 30 },
        scale = { 0.3, 0.2, 0.15 }
    }))) or fallbackmarker
end

function shared.print(...) print(string.strjoin(' ', ...)) end

function shared.info(...) lib.print.info(string.strjoin(' ', ...)) end

function TypeError(variable, expected, received)
    error(("expected %s to have type '%s' (received %s)"):format(variable, expected, received))
end

local function spamError(err)
    shared.ready = false

    CreateThread(function()
        while true do
            Wait(10000)
            CreateThread(function()
                error(err, 0)
            end)
        end
    end)

    addDeferral(err)
    error(err, 0)
end

function data(name)
    if shared.server and shared.ready == nil then return {} end
    local file = ('data/%s.lua'):format(name)
    local datafile = LoadResourceFile(shared.resource, file)
    local path = ('@@%s/%s'):format(shared.resource, file)

    if not datafile then
        warn(('no datafile found at path %s'):format(path:gsub('@@', '')))
        return {}
    end

    local func, err = load(datafile, path)

    if not func or err then
        shared.ready = false
        return spamError(err)
    end

    return func()
end

if not lib then
    return spamError('ox_inventory requires the ox_lib resource, refer to the documentation.')
end

local success, msg = lib.checkDependency('oxmysql', '2.7.3')

if success then
    success, msg = lib.checkDependency('ox_lib', '3.27.0')
end

if not success then
    return spamError(msg)
end

if not LoadResourceFile(shared.resource, 'web/build/index.html') then
    return spamError(
        'UI has not been built, refer to the documentation or download a release build.\n	^3https://coxdocs.dev/ox_inventory^0')
end

if shared.target and GetResourceState('ox_target') ~= 'started' then
    shared.target = false
    warn('ox_target is not loaded - it should start before ox_inventory')
end

if lib.context == 'server' then
    shared.ready = false
    return require 'server'
end

require 'client'
