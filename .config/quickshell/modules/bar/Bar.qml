import QtQuick
import Quickshell
import "../public" as Theme

PanelWindow {
    id: bar
    implicitHeight: 32
    screen: Quickshell.screens[0]
    color: Theme.Colors.surface   

    anchors {
        top: true
        left: true
        right: true
    }

    Clock {
        anchors.centerIn: parent
    }
}