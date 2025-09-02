CREATE TABLE IF NOT EXISTS apartments (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) DEFAULT NULL,
  type VARCHAR(255) DEFAULT NULL,
  label VARCHAR(255) DEFAULT NULL,
  citizenid VARCHAR(11) DEFAULT NULL
);

CREATE INDEX idx_apartments_citizenid ON apartments (citizenid);
CREATE INDEX idx_apartments_name ON apartments (name);

CREATE TABLE IF NOT EXISTS bank_accounts (
  id SERIAL PRIMARY KEY,
  citizenid VARCHAR(11) DEFAULT NULL,
  account_name VARCHAR(50) UNIQUE,
  account_balance INT NOT NULL DEFAULT 0,
  account_type VARCHAR(10) CHECK (account_type IN ('shared', 'job', 'gang')),
  users TEXT DEFAULT '[]'
);

CREATE TABLE IF NOT EXISTS bank_statements (
  id SERIAL PRIMARY KEY,
  citizenid VARCHAR(11) DEFAULT NULL,
  account_name VARCHAR(50) DEFAULT 'checking',
  amount INT DEFAULT NULL,
  reason VARCHAR(50) DEFAULT NULL,
  statement_type VARCHAR(10) CHECK (statement_type IN ('deposit', 'withdraw')),
  date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_bank_statements_citizenid ON bank_statements (citizenid);

CREATE OR REPLACE FUNCTION update_date_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.date = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER bank_statements_update_date_trigger
BEFORE UPDATE ON bank_statements
FOR EACH ROW
EXECUTE FUNCTION update_date_column();

CREATE TABLE IF NOT EXISTS bans (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) DEFAULT NULL,
  license VARCHAR(50) DEFAULT NULL,
  discord VARCHAR(50) DEFAULT NULL,
  ip VARCHAR(50) DEFAULT NULL,
  reason TEXT DEFAULT NULL,
  expire INT DEFAULT NULL,
  bannedby VARCHAR(255) NOT NULL DEFAULT 'LeBanhammer'
);

CREATE INDEX idx_bans_license ON bans (license);
CREATE INDEX idx_bans_discord ON bans (discord);
CREATE INDEX idx_bans_ip ON bans (ip);

CREATE TABLE IF NOT EXISTS crypto (
  crypto VARCHAR(50) PRIMARY KEY DEFAULT 'qbit',
  worth INT NOT NULL DEFAULT 0,
  history TEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS crypto_transactions (
  id SERIAL PRIMARY KEY,
  citizenid VARCHAR(11) DEFAULT NULL,
  title VARCHAR(50) DEFAULT NULL,
  message VARCHAR(50) DEFAULT NULL,
  date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_crypto_transactions_citizenid ON crypto_transactions (citizenid);

CREATE TABLE IF NOT EXISTS dealers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL DEFAULT '0',
  coords TEXT DEFAULT NULL,
  time TEXT DEFAULT NULL,
  createdby VARCHAR(50) NOT NULL DEFAULT '0'
);

CREATE TABLE IF NOT EXISTS houselocations (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) DEFAULT NULL,
  label VARCHAR(255) DEFAULT NULL,
  coords TEXT DEFAULT NULL,
  owned BOOLEAN DEFAULT NULL,
  price INT DEFAULT NULL,
  tier SMALLINT DEFAULT NULL,
  garage TEXT DEFAULT NULL
);

CREATE INDEX idx_houselocations_name ON houselocations (name);

CREATE TABLE IF NOT EXISTS inventories (
  id SERIAL,
  identifier VARCHAR(50) NOT NULL PRIMARY KEY,
  items TEXT DEFAULT '[]'
);

CREATE TABLE IF NOT EXISTS player_houses (
  id SERIAL PRIMARY KEY,
  house VARCHAR(50) NOT NULL,
  identifier VARCHAR(50) DEFAULT NULL,
  citizenid VARCHAR(11) DEFAULT NULL,
  keyholders TEXT DEFAULT NULL,
  decorations TEXT DEFAULT NULL,
  stash TEXT DEFAULT NULL,
  outfit TEXT DEFAULT NULL,
  logout TEXT DEFAULT NULL
);

CREATE INDEX idx_player_houses_house ON player_houses (house);
CREATE INDEX idx_player_houses_citizenid ON player_houses (citizenid);
CREATE INDEX idx_player_houses_identifier ON player_houses (identifier);

CREATE TABLE IF NOT EXISTS house_plants (
  id SERIAL PRIMARY KEY,
  building VARCHAR(50) DEFAULT NULL,
  stage INT DEFAULT 1,
  sort VARCHAR(50) DEFAULT NULL,
  gender VARCHAR(50) DEFAULT NULL,
  food INT DEFAULT 100,
  health INT DEFAULT 100,
  progress INT DEFAULT 0,
  coords TEXT DEFAULT NULL,
  plantid VARCHAR(50) DEFAULT NULL
);

CREATE INDEX idx_house_plants_building ON house_plants (building);
CREATE INDEX idx_house_plants_plantid ON house_plants (plantid);

CREATE TABLE IF NOT EXISTS lapraces (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) DEFAULT NULL,
  checkpoints TEXT DEFAULT NULL,
  records TEXT DEFAULT NULL,
  creator VARCHAR(50) DEFAULT NULL,
  distance INT DEFAULT NULL,
  raceid VARCHAR(50) DEFAULT NULL
);

CREATE INDEX idx_lapraces_raceid ON lapraces (raceid);

CREATE TABLE IF NOT EXISTS occasion_vehicles (
  id SERIAL PRIMARY KEY,
  seller VARCHAR(50) DEFAULT NULL,
  price INT DEFAULT NULL,
  description TEXT DEFAULT NULL,
  plate VARCHAR(50) DEFAULT NULL,
  model VARCHAR(50) DEFAULT NULL,
  mods TEXT DEFAULT NULL,
  occasionid VARCHAR(50) DEFAULT NULL
);

CREATE INDEX idx_occasion_vehicles_occasionid ON occasion_vehicles (occasionid);

CREATE TABLE IF NOT EXISTS phone_invoices (
  id SERIAL PRIMARY KEY,
  citizenid VARCHAR(11) DEFAULT NULL,
  amount INT NOT NULL DEFAULT 0,
  society TEXT DEFAULT NULL,
  sender VARCHAR(50) DEFAULT NULL,
  sendercitizenid VARCHAR(50) DEFAULT NULL
);

CREATE INDEX idx_phone_invoices_citizenid ON phone_invoices (citizenid);

CREATE TABLE IF NOT EXISTS phone_gallery (
   citizenid VARCHAR(11) NOT NULL,
   image VARCHAR(255) NOT NULL,
   date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS player_mails (
  id SERIAL PRIMARY KEY,
  citizenid VARCHAR(11) DEFAULT NULL,
  sender VARCHAR(50) DEFAULT NULL,
  subject VARCHAR(50) DEFAULT NULL,
  message TEXT DEFAULT NULL,
  read SMALLINT DEFAULT 0,
  mailid INT DEFAULT NULL,
  date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  button TEXT DEFAULT NULL
);

CREATE INDEX idx_player_mails_citizenid ON player_mails (citizenid);

CREATE TABLE IF NOT EXISTS phone_messages (
  id SERIAL PRIMARY KEY,
  citizenid VARCHAR(11) DEFAULT NULL,
  number VARCHAR(50) DEFAULT NULL,
  messages TEXT DEFAULT NULL
);

CREATE INDEX idx_phone_messages_citizenid ON phone_messages (citizenid);
CREATE INDEX idx_phone_messages_number ON phone_messages (number);

CREATE TABLE IF NOT EXISTS phone_tweets (
  id SERIAL PRIMARY KEY,
  citizenid VARCHAR(11) DEFAULT NULL,
  firstName VARCHAR(25) DEFAULT NULL,
  lastName VARCHAR(25) DEFAULT NULL,
  message TEXT DEFAULT NULL,
  date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  url TEXT DEFAULT NULL,
  picture VARCHAR(512) DEFAULT './img/default.png',
  tweetId VARCHAR(25) NOT NULL
);

CREATE INDEX idx_phone_tweets_citizenid ON phone_tweets (citizenid);

CREATE TABLE IF NOT EXISTS player_contacts (
  id SERIAL PRIMARY KEY,
  citizenid VARCHAR(11) DEFAULT NULL,
  name VARCHAR(50) DEFAULT NULL,
  number VARCHAR(50) DEFAULT NULL,
  iban VARCHAR(50) NOT NULL DEFAULT '0'
);

CREATE INDEX idx_player_contacts_citizenid ON player_contacts (citizenid);

CREATE TABLE IF NOT EXISTS players (
  id SERIAL PRIMARY KEY,
  citizenid VARCHAR(11) NOT NULL UNIQUE,
  cid INT DEFAULT NULL,
  license VARCHAR(100) NOT NULL,
  name VARCHAR(50) NOT NULL,
  money TEXT NOT NULL,
  charinfo TEXT DEFAULT NULL,
  job TEXT NOT NULL,
  gang TEXT DEFAULT NULL,
  position TEXT NOT NULL,
  metadata TEXT NOT NULL,
  inventory TEXT DEFAULT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_players_last_updated ON players (last_updated);
CREATE INDEX idx_players_license ON players (license);

CREATE OR REPLACE FUNCTION update_last_updated_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.last_updated = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER players_update_last_updated_trigger
BEFORE UPDATE ON players
FOR EACH ROW
EXECUTE FUNCTION update_last_updated_column();


CREATE TABLE IF NOT EXISTS playerskins (
  id SERIAL PRIMARY KEY,
  citizenid VARCHAR(11) NOT NULL,
  model VARCHAR(255) NOT NULL,
  skin TEXT NOT NULL,
  active SMALLINT NOT NULL DEFAULT 1
);

CREATE INDEX idx_playerskins_citizenid ON playerskins (citizenid);
CREATE INDEX idx_playerskins_active ON playerskins (active);

CREATE TABLE IF NOT EXISTS player_outfits (
  id SERIAL PRIMARY KEY,
  citizenid VARCHAR(11) DEFAULT NULL,
  outfitname VARCHAR(50) NOT NULL,
  model VARCHAR(50) DEFAULT NULL,
  skin TEXT DEFAULT NULL,
  outfitId VARCHAR(50) NOT NULL
);

CREATE INDEX idx_player_outfits_citizenid ON player_outfits (citizenid);
CREATE INDEX idx_player_outfits_outfitId ON player_outfits (outfitId);

CREATE TABLE IF NOT EXISTS player_vehicles (
  id SERIAL PRIMARY KEY,
  license VARCHAR(50) DEFAULT NULL,
  citizenid VARCHAR(11) DEFAULT NULL,
  vehicle VARCHAR(50) DEFAULT NULL,
  hash VARCHAR(50) DEFAULT NULL,
  mods TEXT DEFAULT NULL,
  plate VARCHAR(8) NOT NULL,
  fakeplate VARCHAR(8) DEFAULT NULL,
  garage VARCHAR(50) DEFAULT NULL,
  fuel INT DEFAULT 100,
  engine FLOAT DEFAULT 1000,
  body FLOAT DEFAULT 1000,
  state INT DEFAULT 1,
  depotprice INT NOT NULL DEFAULT 0,
  drivingdistance INT DEFAULT NULL,
  status TEXT DEFAULT NULL,
  balance INT NOT NULL DEFAULT 0,
  paymentamount INT NOT NULL DEFAULT 0,
  paymentsleft INT NOT NULL DEFAULT 0,
  financetime INT NOT NULL DEFAULT 0
);

CREATE INDEX idx_player_vehicles_plate ON player_vehicles (plate);
CREATE INDEX idx_player_vehicles_citizenid ON player_vehicles (citizenid);
CREATE INDEX idx_player_vehicles_license ON player_vehicles (license);

CREATE TABLE IF NOT EXISTS player_warns (
  id SERIAL PRIMARY KEY,
  senderIdentifier VARCHAR(50) DEFAULT NULL,
  targetIdentifier VARCHAR(50) DEFAULT NULL,
  reason TEXT DEFAULT NULL,
  warnId VARCHAR(50) DEFAULT NULL
);