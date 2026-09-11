import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import ".."
import "../services"

Scope {
    id: root

    // ListModel to hold visible toast notifications
    ListModel {
        id: toastModel
    }

    Connections {
        target: notificationServer

        function onNotification(notif) {
            notif.tracked = true;

            // If DND is active, do not pop up a toast
            if (ShellState.dndEnabled) return;

            toastModel.insert(0, {
                notifId: notif.id,
                summary: notif.summary || notif.appName || "Notification",
                body: notif.body || "",
                appName: notif.appName || "",
                appIcon: notif.appIcon || ""
            });

            // Limit visible toasts
            while (toastModel.count > 4) {
                toastModel.remove(toastModel.count - 1);
            }
        }
    }

    LazyLoader {
        active: toastModel.count > 0

        PanelWindow {
            anchors.top: true
            anchors.right: true
            margins.top: Theme.barHeight + 10
            margins.right: 12
            exclusiveZone: 0

            implicitWidth: 360
            implicitHeight: toastColumn.implicitHeight
            color: "transparent"

            Column {
                id: toastColumn
                width: parent.width
                spacing: 8

                Repeater {
                    model: toastModel

                    delegate: Rectangle {
                        required property int index
                        required property int notifId
                        required property string summary
                        required property string body
                        required property string appName
                        required property string appIcon

                        width: toastColumn.width
                        implicitHeight: contentColumn.implicitHeight + 20
                        color: Theme.bg
                        border.color: Theme.borderFocused
                        border.width: 1

                        Timer {
                            interval: 6000
                            running: true
                            onTriggered: {
                                if (index >= 0 && index < toastModel.count) {
                                    toastModel.remove(index);
                                }
                            }
                        }

                        ColumnLayout {
                            id: contentColumn
                            anchors {
                                left: parent.left
                                right: parent.right
                                top: parent.top
                                margins: 10
                            }
                            spacing: 4

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                Text {
                                    text: appName ? appName.toUpperCase() : "NOTIFICATION"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeSmall - 1
                                    font.bold: true
                                    color: Theme.blue
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: "✕"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.fgDim

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: toastModel.remove(index)
                                    }
                                }
                            }

                            Text {
                                text: summary
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeNormal
                                font.bold: true
                                color: Theme.fg
                                wrapMode: Text.Wrap
                                Layout.fillWidth: true
                            }

                            Text {
                                visible: body !== ""
                                text: body
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.fgDim
                                wrapMode: Text.Wrap
                                maximumLineCount: 3
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            z: -1
                            onClicked: toastModel.remove(index)
                        }
                    }
                }
            }
        }
    }
}
