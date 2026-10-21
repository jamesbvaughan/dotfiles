import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Hyprland
import ".."

// Bar button + dropdown listing paired Bluetooth devices (click a device to connect/disconnect)
Item {
    id: root

    required property var barWindow
    property bool open: false

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool isEnabled: adapter?.enabled ?? false
    readonly property bool isBlocked: adapter?.state === BluetoothAdapterState.Blocked

    // Connected first, then alphabetical
    readonly property var pairedDevices: Bluetooth.devices.values
        .filter(d => d.paired || d.bonded)
        .sort((a, b) => (b.connected - a.connected) || deviceLabel(a).localeCompare(deviceLabel(b)))
    readonly property var connectedDevices: pairedDevices.filter(d => d.connected)

    function deviceLabel(d) {
        return d.deviceName || d.name || d.address;
    }

    function deviceGlyph(iconName) {
        const icon = iconName || "";
        if (icon.includes("headset")) return String.fromCodePoint(0xF02CE);
        if (icon.includes("headphone")) return String.fromCodePoint(0xF02CB);
        if (icon.startsWith("audio")) return String.fromCodePoint(0xF04C3);
        if (icon.includes("keyboard")) return String.fromCodePoint(0xF030C);
        if (icon.includes("mouse")) return String.fromCodePoint(0xF037D);
        if (icon.includes("gaming")) return String.fromCodePoint(0xF0297);
        if (icon.includes("phone")) return String.fromCodePoint(0xF011C);
        if (icon.includes("computer")) return String.fromCodePoint(0xF0322);
        if (icon.includes("display")) return String.fromCodePoint(0xF0379);
        return String.fromCodePoint(0xF00AF);
    }

    function toggleOpen() {
        if (!open) {
            const pos = button.mapToItem(barWindow.contentItem, 0, 0);
            popup.anchor.rect.x = pos.x;
            popup.anchor.rect.width = button.width;
        }
        open = !open;
    }

    implicitWidth: button.implicitWidth
    implicitHeight: button.implicitHeight
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined

    BarItem {
        id: button
        anchors.fill: parent

        icon: {
            if (!root.isEnabled) return "󰂲";
            if (root.connectedDevices.length > 0) return "󰂱";
            return String.fromCodePoint(0xF294);
        }
        iconColor: {
            if (!root.isEnabled) return Theme.fgMuted;
            if (root.connectedDevices.length > 0) return Theme.blue;
            return Theme.fgDim;
        }
        text: {
            if (root.connectedDevices.length === 0) return "";
            const name = root.deviceLabel(root.connectedDevices[0]);
            return name.length > 20 ? name.substring(0, 18) + "…" : name;
        }
        active: root.open
        tooltipText: root.open ? "" : (root.isEnabled ? "Bluetooth (click to manage, right-click to turn off)" : "Bluetooth: Off (right-click to turn on)")

        onClicked: root.toggleOpen()
        onRightClicked: if (root.adapter) root.adapter.enabled = !root.adapter.enabled
    }

    // Close when clicking anywhere outside the popup
    HyprlandFocusGrab {
        active: root.open
        windows: [ popup ]
        onCleared: root.open = false
    }

    PopupWindow {
        id: popup
        anchor.window: root.barWindow
        anchor.rect.y: Theme.barHeight + 6
        anchor.rect.height: 0
        anchor.edges: Edges.Top
        anchor.gravity: Edges.Bottom
        visible: root.open
        color: "transparent"

        implicitWidth: 560
        implicitHeight: panel.implicitHeight

        Rectangle {
            id: panel
            anchors.fill: parent
            implicitHeight: content.implicitHeight + 36
            color: Theme.bg
            border.color: Theme.border
            border.width: 1

            focus: true
            Keys.onEscapePressed: root.open = false

            ColumnLayout {
                id: content
                anchors.fill: parent
                anchors.margins: 18
                spacing: 12

                // Header: title + adapter power toggle
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: "Bluetooth"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeNormal
                        font.bold: true
                        color: Theme.fg
                    }

                    Rectangle {
                        implicitWidth: powerText.implicitWidth + 24
                        implicitHeight: 36
                        color: powerMouse.containsMouse ? Theme.surfaceHover : Theme.surface
                        border.color: root.isEnabled ? Theme.blue : Theme.border
                        border.width: 1

                        Text {
                            id: powerText
                            anchors.centerIn: parent
                            text: root.isBlocked ? "Blocked" : (root.isEnabled ? "On" : "Off")
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            color: root.isEnabled ? Theme.blue : Theme.fgDim
                        }

                        MouseArea {
                            id: powerMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (root.adapter) root.adapter.enabled = !root.adapter.enabled
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: Theme.border
                }

                Text {
                    visible: !root.isEnabled || root.pairedDevices.length === 0
                    Layout.fillWidth: true
                    Layout.topMargin: 6
                    Layout.bottomMargin: 6
                    text: !root.adapter ? "No Bluetooth adapter found" : (!root.isEnabled ? "Bluetooth is off" : "No paired devices")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.fgMuted
                    horizontalAlignment: Text.AlignHCenter
                }

                // Paired devices
                Repeater {
                    model: root.isEnabled ? root.pairedDevices : []

                    delegate: Rectangle {
                        id: row
                        required property BluetoothDevice modelData
                        readonly property bool busy: modelData.state === BluetoothDeviceState.Connecting
                            || modelData.state === BluetoothDeviceState.Disconnecting

                        Layout.fillWidth: true
                        implicitHeight: 64
                        color: rowMouse.containsMouse ? Theme.surfaceHover : (modelData.connected ? Theme.surface : "transparent")

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 14

                            Text {
                                text: root.deviceGlyph(row.modelData.icon)
                                font.family: Theme.iconFont
                                font.pixelSize: Theme.fontSizeLarge
                                color: row.modelData.connected ? Theme.blue : Theme.fgDim
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    Layout.fillWidth: true
                                    text: root.deviceLabel(row.modelData)
                                    elide: Text.ElideRight
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.fg
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: {
                                        const d = row.modelData;
                                        if (d.state === BluetoothDeviceState.Connecting) return "Connecting…";
                                        if (d.state === BluetoothDeviceState.Disconnecting) return "Disconnecting…";
                                        if (!d.connected) return "Not connected";
                                        return d.batteryAvailable ? `Connected · ${Math.round(d.battery * 100)}%` : "Connected";
                                    }
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeSmall - 3
                                    color: row.busy ? Theme.yellow : (row.modelData.connected ? Theme.green : Theme.fgMuted)
                                }
                            }

                            Text {
                                visible: rowMouse.containsMouse && !row.busy
                                text: row.modelData.connected ? "Disconnect" : "Connect"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall - 3
                                color: row.modelData.connected ? Theme.red : Theme.blue
                            }
                        }

                        MouseArea {
                            id: rowMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: row.busy ? Qt.BusyCursor : Qt.PointingHandCursor
                            onClicked: {
                                if (row.busy) return;
                                if (row.modelData.connected) row.modelData.disconnect();
                                else row.modelData.connect();
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: Theme.border
                }

                // Pairing new devices is left to bluetui
                Text {
                    text: "Pair new device…"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall - 3
                    color: pairMouse.containsMouse ? Theme.fg : Theme.fgDim

                    MouseArea {
                        id: pairMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.open = false;
                            Quickshell.execDetached(["ghostty", "--class=bluetui.Bluetui", "-e", "bluetui"]);
                        }
                    }
                }
            }
        }
    }
}
