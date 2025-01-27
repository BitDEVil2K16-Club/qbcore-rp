// DONT TOUCH
// This is currently WIP.
var phoneData = null

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
});

// DONT TOUCH ^
// APP LOGIC BELOW v
