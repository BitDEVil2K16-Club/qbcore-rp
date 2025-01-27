// DONT TOUCH
// This is currently WIP.
/* var phoneData = null

const OnAppStart = (e) => {
}

window.addEventListener("message", e => {
    phoneData = e.data.phoneData;

    $('.app').css('transform', 'scale(0.5)')
    $('.app')[0].animate(
        [
          {
            transform: "scale(1.0)",
          },
        ],
        {
          duration: 250,
          fill: "forwards",
        }
    );

    OnAppStart(e)
}); */

// DONT TOUCH ^
// APP LOGIC BELOW v


const writeInput = $('.write-input input');
const searchBarChats = $('.messages-app > .search-bar input');
let messages = $('.opened-chat .content')
let sendButton = $('.write-input .send')
let backToChatsButtonFromChat = $('.opened-chat .back')

let time = "12:00"
let isDragging = false
let startY
let scrollTop

let localId = 1234321
let chatsData = null
let messagesData = null

let hardcodedChatsData = [
  {
    id: 1,
    name: "Dobby",
    participants: [1234321],
    img: "https://es.web.img2.acsta.net/img/13/0e/130ef5c860d21d4f7eb16627dcfd6d1d.jpeg",
  },
  {
    id: 2,
    name: "Helix group",
    participants: [1234321, 323347, 123123],
    img: "https://pbs.twimg.com/profile_images/1460325646895546368/Q6jgR8do_400x400.png",
  },
  {
    id: 3,
    name: "Oils",
    participants: [1234321],
    img: "https://images.immediate.co.uk/production/volatile/sites/30/2020/02/Sunflower-oil-b79e8f8.jpg?resize=960,872",
  }
]
let hardcodedMessagesData = {
  1: [
    {
      contact: 1234321,
      message: "Hi",
      time: "12:00",
      readed: true
    },
    {
      contact: 123123,
      message: "Hey",
      time: "12:00",
      readed: true
    },
    {
      contact: 1234321,
      message: "How are you?",
      time: "12:00",
      readed: true
    },
  ],
  2: [
    {
      contact: 1234321,
      message: "Hi",
      time: "12:00",
      readed: true
    },
    {
      contact: 1234321,
      message: "How are you guys?",
      time: "12:00",
      readed: true
    },
    {
      contact: 123123,
      message: "Hey wtsup",
      time: "12:00",
      readed: false
    },
    {
      contact: 1234321,
      message: "How are you guys?",
      time: "12:00",
      readed: false
    },
    {
      contact: 123123,
      message: "Hey wtsup",
      time: "12:00",
      readed: false
    },
    {
      contact: 1234321,
      message: "How are you guys?",
      time: "12:00",
      readed: false
    },
    {
      contact: 123123,
      message: "Hey wtsup",
      time: "12:00",
      readed: false
    },
    {
      contact: 1234321,
      message: "How are you guys?",
      time: "12:00",
      readed: false
    },
    {
      contact: 123123,
      message: "Hey wtsup",
      time: "12:00",
      readed: false
    },
    {
      contact: 1234321,
      message: "How are you guys?",
      time: "12:00",
      readed: false
    },
    {
      contact: 123123,
      message: "Hey wtsup",
      time: "12:00",
      readed: false
    },
  ],
  3: [
    {
      contact: 123123,
      message: "HAVE MORE DESIGNS FOR U 😛😛",
      time: "12:00",
      readed: false
    },
  ]
}



backToChatsButtonFromChat.click(function () {
  $('.opened-chat').removeClass('active')
})

sendButton.click(function () {
  let message = writeInput.val()
  if (message == '') return
  sendMessage(message)
  writeInput.val('')
})

messages.mousedown(function (e) {
  isDragging = true
  startY = e.clientY
  scrollTop = messages.scrollTop()
})

searchBarChats.keyup(function () {
  let value = $(this).val().toLowerCase()
  $('.chats .chat').filter(function () {
    // $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)

    if ($(this).text().toLowerCase().indexOf(value) > -1) {
      $(this).removeClass('hided')
    } else {
      $(this).addClass('hided')
    }
  })
})

$(window).mousemove(function (e) {
  if (!isDragging) return
  const deltaY = e.clientY - startY
  messages.scrollTop(scrollTop - deltaY)
})

$(window).mouseup(function () {
  isDragging = false
})

$(window).keypress(function (e) {
  if (e.which == 13 && writeInput.is(":focus")) {
    let message = writeInput.val()
    if (message == '') return
    sendMessage(message)
    writeInput.val('')
  }
})


function sendMessage(message) {
  // si el anterior mensaje es del usuario y el tiempo es menos a 2 minutos, no crear un nuevo mensaje, sino agregar un phrase al anterior
  let lastMessage = $('.message').last()
  let lastMessageTime = lastMessage.find('.time span').text()
  let lastMessageIsUser = lastMessage.hasClass('you')
  let lastMessageTimeIsLessThan2Minutes = lastMessageTime.split(':')[1] - new Date().getMinutes() < 2


  let totalHeight = 0
  $('.message').each(function () {
    totalHeight += $(this).outerHeight(true)
  })
  let isOverflowing = $('.opened-chat .content').outerHeight(true) < totalHeight

  if (lastMessageIsUser && lastMessageTimeIsLessThan2Minutes) {
    let newPhrase = `<p class="phrase">${message}</p>`
    lastMessage.append(newPhrase)



    let lastPhrase = $('.message').last().children('.phrase').last()

    let lastPhraseOuterHeight = lastPhrase.outerHeight(true)
    lastPhrase.css('opacity', '0')
    lastPhrase.css('display', 'none')

    if (isOverflowing) {
      $('.message').css('transition', 'none')
      $('.message').css('transform', 'translateY(' + (lastPhraseOuterHeight) + 'px)')
    }

    $('.opened-chat .content').scrollTop($('.opened-chat .content')[0].scrollHeight)

    setTimeout(() => {
      if (isOverflowing) {
        $('.message').css('transition', 'transform .5s ease')
        $('.message').css('transform', 'translateY(0px)')
      }
      lastPhrase.css('display', 'block')
      lastPhrase.css('opacity', '0')
      lastPhrase.css('transform', 'translate(5px, ' + (lastPhraseOuterHeight) + 'px)')

      setTimeout(() => {
        lastPhrase.css('transition', 'all 1s ease')
        lastPhrase.css('opacity', '1')
        lastPhrase.css('transform', 'translate(5px, 0px)')
      }, 50)
    }, 50)


  } else {

    let element = `<div class="message you">
        <p class="time"><span>12:00</span>PM</p>
        <p class="phrase">${message}</p>
      </div>`

    messages.append(element)

    let lastMessageOuterHeight = $('.message').last().outerHeight(true)

    $('.message').last().css('opacity', '0')
    $('.message').last().css('display', 'none')


    if (isOverflowing) {
      $('.message').css('transition', 'none')
      $('.message').css('transform', 'translateY(' + (lastMessageOuterHeight) + 'px)')
    }


    $('.opened-chat .content').scrollTop($('.opened-chat .content')[0].scrollHeight)

    setTimeout(() => {
      if (isOverflowing) {
        $('.message').css('transition', 'transform .5s ease')
        $('.message').css('transform', 'translateY(0px)')
      }
      $('.message').last().css('display', 'block')
      $('.message').last().css('opacity', '0')
      $('.message').last().css('transform', 'translateY(' + (lastMessageOuterHeight) + 'px)')


      setTimeout(() => {
        $('.message').last().css('transition', 'all 1s ease')
        $('.message').last().css('opacity', '1')
        $('.message').last().css('transform', 'translateY(0px)')
      }, 50);
    }, 50);
  }




  const writeInputPosition = {
    bottom: 0,
    left: "50%"
  };


}

function setChatHeader(name, img) {
  $('.opened-chat .contact .name').text(name)
  $('.opened-chat .contact img').attr('src', img)
}












// New and modified js

// let hardcodedContacts = [
//   {
//     id: 1,
//     name: 'Dobby',
//     number: '937-543',
//   },
//   {
//     id: 3,
//     name: 'Oils',
//     number: '987-431',
//   },
//   {
//     id: 4,
//     name: 'Opod',
//     number: '321-432',
//   },
//   {
//     id: 1,
//     name: 'Dobby',
//     number: '937-543',
//   },
//   {
//     id: 3,
//     name: 'Oils',
//     number: '987-431',
//   },
//   {
//     id: 4,
//     name: 'Opod',
//     number: '321-432',
//   },
// ]

let editChatsButton = $('.header .edit')
let writeNewMessageButton = $('button.new-message')
let backToChatButtonFromNewChat = $('.new-chat .back')
let searchBarContacts = $('.new-chat .search-bar input')
let sendNewMessage = $('.new-chat .actions .send')
let addRecipientButton = $('.new-chat .recipient .add')

let contacts = null
let editingMode = false
let animatingDelete = false


editChatsButton.click(() => {
  if (editChatsButton.hasClass('active')) {
    editChatsButton.removeClass('active')
    setEditingMode(false)
  } else {
    editChatsButton.addClass('active')
    setEditingMode(true)
  }
}
)

writeNewMessageButton.click(() => {
  $('.new-chat').addClass('active')
})

backToChatButtonFromNewChat.click(() => {
  $('.new-chat').removeClass('active')
  $('.new-chat').removeClass('selecting')
})

searchBarContacts.keyup(function () {
  let value = $(this).val().toLowerCase()
  $('.new-chat .content > .contact').filter(function () {
    // $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    // $(this).css('min-height', '0px')

    if ($(this).text().toLowerCase().indexOf(value) > -1) {
      $(this).removeClass('hided')
    } else {
      $(this).addClass('hided')
    }

  })
})

sendNewMessage.click(() => {
  $('.new-chat').removeClass('selecting')
  setTimeout(() => {
    let message = $('.new-chat .actions .write-input input').val()
    let contact = $('.new-chat .content .contact.active').data('id')

    if (message == '') return

    setChatMessages(contact, messagesData[contact])
    addChat(contact)

    $('.new-chat').removeClass('active')

    setTimeout(() => {
      $('.opened-chat').addClass('active')
      setTimeout(() => {
        sendMessage(message)
      }, 300)
    }, 300)
  }, 500)
})

addRecipientButton.click(() => {
  $('.new-chat').addClass('selecting')
})

function updateChats(chats, messages) {
  chatsData = chats
  messagesData = messages
  $('.chats').empty()

  chats.forEach(chat => {
    let lastMessage = messages[chat.id][messages[chat.id].length - 1]
    let notReaded = 0
    messages[chat.id].forEach(message => {
      if (!message.readed) notReaded++
    })
    let element = `<div class="chat ${notReaded == 0 ? '' : 'not-readed'}" data-id="${chat.id}">
      <img src="../img/apps/messages/delete.png" alt="" class="delete">
      <div class="image">
        <img src="${chat.img}" alt="">
        <span class="not-readed-msj">${notReaded}</span>
      </div>
      <div class="content">
          <div class="header">
              <h1 class="name">${chat.name}</h1>
              <p class="time"><span>${lastMessage.time}</span>PM</p>
          </div>
          <p class="spoiler">
              ${lastMessage.message}
          </p>
      </div>
      <img src="../img/apps/messages/arrow-right.png" alt="" class="arrow-right">
  </div>`

    $('.chats').append(element)
  });

  $('.chat .delete').click(function (e) {
    let chatId = $(this).parent().data('id')
    deleteChet(chatId)
  })
  $('.chats .chat').click(function () {
    if (!editingMode) {
      $('.opened-chat').addClass('active')
      $('.opened-chat .content').scrollTop($('.opened-chat .content')[0].scrollHeight)
  
      let id = $(this).data('id')
      let messages = messagesData[id]
      setChatMessages(id, messages)
    }
  })
}

function setChatMessages(chatId, messages) {
  writeInput.val('')
  $('.opened-chat .content').empty()
  if (chatsData[chatId - 1] == null) return
  setChatHeader(chatsData[chatId - 1].name, chatsData[chatId - 1].img)

  messages.forEach(message => {
    let isSameContactThanLast = messages.indexOf(message) != 0 && messages[messages.indexOf(message) - 1].contact == message.contact
    if (isSameContactThanLast) {
      let lastElement = $('.opened-chat .content .message:last-child')
      let newPhrase = `<p class="phrase">
        ${message.message}
      </p>`
      lastElement.append(newPhrase)
      return
    } else {
      let element = `<div class="message ${message.contact == 1234321 ? 'you' : ''}" data-contact="${message.contact}">
        <p class="time"><span>${message.time}</span>PM</p>

        <p class="phrase">
          ${message.message}
        </p>
      </div>`
      $('.opened-chat .content').append(element)
    }
  })
  $('.opened-chat .content').scrollTop($('.opened-chat .content')[0].scrollHeight)

  $('.chat .delete').click(function (e) {
    let chatId = $(this).parent().data('id')
    deleteChet(chatId)
  })
}

const setEditingMode = (state) => {
  editingMode = state
  if (state) {
    $('.chats').addClass('editing')
  } else {
    $('.chats').removeClass('editing')
  }
}

const setBackground = (url) => {
  $('.bg').attr('src', url)
}

function deleteChet(chatId) {
  if (animatingDelete) return
  animatingDelete = true
  let chat = $(`.chat[data-id="${chatId}"]`)
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
        $('.chats>.chat').css('transition', 'all .3s')
        $('.chats').css('transition', 'all .3s')
        chat.remove()
        chat.css('opacity', '1')
        animatingDelete = false
      }, 50)
    }, 300)
  }, 300)

}

function setContacts(contactsData) {
  contacts = contactsData
  $('.new-chat .content').empty()
  contactsData.forEach(contact => {
    let element = `<div class="contact" data-id="${contact.id}">
    <p class="name">${contact.name}</p>
    <p class="number">${contact.number}</p>
  </div>`

    $('.new-chat .content').append(element)
  })

  $('.new-chat .content .contact').click(function () {
    let id = $(this).data('id')
    let messages = messagesData[id]
    setChatMessages(id, messages)
    $('.new-chat .content .contact').removeClass('active')
    $(this).addClass('active')

    let recipient = $(this).find('.name').text() + ' ' + $(this).find('.number').text()
    $('.new-chat .recipient .user').text(recipient)
  })
}

function addChat(contact) {
  let existChat = $(`.chat[data-id="${contact}"]`)
  if (existChat.length > 0) {
    existChat.remove()
  }

  let existOldChat = messagesData[contact] != null
  if (!existOldChat) {
    messagesData[contact] = []
  } else {
    messagesData[contact].forEach(message => {
      message.readed = true
    })
  }



  let lastMessage = messagesData[contact][messagesData[contact].length - 1]
  let notReaded = 0
  messagesData[contact].forEach(message => {
    if (!message.readed) notReaded++
  })
  let chat = chatsData[contact - 1]

  let element = `<div class="chat ${notReaded == 0 ? '' : 'not-readed'}" data-id="${chat.id}">
  <img src="../img/apps/messages/delete.png" alt="" class="delete">
  <div class="image">
    <img src="${chat.img}" alt="">
    <span class="not-readed-msj">${notReaded}</span>
  </div>
  <div class="content">
      <div class="header">
          <h1 class="name">${chat.name}</h1>
          <p class="time"><span>${lastMessage.time}</span>PM</p>
      </div>
      <p class="spoiler">
          ${lastMessage.message}
      </p>
  </div>
  <img src="../img/apps/messages/arrow-right.png" alt="" class="arrow-right">
</div>`
  $('.chats').append(element)
  $('.chats .chat').click(function () {
    if (!editingMode) {
      $('.opened-chat').addClass('active')
      $('.opened-chat .content').scrollTop($('.opened-chat .content')[0].scrollHeight)

      let id = $(this).data('id')
      let messages = messagesData[id]
      setChatMessages(id, messages)
    }
  })

  $('.chat .delete').click(function (e) {
    let chatId = $(this).parent().data('id')
    deleteChet(chatId)
  })
}


setBackground("../img/backgrounds/fundosiphone/2.jpg")
// setContacts(hardcodedContacts)
// updateChats(hardcodedChatsData, hardcodedMessagesData)