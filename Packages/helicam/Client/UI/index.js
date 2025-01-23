const speedElement = document.getElementById("speed");
const elevationElement = document.getElementById("elevation");
const timeElement = document.getElementById("time");
const headingElement = document.getElementById("heading");

Events.Subscribe("UpdateHUD", (speed, elevation, time, compass) => {
    speedElement.textContent = "Speed: " + speed;
    elevationElement.textContent = "Elevation: " + elevation;
    timeElement.textContent = "Time: " + time;
    headingElement.textContent = "Heading: " + compass;
});
