var phoneData = null

const OnAppStart = (e) => {
    $('.messages-list').empty()
    $(".message--header").hide();
    $(".message--footer").hide();

    Object.entries(phoneData.messages).forEach(([number, messages]) => {
        $('.messages-list').append(`
        <div class="message--index" data-number=${number}>
            <div class="avatar"></div>
            <div class="content">
                <div class="top">
                    <div class="subject">
                        ${phoneData.contacts[number] ? phoneData.contacts[number].name : number }
                    </div>
                    <div class="message--date">
                        Yesterday
                    </div>
                </div>
                <div class="message">
                    ${phoneData.messages[number][phoneData.messages[number].length - 1].content}
                </div>
            </div>
        </div>
        `)
    })
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

$(window).click((e) => {
    var target = e.target.closest('.message--index')
    if (target)
    {
        $(".message--header").fadeIn();
        $(".message--footer").fadeIn();
        $(".message--list").empty();

        $(".message--list")[0].animate(
          [
            {
              left: "0",
            },
          ],
          {
            duration: 150,
            fill: "forwards",
          }
        );

        var messageNumber = target.dataset.number

        $(".contact--info .contact--name").text(phoneData.contacts[messageNumber]?.name || messageNumber)
        phoneData.messages[messageNumber].forEach(x => {
            var temp = `
            <div class="message ${x.sender && 'sender'}">
                ${x.content}
            </div>
            `

            $('.message--list').append(temp)
        })
    }
});