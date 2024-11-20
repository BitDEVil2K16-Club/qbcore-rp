const NOTIFY_CONFIG = {
    VariantDefinitions: {
        success: {
            classes: "success",
            icon: "fa-circle-check",
        },
        primary: {
            classes: "primary",
            icon: "fa-circle-info",
        },
        warning: {
            classes: "warning",
            icon: "fa-circle-exclamation",
        },
        error: {
            classes: "error",
            icon: "fa-circle-xmark",
        },
        police: {
            classes: "police",
            icon: "fa-building-shield",
        },
        ambulance: {
            classes: "ambulance",
            icon: "fa-truck-medical",
        },
    },
};

const determineStyleFromVariant = (variant) => {
    const variantData = NOTIFY_CONFIG.VariantDefinitions[variant];
    if (!variantData) {
        throw new Error(`Style of type: ${variant}, does not exist in the config`);
    }
    return variantData;
};

const showNotif = (data) => {
    const { text, length, type, caption, icon: dataIcon } = data;
    let config = determineStyleFromVariant(type);

    const icon = dataIcon || config.icon;
    const classes = config.classes;

    const notifDiv = document.createElement("div");
    notifDiv.className = `notification ${classes}`;

    const iconElem = document.createElement("i");
    iconElem.className = `fas ${icon}`;

    const strongElem = document.createElement("strong");
    strongElem.textContent = caption;

    const pElem = document.createElement("p");
    pElem.textContent = text;

    notifDiv.appendChild(iconElem);
    notifDiv.appendChild(strongElem);
    notifDiv.appendChild(pElem);
    document.body.appendChild(notifDiv);

    setTimeout(() => {
        notifDiv.classList.add("show");
    }, 10);

    setTimeout(() => {
        notifDiv.classList.remove("show");
        setTimeout(() => {
            document.body.removeChild(notifDiv);
        }, 500);
    }, length || 3000);
};

Events.Subscribe("NOTIFY", (data) => {
    showNotif(data);
});
