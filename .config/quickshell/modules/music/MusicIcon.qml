import QtQuick
import Quickshell
import "../public" as Theme

Item {
    id: musicIcon
    width: 24
    height: 24

    signal togglePopup(bool visible)

    property real scaleFactor: 1.0
    property real rotationAngle: 0
    property bool isHovered: false

    Text {
        id: iconText
        text: "󰎆" 
        font.pixelSize: 28
        font.family: "JetBrainsMono Nerd Font"
        color: isHovered ? Theme.Colors.primary : Theme.Colors.on_surface
        anchors.centerIn: parent
        
        scale: musicIcon.scaleFactor
        rotation: musicIcon.rotationAngle
        
        Behavior on scale {
            NumberAnimation { duration: 200; easing.type: Easing.OutBack }
        }
        Behavior on rotation {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }
        Behavior on color {
            ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: {
                musicIcon.scaleFactor = 1.2
                musicIcon.rotationAngle = 15
                musicIcon.isHovered = true
                musicIcon.togglePopup(true)
            }
            onExited: {
                musicIcon.scaleFactor = 1.0
                musicIcon.rotationAngle = 0
                musicIcon.isHovered = false
            }
        }
    }
}