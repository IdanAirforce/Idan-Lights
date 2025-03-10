function AddLight(coords, color, range, intensity, radius)
    
    TriggerClientEvent('idan-lights:addLight', -1, coords, color, range, intensity, radius)

end


function RemoveLight(coords)

    TriggerClientEvent('idan-lights:removeLight', -1, coords)

end


exports('AddLight', AddLight)
exports('RemoveLight', RemoveLight)