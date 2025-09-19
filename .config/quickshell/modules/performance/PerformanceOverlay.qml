import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "../public/"

Item {
    id: perfOverlay
    visible: Opener.perfOpenerOpen
    implicitWidth: 480
    height: Opener.perfOpenerOpen ? 200 : 0
    anchors.centerIn: parent

    Rectangle {
        anchors.fill: parent
        color: "#1e1e2e"
        border.color: "#89b4fa"
        border.width: 2
        radius: 10

        Column {
            anchors.centerIn: parent
            spacing: 8
            Text {
                text: "CPU: 12%"
                color: "#a6e3a1"
            }
            Text {
                text: "RAM: 2.4 GB"
                color: "#f9e2af"
            }
            Text {
                text: "Net: 20 Mbps"
                color: "#89dceb"
            }
        }
    }
}
