local playersProcessingMeth = {}

RegisterServerEvent('ddx_drugs:pickedUpHydrochloricAcid')
AddEventHandler('ddx_drugs:pickedUpHydrochloricAcid', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('hydrochloric_acid')

	if xItem.limit ~= 100 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('hydrochloric_acid_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('ddx_drugs:pickedUpSodiumHydroxide')
AddEventHandler('ddx_drugs:pickedUpSodiumHydroxide', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('sodium_hydroxide')

	if xItem.limit ~= 100 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('sodium_hydroxide_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('ddx_drugs:pickedUpSulfuricAcid')
AddEventHandler('ddx_drugs:pickedUpSulfuricAcid', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('sulfuric_acid')

	if xItem.limit ~= 100 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('sulfuric_acid_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('ddx_drugs:processMeth')
AddEventHandler('ddx_drugs:processMeth', function()
	if not playersProcessingMeth[source] then
		local _source = source

		playersProcessingMeth[_source] = ESX.SetTimeout(Config.Delays.MethProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xhydrochloric_acid,xsulfuric_acid,xsodium_hydroxide,xmeth = xPlayer.getInventoryItem('hydrochloric_acid'),xPlayer.getInventoryItem('sulfuric_acid'),xPlayer.getInventoryItem('sodium_hydroxide'), xPlayer.getInventoryItem('meth')

			if xmeth.limit ~= 20 and (xmeth.count + 1) > xmeth.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('meth_processingfull'))
			elseif xhydrochloric_acid.count < 5 then
				TriggerClientEvent('esx:showNotification', _source, _U('meth_processingenough'))
			elseif xsulfuric_acid.count < 5 then
				TriggerClientEvent('esx:showNotification', _source, _U('meth_processingenough'))
			elseif xsodium_hydroxide.count < 5 then
				TriggerClientEvent('esx:showNotification', _source, _U('meth_processingenough'))
			else
				xPlayer.removeInventoryItem('hydrochloric_acid', 5)
				xPlayer.removeInventoryItem('sulfuric_acid', 5)
				xPlayer.removeInventoryItem('sodium_hydroxide', 5)
				xPlayer.addInventoryItem('meth', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('meth_processed'))
			end

			playersProcessingMeth[_source] = nil
		end)
	else
		print(('ddx_drugs: %s attempted to exploit meth processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingMeth[playerID] then
		ESX.ClearTimeout(playersProcessingMeth[playerID])
		playersProcessingMeth[playerID] = nil
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
