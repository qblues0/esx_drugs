local playersProcessingLSD = {}

RegisterServerEvent('ddx_drugs:processLSD')
AddEventHandler('ddx_drugs:processLSD', function()
	if not playersProcessingLSD[source] then
		local _source = source

		playersProcessingLSD[_source] = ESX.SetTimeout(Config.Delays.lsdProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xLSA, xThionylChloride, xLSD = xPlayer.getInventoryItem('lsa'), xPlayer.getInventoryItem('thionyl_chloride'), xPlayer.getInventoryItem('lsd')

			if xLSD.limit ~= 20 and (xLSD.count + 1) > xLSD.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('lsd_processingfull'))
			elseif xThionylChloride.count < 5 then
				TriggerClientEvent('esx:showNotification', _source, _U('lsd_processingenough'))
			else
				xPlayer.removeInventoryItem('thionyl_chloride', 5)
				xPlayer.addInventoryItem('lsd', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('lsd_processed'))
			end

			playersProcessingLSD[_source] = nil
		end)
	else
		print(('ddx_drugs: %s attempted to exploit lsd processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

RegisterServerEvent('ddx_drugs:processThionylChloride')
AddEventHandler('ddx_drugs:processThionylChloride', function()
	if not playersProcessingLSD[source] then
		local _source = source

		playersProcessingLSD[_source] = ESX.SetTimeout(Config.Delays.lsdProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xLSA, xChemicals, xThionylChloride = xPlayer.getInventoryItem('lsa'), xPlayer.getInventoryItem('chemicals'), xPlayer.getInventoryItem('thionyl_chloride')

			if xThionylChloride.limit ~= 100 and (xThionylChloride.count + 1) > xThionylChloride.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('thionylchloride_processingfull'))
			elseif xLSA.count < 5 or xChemicals.count < 5 then
				TriggerClientEvent('esx:showNotification', _source, _U('thionylchloride_processingenough'))
			else
				xPlayer.removeInventoryItem('lsa', 5)
				xPlayer.removeInventoryItem('chemicals', 5)
				xPlayer.addInventoryItem('thionyl_chloride', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('thionylchloride_processed'))
			end

			playersProcessingLSD[_source] = nil
		end)
	else
		print(('ddx_drugs: %s attempted to exploit lsd processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingLSD[playerID] then
		ESX.ClearTimeout(playersProcessingLSD[playerID])
		playersProcessingLSD[playerID] = nil
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
