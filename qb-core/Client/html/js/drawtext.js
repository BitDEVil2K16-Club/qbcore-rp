const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const resetClasses = (element, classes) => {
    classes.forEach((cls) => {
        if (element) {
            element.classList.remove(cls);
        }
    });
};

const addClass = (element, name) => {
    if (element && !element.classList.contains(name)) {
        element.classList.add(name);
    }
};

const drawText = async (text, position = "left") => {
    const textElement = document.getElementById("text");
    if (!textElement) return;
    addClass(textElement, position);
    textElement.innerHTML = text;
    document.getElementById("drawtext-container").style.display = "block";
    await sleep(100);
    addClass(textElement, "show");
};

const changeText = async (text, position = "left") => {
    const textElement = document.getElementById("text");
    if (!textElement) return;
    resetClasses(textElement, ["show", "left", "right", "top", "bottom", "hide", "pressed"]);
    addClass(textElement, "pressed");
    addClass(textElement, "hide");
    await sleep(500);
    addClass(textElement, position);
    textElement.innerHTML = text;
    await sleep(100);
    addClass(textElement, "show");
};

const hideText = async () => {
    const textElement = document.getElementById("text");
    if (!textElement) return;
    resetClasses(textElement, ["show", "left", "right", "top", "bottom", "hide", "pressed"]);
    document.getElementById("drawtext-container").style.display = "none";
};

const keyPressed = () => {
    const textElement = document.getElementById("text");
    if (!textElement) return;
    addClass(textElement, "pressed");
};

Events.Subscribe("DRAW_TEXT", (text, position) => {
    if (typeof text === "string" && typeof position === "string") {
        drawText(text, position);
    }
});

Events.Subscribe("CHANGE_TEXT", (text, position) => {
    if (typeof text === "string" && typeof position === "string") {
        changeText(text, position);
    }
});

Events.Subscribe("HIDE_TEXT", () => {
    hideText();
});

Events.Subscribe("KEY_PRESSED", () => {
    keyPressed();
});
