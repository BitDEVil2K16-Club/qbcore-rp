var phoneData = null

// Ran when the app opens up, use this to get elements on DOM
const OnAppStart = (e, args) => {
    phoneData = e.data.phoneData

    $('.bg').attr('src', `${phoneData.phoneBackground}`)

    SetupContacts(phoneData.contacts)
    // SetupRecents(hardcodedRecentCalls)
    SetActivePage(NavigationButtons.Contacts)
}

// Ran when the app is closed
const OnAppClose = (e, args) => {
}

const OnAppUpdate = (e, args) => {
    if (args.action == 'CONTACT_ADDED')
    {
        phoneData.contacts = args.contacts
        // console.log(phoneData.contacts)
        // if (Array.isArray(phoneData.contacts))
        //     phoneData.contacts = {}

        // console.log(phoneData.contacts)
        // phoneData.contacts[args.number] = args.data
        // console.log(args, phoneData.contacts)
        SetupContacts(phoneData.contacts)
        return
    }

}

// var phoneData.contacts = {}

// Main
const backButton = $('.header button.back')
const searchBar = $('.searchbar input')

// Contacts wrapper
const contactsApp = $('.contacts-app')
const contactsWrapper = $('.contacts-wrapper')
const contactsList = contactsWrapper.find('.contacts-list')
const contact = contactsWrapper.find('.contacts-list .contact')
const selectContactToEdit = contactsWrapper.find('.header .edit')
const addNewContact = contactsWrapper.find('.header .add')
const editContactFromContacts = contactsWrapper.find('.contacts-list .contact .editing-actions .edit')
const myFullName = contactsWrapper.find('.my-profile .name')
const myNumber = contactsWrapper.find('.my-profile .number')

// Contact profile wrapper
const contactProfile = $('.contact-profile-wrapper')
const editContactFromProfile = contactProfile.find('.header .edit')
const contactFavButton = contactProfile.find('.name svg')
const copyNumber = contactProfile.find('.number button')

// Editing contact wrapper
const editingContactWrapper = $('.editing-contact-wrapper')
const inputNotes = editingContactWrapper.find('.notes textarea')

// Favoites wrapper
const favoritesWrapper = $('.favorites-wrapper')
const selectContactToEditFavorites = favoritesWrapper.find('.header .edit')
const favoriteContactsList = favoritesWrapper.find('.contacts-list')

// Recent calls
const recentCallsWrapper = $('.recent-calls-wrapper')
const recentCallsList = recentCallsWrapper.find('.calls-list')

// Numpad
const numpadWrapper = $('.numpad-wrapper')
const buttons = numpadWrapper.find('.keyboard button')
const contactName = numpadWrapper.find('.contact-name')
const inputNumber = numpadWrapper.find('.input-number')

// Actions
const actionButtons = $('.contacts-app>.actions button')

// Variables
const tabs = ['in-contacts', 'in-creating-contact', 'in-contact-profile', 'in-favorites', 'in-recent-calls', 'in-numpad']
let actualTab = 0
let prevTab = 0
let selectingToEdit = false
let editingContact = false
let animating = false
// let persistentContacts = []
let persistentRecentCalls = []


var PhoneStates = {
    InFavourites: 1,
    InRecents: 2,
    InContacts: 3,
    InDialPad: 4,
    InContactProfile: 5,
    InCreatingContact: 6
}

var PhoneModes = {
    View: 1,
    Edit: 2
}

var NavigationButtons = {
    Favourites: $('#in-favorites'),
    RecentCalls: $('#in-recent-calls'),
    Contacts: $('#in-contacts'),
    Numpad: $('#in-numpad')
}

var ContactProfileElements = {
    Body: $('.contact-profile-wrapper'),
    Favourite: $('.contact-profile-wrapper > div.name > svg'),
    ContactNumber: $('.contact-profile-wrapper .number p'),
    EditFields: $('.contact-profile-wrapper .editing-fields input, .contact-profile-wrapper .editing-fields textarea'),
    ContactName: $('.contact-profile-wrapper > div.name > p'),
    ContactImage: $('.contact-profile-wrapper > div.header > .avatar')
}

var CreateContactElements = {
    Body: $('.creating-contact-wrapper'),
    Inputs: $('.creating-contact-wrapper .field input, .creating-contact-wrapper .editing-notes textarea'),
    CreateContactButton: $('.creating-contact-wrapper .done'),
}

var ContactPageElements = {
    ContactsList: $(".contacts-wrapper .contacts-list"),
    ProfileName: $('.contacts-wrapper > div.my-profile > div > h1'),
    ProfileNumber: $('.contacts-wrapper > div.my-profile > div > p'),
}

var FavoritePageElements = {
    ContactsList: $('.favorites-wrapper .contacts-list')
}

var RecentPageElements = {
    ContactsList: $('.recent-calls-wrapper .calls-list')
}

var KeypadPageElements = {
    NumberInput: $('.numpad-wrapper .input-number')
}

var currentMode = PhoneModes.View
var currentState = null
var currentActionSelected = null

actionButtons.removeClass('selected')

$(window).click(e => {
    var target = e.target

    var navMenu = target.closest('.contacts-app>.actions button')
    if (navMenu)
    {
        navMenu = $(navMenu)
        SetActivePage(navMenu)
        return
    }
    if (currentState == PhoneStates.InFavourites)
    {
        var editButton = target.closest('.favorites-wrapper > .header > .edit')
        if (editButton)
        {
            if (currentMode == PhoneModes.Edit)
            {
                currentMode = PhoneModes.View
                FavoritePageElements.ContactsList.removeClass('selecting')
                return
            }
            else if (currentMode == PhoneModes.View)
            {
                currentMode = PhoneModes.Edit
                FavoritePageElements.ContactsList.addClass('selecting')
                return
            }
        }

        if (currentMode == PhoneModes.View)
        {
            var callButton = target.closest('.favorites-wrapper .contact-actions > .call-styled')
            if (callButton)
            {
                // CALL
                // Events.Call('CallNumber', currentConversation)
                DialPhoneCall(15112, 1);
                console.log("CALL BUTTON")
                return
            }
            var messageButton = target.closest('.favorites-wrapper .contact-actions > .chat-styled')
            if (messageButton)
            {
                // TEXT
                console.log("TEXT BUTTON")
                return
            }
            var contact = target.closest('.contacts-list .contact')
            if (contact)
            {
                SelectContact($(contact).data('number'))
                return
            }
        }
    }
    else if (currentState == PhoneStates.InContacts)
    {
        var editButton = target.closest('.contacts-wrapper > .header > .edit')
        if (editButton)
        {
            console.log(currentMode, PhoneModes.Edit, PhoneModes.View)
            if (currentMode == PhoneModes.Edit)
            {
                currentMode = PhoneModes.View
                ContactPageElements.ContactsList.removeClass('selecting')
                return
            }
            else if (currentMode == PhoneModes.View)
            {
                currentMode = PhoneModes.Edit
                ContactPageElements.ContactsList.addClass('selecting')
                return
            }
        }

        if (currentMode == PhoneModes.View)
        {
            var callButton = target.closest('.contacts-wrapper .contact-actions > .call-styled')
            var contact = target.closest('.contacts-list .contact')
            if (callButton)
            {
                if (!contact) return;
                
                // CALL
     
                Events.Call('CallNumber', $(contact).data('number'))
                return
            }
            var messageButton = target.closest('.contacts-wrapper .contact-actions > .chat-styled')
            if (messageButton)
            {
                // TEXT
                console.log("TEXT BUTTON")
                Phone.OpenApp('messages', { target: $(contact).data('number') })
                return
            }
            if (contact)
            {
                SelectContact($(contact).data('number'))
                return
            }

            var createContact = target.closest('.contacts-wrapper > .header > button.add')
            if (createContact)
            {
                SetActivePage($(createContact))
                return
            }
        }
    }
    else if (currentState == PhoneStates.InContactProfile)
    {
        var backButton = target.closest('.header .back')
        if (backButton)
        {
            if (currentMode == PhoneModes.Edit)
            {
                currentMode = PhoneModes.View
                ContactProfileElements.Body.removeClass('editing')
                return
            }

            currentState = PhoneStates.InContacts
            contactsApp.removeClass('in-contact-profile')
            contactsApp.addClass(currentActionSelected.attr('id'))

            return
        }

        var editButton = target.closest('.contact-profile-wrapper .edit')
        if (editButton)
        {
            if (currentMode == PhoneModes.View)
            {
                currentMode = PhoneModes.Edit
                ContactProfileElements.Body.addClass('editing')
            }
            else
            {
                currentMode = PhoneModes.View
                ContactProfileElements.Body.removeClass('editing')
            }
            return
        }

        if (currentMode == PhoneModes.View)
        {
            var deleteContact = target.closest('.delete-contact')
            if (deleteContact)
            {
                // Delete contact
                return
            }
    
            var callButton = target.closest('.call')
            if (callButton)
            {
                // Call contact
                Events.Call('CallNumber', ContactProfileElements.Body.data('number'))
                return
            }
    
            var messageButton = target.closest('.message')
            if (messageButton)
            {
                Phone.OpenApp('messages')
                // Message button
                return
            }
    
            var copyNumber = target.closest('.contact-profile-wrapper > .number > button')
            if (copyNumber)
            {
                // Copy phone number
                navigator.clipboard.writeText(ContactProfileElements.Body.data('number'))
                return
            }
    
            var favButton = target.closest('.contact-profile-wrapper .name svg')
            if (favButton)
            {
                // Favourite button
                ContactProfileElements.Body.toggleClass('favorite')
                return
            }
        }
        else if (currentMode == PhoneModes.Edit)
        {
            var saveButton = target.closest('.contact-profile-wrapper > .editing-fields > .save')
            if (saveButton)
            {
                // Save contact details
                SaveContactDetails(ContactProfileElements.Body.data('number'))
                
                currentMode = PhoneModes.View
                ContactProfileElements.Body.removeClass('editing')
                currentState = PhoneStates.InContacts                
                return
            }
        }
        return
    } else if (currentState == PhoneStates.InDialPad)
    {
        var dialNumber = target.closest('.keyboard .number')
        if (dialNumber)
        {
            var number = dialNumber.dataset.number
            if (!number)
                return
            
            var isNumber = isFinite(number)
            if (isNumber == false) return;
    
            var numberInput = KeypadPageElements.NumberInput[0].dataset.number;
            
            if (!numberInput)
            {
                KeypadPageElements.NumberInput[0].dataset.number = ''
                numberInput = KeypadPageElements.NumberInput[0].dataset.number;
            }

            if (numberInput.length > 10) return;
    
            numberInput = numberInput + number
    
            KeypadPageElements.NumberInput[0].dataset.number = numberInput
            KeypadPageElements.NumberInput.val(phoneFormat(numberInput))
            return
        }
        var deleteNumber = target.closest('.keyboard .delete')
        if (deleteNumber)
        {    
            var numberInput = KeypadPageElements.NumberInput[0].dataset.number;
            
            if (!numberInput)
            {
                KeypadPageElements.NumberInput[0].dataset.number = ''
                numberInput = KeypadPageElements.NumberInput[0].dataset.number;
            }
            
            if (numberInput.length < 1) return;
            
            numberInput = numberInput.slice(0, -1)
            
            KeypadPageElements.NumberInput[0].dataset.number = numberInput
            KeypadPageElements.NumberInput.val(numberInput)
            return
        }
        var callButton = target.closest('.keyboard .call')
        if (callButton)
        {
            // Call 
            var numberInput = KeypadPageElements.NumberInput[0].dataset.number;
            Events.Call('CallNumber', numberInput)
            return
        }
        
        var textButton = target.closest('.keyboard .text')
        if (textButton)
        {
            // Text
            var numberInput = KeypadPageElements.NumberInput[0].dataset.number;
            Phone.OpenApp('messages', { target: numberInput })

            KeypadPageElements.NumberInput.val('')
            KeypadPageElements.NumberInput[0].dataset.number = '';
            return
        }
    } else if (currentState == PhoneStates.InCreatingContact)
    {
        var backButton = target.closest('.creating-contact-wrapper > div.header > button.back')
        if (backButton)
        {
            SetActivePage(NavigationButtons.Contacts)
            return
        }

        var createContact = target.closest('.creating-contact-wrapper > button.done')
        if (createContact)
        {
            var inputData = {}
            CreateContactElements.Inputs.each((_, x) => inputData[x.id] = x.value)

            // Create contact
            Events.Call('CreateContact', inputData)
            SetActivePage(NavigationButtons.Contacts)
            return
        }
    }
})

const SaveContactDetails = (contact) => {
    var contactDetails = {}

    ContactProfileElements.EditFields.each((x, el) => {
        var val = $(el).val()
        if (val && val.length > 0)
            contactDetails[el.id] = val
    })

    var { firstName, lastName, phonenumber, notes } = contactDetails;

    phoneData.contacts[contact].firstName = firstName
    phoneData.contacts[contact].lastName = lastName
    phoneData.contacts[contact].phonenumber = phonenumber
    phoneData.contacts[contact].phonenumber = notes

    Events.Call('UpdateContact', contact, contactDetails)
}

const SelectContact = (contact) => {
    currentState = PhoneStates.InContactProfile

    ContactProfileElements.Body.data('number', contact)
    
    var { firstName, lastName, favorite, imgUrl } = phoneData.contacts[contact]

    ContactProfileElements.ContactNumber.text(phoneFormat(contact))
    ContactProfileElements.ContactName.text(`${firstName} ${lastName}`)
    
    ContactProfileElements.EditFields.each((idx, x) => {
        x.placeholder = phoneData.contacts[contact][x.id] || ''
    })

    if (favorite)
        ContactProfileElements.Body.addClass('favorite')
    else
        ContactProfileElements.Body.removeClass('favorite')


    ContactProfileElements.ContactImage[0].dataset.letter = firstName[0]
    
    if (imgUrl == undefined)
        ContactProfileElements.ContactImage.addClass('placeholder--profile')
    else
        ContactProfileElements.ContactImage.removeClass('placeholder--profile')


    contactsApp.addClass('in-contact-profile')
    contactsApp.removeClass(currentActionSelected.attr('id'))
}

const SetActivePage = (navMenu) => {
    if (currentActionSelected == navMenu.attr('id'))
    return

    if (currentMode == PhoneModes.Edit)
        currentMode = PhoneModes.View
            
    currentActionSelected?.removeClass('selected')
    navMenu.addClass('selected')
    
    if (currentActionSelected)
        contactsApp.removeClass(currentActionSelected.attr('id'))
    
    var oldClass = 'in-contact-profile'

    if (currentActionSelected)
        oldClass = currentActionSelected.attr('id')

    currentActionSelected = navMenu

    var id = currentActionSelected.attr('id')

    switch (id)
    {
        case 'in-contacts':
            currentState = PhoneStates.InContacts
            break
        case 'in-numpad':
            currentState = PhoneStates.InDialPad
            break
        case 'in-recent-calls':
            currentState = PhoneStates.InRecents
            break
        case 'in-favorites':
            currentState = PhoneStates.InFavourites
        case 'in-creating-contact':
            currentState = PhoneStates.InCreatingContact
            break
    }

    contactsApp.removeClass(oldClass)
    contactsApp.addClass(currentActionSelected.attr('id'))
}

const phoneFormat = (input) => {
    if(input.length >= 10)
      return input.replace(/(\d{3})(\d{3})(\d{4})/, "$1-$2-$3");
    
    return input
  }

  const SetupContacts = (contacts) => {

    contacts = [ 
        {
            firstName: "Mikel",
            lastName: "",
            number: "1234567890",
            favorite: true,
            imgUrl: "../img/apps/contacts/profile_image.png",
        }
    ]
    ContactPageElements.ContactsList.empty();
    FavoritePageElements.ContactsList.empty();
    Object.entries(contacts).forEach(([number, data]) => {
        var { firstName, lastName, favorite, imgUrl } = data;

        var template = $(`<div class="contact">
            <div class="editing-actions">
                <button class="delete">
                    <svg width="8" height="10" viewBox="0 0 8 10" fill="none"
                        xmlns="http://www.w3.org/2000/svg">
                        <path
                            d="M7.5 1H5.75L5.25 0.5H2.75L2.25 1H0.5V2H7.5M1 8.5C1 8.76522 1.10536 9.01957 1.29289 9.20711C1.48043 9.39464 1.73478 9.5 2 9.5H6C6.26522 9.5 6.51957 9.39464 6.70711 9.20711C6.89464 9.01957 7 8.76522 7 8.5V2.5H1V8.5Z"
                            fill="white" fill-opacity="0.65" />
                    </svg>
                </button>
                <button class="edit">
                    <svg width="8" height="8" viewBox="0 0 8 8" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path
                            d="M7.13454 2.70685L5.27418 0.865753L5.887 0.252055C6.0548 0.0840183 6.26097 0 6.50552 0C6.75006 0 6.95609 0.0840183 7.12359 0.252055L7.73642 0.865753C7.90421 1.03379 7.99176 1.2366 7.99906 1.47419C8.00635 1.71178 7.9261 1.91445 7.7583 2.08219L7.13454 2.70685ZM6.49983 3.35342L1.85987 8H-0.000488281V6.13699L4.63947 1.49041L6.49983 3.35342Z"
                            fill="white" fill-opacity="0.65" />
                    </svg>
                </button>
            </div>
            <div style="background-image: url(${imgUrl})" alt="" class="avatar ${imgUrl == undefined && 'placeholder--profile'}" data-letter=${firstName[0]}> </div>
            <h1>${firstName + ' ' + lastName}</h1>
            <div class="contact-actions">
                <button class="call-styled">
                    <svg width="10" height="10" viewBox="0 0 10 10" fill="none"
                        xmlns="http://www.w3.org/2000/svg">
                        <path
                            d="M2.30951 4.395C3.02951 5.81 4.18951 6.965 5.60451 7.69L6.70451 6.59C6.83951 6.455 7.03951 6.41 7.21451 6.47C7.77451 6.655 8.37951 6.755 8.99951 6.755C9.27451 6.755 9.49951 6.98 9.49951 7.255V9C9.49951 9.275 9.27451 9.5 8.99951 9.5C4.30451 9.5 0.499512 5.695 0.499512 1C0.499512 0.725 0.724512 0.5 0.999512 0.5H2.74951C3.02451 0.5 3.24951 0.725 3.24951 1C3.24951 1.625 3.34951 2.225 3.53451 2.785C3.58951 2.96 3.54951 3.155 3.40951 3.295L2.30951 4.395Z"
                            fill="white" fill-opacity="0.9" />
                    </svg>
                </button>
                <button class="chat-styled">
                    <svg width="11" height="10" viewBox="0 0 11 10" fill="none"
                        xmlns="http://www.w3.org/2000/svg">
                        <path
                            d="M1.91001 1.45501C3.85901 0.0725074 6.64451 0.185508 8.44651 1.72301C10.28 3.28651 10.5305 5.84201 9.02251 7.67151C7.60151 9.39501 5.04001 9.96301 2.90701 9.07401L2.79101 9.02351L0.603512 9.48901L0.566012 9.49551L0.511012 9.50001L0.454512 9.49801L0.432512 9.49551L0.377512 9.48551L0.325012 9.46851L0.275012 9.44651L0.237012 9.42551L0.183012 9.38701L0.142512 9.35001L0.106012 9.30851L0.0795118 9.27101L0.0470117 9.21351L0.0260117 9.16051L0.0105118 9.10401L0.00401175 9.06651L-0.000488281 9.01151L0.00151169 8.95501L0.00401175 8.93301L0.0140117 8.87801L0.0250118 8.84201L0.600012 7.11651L0.589012 7.09851C-0.515988 5.22501 -0.0154881 2.90251 1.79451 1.53951L1.90951 1.45551L1.91001 1.45501Z"
                            fill="white" fill-opacity="0.9" />
                    </svg>
                </button>
            </div>
        </div>`);

        template.data('number', number);

        // $(".call-styled").on('click', function() {
        //     console.log("DialPhoneCall", number, 1)
        // });

        // ContactPageElements on click call

        ContactPageElements.ContactsList.append(template);

        if (favorite) {
            FavoritePageElements.ContactsList.append(template.clone(true)); // Clone favorite contact
        }
    });
};

const SetupRecents = (recents) => {
    RecentPageElements.ContactsList.empty()

    recents.forEach(x => {
        var { callType, number, time } = x
        var { firstName, lastName, imgUrl } = phoneData.contacts[number]
        console.log(number, firstName, lastName)
        var recentCall = $(`<div class="call">
            <div style="background-image: url(${imgUrl}" alt="" class="avatar ${imgUrl == undefined && 'placeholder--profile'}" data-letter=${firstName[0]}></div>
            <h1>${firstName} ${lastName}</h1>
            <img src="../img/apps/contacts/${callType}_call.svg" alt="" class="call-state">
            <p class="time">${time}</p>
        </div>`)

        recentCall.data('number', number)

        RecentPageElements.ContactsList.append(recentCall)
    })
}

searchBar.on('input', function () {
    let input = this.value
    // Toggle class 'hided' on contacts that don't match the input
    if (actualTab === 0) {
        let filteredContacts = persistentContacts.filter(contact => {
            return contact.firstName.toLowerCase().includes(input.toLowerCase())
        })
        contactsList.find('.contact').each(function () {
            let contactName = $(this).find('h1').text().toLowerCase()
            if (contactName.includes(input.toLowerCase())) {
                $(this).removeClass('hided')
            } else {
                $(this).addClass('hided')
            }
        })
    } else if (actualTab === 3) {
        let filteredContacts = persistentContacts.filter(contact => {
            return contact.firstName.toLowerCase().includes(input.toLowerCase())
        })
        favoriteContactsList.find('.contact').each(function () {
            let contactName = $(this).find('h1').text().toLowerCase()
            if (contactName.includes(input.toLowerCase())) {
                $(this).removeClass('hided')
            } else {
                $(this).addClass('hided')
            }
        })
    } else if (actualTab === 4) {
        let filteredRecentCalls = persistentRecentCalls.filter(call => {
            return call.firstName.toLowerCase().includes(input.toLowerCase())
        })
        recentCallsList.find('.call').each(function () {
            let callName = $(this).find('h1').text().toLowerCase()
            if (callName.includes(input.toLowerCase())) {
                $(this).removeClass('hided')
            } else {
                $(this).addClass('hided')
            }
        })
    }
})


// Editing contact
inputNotes.on('input', function () {
    editingContactWrapper.find('.notes .pages').html(`${this.value.length} <span>/ 256</span>`)
    if (this.value.length > 255) {
        this.value = this.value.slice(0, 255)
    }
})

// onkeypress if actual wrapper is numpad
$(document).on('keyup', (e) => {
    if (currentState == PhoneStates.InDialPad)
    {
        var input = KeypadPageElements.NumberInput[0] 
        if (KeypadPageElements.NumberInput.is(':focus'))
        {
            var number =  KeypadPageElements.NumberInput.val()
            if (number.length > 10) return
            input.dataset.number = KeypadPageElements.NumberInput.val()
            return
        }

        if  (!input.dataset.number)
            input.dataset.number = ''

        // Backspace
        if (e.which === 8)
        {
            if (input.dataset.number.length === 0) return;

            input.dataset.number = input.dataset.number.slice(0, -1)

            KeypadPageElements.NumberInput.val(input.dataset.number)
            return
        }
        
        var isNumber = isFinite(e.key)
        if (isNumber == false) return;

        if (input.dataset.number.length > 10) return;

        input.dataset.number = input.dataset.number + e.key

        KeypadPageElements.NumberInput.val(input.dataset.number)

        return
    }

    var textArea = document.activeElement

    if (textArea.tagName === 'TEXTAREA')
    {
        var textLength = textArea.value.length

        if (textLength > 250) return;

        $(textArea.parentElement).find('.pages').html(`${textArea.value.length} <span>/ 250</span>`)
        return
    }
})

var hardcodedContacts = [
    {
        firstName: 'John',
        lastName: 'Oils',
        number: '111-222-333',
        favorite: false,
        notes: 'This is a blue note',
        imgUrl: '../img/apps/contacts/profile_image.png',
    },
    {
        firstName: 'Jane',
        lastName: 'Doe',
        number: '444-555-666',
        favorite: true,
        notes: 'Ut enim ad minim veniam',
        // imgUrl: '../img/apps/contacts/profile_image.png',
    },
    {
        firstName: 'Bob',
        lastName: 'Smith',
        number: '777-888-999',
        favorite: false,
        notes: 'Duis aute irure dolor in reprehenderit',
        // imgUrl: '../img/apps/contacts/profile_image.png',
    },
    {
        firstName: 'Alice',
        lastName: 'Cooper',
        number: '123-456-7890',
        favorite: true,
        notes: 'Excepteur sint occaecat cupidatat',
        // imgUrl: '../img/apps/contacts/profile_image.png',
    },
    {
        firstName: 'Mike',
        lastName: 'Brown',
        number: '234-567-8901',
        favorite: false,
        notes: 'Sed ut perspiciatis unde omnis iste natus error',
        // imgUrl: '../img/apps/contacts/profile_image.png',
    },
    {
        firstName: 'Sarah',
        lastName: 'Lee',
        number: '345-678-9012',
        favorite: true,
        notes: 'Nemo enim ipsam voluptatem',
        // imgUrl: '../img/apps/contacts/profile_image.png',
    },
    {
        firstName: 'Tom',
        lastName: 'Johnson',
        number: '456-789-0123',
        favorite: false,
        notes: 'At vero eos et accusamus et iusto odio dignissimos',
        // imgUrl: '../img/apps/contacts/profile_image.png',
    },
    {
        firstName: 'Lisa',
        lastName: 'Green',
        number: '567-890-1234',
        favorite: true,
        notes: 'Quis autem vel eum iure reprehenderit',
        // imgUrl: '../img/apps/contacts/profile_image.png',
    },
    {
        firstName: 'David',
        lastName: 'Gonzalez',
        number: '678-901-2345',
        favorite: false,
        notes: 'Lorem ipsum dolor sit amet',
        // imgUrl: '../img/apps/contacts/profile_image.png',
    },
    {
        firstName: 'Maggie',
        lastName: 'Jones',
        number: '789-012-3456',
        favorite: true,
        notes: 'Consectetur adipiscing elit',
        // imgUrl: '../img/apps/contacts/profile_image.png',
    },
    {
        firstName: 'Tim',
        lastName: 'White',
        number: '890-123-4567',
        favorite: false,
        notes: 'Suspendisse potenti',
        // imgUrl: '../img/apps/contacts/profile_image.png',
    },
    {
        firstName: 'Olivia',
        lastName: 'Davis',
        number: '901-234-5678',
        favorite: true,
        notes: 'Aenean auctor felis sed',
        // imgUrl: '../img/apps/contacts/profile_image.png',
    },
];
const hardcodedRecentCalls = [
    {
        callType: 'incoming',
        number: '890-123-4567',
        time: '12:15 pm'
    },
];