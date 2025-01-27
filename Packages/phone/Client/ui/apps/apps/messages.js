var writeInput = $('.write-input input');
var searchBar = $('.search-bar input');

let messages = $('.opened-chat .content')
let sendButton = $('.write-input .send')
let backToChatsButton = $('.opened-chat img.back')

let isDragging = false
let startY
let scrollTop

let chatsData = null
let messagesData = null


var phoneData = null
var currentConversation = null
var newConversationContact = null

var currentState
var animatingDelete = false
var pendingChatDeletings = []

var PhoneState = {
    InMessages: 1,
    InChatHistory: 2,
    InNewConversation: 3
}

var ConversationElements = {
    Input: $('.opened-chat .actions input'),
    SendButton: $('.opened-chat .actions button.send')
}

var NewConversationElements = {
    Input: $('.new-chat > div.actions > div > input[type=text]')
}

currentState = PhoneState.InChatHistory
// Ran when the app opens up, use this to get elements on DOM
const OnAppStart = (e, args) => {
    $('.chats').empty();

    phoneData = e.data.phoneData

    $('.new-chat, .opened-chat, .chats').css('--bg', `url(../${phoneData.phoneBackground})`)

    Object.entries(phoneData.messages).forEach(([key, val]) => {
        CreateConversation(val, key)
    })
    
    if (args.target)
    {
        ShowChatHistory(args.target)
    }
}

// Ran when the app is closed
const OnAppClose = (e, args) => {
}

const OnAppUpdate = (phoneData, data) => {
    if (data.action == 'UPDATE_MESSAGE') {
        phoneData.messages = data.conversations
        
        $('.chats').empty();

        Object.entries(phoneData.messages).forEach(([key, val]) => {
            CreateConversation(val, key)
        })

        if (currentConversation)
            ShowChatHistory(currentConversation)
    }
}

function CreateConversation(data, id) {
    var latestMessage = data.data[data.data.length - 1]
    var [time, amPM] = ConvertTimestamp(latestMessage.time)
    var template = $(`
        <div class="chat" data-id="${id}">
            <img src="../img/apps/messages/delete.png" alt="" class="delete">
            <div class="image">
                <img src="https://es.web.img2.acsta.net/img/13/0e/130ef5c860d21d4f7eb16627dcfd6d1d.jpeg" alt="">
                <span class="not-readed-msj">0</span>
            </div>
            <div class="content">
                <div class="header">
                    <h1 class="name">${data.name}</h1>
                    <p class="time"><span>${time}${amPM}</span></p>
                </div>
                <p class="spoiler">
                    ${latestMessage.message}
                </p>
            </div>
            <img src="../img/apps/messages/arrow-right.png" alt="" class="arrow-right">
        </div>
    `)

    template.data('id', id)
    $('.chats').append(template)
}

function ConvertTimestamp(time) {
    var date = new Date(parseInt(time) * 1000);

    var hour = date.getHours();
    var minute = date.getMinutes();
    var amPM = hour < 12 ? "AM" : "PM"; // determine AM or PM suffix
    hour = hour % 12 || 12; // convert hour to 12-hour format

    return [`${hour}:${minute}`, amPM]
}

function ShowChatHistory(id) {
    var animateChat = currentState == PhoneState.InMessages

    $('.opened-chat .content').empty()

    if (currentState !== PhoneState.InMessages)
    {
        $('.opened-chat').addClass('active')
        $('.chats, .messages-app > .header, .search-bar').fadeOut()
        $('.opened-chat .header .contact .name').text(phoneData?.messages[id]?.name || id)        
    }

    currentConversation = id;
    currentState = PhoneState.InMessages

    console.log("SHOW CHAT HISTORY =>", id)

    // $('.opened-chat .content').scrollTop($('.opened-chat .content')[0].scrollHeight)


    if (phoneData.messages[id])
    {
        var chatData = phoneData.messages[id].data;
        if (!chatData) return;
    
        var chatDataLength = chatData.length - 1
        chatData.forEach((x, i) => {
            var [time, amPM] = ConvertTimestamp(x.time)
            var template = $(`
            <div class="message ${x.contact == phoneData.number && 'you'}">
                <p class="time"><span>${time}</span>${amPM}</p>
    
                <p class="phrase">
                    ${x.message}
                </p>
            </div>`);
    
            if (animateChat && i == chatDataLength) {
                template.hide()
            }
            $('.opened-chat .content').append(template)
        });
    
        var recentMessage = $('.opened-chat .content .message').last()
    
        if (animateChat) {
            recentMessage.css('transform', 'translateY(20px)');
            recentMessage.css('transition', 'transform 150ms ease')
    
            recentMessage.fadeIn(200)
            recentMessage.css('transform', 'translateY(0)');
        }
    }
}

$(window).click(e => {
    var target = e.target

    console.log(currentState, PhoneState)
    // If in chat history page process these
    if (currentState == PhoneState.InChatHistory) {
        var removeButton = target.closest('.chat > .delete')

        if (removeButton) {
            var id = $(removeButton.closest('.chat')).data('id')
            deleteChat(id)
            return
        }

        var chat = target.closest('.chats .chat')
        if (chat) {
            let id = $(chat).data('id')
            ShowChatHistory(id)
            return
        }

        var newConversation = target.closest('.header .new-message')
        if (newConversation) {
            currentState = PhoneState.InNewConversation

            $('.new-chat').addClass('active')
            $('.new-chat .content').empty()
            $('.new-chat .recipient .user').empty()
            
            Object.entries(phoneData.contacts).forEach(([number, contact]) => {
                var template = $(`
                <div class="contact">
                    <p class="name">${(contact.firstName || contact.lastName) && (contact.firstName + ' ' + contact.lastName) || "Unknown"}</p>
                    <p class="number">${number}</p>
                </div>
                `)

                template.data('number', number)

                $('.new-chat .content').append(template)
            })

            return
        }

        var editButton = target.closest('.header .edit')
        if (editButton) {
            editButton = $(editButton);

            if (editButton.hasClass('active')) {
                $(editButton).removeClass('active');
                $('.chats').removeClass('editing');

                if (pendingChatDeletings.length > 0)
                {
                    // Send deleted chat request and update
                    Events.Call('DeleteChats', pendingChatDeletings)
                }

                return
            }

            $(editButton).addClass('active');
            $('.chats').addClass('editing');
            pendingChatDeletings = []
        }
    }

    // If in messages view process these
    if (currentState == PhoneState.InMessages) {
        var backToChats = target.closest('.opened-chat img.back')
        console.log(backToChats)
        if (backToChats) {
            currentState = PhoneState.InChatHistory
            $('.chats, .messages-app > .header, .search-bar').fadeIn()
            $('.opened-chat').removeClass('active')
            return
        }

        var sendButton = target.closest('.write-input .send')

        if (sendButton) {
            sendMessage()
            return
        }

        var callButton = target.closest('.header .call')

        if (callButton) {
            if (currentConversation.includes('gc_'))
                return

            Events.Call('CallNumber', currentConversation)
            return
        }
    }

    // If in new conversation mode process these
    if (currentState == PhoneState.InNewConversation) {
        var findRecipient = target.closest('.recipient .add')
        if (findRecipient) {
            $('.new-chat').addClass('selecting')
            return
        }

        var sendButton = target.closest('.write-input .send')

        if (sendButton) {
            sendMessage()
            return
        }

        var backButton = target.closest('.header > .back')

        if (backButton) {
            $('.new-chat').removeClass('selecting active')
            newConversationContact = null
            currentState = PhoneState.InChatHistory
            return
        }

        var selectedContact = target.closest('.new-chat .content .contact')
        if (selectedContact) {
            $('.new-chat .content .contact').removeClass('active')
            
            selectedContact = $(selectedContact)
            selectedContact.addClass('active')

            var number = selectedContact.data('number')
            
            newConversationContact = number

            var data = phoneData.contacts[number]
            if (!data) return;

            $('.recipient .user').text(`${data.firstName + ' ' + data.lastName} ${number}`)
        }
    }
})

// $(window).mousemove(function (e) {
//     if (!isDragging) return
//     const deltaY = e.clientY - startY
//     messages.scrollTop(scrollTop - deltaY)
// })

// $(window).mouseup(function () {
//     isDragging = false
// })


$(window).keypress(function (e) {
    if (e.which == 13 && writeInput.is(":focus")) {
        sendMessage()
        return
    }
})

$(window).keyup(e => {
    if (searchBar.is(":focus"))
    {
        let value = $(document.activeElement).val().toLowerCase()
        console.log('value => ', value)

        if (currentState === PhoneState.InNewConversation)
        {
            $('.new-chat .contact').hide()
            var found = false
            $('.new-chat .contact').filter((i, el) => {
                if (el.textContent.toLowerCase().includes(value))
                {
                    found = true
                    return true;
                }
                return false;
            }).show()

            if (found)
                $('.new-chat .content').show()
            else
                $('.new-chat .content').hide()

            return
        }

        console.log('test', PhoneState)
        $('.chats .chat').hide()
        $('.chats .chat').filter((i, el) => {
            return el.textContent.includes(value);
        }).show()
    }
})

function sendMessage() {
    var message

    // console.log(ConversationElements)
    // console.log(ConversationElements.Input, currentState, PhoneState.InMessages)
    if (currentState === PhoneState.InMessages)
        message = ConversationElements.Input
    if (currentState === PhoneState.InNewConversation)
        message = NewConversationElements.Input

    console.log(message)
    var text = message.val()

    if (text == '') return
    message.val('')
    
    // If in new conversation, switch to new conversation view
    if (currentState == PhoneState.InNewConversation)
    {
        currentConversation = newConversationContact 
        $('.new-chat').removeClass('active')
        $('.opened-chat').addClass('active')
    }

    Events.Call('SendMessage', currentConversation, text)
}

async function deleteChat(chatId) {
    if (animatingDelete) return
    animatingDelete = true

    let chat = $(`.chat[data-id="${chatId}"]`)

    response = await Phone.ShowPrompt("Are you sure you want to delete this message?")

    if (!response)
    {
        animatingDelete = false;
        return
    }

    pendingChatDeletings.push(chatId)

    chat.css('transition', 'transform .3s ease')
    chat.css('transform', 'translateX(-100%)')

    let chatHeight = chat.outerHeight(true)
    let nextChats = chat.nextAll()

    setTimeout(() => {
        nextChats.css('transition', 'all .3s')
        nextChats.css('transform', 'translateY(-' + chatHeight + 'px)')
        chat.css('transition', 'none')
        chat.css('opacity', '0')
        setTimeout(() => {
            chat.css('display', 'none')
            nextChats.css('transition', 'none')
            nextChats.css('transform', 'translateY(0px)')
            setTimeout(() => {
                $('.chats >.chat').css('transition', 'all .3s')
                $('.chats').css('transition', 'all .3s')
                chat.remove()
                chat.css('opacity', '1')
                animatingDelete = false
            }, 50)
        }, 300)
    }, 300)
}

function setChatHeader(name, img) {
    $('.opened-chat .contact .name').text(name)
    $('.opened-chat .contact img').attr('src', img)
}