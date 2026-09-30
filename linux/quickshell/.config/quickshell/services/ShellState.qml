pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Singleton {
    id: root

    property bool notificationCenterOpen: false
    property bool dndEnabled: false

    property bool powerDialogOpen: false

    // Handled by LockScreen; lets the bar, power dialog and IPC lock without reaching into it
    signal lockRequested()

    function lock() {
        lockRequested();
    }

    property bool showOsd: false
    property string osdType: "volume" // "volume" | "brightness" | "kblight"
    property real osdValue: 0.0 // 0.0 to 1.0
    property string osdIcon: ""
    property string osdLabel: ""

    // Brightness state (tracked via brightness.sh or IPC)
    property int brightnessPercent: 100

    // Keyboard backlight state (polled from sysfs by SystemStats unless a slider drag is in flight)
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

    // Slider drags call these on every mouse move; the hardware writes are throttled so a
    // drag doesn't fork a process per pixel. The last value always gets written.
    function setBrightness(percent) {
        brightnessPercent = Math.min(Math.max(percent, 0), 100);
        if (!brightnessWrite.running) brightnessWrite.start();
    }

    function setKblight(percent) {
        isSettingKblight = true;
        kblightPercent = Math.min(Math.max(percent, 0), 100);
        triggerKblightOsd(kblightPercent);
        if (!kblightWrite.running) kblightWrite.start();
        resetKblightFlagTimer.restart();
    }

    Timer {
        id: brightnessWrite
        interval: 80
        onTriggered: Quickshell.execDetached([Quickshell.env("HOME") + "/.dotfiles/scripts/brightness.sh", "set", root.brightnessPercent.toString()])
    }

    Timer {
        id: kblightWrite
        interval: 80
        onTriggered: Quickshell.execDetached(["brightnessctl", "-q", "-d", "chromeos::kbd_backlight", "set", root.kblightPercent + "%"])
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
}
