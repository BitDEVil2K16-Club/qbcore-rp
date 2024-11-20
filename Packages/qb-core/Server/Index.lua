QBCore = {}
QBCore.Config = QBConfig
QBCore.Shared = QBShared
QBCore.ClientCallbacks = {}
QBCore.ServerCallbacks = {}

Package.Require('Shared/config.lua')
Package.Require('Shared/gangs.lua')
Package.Require('Shared/items.lua')
Package.Require('Shared/jobs.lua')
Package.Require('Shared/main.lua')
Package.Require('Shared/vehicles.lua')
Package.Require('Shared/weapons.lua')

Package.Require('functions.lua')
Package.Require('player.lua')
Package.Require('commands.lua')
Package.Require('events.lua')

Package.Export('QBShared', QBShared)
Package.Export('QBConfig', QBConfig)
Package.Export('QBCore', QBCore)
