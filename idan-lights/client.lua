-- Variables
local sleep = Config.DefaultSleep
local nearbyObjects = {}


-- Functions
local function AmIsraelHai()

    local objects = {}

    for _, objData in pairs(Config.Objects) do

        local objectHandle = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 50.0, GetHashKey(objData.model), false, false, false)

        if DoesEntityExist(objectHandle) then

            table.insert(objects, { handle = objectHandle, color = objData.color })

        end

    end

    return objects

end


-- Threads
Citizen.CreateThread(function()

    while true do

        nearbyObjects = AmIsraelHai()

        Wait(2000)

    end

end)


Citizen.CreateThread(function()

    while true do
        
        local pedCoords = GetEntityCoords(PlayerPedId())

        local foundLight = false

        for _, light in pairs(Config.Lights) do

            local lightDistance = #(pedCoords - light.coords)

            if lightDistance <= light.radius then

                foundLight = true

                
                DrawLightWithRange(light.coords.x, light.coords.y, light.coords.z, light.color.r, light.color.g, light.color.b, light.range, light.intensity)
            end

        end

        for _, obj in pairs(nearbyObjects) do

            local objCoords = GetEntityCoords(obj.handle)

            local objDist = #(pedCoords - objCoords)


            if objDist <= 20.0 then

                foundLight = true

                DrawLightWithRange(objCoords.x, objCoords.y, objCoords.z + 1.0, obj.color.r, obj.color.g, obj.color.b, 2.0, 1.0)

            end

        end

        Wait(foundLight and 0 or Config.DefaultSleep)

    end

end)


-- Events
RegisterNetEvent('idan-lights:addLight')
AddEventHandler('idan-lights:addLight', function(coords, color, range, intensity, radius)

    table.insert(Config.Lights, { coords = coords, color = color, range = range, intensity = intensity, radius = radius })

end)


RegisterNetEvent('idan-lights:removeLight')
AddEventHandler('idan-lights:removeLight', function(coords)

    for i, light in pairs(Config.Lights) do

        if light.coords == coords then

            table.remove(Config.Lights, i)

            break

        end

    end

end)