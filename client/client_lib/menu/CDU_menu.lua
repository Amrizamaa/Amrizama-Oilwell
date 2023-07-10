local QBCore = exports['qb-core']:GetCoreObject()
local Locales = Oilwell_config.translations[Oilwell_config.locales]

function GetTranslation(key)
  return Oilwell_config.translations[Oilwell_config.locales][key]
end

local function showCDU(data)
     if not data then return end
     local state = ''
     if data.metadata.state == true then
          state = Locales['active']
     else
          state = Locales['inactive']
     end
     local header = Locales['crude_oil_distillation_unit'] .. " (" .. state .. ')'
     -- header
     local CDU_Temperature = data.metadata.temp
     local CDU_Gal = data.metadata.oil_storage
     local openMenu = {
          {
               header = header,
               isMenuHeader = true,
               icon = 'fa-solid fa-gear'
          },
          {
               header = Locales['temperature'],
               icon = 'fa-solid fa-temperature-high',
               txt = "" .. CDU_Temperature .. " °C",
          },
          {
               header = Locales['crude_oil_inside_CDU'],
               icon = 'fa-solid fa-oil-can',
               txt = CDU_Gal .. " " .. Locales['gallons'],
          },
          {
               header = Locales['pump_crude_oil_to_CDU'],
               icon = 'fa-solid fa-arrows-spin',
               params = {
                    event = "keep-oilrig:CDU_menu:pumpCrudeOil_to_CDU"
               }
          },
          {
               header = Locales['change_temperature'],
               icon = 'fa-solid fa-temperature-arrow-up',
               params = {
                    event = "keep-oilrig:CDU_menu:set_CDU_temp"
               }
          },
          {
               header = Locales['toggle_CDU'],
               icon = 'fa-solid fa-sliders',
               params = {
                    event = "keep-oilrig:CDU_menu:switchPower_of_CDU"
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
end


AddEventHandler('keep-oilrig:CDU_menu:ShowCDU', function()
     QBCore.Functions.TriggerCallback('keep-oilrig:server:get_CDU_Data', function(result)
          showCDU(result)
     end)
end)

AddEventHandler('keep-oilrig:CDU_menu:switchPower_of_CDU', function()
     QBCore.Functions.TriggerCallback('keep-oilrig:server:switchPower_of_CDU', function(result)
          showCDU(result)
     end)
end)

AddEventHandler('keep-oilrig:CDU_menu:set_CDU_temp', function()
     local inputData = exports['qb-input']:ShowInput({
          header = Locales['CDU_temperature'],
          submitText = Locales['assign_new_temperature'],
          inputs = {
               {
                    type = 'number',
                    isRequired = true,
                    name = 'temp',
                    text = Locales['enter_new_temperature']
               },
          }
     })
     if inputData then
          if not inputData.temp then
               return
          end
          QBCore.Functions.TriggerCallback('keep-oilrig:server:set_CDU_temp', function(result)
               showCDU(result)
          end, inputData)
     end
end)

AddEventHandler('keep-oilrig:CDU_menu:pumpCrudeOil_to_CDU', function()
     local inputData = exports['qb-input']:ShowInput({
          header = Locales['pump_crude_oil_to_CDU'],
          submitText = Locales['enter'],
          inputs = {
               {
                    type = 'number',
                    isRequired = true,
                    name = 'amount',
                    text = Locales['enter_value']
               },
          }
     })
     if inputData then
          inputData.amount = tonumber(inputData.amount)
          if not inputData.amount then
               return
          end

          if inputData.amount <= 0 then
               QBCore.Functions.Notify(Locales['amount_more_than_zero'], "error")
               return
          end
          QBCore.Functions.TriggerCallback('keep-oilrig:server:pumpCrudeOil_to_CDU', function(result)
               showCDU(result)
          end, inputData)
     end
end)