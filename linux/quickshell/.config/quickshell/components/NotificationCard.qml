import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import ".."
import "../services"

// One notification: app name, image, summary, body and action buttons.
// Clicking the card runs the notification's default action (if any) and emits activated().
// Invoking an action usually dismisses the notification, which destroys this card, so
// activated() is always emitted first and the action is invoked from captured references.
Rectangle {
    id: root

    required property Notification notification
    property int maxBodyLines: 0 // 0 = unlimited

    signal closeRequested()
    signal activated()

    implicitHeight: contentColumn.implicitHeight + 28
    color: Theme.surface
    border.color: notification.urgency === NotificationUrgency.Critical ? Theme.red : Theme.border
    border.width: 1

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            const notif = root.notification;
            root.activated();
            NotificationService.activate(notif);
        }
    }

    ColumnLayout {
        id: contentColumn
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 14
        }
        spacing: 8

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: root.notification.appName ? root.notification.appName.toUpperCase() : "NOTIFICATION"
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall - 2
                font.bold: true
                color: Theme.blue
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: "✕"
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.fgDim

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.closeRequested()
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Image {
                visible: root.notification.image !== "" && status === Image.Ready
                source: root.notification.image
                Layout.preferredWidth: 56
                Layout.preferredHeight: 56
                Layout.alignment: Qt.AlignTop
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: root.notification.summary || root.notification.appName || "Notification"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeNormal
                    font.bold: true
                    color: Theme.fg
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }

                Text {
                    visible: root.notification.body !== ""
                    text: root.notification.body
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.fgDim
                    wrapMode: Text.Wrap
                    maximumLineCount: root.maxBodyLines > 0 ? root.maxBodyLines : 100000
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }
        }

        // Non-default actions as buttons ("default" is what clicking the card does)
        Flow {
            Layout.fillWidth: true
            spacing: 8
            visible: actionRepeater.count > 0

            Repeater {
                id: actionRepeater
                model: Array.from(root.notification.actions).filter(a => a.identifier !== "default")

                delegate: Rectangle {
                    required property NotificationAction modelData
                    implicitWidth: actionLabel.implicitWidth + 24
                    implicitHeight: actionLabel.implicitHeight + 12
                    color: actionMouse.containsMouse ? Theme.surfaceHover : Theme.bg
                    border.color: Theme.border
                    border.width: 1

                    Text {
                        id: actionLabel
                        anchors.centerIn: parent
                        text: modelData.text
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.fg
                    }

                    MouseArea {
                        id: actionMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            const action = modelData;
                            root.activated();
                            action.invoke();
                        }
                    }
                }
            }
        }
    }
}
