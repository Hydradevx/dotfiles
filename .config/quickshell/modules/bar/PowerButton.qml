import QtQuick
import "../public" as Theme
import Quickshell.Io

Text {
    id: powerBtn
    text: ""
    font.pixelSize: 24
    font.family: "JetBrainsMono Nerd Font"
    color: Theme.Colors.on_surface
    anchors.verticalCenter: parent.verticalCenter
    rightPadding: 10

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', powerBtn)
            proc.command = ["wlogout"]
            proc.running = true
        }
    }
}