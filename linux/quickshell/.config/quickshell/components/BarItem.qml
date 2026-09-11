import QtQuick
import Quickshell
import ".."

Rectangle {
    id: root

    property string icon: ""
    property color iconColor: Theme.fg
    property string text: ""
    property color textColor: Theme.fg
    property string badge: ""
    property color badgeColor: Theme.red
    property string tooltipText: ""
    property bool tooltipAbove: false
    property bool showTooltip: false
    property bool active: false
    property bool clickable: true
    property color activeColor: Theme.surfaceActive
    property color defaultColor: "transparent"

    property int fixedWidth: 0

    signal clicked()
    signal rightClicked()
    signal scrollUp()
    signal scrollDown()

    implicitWidth: fixedWidth > 0 ? fixedWidth : (contentRow.implicitWidth + 12)
    implicitHeight: Math.max(contentRow.implicitHeight, 36)
    radius: Theme.radius

    color: {
        if (mouseArea.containsMouse && clickable) return Theme.surfaceHover
        if (active) return activeColor
        return defaultColor
    }

    // 350ms hover delay so tooltips don't flash during mouse traversal
    Timer {
        id: tooltipTimer
        interval: 350
        running: mouseArea.containsMouse && root.tooltipText !== ""
        onTriggered: root.showTooltip = true
    }

    Connections {
        target: mouseArea
        function onContainsMouseChanged() {
            if (!mouseArea.containsMouse) {
                root.showTooltip = false;
                tooltipTimer.stop();
            }
        }
    }

    // Floating Tooltip Window
    PopupWindow {
        id: tooltipWindow
        anchor.item: root
        anchor.edges: root.tooltipAbove ? Edges.Top : Edges.Bottom
        anchor.gravity: root.tooltipAbove ? Edges.Top : Edges.Bottom
        visible: root.showTooltip && root.tooltipText !== ""
        color: "transparent"

        implicitWidth: tipBox.implicitWidth
        implicitHeight: tipBox.implicitHeight

        Rectangle {
            id: tipBox
            implicitWidth: tipText.implicitWidth + 18
            implicitHeight: tipText.implicitHeight + 14
            color: Theme.bgAlt
            border.color: Theme.border
            border.width: 1

            Text {
                id: tipText
                anchors.centerIn: parent
                text: root.tooltipText
                textFormat: Text.AutoText
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.fg
            }
        }
    }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 7

        Text {
            id: iconText
            visible: root.icon !== ""
            text: root.icon
            font.family: Theme.iconFont
            font.pixelSize: Theme.fontSizeNormal
            color: root.iconColor
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: labelText
            visible: root.text !== ""
            text: root.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            color: root.textColor
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: badgeRect
            visible: root.badge !== ""
            width: Math.max(badgeText.implicitWidth + 8, 20)
            height: 20
            radius: 10
            color: root.badgeColor
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: badgeText
                anchors.centerIn: parent
                text: root.badge
                font.family: Theme.fontFamily
                font.pixelSize: 14
                font.bold: true
                color: Theme.bg
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                root.rightClicked();
            } else {
                root.clicked();
            }
        }

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                root.scrollUp();
            } else if (wheel.angleDelta.y < 0) {
                root.scrollDown();
            }
        }
    }
}
