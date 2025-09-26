import QtQuick
import "../../globals/state" as GlobalState
import QtQuick.Layouts

Rectangle {
    id: profileButton
    Layout.fillWidth: true
    Layout.preferredHeight: 40
    radius: 8
    
    property string profile: ""
    property string icon: "?"
    property string tooltip: ""
    property bool isSelected: false
    
    signal clicked()
    
    color: profileButton.isSelected ? GlobalState.Colors.primary : GlobalState.Colors.surface_variant
    border.color: profileButton.isSelected ? GlobalState.Colors.primary : GlobalState.Colors.outline
    border.width: 2

    RowLayout {
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: profileButton.icon
            font.pixelSize: 16
            font.family: "JetBrainsMono Nerd Font"
            color: profileButton.isSelected ? GlobalState.Colors.on_primary : GlobalState.Colors.on_surface_variant
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: profileButton.clicked()
    }
}