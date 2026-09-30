pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower
import ".."

Singleton {
    id: root

    readonly property real percent: (UPower.displayDevice?.percentage ?? 1.0) * 100
    readonly property int state: UPower.displayDevice?.state ?? UPowerDeviceState.Unknown
    readonly property bool charging: state === UPowerDeviceState.Charging
    // PendingCharge is what UPower reports while the EC holds the battery at the charge limit
    readonly property bool pluggedIn: charging || state === UPowerDeviceState.FullyCharged || state === UPowerDeviceState.PendingCharge

    readonly property string statusLabel: charging ? "Charging" : (pluggedIn ? "Plugged in" : "Battery")

    readonly property string icon: {
        if (charging) return "󰂄";
        if (pluggedIn) return "";
        if (percent <= 15) return "";
        if (percent <= 35) return "";
        if (percent <= 60) return "";
        if (percent <= 85) return "";
        return "";
    }

    readonly property color color: {
        if (pluggedIn) return Theme.green;
        if (percent <= 20) return Theme.red;
        if (percent <= 35) return Theme.orange;
        return Theme.fg;
    }
}
