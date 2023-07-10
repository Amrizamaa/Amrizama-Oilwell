local QBCore = exports['qb-core']:GetCoreObject()
local Locales = Oilwell_config.translations[Oilwell_config.locales]

function GetTranslation(key)
  return Oilwell_config.translations[Oilwell_config.locales][key]
end

local function showInfo(data)
     QBCore.Functions.TriggerCallback('keep-oilwell:server:oilwell_metadata', function(selected_oilrig)
          local header = Locales['name']:format(data.name)
          local partInfoString = Locales['belt']:format(selected_oilrig.part_info.belt) ..
              Locales['polish']:format(selected_oilrig.part_info.polish) ..
              Locales['clutch']:format(selected_oilrig.part_info.clutch)
          local duration = math.floor(selected_oilrig.duration / 60)
          
          local openMenu = {
               {
                    header = header,
                    isMenuHeader = true,
                    icon = 'fa-solid fa-oil-well'
               }, {
                    header = Locales['speed'],
                    icon = 'fa-solid fa-gauge',
                    txt = Locales['speed_value']:format(selected_oilrig.speed),
                    disabled = true,
               },
               {
                    header = Locales['duration'],
                    icon = 'fa-solid fa-clock',
                    txt = Locales['duration_value']:format(duration),
                    disabled = true,
               },
               {
                    header = Locales['temperature'],
                    icon = 'fa-solid fa-temperature-high',
                    txt = Locales['temperature_value']:format(selected_oilrig.temp),
                    disabled = true,
               },
               {
                    header = Locales['oil_storage'],
                    icon = 'fa-solid fa-oil-can',
                    txt = Locales['oil_storage_value']:format(selected_oilrig.oil_storage),
                    disabled = true,
               },
               {
                    header = Locales['part_info'],
                    icon = 'fa-solid fa-oil-can',
                    txt = partInfoString,
                    disabled = true,
               },
               {
                    header = Locales['pump_oil_storage'],
                    icon = 'fa-solid fa-arrows-spin',
                    params = {
                         event = 'keep-oilrig:storage_menu:PumpOilToStorage',
                         args = {
                              oilrig_hash = data.oilrig_hash
                         }
                    }
               },
               {
                    header = Locales['manage_employees'],
                    icon = 'fa-solid fa-people-group',
                    params = {
                         event = 'keep-oilwell:menu:ManageEmployees',
                         args = data.oilrig_hash
                    }
               },
               {
                    header = Locales['leave'],
                    icon = 'fa-solid fa-circle-xmark',
                    params = {
                         event = "qb-menu:closeMenu"
                    }
               }
          }

          exports['qb-menu']:openMenu(openMenu)
     end, data.oilrig_hash)
end

RegisterNetEvent('keep-oilwell:menu:ManageEmployees', function(oilrig_hash)
     QBCore.Functions.TriggerCallback('keep-oilwell:server:employees_list', function(result)
          if not result then return end
          
          local Menu = {
               {
                    header = Locales['oilwell_employees'],
                    isMenuHeader = true,
                    icon = 'fa-solid fa-vest'
               },
          }

          Menu[#Menu + 1] = {
               header = Locales['add_new_employee'],
               icon = 'fa-solid fa-person-circle-plus',
               params = {
                    event = "keep-oilwell:client:add_employee",
                    args = {
                         oilrig_hash = oilrig_hash,
                         state_id = 1
                    }
               }
          }

          for index, employee in ipairs(result) do
               local name = employee.charinfo.firstname .. ' ' .. employee.charinfo.lastname
               local gender = (employee.charinfo.gender == 0 and Locales['male'] or Locales['female'])
               local information = Locales['employee_information']
               local other = ' (Online: %s)'
               local online = (employee.online and '🟢' or not employee.online and '🔴')

               Menu[#Menu + 1] = {
                    header = Locales['employee_header']:format(index) .. string.format(other, online),
                    txt = string.format(information, name, employee.charinfo.phone, gender),
                    icon = 'fa-solid fa-person',
                    params = {
                         event = "keep-oilwell:menu:remove_employee",
                         args = {
                              employee = employee,
                              oilrig_hash = oilrig_hash
                         }
                    }
               }
          end

          Menu[#Menu + 1] = {
               header = Locales['leave'],
               icon = 'fa-solid fa-circle-xmark',
               params = {
                    event = "qb-menu:closeMenu"
               }
          }

          exports['qb-menu']:openMenu(Menu)
     end, oilrig_hash)
end)


RegisterNetEvent('keep-oilwell:client:add_employee', function(data)
     local inputData = exports['qb-input']:ShowInput({
          header = Locales['enter_employee_state_id'],
          inputs = {
               {
                    type = 'number',
                    isRequired = true,
                    name = 'stateId',
                    text = Locales['enter_state_id']
               },
          }
     })
     if inputData then
          if not inputData.stateId then return end
          inputData.stateId = tonumber(inputData.stateId)
          TriggerServerEvent('keep-oilwell:server:add_employee', data.oilrig_hash, inputData.stateId)
     end
end)

RegisterNetEvent('keep-oilwell:menu:remove_employee', function(data)
     local employee = data.employee
     local name = employee.charinfo.firstname .. ' ' .. employee.charinfo.lastname
     local Menu = {
          {
               header = Locales['back'],
               icon = 'fa-solid fa-angle-left',
               params = {
                    event = "keep-oilwell:menu:ManageEmployees",
                    args = data.oilrig_hash
               }
          },
          {
               header = Locales['fire_employee'],
               txt = Locales['employee_name']:format(name),
               isMenuHeader = true,
               icon = 'fa-solid fa-vest'
          },
          {
               header = Locales['yes'],
               icon = 'fa-solid fa-circle-check',
               params = {
                    event = "keep-oilwell:menu:fire_employee",
                    args = {
                         employee = data.employee,
                         oilrig_hash = data.oilrig_hash
                    }
               }
          }
     }

     Menu[#Menu + 1] = {
          header = Locales['cancel'],
          icon = 'fa-solid fa-circle-xmark',
          params = {
               event = "qb-menu:closeMenu"
          }
     }

     exports['qb-menu']:openMenu(Menu)
end)

RegisterNetEvent('keep-oilwell:menu:fire_employee', function(data)
     TriggerServerEvent('keep-oilwell:server:remove_employee', data.oilrig_hash, data.employee.citizenid)
end)

local function show_oilwell_stash(data)
     QBCore.Functions.TriggerCallback('keep-oilwell:server:oilwell_metadata', function(selected_oilrig)
          local header = "Name: " .. data.name
          local partInfoString = "Belt: " ..
              selected_oilrig.part_info.belt ..
              " Polish: " .. selected_oilrig.part_info.polish .. " Clutch: " .. selected_oilrig.part_info.clutch
          local openMenu = {
               {
                    header = header,
                    isMenuHeader = true,
                    icon = 'fa-solid fa-oil-well'
               },
               {
                    header = 'Part Info',
                    icon = 'fa-solid fa-oil-can',
                    txt = partInfoString,
                    disabled = true,
               },
               {
                    header = Locales['open_stash'],
                    icon = 'fa-solid fa-cart-flatbed',
                    params = {
                         event = 'keep-oilwell:client:openOilPump',
                         args = {
                              oilrig_hash = data.oilrig_hash
                         }
                    }
               },
               {
                    header = Locales['fix_oilwell'],
                    icon = 'fa-solid fa-screwdriver-wrench',
                    params = {
                         event = 'keep-oilwell:client:fix_oilwell',
                         args = {
                              oilrig_hash = data.oilrig_hash
                         }
                    }
               },
               {
                    header = Locales['leave'],
                    icon = 'fa-solid fa-circle-xmark',
                    params = {
                         event = "qb-menu:closeMenu"
                    }
               }
          }

          exports['qb-menu']:openMenu(openMenu)
     end, data.oilrig_hash)
end


-- Events
AddEventHandler('keep-oilrig:storage_menu:PumpOilToStorage', function(data)
     QBCore.Functions.TriggerCallback('keep-oilrig:server:PumpOilToStorageCallback', function(result)

     end, data.oilrig_hash)
end)

AddEventHandler('keep-oilrig:client:viewPumpInfo', function(qbtarget)
     -- ask for updated data
     OilRigs:startUpdate(function()
          showInfo(OilRigs:getByEntityHandle(qbtarget.entity))
     end)
end)


AddEventHandler('keep-oilrig:client:show_oilwell_stash', function(qbtarget)
     -- ask for updated data
     OilRigs:startUpdate(function()
          show_oilwell_stash(OilRigs:getByEntityHandle(qbtarget.entity))
     end)
end)

-- Open oil pump stash.
RegisterNetEvent("keep-oilwell:client:openOilPump", function(data)
     if not data then return end
     TriggerServerEvent("inventory:server:OpenInventory", "stash", "oilPump_" .. data.oilrig_hash,
          { maxweight = 100000, slots = 5 })
     TriggerEvent("inventory:client:SetCurrentStash", "oilPump_" .. data.oilrig_hash)
end)

AddEventHandler('keep-oilwell:client:fix_oilwell', function(data)
     -- ask for updated data
     QBCore.Functions.TriggerCallback('keep-oilwell:server:fix_oil_well', function(result)
          print(result)
     end, data.oilrig_hash)

end)
