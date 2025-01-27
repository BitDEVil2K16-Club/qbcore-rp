// Utility functions
const clamp = (num, min, max) => Math.min(Math.max(num, min), max);
const onAnimStop = (anim, fnc) => {
  window.removeEventListener("finish", anim);
  fnc();
};

// Phone data
var phoneData = {
  phoneNumber: "0851124556",

  messages: {
    ['0892301156'] : [
        {
            sender: true,
            content: "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Libero, voluptatem."
        },
        {
            sender: false,
            content: "Lorem ipsum dolor sit, amet."
        },
    ]
  },

  contacts: {
    ['0892301156'] : {
        name: "Kell",
        icon: null
    }
  },

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

  appbar: [
    "contacts",
    "phone",
    "camera",
  ],

  installedApps: {
    camera: {},
    message: {},
    contacts: {},
  },

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

  apps: {}
};

// DOM Elements
const phoneIsland = $(".notification");
const homeButton = $(".phone_home_button");
const phoneContainer = $(".phone-container");

const phoneOverlay = $(".phone--screen--overlay");
const controlPanel = $(".phone--control--panel");

const hotbarIcons = $('.hotbar-apps');
const phoneBattery = document.querySelector("svg > path:nth-child(3)")

hotbarIcons.css('display', 'flex').hide()
console.log(phoneBattery)

var phoneApplications = $(".phone-applications");

var focalButtons = $(".focal--action");

var audioSlider = document.querySelector("#audio__slider");
var audioSliderFill = audioSlider.querySelector(".slider");

var brightnessSlider = document.querySelector("#brightness__slider");
var brightnessSliderFill = brightnessSlider.querySelector(".slider");

var controlPanelMouseDown = false;
var controlPanelMouseData = {};

var activeApp = undefined;

const showLockscreen = () => {
  phoneApplications.hide()
  var island = phoneIsland[0];

  phoneIsland.stop()
  island.animate(
    [
      {
        right: "0",
        left: "-16px",
      },
    ],
    {
      duration: 300,
      fill: "forwards",
    }
  );
};

const UpdateBrightness = (percent) => {
  phoneData.brightness = percent / 100;
  brightnessSliderFill.style.height = `${percent}%`;
  phoneContainer[0].style.filter = `brightness(${clamp(
    percent * 1.05,
    20,
    150
  )}%)`;
};

const ReturnHome = () => {
  if (activeApp)
  {
    var app = $(phoneData.installedApps[activeApp].iframe)
    var icon = $(phoneData.installedApps[activeApp].app)

    // left = offsetLeft, height = offsetTop + offsetHeight
    app.css('transform-origin', `26px 140px`)

    app.css('transform', 'scale(0.15)')
    app.fadeOut('fast');
    
    activeApp = undefined;
  }

  phoneApplications.css("background", "transparent");
  setTimeout(() => {
    phoneApplications.find('[data-app="home"]').show();
    homeButton.hide();
    hotbarIcons.show()
  }, 150)
}

const UpdateAudio = (percent) => {
  phoneData.volume = percent / 100;
  audioSliderFill.style.height = `${percent}%`;
};

const openControlPanel = () => {
  phoneOverlay.hide();
  phoneOverlay.addClass("blur");
  phoneOverlay.fadeIn();
  controlPanel.addClass("control--panel--opened");

  controlPanel.find('[data-utility]').each((idx, el) => {
    phoneData.settings[el.dataset.utility] ? $(el).addClass('active') : $(el).removeClass('active')
  })
};

const closeControlPanel = () => {
  phoneOverlay.show();
  controlPanel.removeClass("control--panel--opened");
  phoneOverlay.fadeOut("fast");
};

const showNotification = (appName, notificationMsg) => {
  var island = phoneIsland[0];
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

  phoneIsland.stop()
  island.animate(
    [
      {
        right: "-93px",
        left: "-93px",
        height: "60px",
        easing: "cubic-bezier(0.87, 0, 0.13, 1)",
      },
    ],
    {
      duration: 100,
      fill: "forwards",
    }
  );

  phoneIsland.children().hide();
  phoneIsland.children().fadeIn("slow");

  $("#phone-icons").fadeOut("fast");

  setTimeout(() => {

    island.animate(
      [
        {
          right: "0",
          left: "0",
        }
      ],
      {
        duration: 150,
        fill: "forwards"
      }
    );
  
    setTimeout(() => {
      island.animate([
        {
          height: "0",
        }
      ], {
        duration: 150,
        fill: "forwards"
      })
    }, 50)
  
    phoneIsland.removeClass("expanded--max");
    phoneIsland.children().fadeOut();
    phoneIsland.html("");
    
    $("#phone-icons").fadeIn("fast");
  }, 3500)

}

const showCallingNotification = () => {
  var island = phoneIsland[0];

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

  phoneIsland.stop()
  island.animate(
    [
      {
        right: "-93px",
        left: "-93px",
        height: "60px",
        easing: "cubic-bezier(0.87, 0, 0.13, 1)",
      },
    ],
    {
      duration: 100,
      fill: "forwards",
    }
  );

  
  phoneIsland.children().hide();

  setTimeout(() => {
    phoneIsland.children().fadeIn("slow");
    $("#phone-icons").fadeOut("fast");
  }, 50)
};

const hideCallingNotification = () => {
  var island = phoneIsland[0];

  phoneIsland.removeClass("expanded--max");
  phoneIsland.children().fadeOut();
  phoneIsland.html("");

  phoneIsland.stop();

  island.animate(
    [
      {
        right: "0",
        left: "0",
      }
    ],
    {
      duration: 150,
      fill: "forwards"
    }
  );

  setTimeout(() => {
    island.animate([
      {
        height: "0",
      }
    ], {
      duration: 150,
      fill: "forwards"
    })
  }, 50)

  $("#phone-icons").fadeIn("fast");
};

$(".focal-length").click((e) => {
  var focalButton = e.target.closest(".focal--action");
  if (focalButton == null) return;
  focalButtons.removeClass("selected");
  $(focalButton).addClass("selected");
});

$(window.document).click(e => {
  console.log(e)
})

$(".phone-lockscreen").click((e) => {
  var lockscreen = $(".phone-lockscreen")[0];

  var animation = lockscreen.animate(
    [
      {
        top: "-100%",
        backdropFilter: "brightness(1.0)",
      },
    ],
    {
      duration: 300,
      fill: "forwards",
    }
  );

  animation.addEventListener("finish", () =>
    onAnimStop(animation, () => {
      $(".phone-lockscreen").fadeOut();
    })
  );

  phoneApplications.fadeIn();
  phoneContainer.removeClass("locked");

  phoneIsland.stop()
  var island = phoneIsland[0];

  island.animate(
    [
      {
        right: "0",
        left: "0",
      },
    ],
    {
      duration: 300,
      fill: "forwards",
    }
  );

  $(".lock--indicator").fadeOut("fast");

  ReturnHome()
});

$(window).mouseup((e) => {
  if (controlPanelMouseDown) {
    controlPanelMouseDown = false;

    var newY = e.clientY;

    var dist = newY - controlPanelMouseData.y;

    controlPanelMouseData = {};
    if (dist <= 50) return;

    openControlPanel();
  }
});
$(".phone-header").mousedown((e) => {
  controlPanelMouseDown = true;
  controlPanelMouseData.y = e.clientY;
});

homeButton.click(e => {
  ReturnHome()
})

$(".phone--control--panel").click((e) => {
  if (e.target === e.currentTarget) closeControlPanel();
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
showLockscreen();

var incomingCallId = undefined;

var phoneAudio = new Howl({
  src: ['./sounds/ringtones/ringtone.wav'],
  autoplay: false,
  loop: true,
  volume: 0.5
});

Events.Subscribe('ReceivePhoneCall', (number, callID) => {
  incomingCallId = callID;

  console.log(incomingCallId, callID)

  if (phoneContainer.hasClass('hide--phone'))
  {
    phoneContainer.removeClass('hide--phone')
    phoneContainer.addClass('phone--call')
    phoneContainer.addClass('show--notification')
  }
  
  phoneAudio.play()
  showCallingNotification()
})

Events.Subscribe('RejectPhoneCall', (number, callID) => {
  if (callID !== incomingCallId) return;
  
  incomingCallId = undefined;
  
  phoneContainer.addClass('hide--phone')
  phoneContainer.removeClass('phone--call')
  phoneContainer.removeClass('show--notification')
  
  hideCallingNotification()
  phoneAudio.stop()
  
})

Events.Subscribe('OpenPhone', () => {
  phoneContainer.removeClass('hide--phone')
  phoneContainer.removeClass('show--notification')
})

Events.Subscribe('ClosePhone', () => {
  if (incomingCallId)
    phoneContainer.addClass('show--notification')
  else
    phoneContainer.addClass('hide--phone')
})

Events.Subscribe('SetupApps', (phoneApps, savedData) => {
  console.log('setup app')

  // Setup app data
  Object.entries(phoneApps).forEach(([ key, object ]) => {
    if (!object.icon)
      phoneApps[key].icon = `img/app-icons/${key}.png`
    if (!object.ui)
      phoneApps[key].ui = `apps/${key}.html`
  })

  phoneData.apps = phoneApps

  // If not saved data setup default apps
  console.log(savedData)
  if (!savedData)
  {
    $('.installed-apps').empty()

    var slots = 1
    Object.entries(phoneApps).forEach(([key, object]) => {
      var app = $(`<div class="app-icon" style="background-image: url(${object.icon}); background-color: transparent; background-position: center; background-size: cover;" data-app="${key}" data-title="${object.name}" data-position="${slots}"></div>`)
      if (!object.blocked)
      {
        var iframe = $(`<iframe data-app="${key}" src="${object.ui}" frameborder="0"></iframe>`);
        $('.phone-applications').append(iframe);
        phoneData.installedApps[key] = { iframe: iframe[0], app: app[0] }
      }
      
      $('.installed-apps').append(app)
      
      slots++;
    })
  }

  var draggingApp = false
  
  $('.app-icon').draggable({
    helper: 'clone',
    appendTo: '.phone-container',
    revert: 'invalid',
    revertDuration: 250,
    delay: 150,
    start: function (event, ui) {
      draggingApp = true
      $(event.currentTarget).addClass('hide')
      event.currentTarget.dataset.title = ''
  
      $(ui.helper).css('width', '48px')
      $(ui.helper).css('height', '48px')
      $(ui.helper).css('z-index', '9999')
      $(ui.helper).css('background-size', 'contain')
    },
    stop: function (event, ui) { 
      if (!draggingApp) return;
      // Only triggers if the app isnt swapped with an existing app
      var app = $(this)

      var appData = phoneData.apps[app[0].dataset.app];
      app[0].dataset.title = appData.name
      app.removeClass('hide')

    },
  })
  
  $('.app-icon').droppable({
    drop: (e, ui) => {
      draggingApp = false
      var fromSlot = $(ui.draggable.closest('.app-icon'));

      var appData = phoneData.apps[fromSlot[0].dataset.app];
      fromSlot[0].dataset.title = appData.name
      fromSlot.removeClass('hide')
      
      var toSlot = $(e.target.closest('.app-icon'));
      if (!toSlot) return;
      
      // Do swap
    }
  })

  $(".app-icon").click((e) => {
    var app = e.target;
    if (!phoneData?.installedApps[app.dataset.app]) return showNotification("System", "This app is still in development!");
    
    homeButton.fadeIn();
    phoneApplications.css("background", "var(--sys-bg)");
    
    activeApp = app.dataset.app
    
    var appData = phoneData.installedApps[activeApp]
    var _app = $(appData.iframe)
    
    hotbarIcons.hide();
    phoneApplications.find('[data-app="home"]').hide();

    _app.fadeIn();
    _app.css('transform', 'scale(1.0)');
    
    // On App Load
    console.log(phoneData)
    var serialized = JSON.parse(JSON.stringify({phoneData}))
    _app[0].contentWindow.postMessage(serialized, '*');
  
  });

  var phoneApplications = $(".phone-applications");
  phoneApplications.hide();
  phoneApplications.children().hide();
})