import QtQuick
import "../../globals/state" as GlobalState

Item {
    id: animatedIcon
    width: 24
    height: 24
    
    property string icon: "?"
    property real iconSize: 28
    property real scaleFactor: 1.0
    property real rotationAngle: 0
    property bool isHovered: false
    property color normalColor: GlobalState.Colors.on_surface
    property color hoverColor: GlobalState.Colors.primary
    
    signal clicked()
    signal hovered(bool hovered)
    
    Text {
        id: iconText
        text: animatedIcon.icon
        font.pixelSize: animatedIcon.iconSize
        font.family: "JetBrainsMono Nerd Font"
        color: animatedIcon.isHovered ? animatedIcon.hoverColor : animatedIcon.normalColor
        anchors.centerIn: parent
        
        scale: animatedIcon.scaleFactor
        rotation: animatedIcon.rotationAngle
        
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
                animatedIcon.scaleFactor = 1.2
                animatedIcon.rotationAngle = 15
                animatedIcon.isHovered = true
                animatedIcon.hovered(true)
            }
            
            onExited: {
                animatedIcon.scaleFactor = 1.0
                animatedIcon.rotationAngle = 0
                animatedIcon.isHovered = false
                animatedIcon.hovered(false)
            }
            
            onClicked: animatedIcon.clicked()
        }
    }
}