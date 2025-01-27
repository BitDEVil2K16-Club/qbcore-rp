var callOptions = $('.calling--options')
var incomingCall = $('.calling--prompt')

callOptions.hide()
incomingCall.hide()

var callName = $('.caller--name')
var callDuration = $('.call--duration')
var dialPad = $('.dial--pad')

var phoneData = null

var actionButtons = $('.action--button')
var callButtons = {
  microphone: $('#mic--toggle'),
  keypad: $('#keypad--toggle'),
  audio: $('#speaker--toggle'),
  add_call: $('#add--to--call'),
  video: $('#video--toggle'),
  contacts: $('#contacts--toggle')
}

var currentState = null;
var PhoneState = {
  OutgoingCall: 1,
  IncomingCall: 2,
}

// Ran when the app opens up, use this to get elements on DOM
const OnAppStart = (e, args) => {  
  callOptions = $('.calling--options')
  incomingCall = $('.calling--prompt')
  
  callName = $('.caller--name')
  callDuration = $('.call--duration')
  
  phoneData = null
  
  actionButtons = $('.action--button')
  callButtons = {
    microphone: $('#mic--toggle'),
    keypad: $('#keypad--toggle'),
    audio: $('#speaker--toggle'),
    add_call: $('#add--to--call'),
    video: $('#video--toggle'),
    contacts: $('#contacts--toggle')
  }
  
  dialPad = $('.dial--pad')

  
  callOptions.hide();
  incomingCall.hide();

  phoneData = e.data.phoneData

  Phone.HideHomeButton()
  
  if (args.incomingCall)
    ShowIncomingCall(args.contact)
  else if (args.outgoingCall)
    ShowOutgoingCall(args.contact)
  else if (args.callInitialised)
    ShowInitialisedCall(args.contact)
}

// Ran when the app is closed
const OnAppClose = (e, args) => {
  // Send Request to cancel call or keep call active in notifications
}

const OnAppUpdate = (phoneData, data) => {
  console.log(data)
  if (data.action == 'CALL_ANSWERED')
  {
    ShowInitialisedCall(data.contact)
  }
}

const ShowKeypad = () => {
  actionButtons.hide()
  dialPad.show()
  dialPad.css('transform', 'scale(1.0) translateX(-50%)')
}

const CloseKeypad = () => {
  dialPad.css('transform', 'scale(0.0) translateX(-50%)')
  dialPad.fadeOut()
  actionButtons.show()
}

const ShowOutgoingCall = (phoneNumber) => {
  var contact = phoneData.contacts[phoneNumber]?.name || phoneNumber
  
  actionButtons.removeClass('disabled')
  actionButtons.removeClass('active')
  
  callDuration.text("Calling...")
  callName.text("Mikel")
  
  callButtons.add_call.addClass('disabled')
  callButtons.video.addClass('disabled')
  
  callOptions.show()

  // set timeout and then StartCallTimer()
  setTimeout(() => {
    StartCallTimer()
  }, 4000)
}

const ShowIncomingCall = (phoneNumber) => {
  var contact = phoneData.contacts[phoneNumber]?.name || phoneNumber

  callName.text(contact)
  incomingCall.show()
}


var callTimer = null
var phoneTime = 0

const StartCallTimer = () => {
  if (callTimer != null)
    StopCallTimer()
    
  var callTime = new Date(phoneTime * 1000).toISOString().slice(11, 19);
  callDuration.text(callTime)

  callTimer = setInterval(() => {
    phoneTime++;
    var callTime = new Date(phoneTime * 1000).toISOString().slice(11, 19);
    callDuration.text(callTime)
  }, 1000)
}

const StopCallTimer = () => {
  if (callTimer == null)
    return
  
  clearInterval(callTimer)
  callTimer = null
  phoneTime = 0
}

const ShowInitialisedCall = (phoneNumber) => {
  var contact = phoneData.contacts[phoneNumber]?.name || phoneNumber

  actionButtons.removeClass('disabled')
  actionButtons.removeClass('active')

  callName.text(contact)

  callButtons.video.addClass('disabled')
  Phone.RemovePhoneClass('phone--call')
  
  callOptions.show()
  incomingCall.hide()

  StartCallTimer()
}

$(window).click(e => {
  var target = e.target

  if (target.closest('.decline--call'))
  {
    console.log("Decline Call")
    // event for playing animation for putting phone away
    StopCallTimer()
    Phone.Close()
    Phone.ShowHomeButton()
    
    Phone.EndCall()
    Events.Call('StopCall')
    return
  }


  if (target.closest('.answer--call'))
  {
    Events.Call('AnswerCall')
    return
  }

  if (target.closest('#keypad--toggle:not(.disabled)'))
  {
    ShowKeypad()
    return
  }
})

CloseKeypad()