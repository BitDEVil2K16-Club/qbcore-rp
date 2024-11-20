var QBRadialMenu = null;
var toggleConfig = false;
var keybindConfig = false;

Events.Subscribe("ui", (radial, items, toggle, keybind) => {
    toggleConfig = toggle;
    keybindConfig = keybind;
    if (radial) {
        createMenu(items);
        QBRadialMenu.open();
    } else {
        QBRadialMenu.close(true);
    }
});

function createMenu(items) {
    QBRadialMenu = new RadialMenu({
        parent: document.body,
        size: 375,
        menuItems: items,
        onClick: function (item) {
            if (item.shouldClose) {
                QBRadialMenu.close(true);
            }
            if (item.items == null && item.shouldClose != null) {
                Events.Call("selectItem", item);
            }
        },
    });
}
