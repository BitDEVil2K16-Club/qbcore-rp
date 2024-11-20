let buttonParams = [];

const openMenu = (data = null) => {
    let html = "";
    data.forEach((item, index) => {
        if (!item.hidden) {
            let header = item.header;
            let message = item.txt || item.text;
            let isMenuHeader = item.isMenuHeader;
            let isDisabled = item.disabled;
            let icon = item.icon;
            html += getButtonRender(header, message, index, isMenuHeader, isDisabled, icon);
            if (item.params) buttonParams[index] = item.params;
        }
    });

    document.getElementById("buttons").innerHTML = html;

    document.querySelectorAll(".button").forEach((button) => {
        button.addEventListener("click", function () {
            if (!this.classList.contains("title") && !this.classList.contains("disabled")) {
                postData(this.getAttribute("id"));
            }
        });
    });
};

const getButtonRender = (header, message = null, id, isMenuHeader, isDisabled, icon) => {
    return `
        <div class="${isMenuHeader ? "title" : "button"} ${isDisabled ? "disabled" : ""}" id="${id}">
            <div class="icon"> <img src=${icon} width=30px onerror="this.onerror=null; this.remove();"> <i class="${icon}" onerror="this.onerror=null; this.remove();"></i> </div>
            <div class="column">
            <div class="header"> ${header}</div>
            ${message ? `<div class="text">${message}</div>` : ""}
            </div>
        </div>
    `;
};

const closeMenu = () => {
    document.getElementById("buttons").innerHTML = " ";
    buttonParams = [];
};

const postData = (id) => {
    Events.Call("clickedButton", JSON.stringify(parseInt(id) + 1));
    return closeMenu();
};

const cancelMenu = () => {
    Events.Call("closeMenu");
    return closeMenu();
};

Events.Subscribe("OPEN_MENU", openMenu);
Events.Subscribe("CLOSE_MENU", closeMenu);
Events.Subscribe("SHOW_HEADER", openMenu);
