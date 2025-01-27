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

$(window).click((e) => {
    var backButton = e.target.closest(".go--back")
    if (backButton)
    {
        $(".message--list")[0].animate(
          [
            {
              left: "100%",
            },
          ],
          {
            duration: 150,
            fill: "forwards",
          }
        );
      
        $(".message--header").fadeOut("fast");
        $(".message--footer").fadeOut("fast");
    }
  });