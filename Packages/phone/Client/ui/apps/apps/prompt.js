var phoneData = null

var currentState = null;
var PhoneState = {
  AppClosed: 1,
  AppOpen: 2,
}

var promptText = undefined;
var sourceApp = undefined;

// Ran when the app opens up, use this to get elements on DOM
const OnAppStart = (e, args) => {
    currentState = PhoneState.AppOpen

    Phone.HideHomeButton()

    promptText = $('.prompt--text');
    
    phoneData = e.data.phoneData
    sourceApp = args.source;

 
    promptText.text(args.prompt);

}

const SendPromptResponse = (resp) => {
    window.parent.postMessage({ action: "SEND_PROMPT_RESPONSE", source: sourceApp, response: resp }, "*")
    Phone.ShowHomeButton()
    Phone.Close()
}

// Ran when the app is closed
const OnAppClose = (e, args) => {
    currentState = PhoneState.AppClosed
  // Send Request to cancel call or keep call active in notifications
}

const OnAppUpdate = (phoneData, data) => {
}

$(window).click((e) => {
    if (currentState == PhoneState.AppClosed) return;

    var target = e.target
    if (target.closest('.prompt--confirm'))
    {
        SendPromptResponse(true)
    }
    else if (target.closest('.prompt--cancel'))
    {
        SendPromptResponse(false)
    }
})