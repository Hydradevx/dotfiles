import QtQuick
import Quickshell
import "../public" as Theme

Item {
    id: musicIcon
    width: 24
    height: 24

    signal togglePopup()

    Text {
        text: "󰎆" // Nerd Font music note icon
        font.pixelSize: 28
        font.family: "JetBrainsMono Nerd Font"
        color: Theme.Colors.on_surface
        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: musicIcon.togglePopup()
        }
    }
}
