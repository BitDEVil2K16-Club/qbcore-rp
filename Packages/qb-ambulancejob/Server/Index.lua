-- Handlers

HCharacter.Subscribe('Death', function(self, last_damage_taken, last_bone_damaged, damage_type_reason, hit_from_direction, instigator, causer)
    print('Death was called')
    print(self, last_damage_taken, last_bone_damaged, damage_type_reason, hit_from_direction, instigator, causer)
end)

HCharacter.Subscribe('TakeDamage', function(self, damage, bone, type, from_direction, instigator, causer)
    print('TakeDamage was called')
    print(self, damage, bone, type, from_direction, instigator, causer)
end)

HCharacter.Subscribe('Respawn', function(self)
    print('Respawn was called')
    print(self)
end)

HCharacter.Subscribe('HealthChange', function(self, old_health, new_health)
    print('HealthChange was called')
    print(self, old_health, new_health)
end)

-- HCharacter::ApplyDamage(damage, bone_name?, damage_type?, from_direction?, instigator?, causer?)
-- HCharacter:GetHealth() - both
-- HCharacter:GetMaxHealth() - both
-- HCharacter:Respawn(location?, rotation?)
-- HCharacter:SetHealth(new_health)
-- HCharacter:SetMaxHealth(new_max_health)

-- Functions

-- Events

Events.SubscribeRemote('qb-ambulancejob:server:KillPlayer', function(playerId)
    local ped = playerId:GetControlledCharacter()
    if not ped then return end
    ped:SetHealth(0)
end)

Events.SubscribeRemote('qb-ambulancejob:server:HealPlayer', function(playerId)
    local ped = playerId:GetControlledCharacter()
    if not ped then return end
    ped:SetHealth(ped:GetMaxHealth())
end)

-- Callbacks

-- Setup
