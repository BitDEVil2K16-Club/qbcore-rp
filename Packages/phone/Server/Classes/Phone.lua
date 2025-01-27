OngoingPhoneCalls = {}
ActivePhones = {}

Phone = {}
Phone.__index = Phone

local insert = table.insert
local time = os.time

function Phone:new(xPlayer, number)
    local s = {}
    s.number = number
    s.holder = xPlayer

    s.appsInstalled = {}
    s.messages = {}
    s.contacts = {}
    s.recentCalls = {}

    setmetatable(s, Phone)

    if number == nil then
        number = s:GenerateNumber()
    end

    ActivePhones[number] = s

    return s
end

function Phone:AddContact(number, firstName, lastName)
    firstName = firstName or 'Unknown'

    local data = {
        firstName = firstName,
        lastName = lastName or ''
    }

    self.contacts[number] = data

    print(NanosUtils.Dump(self.contacts))

    self.holder.call('pcrp-phone:AddContact', number, data)
end

function Phone:CreateGroupChat(participants, groupchatName)
    local id = 'gc_'
    local title = ''
    for k, v in ipairs(participants) do
        local x = s.contacts[v] and s.contacts[v].name or v
        id = id .. (v):sub(3, 6)
        title = title .. x .. ', '
    end

    title = (title):sub(1, #title - 2)

    local messageContents = {
        name = groupchatName or title,
        participants = participants,
        data = {}
    }

    local new_participants = participants
    insert(new_participants, self.number)

    for k, v in ipairs(new_participants) do
        local p = ActivePhones[v]

        p.messages[id] = {
            name = groupchatName or title,
            participants = participants,
            data = {}
        }

        p.holder.call('pcrp-phone:CreateGroupChat', p.messages)
    end

    return id
end

function Phone:DeleteConversation(conversation)
    if type(conversation) == 'table' then
        for k, v in pairs(conversation) do
            self:DeleteConversation(v)
        end
        return
    end


    self.messages[conversation] = nil
    self.holder.call('pcrp-phone:DeleteConversation', conversation)
end

function Phone:SendMessage(number, message)
    print('test 1')
    local gc_flag = false
    local participants

    if type(number) == 'table' then
        gc_flag = true

        insert(number, self.number)
        participants = number

        number = self:CreateGroupChat(number)
    end

    local messageData = {
        contact = self.number,
        message = message,
        time = time()
    }

    print('test 2')
    -- Add Message to targets phone
    if gc_flag then
        for k, v in ipairs(participants) do
            local tP = ActivePhones[v]
            if tP then
                insert(tP.messages[number].data, messageData)
                if tP.holder then
                    tP.holder.call('pcrp-phone:UpdateMessage', number, messageData)
                end
            end
        end

        return
    end


    print('test 3')
    -- local targetPhone = ActivePhones[number]

    -- if targetPhone == nil then
    --     return
    -- end

    participants = { number, self.number }

    -- print('test 4')
    for k, v in ipairs(participants) do
        local tP = ActivePhones[v]
        if tP then
            local nP = participants[k % 2 + 1] -- Gets the next participant

            print(nP)
            if tP.messages[nP] == nil then
                tP.messages[nP] = {
                    name = (tP.contacts and tP.contacts[nP] and tP.contacts[nP].label) or nP,
                    participants = { nP },
                    profilePicture = ''
                }
            end

            -- Message history already exists
            if tP.messages[nP].data == nil then
                tP.messages[nP].data = {}
            end

            insert(tP.messages[nP].data, messageData)
            if tP.holder then
                print('sending event => ', nP, messageData)
                tP.holder.call('pcrp-phone:UpdateMessage', nP, messageData)
            end
        end
    end
end

function Phone:GetApps()

end

function Phone:InstallApp()

end

function Phone:Answer()
    if OngoingPhoneCalls[self.number] == nil then return end -- reciever isnt recieving a call

    local transmitterNumber = OngoingPhoneCalls[self.number]

    if OngoingPhoneCalls[transmitterNumber] ~= self.number then return end -- the transmitter isnt calling the reciever

    local transmitterPhone = ActivePhones[transmitterNumber]
    local voipChannel = transmitterPhone.holder.source

    transmitterPhone.holder.player:SetVOIPSetting(VOIPSetting.Global)
    transmitterPhone.holder.player:SetVOIPChannel(voipChannel)

    self.holder.player:SetVOIPChannel(VOIPSetting.Global)
    self.holder.player:SetVOIPChannel(voipChannel)

    self.holder.call('pcrp-phone:AnswerCall', transmitterNumber)
    transmitterPhone.holder.call('pcrp-phone:AnswerCall', self.number)
end

function Phone:Hangup()
    if OngoingPhoneCalls[self.number] == nil then return end -- reciever isnt recieving a call

    local transmitterNumber = OngoingPhoneCalls[self.number]

    if OngoingPhoneCalls[transmitterNumber] ~= self.number then return end -- the transmitter isnt calling the reciever

    OngoingPhoneCalls[self.number] = nil
    OngoingPhoneCalls[transmitterNumber] = nil
end

function Phone:CallNumber(number)
    if ActivePhones[number] == nil then return end    -- Phone number does not exist

    if OngoingPhoneCalls[self.number] then return end -- Transmitter is sending a call / on a call
    if OngoingPhoneCalls[number] then return end      -- Receiver is recieving a call / on a call

    OngoingPhoneCalls[self.number] = number
    OngoingPhoneCalls[number] = self.number

    local callID = self.number .. ':' .. time()

    local recieverPhone = ActivePhones[number]

    local reciever = recieverPhone.holder

    if reciever then
        reciever.call('pcrp-phone:SendPhoneCall', self.number, callID, false)
        reciever.recentCalls[callID] = { callType = 'incoming', number = number, time = time() }
    end

    self.holder.call('pcrp-phone:SendPhoneCall', number, callID, true)
    self.recentCalls[callID] = { callType = 'outgoing', number = number, time = time() }

    return true
end

function Phone:UpdateContact(number, details)
    if self.contacts[number] == nil then return end

    self.contacts[number].firstName = details.firstName or self.contacts[number].firstName
    self.contacts[number].phoneNumber = details.phoneNumber or self.contacts[number].phoneNumber
    self.contacts[number].lastName = details.lastName or self.contacts[number].lastName
    self.contacts[number].notes = details.notes or self.contacts[number].notes
end

function Phone:GenerateNumber()
    local number = ''

    for i = 1, 10, 1 do
        number = number .. math.random(0, 9)
    end

    self.number = number

    return self.number
end

function Phone:GetNumber()
    return self.number
end

function Phone:SetNumber(number)
    self.number = number
end
