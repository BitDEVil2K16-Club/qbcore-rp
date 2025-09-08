-- -- Package.Subscribe('Unload', function()
-- --     if PSQL then
-- --         Console.Log('Closing database connection')
-- --         PSQL:Close()
-- --     end
-- -- end)

Database.Initialize('qbcore.db')

local success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        citizenid VARCHAR(11) NOT NULL UNIQUE,
        cid INTEGER DEFAULT NULL,
        license VARCHAR(255) NOT NULL,
        name VARCHAR(255) NOT NULL,
        money TEXT NOT NULL,
        charinfo TEXT DEFAULT NULL,
        job TEXT NOT NULL,
        gang TEXT DEFAULT NULL,
        position TEXT NOT NULL,
        metadata TEXT NOT NULL,
        inventory TEXT DEFAULT NULL,
        last_updated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_players_last_updated ON players(last_updated)]])
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_players_license ON players(license)]])

    Database.Execute([[
        CREATE TRIGGER IF NOT EXISTS trigger_players_last_updated
        AFTER UPDATE ON players
        FOR EACH ROW
        BEGIN
            UPDATE players SET last_updated = CURRENT_TIMESTAMP WHERE id = NEW.id;
        END
    ]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS apartments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(255) DEFAULT NULL,
        type VARCHAR(255) DEFAULT NULL,
        label VARCHAR(255) DEFAULT NULL,
        citizenid VARCHAR(11) DEFAULT NULL
    )
]])
if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_apartments_citizenid ON apartments(citizenid)]])
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_apartments_name ON apartments(name)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS bank_accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        citizenid VARCHAR(11) DEFAULT NULL,
        account_name VARCHAR(50) DEFAULT NULL,
        account_balance INTEGER NOT NULL DEFAULT 0,
        account_type VARCHAR(10) NOT NULL CHECK (account_type IN ('shared','job','gang')),
        users TEXT DEFAULT '[]',
        UNIQUE (account_name)
    )
]])

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS bank_statements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        citizenid VARCHAR(11) DEFAULT NULL,
        account_name VARCHAR(50) DEFAULT 'checking',
        amount INTEGER DEFAULT NULL,
        reason VARCHAR(50) DEFAULT NULL,
        statement_type VARCHAR(10) DEFAULT NULL CHECK (statement_type IN ('deposit','withdraw')),
        date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_bank_statements_citizenid ON bank_statements(citizenid)]])

    Database.Execute([[
        CREATE TRIGGER IF NOT EXISTS trigger_bank_statements_date_updated
        AFTER UPDATE ON bank_statements
        FOR EACH ROW
        BEGIN
            UPDATE bank_statements SET date = CURRENT_TIMESTAMP WHERE id = NEW.id;
        END
    ]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS bans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(50) DEFAULT NULL,
        license VARCHAR(50) DEFAULT NULL,
        discord VARCHAR(50) DEFAULT NULL,
        ip VARCHAR(50) DEFAULT NULL,
        reason TEXT DEFAULT NULL,
        expire INTEGER DEFAULT NULL,
        bannedby VARCHAR(255) NOT NULL DEFAULT 'LeBanhammer'
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_bans_license ON bans(license)]])
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_bans_discord ON bans(discord)]])
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_bans_ip ON bans(ip)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS crypto (
        crypto VARCHAR(50) NOT NULL DEFAULT 'qbit',
        worth INTEGER NOT NULL DEFAULT 0,
        history TEXT DEFAULT NULL,
        PRIMARY KEY (crypto)
    )
]])

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS crypto_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        citizenid VARCHAR(11) DEFAULT NULL,
        title VARCHAR(50) DEFAULT NULL,
        message VARCHAR(50) DEFAULT NULL,
        date DATETIME DEFAULT CURRENT_TIMESTAMP
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_crypto_transactions_citizenid ON crypto_transactions(citizenid)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS dealers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(50) NOT NULL DEFAULT '0',
        coords TEXT DEFAULT NULL,
        time TEXT DEFAULT NULL,
        createdby VARCHAR(50) NOT NULL DEFAULT '0'
    )
]])

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS houselocations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(255) DEFAULT NULL,
        label VARCHAR(255) DEFAULT NULL,
        coords TEXT DEFAULT NULL,
        owned INTEGER DEFAULT NULL,
        price INTEGER DEFAULT NULL,
        tier INTEGER DEFAULT NULL,
        garage TEXT DEFAULT NULL
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_houselocations_name ON houselocations(name)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS player_houses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        house VARCHAR(50) NOT NULL,
        identifier VARCHAR(50) DEFAULT NULL,
        citizenid VARCHAR(11) DEFAULT NULL,
        keyholders TEXT DEFAULT NULL,
        decorations TEXT DEFAULT NULL,
        stash TEXT DEFAULT NULL,
        outfit TEXT DEFAULT NULL,
        logout TEXT DEFAULT NULL
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_player_houses_house ON player_houses(house)]])
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_player_houses_citizenid ON player_houses(citizenid)]])
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_player_houses_identifier ON player_houses(identifier)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS house_plants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        building VARCHAR(50) DEFAULT NULL,
        stage INTEGER DEFAULT 1,
        sort VARCHAR(50) DEFAULT NULL,
        gender VARCHAR(50) DEFAULT NULL,
        food INTEGER DEFAULT 100,
        health INTEGER DEFAULT 100,
        progress INTEGER DEFAULT 0,
        coords TEXT DEFAULT NULL,
        plantid VARCHAR(50) DEFAULT NULL
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_house_plants_building ON house_plants(building)]])
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_house_plants_plantid ON house_plants(plantid)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS lapraces (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(50) DEFAULT NULL,
        checkpoints TEXT DEFAULT NULL,
        records TEXT DEFAULT NULL,
        creator VARCHAR(50) DEFAULT NULL,
        distance INTEGER DEFAULT NULL,
        raceid VARCHAR(50) DEFAULT NULL
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_lapraces_raceid ON lapraces(raceid)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS occasion_vehicles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        seller VARCHAR(50) DEFAULT NULL,
        price INTEGER DEFAULT NULL,
        description TEXT DEFAULT NULL,
        plate VARCHAR(50) DEFAULT NULL,
        model VARCHAR(50) DEFAULT NULL,
        mods TEXT DEFAULT NULL,
        occasionid VARCHAR(50) DEFAULT NULL
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_occasion_vehicles_occasionid ON occasion_vehicles(occasionid)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS phone_invoices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        citizenid VARCHAR(11) DEFAULT NULL,
        amount INTEGER NOT NULL DEFAULT 0,
        society TEXT DEFAULT NULL,
        sender VARCHAR(50) DEFAULT NULL,
        sendercitizenid VARCHAR(50) DEFAULT NULL
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_phone_invoices_citizenid ON phone_invoices(citizenid)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS phone_gallery (
        citizenid VARCHAR(11) NOT NULL,
        image VARCHAR(255) NOT NULL,
        date DATETIME DEFAULT CURRENT_TIMESTAMP
    )
]])

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS player_mails (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        citizenid VARCHAR(11) DEFAULT NULL,
        sender VARCHAR(50) DEFAULT NULL,
        subject VARCHAR(50) DEFAULT NULL,
        message TEXT DEFAULT NULL,
        read INTEGER DEFAULT 0,
        mailid INTEGER DEFAULT NULL,
        date DATETIME DEFAULT CURRENT_TIMESTAMP,
        button TEXT DEFAULT NULL
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_player_mails_citizenid ON player_mails(citizenid)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS phone_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        citizenid VARCHAR(11) DEFAULT NULL,
        number VARCHAR(50) DEFAULT NULL,
        messages TEXT DEFAULT NULL
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_phone_messages_citizenid ON phone_messages(citizenid)]])
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_phone_messages_number ON phone_messages(number)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS phone_tweets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        citizenid VARCHAR(11) DEFAULT NULL,
        firstName VARCHAR(25) DEFAULT NULL,
        lastName VARCHAR(25) DEFAULT NULL,
        message TEXT DEFAULT NULL,
        date DATETIME DEFAULT CURRENT_TIMESTAMP,
        url TEXT DEFAULT NULL,
        picture VARCHAR(512) DEFAULT './img/default.png',
        tweetId VARCHAR(25) NOT NULL
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_phone_tweets_citizenid ON phone_tweets(citizenid)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS player_contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        citizenid VARCHAR(11) DEFAULT NULL,
        name VARCHAR(50) DEFAULT NULL,
        number VARCHAR(50) DEFAULT NULL,
        iban VARCHAR(50) NOT NULL DEFAULT '0'
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_player_contacts_citizenid ON player_contacts(citizenid)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS playerskins (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        citizenid VARCHAR(11) NOT NULL,
        model VARCHAR(255) NOT NULL,
        skin TEXT NOT NULL,
        active INTEGER NOT NULL DEFAULT 1
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_playerskins_citizenid ON playerskins(citizenid)]])
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_playerskins_active ON playerskins(active)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS player_outfits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        citizenid VARCHAR(11) DEFAULT NULL,
        outfitname VARCHAR(50) NOT NULL,
        model VARCHAR(50) DEFAULT NULL,
        skin TEXT DEFAULT NULL,
        outfitId VARCHAR(50) NOT NULL
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_player_outfits_citizenid ON player_outfits(citizenid)]])
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_player_outfits_outfitId ON player_outfits(outfitId)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS player_vehicles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        license VARCHAR(50) DEFAULT NULL,
        citizenid VARCHAR(11) DEFAULT NULL,
        vehicle VARCHAR(50) DEFAULT NULL,
        hash VARCHAR(50) DEFAULT NULL,
        mods TEXT DEFAULT NULL,
        plate VARCHAR(8) NOT NULL,
        fakeplate VARCHAR(8) DEFAULT NULL,
        garage VARCHAR(50) DEFAULT NULL,
        fuel INTEGER DEFAULT 100,
        engine REAL DEFAULT 1000,
        body REAL DEFAULT 1000,
        state INTEGER DEFAULT 1,
        depotprice INTEGER NOT NULL DEFAULT 0,
        drivingdistance INTEGER DEFAULT NULL,
        status TEXT DEFAULT NULL,
        balance INTEGER NOT NULL DEFAULT 0,
        paymentamount INTEGER NOT NULL DEFAULT 0,
        paymentsleft INTEGER NOT NULL DEFAULT 0,
        financetime INTEGER NOT NULL DEFAULT 0
    )
]])

if success then
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_player_vehicles_plate ON player_vehicles(plate)]])
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_player_vehicles_citizenid ON player_vehicles(citizenid)]])
    Database.Execute([[CREATE INDEX IF NOT EXISTS idx_player_vehicles_license ON player_vehicles(license)]])
end

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS player_warns (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        senderIdentifier VARCHAR(50) DEFAULT NULL,
        targetIdentifier VARCHAR(50) DEFAULT NULL,
        reason TEXT DEFAULT NULL,
        warnId VARCHAR(50) DEFAULT NULL
    )
]])

success = Database.Execute([[
    CREATE TABLE IF NOT EXISTS inventories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        identifier VARCHAR(50) NOT NULL UNIQUE,
        items TEXT DEFAULT '[]'
    )
]])

MySQL = {
    query = {},
    insert = {},
    scalar = {},
    single = {},
    update = {},
    prepare = {},
    transaction = {},
}

-- Optional convenience to init Database from here.
function MySQL.init(path)
    Database.Initialize(path)
end

-- Normalize a single row from Database.Select into a plain name->value table.
local function normalizeRow(row)
    -- If Database returns rows like { Columns = { {Name=..., Value=...}, ... } }
    if row and row.Columns then
        local t = {}
        for _, c in ipairs(row.Columns) do
            t[c.Name] = c.Value
        end
        return t
    end
    -- Otherwise assume it's already a plain table.
    return row
end

-- Normalize an array of rows.
local function normalizeRows(rows)
    if not rows then return {} end
    if rows[1] and rows[1].Columns then
        local out = {}
        for i = 1, #rows do out[i] = normalizeRow(rows[i]) end
        return out
    end
    return rows
end

-- Convert MySQL-style params to SQLite/Database.lua shape.
-- Supports :named and ? placeholders. Produces '?' placeholders with ordered array params.
local function convertPlaceholders(query, params)
    params = params or {}
    local newParams = {}

    -- Very simple MySQL UPSERT shim -> SQLite.
    -- NOTE: hardcoded conflict target 'citizenid' to match your original snippet.
    query = query:gsub('ON DUPLICATE KEY UPDATE', 'ON CONFLICT (citizenid) DO UPDATE SET')

    if query:find(':%w+') then
        -- Named params: replace :name with ? and push params[name] in order encountered.
        query = query:gsub(':(%w+)', function(name)
            table.insert(newParams, params[name])
            return '?'
        end)
    else
        -- Positional '?': keep as-is; copy array values in order.
        if params[1] ~= nil then
            for i = 1, #params do newParams[i] = params[i] end
        else
            -- If a map slipped through, fall back to deterministic order by key name.
            for k, v in pairs(params) do
                table.insert(newParams, v)
            end
        end
    end

    return query, newParams
end

local function isSelect(query)
    return string.match(string.lower(query or ''), '^%s*select') ~= nil
end

-- Core executor: supports sync and async (callback) modes.
local function executeQuery(query, params, asyncCallback)
    local newQuery, newParams = convertPlaceholders(query, params)

    if asyncCallback then
        if isSelect(newQuery) then
            Database.SelectAsync(newQuery, newParams, function(rows, err)
                if err then
                    Console.Log('Async Select Error: ' .. tostring(err))
                    asyncCallback(nil, err)
                    return
                end
                asyncCallback(normalizeRows(rows))
            end)
        else
            Database.ExecuteAsync(newQuery, newParams, function(ok, err)
                if err or ok == false then
                    Console.Log('Async Execute Error: ' .. tostring(err or 'Execute failed'))
                    asyncCallback(nil, err or 'Execute failed')
                    return
                end
                -- Try to return affected rows count
                local count = nil
                local okc, val = pcall(function()
                    return Database.SelectValue and Database.SelectValue('SELECT changes()') or nil
                end)
                if okc then count = val end
                asyncCallback(count or true) -- legacy: return true if count unknown
            end)
        end
        return
    end

    -- Sync path
    if isSelect(newQuery) then
        local rows, err = Database.Select(newQuery, newParams)
        if err then
            Console.Log('Sync Select Error: ' .. tostring(err))
            return nil, err
        end
        return normalizeRows(rows)
    else
        local ok, err = Database.Execute(newQuery, newParams)
        if err or ok == false then
            Console.Log('Sync Execute Error: ' .. tostring(err or 'Execute failed'))
            return nil, err or 'Execute failed'
        end
        -- Return affected rows via SQLite changes()
        local count = nil
        local okc, val = pcall(function()
            return Database.SelectValue and Database.SelectValue('SELECT changes()') or nil
        end)
        if okc then count = val end
        return count or true
    end
end

-- === MySQL.query ===
setmetatable(MySQL.query, {
    __call = function(_, query, params, callback)
        executeQuery(query, params, callback)
    end,
})
function MySQL.query.await(query, params)
    return executeQuery(query, params)
end

-- === MySQL.insert (alias of exec) ===
setmetatable(MySQL.insert, {
    __call = function(_, query, params, callback)
        executeQuery(query, params, callback)
    end,
})
function MySQL.insert.await(query, params)
    return executeQuery(query, params)
end

-- === MySQL.scalar ===
setmetatable(MySQL.scalar, {
    __call = function(_, query, params, callback)
        executeQuery(query, params, function(rows, err)
            if err then
                callback(nil, err); return
            end
            local r = rows and rows[1] and normalizeRow(rows[1]) or nil
            if not r then
                callback(nil, nil); return
            end
            for _, v in pairs(r) do
                callback(v, nil); return
            end
            callback(nil, nil)
        end)
    end,
})
function MySQL.scalar.await(query, params)
    local rows, err = executeQuery(query, params)
    if err then return nil, err end
    local r = rows and rows[1] and normalizeRow(rows[1]) or nil
    if not r then return nil end
    for _, v in pairs(r) do return v end
    return nil
end

-- === MySQL.single ===
setmetatable(MySQL.single, {
    __call = function(_, query, params, callback)
        executeQuery(query, params, function(rows, err)
            if err then
                callback(nil, err); return
            end
            if rows and #rows > 0 then
                callback(rows[1], nil)
            else
                callback(nil, nil)
            end
        end)
    end,
})
function MySQL.single.await(query, params)
    local rows, err = executeQuery(query, params)
    if err then return nil, err end
    if rows and #rows > 0 then return rows[1] end
    return nil
end

-- === MySQL.update ===
setmetatable(MySQL.update, {
    __call = function(_, query, params, callback)
        executeQuery(query, params, function(result, err)
            if err then
                callback(nil, err); return
            end
            -- result is affected rows (number) or true
            callback(type(result) == 'number' and result or 0, nil)
        end)
    end,
})
function MySQL.update.await(query, params)
    local result, err = executeQuery(query, params)
    if err then return nil, err end
    return type(result) == 'number' and result or 0
end

-- === MySQL.prepare (no-op passthrough in this adapter) ===
setmetatable(MySQL.prepare, {
    __call = function(_, query, params, callback)
        -- We don't persist prepared statements; just execute.
        executeQuery(query, params, callback)
    end,
})
function MySQL.prepare.await(query, params)
    return executeQuery(query, params)
end

-- === MySQL.transaction ===
setmetatable(MySQL.transaction, {
    __call = function(_, queries, sharedValues, callback)
        -- Async transactional execution
        local function runAsync()
            Database.ExecuteAsync('BEGIN', {}, function(ok, err)
                if err or ok == false then
                    Console.Log('Failed to begin transaction: ' .. tostring(err or 'begin failed'))
                    callback(false); return
                end

                local i, n = 1, #queries
                local rolledBack = false

                local function rollback(reason)
                    if rolledBack then return end
                    rolledBack = true
                    Database.ExecuteAsync('ROLLBACK', {}, function()
                        Console.Log('Transaction failed: ' .. tostring(reason))
                        callback(false)
                    end)
                end

                local function step()
                    if rolledBack then return end
                    if i > n then
                        Database.ExecuteAsync('COMMIT', {}, function(ok2, err2)
                            if err2 or ok2 == false then
                                Console.Log('Failed to commit transaction: ' .. tostring(err2 or 'commit failed'))
                                callback(false)
                            else
                                callback(true)
                            end
                        end)
                        return
                    end

                    local q = queries[i]
                    local qsql, qparams
                    if type(q) == 'table' and q.query then
                        qsql, qparams = q.query, q.values
                    else
                        qsql, qparams = q, sharedValues
                    end

                    local sql2, params2 = convertPlaceholders(qsql, qparams or {})
                    Database.ExecuteAsync(sql2, params2, function(okx, errx)
                        if errx or okx == false then
                            rollback(errx or 'execute failed')
                            return
                        end
                        i = i + 1
                        step()
                    end)
                end

                step()
            end)
        end
        runAsync()
    end,
})

function MySQL.transaction.await(queries, sharedValues)
    local ok, err = Database.Execute('BEGIN', {})
    if err or ok == false then
        Console.Log('Failed to begin transaction: ' .. tostring(err or 'begin failed'))
        return false
    end

    for _, q in ipairs(queries) do
        local qsql, qparams
        if type(q) == 'table' and q.query then
            qsql, qparams = q.query, q.values
        else
            qsql, qparams = q, sharedValues
        end
        local sql2, params2 = convertPlaceholders(qsql, qparams or {})
        ok, err = Database.Execute(sql2, params2)
        if err or ok == false then
            Database.Execute('ROLLBACK', {})
            Console.Log('Transaction failed: ' .. tostring(err or 'execute failed'))
            return false
        end
    end

    ok, err = Database.Execute('COMMIT', {})
    if err or ok == false then
        Console.Log('Failed to commit transaction: ' .. tostring(err or 'commit failed'))
        return false
    end
    return true
end
