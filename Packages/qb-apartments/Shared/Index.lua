Apartments = {}
Apartments.Starting = true
Apartments.SpawnOffset = -5000
Apartments.Locations = {
	apartment1 = {
		name = "apartment1",
		label = "Beachfront Apartments",
		coords = { 4795.2, 2856.7, -299.8 },
		polyzoneBoxData = {
			heading = 180,
			length = 0.01,
			width = 1.0,
			distance = 500.0,
			created = false,
		},
	},
	apartment2 = {
		name = "apartment2",
		label = "West End Apartments",
		coords = { -167.3, 15750.0, -293.8 },
		polyzoneBoxData = {
			heading = 90,
			length = 0.01,
			width = 1.0,
			distance = 500.0,
			created = false,
		},
	},
	apartment3 = {
		name = "apartment3",
		label = "West End Apartments 2",
		coords = { -6194.9, 13118.3, -299.9 },
		polyzoneBoxData = {
			heading = 180,
			length = 0.01,
			width = 1.0,
			distance = 500.0,
			created = false,
		},
	},
	apartment4 = {
		name = "apartment4",
		label = "West End Apartments 3",
		coords = { -6195.0, 10896.2, -299.8 },
		polyzoneBoxData = {
			heading = 180,
			length = 0.01,
			width = 1.0,
			distance = 500.0,
			created = false,
		},
	},
	apartment5 = {
		name = "apartment5",
		label = "East End Apartments",
		coords = { 2555.5, -15145.1, -299.9 },
		polyzoneBoxData = {
			heading = 90,
			length = 0.01,
			width = 1.0,
			distance = 500.0,
			created = false,
		},
	},
}

Package.Export("Apartments", Apartments)
