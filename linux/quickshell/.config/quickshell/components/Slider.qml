import QtQuick
import ".."

Item {
    id: root

    property real value: 0.0 // 0.0 to 1.0
    property color trackColor: Theme.surface
    property color progressColor: Theme.blue
    property color handleColor: Theme.fg

    signal moved(real val)

    implicitWidth: 160
    implicitHeight: 36

    Rectangle {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 12
        radius: 6
        color: root.trackColor

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Math.max(0, Math.min(parent.width, parent.width * root.value))
            radius: parent.radius
            color: root.progressColor
        }
    }

    Rectangle {
        id: handle
        x: Math.max(0, Math.min(track.width - width, (track.width * root.value) - (width / 2)))
        anchors.verticalCenter: parent.verticalCenter
        width: 26
        height: 26
        radius: 13
        color: root.handleColor
        border.color: Theme.border
        border.width: 1
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        function updateValue(mouseX) {
            const clamped = Math.max(0, Math.min(track.width, mouseX));
            // Only report the new value: assigning root.value here would break the caller's
            // binding, and the slider would stop following external changes after one drag
            root.moved(clamped / track.width);
        }

        onPressed: mouse => updateValue(mouse.x)
        onPositionChanged: mouse => {
            if (pressed) updateValue(mouse.x);
        }
    }
}
