import QtQuick
import Quickshell
import "../public" as Theme

Item {
    id: perfIcon
    width: 24
    height: 24

    signal togglePopup(bool visible)

    property real scaleFactor: 1.0
    property bool isHovered: false

    Text {
        text: "󰓅" 
        font.pixelSize: 28
        font.family: "JetBrainsMono Nerd Font"
        color: Theme.Colors.on_surface
        anchors.centerIn: parent
        
        scale: perfIcon.scaleFactor
        
        Behavior on scale {
            NumberAnimation { duration: 200; easing.type: Easing.OutBack }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: {
                perfIcon.scaleFactor = 1.2
                perfIcon.isHovered = true
                perfIcon.togglePopup(true)
            }
            onExited: {
                perfIcon.scaleFactor = 1.0
                perfIcon.isHovered = false
            }
        }
    }
}