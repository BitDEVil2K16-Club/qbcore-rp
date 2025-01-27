// Utility functions
const clamp = (num, min, max) => Math.min(Math.max(num, min), max);

var appPositions = {};
var activeUtilities = [];

var phoneTimeDisplay = undefined;
var phoneTimeDisplayAMPM = undefined;

setInterval(() => {
    GenerateTime();
}, 60000);

function GenerateTime() {
    const now = new Date();

    var time_display = now.toLocaleString("en-US", { timeZone: "America/New_York" });

    var time = time_display.slice(11, 15);
    var [hour, min] = time.split(":");

    time = hour.padStart(2, "0");
    time = time + ":" + min.padStart(2, "0");

    var am_pm = time_display.slice(-2);

    phoneTimeDisplay = time;
    phoneTimeDisplayAMPM = time + am_pm;

    timeDisplay.text(phoneTimeDisplay);
}

// Phone data
// var phoneData = {}
var phoneData = {
    phoneBackground: "../img/background.jpg",
    messages: {},

    utilityApps: {},

    contacts: {},

    settings: {
        bluetooth: false,
        airplaneMode: false,
        notfications: true,
        flashlight: false,
        wifi: false,
        mobileData: true,
    },

    brightness: 0.5,
    volume: 0.5,

    appbar: ["contacts", "phone", "camera"],

    installedApps: {},

    homescreen: [
        {
            slot: 3,
            app: "contacts",
            label: "Contacts",
        },
        {
            slot: 7,
            app: "settings",
            label: "Settings",
        },
        {
            slot: 11,
            app: "contacts",
        },
        {
            slot: 15,
            app: "contacts",
        },
        {
            slot: 19,
            app: "contacts",
        },
        {
            slot: 23,
            app: "contacts",
        },
    ],

    apps: {},
};

// DOM Elements
const phoneIsland = $(".notification");
const homeButton = $(".phone_home_button");
const phoneContainer = $(".phone-container");

const phoneOverlay = $(".phone--screen--overlay");
const controlPanel = $(".phone--control--panel");

const hotbarIcons = $(".hotbar-apps");
const phoneBattery = document.querySelector("svg > path:nth-child(3)");

hotbarIcons.css("display", "flex").hide();

var phoneApplications = $(".phone-applications");

var focalButtons = $(".focal--action");

var timeDisplay = $(".time--display .time, #phone-time");

var audioSlider = document.querySelector("#audio__slider");
var audioSliderFill = audioSlider.querySelector(".slider");

var brightnessSlider = document.querySelector("#brightness__slider");
var brightnessSliderFill = brightnessSlider.querySelector(".slider");

var controlPanelMouseDown = false;
var controlPanelMouseData = {};

var activeApp = undefined;
var lockscreenEnabled = false;

var incomingCall;

const ShowLockscreen = () => {
    lockscreenEnabled = true;

    phoneApplications.hide();
    ShowLockIndicator();
};

const UpdateBrightness = (percent) => {
    phoneData.brightness = percent / 100;
    brightnessSliderFill.style.height = `${percent}%`;
    phoneContainer[0].style.filter = `brightness(${clamp(percent * 1.05, 20, 150)}%)`;
};

const ShowLockIndicator = () => {
    // setTimeout(() => {
    var style = {
        right: "0",
        left: "-16px",
    };

    phoneIsland.html(`
    <div class="lock--indicator left--align">
      <span class="material-symbols-outlined">
          lock
      </span>
    </div>
    `);

    phoneIsland.stop();
    phoneIsland.animate(style, 300, () => {
        $(this).css(style);
        phoneIsland[0].style.removeProperty("height");
    });
    $(".lock--indicator").fadeIn("fast");
    // },)
};

const ReturnHome = () => {
    lockscreenEnabled = false;

    if (activeApp) {
        var app = $(phoneData.installedApps[activeApp].iframe);
        var pos = appPositions[activeApp];

        // left = offsetLeft, height = offsetTop + offsetHeight
        app.css("transform-origin", `${pos.left * 1.2}px ${pos.top * 1.1}px`);

        app.css("transition", "transform 350ms cubic-bezier(0.075, 0.82, 0.165, 1)");
        app.css("transform", "scaleX(0.2) scaleY(0.1)");
        app.fadeOut("fast");

        app[0].contentWindow.postMessage({ action: "CLOSE_APP", phoneData: SerialiseData(), args: undefined }, "*");

        activeApp = undefined;
    }

    phoneApplications.css("background", "transparent");

    HideHomeButton();

    setTimeout(() => {
        phoneApplications.find('[data-app="home"]').show();
        hotbarIcons.show();

        $(`.app-icon`).each((i, el) => {
            appPositions[el.dataset.app] = $(el).position();
        });
    }, 150);
};

const UpdateAudio = (percent) => {
    phoneData.volume = percent / 100;
    audioSliderFill.style.height = `${percent}%`;
};

const OpenControlPanel = () => {
    phoneOverlay.hide();
    phoneOverlay.addClass("blur");
    phoneOverlay.fadeIn();
    controlPanel.addClass("control--panel--opened");

    controlPanel.find("[data-utility]").each((idx, el) => {
        phoneData.settings[el.dataset.utility] ? $(el).addClass("active") : $(el).removeClass("active");
    });
};

const CloseControlPanel = () => {
    phoneOverlay.show();
    controlPanel.removeClass("control--panel--opened");
    phoneOverlay.fadeOut("fast");
};

const EndCall = () => {
    Events.Call("EndCall");
    incomingCallId = undefined;
};

var notificationId;

const ShowNotification = (appName, notificationMsg) => {
    phoneIsland.addClass("expanded--max");
    phoneIsland.html(
        `
    <div class="display">
        <div class="profile">
        </div>
        <div class="profile--info">
            <p id="small--text">${appName}</p>
            <p id="main--text">${notificationMsg}</p>
        </div>
    </div>
    `
    );

    notificationId = new Date().getTime();
    phoneIsland.stop();

    var style = {
        right: "-93px",
        left: "-93px",
        height: "60px",
        easing: "cubic-bezier(0.87, 0, 0.13, 1)",
    };

    phoneIsland.animate(style, 100, () => $(this).css(style));

    phoneIsland.children().hide();
    phoneIsland.children().fadeIn("slow");

    $("#phone-icons").fadeOut("fast");

    setTimeout(
        (id) => {
            if (notificationId !== id) return;

            style = {
                right: "0",
                left: "0",
            };

            phoneIsland.animate(style, 100, () => $(this).css(style));

            setTimeout(
                (id) => {
                    if (notificationId !== id) return;
                    style = { height: "0" };
                    phoneIsland.animate(style, 150, () => {
                        $(this).css(style);

                        if (lockscreenEnabled) ShowLockIndicator();
                    });
                },
                50,
                id
            );

            phoneIsland.removeClass("expanded--max");
            phoneIsland.children().fadeOut();
            phoneIsland.html("");

            $("#phone-icons").fadeIn("fast");
        },
        3500,
        notificationId
    );
};

// Removes any elements from the object so that we can pass the phone data object through to the iframes.
const SerialiseData = () => {
    var serialised = { ...phoneData };
    var t = {};
    var u = {};
    Object.entries(serialised.installedApps).forEach((x, i) => {
        t[x[0]] = true;
    });
    Object.entries(serialised.utilityApps).forEach((x, i) => {
        u[x[0]] = true;
    });

    serialised.utilityApps = u;
    serialised.installedApps = t;

    return serialised;
};

// Used for Utility Apps:
// A utility app is considered a helper app
// think of the calling prompt for the phone, it needs to overtake the other
// apps by default in z-index and when its closed it should return to the previous opened app
const OpenUtility = (app, args) => {
    if (!phoneData.utilityApps[app]) return;

    activeUtilities.push(app);

    HideHomeScreen();

    var appName = app;
    var appData = phoneData.utilityApps[app];
    var app = $(appData.iframe);

    app.fadeIn();

    if (!args?.keepBackground) phoneApplications.css("background", "var(--sys-bg)");

    setTimeout(() => {
        app[0].contentWindow.postMessage({ action: "OPEN_APP", phoneData: SerialiseData(), appType: "utility", appName: appName, args: args }, "*");
    }, 15);
};

const CloseUtility = (app) => {
    if (app) {
        var foundApp = activeUtilities.indexOf(app);

        if (foundApp == -1) return;

        app = phoneData.utilityApps[activeUtilities[foundApp]];

        activeUtilities.splice(foundApp, 1);
    } else app = phoneData.utilityApps[activeUtilities.pop()];

    $(app.iframe).fadeOut();
};

const HideHomeButton = () => {
    var style = {
        bottom: "0px",
        opacity: "0",
    };

    homeButton.stop();
    homeButton.animate(style, 250, () => $(this).css(style));
};

const ShowHomeButton = () => {
    homeButton.css("bottom", "0");
    homeButton.fadeIn();
    homeButton.stop();

    var style = {
        bottom: "23px",
        opacity: "1",
    };

    homeButton.animate(style, 250, () => $(this).css(style));
};

const HideHomeScreen = () => {
    hotbarIcons.hide();
    phoneApplications.find('[data-app="home"]').hide();
};

const OpenApp = (app, args) => {
    console.log("opening app", args);
    if (!phoneData?.installedApps[app]) return ShowNotification("System", "This app is still in development!");

    ReturnHome();
    ShowHomeButton();

    if (!args?.keepBackground) phoneApplications.css("background", "var(--sys-bg)");

    activeApp = app;

    var appName = activeApp;
    var appData = phoneData.installedApps[activeApp];
    var _app = $(appData.iframe);

    Events.Call("OnAppOpened", activeApp);

    HideHomeScreen();

    _app.fadeIn();
    _app.css("transform", "scale(1.0)");

    // On App Load
    setTimeout(() => {
        _app[0].contentWindow.postMessage({ action: "OPEN_APP", phoneData: SerialiseData(), appType: "app", appName: appName, args: args }, "*");
    }, 15);
};

const RemovePhoneClass = (class_) => {
    phoneContainer.removeClass(class_);
};

const ShowCallingNotification = () => {
    var island = phoneIsland[0];

    island.dataset["callIncoming"] = true;
    phoneIsland.addClass("expanded--max");
    phoneIsland.html(
        `
    <div class="display">
        <div class="profile">
        </div>
        <div class="profile--info">
            <p id="small--text">mobile</p>
            <p id="main--text">Opod Pog</p>
        </div>
    </div>
    <div class="actions">
        <div class="button hangup">
            <span class="material-symbols-outlined">
                call_end
            </span>
        </div>
        <div class="button answer">
            <span class="material-symbols-outlined">
                call
            </span>
        </div>
    </div>
    `
    );

    phoneIsland.stop();

    var style = {
        right: "-93px",
        left: "-93px",
        height: "60px",
        easing: "cubic-bezier(0.87, 0, 0.13, 1)",
    };

    phoneIsland.animate(style, 100, () => $(this).css(style));
    phoneIsland.children().hide();

    setTimeout(() => {
        phoneIsland.children().fadeIn("slow");
        $("#phone-icons").fadeOut("fast");
    }, 50);
};

const HideCallingNotification = () => {
    var island = phoneIsland[0];

    island.dataset["callIncoming"] = false;
    phoneIsland.removeClass("expanded--max");
    phoneIsland.children().fadeOut();
    phoneIsland.html("");

    phoneIsland.stop();

    var style = {
        right: "0",
        left: "0",
    };

    phoneIsland.animate(style, 150, () => $(this).css(style));

    setTimeout(() => {
        style = {
            height: "0",
        };

        phoneIsland.animate(style, 150, () => $(this).css(style));
    }, 50);

    $("#phone-icons").fadeIn("fast");
};

$(".focal-length").click((e) => {
    var focalButton = e.target.closest(".focal--action");
    if (focalButton == null) return;
    focalButtons.removeClass("selected");
    $(focalButton).addClass("selected");
});

$(window.document).click((e) => {
    var notification = e.target.closest(".notification.expanded--max");
    if (notification) {
        var btn = e.target.closest(".notification .button");
        if (btn) return;

        HideCallingNotification();
        // If click notification open up prompt
        OpenUtility("calling", { ...phoneData.apps["calling"]?.args, incomingCall: true, contact: incomingCall });
        return;
    }
});

$(".phone-lockscreen").click((e) => {
    var lockscreen = $(".phone-lockscreen");
    var style = {
        top: "-100%",
        backdropFilter: "brightness(1.0)",
    };
    lockscreen.animate(style, 300, () => $(this).css(style));

    phoneApplications.fadeIn();
    phoneContainer.removeClass("locked");

    phoneIsland.stop();

    style = {
        right: "0",
        left: "0",
    };
    phoneIsland.animate(style, 300, () => $(this).css(style));

    $(".lock--indicator").fadeOut("fast");

    ReturnHome();
});

$(window).mouseup((e) => {
    if (controlPanelMouseDown) {
        controlPanelMouseDown = false;

        var newY = e.clientY;

        var dist = newY - controlPanelMouseData.y;

        controlPanelMouseData = {};
        if (dist <= 50) return;

        OpenControlPanel();
    }
});
$(".phone-header").mousedown((e) => {
    controlPanelMouseDown = true;
    controlPanelMouseData.y = e.clientY;
});

homeButton.click((e) => {
    ReturnHome();
});

$(".phone--control--panel").click((e) => {
    if (e.target === e.currentTarget) CloseControlPanel();
});

brightnessSlider.oninput = function (e) {
    UpdateBrightness(e.target.value);
};

audioSlider.oninput = function (e) {
    UpdateAudio(e.target.value);
};

UpdateBrightness(80);
UpdateAudio(50);
// ReturnHome()
ShowLockscreen();

var incomingCallId = undefined;

var phoneAudio = new Howl({
    src: ["./sounds/ringtones/ringtone.wav"],
    autoplay: false,
    loop: true,
    volume: 0.5,
});

Events.Subscribe("UpdatePhoneData", (_phoneData) => {
    Object.entries(_phoneData).forEach(([key, val]) => {
        // if (key === 'contacts' && val?.isArray())
        //   val = {}
        phoneData[key] = val;
    });
});

Events.Subscribe("SendAppData", (app, data) => {
    if (!phoneData.installedApps[app] && !phoneData.utilityApps[app]) return;
    var app = $(phoneData.installedApps[app]?.iframe || phoneData.utilityApps[app]?.iframe);

    app[0].contentWindow.postMessage({ action: "SEND_DATA", phoneData: SerialiseData(), args: data }, "*");
});

Events.Subscribe("SendAppNotification", (app, message, title) => {
    if (!phoneData.installedApps[app]) return;
    if (activeApp == app) return;

    ShowNotification(title || app, message);
});

function DialPhoneCall(number, callID) {
    incomingCallId = callID;

    if (phoneContainer.hasClass("hide--phone")) {
        phoneContainer.removeClass("hide--phone");
        phoneContainer.addClass("phone--call");
        phoneContainer.addClass("show--notification");
    }

    // phoneAudio.play()

    OpenUtility("calling", { ...phoneData.apps["calling"]?.args, outgoingCall: true, contact: number });
}

Events.Subscribe("DialPhoneCall", (number, callID) => {
    DialPhoneCall(number, callID);
});

Events.Subscribe("ReceivePhoneCall", (number, callID) => {
    incomingCallId = callID;

    if (phoneContainer.hasClass("hide--phone")) {
        phoneContainer.removeClass("hide--phone");
        phoneContainer.addClass("phone--call show--notification");
    }

    phoneAudio.play();

    incomingCall = number;
    ShowCallingNotification();
});

Events.Subscribe("RejectPhoneCall", (number, callID) => {
    if (callID !== incomingCallId) return;

    incomingCallId = undefined;
    incomingCall = null;

    phoneContainer.addClass("hide--phone");
    phoneContainer.removeClass("phone--call show--notification");

    HideCallingNotification();
    phoneAudio.stop();
});

Events.Subscribe("OpenPhone", () => {
    console.log("OpenPhone");
    if (!phoneTimeDisplay) GenerateTime();

    phoneContainer.removeClass("hide--phone show--notification");
});

Events.Subscribe("ClosePhone", () => {
    if (incomingCallId) phoneContainer.addClass("show--notification");
    else phoneContainer.addClass("hide--phone");
});

Events.Subscribe("SetupApps", (phoneApps, savedData) => {
    // Setup app data
    Object.entries(phoneApps).forEach(([key, object]) => {
        if (!object.icon) phoneApps[key].icon = `img/app-icons/${key}.png`;
        if (!object.ui) phoneApps[key].ui = `apps/${key}.html`;
    });

    phoneData.apps = phoneApps;

    // If not saved data setup default apps
    if (!savedData) {
        $(".installed-apps").empty();

        var slots = 1;
        var homescreen = [];
        Object.entries(phoneApps).forEach(([key, object]) => {
            if (!object.utility && !object.hide) {
                var app = $(`<div class="app-icon" style="background-image: url(${object.icon}); background-color: transparent; background-position: center; background-size: cover;" data-app="${key}" data-title="${object.name}" data-position="${slots}"></div>`);
                $(".installed-apps").append(app);
                homescreen[slots] = key;
                slots++;
            }
            if (!object.utility && !object.blocked) {
                var iframe = $(`<iframe data-app="${key}" src="${object.ui}" frameborder="0"></iframe>`);
                $(".phone-applications").append(iframe);
                phoneData.installedApps[key] = { iframe: iframe[0], app: app && app[0] };
            }
            if (object.utility) {
                var iframe = $(`<iframe data-utility="${key}" src="${object.ui}" frameborder="0"></iframe>`);
                $(".phone-utilities").append(iframe);
                phoneData.utilityApps[key] = { iframe: iframe[0] };
            }
        });

        phoneData.homescreen = homescreen;
        Events.Call("UpdateHomescreen", homescreen);
    }

    var draggingApp = false;

    $(".app-icon").draggable({
        helper: "clone",
        appendTo: ".phone-container",
        revert: "invalid",
        revertDuration: 250,
        delay: 150,
        start: function (event, ui) {
            draggingApp = true;
            $(event.currentTarget).addClass("hide");
            event.currentTarget.dataset.title = "";

            var icon = $(ui.helper);
            icon.css("width", "48px");
            icon.css("height", "48px");
            icon.css("z-index", "9999");
            icon.css("background-size", "contain");
        },
        stop: function (event, ui) {
            if (!draggingApp) return;
            // Only triggers if the app isnt swapped with an existing app
            var app = $(this);

            var appData = phoneData.apps[app[0].dataset.app];
            app[0].dataset.title = appData.name;
            app.removeClass("hide");
        },
    });

    $(".app-icon").droppable({
        drop: (e, ui) => {
            draggingApp = false;
            var fromSlot = $(ui.draggable.closest(".app-icon"));

            var appData = phoneData.apps[fromSlot[0].dataset.app];
            fromSlot[0].dataset.title = appData.name;
            fromSlot.removeClass("hide");

            var toSlot = $(e.target.closest(".app-icon"));
            if (!toSlot) return;

            var toAppData = phoneData.apps[toSlot[0].dataset.app];

            // Do swap
            var fromIdx = phoneData.homescreen.indexOf(fromSlot[0].dataset.app);
            var toIdx = phoneData.homescreen.indexOf(toSlot[0].dataset.app);

            var temp = phoneData.homescreen[fromIdx];
            phoneData.homescreen[fromIdx] = phoneData.homescreen[toIdx];
            phoneData.homescreen[toIdx] = temp;

            fromSlot[0].dataset.title = toAppData.name;
            toSlot[0].dataset.title = appData.name;

            fromSlot.css({ "background-image": `url(${toAppData.icon})`, "background-color": "transparent", "background-position": "center", "background-size": "cover" });
            toSlot.css({ "background-image": `url(${appData.icon})`, "background-color": "transparent", "background-position": "center", "background-size": "cover" });
        },
    });

    $(".app-icon").click((e) => {
        var app = e.target.dataset.app;
        OpenApp(app, phoneData?.apps[app]?.args);
    });

    var phoneApplications = $(".phone-applications");
    phoneApplications.hide();
    phoneApplications.children().hide();
});

window.addEventListener("message", (e) => {
    var data = e.data;
    var action = data.action;

    // Allows iframes (app screens) to trigger functions
    if (action == "TRIGGER_FUNC") {
        const x = data.args.map((x) => {
            if (typeof x == "string") return `"${x}"`;
            if (typeof x == "object") return JSON.stringify(x);
        });

        eval(`${data.function}(${x.join(", ")})`);
    }
    // Send prompt response
    else if (action == "SEND_PROMPT_RESPONSE") {
        if (!phoneData.installedApps[data.source] && !phoneData.utilityApps[data.source]) return;

        var app = phoneData.installedApps[data.source]?.iframe;

        if (!app) app = phoneData.utilityApps[data.source]?.iframe;

        if (!app) return;

        app.contentWindow.postMessage({ action: "SEND_PROMPT_RESPONSE", phoneData: SerialiseData(), response: data.response }, "*");
    }
});
