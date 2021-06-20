DM = nil
CreateThread(function()
    while DM == nil do
        Wait(0)
        TriggerEvent('esx:getSharedObject', function(object)
            DM = object
        end)
    end
end)

RegisterNetEvent('Open:this:menu')
AddEventHandler('Open:this:menu', function()
    AdminsMenu()
end)
local total = 0
AdminsMenu = function()
    DM.TriggerServerCallback('GetOnlineAdmins:tableinsert:this', function(ad)
        local admins = {}
        for i=1, #ad, 1 do
            table.insert(admins, {
                label = ad[i].name..' ['..ad[i].source..']',
                value = ad[i].source,
                perm = ad[i].perm,
                group = ad[i].group,
                name = ad[i].name
            })
            total = ad
        end
        DM.UI.Menu.Open('default', GetCurrentResourceName(), 'adminslist', {
            title = 'Admins : '..#total,
            align = 'top-left',
            elements = admins
        }, function(d, m)
            m.close()
            AdminManage(d.current.value, d.current.perm, d.current.group, d.current.name)
        end, function(d, m)
            m.close()
        end)
    end)
end

AdminManage = function(id, perm, group, name)
    local mg={}
    table.insert(mg, {label = 'Id : '..id,value='id'})    
    table.insert(mg, {label = 'PermissionLevel : '..perm,value='perm'})
    table.insert(mg, {label = 'group : '..group,value='group'})
    table.insert(mg, {label = '----------------------------',value='fasele'})
    table.insert(mg, {label = 'Set New Perm',value='setperm'})
    table.insert(mg, {label = 'Set New Group',value='setgroup'})
    DM.UI.Menu.Open('default', GetCurrentResourceName(), 'manageadmins', {
        title = name,
        align = 'top-left',
        elements = mg
    }, function(d, m)
        if d.current.value=='setperm' then
            DialogMenu(id, 'number')
            m.close()
        elseif d.current.value=='setgroup' then
            DialogMenu(id, 'string')
            m.close()
        end
    end, function(d, m)
        m.close()
        AdminsMenu()
    end)
end

DialogMenu = function(player, tp)
    DM.UI.Menu.Open('dialog', GetCurrentResourceName(), 'dialogadmins', {
        title = 'Type...',
        align = 'top-left'
    }, function(d, m)
        local dm = d.value
        local active = GetActivePlayers()
        if tp == 'string' then
            TriggerServerEvent('set:perm:or:group', player, 'group', dm, active)
            m.close()
        elseif tp == 'number' then
            TriggerServerEvent('set:perm:or:group', player, 'perm', dm, active)
            m.close()
        end
    end, function(d, m)
        m.close()
        AdminsMenu()
    end)
end

RegisterNetEvent('notif:admins')
AddEventHandler('notif:admins', function(tx)
    DM.ShowNotification(tx)
end)