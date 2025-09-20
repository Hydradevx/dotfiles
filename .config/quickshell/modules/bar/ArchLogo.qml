import QtQuick
import "../public" as Theme
import Quickshell.Io

Text {
    id: archLogo
    text: ""
    font.pixelSize: 30
    font.family: "JetBrainsMono Nerd Font"
    color: Theme.Colors.on_surface
    anchors.verticalCenter: parent.verticalCenter
    leftPadding: 10

    Process {
        id: rofiProcess
        command: ["rofi", "-show", "drun"]
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: rofiProcess.running = true
    }
}