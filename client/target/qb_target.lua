local QBCore = exports['qb-core']:GetCoreObject()
local debugPoly = false
local Locales = Oilwell_config.translations[Oilwell_config.locales]

function GetTranslation(key)
  return Oilwell_config.translations[Oilwell_config.locales][key]
end

Targets['ox_target'] = {}

function Targets.ox_target.storage(coords, name)
    local tmp_coord = vector3(coords.x, coords.y, coords.z + 2)

    exports.ox_target:addBoxZone({
        coords = tmp_coord,
        size = vector3(2, 2, 2),
        rotation = 0,
        debug = debugPoly,
        options = {
            {
                type = "client",
                event = "keep-oilrig:storage_menu:ShowStorage",
                icon = "fa-solid fa-arrows-spin",
                label = Locales['view_storage'],
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        TriggerEvent('QBCore:Notify', Locales['must_be_on_duty'], "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
        },
    })
end


function Targets.ox_target.distillation(coords, name)
    local tmp_coord = vector3(coords.x, coords.y, coords.z + 1.1)

    exports.ox_target:addBoxZone({
        coords = tmp_coord,
        size = vector3(2.4, 2.4, 2.4),
        rotation = 0,
        debug = debugPoly,
        options = {
            {
                type = "client",
                event = "keep-oilrig:CDU_menu:ShowCDU",
                icon = "fa-solid fa-gear",
                label = Locales['open_cdu_panels'],
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        TriggerEvent('QBCore:Notify', Locales['must_be_on_duty'], "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
        },
    })
end


function Targets.ox_target.toggle_job(coords, name)
    local tmp_coord = vector3(coords.x, coords.y, coords.z + 1.1)

    exports.ox_target:addBoxZone({
        coords = tmp_coord,
        size = vector3(1.5, 1.5, 1.5),
        rotation = 0,
        debug = debugPoly,
        options = {
            {
                type = "client",
                event = "keep-oilrig:client:goOnDuty",
                icon = "fa-solid fa-boxes-packing",
                label = Locales['toggle_duty'],
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    return true
                end,
            },
        },
    })
end


function Targets.ox_target.barrel_withdraw(coords, name)
    local tmp_coord = vector3(coords.x, coords.y, coords.z + 1.1)

    exports.ox_target:addBoxZone({
        coords = tmp_coord,
        size = vector3(2.0, 2.0, 2.0),
        rotation = 0,
        debug = debugPoly,
        options = {
            {
                type = "client",
                event = "keep-oilrig:client_lib:withdraw_from_queue",
                icon = "fa-solid fa-boxes-packing",
                label = Locales['transfer_to_stash'],
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        TriggerEvent('QBCore:Notify', Locales['must_be_on_duty'], "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
            {
                type = "client",
                event = "keep-oilwell:client:openWithdrawStash",
                icon = "fa-solid fa-boxes-packing",
                label = Locales['open_withdraw_stash'],
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        TriggerEvent('QBCore:Notify', Locales['must_be_on_duty'], "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
            {
                type = "client",
                event = "keep-oilwell:client:open_purge_menu",
                icon = "fa-solid fa-trash-can",
                label = Locales['purge_withdraw_stash'],
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        TriggerEvent('QBCore:Notify', Locales['must_be_on_duty'], "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
        },
    })
end


function Targets.ox_target.blender(coords, name)
    local tmp_coord = vector3(coords.x, coords.y, coords.z + 2.5)

    exports.ox_target:addBoxZone({
        coords = tmp_coord,
        size = vector3(7.0, 7.0, 5.0),
        rotation = 0,
        debug = debugPoly,
        options = {
            {
                type = "client",
                event = "keep-oilrig:blender_menu:ShowBlender",
                icon = "fa-solid fa-gear",
                label = Locales['open_blender_panel'],
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        TriggerEvent('QBCore:Notify', Locales['must_be_on_duty'], "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
        },
    })
end

function Targets.ox_target.crude_oil_transport(coords, name)
    local tmp_coord = vector3(coords.x, coords.y, coords.z + 2.5)

    exports.ox_target:addBoxZone({
        coords = tmp_coord,
        size = vector3(4.0, 4.0, 4.0),
        rotation = 0,
        debug = debugPoly,
        options = {
            {
                type = "client",
                event = "keep-oilwell:menu:show_transport_menu",
                icon = "fa-solid fa-boxes-packing",
                label = Locales['fill_transport'],
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        TriggerEvent('QBCore:Notify', Locales['must_be_on_duty'], "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
        },
    })
end


function Targets.ox_target.oilwell(coords, name)
    local coord = vector3(coords.x, coords.y, coords.z + 2.5)

    exports.ox_target:addBoxZone({
        coords = coord,
        size = vector3(7.0, 7.0, 5.0),
        rotation = 0,
        debug = true,
        options = {
            {
                type = "client",
                event = "keep-oilrig:client:viewPumpInfo",
                icon = "fa-solid fa-info",
                label = Locales['view_pump_info'],
                canInteract = function(entity)
                    return true
                end,
            },
            {
                type = "client",
                event = "keep-oilrig:client:changeRigSpeed",
                icon = "fa-solid fa-gauge-high",
                label = Locales['modify_pump_settings'],
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then return false end
                    return isOwner(entity)
                end,
            },
            {
                type = "client",
                event = "keep-oilrig:client:show_oilwell_stash",
                icon = "fa-solid fa-gears",
                label = Locales['manage_parts'],
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then return false end
                    return isOwner(entity)
                end,
            },
            {
                type = "client",
                event = "keep-oilwell:client:remove_oilwell",
                icon = "fa-regular fa-file-lines",
                label = Locales['remove_oilwell'],
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not (PlayerJob.grade.level == 4) then return false end
                    if not CheckOnduty() then return false end
                    return true
                end,
            },
        },
    })
end

function Targets.ox_target.truck(plate, truck)
    exports.ox_target:addBoxZone({
        coords = GetEntityCoords(truck),
        size = vector3(5.0, 5.0, 3.0),
        rotation = GetEntityHeading(truck),
        debug = false,
        options = {
            {
                type = "client",
                event = "keep-oilwell:client:refund_truck",
                icon = "fa-solid fa-location-arrow",
                label = Locales['refund_truck'],
                vehiclePlate = plate
            },
        },
    })
end

