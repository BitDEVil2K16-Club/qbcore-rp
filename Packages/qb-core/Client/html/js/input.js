let formInputs = {};

const OpenMenu = (data) => {
    if (data == null || data == "") {
        return null;
    }

    document.querySelector(".main-wrapper").style.display = "block";

    let form = ["<form id='qb-input-form'>", `<div class="heading">${data.header != null ? data.header : "Form Title"}</div>`];

    data.data.inputs.forEach((item, index) => {
        switch (item.type) {
            case "text":
                form.push(renderTextInput(item));
                break;
            case "password":
                form.push(renderPasswordInput(item));
                break;
            case "number":
                form.push(renderNumberInput(item));
                break;
            case "radio":
                form.push(renderRadioInput(item));
                break;
            case "select":
                form.push(renderSelectInput(item));
                break;
            case "checkbox":
                form.push(renderCheckboxInput(item));
                break;
            case "color":
                form.push(renderColorInput(item));
                break;
            default:
                form.push(`<div class="label">${item.text}</div>`);
        }
    });
    form.push(`<div class="footer"><button type="submit" class="btn btn-success" id="submit">${data.submitText ? data.submitText : "Submit"}</button></div>`);

    form.push("</form>");

    document.querySelector(".main-wrapper").innerHTML = form.join(" ");

    document.querySelector("#qb-input-form").addEventListener("change", function (event) {
        if (event.target.getAttribute("type") == "checkbox") {
            const value = event.target.checked ? "true" : "false";
            formInputs[event.target.getAttribute("value")] = value;
        } else {
            formInputs[event.target.getAttribute("name")] = event.target.value;
        }
    });

    document.querySelector("#qb-input-form").addEventListener("submit", async function (event) {
        if (event != null) {
            event.preventDefault();
        }
        //Events.Call("buttonSumbit", JSON.stringify({ data: formInputs }));
        Events.Call("buttonSumbit", formInputs);
        CloseMenu();
    });
};

const renderTextInput = (item) => {
    const { text, name } = item;
    formInputs[name] = item.default ? item.default : "";
    const isRequired = item.isRequired == "true" || item.isRequired ? "required" : "";
    const defaultValue = item.default ? `value="${item.default}"` : "";

    return ` <input placeholder="${text}" type="text" class="form-control" name="${name}" ${defaultValue} ${isRequired}/>`;
};
const renderPasswordInput = (item) => {
    const { text, name } = item;
    formInputs[name] = item.default ? item.default : "";
    const isRequired = item.isRequired == "true" || item.isRequired ? "required" : "";
    const defaultValue = item.default ? `value="${item.default}"` : "";

    return ` <input placeholder="${text}" type="password" class="form-control" name="${name}" ${defaultValue} ${isRequired}/>`;
};
const renderNumberInput = (item) => {
    try {
        const { text, name } = item;
        formInputs[name] = item.default ? item.default : "";
        const isRequired = item.isRequired == "true" || item.isRequired ? "required" : "";
        const defaultValue = item.default ? `value="${item.default}"` : "";

        return `<input placeholder="${text}" type="number" class="form-control" name="${name}" ${defaultValue} ${isRequired}/>`;
    } catch (err) {
        return "";
    }
};

const renderRadioInput = (item) => {
    const { options, name, text } = item;
    formInputs[name] = options[0].value;

    let div = `<div class="form-input-group"> <div class="form-group-title">${text}</div>`;
    div += '<div class="input-group">';
    options.forEach((option, index) => {
        div += `<label for="radio_${name}_${index}"> <input type="radio" id="radio_${name}_${index}" name="${name}" value="${option.value}"
                ${(item.default ? item.default == option.value : index == 0) ? "checked" : ""}> ${option.text}</label>`;
    });

    div += "</div>";
    div += "</div>";
    return div;
};

const renderCheckboxInput = (item) => {
    const { options, name, text } = item;

    let div = `<div class="form-input-group"> <div class="form-group-title">${text}</div>`;
    div += '<div class="input-group-chk">';

    options.forEach((option, index) => {
        div += `<label for="chk_${name}_${index}">${option.text} <input type="checkbox" id="chk_${name}_${index}" name="${name}" value="${option.value}" ${option.checked ? "checked" : ""}></label>`;
        formInputs[option.value] = option.checked ? "true" : "false";
    });

    div += "</div>";
    div += "</div>";
    return div;
};

const renderSelectInput = (item) => {
    const { options, name, text } = item;
    let div = `<div class="select-title">${text}</div>`;

    div += `<select class="form-select" name="${name}" title="${text}">`;
    formInputs[name] = options[0].value;

    options.forEach((option, index) => {
        const isDefaultValue = item.default == option.value;
        div += `<option value="${option.value}" ${isDefaultValue ? "selected" : ""}>${option.text}</option>`;
        if (isDefaultValue) {
            formInputs[name] = option.value;
        }
    });
    div += "</select>";
    return div;
};

const renderColorInput = (item) => {
    const { text, name } = item;
    formInputs[name] = item.default ? item.default : "#ffffff";
    const isRequired = item.isRequired == "true" || item.isRequired ? "required" : "";
    const defaultValue = item.default ? `value="${item.default}"` : "";
    return ` <input placeholder="${text}" type="color" class="form-control" name="${name}" ${defaultValue} ${isRequired}/>`;
};

const CloseMenu = () => {
    document.querySelector(".main-wrapper").style.display = "none";
    document.querySelector("#qb-input-form").remove();
    formInputs = {};
};

const SetStyle = (style) => {
    var link = document.createElement("link");
    link.rel = "stylesheet";
    link.type = "text/css";
    link.href = `./styles/${style}.css`;
    document.head.appendChild(link);
};

const CancelMenu = () => {
    Events.Call("CLOSE_INPUT");
    return CloseMenu();
};

Events.Subscribe("OPEN_INPUT", OpenMenu);
Events.Subscribe("CLOSE_INPUT", CloseMenu);
