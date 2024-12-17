let knownGameCoords = [
    [0, 0],
    [0, 0],
    [0, 0],
];
let knownImageCoords = [
    [0, 0],
    [0, 0],
    [0, 0],
];

const mapContainer = $(".minimap");
const playerIndicator = $(".minimap .player-indicator");

const mapSize = { width: mapContainer.width(), height: mapContainer.height() };
const minimapSize = { width: 260, height: 260 };

let persistentBlips = [];
let userBlips = [];
let currentPlayerCoords = { x: minimapSize.width / 2, y: minimapSize.height / 2 };
let isMinimapCircular = false;
let currentCameraRotation = 0;
let blinkingBlips = {};
let waypointIsBlinking = false;
let waypointBlinkInterval = null;
let waypointBlinkTimeout = null;
let minimapScale = 1;

// Show the minimap
const showMinimap = () => {
    $(".minimap-section").removeClass("hidden");
};

// Hide the minimap
const hideMinimap = () => {
    $(".minimap-section").addClass("hidden");
};

// Convert game coordinates to minimap coordinates using barycentric interpolation
const barycentricInterpolation = ({ x, y }) => {
    const [[x1, y1], [x2, y2], [x3, y3]] = knownGameCoords;
    const [[u1, v1], [u2, v2], [u3, v3]] = knownImageCoords;

    const w1 = ((y2 - y3) * (x - x3) + (x3 - x2) * (y - y3)) / ((y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - y3));
    const w2 = ((y3 - y1) * (x - x3) + (x1 - x3) * (y - y3)) / ((y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - y3));
    const w3 = 1 - w1 - w2;

    const u = w1 * u1 + w2 * u2 + w3 * u3;
    const v = w1 * v1 + w2 * v2 + w3 * v3;

    return { x: u, y: v };
};

// Check if a blip is within the minimap view
const isBlipInView = (blipX, blipY) => {
    const minimapX = currentPlayerCoords.x - (minimapSize.width * (1 / minimapScale)) / 2;
    const minimapY = currentPlayerCoords.y - (minimapSize.height * (1 / minimapScale)) / 2;

    return (
        blipX >= minimapX &&
        blipX <= minimapX + minimapSize.width * (1 / minimapScale) &&
        blipY >= minimapY &&
        blipY <= minimapY + minimapSize.height * (1 / minimapScale)
    );
};

// Recalculate blip position based on camera angle
const rotatePoint = (x, y, angle) => {
    const radians = (Math.PI / 180) * angle;
    const cos = Math.cos(radians);
    const sin = Math.sin(radians);

    const nx = cos * (x - minimapSize.width / 2) - sin * (y - minimapSize.height / 2) + minimapSize.width / 2;
    const ny = sin * (x - minimapSize.width / 2) + cos * (y - minimapSize.height / 2) + minimapSize.height / 2;

    return { x: nx, y: ny };
};

// Move a blip to the edge of a circular minimap
const moveBlipToEdgeCircular = (blipX, blipY, cameraRotation) => {
    let normalizedX = blipX - currentPlayerCoords.x;
    let normalizedY = blipY - currentPlayerCoords.y;

    const angle = Math.atan2(normalizedY, normalizedX) - (Math.PI / 180) * cameraRotation;
    const radius = minimapSize.width / 2;
    let edgeX = minimapSize.width / 2 + radius * Math.cos(angle);
    let edgeY = minimapSize.height / 2 + radius * Math.sin(angle);

    edgeY -= 20;

    return { x: edgeX, y: edgeY };
};

// Move a blip to the edge of a square minimap
const moveBlipToEdgeSquare = (blipX, blipY, cameraRotation) => {
    let normalizedX = blipX - currentPlayerCoords.x;
    let normalizedY = blipY - currentPlayerCoords.y;

    const angle = Math.atan2(normalizedY, normalizedX) - (Math.PI / 180) * cameraRotation;
    const distanceToEdge = Math.min(
        minimapSize.width / 2 / Math.abs(Math.cos(angle)),
        minimapSize.height / 2 / Math.abs(Math.sin(angle))
    );

    let edgeX = minimapSize.width / 2 + distanceToEdge * Math.cos(angle);
    let edgeY = minimapSize.height / 2 + distanceToEdge * Math.sin(angle);

    edgeY -= 20;

    return { x: edgeX, y: edgeY };
};

// Toggle minimap shape between square and circular
const toggleMinimapShape = (isCircular) => {
    isMinimapCircular = isCircular;
    mapContainer.css("border-radius", isCircular ? "100%" : "10px");
};

// Set blips on the minimap and adjust their positions
const setBlips = (blips, cameraRotation) => {
    persistentBlips = blips;
    const existingBlipIds = {};

    blips.forEach((blip) => {
        let { imgUrl, id } = blip;
        existingBlipIds[id] = true;
        let mapBlip = $(`.map-blip[data-id="${id}"]`);
        if (mapBlip.length === 0) {
            let blipHtml = `<img data-id="${id}" src="${imgUrl}" alt="" class="map-blip">`;
            $(".minimap .rotator-container>div:not(.player-indicator)").append(blipHtml);
            mapBlip = $(`.map-blip[data-id="${id}"]`);
        }

        let { x, y } = barycentricInterpolation(blip.coords);
        mapBlip.data("coords", JSON.stringify({ x: x, y: y }));

        let mapBlipWidth = mapBlip.width();
        let mapBlipHeight = mapBlip.height();

        x -= mapBlipWidth / 2;
        y -= mapBlipHeight / 2;

        const isInView = isBlipInView(x, y);
        if (!isInView) {
            const edgeCoords = isMinimapCircular
                ? moveBlipToEdgeCircular(x, y, cameraRotation)
                : moveBlipToEdgeSquare(x, y, cameraRotation);
            x = edgeCoords.x - mapBlipWidth / 2;
            y = edgeCoords.y - mapBlipHeight / 2;
            $("#blip-container .blip-container-relative").append(mapBlip);
        } else {
            y -= 20;
            if (!mapBlip.parent().is(".rotator-container>div:not(.player-indicator)")) {
                $(".rotator-container>div:not(.player-indicator)").append(mapBlip);
            }
        }

        mapBlip.css({
            left: x + "px",
            bottom: y + "px",
        });

        if (isInView) {
            const fixedCameraRotation = -cameraRotation;
            mapBlip.css({
                transform: `translate(-50%, -50%) rotate(${fixedCameraRotation}deg)`,
            });
        }
    });

    $(".map-blip").each(function () {
        const blipId = $(this).data("id");
        if (!existingBlipIds[blipId]) {
            $(this).remove();
        }
    });

    updateBlipPositions(cameraRotation);
};

// Center the minimap on the player coordinates and update the camera rotation
const goToCoords = (coords, cameraRotation) => {
    currentPlayerCoords = coords;

    let { x, y } = coords;

    let mapContainerWidth = mapContainer.width();
    let mapContainerHeight = mapContainer.height();

    let adjustedX = mapContainerWidth / 2 - x;
    let adjustedY = mapContainerHeight / 2 - y;

    $(".minimap .rotator-container>div:not(.player-indicator)").css({
        left: adjustedX,
        bottom: adjustedY,
    });

    $(".minimap .rotator-container").css({
        transform: `rotate(${cameraRotation}deg) scale(${minimapScale})`,
    });

    updateBlipPositions(cameraRotation);
};

// Set the player's heading on the minimap
const setPlayerHeading = (playerHeading) => {
    let fixedHeading = playerHeading;

    playerIndicator.css({
        transform: `translate(-50%, 50%) rotate(${fixedHeading}deg) rotate(-300deg) scale(${1 / minimapScale})`,
    });
};

// Set the waypoint on the minimap
const setWaypoint = (waypoint) => {
    $(".waypoint-marker").remove();

    if (!waypoint || !waypoint.coords) return;

    let { x, y } = barycentricInterpolation(waypoint.coords);

    let waypointMarker = $('<div>', {
        class: 'waypoint-marker',
    });

    $(".rotator-container>div").append(waypointMarker);
    waypointMarker.data("coords", JSON.stringify({ x: x, y: y }));

    const isInView = isBlipInView(x, y);

    if (!isInView) {
        const edgeCoords = isMinimapCircular
            ? moveBlipToEdgeCircular(x, y, currentCameraRotation)
            : moveBlipToEdgeSquare(x, y, currentCameraRotation);
        x = edgeCoords.x;
        y = edgeCoords.y;
        $("#blip-container .blip-container-relative").append(waypointMarker);
    }

    waypointMarker.css({
        left: x + "px",
        bottom: y + "px",
        transform: `translate(-50%, -50%) rotate(${-currentCameraRotation}deg) scale(${1 / minimapScale})`,
    });

    if (waypointIsBlinking) {
        waypointMarker.addClass('blinking');
    }
};

// Remove waypoint from minimap
function removeWaypoint() {
    if (waypointBlinkInterval) {
        clearInterval(waypointBlinkInterval);
        waypointBlinkInterval = null;
    }
    if (waypointBlinkTimeout) {
        clearTimeout(waypointBlinkTimeout);
        waypointBlinkTimeout = null;
    }
    $(".waypoint-marker").remove();
}

const updateBlipPositions = (cameraRotation) => {
    $(".map-blip, .waypoint-marker").each(function () {
        const blipData = $(this).data("coords");
        if (blipData) {
            const blipCoords = JSON.parse(blipData);

            const isInView = isBlipInView(blipCoords.x, blipCoords.y);

            let x, y;
            if (!isInView) {
                const edgeCoords = isMinimapCircular
                    ? moveBlipToEdgeCircular(blipCoords.x, blipCoords.y, cameraRotation)
                    : moveBlipToEdgeSquare(blipCoords.x, blipCoords.y, cameraRotation);
                x = edgeCoords.x - $(this).width() / 2;
                y = edgeCoords.y - $(this).height() / 2;
                $("#blip-container .blip-container-relative").append($(this));
                $(this).css({ transform: "translate(0%, -100%)" });
            } else {
                x = blipCoords.x - $(this).width() / 2;
                y = blipCoords.y - $(this).height() / 2 - 20;
                const fixedCameraRotation = -cameraRotation;
                $(this).css({
                    transform: `translate(-50%, -50%) rotate(${fixedCameraRotation}deg) scale(${1/minimapScale})`,
                });

                if ($(this).is(".waypoint-marker")) {
                    $(this).css({
                        transform: `translate(0%, -30%) rotate(${fixedCameraRotation}deg) scale(${1/minimapScale})`,
                    });
                }

                y += 20;

                if (!$(this).parent().is(".rotator-container>div:not(.player-indicator)")) {
                    $(".rotator-container>div:not(.player-indicator)").append($(this));
                }
            }

            $(this).css({
                left: x + "px",
                bottom: y + "px",
            });
            
        }
    });
};

function startBlinkingBlip(blipId) {
    if (blinkingBlips[blipId]) return;

    function tryStartBlinking() {
        let blipElement = $(`.map-blip[data-id="${blipId}"]`);
        console.log(`Buscando blip con ID: ${blipId}. Encontrado: ${blipElement.length > 0}`);
        if (blipElement.length > 0) {
            console.log(`Iniciando parpadeo del blip con ID: ${blipId}`);
            let isVisible = true;

            let blinkInterval = setInterval(() => {
                blipElement.css('opacity', isVisible ? '0.4' : '1');
                isVisible = !isVisible;
            }, 500);

            let blinkTimeout = setTimeout(() => {
                clearInterval(blinkInterval);
                blipElement.css('opacity', '1');
                delete blinkingBlips[blipId];
                console.log(`Parpadeo terminado para blip ID: ${blipId}`);
            }, 5000);

            blinkingBlips[blipId] = { timeout: blinkTimeout, interval: blinkInterval };
        } else {
            console.log(`Blip con ID: ${blipId} no encontrado, reintentando...`);
            setTimeout(tryStartBlinking, 100);
        }
    }

    tryStartBlinking();
}

function stopBlinkingBlip(blipId) {
    if (blinkingBlips[blipId]) {
        clearTimeout(blinkingBlips[blipId].timeout);
        clearInterval(blinkingBlips[blipId].interval);
        let blipElement = $(`.map-blip[data-id="${blipId}"]`);
        blipElement.css('opacity', '1');
        delete blinkingBlips[blipId];
    }
}

function startBlinkingWaypoint() {
    if (waypointBlinkTimeout) return;

    let waypointMarker = $(".waypoint-marker");
    if (waypointMarker.length > 0) {
        console.log("Iniciando parpadeo del waypoint");
        let isVisible = true;

        waypointBlinkInterval = setInterval(() => {
            waypointMarker.css('opacity', isVisible ? '0.4' : '1');
            isVisible = !isVisible;
        }, 500);

        waypointBlinkTimeout = setTimeout(() => {
            clearInterval(waypointBlinkInterval);
            waypointMarker.css('opacity', '1');
            waypointBlinkInterval = null;
            waypointBlinkTimeout = null;
            console.log("Parpadeo del waypoint terminado");
        }, 5000);
    } else {
        console.log("Waypoint no encontrado, reintentando...");
        setTimeout(startBlinkingWaypoint, 100);
    }
}

// Set initial blips and minimap shape
const hardcodedBlips = [];
setBlips(hardcodedBlips, 0);
toggleMinimapShape(false);

Events.Subscribe("ToggleShape", (isCircular) => {
    toggleMinimapShape(isCircular);
});

Events.Subscribe("UpdatePlayerPos", (playerCoordsX, playerCoordsY, playerHeading, cameraRotation) => {
    currentCameraRotation = -cameraRotation - 90;
    let playerCoords = { x: playerCoordsX, y: playerCoordsY };
    let { x, y } = barycentricInterpolation(playerCoords);
    setPlayerHeading(playerHeading);
    goToCoords({ x, y }, currentCameraRotation);
});

Events.Subscribe("SetKnownCoords", (gameCoords, imageCoords) => {
    knownGameCoords = gameCoords;
    knownImageCoords = imageCoords;
    console.log(knownGameCoords, knownImageCoords);
});

Events.Subscribe("SetWaypoint", (waypointBlip) => {
    setWaypoint(waypointBlip);
});

Events.Subscribe("RemoveWaypoint", () => {
    removeWaypoint();
});

Events.Subscribe("SetMinimapShape", (shape) => {
    const isCircular = shape === "circle";
    toggleMinimapShape(isCircular);
});

Events.Subscribe("SetBlips", (blips) => {
    setBlips(blips, 0);
});

Events.Subscribe("RemoveBlip", function (id) {
    hardcodedBlips = hardcodedBlips.filter((blip) => blip.id !== id);
    setBlips(hardcodedBlips, 0);
});

Events.Subscribe("SetPosition", (position) => {
    switch (position) {
        case 0:
            $(".minimap-section").attr("data-position", "top-left");
            break;
        case 1:
            $(".minimap-section").attr("data-position", "top-right");
            break;
        case 2:
            $(".minimap-section").attr("data-position", "bottom-left");
            break;
        case 3:
            $(".minimap-section").attr("data-position", "bottom-right");
            break;
    }
});

Events.Subscribe("BlinkBlip", function (blipId) {
    console.log(`Evento BlinkBlip recibido para blip ID: ${blipId}`);
    startBlinkingBlip(blipId);
});

Events.Subscribe("BlinkWaypoint", function() {
    startBlinkingWaypoint();
});

Events.Subscribe("SetMinimapScale", (scale) => {
    minimapScale = scale;
});
