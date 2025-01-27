Config = Config or {}
Config.BillingCommissions = { -- This is a percentage (0.10) == 10%
    mechanic = 0.10
}

Config.CoreName = 'qb-core'          ---- qb-core
Config.HouseScriptName = 'qb-houses' --- qb-houses
Config.BossActionsScriptName = 'qb-management'
Config.RacingScriptName = 'qb-racing'
Config.GarageEvent = 'qb-garage:server:GetPlayerVehicles'
Config.CryptoScriptName = 'qb-crypto'
Config.PhoneItem = { 'phone', 'phone2' }
Config.JobsApp = { 'police', 'ambulance', 'mechanic', 'taxi' }                                                                                     ---- put name of job, like setjob
Config.JobsAppLabel = { 'Police', 'Ambulance', 'Mechanic', 'Uber' }                                                                                ---- put same order or this will not work properly
Config.Linux = false                                                                                                                               -- True if linux
Config.VoiceScript = 'pma'                                                                                                                         -- pma, mumble, salty, tokovoip
Config.WebHook = 'https://discord.com/api/webhooks/988854083966337075/TETrCxR-fFhQUeeJNvzDT68y3utfIismXQ24N2dFCvum_JFzY1ad9rHh_8BEhVXLwwdU'        -- photos
Config.WebHookTwitter = 'https://discord.com/api/webhooks/987830677699452978/A9BNM6YXLkQtUIGQaCZM92IdMK8U62hQsDC2kPrimz8oNxy5irwFI8HsJUlD2p71YOYe' -- twt
Config.TweetLogMessage = 'New tweet'
Config.WebHookOLX = 'https://discord.com/api/webhooks/987832181638447184/t1Ivnm5GlE9OnOZkZAtF_U3wwr4-tW7rfC_cAvGT2ynEQj7g5831DcbfsvLolz6dEtcD'     -- olx
Config.OLXLogMessage = 'New AD'
Config.TweetDuration = 48                                                                                                                          -- How many hours to load tweets
Config.OLXDuration = 72                                                                                                                            -- How many hours to load olx
Config.RepeatTimeout = 4000                                                                                                                        --- Depends of ringtone
Config.CallRepeats = 10                                                                                                                            --- Depends of ringtone
Config.OpenPhone = 244                                                                                                                             ---- to open phone
Config.PhoneApplications = {                                                                                                                       ---- automatically by code (leave like this)

}
Config.MaxSlots = 30

Config.StoreApps = {
    ['droga'] = {
        app = 'droga',
        color = 'transparent',
        icon = 'workspace.png',
        tooltipText = 'Drugs',
        tooltipPos = 'right',
        job = { 'vagos', 'bloods', 'groove', 'ballas' },
        slot = 1, ---- store apps dont need to change slots
        Alerts = 0,
        creator = 'Anonymous',
        title = 'Drugs',
        avaliacao = '<i class="fa-solid fa-star"></i>'
    },
    ['twitter'] = {
        app = 'twitter',
        color = 'transparent',
        icon = 'twitter.png',
        tooltipText = 'Twitter',
        tooltipPos = 'top',
        job = {},
        slot = 2,
        Alerts = 0,
        creator = 'Twitter, Inc.',
        title = 'Twitter',
        avaliacao = '<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star-half-stroke"></i>'
    },
    ['garage'] = {
        app = 'garage',
        color = 'transparent',
        icon = 'garagem.png',
        tooltipText = 'Garage',
        job = {},
        slot = 3,
        Alerts = 0,
        creator = 'Via Verde, Inc.',
        title = 'Garage',
        avaliacao = '<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>'
    },
    ['mail'] = {
        app = 'mail',
        color = 'transparent',
        icon = 'mail.png',
        tooltipText = 'Mail',
        job = {},
        slot = 4,
        Alerts = 0,
        creator = 'Microsoft Corporation',
        title = 'Mail',
        avaliacao = '<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>'
    },
    ['advert'] = {
        app = 'advert',
        color = 'transparent',
        icon = 'olx.png',
        tooltipText = 'OLX',
        job = {},
        slot = 5,
        Alerts = 0,
        creator = 'OLX Portugal SA',
        title = 'OLX',
        avaliacao = '<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star-half-stroke"></i>'
    },
    ['bank'] = {
        app = 'bank',
        color = 'transparent',
        icon = 'wallet.png',
        tooltipText = 'Bank',
        job = {},
        slot = 6,
        Alerts = 0,
        creator = 'JPR',
        title = 'Bank',
        avaliacao = '<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star-half-stroke"></i>'
    },
    ['crypto'] = {
        app = 'crypto',
        color = 'transparent',
        icon = 'stocks.png',
        tooltipText = 'Crypto',
        job = {},

        slot = 7,
        Alerts = 0,
        creator = 'JPR',
        title = 'Crypto',
        avaliacao = '<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>'
    },
    ['racing'] = {
        app = 'racing',
        color = 'transparent',
        icon = 'corrida.png',
        tooltipText = 'Racing',
        job = {},
        slot = 8,
        Alerts = 0,
        creator = 'Lambra, LDA',
        title = 'Racing',
        avaliacao = '<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>'
    },
    ['houses'] = {
        app = 'houses',
        color = 'transparent',
        icon = 'home.png',
        tooltipText = 'Home',
        job = {},
        slot = 9,
        Alerts = 0,
        creator = 'Nino imóveis, LDA',
        title = 'Home',
        avaliacao = '<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star-half-stroke"></i>'
    },
    ['meos'] = {
        app = 'meos',
        color = 'transparent',
        icon = 'meos.png',
        tooltipText = 'MDT',
        job = { 'police' },
        slot = 10,
        Alerts = 0,
        creator = 'JPR',
        title = 'MDT',
        avaliacao = '<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star-half-stroke"></i>'
    },
    ['youtube'] = {
        app = 'youtube',
        color = 'transparent',
        icon = 'youtube.png',
        tooltipText = 'Youtube',
        job = {},
        slot = 11,
        Alerts = 0,
        creator = 'Google LLC',
        title = 'Youtube',
        avaliacao = '<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star-half-stroke"></i>'
    },

    ['jogos'] = {
        app = 'jogos',
        color = 'transparent',
        icon = 'playjogos.png',
        tooltipText = 'Games',
        job = {},
        slot = 11,
        Alerts = 0,
        creator = 'Google LLC',
        title = 'Games',
        avaliacao = '<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star-half-stroke"></i>'
    },

    ['calculator'] = {
        app = 'calculator',
        color = 'transparent',
        icon = 'calculator.png',
        tooltipText = 'Calcs',
        job = {},
        slot = 12,
        Alerts = 0,
        creator = 'IOS',
        title = 'Calcs',
        avaliacao = '<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>'
    },

}

Config.InicialApps = {
    ['phone'] = {
        app = 'phone',
        color = 'transparent', ---- leave this transparent
        icon = 'phone.png',
        tooltipText = 'Phone',
        tooltipPos = 'top',
        job = {},
        slot = 1,
        Alerts = 0,
    },
    ['whatsapp'] = {
        app = 'whatsapp',
        color = 'transparent',
        icon = 'whatsapp.png',
        tooltipText = 'Whatsapp',
        tooltipPos = 'top',
        style = 'font-size: 2.8vh',
        job = {},
        slot = 2,
        Alerts = 0,
    },
    ['settings'] = {
        app = 'settings',
        color = 'transparent',
        icon = 'settings.png',
        tooltipText = 'Settings',
        tooltipPos = 'top',
        style = 'padding-right: .08vh; font-size: 2.3vh',
        job = {},
        slot = 3,
        Alerts = 0,
    },

    ['lawyers'] = {
        app = 'lawyers',
        color = 'transparent',
        icon = 'contacts.png',
        tooltipText = 'Services',
        tooltipPos = 'bottom',
        job = {},
        slot = 4,
        Alerts = 0,
    },
    ['gallery'] = {
        app = 'gallery',
        color = 'transparent',
        icon = 'photos.png',
        tooltipText = 'Gallery',
        tooltipPos = 'bottom',
        job = {},
        slot = 5,
        Alerts = 0,
    },
    ['camera'] = {
        app = 'camera',
        color = 'transparent',
        icon = 'camera.png',
        tooltipText = 'Camera',
        tooltipPos = 'bottom',
        job = {},
        slot = 6,
        Alerts = 0,
    },

    ['store'] = {
        app = 'store',
        color = 'transparent',
        icon = 'appstore.png',
        tooltipText = 'AppStore',
        tooltipPos = 'bottom',
        job = {},
        slot = 7,
        Alerts = 0,
    },
}


Config.NotifyTranslations = { ----------- Basic logs translations
    Notify = {
        Notify1 = "You don't have a cell phone", ----- notify text
        Notify2 = 'Phone', ----- notify text
        Notify3 = 'Call Terminated', ----- notify text
        Notify4 = "You don't have a pending call...", ----- notify text
        Notify5 = "You can't access the phone now....", ----- notify text
        Notify6 = 'Open Phone', ----- notify text
        Notify7 = 'Loc. gps!', ----- notify text
        Notify8 = 'Garage', ----- notify text
        Notify9 = 'Your vehicle is in the GPS!', ----- notify text
        Notify10 = 'Tracking of this vehicle is unavailable', ----- notify text
        Notify11 = 'Contact deleted!', ----- notify text
        Notify12 = 'GPS: ', ----- notify text
        Notify13 = 'Unknown', ----- notify text
        Notify14 = 'You are too far away. GPS of the race sent.', ----- notify text
        Notify15 = 'GPS sent!', ----- notify text
        Notify16 = 'Settings', ----- notify text
        Notify17 = 'Unknown account!', ----- notify text
        Notify18 = 'Bank', ----- notify text
        Notify19 = 'has been added to your account!', ----- notify text
        Notify20 = 'New Tweet', ----- notify text
        Notify21 = 'New post on twitter.', ----- notify text
        Notify22 = 'The Tweet has been deleted!', ----- notify text
        Notify23 = 'New Ad', ----- notify text
        Notify24 = 'New post on olx.', ----- notify text
        Notify25 = 'OLX', ----- notify text
        Notify26 = 'The ad has been deleted!', ----- notify text
        Notify27 = 'Races', ----- notify text
        Notify28 = 'You received a new email from', ----- notify text
        Notify29 = 'Mail', ----- notify text
        Notify30 = 'A new AD published', ----- notify text
        Notify31 = 'Call terminated.', ----- notify text
        Notify32 = 'New message from ', ----- notify text
        Notify33 = 'For yourself !?', ----- notify text
        Notify34 = 'New message in the group: ', ----- notify text
        Notify35 = 'Added to the group: ', ----- notify text
        Notify36 = '€ have been removed from your account!', ----- notify text
        Notify37 = 'New contact suggestion!', ----- notify text
        Notify38 = 'You have no outstanding calls...', ----- notify text
        Notify39 = 'Nobody close!', ----- notify text
        Notify40 = 'You were mentioned in a tweet!', ----- notify text
        Notify41 = 'Finance', ----- notify text
        Notify42 = 'Commission received', ----- notify text
        Notify43 = 'You received a commission from %s € when %s %s paid the invoice for %s €.', ----- notify text
        Notify44 = 'Invoice paid', ----- notify text
        Notify45 = '%s %s paid an invoice for %s €', ----- notify text
        Notify46 = 'Unknown brand..', ----- notify text
        Notify47 = 'Name not found..', ----- notify text
        Notify48 = 'No vehicles nearby', ----- notify text
        Notify49 = "This account number doesn't exist!", ----- notify text
        Notify50 = 'Welcome to your new group!', ----- notify text
    },
}
