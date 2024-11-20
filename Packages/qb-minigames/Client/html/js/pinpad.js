const pinContainer = document.querySelector(".pinpad-container"),
    pinBox = document.getElementById("PINbox");

let pinValue = "";
let correctSequence = [];

const openPinpad = (pinNumber) => {
    correctSequence = pinNumber.split("");
    pinBox.value = "";
    pinValue = "";
    pinContainer.style.display = "block";
    setTimeout(() => (pinContainer.style.opacity = 1), 300);
};

const closePinpad = async () => {
    pinContainer.style.opacity = 0;
    setTimeout(async () => {
        pinContainer.style.display = "none";
        try {
            await Events.Call("pinpadExit");
        } catch (err) {}
    }, 300);
};

const addNumber = (num) => {
    pinValue += num;
    pinBox.value += "*";

    if (pinValue.length === correctSequence.length) {
        checkSequence();
    }
};

const checkSequence = async () => {
    const isCorrect = pinValue === correctSequence.join("");
    pinValue = "";
    pinBox.value = "";

    try {
        if (isCorrect) {
            await Events.Call("pinpadFinish", true);
        } else {
            await Events.Call("pinpadFinish", false);
        }
    } catch (err) {}
    closePinpad();
};

const clearInput = () => {
    pinValue = "";
    pinBox.value = "";
};

document.addEventListener("DOMContentLoaded", () => {
    const pinButtonsContainer = document.getElementById("PINcode");
    const clearButton = document.getElementById("clearButton");

    pinButtonsContainer.addEventListener("click", (event) => {
        const button = event.target;
        if (button.classList.contains("PINbutton") && button.id !== "clearButton") {
            addNumber(button.value);
        }
    });

    clearButton.addEventListener("click", clearInput);
});

Events.Subscribe("KeyPress", function (key_name) {
    if (key_name === "BackSpace") {
        closePinpad();
    }
});

Events.Subscribe("openPinpad", function (numbers) {
    const pinNumber = numbers;
    const pinAsString = pinNumber.toString();
    openPinpad(pinAsString);
});
