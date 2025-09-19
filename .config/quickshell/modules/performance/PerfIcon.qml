import QtQuick
import Quickshell
import "../public" as Theme

Item {
    id: perfIcon
    width: 24
    height: 24

    signal togglePopup()

    Text {
        text: "󰓅" 
        font.pixelSize: 20
        font.family: "JetBrainsMono Nerd Font"
        color: Theme.Colors.on_surface
        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: perfIcon.togglePopup()
        }
    }
}