RegisterServerEvent('ddx_drugs:Wash')
AddEventHandler('ddx_drugs:Wash', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammount = xPlayer.getAccount('black_money').money

	xPlayer.removeAccountMoney('black_money', ammount)

	xPlayer.addMoney(ammount)

	TriggerClientEvent('esx:showNotification', source, _U('moneywash_washed', ammount))
end)

ESX.RegisterServerCallback('ddx_drugs:GetBlackmoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammount = xPlayer.getAccount('black_money').money
	
	cb(ammount)
end)

ESX.RegisterServerCallback('ddx_drugs:CheckMoneyWashLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xMoneyWash = xPlayer.getInventoryItem('moneywash')

	if xMoneyWash.count == 1 then
		cb(true)
	else
		cb(false)
	end
end)