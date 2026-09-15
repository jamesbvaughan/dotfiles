import QtQuick
import Quickshell
import Quickshell.Services.UPower

Item {
    id: root

    // Reactively track whether the system is running on battery
    readonly property bool onBattery: UPower.onBattery

    function applyProfile() {
        if (UPower.onBattery) {
            if (PowerProfiles.profile !== PowerProfile.Balanced) {
                PowerProfiles.profile = PowerProfile.Balanced;
            }
        } else {
            if (PowerProfiles.hasPerformanceProfile && PowerProfiles.profile !== PowerProfile.Performance) {
                PowerProfiles.profile = PowerProfile.Performance;
            }
        }
    }

    onOnBatteryChanged: {
        applyProfile();
    }

    Component.onCompleted: {
        applyProfile();
    }

    // Delayed fallback check in case UPower/DBus properties are still populating at startup
    Timer {
        id: initTimer
        interval: 1500
        running: true
        repeat: false
        onTriggered: root.applyProfile()
    }
}
