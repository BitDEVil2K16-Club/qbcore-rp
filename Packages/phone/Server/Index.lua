-- Require the Phone class
Package.Require('Server/Classes/Phone.lua')

-- Phone applications definition
local PhoneApps = {
	messages = {
		name = 'Messages',
		defaultApp = true,
		size = 126,
		args = { keepBackground = true },
	},
	camera = {
		name = 'Camera',
		defaultApp = true,
		size = 126,
	},
	contacts = {
		name = 'Contacts',
		defaultApp = true,
		size = 126,
	},
	photos = {
		name = 'Photos',
		defaultApp = true,
		size = 126,
	},
	bank = {
		name = 'Bank',
		defaultApp = true,
		size = 126,
		blocked = true,
	},
	calculator = {
		name = 'Calculator',
		defaultApp = true,
		size = 126,
		blocked = true,
	},
	mail = {
		name = 'Mail',
		defaultApp = true,
		size = 126,
		blocked = true,
	},
	settings = {
		name = 'Settings',
		defaultApp = true,
		size = 126,
		blocked = true,
	},
	calling = {
		name = 'Calling',
		defaultApp = true,
		size = 126,
		utility = true,
		hide = true,
	},
	prompt = {
		name = 'Prompt',
		defaultApp = true,
		size = 126,
		utility = true,
		hide = true,
	},
}

-- When the player is ready, assign them a phone
Player.Subscribe('Ready', function(player)
	local phone = Phone:new(player, 15151)
	Events.CallRemote('pcrp-phone:SetupPhone', player, phone, PhoneApps)
end)

-- Handle animation execution from the client
Events.SubscribeRemote('pcrp-phone:ExecuteAnimation', function(player, animation, upperBodyOnly, loop)
	print('Executing animation:', animation)
	local slot_type = upperBodyOnly and AnimationSlotType.UpperBody or AnimationSlotType.FullBody
	local character = player:GetControlledCharacter()
	character:PlayAnimation(animation, slot_type, loop)

	if animation == 'ffcce-phone-anims::ply_take_phone_out' then
		local phoneProp = Prop(
			character:GetLocation(),
			character:GetRotation(),
			'helix-iyoshko-mobile-phone::SM_Phone_C',
			1,
			false,
			0,
			CCDMode.Disabled
		)
		phoneProp:AttachTo(character, 2, 'hand_r')
		phoneProp:SetScale(Vector(1.0, 1.0, 1.0))
		phoneProp:SetRelativeLocation(Vector(-9.7, 1.6, 0.9))
		phoneProp:SetRelativeRotation(Rotator(30.0, 0.9, 9.4))
	elseif animation == 'ffcce-phone-anims::ply_putting_phone_away' then
		print('Storing phone')
		Timer.SetTimeout(function()
			local attachedEntities = character:GetAttachedEntities()
			for _, entity in ipairs(attachedEntities) do
				if entity:IsA(Prop) and entity:GetMesh() == 'helix-iyoshko-mobile-phone::SM_Phone_C' then
					entity:Destroy()
					print('Phone destroyed')
				end
			end
		end, 1600)
	end
end)

-- Handle animation stopping
Events.SubscribeRemote('pcrp-phone:StopAnimation', function(player, animation)
	print('Stopping animation:', animation)
	player:GetControlledCharacter():StopAnimation(animation)
end)

-- Initialize phones for all players when server loads
Package.Subscribe('Load', function()
	local allPlayers = Player.GetAll()
	for _, player in ipairs(allPlayers) do
		local phone = Phone:new(player, 151515)
		Events.CallRemote('pcrp-phone:SetupPhone', player, phone, PhoneApps)
	end
end)
