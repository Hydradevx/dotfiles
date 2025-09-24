import QtQuick
import Quickshell
import "../public" as Theme

Item {
    id: quoteIcon
    width: 24
    height: 24

    signal togglePopup(bool visible)

    property real scaleFactor: 1.0
    property bool isHovered: false

    Text {
        id: iconText
        text: "󰍡"
        font.pixelSize: 28
        font.family: "JetBrainsMono Nerd Font"
        color: isHovered ? Theme.Colors.primary : Theme.Colors.on_surface
        anchors.centerIn: parent
        
        scale: quoteIcon.scaleFactor
        
        Behavior on scale {
            NumberAnimation { duration: 200; easing.type: Easing.OutBack }
        }
        Behavior on color {
            ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: {
                quoteIcon.scaleFactor = 1.2
                quoteIcon.isHovered = true
                quoteIcon.togglePopup(true)
            }
            onExited: {
                quoteIcon.scaleFactor = 1.0
                quoteIcon.isHovered = false
            }
        }
    }
}