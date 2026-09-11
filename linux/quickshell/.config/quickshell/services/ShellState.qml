pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import ".."

Singleton {
    id: root

    property bool notificationCenterOpen: false
    property bool dndEnabled: false

    property bool powerDialogOpen: false

    property bool showOsd: false
    property string osdType: "volume" // "volume" | "brightness"
    property real osdValue: 0.0 // 0.0 to 1.0
    property string osdIcon: ""
    property string osdLabel: ""

    // Brightness state (tracked via brightness.sh or IPC)
    property int brightnessPercent: 100

    // Keyboard backlight state
    property int kblightPercent: 0
    property bool isSettingKblight: false

    function toggleNotificationCenter() {
        notificationCenterOpen = !notificationCenterOpen;
    }

    function closeNotificationCenter() {
        notificationCenterOpen = false;
    }

    function togglePowerDialog() {
        powerDialogOpen = !powerDialogOpen;
    }

    function openPowerDialog() {
        powerDialogOpen = true;
    }

    function closePowerDialog() {
        powerDialogOpen = false;
    }

    function triggerVolumeOsd(vol, muted) {
        osdType = "volume";
        osdValue = Math.min(Math.max(vol, 0.0), 1.0);
        if (muted) {
            osdIcon = "";
            osdLabel = "Muted";
        } else {
            if (vol > 0.6) osdIcon = "";
            else if (vol > 0.2) osdIcon = "";
            else osdIcon = "";
            osdLabel = Math.round(vol * 100) + "%";
        }
        showOsd = true;
        osdTimer.restart();
    }

    function triggerBrightnessOsd(percent) {
        osdType = "brightness";
        brightnessPercent = Math.min(Math.max(percent, 0), 100);
        osdValue = brightnessPercent / 100.0;
        osdIcon = "";
        osdLabel = brightnessPercent + "%";
        showOsd = true;
        osdTimer.restart();
    }

    function triggerKblightOsd(percent) {
        osdType = "kblight";
        kblightPercent = Math.min(Math.max(percent, 0), 100);
        osdValue = kblightPercent / 100.0;
        osdIcon = "󰌌";
        osdLabel = kblightPercent + "%";
        showOsd = true;
        osdTimer.restart();
    }

    function setKblight(percent) {
        isSettingKblight = true;
        kblightPercent = Math.min(Math.max(percent, 0), 100);
        triggerKblightOsd(kblightPercent);
        Quickshell.execDetached([Quickshell.env("HOME") + "/.dotfiles/scripts/framework.sh", "kblight", "set", kblightPercent.toString()]);
        resetKblightFlagTimer.restart();
    }

    Timer {
        id: resetKblightFlagTimer
        interval: 1500
        onTriggered: root.isSettingKblight = false
    }

    Timer {
        id: osdTimer
        interval: 1500
        onTriggered: root.showOsd = false
    }

    // Process to query initial brightness
    Process {
        id: brightnessQueryProc
        command: [Quickshell.env("HOME") + "/.dotfiles/scripts/brightness.sh", "get"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const val = parseInt(this.text.trim());
                if (!isNaN(val)) {
                    root.brightnessPercent = val;
                }
            }
        }
    }

    // Process to query initial keyboard backlight
    Process {
        id: kblightQueryProc
        command: [Quickshell.env("HOME") + "/.dotfiles/scripts/framework.sh", "kblight", "get"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const val = parseInt(this.text.trim());
                if (!isNaN(val)) {
                    root.kblightPercent = val;
                }
            }
        }
    }
}
