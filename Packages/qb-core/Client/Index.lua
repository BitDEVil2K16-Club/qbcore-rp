QBCore = {}
QBCore.PlayerData = {}
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

Package.Require('menu.lua')
Package.Require('input.lua')
Package.Require('drawtext.lua')
Package.Require('events.lua')
Package.Require('functions.lua')
Package.Require('loops.lua')

Package.Export('QBConfig', QBConfig)
Package.Export('QBShared', QBShared)
Package.Export('QBCore', QBCore)

Package.Export("exports", exports)

local waiting_coroutines = {}

-- -- Periodically check and resume waiting coroutines
-- function RunScheduledFunctions()
--     local current_time = os.clock()
--     print(#waiting_coroutines)
--     for co, end_time in pairs(waiting_coroutines) do
--         if current_time >= end_time then
--             print("Should execute")
--             waiting_coroutines[co] = nil
--             local ok, err = coroutine.resume(co)
--             if not ok then
--                 print("Coroutine error: ", err)
--             end
--         end
--     end
-- end

-- --Simulate waiting in a coroutine
-- function Wait(sec)
--     print("waiting")
--     local co = coroutine.running()
--     if co then
--         local end_time = os.clock() + sec
--         waiting_coroutines[co] = end_time
--         coroutine.yield()
--     else
--         print("Wait must be called from within a coroutine")
--     end
-- end


-- CreateThread(function ()
--     print("started "..   tostring(os.clock()))
--     for i = 1, 100, 1 do
--         local a = 500 * 500 / 500
--     end
--     Wait(2)
--     print("ended " ..  tostring(os.clock()))
-- end)
--exports['qb-menu']:openMenu()
