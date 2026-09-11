import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import ".."
import "../components"
import "../services"

PanelWindow {
    id: bottomBar

    anchors {
        bottom: true
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight
    color: Theme.bg

    Item {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14

        // ==================== LEFT MODULES ====================
        Row {
            id: leftRow
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.moduleSpacing

            // CPU Usage
            BarItem {
                clickable: false
                icon: ""
                iconColor: {
                    if (SystemStats.cpuUsage > 85) return Theme.red;
                    if (SystemStats.cpuUsage > 60) return Theme.yellow;
                    return Theme.blue;
                }
                text: SystemStats.cpuUsage + "%"
                tooltipText: "CPU: " + SystemStats.cpuUsage + "%"
                tooltipAbove: true
            }

            BarSeparator {}

            // Memory Usage
            BarItem {
                clickable: false
                icon: ""
                iconColor: {
                    if (SystemStats.memUsage > 85) return Theme.red;
                    if (SystemStats.memUsage > 70) return Theme.yellow;
                    return Theme.green;
                }
                text: SystemStats.memUsage + "%"
                tooltipText: "Memory: " + SystemStats.memUsage + "%"
                tooltipAbove: true
            }

            BarSeparator {}

            // Disk Usage
            BarItem {
                clickable: false
                icon: "󰋊"
                iconColor: {
                    if (SystemStats.diskUsage > 90) return Theme.red;
                    if (SystemStats.diskUsage > 75) return Theme.yellow;
                    return Theme.aqua;
                }
                text: SystemStats.diskUsage + "%"
                tooltipText: "Disk: " + SystemStats.diskUsage + "%\nUsed: " + SystemStats.diskUsed + " (Total: " + SystemStats.diskTotal + ")\nAvailable: " + SystemStats.diskAvail
                tooltipAbove: true
            }

            BarSeparator {}

            // Temperature
            BarItem {
                clickable: false
                icon: ""
                iconColor: {
                    if (SystemStats.temperature > 80) return Theme.red;
                    if (SystemStats.temperature > 65) return Theme.orange;
                    return Theme.fgDim;
                }
                text: SystemStats.temperature + "°C"
                tooltipText: "Temperature: " + SystemStats.temperature + "°C"
                tooltipAbove: true
            }

            BarSeparator {}

            // Fan Speed
            BarItem {
                clickable: false
                icon: "󰠝"
                iconColor: {
                    if (SystemStats.fanRpm > 4500) return Theme.red;
                    if (SystemStats.fanRpm > 2500) return Theme.yellow;
                    if (SystemStats.fanRpm > 0) return Theme.blue;
                    return Theme.fgDim;
                }
                text: SystemStats.fanRpm > 0 ? (SystemStats.fanRpm + " RPM") : "0 RPM"
                tooltipText: "Fan: " + (SystemStats.fanRpm > 0 ? (SystemStats.fanRpm + " RPM") : "0 RPM (Silent)")
                tooltipAbove: true
            }

            BarSeparator {}

            // Wattage (BAT1 Power Draw)
            BarItem {
                clickable: false
                icon: "󱐋"
                iconColor: Theme.yellow
                text: SystemStats.wattage
                tooltipText: "Power draw: " + SystemStats.wattage
                tooltipAbove: true
            }
        }

        // ==================== CENTER MODULES ====================
        Row {
            id: centerRow
            anchors.centerIn: parent

            // MPRIS Media Player
            BarItem {
                visible: MediaService.showMedia

                icon: MediaService.isPlaying ? "▶" : "⏸"
                iconColor: MediaService.isPlaying ? Theme.green : Theme.fgDim
                text: MediaService.trackLabel
                textColor: Theme.fg
                tooltipText: MediaService.trackTitle + (MediaService.trackArtist ? ("\n" + MediaService.trackArtist) : "")
                tooltipAbove: true

                onClicked: MediaService.togglePlaying()
                onRightClicked: MediaService.next()
            }
        }

        // ==================== RIGHT MODULES ====================
        Row {
            id: rightRow
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.moduleSpacing

            // Bluetooth
            BarItem {
                readonly property bool isEnabled: Bluetooth.defaultAdapter?.enabled ?? false
                readonly property var connectedDevices: {
                    const list = Bluetooth.devices.values;
                    const connected = [];
                    for (let i = 0; i < list.length; i++) {
                        if (list[i].connected) {
                            connected.push(list[i]);
                        }
                    }
                    return connected;
                }
                readonly property int connectedCount: connectedDevices.length
                readonly property var firstDevice: connectedCount > 0 ? connectedDevices[0] : null

                icon: {
                    if (!isEnabled) return "󰂲";
                    if (connectedCount > 0) return "󰂱";
                    return "";
                }
                iconColor: {
                    if (!isEnabled) return Theme.fgMuted;
                    if (connectedCount > 0) return Theme.blue;
                    return Theme.fgDim;
                }
                text: {
                    if (!isEnabled) return "Off";
                    if (connectedCount > 0) {
                        const name = firstDevice?.deviceName || firstDevice?.name || "Connected";
                        return name.length > 18 ? (name.substring(0, 15) + "...") : name;
                    }
                    return "On";
                }
                textColor: isEnabled ? (connectedCount > 0 ? Theme.fg : Theme.fgDim) : Theme.fgMuted

                tooltipText: {
                    if (!isEnabled) return "Bluetooth: Off (click for bluetui)";
                    if (connectedCount > 0) {
                        const names = connectedDevices.map(d => d.deviceName || d.name).join(", ");
                        return `Bluetooth: Connected (${names})\nClick for bluetui`;
                    }
                    return "Bluetooth: On (no devices connected)\nClick for bluetui";
                }
                tooltipAbove: true
                onClicked: Quickshell.execDetached(["ghostty", "--class=bluetui.Bluetui", "-e", "bluetui"])
            }

            BarSeparator {}

            // Systemd Failed Units
            BarItem {
                icon: SystemStats.failedUnits > 0 ? "✗" : "✓"
                iconColor: SystemStats.failedUnits > 0 ? Theme.red : Theme.green
                text: SystemStats.failedUnits > 0 ? SystemStats.failedUnits.toString() : ""
                textColor: SystemStats.failedUnits > 0 ? Theme.red : Theme.green
                tooltipText: SystemStats.failedUnits > 0 ? `${SystemStats.failedUnits} failed systemd units` : "All systemd units OK"
                tooltipAbove: true
                onClicked: Quickshell.execDetached(["ghostty", "-e", "systemctl", "--failed"])
            }

            BarSeparator {}

            // Power Profiles Daemon
            BarItem {
                fixedWidth: 36
                icon: {
                    switch (PowerProfiles.profile) {
                        case PowerProfile.Performance: return "";
                        case PowerProfile.PowerSaver: return "󰌪";
                        case PowerProfile.Balanced:
                        default: return "";
                    }
                }
                iconColor: {
                    switch (PowerProfiles.profile) {
                        case PowerProfile.Performance: return Theme.red;
                        case PowerProfile.PowerSaver: return Theme.green;
                        case PowerProfile.Balanced:
                        default: return Theme.blue;
                    }
                }
                tooltipText: {
                    switch (PowerProfiles.profile) {
                        case PowerProfile.Performance: return "Performance mode";
                        case PowerProfile.PowerSaver: return "Power-saver mode";
                        case PowerProfile.Balanced:
                        default: return "Balanced mode";
                    }
                }
                tooltipAbove: true

                onClicked: {
                    if (PowerProfiles.profile === PowerProfile.PowerSaver) {
                        PowerProfiles.profile = PowerProfile.Balanced;
                    } else if (PowerProfiles.profile === PowerProfile.Balanced) {
                        if (PowerProfiles.hasPerformanceProfile) {
                            PowerProfiles.profile = PowerProfile.Performance;
                        } else {
                            PowerProfiles.profile = PowerProfile.PowerSaver;
                        }
                    } else {
                        PowerProfiles.profile = PowerProfile.PowerSaver;
                    }
                }
            }

            BarSeparator {}

            // Battery
            BarItem {
                readonly property real pct: (UPower.displayDevice?.percentage ?? 1.0) * 100
                readonly property int state: UPower.displayDevice?.state ?? 0
                readonly property bool isCharging: state === 1 || state === 5 // Charging or PendingCharge
                readonly property bool isPlugged: state === 4 // Fully charged / plugged

                icon: {
                    if (isCharging) return "󰂄";
                    if (isPlugged) return "";
                    if (pct <= 15) return "";
                    if (pct <= 35) return "";
                    if (pct <= 60) return "";
                    if (pct <= 85) return "";
                    return "";
                }
                iconColor: {
                    if (isCharging || isPlugged) return Theme.green;
                    if (pct <= 20) return Theme.red;
                    if (pct <= 35) return Theme.orange;
                    return Theme.fg;
                }
                text: Math.round(pct) + "%" + (SystemStats.chargeLimit < 100 ? (" [" + SystemStats.chargeLimit + "%]") : "")
                textColor: Theme.fg
                tooltipText: (isCharging ? "Charging: " : (isPlugged ? "Plugged in: " : "Battery: ")) + Math.round(pct) + "%" +
                             "\nCharge limit: " + SystemStats.chargeLimit + "%" +
                             "\nClick to toggle limit (80% Desk / 100% Travel)"
                tooltipAbove: true
                onClicked: {
                    Quickshell.execDetached([Quickshell.env("HOME") + "/.dotfiles/scripts/framework.sh", "charge-limit", "toggle"]);
                }
            }
        }
    }
}
