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

    ArchLogo {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    Clock {
        anchors.centerIn: parent
    }

    PowerButton {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}