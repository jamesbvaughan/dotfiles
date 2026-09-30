import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import ".."
import "../components"
import "../services"

PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight
    color: Theme.bg

    // Bind Pipewire default audio sink
    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }

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

            // Workspaces (1 through 10)
            Row {
                spacing: 4
                anchors.verticalCenter: parent.verticalCenter

                Repeater {
                    model: 10

                    delegate: Rectangle {
                        required property int index
                        readonly property int wsId: index + 1
                        readonly property var wsObj: {
                            const list = Hyprland.workspaces.values;
                            for (let i = 0; i < list.length; i++) {
                                if (list[i].id === wsId) return list[i];
                            }
                            return null;
                        }
                        readonly property bool isFocused: Hyprland.focusedWorkspace?.id === wsId
                        readonly property bool isOccupied: wsObj !== null
                        readonly property bool isUrgent: wsObj?.urgent ?? false

                        // Show if occupied or focused, or if within 1..5
                        visible: isOccupied || isFocused || wsId <= 5

                        width: 38
                        height: 36
                        radius: Theme.radius

                        color: {
                            if (isFocused) return Theme.blue;
                            if (isUrgent) return Theme.red;
                            if (wsMouse.containsMouse) return Theme.surfaceHover;
                            if (isOccupied) return Theme.surface;
                            return "transparent";
                        }

                        border.color: isFocused ? Theme.blue : (isOccupied ? Theme.border : "transparent")
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: wsId.toString()
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            font.bold: isFocused
                            color: isFocused ? Theme.bg : (isOccupied ? Theme.fg : Theme.fgMuted)
                        }

                        MouseArea {
                            id: wsMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (wsObj) {
                                    wsObj.activate();
                                } else if (Hyprland.usingLua) {
                                    Hyprland.dispatch("hl.dsp.focus({ workspace = " + wsId + " })");
                                } else {
                                    Hyprland.dispatch("workspace " + wsId);
                                }
                            }
                        }
                    }
                }
            }

            BarSeparator {}

            // Active Window Title
            Text {
                id: windowTitle
                anchors.verticalCenter: parent.verticalCenter
                text: {
                    const title = Hyprland.activeToplevel?.title ?? "";
                    if (title.length > 55) return title.substring(0, 52) + "...";
                    return title;
                }
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeNormal
                color: Theme.fgDim
            }
        }

        // ==================== CENTER MODULES ====================
        Row {
            id: centerRow
            anchors.centerIn: parent

            BarItem {
                icon: ""
                iconColor: Theme.yellow
                text: EventsService.eventText.replace(/^\s*/, "")
                textColor: Theme.fg
                tooltipText: EventsService.tooltipText
                onClicked: EventsService.openCalendar()
            }
        }

        // ==================== RIGHT MODULES ====================
        Row {
            id: rightRow
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.moduleSpacing

            // Brightness Module
            BarItem {
                icon: ""
                iconColor: Theme.yellow
                text: ShellState.brightnessPercent + "%"
                tooltipText: "Brightness: " + ShellState.brightnessPercent + "% (scroll to adjust)"
                // brightness.sh reports the resulting level back through the OSD IPC call
                onScrollUp: Quickshell.execDetached([Quickshell.env("HOME") + "/.dotfiles/scripts/brightness.sh", "up"])
                onScrollDown: Quickshell.execDetached([Quickshell.env("HOME") + "/.dotfiles/scripts/brightness.sh", "down"])
                onClicked: {
                    ShellState.triggerBrightnessOsd(ShellState.brightnessPercent);
                }
            }

            BarSeparator {}

            // Audio / Volume Module
            BarItem {
                readonly property real vol: Pipewire.defaultAudioSink?.audio.volume ?? 0
                readonly property bool isMuted: Pipewire.defaultAudioSink?.audio.muted ?? false

                icon: {
                    if (isMuted) return "";
                    if (vol > 0.6) return "";
                    if (vol >= 0.2) return "";
                    return "";
                }
                iconColor: isMuted ? Theme.red : Theme.blue
                text: isMuted ? "Muted" : Math.round(vol * 100) + "%"
                tooltipText: isMuted ? "Audio: Muted (click for pavucontrol, right-click to unmute)" : "Volume: " + Math.round(vol * 100) + "% (click for pavucontrol, right-click to mute)"

                onClicked: Quickshell.execDetached(["pavucontrol"])
                onRightClicked: {
                    if (Pipewire.defaultAudioSink?.audio) {
                        Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
                    }
                }
                onScrollUp: {
                    if (Pipewire.defaultAudioSink?.audio) {
                        Pipewire.defaultAudioSink.audio.volume = Math.min(1.0, vol + 0.05);
                    }
                }
                onScrollDown: {
                    if (Pipewire.defaultAudioSink?.audio) {
                        Pipewire.defaultAudioSink.audio.volume = Math.max(0.0, vol - 0.05);
                    }
                }
            }

            BarSeparator {}

            // Weather Module
            BarItem {
                text: WeatherService.weatherText
                textColor: Theme.fg
                tooltipText: WeatherService.tooltipText
                onClicked: Quickshell.execDetached(["xdg-open", "https://wttr.in"])
            }

            BarSeparator {}

            // Clock Module
            BarItem {
                id: clockModule
                property bool showAlt: false

                function updateTime() {
                    const d = new Date();
                    clockModule.text = showAlt ? Qt.formatDateTime(d, "yyyy-MM-dd") : Qt.formatDateTime(d, "ddd MMM dd  hh:mm");
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    triggeredOnStart: true
                    onTriggered: clockModule.updateTime()
                }

                textColor: Theme.fg
                onClicked: {
                    showAlt = !showAlt;
                    updateTime();
                }
            }

            BarSeparator {}

            // Lock Screen Button
            BarItem {
                fixedWidth: 36
                icon: ""
                iconColor: Theme.orange
                tooltipText: "Lock screen"
                onClicked: ShellState.lock()
            }

            BarSeparator {}

            // System Tray
            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Repeater {
                    model: SystemTray.items

                    delegate: Item {
                        id: trayItem
                        required property SystemTrayItem modelData
                        width: 30
                        height: 30
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.fill: parent
                            source: {
                                const icon = modelData.icon;
                                if (icon && icon.includes("dropboxstatus")) {
                                    const match = icon.match(/(dropboxstatus-[^?&]+)/);
                                    if (match) {
                                        return `file:///usr/share/icons/breeze-dark/status/24/${match[1]}.svg`;
                                    }
                                }
                                return icon;
                            }
                            fillMode: Image.PreserveAspectFit
                        }

                        MouseArea {
                            id: trayMouse
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            cursorShape: Qt.PointingHandCursor

                            onClicked: mouse => {
                                const clickPos = trayMouse.mapToItem(bar.contentItem, mouse.x, mouse.y);
                                if (mouse.button === Qt.RightButton) {
                                    if (modelData.hasMenu) {
                                        modelData.display(bar, clickPos.x, bar.height);
                                    } else {
                                        modelData.secondaryActivate();
                                    }
                                } else {
                                    if (modelData.onlyMenu && modelData.hasMenu) {
                                        modelData.display(bar, clickPos.x, bar.height);
                                    } else {
                                        modelData.activate();
                                    }
                                }
                            }
                        }
                    }
                }
            }

            BarSeparator {}

            // Notifications Center Toggle Button
            BarItem {
                icon: ShellState.dndEnabled ? "" : ""
                iconColor: ShellState.dndEnabled ? Theme.red : (NotificationService.count > 0 ? Theme.orange : Theme.fgDim)
                badge: NotificationService.count > 0 ? NotificationService.count.toString() : ""
                badgeColor: Theme.red
                active: ShellState.notificationCenterOpen
                tooltipText: ShellState.dndEnabled ? "Do Not Disturb (active)" : (NotificationService.count > 0 ? (NotificationService.count + " notifications") : "No notifications")
                onClicked: ShellState.toggleNotificationCenter()
                onRightClicked: ShellState.dndEnabled = !ShellState.dndEnabled
            }
        }
    }
}
