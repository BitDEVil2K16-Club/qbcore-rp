var phoneData = null
var appType = null
var appName = null
var promptAction = null

window.addEventListener("message", e => {
	phoneData = e.data.phoneData;

	var type = e.data.appType;
	var args = e.data.args;

	appType = type;
	appName = e.data.appName;

	console.log("APP NAME => ", appName)

	if (e.data.action == 'OPEN_APP')
		OnAppStart(e, args)
	else if (e.data.action == 'CLOSE_APP')
		OnAppClose(e, args)
	else if (e.data.action == 'SEND_DATA') {
		OnAppUpdate(phoneData, args)
	}
	else if (e.data.action == 'SEND_PROMPT_RESPONSE') {
		promptAction(e.data.response)
		promptAction = null;
		return
	}

	var app = $('.app')

	if (type == 'utility') {
		app.css('transform', 'scale(1.0)')
		app.fadeIn()
		return
	}

	var style = {
		transform: "scale(1.0)"
	}

	app.stop()
	app.css('transform-origin', 'center top')
	app.css('transform', 'scale(0.5)')

	app[0].animate(
		[
			{
				transform: "scaleX(1.0) scaleY(0.95)",
			},
		],
		{
			duration: 250,
			fill: "forwards",
		}
	);

	setTimeout(() => {
		app[0].animate(
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
	}, 150)

	app.animate(style, 250, () => $(this).css(style));

	app.show()
});

const Phone = {
	ShowNotification: str => {
		window.parent.postMessage({ action: "TRIGGER_FUNC", function: "ShowNotification", args: ["testing", str] }, "*")
	},
	Close: () => {
		if (appType == 'utility')
			window.parent.postMessage({ action: "TRIGGER_FUNC", function: "CloseUtility", args: [appName] }, "*")
		else if (appType == 'app')
			window.parent.postMessage({ action: "TRIGGER_FUNC", function: "CloseApp", args: [appName] }, "*")
	},
	HideHomeButton: () => {
		window.parent.postMessage({ action: "TRIGGER_FUNC", function: "HideHomeButton", args: [] }, "*")
	},
	ShowHomeButton: () => {
		window.parent.postMessage({ action: "TRIGGER_FUNC", function: "ShowHomeButton", args: [] }, "*")
	},
	RemovePhoneClass: (class_) => {
		window.parent.postMessage({ action: "TRIGGER_FUNC", function: "RemovePhoneClass", args: [class_] }, "*")
	},
	ShowPrompt: (prompt, cb) => {
		// FIX APP NAME
		if (cb) {
			promptAction = cb;
			window.parent.postMessage({ action: "TRIGGER_FUNC", function: "OpenUtility", args: ["prompt", { prompt: prompt, source: "messages" }] }, "*")
		}
		else {
			return new Promise((resolve, reject) => {
				promptAction = resolve; // store the resolve function in promptAction
				window.parent.postMessage({ action: "TRIGGER_FUNC", function: "OpenUtility", args: ["prompt", { prompt: prompt, source: "messages" }] }, "*");
			});
		}
	},
	OpenApp: (app, args) => {
		window.parent.postMessage({ action: "TRIGGER_FUNC", function: "OpenApp", args: [app, args] }, "*")	
	},
	EndCall: () => {
		window.parent.postMessage({ action: "TRIGGER_FUNC", function: "EndCall", args: [] }, "*")	
	}
}