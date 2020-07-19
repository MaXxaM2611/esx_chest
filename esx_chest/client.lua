--###################################
--## ESX_CHEST By MaXxaM#0511 ####
--###################################
--client
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 230
	DrawRect(_x, _y + 0.0250, 0.095 + factor, 0.06, 41, 11, 41, 100)
end

function interazioneMagazzini(id, prezzo, codice)
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'interazione_magazzini',
	  {
		  title    = 'Magazzino',
		  elements = {
            {label = 'Compra Magazzino | ' .. prezzo .. ' dollari', value = 'compra'},
            {label = 'Apri Magazzino', value = 'apri'},
            {label = 'Vendi Magazzino', value = 'vendi'},
		  }
	  },
	  function(data, menu)
		  local val = data.current.value
		  
			if val == 'compra' then
			    menu.close()
                TriggerServerEvent('esx_chest:acquisto', id, prezzo, codice)
            elseif val == 'apri' then
                menu.close()
                AddTextEntry("FMMC_KEY_TIP1", "Inserisci il Codice")
                DisplayOnscreenKeyboard(6, "FMMC_KEY_TIP1", "", "", "", "", "", 6)
                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                    Citizen.Wait(0)
                end
                if UpdateOnscreenKeyboard() ~= 2 then
                    local result = GetOnscreenKeyboardResult()
					if result == codice then
						PlaySoundFrontend(-1, "Drill_Pin_Break", 'DLC_HEIST_FLEECA_SOUNDSET', 1);
						ApriInventario(id)
						ESX.ShowNotification("~g~Codice inserito correttamente")
						TriggerServerEvent('esx_chest:discord', id)
                    else
                        ESX.ShowNotification("~r~Codice errato")
                    end
                end
		    end
	  end,
	  function(data, menu)
		  menu.close()
	  end
  )
end

function ApriInventario(id)

	local elements = {
		{label = 'Prendi oggetto',  value = 'get_stock'},
		{label = 'Deposita oggetto', value = 'put_stock'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory',
	{
		title    = 'Inventario',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'put_stock' then
			OpenPutStocksMenu(id)
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu(id)
		end

	end, function(data, menu)
		menu.close()

	end)

end

function OpenGetStocksMenu(id)

ESX.TriggerServerCallback('esx_chest:getStockItems', function(items)


	local elements = {}

	for i=1, #items, 1 do
		table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
	{
		title    = 'Inventario',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		local itemName = data.current.value

		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
			title = 'Quantità'
		}, function(data2, menu2)

			local count = tonumber(data2.value)

			if count == nil then
				ESX.ShowNotification('Quantità non valida')
			else
				menu2.close()
				--menu.close()
				TriggerServerEvent('esx_chest:getStockItem', itemName, count, 'society_magazzino' .. id)

				Citizen.Wait(300)
				OpenGetStocksMenu()
			end

		end, function(data2, menu2)
			menu2.close()
		end)

	end, function(data, menu)
		menu.close()
	end)

end, 'society_magazzino' .. id)

end

function OpenPutStocksMenu(id)

ESX.TriggerServerCallback('esx_chest:getPlayerInventory', function(inventory)

	local elements = {}

	for i=1, #inventory.items, 1 do
		local item = inventory.items[i]

		if item.count > 0 then
			table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
	{
		title    = 'Inventario',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		local itemName = data.current.value

		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
			title = 'Quantità'
		}, function(data2, menu2)

			local count = tonumber(data2.value)

			if count == nil then
				ESX.ShowNotification('Quantità non valida')
			else
				menu2.close()
				--menu.close()
				TriggerServerEvent('esx_chest:putStockItems', itemName, count, 'society_magazzino' .. id)

				Citizen.Wait(300)
				OpenPutStocksMenu()
			end

		end, function(data2, menu2)
			menu2.close()
		end)

	end, function(data, menu)
		menu.close()
	end)
end)

end

Citizen.CreateThread(function()
      
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k,v in pairs(Magazzini)do
            local pos2 = v.posizione
            
            if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0) then
                DrawMarker(23, v.posizione.x, v.posizione.y, v.posizione.z-0.9, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 127, 255, 212, 200, 0, 0, 0, 0)
                if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0) then
                    DrawText3D(v.posizione.x, v.posizione.y, v.posizione.z, '~w~[~g~E~w~] Magazzino', 0.6)
                    --DisplayHelpText(_U('press_to_action'))
                    if IsControlJustReleased(1, 51) then
                        interazioneMagazzini(v.id, v.prezzo, v.codice)
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)