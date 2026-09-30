import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import ".."
import "../components"
import "../services"

Scope {
    id: root

    LazyLoader {
        active: ShellState.notificationCenterOpen

        PanelWindow {
            anchors {
                top: true
                bottom: true
                right: true
            }
            margins {
                top: Theme.barHeight + 6
                bottom: Theme.barHeight + 6
                right: 6
            }
            exclusiveZone: 0

            implicitWidth: 680
            color: "transparent"

            Rectangle {
                anchors.fill: parent
                color: Theme.bg
                border.color: Theme.border
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 26
                    spacing: 20

                    // Top Bar / Header
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "CONTROL CENTER"
                            font.family: Theme.fontFamily
                            font.pixelSize: 22
                            font.bold: true
                            color: Theme.blue
                            Layout.fillWidth: true
                        }

                        // DND Button
                        Rectangle {
                            implicitWidth: dndRow.implicitWidth + 24
                            implicitHeight: 40
                            color: ShellState.dndEnabled ? Theme.red : Theme.surface
                            border.color: Theme.border
                            border.width: 1

                            Row {
                                id: dndRow
                                anchors.centerIn: parent
                                spacing: 8

                                Text {
                                    text: ShellState.dndEnabled ? "" : ""
                                    font.family: Theme.iconFont
                                    font.pixelSize: 22
                                    color: ShellState.dndEnabled ? Theme.bg : Theme.fg
                                }
                                Text {
                                    text: "DND"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: ShellState.dndEnabled ? Theme.bg : Theme.fg
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: ShellState.dndEnabled = !ShellState.dndEnabled
                            }
                        }

                        // Close Button
                        Rectangle {
                            implicitWidth: 40
                            implicitHeight: 40
                            color: Theme.surface
                            border.color: Theme.border
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "✕"
                                font.family: Theme.fontFamily
                                font.pixelSize: 22
                                color: Theme.fgDim
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: ShellState.closeNotificationCenter()
                            }
                        }
                    }

                    // Sliders Section (Volume & Brightness)
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: slidersCol.implicitHeight + 36
                        color: Theme.surface
                        border.color: Theme.border
                        border.width: 1

                        ColumnLayout {
                            id: slidersCol
                            anchors.fill: parent
                            anchors {
                                leftMargin: 20
                                rightMargin: 20
                                topMargin: 18
                                bottomMargin: 18
                            }
                            spacing: 18

                            // Volume Slider
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 16

                                Text {
                                    text: Pipewire.defaultAudioSink?.audio.muted ? "" : ""
                                    font.family: Theme.iconFont
                                    font.pixelSize: 26
                                    color: Pipewire.defaultAudioSink?.audio.muted ? Theme.red : Theme.blue
                                    Layout.preferredWidth: 36
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignVCenter

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (Pipewire.defaultAudioSink?.audio) {
                                                Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
                                            }
                                        }
                                    }
                                }

                                Slider {
                                    Layout.fillWidth: true
                                    value: Pipewire.defaultAudioSink?.audio.volume ?? 0
                                    progressColor: Theme.blue
                                    onMoved: val => {
                                        if (Pipewire.defaultAudioSink?.audio) {
                                            Pipewire.defaultAudioSink.audio.volume = val;
                                        }
                                    }
                                }

                                Text {
                                    text: Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100) + "%"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 20
                                    color: Theme.fgDim
                                    Layout.preferredWidth: 65
                                    horizontalAlignment: Text.AlignRight
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }

                            // Brightness Slider
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 16

                                Text {
                                    text: ""
                                    font.family: Theme.iconFont
                                    font.pixelSize: 26
                                    color: Theme.yellow
                                    Layout.preferredWidth: 36
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Slider {
                                    Layout.fillWidth: true
                                    value: ShellState.brightnessPercent / 100.0
                                    progressColor: Theme.yellow
                                    onMoved: val => ShellState.setBrightness(Math.round(val * 100))
                                }

                                Text {
                                    text: ShellState.brightnessPercent + "%"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 20
                                    color: Theme.fgDim
                                    Layout.preferredWidth: 65
                                    horizontalAlignment: Text.AlignRight
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }

                            // Keyboard Backlight Slider
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 16

                                Text {
                                    text: "󰌌"
                                    font.family: Theme.iconFont
                                    font.pixelSize: 26
                                    color: Theme.purple
                                    Layout.preferredWidth: 36
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignVCenter

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            ShellState.setKblight(ShellState.kblightPercent > 0 ? 0 : 20);
                                        }
                                    }
                                }

                                Slider {
                                    Layout.fillWidth: true
                                    value: ShellState.kblightPercent / 100.0
                                    progressColor: Theme.purple
                                    onMoved: val => ShellState.setKblight(Math.round(val * 100))
                                }

                                Text {
                                    text: ShellState.kblightPercent + "%"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 20
                                    color: Theme.fgDim
                                    Layout.preferredWidth: 65
                                    horizontalAlignment: Text.AlignRight
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }
                        }
                    }

                    // Media Player Card (if available)
                    Item {
                        Layout.fillWidth: true
                        implicitHeight: mediaCard.visible ? mediaCard.implicitHeight : 0
                        visible: mediaCard.visible

                        Rectangle {
                            id: mediaCard
                            anchors.fill: parent
                            visible: MediaService.showMedia && MediaService.trackTitle !== ""
                            color: Theme.surface
                            border.color: Theme.border
                            border.width: 1
                            implicitHeight: 140

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 18
                                spacing: 18

                                // Album Art Box
                                Rectangle {
                                    id: artBox
                                    Layout.preferredWidth: 104
                                    Layout.preferredHeight: 104
                                    color: Theme.surfaceHover
                                    border.color: Theme.border
                                    border.width: 1
                                    Layout.alignment: Qt.AlignVCenter

                                    Image {
                                        id: artImage
                                        anchors.fill: parent
                                        anchors.margins: 1
                                        source: MediaService.trackArtUrl
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                        cache: true
                                        visible: status === Image.Ready
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: "󰎆"
                                        font.family: Theme.iconFont
                                        font.pixelSize: 42
                                        color: Theme.fgDim
                                        visible: !artImage.visible
                                    }
                                }

                                // Metadata Column
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    spacing: 6

                                    // App name & status row
                                    RowLayout {
                                        spacing: 6

                                        Text {
                                            text: "󰝚"
                                            font.family: Theme.iconFont
                                            font.pixelSize: 15
                                            color: Theme.blue
                                            Layout.alignment: Qt.AlignVCenter
                                        }

                                        Text {
                                            text: MediaService.appName.toUpperCase()
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 15
                                            font.bold: true
                                            color: Theme.blue
                                            Layout.alignment: Qt.AlignVCenter
                                        }

                                        Text {
                                            text: "•"
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 13
                                            color: Theme.fgMuted
                                            Layout.alignment: Qt.AlignVCenter
                                        }

                                        Text {
                                            text: MediaService.isPlaying ? "PLAYING" : "PAUSED"
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 13
                                            font.bold: true
                                            color: MediaService.isPlaying ? Theme.green : Theme.fgMuted
                                            Layout.alignment: Qt.AlignVCenter
                                        }
                                    }

                                    // Track Title
                                    Text {
                                        text: MediaService.trackTitle || "No Track"
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 22
                                        font.bold: true
                                        color: Theme.fg
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }

                                    // Artist & Album
                                    Text {
                                        text: {
                                            const artist = MediaService.trackArtist;
                                            const album = MediaService.trackAlbum;
                                            if (artist && album) return `${artist}  —  ${album}`;
                                            return artist || album || "";
                                        }
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 18
                                        color: Theme.fgDim
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }
                                }

                                // Playback Controls
                                RowLayout {
                                    spacing: 12
                                    Layout.alignment: Qt.AlignVCenter

                                    // Previous button
                                    Rectangle {
                                        implicitWidth: 48
                                        implicitHeight: 48
                                        color: prevMouse.containsMouse ? Theme.surfaceHover : "transparent"
                                        border.color: prevMouse.containsMouse ? Theme.borderFocused : Theme.border
                                        border.width: 1
                                        Layout.alignment: Qt.AlignVCenter

                                        Text {
                                            anchors.centerIn: parent
                                            text: "󰒮"
                                            font.family: Theme.iconFont
                                            font.pixelSize: 26
                                            color: prevMouse.containsMouse ? Theme.fg : Theme.fgDim
                                        }

                                        MouseArea {
                                            id: prevMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: MediaService.previous()
                                        }
                                    }

                                    // Play / Pause button
                                    Rectangle {
                                        implicitWidth: 58
                                        implicitHeight: 58
                                        color: playMouse.containsMouse ? Theme.surfaceActive : Theme.surfaceHover
                                        border.color: MediaService.isPlaying ? Theme.green : Theme.border
                                        border.width: 2
                                        Layout.alignment: Qt.AlignVCenter

                                        Text {
                                            anchors.centerIn: parent
                                            text: MediaService.isPlaying ? "󰏤" : "󰐊"
                                            font.family: Theme.iconFont
                                            font.pixelSize: 32
                                            color: MediaService.isPlaying ? Theme.green : Theme.fg
                                        }

                                        MouseArea {
                                            id: playMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: MediaService.togglePlaying()
                                        }
                                    }

                                    // Next button
                                    Rectangle {
                                        implicitWidth: 48
                                        implicitHeight: 48
                                        color: nextMouse.containsMouse ? Theme.surfaceHover : "transparent"
                                        border.color: nextMouse.containsMouse ? Theme.borderFocused : Theme.border
                                        border.width: 1
                                        Layout.alignment: Qt.AlignVCenter

                                        Text {
                                            anchors.centerIn: parent
                                            text: "󰒭"
                                            font.family: Theme.iconFont
                                            font.pixelSize: 26
                                            color: nextMouse.containsMouse ? Theme.fg : Theme.fgDim
                                        }

                                        MouseArea {
                                            id: nextMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: MediaService.next()
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Notifications List Header
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 6

                        Text {
                            text: "NOTIFICATIONS (" + NotificationService.count + ")"
                            font.family: Theme.fontFamily
                            font.pixelSize: 20
                            font.bold: true
                            color: Theme.fgDim
                            Layout.fillWidth: true
                        }

                        Text {
                            text: "Clear All"
                            font.family: Theme.fontFamily
                            font.pixelSize: 18
                            color: Theme.red
                            visible: NotificationService.count > 0

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: NotificationService.dismissAll()
                            }
                        }
                    }

                    // Notifications List
                    ListView {
                        id: notifList
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 14
                        boundsBehavior: Flickable.StopAtBounds
                        model: NotificationService.list

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                            contentItem: Rectangle {
                                implicitWidth: 6
                                color: Theme.surfaceHover
                            }
                        }

                        WheelHandler {
                            target: null
                            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                            onWheel: event => {
                                const dy = event.pixelDelta.y !== 0 ? event.pixelDelta.y : (event.angleDelta.y / 2);
                                const maxScroll = Math.max(0, notifList.contentHeight - notifList.height);
                                notifList.contentY = Math.max(0, Math.min(maxScroll, notifList.contentY - dy * 4));
                            }
                        }

                        delegate: NotificationCard {
                            required property var modelData
                            notification: modelData
                            width: notifList.width
                            onCloseRequested: notification.dismiss()
                            onActivated: ShellState.closeNotificationCenter()
                        }
                    }
                }
            }
        }
    }
}
