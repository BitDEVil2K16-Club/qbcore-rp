Config = {}
Config.Commission = 0.10               -- Percent that goes to sales person from a full car sale 10%
Config.FinanceCommission = 0.05        -- Percent that goes to sales person from a finance sale 5%
Config.PaymentWarning = 10             -- time in minutes that player has to make payment before repo
Config.PaymentInterval = 24            -- time in hours between payment being due
Config.MinimumDown = 10                -- minimum percentage allowed down
Config.MaximumPayments = 24            -- maximum payments allowed
Config.PreventFinanceSelling = false   -- allow/prevent players from using /transfervehicle if financed
Config.FilterByMake = false            -- adds a make list before selecting category in shops
Config.SortAlphabetically = true       -- will sort make, category, and vehicle selection menus alphabetically
Config.HideCategorySelectForOne = true -- will hide the category selection menu if a shop only sells one category of vehicle or a make has only one category
Config.Shops = {
    ['pdm'] = {
        ['Type'] = 'free-use',
        ['Job'] = 'none',
        ['TestDriveTimeLimit'] = 0.5,
        --['ReturnLocation'] = Vector(-44.74, -1082.58, 26.68),
        ['VehicleSpawn'] = {
            location = Vector(-127.491244, 14050.276126, -400),
            rotation = Rotator(0, 179, 0)
        },
        ['TestDriveSpawn'] = {
            location = Vector(-127.491244, 14050.276126, -400),
            rotation = Rotator(0, 179, 0)
        },
        ['FinanceZone'] = Vector(-29.53, -1103.67, 26.42),
        ['ShowroomVehicles'] = {
            {
                coords = {
                    location = Vector(-1769.242054, 15374.785969, -400),
                    rotation = Rotator(0, 268, 0)
                },
                defaultVehicle = 'bp_police',
                chosenVehicle = 'bp_police',
            },
            {
                coords = {
                    location = Vector(-3590, 13306, -400),
                    rotation = Rotator(0, 1, 0)
                },
                defaultVehicle = 'bp_police',
                chosenVehicle = 'bp_police',
            },
        },
    },
}
