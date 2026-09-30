import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import ".."
import "../services"

Scope {
    id: root

    LazyLoader {
        active: ShellState.powerDialogOpen

        PanelWindow {
            id: window

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            exclusiveZone: 0
            color: "transparent"

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            WlrLayershell.namespace: "quickshell:power-dialog"

            FocusScope {
                id: dialogFocusScope
                anchors.fill: parent
                focus: true

                property int selectedIndex: 0

                // Least destructive first: Lock is selected by default, so a stray Enter
                // (e.g. hitting the power key twice) never shuts the machine down
                readonly property var actions: [
                    { actionId: "lock",     label: "Lock",      icon: "", keyHint: "L", color: Theme.blue },
                    { actionId: "suspend",  label: "Suspend",   icon: "󰒲", keyHint: "U", color: Theme.aqua },
                    { actionId: "reboot",   label: "Restart",   icon: "", keyHint: "R", color: Theme.orange },
                    { actionId: "shutdown", label: "Shut Down", icon: "", keyHint: "S", color: Theme.red }
                ]

                function executeById(actionId) {
                    executeAction(actions.findIndex(a => a.actionId === actionId));
                }

                function executeAction(index) {
                    if (index < 0 || index >= actions.length) return;
                    const action = actions[index];
                    ShellState.closePowerDialog();

                    if (action.actionId === "shutdown") {
                        Quickshell.execDetached(["systemctl", "poweroff"]);
                    } else if (action.actionId === "reboot") {
                        Quickshell.execDetached(["systemctl", "reboot"]);
                    } else if (action.actionId === "suspend") {
                        Quickshell.execDetached(["systemctl", "suspend"]);
                    } else if (action.actionId === "lock") {
                        ShellState.lock();
                    }
                }

                Component.onCompleted: dialogFocusScope.forceActiveFocus()

                Timer {
                    interval: 30
                    running: true
                    onTriggered: dialogFocusScope.forceActiveFocus()
                }

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        ShellState.closePowerDialog();
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Left || event.key === Qt.Key_Backtab) {
                        dialogFocusScope.selectedIndex = (dialogFocusScope.selectedIndex - 1 + actions.length) % actions.length;
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Tab) {
                        dialogFocusScope.selectedIndex = (dialogFocusScope.selectedIndex + 1) % actions.length;
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                        dialogFocusScope.executeAction(dialogFocusScope.selectedIndex);
                        event.accepted = true;
                    } else if (event.key === Qt.Key_S) {
                        dialogFocusScope.executeById("shutdown");
                        event.accepted = true;
                    } else if (event.key === Qt.Key_R) {
                        dialogFocusScope.executeById("reboot");
                        event.accepted = true;
                    } else if (event.key === Qt.Key_U || event.key === Qt.Key_Z) {
                        dialogFocusScope.executeById("suspend");
                        event.accepted = true;
                    } else if (event.key === Qt.Key_L) {
                        dialogFocusScope.executeById("lock");
                        event.accepted = true;
                    }
                }

                // Fullscreen backdrop to dim desktop and catch outside clicks
                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(0.06, 0.05, 0.05, 0.75)

                    MouseArea {
                        anchors.fill: parent
                        onClicked: ShellState.closePowerDialog()
                    }
                }

                // Modal dialog box centered on screen
                Rectangle {
                    id: dialogCard
                    anchors.centerIn: parent
                    width: 720
                    height: contentColumn.implicitHeight + 56
                    color: Theme.bg
                    border.color: Theme.border
                    border.width: 1

                    // Prevent click-through to backdrop
                    MouseArea {
                        anchors.fill: parent
                    }

                    ColumnLayout {
                        id: contentColumn
                        anchors.fill: parent
                        anchors.margins: 28
                        spacing: 24

                        // Header area
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            // Title row with Close button
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 12

                                Text {
                                    text: ""
                                    font.family: Theme.iconFont
                                    font.pixelSize: Theme.fontSizeLarge
                                    color: Theme.red
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Text {
                                    text: "SYSTEM POWER"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeNormal
                                    font.bold: true
                                    color: Theme.fg
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                // Close / Esc button
                                Rectangle {
                                    implicitWidth: 36
                                    implicitHeight: 36
                                    color: escMouse.containsMouse ? Theme.surfaceHover : Theme.surface
                                    border.color: escMouse.containsMouse ? Theme.fgDim : Theme.border
                                    border.width: 1
                                    Layout.alignment: Qt.AlignVCenter

                                    Text {
                                        anchors.centerIn: parent
                                        text: "✕"
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 18
                                        color: escMouse.containsMouse ? Theme.fg : Theme.fgDim
                                    }

                                    MouseArea {
                                        id: escMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: ShellState.closePowerDialog()
                                    }
                                }
                            }

                            // Subtitle
                            Text {
                                text: "Press Enter to lock, or choose an option"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.fgDim
                            }
                        }

                        // Divider line
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 1
                            color: Theme.border
                        }

                        // Action cards row
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 16

                            Repeater {
                                model: dialogFocusScope.actions

                                delegate: Rectangle {
                                    id: actionCard
                                    required property var modelData
                                    required property int index

                                    readonly property bool isSelected: dialogFocusScope.selectedIndex === index
                                    readonly property bool isHovered: cardMouse.containsMouse

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 136
                                    color: isSelected ? Theme.surfaceActive : (isHovered ? Theme.surfaceHover : Theme.surface)
                                    border.color: isSelected ? modelData.color : (isHovered ? Theme.fgDim : Theme.border)
                                    border.width: isSelected ? 2 : 1

                                    MouseArea {
                                        id: cardMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: dialogFocusScope.executeAction(actionCard.index)
                                    }

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 14
                                        spacing: 8

                                        Text {
                                            Layout.alignment: Qt.AlignHCenter
                                            text: actionCard.modelData.icon
                                            font.family: Theme.iconFont
                                            font.pixelSize: 36
                                            color: actionCard.modelData.color
                                        }

                                        Text {
                                            Layout.alignment: Qt.AlignHCenter
                                            text: actionCard.modelData.label
                                            font.family: Theme.fontFamily
                                            font.pixelSize: Theme.fontSizeSmall
                                            font.bold: actionCard.isSelected
                                            color: actionCard.isSelected ? Theme.fg : Theme.fgDim
                                        }

                                        Rectangle {
                                            Layout.alignment: Qt.AlignHCenter
                                            implicitWidth: keyHintText.implicitWidth + 14
                                            implicitHeight: 22
                                            color: actionCard.isSelected ? actionCard.modelData.color : Theme.bg
                                            border.color: actionCard.isSelected ? actionCard.modelData.color : Theme.border
                                            border.width: 1

                                            Text {
                                                id: keyHintText
                                                anchors.centerIn: parent
                                                text: actionCard.isSelected ? "Enter" : actionCard.modelData.keyHint
                                                font.family: Theme.fontFamily
                                                font.pixelSize: 13
                                                font.bold: true
                                                color: actionCard.isSelected ? Theme.bg : Theme.fgMuted
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Divider line
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 1
                            color: Theme.border
                        }

                        // Footer info
                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                text: "← / → / Tab  Navigate    Enter  Confirm    Esc  Cancel"
                                font.family: Theme.fontFamily
                                font.pixelSize: 15
                                color: Theme.fgMuted
                                Layout.fillWidth: true
                            }

                            Text {
                                text: "Hotkeys: [L] [U] [R] [S]"
                                font.family: Theme.fontFamily
                                font.pixelSize: 15
                                color: Theme.fgMuted
                                horizontalAlignment: Text.AlignRight
                            }
                        }
                    }
                }
            }
        }
    }
}
