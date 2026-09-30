import QtQuick
import Quickshell
import Quickshell.Services.UPower

// Switches the power profile when the charger is plugged in or pulled
// (AC -> Performance, battery -> Balanced). It only reacts to that transition, so a
// profile picked by hand from the bar sticks until the next plug/unplug.
Scope {
    id: root

    function applyProfile() {
        if (UPower.onBattery) {
            PowerProfiles.profile = PowerProfile.Balanced;
        } else if (PowerProfiles.hasPerformanceProfile) {
            PowerProfiles.profile = PowerProfile.Performance;
        }
    }

    Connections {
        target: UPower
        function onOnBatteryChanged() {
            root.applyProfile();
        }
    }

    // UPower's properties arrive over D-Bus shortly after startup; apply once they have
    Timer {
        interval: 1500
        running: true
        onTriggered: root.applyProfile()
    }
}
