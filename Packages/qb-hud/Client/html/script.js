const { createApp, ref, onMounted } = Vue;

const app = createApp({
    setup() {
        const showAll = ref(false);
        // money
        const cash = ref(0);
        const bank = ref(0);
        const amount = ref(0);
        const plus = ref(false);
        const minus = ref(false);
        const showUpdate = ref(false);
        const showCash = ref(false);
        const showBank = ref(false);
        // player hud
        const health = ref(100);
        const armor = ref(100);
        const hunger = ref(100);
        const thirst = ref(100);
        const stress = ref(0);
        const voice = ref(2.5);
        const talking = ref(false);
        // vehicle
        const speed = ref(0);
        const fuel = ref(100);
        const fuelgauge = ref(100);
        const seatbelt = ref(false);
        const cruise = ref(false);
        const showSpeedometer = ref(false);
        // weapon
        const ammoClip = ref(0);
        const ammoBag = ref(0);
        const showWeapon = ref(false);
        // Color properties
        const talkingColor = ref("#FFFFFF");
        const healthColor = ref("#3FA554");
        const armorColor = ref("#326dbf");
        const hungerColor = ref("#dd6e14");
        const thirstColor = ref("#1a7cad");
        const fuelColor = ref("#FFFFFF");

        function formatMoney(value) {
            const formatter = new Intl.NumberFormat("en-US", {
                style: "currency",
                currency: "USD",
                minimumFractionDigits: 0,
            });
            let money = formatter.format(value);
            let parts = money.split("$");
            return parts[0] + '<span id="sign">$ </span>' + parts[1];
        }

        function handleVisibility(refName, show, duration) {
            if (refName.timeoutId) clearTimeout(refName.timeoutId);
            refName.value = show;
            if (show) {
                refName.timeoutId = setTimeout(() => {
                    refName.value = false;
                }, duration);
            }
        }

        function updateHudData(newhealth, newarmor, newhunger, newthirst, newstress, playerDead) {
            showAll.value = true;

            if (newhealth !== undefined) {
                health.value = newhealth;
                healthColor.value = playerDead ? "#ff0000" : "#3FA554";
                if (playerDead) health.value = 100;
            }

            if (newarmor !== undefined) {
                armor.value = newarmor;
                armorColor.value = newarmor <= 0 ? "#FF0000" : "#326dbf";
            }

            if (newhunger !== undefined) {
                hunger.value = newhunger;
                hungerColor.value = newhunger <= 30 ? "#ff0000" : "#dd6e14";
            }

            if (newthirst !== undefined) {
                thirst.value = newthirst;
                thirstColor.value = newthirst <= 30 ? "#ff0000" : "#1a7cad";
            }

            if (newstress !== undefined) {
                stress.value = newstress;
            }
        }

        function UpdateMoney(cashAmount, bankAmount, amount, isMinus, type) {
            amount.value = amount;
            if (isMinus) {
                minus.value = true;
            } else {
                plus.value = true;
            }
            if (type === "cash") {
                cash.value = formatMoney(cashAmount);
                handleVisibility(showCash, true, 2000);
            } else if (type === "bank") {
                bank.value = formatMoney(bankAmount);
                handleVisibility(showBank, true, 2000);
            }
            handleVisibility(showUpdate, true, 2000);
        }

        function ShowCashAmount(amount) {
            if (amount !== undefined) {
                cash.value = formatMoney(amount);
                handleVisibility(showCash, true, 2000);
            }
        }

        function ShowBankAmount(amount) {
            if (amount !== undefined) {
                bank.value = formatMoney(amount);
                handleVisibility(showBank, true, 2000);
            }
        }

        function ShowSpeedometer(bool) {
            showSpeedometer.value = bool;
        }

        function UpdateVehicleStats(speedAmount, fuelAmount) {
            speed.value = Math.floor(speedAmount);
            fuel.value = Math.floor(fuelAmount);

            if (fuel.value <= 20) {
                fuelColor.value = "#ff0000";
            } else if (fuel.value <= 30) {
                fuelColor.value = "#dd6e14";
            }
        }

        function ShowWeapon(bool) {
            showWeapon.value = bool;
        }

        function UpdateWeaponAmmo(clipAmount, bagAmount) {
            ammoClip.value = clipAmount;
            ammoBag.value = bagAmount;
        }

        function IsTalking(bool) {
            talking.value = bool;
            talkingColor.value = talking.value ? "#FFFF3E" : "#FFFFFF";
        }

        function UpdateVoiceVolume(radius) {
            voice.value = radius;
        }

        function setupEventListeners() {
            Events.Subscribe("UpdateHUD", updateHudData);
            Events.Subscribe("UpdateMoney", UpdateMoney);
            Events.Subscribe("UpdateVehicleStats", UpdateVehicleStats);
            Events.Subscribe("UpdateWeaponAmmo", UpdateWeaponAmmo);
            Events.Subscribe("ShowCashAmount", ShowCashAmount);
            Events.Subscribe("ShowBankAmount", ShowBankAmount);
            Events.Subscribe("ShowSpeedometer", ShowSpeedometer);
            Events.Subscribe("ShowWeapon", ShowWeapon);
            Events.Subscribe("IsTalking", IsTalking);
            Events.Subscribe("UpdateVoiceVolume", UpdateVoiceVolume);
        }

        onMounted(() => {
            setupEventListeners();
        });

        return {
            showAll,
            showCash,
            showBank,
            cash,
            bank,
            health,
            armor,
            voice,
            talking,
            hunger,
            thirst,
            stress,
            talkingColor,
            healthColor,
            armorColor,
            hungerColor,
            thirstColor,
            amount,
            plus,
            minus,
            showUpdate,
            speed,
            fuel,
            fuelColor,
            fuelgauge,
            seatbelt,
            cruise,
            showSpeedometer,
            ammoClip,
            ammoBag,
            showWeapon,
        };
    },
});

app.use(Quasar);
app.mount("#main-container");
