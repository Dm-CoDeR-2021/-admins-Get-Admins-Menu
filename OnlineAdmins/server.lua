DM = nil
TriggerEvent('esx:getSharedObject', function(object)
    DM = object
end)

DM.RegisterServerCallback('GetOnlineAdmins:tableinsert:this', function(source, cb)
	local xPlayers = DM.GetPlayers()
	local players  = {}
 	for i=1, #xPlayers, 1 do
		local xPlayer = DM.GetPlayerFromId(xPlayers[i])
        if xPlayer.permission_level > 1 then
		table.insert(players, {
			source = xPlayer.source,
			name = xPlayer.name,
			perm = xPlayer.permission_level,
			group = xPlayer.group
		})
        end
	end
 	cb(players)
end)

RegisterCommand(Config.command, function(source, args, user)
    if DM.GetPlayerFromId(source).permission_level >= Config.CommandPermission then
        TriggerClientEvent('Open:this:menu', source)
    end
end)


RegisterNetEvent('set:perm:or:group')
AddEventHandler('set:perm:or:group', function(player, pog, data, active)
    local xp = DM.GetPlayerFromId(player)
    local ac = #active
    if pog == 'perm' then
        MySQL.Async.execute('UPDATE users SET permission_level = @newperm WHERE identifier = @identifier', 
		{
		    ['@identifier'] = xp.identifier,
            ['@newperm'] = data
		},function()
		end)
        xp.set('permission_level', tonumber(data))
    end
    if pog == 'group' then
        MySQL.Async.execute('UPDATE users SET `group` = @newgroup WHERE identifier = @identifier', 
		{
		    ['@identifier'] = xp.identifier,
            ['@newgroup'] = data
		},function()
		end)
        xp.set('group', tostring(data))
    end
end)