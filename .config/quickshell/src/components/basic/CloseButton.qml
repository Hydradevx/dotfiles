import QtQuick
import "../../globals/state" as GlobalState

Rectangle {
    id: closeButton
    width: 32
    height: 32
    radius: GlobalState.ThemeManager.radiusSmall
    
    property bool hovered: false
    
    signal clicked()
    
    color: hovered ? GlobalState.Colors.error_container : "transparent"
    
    Text {
        text: "×"
        font.pixelSize: 20
        font.weight: Font.Bold
        color: hovered ? GlobalState.Colors.on_error_container : GlobalState.Colors.on_surface_variant
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onContainsMouseChanged: closeButton.hovered = containsMouse
        onClicked: closeButton.clicked()
    }
}