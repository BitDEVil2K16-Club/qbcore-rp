Config = {

    Jobs = {
        ['trucker'] = { ['label'] = 'Trucker', ['isManaged'] = false },
        ['taxi'] = { ['label'] = 'Taxi', ['isManaged'] = false },
        ['tow'] = { ['label'] = 'Tow Truck', ['isManaged'] = false },
        ['reporter'] = { ['label'] = 'News Reporter', ['isManaged'] = false },
        ['garbage'] = { ['label'] = 'Garbage Collector', ['isManaged'] = false },
        ['bus'] = { ['label'] = 'Bus Driver', ['isManaged'] = false },
        ['hotdog'] = { ['label'] = 'Hot Dog Stand', ['isManaged'] = false }
    },

    Locations = {
        {
            coords = { Vector(-50194.7, 38451.2, 215.0), Rotator(0.0, 180.00004577637, 0.0) },
            showBlip = true,
            blipData = {
                sprite = 487,
                display = 4,
                scale = 0.65,
                colour = 0,
                title = 'City Services'
            },
            licenses = {
                ['id_card'] = {
                    label = 'ID Card',
                    cost = 50,
                },
                ['driver_license'] = {
                    label = 'Driver License',
                    cost = 50,
                    metadata = 'driver'
                },
                ['weapon_license'] = {
                    label = 'Weapon License',
                    cost = 50,
                    metadata = 'weapon'
                },
            }
        }
    }
}

return Config
