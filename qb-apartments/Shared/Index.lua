Apartments = {}
Apartments.Starting = true
Apartments.SpawnOffset = -20000
Apartments.Locations = {
	apartment1 = {
		name = 'apartment1',
		label = 'Southside Apartments',
		coords = { -249.54, 1358.93, 91.697 },
		polyzoneBoxData = {
			heading = 180,
			length = 0.01,
			width = 1.0,
			distance = 200.0,
			created = false,
		},
	},
	apartment2 = {
		name = 'apartment2',
		label = 'West End Apartments',
		coords = { -249.54, -2463.590, 91.697 },
		polyzoneBoxData = {
			heading = 90,
			length = 0.01,
			width = 1.0,
			distance = 200.0,
			created = false,
		},
	},
}

exports('qb-apartments', 'Apartments', function()
	return Apartments
end)
