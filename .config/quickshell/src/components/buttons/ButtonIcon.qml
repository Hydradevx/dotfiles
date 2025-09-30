import QtQuick
import "../../globals/state" as GlobalState

Rectangle {
    id: iconButton
    width: 40
    height: 40
    radius: 8
    
    property string icon: "?"
    property string tooltip: ""
    property bool isPrimary: false
    property bool enabled: true
    
    signal clicked()
    
    color: {
        if (!enabled) return GlobalState.Colors.surface_variant
        return mouseArea.containsMouse ? 
            (isPrimary ? GlobalState.Colors.primary_container : GlobalState.Colors.surface_container) : 
            (isPrimary ? GlobalState.Colors.primary : GlobalState.Colors.surface_variant)
    }
    
    border.color: isPrimary ? GlobalState.Colors.primary : GlobalState.Colors.outline
    border.width: 2

    Text {
        anchors.centerIn: parent
        text: iconButton.icon
        font.pixelSize: 18
        font.family: "JetBrainsMono Nerd Font"
        color: isPrimary ? GlobalState.Colors.on_primary : GlobalState.Colors.on_surface_variant
        opacity: iconButton.enabled ? 1.0 : 0.5
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        enabled: iconButton.enabled
        onClicked: iconButton.clicked()
    }
}