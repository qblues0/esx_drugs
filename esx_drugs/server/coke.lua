local playersProcessingCocaLeaf = {}

RegisterServerEvent('ddx_drugs:pickedUpCocaLeaf')
AddEventHandler('ddx_drugs:pickedUpCocaLeaf', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('coca_leaf')

	if xItem.limit ~= 100 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('coca_leaf_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('ddx_drugs:processCocaLeaf')
AddEventHandler('ddx_drugs:processCocaLeaf', function()
	if not playersProcessingCocaLeaf[source] then
		local _source = source

		playersProcessingCocaLeaf[_source] = ESX.SetTimeout(Config.Delays.CokeProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xCocaLeaf, xCoke = xPlayer.getInventoryItem('coca_leaf'), xPlayer.getInventoryItem('coke')

			if xCoke.limit ~= 20 and (xCoke.count + 1) > xCoke.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('coke_processingfull'))
			elseif xCocaLeaf.count < 5 then
				TriggerClientEvent('esx:showNotification', _source, _U('coke_processingenough'))
			else
				xPlayer.removeInventoryItem('coca_leaf', 5)
				xPlayer.addInventoryItem('coke', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('coke_processed'))
			end

			playersProcessingCocaLeaf[_source] = nil
		end)
	else
		print(('ddx_drugs: %s attempted to exploit coke processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingCocaLeaf[playerID] then
		ESX.ClearTimeout(playersProcessingCocaLeaf[playerID])
		playersProcessingCocaLeaf[playerID] = nil
	end
end

RegisterServerEvent('ddx_drugs:cancelProcessing')
AddEventHandler('ddx_drugs:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
