local QBCore = exports['qb-core']:GetCoreObject()
local Locales = Oilwell_config.translations[Oilwell_config.locales]

function GetTranslation(key)
  return Oilwell_config.translations[Oilwell_config.locales][key]
end

local function showblender(data)
     local state = ''
     local start_btn = Locales['start_btn']
     local start_icon = 'fa-solid fa-square-caret-right'
     if type(data) == "table" and data.metadata.state == false then
          state = Locales['inactive']
          start_btn = Locales['start']
          start_icon = 'fa-solid fa-square-caret-right'
     else
          state = Locales['active']
          start_btn = Locales['stop']
          start_icon = "fa-solid fa-circle-stop"
     end

     local header = Locales['blender_unit'] .. " (" .. state .. ')'
     -- header
     local heavy_naphtha = data.metadata.heavy_naphtha
     local light_naphtha = data.metadata.light_naphtha
     local other_gases = data.metadata.other_gases
     -- new elements
     local diesel = data.metadata.diesel
     local kerosene = data.metadata.kerosene
     local fuel_oil = data.metadata.fuel_oil

     local openMenu = {
          {
               header = header,
               isMenuHeader = true,
               icon = 'fa-solid fa-blender'
          }, {
               header = Locales['heavy_naphtha'],
               icon = 'fa-solid fa-circle',
               txt = heavy_naphtha .. " " .. Locales['gallons'],
               disabled = true
          },
          {
               header = Locales['light_naphtha'],
               icon = 'fa-solid fa-circle',
               txt = light_naphtha .. " " .. Locales['gallons'],
               disabled = true
          },
          {
               header = Locales['other_gases'],
               icon = 'fa-solid fa-circle',
               txt = other_gases .. " " .. Locales['gallons'],
               disabled = true
          },
     }
     -- new elements
     if diesel then
          openMenu[#openMenu + 1] = {
               header = Locales['diesel'],
               icon = 'fa-solid fa-circle',
               txt = diesel .. " " .. Locales['gallons'],
               disabled = true
          }
     end

     if kerosene then
          openMenu[#openMenu + 1] = {
               header = Locales['kerosene'],
               icon = 'fa-solid fa-circle',
               txt = kerosene .. " " .. Locales['gallons'],
               disabled = true
          }
     end

     if fuel_oil then
          openMenu[#openMenu + 1] = {
               header = Locales['fuel_oil'],
               icon = 'fa-solid fa-circle',
               txt = fuel_oil .. " " .. Locales['gallons'] .. " (" .. Locales['no_use_in_blending'] .. ")",
               disabled = true
          }
     end

     openMenu[#openMenu + 1] = {
          header = Locales['change_recipe'],
          icon = 'fa-solid fa-scroll',
          params = {
               event = "keep-oilrig:blender_menu:recipe_blender"
          }
     }

     openMenu[#openMenu + 1] = {
          header = start_btn .. ' ' .. Locales['blending'],
          icon = start_icon,
          params = {
               event = "keep-oilrig:blender_menu:toggle_blender"
          }
     }

     openMenu[#openMenu + 1] = {
          header = Locales['pump_fuel_oil_to_storage'],
          icon = 'fa-solid fa-arrows-spin',
          params = {
               event = "keep-oilrig:blender_menu:pump_fueloil"
          }
     }

     openMenu[#openMenu + 1] = {
          header = Locales['leave'],
          icon = 'fa-solid fa-circle-xmark',
          params = {
               event = "qb-menu:closeMenu"
          }
     }

     exports['qb-menu']:openMenu(openMenu)
end

AddEventHandler('keep-oilrig:blender_menu:pump_fueloil', function()
     QBCore.Functions.TriggerCallback('keep-oilrig:server:pump_fueloil', function(result)
          showblender(result)
     end)
end)

AddEventHandler('keep-oilrig:blender_menu:ShowBlender', function()
     QBCore.Functions.TriggerCallback('keep-oilrig:server:ShowBlender', function(result)
          showblender(result)
     end)
end)

AddEventHandler('keep-oilrig:blender_menu:toggle_blender', function()
     QBCore.Functions.TriggerCallback('keep-oilrig:server:toggle_blender', function(result)
          showblender(result)
     end)
end)

local function inRange(x, min, max)
     return (x >= min and x <= max)
end

AddEventHandler('keep-oilrig:blender_menu:recipe_blender', function()
     local inputData = exports['qb-input']:ShowInput({
          header = Locales['pump_crude_oil_to_cdu'],
          submitText = Locales['enter'],
          inputs = {
               {
                    type = 'number',
                    isRequired = true,
                    name = 'heavy_naphtha',
                    text = Locales['heavy_naphtha']
               },
               {
                    type = 'number',
                    isRequired = true,
                    name = 'light_naphtha',
                    text = Locales['light_naphtha']
               },
               {
                    type = 'number',
                    isRequired = true,
                    name = 'other_gases',
                    text = Locales['other_gases']
               },
               -- new elements
               {
                    type = 'number',
                    isRequired = true,
                    name = 'diesel',
                    text = Locales['diesel']
               },
               {
                    type = 'number',
                    isRequired = true,
                    name = 'kerosene',
                    text = Locales['kerosene']
               },
          }
     })
     if inputData then
          if not
              (
              inputData.heavy_naphtha
                  and inputData.light_naphtha
                  and inputData.other_gases
                  and inputData.diesel
                  and inputData.kerosene
              ) then
               return
          end
     
          for _, value in pairs(inputData) do
               if not inRange(tonumber(value), 0, 100) then
                    QBCore.Functions.Notify(Locales['numbers_range_error'], "primary")
                    return
               end
          end
     
          QBCore.Functions.TriggerCallback('keep-oilrig:server:recipe_blender', function(result)
               showblender(result)
          end, inputData)
     end
end)