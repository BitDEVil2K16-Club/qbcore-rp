Config = {
    Vehicle = 'abcca-qbcore-veh::BP_Garbage_Truck',

    MinStops = 3,

    MinBagsPerStop = 2,

    BagLowerWorth = 300,
    BagUpperWorth = 1000,

    Locations = {
        ['Depots'] = {
            {
                label = 'West Garbage Depot',
                pedSpawn = { coords = Vector(-257770.4, 35765.8, 184.7), heading = -4.25 },
                vehicleSpawn = { coords = Vector(-257274.0, 35627.7, 154.7), heading = 5.48 },
            },
        },

        ['Dumpsters'] = {
            { coords = Vector(-254486.1, 36299.2, 188.8), heading = -170.6 },
            { coords = Vector(-254404.1, 35069.6, 182.8), heading = -174.0 },
            { coords = Vector(-254292.9, 33696.5, 182.8), heading = -174.0 },
        },
    },
}

return Config