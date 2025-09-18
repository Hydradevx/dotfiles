import QtQuick
import Quickshell
import "../public/Colors.qml" as Colors

PanelWindow {
    id: bar
    height: 32
    screen: Quickshell.screens[0]   
    color: Colors.surface

    anchors {
        top: true
        left: true
        right: true
    }

    Text {
        id: clock
        anchors.centerIn: parent
        color: Colors.on_surface
        font.pixelSize: 14
        text: Qt.formatDateTime(new Date(), "HH:mm:ss")

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm:ss")
        }
    }
}