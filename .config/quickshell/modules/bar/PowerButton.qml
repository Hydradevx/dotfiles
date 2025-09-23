import QtQuick
import "../public" as Theme
import Quickshell.Io

Text {
    id: powerBtn
    text: ""
    font.pixelSize: 24
    font.family: "JetBrainsMono Nerd Font"
    color: isActive ? Theme.Colors.primary : Theme.Colors.on_surface
    anchors.verticalCenter: parent.verticalCenter
    rightPadding: 10

    property real scaleFactor: 1.0
    property bool isActive: false

    scale: scaleFactor

    Behavior on scale {
        NumberAnimation { duration: 200; easing.type: Easing.OutBack }
    }
    Behavior on color {
        ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            powerBtn.isActive = !powerBtn.isActive
            powerBtn.scaleFactor = powerBtn.isActive ? 1.2 : 1.0
            logoutPanel.visible = !logoutPanel.visible
        }

        onEntered: {
            if (!powerBtn.isActive) {
                powerBtn.scaleFactor = 1.1
            }
        }
        onExited: {
            if (!powerBtn.isActive) {
                powerBtn.scaleFactor = 1.0
            }
        }
    }
}