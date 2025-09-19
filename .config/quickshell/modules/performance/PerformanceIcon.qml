import QtQuick
import Quickshell
import "../public" as Theme
import "."

Text {
    id: perfIcon
    text: "" // Nerd font chip icon
    font.pixelSize: 20
    font.family: "JetBrainsMono Nerd Font"
    color: Theme.Colors.on_surface
    anchors.verticalCenter: parent.verticalCenter
    rightPadding: 10

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: perfPopup.visible = !perfPopup.visible
    }

    PerformancePopup {
        id: perfPopup
        visible: false
        anchors.top: perfIcon.bottom
        anchors.right: perfIcon.right
    }
}