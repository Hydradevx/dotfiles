import QtQuick
import "../globals/state" as GlobalState

Rectangle {
    id: overlay
    property bool shown: false
    property real opacityWhenShown: 0.4
    
    color: "#000000"
    opacity: shown ? opacityWhenShown : 0
    
    Behavior on opacity { NumberAnimation { duration: 200 } }
    
    signal clicked()
    
    MouseArea {
        anchors.fill: parent
        onClicked: overlay.clicked()
    }
}