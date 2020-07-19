--###################################
--## ESX_CHEST By MaXxaM#0511 ####
--###################################
--server

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'magazzino1', 'Magazzino1', 'society_magazzino1', 'society_magazzino1', 'society_magazzino1', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino2', 'Magazzino2', 'society_magazzino2', 'society_magazzino2', 'society_magazzino2', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino3', 'Magazzino3', 'society_magazzino3', 'society_magazzino3', 'society_magazzino3', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino4', 'Magazzino4', 'society_magazzino4', 'society_magazzino4', 'society_magazzino4', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino5', 'Magazzino5', 'society_magazzino5', 'society_magazzino5', 'society_magazzino5', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino6', 'Magazzino6', 'society_magazzino6', 'society_magazzino6', 'society_magazzino6', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino7', 'Magazzino7', 'society_magazzino7', 'society_magazzino7', 'society_magazzino7', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino8', 'Magazzino8', 'society_magazzino8', 'society_magazzino8', 'society_magazzino8', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino9', 'Magazzino9', 'society_magazzino9', 'society_magazzino9', 'society_magazzino9', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino10', 'Magazzino10', 'society_magazzino10', 'society_magazzino10', 'society_magazzino10', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino11', 'Magazzino11', 'society_magazzino11', 'society_magazzino11', 'society_magazzino11', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino12', 'Magazzino12', 'society_magazzino12', 'society_magazzino12', 'society_magazzino12', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino13', 'Magazzino13', 'society_magazzino13', 'society_magazzino13', 'society_magazzino13', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino14', 'Magazzino14', 'society_magazzino14', 'society_magazzino14', 'society_magazzino14', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino15', 'Magazzino15', 'society_magazzino15', 'society_magazzino15', 'society_magazzino15', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino16', 'Magazzino16', 'society_magazzino16', 'society_magazzino16', 'society_magazzino16', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino17', 'Magazzino17', 'society_magazzino17', 'society_magazzino17', 'society_magazzino17', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino18', 'Magazzino18', 'society_magazzino18', 'society_magazzino18', 'society_magazzino18', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino19', 'Magazzino19', 'society_magazzino19', 'society_magazzino19', 'society_magazzino19', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'magazzino20', 'Magazzino20', 'society_magazzino20', 'society_magazzino20', 'society_magazzino20', {type = 'public'})

ESX.RegisterServerCallback('esx_chest:getStockItems', function(source, cb, society)
	TriggerEvent('esx_addoninventory:getSharedInventory', society, function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_chest:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

RegisterServerEvent('esx_chest:getStockItem')
AddEventHandler('esx_chest:getStockItem', function(itemName, count, society)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', society, function(inventory)

		local inventoryItem = inventory.getItem(itemName)

	
		if count > 0 and inventoryItem.count >= count then
		
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, 'Quantità non valida')
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, ('Hai prelevato' .. count .. inventoryItem.label))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, 'Quantità non valida')
		end
	end)

end)

RegisterServerEvent('esx_chest:putStockItems')
AddEventHandler('esx_chest:putStockItems', function(itemName, count, society)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', society, function(inventory)

		local inventoryItem = inventory.getItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, ('Hai depositato' .. count .. inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantità non valida')
		end

	end)

end)

RegisterServerEvent('esx_chest:acquisto')
AddEventHandler('esx_chest:acquisto', function(id, prezzo, codice)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = ESX.GetPlayerFromId(source).identifier
  
    MySQL.Async.fetchAll(
    'SELECT identifier FROM chest WHERE id = @id',
    {
      ['@id'] = id,
    }, function(result)
        if result[1].identifier ~= '0' then
            TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Magazzino già acquistato')
        else
            if xPlayer.getMoney() >= prezzo then
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~g~Magazzino acquistato')
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Il codice di sblocco è ~g~' .. codice)
                MySQL.Async.fetchAll(
                "UPDATE chest SET identifier = @identifier WHERE id = @id",
                {
                    ['@identifier']  = identifier, 
                    ['@id'] = id,
                }, function(result)
                end)
                xPlayer.removeMoney(prezzo)
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Non hai abbastanza soldi! Ti mancano ' .. math.floor(prezzo - xPlayer.getMoney()) .. ' dollari')
            end
        end
    end)
end)

function sendToDiscord (name,message,color)
	local DiscordWebHook = "https://discordapp.com/api/webhooks/CAMBIALO"
	-- Modifica il webhook con il tuo personale 
  
  local embeds = {
	  {
		  ["title"]=message,
		  ["type"]="rich",
		  ["color"] =color,
		  ["footer"]=  {
		  ["text"]= "ESX-discord_bot_alert",
		 },
	  }
  }
  
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('esx_chest:discord')
AddEventHandler('esx_chest:discord', function(id)
   local xPlayer = ESX.GetPlayerFromId(source)

   sendToDiscord('Magazzini', xPlayer.name .. " " .. " ha aperto il magazzino" .. id, Config.red)

end)

