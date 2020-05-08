local playersProcessingChemicalsToHydrochloricAcid = {}

RegisterServerEvent('ddx_drugs:pickedUpChemicals')
AddEventHandler('ddx_drugs:pickedUpChemicals', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('chemicals')

	if xItem.limit ~= 100 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('Chemicals_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('ddx_drugs:ChemicalsConvertionMenu')
AddEventHandler('ddx_drugs:ChemicalsConvertionMenu', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(itemName)
	local xChemicals = xPlayer.getInventoryItem('chemicals')

	if xChemicals.count < amount then
		TriggerClientEvent('esx:showNotification', source, _U('Chemicals_notenough', xItem.label))
		return
	end
	
	Citizen.Wait(5000)

	xPlayer.addInventoryItem(xItem.name, amount)

	xPlayer.removeInventoryItem('chemicals', amount)

	TriggerClientEvent('esx:showNotification', source, _U('Chemicals_made', xItem.label))
end)

ESX.RegisterServerCallback('ddx_drugs:CheckLisense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xChemicalsLisence = xPlayer.getInventoryItem('chemicalslisence')

	if xChemicalsLisence.count == 1 then
		cb(true)
	else
		cb(false)
	end
end)