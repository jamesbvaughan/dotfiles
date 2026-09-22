import QtQuick
import Quickshell
import Quickshell.Io
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

    // Monitor systemd login1 PrepareForSleep signal to re-evaluate on wake from sleep
    Process {
        id: sleepMonitor
        command: ["stdbuf", "-oL", "gdbus", "monitor", "-y", "-d", "org.freedesktop.login1", "-o", "/org/freedesktop/login1"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                if (data.includes("PrepareForSleep") && data.includes("false")) {
                    root.applyProfile();
                    wakeTimer.restart();
                }
            }
        }
    }

    // Secondary delayed check after wake to allow hardware / ACPI / tuned-ppd states to settle
    Timer {
        id: wakeTimer
        interval: 1500
        running: false
        repeat: false
        onTriggered: root.applyProfile()
    }
}
