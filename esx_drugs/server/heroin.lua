local playersProcessingPoppyResin = {}

RegisterServerEvent('ddx_drugs:pickedUpPoppy')
AddEventHandler('ddx_drugs:pickedUpPoppy', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('poppyresin')

	if xItem.limit ~= 100 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('poppy_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('ddx_drugs:processPoppyResin')
AddEventHandler('ddx_drugs:processPoppyResin', function()
	if not playersProcessingPoppyResin[source] then
		local _source = source

		playersProcessingPoppyResin[_source] = ESX.SetTimeout(Config.Delays.HeroinProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xPoppyResin, xHeroin = xPlayer.getInventoryItem('poppyresin'), xPlayer.getInventoryItem('heroin')

			if xHeroin.limit ~= 20 and (xHeroin.count + 1) > xHeroin.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('heroin_processingfull'))
			elseif xPoppyResin.count < 5 then
				TriggerClientEvent('esx:showNotification', _source, _U('heroin_processingenough'))
			else
				xPlayer.removeInventoryItem('poppyresin', 5)
				xPlayer.addInventoryItem('heroin', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('heroin_processed'))
			end

			playersProcessingPoppyResin[_source] = nil
		end)
	else
		print(('ddx_drugs: %s attempted to exploit heroin processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingPoppyResin[playerID] then
		ESX.ClearTimeout(playersProcessingPoppyResin[playerID])
		playersProcessingPoppyResin[playerID] = nil
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
