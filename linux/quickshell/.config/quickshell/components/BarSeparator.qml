import QtQuick
import ".."

Item {
    implicitWidth: sepText.implicitWidth + 12
    implicitHeight: sepText.implicitHeight

    Text {
        id: sepText
        anchors.centerIn: parent
        text: "|"
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.fgMuted
    }
}
