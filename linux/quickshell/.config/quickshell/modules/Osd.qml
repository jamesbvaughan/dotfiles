import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import ".."
import "../services"

Scope {
    id: root

    // Track default audio sink volume and mute
    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }

    // Flag to avoid firing OSD on startup initial sync
    property bool syncComplete: false

    Timer {
        interval: 1000
        running: true
        onTriggered: root.syncComplete = true
    }

    Connections {
        target: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null

        function onVolumesChanged() {
            if (!root.syncComplete) return;
            const vol = Pipewire.defaultAudioSink?.audio?.volume ?? 0;
            const muted = Pipewire.defaultAudioSink?.audio?.muted ?? false;
            ShellState.triggerVolumeOsd(vol, muted);
        }

        function onMutedChanged() {
            if (!root.syncComplete) return;
            const vol = Pipewire.defaultAudioSink?.audio?.volume ?? 0;
            const muted = Pipewire.defaultAudioSink?.audio?.muted ?? false;
            ShellState.triggerVolumeOsd(vol, muted);
        }
    }

    LazyLoader {
        active: ShellState.showOsd

        PanelWindow {
            screen: {
                const name = Hyprland.focusedMonitor?.name;
                if (!name) return null;
                for (let i = 0; i < Quickshell.screens.length; ++i) {
                    if (Quickshell.screens[i].name === name) {
                        return Quickshell.screens[i];
                    }
                }
                return null;
            }

            anchors.bottom: true
            margins.bottom: 110
            exclusiveZone: 0

            implicitWidth: 380
            implicitHeight: 66
            color: "transparent"

            mask: Region {}

            Rectangle {
                anchors.fill: parent
                color: Theme.bg
                border.color: Theme.border
                border.width: 1

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 22
                        rightMargin: 22
                    }
                    spacing: 18

                    Text {
                        text: ShellState.osdIcon
                        font.family: Theme.iconFont
                        font.pixelSize: Theme.fontSizeLarge
                        color: ShellState.osdType === "brightness" ? Theme.yellow : (ShellState.osdType === "kblight" ? Theme.purple : Theme.blue)
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 10
                        color: Theme.surface

                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: Math.max(0, Math.min(parent.width, parent.width * ShellState.osdValue))
                            color: ShellState.osdType === "brightness" ? Theme.yellow : (ShellState.osdType === "kblight" ? Theme.purple : Theme.blue)
                        }
                    }

                    Text {
                        text: ShellState.osdLabel
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeNormal
                        font.bold: true
                        color: Theme.fg
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 54
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }
        }
    }
}
