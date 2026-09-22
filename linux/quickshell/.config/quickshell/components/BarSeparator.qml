import QtQuick
import ".."

Item {
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined
    implicitWidth: sepText.implicitWidth + 12
    implicitHeight: Math.max(sepText.implicitHeight, 36)

    Text {
        id: sepText
        anchors.centerIn: parent
        text: "|"
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.fgMuted
    }
}
