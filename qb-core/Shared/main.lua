QBCore = {}
QBCore.PlayerData = {}
QBCore.Config = {}
QBCore.Shared = {}

exports('qb-core', 'GetShared', function(Type)
    return QBCore.Shared[Type] or QBCore.Shared
end)

exports('qb-core', 'GetConfig', function()
    return QBCore.Config
end)
