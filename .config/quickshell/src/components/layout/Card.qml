import QtQuick
import "../../globals/state" as GlobalState

Rectangle {
    id: card
    property bool hovered: false
    property alias hoverEnabled: mouseArea.hoverEnabled
    
    signal clicked()
    
    radius: GlobalState.ThemeManager.radiusLarge
    border.color: GlobalState.ThemeManager.outline
    border.width: 1
    
    scale: hovered ? 1.05 : 1.0
    
    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on scale { NumberAnimation { duration: 100 } }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onContainsMouseChanged: card.hovered = containsMouse
        onClicked: card.clicked()
    }
}