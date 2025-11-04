QBCore.Config.Language = 'en'

--QBCore.Config.MaxPlayers = GetConvarInt('sv_maxclients', 48) -- Gets max players from config file, default 48
QBCore.Config.DefaultSpawn = Vector(-5041.637236, 3194.286463, -315.849986)
QBCore.Config.UpdateInterval = 5    -- how often to update player data in minutes
QBCore.Config.StatusInterval = 5000 -- how often to check if hunger/thirst is empty in milliseconds

QBCore.Config.Money = {}
QBCore.Config.Money.MoneyTypes = { cash = 500, bank = 5000, crypto = 0 } -- type = startamount - Add or remove money types for your server (for ex. blackmoney = 0), remember once added it will not be removed from the database!
QBCore.Config.Money.DontAllowMinus = { 'cash', 'crypto' }                -- Money that is not allowed going in minus
QBCore.Config.Money.PayCheckTimeOut = 10                                 -- The time in minutes that it will give the paycheck
QBCore.Config.Money.PayCheckSociety = false                              -- If true paycheck will come from the society account that the player is employed at, requires qb-management

QBCore.Config.Player = {}
QBCore.Config.Player.HungerRate = 4.2 -- Rate at which hunger goes down.
QBCore.Config.Player.ThirstRate = 3.8 -- Rate at which thirst goes down.
QBCore.Config.Player.Bloodtypes = { 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-' }

QBCore.Config.StarterItems = {
	phone = 1,
	id_card = 1,
	driver_license = 1,
}

QBCore.Config.Server = {}                           -- General server config
QBCore.Config.Server.Closed = false                 -- Set server closed (no one can join except people with ace permission 'qbadmin.join')
QBCore.Config.Server.ClosedReason = 'Server Closed' -- Reason message to display when people can't join the server
QBCore.Config.Server.Uptime = 0                     -- Time the server has been up.
QBCore.Config.Server.Whitelist = false              -- Enable or disable whitelist on the server
QBCore.Config.Server.WhitelistPermission = 'admin'  -- Permission that's able to enter the server when the whitelist is on
QBCore.Config.Server.Discord = ''                   -- Discord invite link
QBCore.Config.Server.CheckDuplicateLicense = true   -- Check for duplicate account id on join
QBCore.Config.Server.Permissions = {                -- string for player account id found using GetAccountID()
	admin = {
		['c5da8bec-bc1e-4783-9ec6-52e7d7a571cb'] = true, -- example account identifier
	},
}

-- Configurable player data

QBCore.Config.Player.PlayerDefaults = {
	citizenid = function()
		return QBCore.Functions.CreateCitizenId()
	end,
	cid = 1,
	money = function()
		local moneyDefaults = {}
		for moneytype, startamount in pairs(QBCore.Config.Money.MoneyTypes) do
			moneyDefaults[moneytype] = startamount
		end
		return moneyDefaults
	end,
	optin = true,
	charinfo = {
		firstname = 'Firstname',
		lastname = 'Lastname',
		birthdate = '00-00-0000',
		gender = 0,
		nationality = 'USA',
		phone = function()
			return QBCore.Functions.CreatePhoneNumber()
		end,
		account = function()
			return QBCore.Functions.CreateAccountNumber()
		end,
	},
	job = {
		name = 'unemployed',
		label = 'Civilian',
		payment = 10,
		type = 'none',
		onduty = false,
		isboss = false,
		grade = {
			name = 'Freelancer',
			level = 1,
		},
	},
	gang = {
		name = 'none',
		label = 'No Gang Affiliation',
		isboss = false,
		grade = {
			name = 'none',
			level = 1,
		},
	},
	metadata = {
		hunger = 100,
		thirst = 100,
		stress = 0,
		isdead = false,
		inlaststand = false,
		armor = 0,
		ishandcuffed = false,
		tracker = false,
		injail = 0,
		jailitems = {},
		status = {},
		phone = {},
		rep = {},
		currentapartment = nil,
		callsign = 'NO CALLSIGN',
		bloodtype = function()
			return QBCore.Config.Player.Bloodtypes[math.random(1, #QBCore.Config.Player.Bloodtypes)]
		end,
		fingerprint = function()
			return QBCore.Functions.CreateFingerId()
		end,
		walletid = function()
			return QBCore.Functions.CreateWalletId()
		end,
		criminalrecord = {
			hasRecord = false,
			date = nil,
		},
		licences = {
			driver = true,
			business = false,
			weapon = false,
		},
		inside = {
			house = nil,
			apartment = {
				apartmentType = nil,
				apartmentId = nil,
			},
		},
		phonedata = {
			SerialNumber = function()
				return QBCore.Functions.CreateSerialNumber()
			end,
			InstalledApps = {},
		},
	},
	position = QBCore.Config.DefaultSpawn,
	items = {},
}
